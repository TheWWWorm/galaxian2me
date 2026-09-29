extends RefCounted
## Read-only observer: ordinary steering and firing, never world edits.
const Combat := preload("res://tests/support/combat_pilot.gd")
const Transit := preload("res://tests/support/transit_pilot.gd")
var combat := Combat.new()
var navigation := Transit.new()
var mode := ""
var desired := Vector3.ZERO
var evading := false

func input(space) -> Dictionary:
	if not space.player.alive or space.portal_arriving(): return {}
	if not space.in_void: return navigation.input(space, space.station)
	var story = space.story
	if story == null or story.failed or story.controls_locked: return {}
	if story.step == 42:
		mode = "escape"
		desired = clear_mothership_course(space, evasive_point(space, space.wormhole.pos, true))
		var aligned: bool = space.player.forward().dot(space.player.pos.direction_to(desired)) > 0.8
		var controls: Dictionary = navigation.steer(space, desired, aligned, false)
		controls.fire = navigation.clear_primary(space, 25000.0)
		return controls
	if story.step != 41 or story.cast.is_empty(): return {}
	var guide = story.cast[0]
	combat.protected_allies = [guide]
	# This is an escort, not an extermination objective: remote fighters
	# regenerate. Defend an observed attack on the guide, otherwise remain
	# near the convoy and prepare a below-hull approach before delivery.
	# All threats, projectiles, health and booster timers remain native.
	var priority = combat.protection_priority(space, space.hostiles())
	var controls := {}
	if priority != null:
		controls = combat.input(space, [priority])
		mode = "protect_guide_" + combat.mode
		desired = combat.desired
	else:
		mode = "escort_position" if guide.pos.z < -80000.0 else "stage_escape"
		var centre: Vector3 = guide.pos + Vector3(25000, -45000, -15000)
		if guide.pos.z >= -80000.0: centre = Vector3(25000, -55000, -22000)
		desired = loiter_point(space.player.pos, centre)
		desired = evasive_point(space, desired)
		var aligned: bool = space.player.forward().dot(space.player.pos.direction_to(desired)) > 0.9
		controls = navigation.steer(space, desired, aligned and (evading or space.player.pos.distance_to(centre) > 35000), false)
		controls.fire = navigation.clear_primary(space, 30000.0) and combat.friendly_corridor_clear(space)
	var clear := clear_mothership_course(space, desired)
	if clear != desired:
		mode = "mothership_bypass"
		desired = clear
		var bypass: Dictionary = navigation.steer(space, clear, false, false)
		bypass.fire = bool(controls.get("fire", false))
		controls = bypass
	# Before delivery acknowledgement, the source exit is fatal. Do not
	# boost towards it, and turn away before crossing the hard boundary.
	var radial: Vector3 = space.player.pos - space.wormhole.pos
	if radial.length() < 90000 and space.player.forward().dot(radial.normalized()) < 0:
		controls.boost = false
	if radial.length() < 30000:
		mode = "avoid_premature_exit"
		controls = navigation.steer(space, space.player.pos + radial.normalized() * 40000, false, false)
	return controls

func loiter_point(origin: Vector3, centre: Vector3) -> Vector3:
	# A moving ship cannot hold a point. Follow a roomy tangent instead of
	# continually overshooting and reversing across the delivery approach.
	var radial := origin - centre
	radial.y = 0
	if radial.length() < 1.0: radial = Vector3.RIGHT
	radial = radial.normalized()
	var tangent := Vector3(-radial.z, 0, radial.x)
	return centre + radial * 16000.0 + tangent * 12000.0

func evasive_point(space, goal: Vector3, precise_arrival := false) -> Vector3:
	evading = false
	var origin: Vector3 = space.player.pos
	var gap := origin.distance_to(goal)
	# Only the physical portal needs a precise final intercept. A loiter
	# waypoint is deliberately near the ship; it must not disable evasion.
	if precise_arrival and gap < 12000.0: return goal
	var threatened := false
	for enemy in space.hostiles():
		if not enemy.visible or enemy.disabled or enemy.weapons.is_empty(): continue
		var to: Vector3 = origin - enemy.pos
		if enemy.ai.get("target") == space.player and to.length() < 38000.0 \
			and enemy.forward().dot(to.normalized()) > 0.85:
			threatened = true
			break
	if not threatened: return goal
	evading = true
	# A modest weaving heading breaks a steady firing lane while retaining
	# forward progress. It is ordinary steering, not projectile deflection.
	var forward := origin.direction_to(goal)
	var side := forward.cross(Vector3.UP).normalized()
	if side.is_zero_approx(): side = Vector3.RIGHT
	var vertical := forward.cross(side).normalized()
	var phase := float(space.clock) / 1000.0 * 1.4
	return origin + forward * minf(gap, 18000.0) \
		+ (side * sin(phase) + vertical * cos(phase)) * 9000.0

func clear_mothership_course(space, target: Vector3) -> Vector3:
	if space.mothership == null: return target
	var centre: Vector3 = space.mothership.pos + space.mothership.ai.centre
	var half: Vector3 = space.mothership.ai.half + Vector3.ONE * 3000
	if AABB(centre - half, half * 2).intersects_segment(space.player.pos, target) == null: return target
	# The delivered exit lies below the hull. First clear that whole face,
	# then follow the direct portal course on a subsequent ordinary frame.
	return Vector3(space.player.pos.x, centre.y - half.y - 10000, space.player.pos.z)
