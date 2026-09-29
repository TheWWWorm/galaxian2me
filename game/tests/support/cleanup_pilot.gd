extends RefCounted
## Read-only input policy for the actual junk-removal scene. It never writes
## bodies, objectives, clocks, RNG, loadouts or outcomes.
const Body := preload("res://src/flight/body.gd")
const Transit := preload("res://tests/support/transit_pilot.gd")
var navigation := Transit.new()
var target: WeakRef
var mode := ""

func input(space) -> Dictionary:
	mode = "waiting"
	if space.story == null or not space.player.alive or space.story.controls_locked: return {}
	if space.docking >= 0 or space.jumping >= 0 or space.travelling >= 0: return {}
	if space.story.complete or space.story.failed: return navigation.input(space, space.station)
	var junk: Body = target.get_ref() if target != null else null
	if junk == null or not junk.alive or not junk.visible:
		junk = null
		var best := INF
		for actor in space.story.cast:
			if not actor.alive or not actor.visible or not actor.is_junk(): continue
			var direction: Vector3 = actor.pos - space.player.pos
			var score: float = direction.length() / 2000.0 + space.player.forward().angle_to(direction) * 3.0
			if score < best: best = score; junk = actor
		target = weakref(junk) if junk != null else null
	if junk == null: return {}
	if space.entry_mode.is_empty() and space.clock < 8000:
		mode = "clear_hangar"
		return navigation.input(space, junk)
	mode = "clear_junk"
	var gap: float = space.player.pos.distance_to(junk.pos)
	var controls := navigation.steer(space, junk.pos, gap > 25000.0, false)
	# Fire only along the real projectile sweep, not merely because a target
	# was selected. Another junk crossing the sight is equally valid.
	if not space.player.weapons.is_empty():
		var weapon: Dictionary = space.player.weapons[0]
		var reach: float = (float(weapon.speed) + space.player.speed) * float(weapon.life)
		var forward: Vector3 = space.player.forward()
		var hit = space._sweep({"owner": space.player, "pos": space.player.pos + forward * 400.0},
			forward * minf(reach, gap + 2000.0))
		controls.fire = hit != null and hit.is_ship() and hit.hostile and not hit.friendly
	return controls
