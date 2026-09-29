extends RefCounted
## Observes a fight and returns only ordinary player controls. All recovery,
## movement, shots, damage and scores remain the native simulation's work.
const Body := preload("res://src/flight/body.gd")
const Transit := preload("res://tests/support/transit_pilot.gd")
const Withdrawal := preload("res://tests/support/withdrawal_course.gd")
const PrimaryCorridor := preload("res://tests/support/primary_corridor.gd")
var navigation := Transit.new()
var opponent: WeakRef
var mode := "attack"
var recovery_started := -1
var pass_until := -1
var gap := 0.0
var desired := Vector3.ZERO
var escape_direction := Vector3.ZERO
var flank_offset := Vector3.ZERO
var flank_target: WeakRef
var flank_replan := -1
var flank_feasible := false
var blocked_candidates: Array = []
## Optional mission allies observed by a rescue/escort test, never world edits.
var protected_allies: Array = []

func input(space, candidates: Array) -> Dictionary:
	if not space.player.alive or space.docking >= 0 or space.jumping >= 0 or space.travelling >= 0:
		return {}
	if space.portal_arriving() or (space.story != null and space.story.controls_locked): return {}
	if space.player.weapons.is_empty(): return {}
	var origin: Vector3 = space.player.pos
	var enemy: Body = opponent.get_ref() if opponent != null else null
	var nearest: Body
	var available: Array = []
	var preferred: Body
	blocked_candidates.clear()
	for b in candidates:
		if not b.alive or not b.visible or b.friendly or not b.hostile or not b.is_ship(): continue
		if nearest == null or b.pos.distance_to(origin) < nearest.pos.distance_to(origin): nearest = b
		if engagement_available(space, b):
			available.append(b)
			if preferred == null or b.pos.distance_to(origin) < preferred.pos.distance_to(origin): preferred = b
		else:
			blocked_candidates.append(b)
	if nearest == null:
		mode = "settling"
		return {}
	# Nearest-target hysteresis must not retain an opponent for which no
	# safe firing pose exists. Keep observing blocked opponents; separation
	# from the friendly may make them feasible on a later native frame.
	if preferred == null: preferred = nearest
	if enemy == null or not enemy.alive or enemy.friendly or not enemy.hostile or not enemy.visible or not candidates.has(enemy) or (not available.is_empty() and not available.has(enemy)) or enemy.pos.distance_to(origin) > maxf(60000.0, preferred.pos.distance_to(origin) * 1.5):
		enemy = preferred
		opponent = weakref(enemy)
	var shield_fraction: float = space.player.shield / maxf(1.0, space.player.shield_max)
	# Escort/rescue allies cannot follow a long shield-recovery orbit. React
	# only to an observed active gun targeting a living protected ally; a
	# harmless nearby friendly does not change ordinary combat policy.
	var protecting: bool = protection_priority(space, candidates) != null
	var priority: Body = protection_priority(space, available)
	if priority != null and (not attacks_protected_ally(enemy) or enemy.pos.distance_to(origin) > maxf(40000.0, priority.pos.distance_to(origin) * 1.5)):
		enemy = priority
		opponent = weakref(enemy)
	var recovery_threshold := 0.2 if protecting else 0.65
	var recovered_threshold := 0.55 if protecting else 0.97
	if protecting and recovery_started >= 0 and shield_fraction >= recovered_threshold and space.clock - recovery_started >= 4000:
		recovery_started = -1
	var have_emp := false
	for w in space.player.weapons:
		if w.kind == "missile" and int(w.get("emp", 0)) > 0 and int(w.count) > 0: have_emp = true
	var suppression := false
	# Reserve the fitted booster for the last approach, then suppress active
	# guns with real finite EMP launches. Do not keep firing EMP at one
	# disabled pirate while its neighbours continue shooting.
	# Once a withdrawal starts, ammunition must not cancel its recovery
	# hysteresis. Start a new suppression pass with a useful shield reserve.
	if have_emp and recovery_started < 0 and shield_fraction > (recovery_threshold if protecting else 0.1) and (mode == "suppress" or shield_fraction >= (0.35 if protecting else 0.65)):
		var threat: Body
		var best := INF
		for b in available:
			if not b.alive or not b.visible or not b.hostile or b.friendly or b.disabled or missile_in_flight(space, b): continue
			var to: Vector3 = b.pos - origin
			if to.length() > 32000.0: continue
			var score: float = to.length() * (2.0 - to.normalized().dot(space.player.forward()))
			if b == priority: score *= 0.25
			if score < best:
				best = score
				threat = b
		if threat != null:
			enemy = threat
			opponent = weakref(enemy)
			suppression = true
	gap = origin.distance_to(enemy.pos)
	var threatened := false
	for b in space.bodies:
		if b != space.player and b.is_ship() and b.alive and b.visible and b.hostile and not b.disabled and b.pos.distance_to(origin) < 40000.0:
			threatened = true
	if not suppression and recovery_started < 0 and threatened and space.player.shield_max > 0 and shield_fraction < recovery_threshold:
		recovery_started = space.clock
	if recovery_started >= 0 and (not threatened or (shield_fraction >= recovered_threshold and space.clock - recovery_started >= 4000)):
		recovery_started = -1
	if gap < (3500.0 if enemy.disabled else 5500.0) and origin.direction_to(enemy.pos).dot(space.player.forward()) > 0.3:
		pass_until = space.clock + 3500
	if recovery_started >= 0 or space.clock < pass_until:
		mode = "recover" if recovery_started >= 0 else "break_pass"
		desired = origin + withdrawal_course(space, nearest) * 30000.0
		var retreat: Dictionary = navigation.steer(space, desired, true, false)
		retreat.fire = navigation.clear_primary(space, gap) and friendly_corridor_clear(space)
		arm_secondary(space, retreat, candidates)
		return retreat
	mode = "suppress" if suppression else "attack"
	var gun: Dictionary = space.player.weapons[0]
	var speed: float = float(gun.speed) + space.player.speed
	var reach: float = speed * float(gun.life)
	desired = enemy.pos
	if gap < reach: desired += enemy.forward() * enemy.speed * (0.2 if enemy.disabled else 1.0) * gap / maxf(1.0, speed)
	# Withholding an unsafe shot is not enough: continuously pursuing the
	# same blocked lane can leave the player circling helplessly beside an
	# ally. Fly to a different firing angle using ordinary stick input.
	if gap < 60000.0 and not friendly_corridor_clear_at(space, origin, Body.facing(desired - origin)):
		mode = "reposition"
		desired = flanking_point(space, enemy)
		var reposition: Dictionary = navigation.steer(space, desired,
			origin.direction_to(desired).dot(space.player.forward()) > 0.7, false)
		reposition.fire = navigation.clear_primary(space, gap) and friendly_corridor_clear(space)
		arm_secondary(space, reposition, candidates)
		return reposition
	var boost: bool = gap > 85000.0 or suppression
	if protecting:
		# Close the response distance without boosting through a tight pass.
		boost = gap > 14000.0 and origin.direction_to(desired).dot(space.player.forward()) > 0.85
	var controls: Dictionary = navigation.steer(space, desired, boost, false)
	# Lead shots may correctly miss the target's CURRENT box; judge the
	# ordinary moving-target aim point while still respecting obstructions.
	var relative: Vector3 = desired - origin
	var along: float = relative.dot(space.player.forward())
	var miss: Vector3 = relative - space.player.forward() * along
	var blocker = space._sweep({"owner": space.player, "pos": origin + space.player.forward() * 400.0}, space.player.forward() * maxf(0.0, along))
	var clear: bool = blocker == null or (blocker.is_ship() and blocker.hostile and not blocker.friendly)
	controls.fire = along > 0 and along < reach and maxf(absf(miss.x), maxf(absf(miss.y), absf(miss.z))) < enemy.radius * 0.8 and clear and friendly_corridor_clear(space)
	if gap < 32000.0 and relative.normalized().dot(space.player.forward()) > 0.99 and space.target != enemy:
		controls.next_target = true
	arm_secondary(space, controls, candidates)
	return controls

func arm_secondary(space, controls: Dictionary, candidates: Array) -> void:
	var target: Body = space.target
	if target == null or not candidates.has(target) or not target.alive or not target.hostile or target.friendly or target.disabled: return
	var relative: Vector3 = target.pos - space.player.pos
	if relative.normalized().dot(space.player.forward()) < 0.99: return
	if not friendly_corridor_clear(space): return
	if missile_in_flight(space, target): return
	for w in space.player.weapons:
		if w.kind == "missile" and int(w.get("emp", 0)) > 0 and int(w.count) > 0 and int(w.cooldown) == 0:
			var closing: float = float(w.speed) + space.player.speed - target.forward().dot(relative.normalized()) * target.speed
			if relative.length() > closing * float(w.life) * 0.9: continue
			if not secondary_path_clear(space, target, w): continue
			controls.secondary = true
			return

func secondary_path_clear(space, target: Body, weapon: Dictionary) -> bool:
	# The lock is not necessarily the first physical recipient. Inspect the
	# current native launch-offset lane before spending finite ammunition.
	# This is a conservative current-pose check, not a promise about future
	# NPC turns. Primary fire may still clear a disabled hostile interceptor.
	var position: Vector3 = space.player.pos + space.player.basis * weapon.get("offset", Vector3.ZERO) + space.player.forward() * 400.0
	var first: Body = space._sweep({"owner": space.player, "pos": position}, target.pos - position)
	if first == null or first == target: return true
	return first.is_ship() and first.hostile and not first.friendly and not first.disabled and not missile_in_flight(space, first)

func attacks_protected_ally(body: Body) -> bool:
	if body == null or not body.alive or not body.visible or not body.combat_active or body.disabled or body.friendly or not body.hostile: return false
	if body.weapons.is_empty(): return false
	var victim: Body = body.ai.get("target")
	return victim != null and protected_allies.has(victim) and victim.alive and victim.friendly and body.pos.distance_to(victim.pos) < 50000.0

func protection_priority(space, candidates: Array) -> Body:
	var chosen: Body
	var best := INF
	for body in candidates:
		if not attacks_protected_ally(body): continue
		var victim: Body = body.ai.target
		var reserve: float = float(victim.hull) / maxf(1.0, victim.hull_max)
		var relative: Vector3 = body.pos - space.player.pos
		var score: float = relative.length() * (2.0 - relative.normalized().dot(space.player.forward())) * (0.25 + reserve)
		if score < best:
			chosen = body
			best = score
	return chosen

func missile_in_flight(space, body: Body) -> bool:
	for p in space.projectiles:
		if p.owner == space.player and p.target == body and p.weapon.kind == "missile": return true
	return false

func friendly_corridor_clear(space) -> bool:
	return friendly_corridor_clear_at(space, space.player.pos, space.player.basis)

func friendly_corridor_clear_at(space, position: Vector3, orientation: Basis) -> bool:
	# Keep the existing combat/flanking API and friendly-only geometry;
	# transit additionally protects neutral traffic through the same helper.
	return PrimaryCorridor.clear_at(space, position, orientation)

func flanking_point(space, enemy: Body) -> Vector3:
	# Candidate poses are geometric queries only. They never replace the
	# player's actual pose, target, projectiles or the simulation's RNG.
	var origin: Vector3 = space.player.pos
	var same: bool = flank_target != null and flank_target.get_ref() == enemy
	if same and space.clock < flank_replan:
		return enemy.pos + flank_offset
	var chosen := find_flank_offset(space, enemy, flank_offset if same else Vector3.ZERO)
	flank_feasible = not chosen.is_zero_approx()
	flank_offset = chosen if flank_feasible else enemy.pos.direction_to(origin) * 30000.0
	flank_target = weakref(enemy)
	flank_replan = space.clock + 250
	return enemy.pos + flank_offset

func engagement_available(space, enemy: Body) -> bool:
	var origin: Vector3 = space.player.pos
	var gun: Dictionary = space.player.weapons[0]
	var reach: float = (float(gun.speed) + space.player.speed) * float(gun.life)
	# A harmless shot that expires before either distant ship is not a
	# firing opportunity. Otherwise approaching the same blocked cluster
	# toggles feasibility at the gun-lifetime boundary and reverses course.
	if origin.distance_to(enemy.pos) < reach and friendly_corridor_clear_at(space, origin, Body.facing(enemy.pos - origin)): return true
	return not find_flank_offset(space, enemy).is_zero_approx()

func find_flank_offset(space, enemy: Body, previous := Vector3.ZERO) -> Vector3:
	# A single standoff sphere can be entirely covered by the friendly's
	# reachable envelope while a closer firing pose is still safe. Prefer
	# the roomy pass, but search nearer passes before declaring no lane.
	for standoff in [18000.0, 12000.0, 8000.0]:
		var chosen := flank_at_range(space, enemy, previous, standoff)
		if not chosen.is_zero_approx(): return chosen
	return Vector3.ZERO

func flank_at_range(space, enemy: Body, previous: Vector3, standoff: float) -> Vector3:
	# A zero result explicitly means no feasible pose. The 30k navigation
	# fallback must never masquerade as proof of a safe firing opportunity.
	var origin: Vector3 = space.player.pos
	var offsets: Array = []
	if not previous.is_zero_approx(): offsets.append(previous.normalized() * standoff)
	var away: Vector3 = enemy.pos.direction_to(origin)
	offsets.append(away * standoff)
	for index in 48:
		var height := 1.0 - 2.0 * (float(index) + 0.5) / 48.0
		var phase := float(index) * PI * (3.0 - sqrt(5.0))
		var radius := sqrt(1.0 - height * height)
		offsets.append(Vector3(cos(phase) * radius, height, sin(phase) * radius) * standoff)
	var best := INF
	var chosen := Vector3.ZERO
	for offset in offsets:
		var at: Vector3 = enemy.pos + offset
		if at.length() > 420000.0: continue
		if space._inside_station(at, 8000.0): continue
		if not friendly_corridor_clear_at(space, at, Body.facing(-offset)): continue
		var cost: float = origin.distance_to(at)
		if not previous.is_zero_approx():
			cost += (1.0 - offset.normalized().dot(previous.normalized())) * 6000.0
		if cost < best:
			best = cost
			chosen = offset
	return chosen

func withdrawal_course(space, nearest: Body) -> Vector3:
	escape_direction = Withdrawal.choose(space, nearest, escape_direction)
	return escape_direction
