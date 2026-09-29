extends RefCounted
## Read-only flight observer returning ordinary player input. It never steps
## the simulation, consumes RNG, changes a target, or writes a body/session.
const Body := preload("res://src/flight/body.gd")
const Withdrawal := preload("res://tests/support/withdrawal_course.gd")
const PrimaryCorridor := preload("res://tests/support/primary_corridor.gd")
var opponent: WeakRef
var docking_goal: WeakRef
var recovery_started := -1
var escape_direction := Vector3.ZERO
var escape_replan := -1
var counterattack_target: WeakRef
var launch_axis := Vector3.ZERO
var departure_goal: WeakRef
var mode := ""
var avoided := false
var steering_point := Vector3.ZERO

func input(space, goal: Body) -> Dictionary:
	mode = "locked"
	avoided = false
	if goal == null or not space.player.alive or space.docking >= 0 or space.jumping >= 0 or space.travelling >= 0:
		return {}
	if space.portal_arriving() or (space.story != null and space.story.controls_locked): return {}
	var origin: Vector3 = space.player.pos
	var departing: bool = goal != space.station
	# _place_player() supplies this outward hangar pose. build() clears
	# arrival_mode before controls run, so recognise only the early actual
	# launch pose, never an arbitrary arrival or a later near-station pass.
	if launch_axis.is_zero_approx() and space.clock < 1000 \
		and origin.distance_to(Vector3(10, 10, 10000)) < 2500.0 \
		and space.player.forward().dot(Vector3.BACK) > 0.99:
		launch_axis = space.player.forward()
	# A Target press can select the station and dock in the very same tick.
	# Leave the hangar before targeting or turning back towards an attacker.
	if departing and space.clock < 8000:
		mode = "clear_hangar"
		if not launch_axis.is_zero_approx():
			if goal.kind in [Body.Kind.GATE, Body.Kind.STAR] and space.player.shield_max > 0 \
				and space.player.shield >= space.player.shield_max * 0.8:
				departure_goal = weakref(goal)
			# Do not steer below the whole assembly to "avoid" its own
			# launch aperture. Native module bounce remains active, large
			# asteroids remain checked, and no station Target is pressed.
			return steer(space, origin + launch_axis * 30000.0, true, true)
		return steer(space, origin + space.player.forward() * 30000.0, true, false)
	var at: Vector3 = origin + space._star_direction(goal) * 100000.0 if goal.kind == Body.Kind.STAR else goal.pos
	var distance: float = origin.distance_to(at)
	# Near the actual gate, completing ordinary targeting and physical
	# entry is safer than abandoning the exit to recover shields. Keep
	# native collisions, incoming damage and obstacle steering active.
	var final_gate: bool = goal.kind == Body.Kind.GATE and distance < 18000.0 \
		and not space._inside_station(origin, 8000.0)
	# A healthy arriving ship can finish its station approach without hunting
	# every armed traffic ship. Otherwise defense's station bypass can keep
	# it orbiting the assembly forever (observed at Nehma with full shields).
	# This is only input-policy hysteresis: all damage, hazards and docking
	# remain native. Low shields, a new destination or a long detour release it.
	var shield_fraction: float = space.player.shield / maxf(1.0, space.player.shield_max)
	var leaving: bool = departure_goal != null and departure_goal.get_ref() == goal and departing \
		and space.player.shield_max > 0 and shield_fraction > 0.2 and distance < 120000.0
	if not leaving: departure_goal = null
	var approaching: bool = docking_goal != null and docking_goal.get_ref() == goal and goal == space.station \
		and space.player.shield_max > 0 and shield_fraction > 0.2 and distance < 90000.0
	if not approaching: docking_goal = null
	if goal == space.station and space.player.shield_max > 0 and shield_fraction >= 0.8 and distance < 60000.0:
		docking_goal = weakref(goal)
		approaching = true
	var enemy: Body = opponent.get_ref() if opponent != null else null
	var nearest: Body
	var armed_near := 0
	for b in space.hostiles():
		if not b.visible or b.friendly or b.disabled or b.weapons.is_empty(): continue
		if b.pos.distance_to(origin) < 45000.0: armed_near += 1
		if nearest == null or b.pos.distance_to(origin) < nearest.pos.distance_to(origin): nearest = b
	if enemy == null or not enemy.alive or enemy.disabled or enemy.friendly or not enemy.hostile or not enemy.visible or enemy.weapons.is_empty() or (nearest != null and enemy.pos.distance_to(origin) > nearest.pos.distance_to(origin) * 1.5):
		enemy = nearest
		opponent = weakref(enemy) if enemy != null else null
	var threatened: bool = enemy != null and enemy.pos.distance_to(origin) < 45000.0
	if not approaching and not leaving and not final_gate and threatened and space.player.shield_max > 0 and shield_fraction < 0.65 and recovery_started < 0:
		recovery_started = space.clock
	if recovery_started >= 0 and (approaching or leaving or final_gate or not threatened or (shield_fraction >= 0.97 and space.clock - recovery_started >= 4000)):
		recovery_started = -1
	# A close equal-speed pursuer can keep landing shots throughout every
	# shield-recovery orbit (actual Genoh D). After a real withdrawal failed
	# to open distance, turn and deal with a SINGLE armed threat instead of
	# waiting to die. Never generalise this reversal into a group of guns.
	if recovery_started < 0 or armed_near != 1:
		counterattack_target = null
	elif space.clock - recovery_started >= 4000 and enemy.pos.distance_to(origin) < 12000.0:
		counterattack_target = weakref(enemy)
	var countering: bool = counterattack_target != null and counterattack_target.get_ref() == enemy \
		and enemy.alive and enemy.pos.distance_to(origin) < 30000.0
	if recovery_started >= 0 and not countering:
		mode = "recover"
		# Fly the chosen leg rather than continually orbit a changing nearest
		# pursuer. A newly obstructed leg is rejected immediately, not after
		# the commitment interval. No native control or turn rate is bypassed.
		var course := escape_direction
		if space.clock >= escape_replan or course.is_zero_approx() or not escape_leg_clear(space, course):
			course = Withdrawal.choose(space, enemy, escape_direction, func(direction: Vector3): return escape_leg_clear(space, direction))
			escape_replan = space.clock + 3000
		if not course.is_zero_approx():
			escape_direction = course
			# The current nose also has to clear hazards: a safe eventual
			# heading alone does not make boosting through a turn safe.
			var retreat := steer(space, origin + course * 30000.0, escape_leg_clear(space, space.player.forward()), false)
			retreat.fire = clear_primary(space, origin.distance_to(enemy.pos))
			return retreat
		return steer(space, station_bypass(space), false, false)
	# Do not hunt harmless freighters. Defend against nearby armed hostiles,
	# but complete a final safe docking/gate approach rather than turn back.
	if enemy != null and enemy.pos.distance_to(origin) < 45000.0 and distance > 13000.0 and not approaching and not leaving and not final_gate:
		mode = "counterattack" if countering else "defend"
		var gun: Dictionary = space.player.weapons[0]
		var speed: float = float(gun.speed) + space.player.speed
		var gap: float = enemy.pos.distance_to(origin)
		at = enemy.pos + enemy.forward() * enemy.speed * gap / maxf(1.0, speed)
		var controls := steer(space, at, false, false)
		controls.fire = clear_primary(space, gap)
		return controls
	mode = "gate_approach" if final_gate else ("depart" if leaving else ("approach" if approaching else "transit"))
	var result := steer(space, at, distance > 15000.0, goal == space.station)
	# Let the reticle acquire the destination. Cycle only on the final gate
	# approach, outside ALL expanded station boxes, never inside the hangar.
	if final_gate:
		result.next_target = space.target != goal
	result.fire_pressed = goal.kind == Body.Kind.STAR and space.target == goal and space.locked
	result.fire = clear_primary(space, 20000.0)
	return result

func steer(space, desired: Vector3, boost: bool, allow_station: bool) -> Dictionary:
	var at := safe_point(space, desired, allow_station)
	steering_point = at
	avoided = not at.is_equal_approx(desired)
	var local: Vector3 = space.player.basis.inverse() * (at - space.player.pos).normalized()
	# atan2(y,z) produces a spurious full pitch for a level target behind.
	# Use horizontal length for elevation; choose the turn via yaw instead.
	var yaw := clampf(-atan2(local.x, local.z) * 4.0, -1.0, 1.0)
	var pitch := clampf(atan2(local.y, Vector2(local.x, local.z).length()) * 4.0, -1.0, 1.0)
	return {"yaw": yaw, "pitch": pitch, "boost": boost and not avoided,
		"autopilot": space.autopilot}

func safe_point(space, desired: Vector3, allow_station: bool) -> Vector3:
	var origin: Vector3 = space.player.pos
	var at := desired
	var direction: Vector3 = (desired - origin).normalized()
	var segment: Vector3 = origin + direction * minf(22000.0, origin.distance_to(desired))
	if not allow_station and not (mode == "recover" and escape_leg_clear(space, direction)):
		for box in space.station_boxes:
			var start: Vector3 = box.basis.inverse() * (origin - box.origin) - box.centre
			var end: Vector3 = box.basis.inverse() * (segment - box.origin) - box.centre
			var half: Vector3 = box.half + Vector3.ONE * 8000.0
			if AABB(-half, half * 2.0).intersects_segment(start, end):
				# Adjacent modules can demand opposite local vertical exits.
				# Clear the complete supplied assembly on one consistent side.
				at = station_bypass(space)
				break
	# A station bypass is itself a flight leg. Do not return it before
	# checking the large rocks on that new course (observed at Valadon).
	direction = (at - origin).normalized()
	var hazard: Body
	var best := 22000.0
	var clearance := 0.0
	for b in space.bodies:
		if not b.alive or b.kind != Body.Kind.ASTEROID or b.size <= 30: continue
		var relative: Vector3 = b.pos - origin
		var ahead := relative.dot(direction)
		var radius: float = 1500.0 * b.scale.length() / 1.7 + space.PLAYER_RADIUS + 5000.0
		if ahead > -radius and ahead < best and (relative - direction * ahead).length() < radius:
			hazard = b
			best = ahead
			clearance = radius
	if hazard != null:
		var sideways: Vector3 = origin - hazard.pos
		sideways -= direction * sideways.dot(direction)
		if sideways.length() < 100.0:
			sideways = space.player.up() - direction * space.player.up().dot(direction)
			if sideways.length() < 0.1: sideways = space.player.basis.x - direction * space.player.basis.x.dot(direction)
		return hazard.pos + sideways.normalized() * clearance * 2.0
	return at

func escape_leg_clear(space, direction: Vector3) -> bool:
	# An already-entered safety margin is not the physical station hull.
	# Permit only outward exits from that margin; still reject all actual
	# modules expanded by the player's radius and every large asteroid.
	if direction.is_zero_approx(): return false
	var origin: Vector3 = space.player.pos
	var endpoint: Vector3 = origin + direction.normalized() * 30000.0
	for box in space.station_boxes:
		var start: Vector3 = box.basis.inverse() * (origin - box.origin) - box.centre
		var end: Vector3 = box.basis.inverse() * (endpoint - box.origin) - box.centre
		var half: Vector3 = box.half + Vector3.ONE * 8000.0
		var margin := AABB(-half, half * 2.0)
		if margin.intersects_segment(start, end) == null: continue
		if not margin.has_point(start): return false
		var physical: Vector3 = box.half + Vector3.ONE * space.PLAYER_RADIUS
		if AABB(-physical, physical * 2.0).intersects_segment(start, end) != null: return false
		var fraction: Vector3 = start.abs() / half
		var axis: int = fraction.max_axis_index()
		if start[axis] * (end[axis] - start[axis]) <= 0.0 or margin.has_point(end): return false
	for b in space.bodies:
		if not b.alive or b.kind != Body.Kind.ASTEROID or b.size <= 30: continue
		var relative: Vector3 = b.pos - origin
		var ahead: float = relative.dot(direction)
		var radius: float = 1500.0 * b.scale.length() / 1.7 + space.PLAYER_RADIUS + 5000.0
		if ahead > -radius and ahead < 30000.0 and (relative - direction * ahead).length() < radius: return false
	return true

func station_bypass(space) -> Vector3:
	var origin: Vector3 = space.player.pos
	var low := INF
	var high := -INF
	for box in space.station_boxes:
		var half: Vector3 = box.half + Vector3.ONE * 8000.0
		for x in [-1, 1]:
			for y in [-1, 1]:
				for z in [-1, 1]:
					var corner: Vector3 = box.origin + box.basis * (box.centre + half * Vector3(x, y, z))
					low = minf(low, corner.y)
					high = maxf(high, corner.y)
	if not is_finite(low) or not is_finite(high): return origin
	var height := high + 12000.0 if origin.y >= (low + high) * 0.5 else low - 12000.0
	return Vector3(origin.x, height, origin.z)

func clear_primary(space, distance: float) -> bool:
	if space.player.weapons.is_empty(): return false
	# A centre-line hostile is only an aiming opportunity. Both actual
	# muzzle lanes must remain safe after it moves or dies; neutral traffic
	# is protected before an accidental hit can provoke its retaliation.
	if not PrimaryCorridor.clear_at(space, space.player.pos, space.player.basis, true): return false
	var weapon: Dictionary = space.player.weapons[0]
	var reach: float = (float(weapon.speed) + space.player.speed) * float(weapon.life)
	var forward: Vector3 = space.player.forward()
	var hit = space._sweep({"owner": space.player, "pos": space.player.pos + forward * 400.0}, forward * minf(reach, distance + 2000.0))
	return hit != null and hit.is_ship() and hit.hostile and not hit.friendly
