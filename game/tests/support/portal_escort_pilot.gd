extends RefCounted
## Ordinary controls only. A's 70k exclusion based on the ENEMY'S position
## suppressed every shot until the freighter died. Guard the player's actual
## approach instead, with an outward recovery that cannot boost into a portal.
const Transit := preload("res://tests/support/transit_pilot.gd")
const Combat := preload("res://tests/support/combat_pilot.gd")
var navigation := Transit.new()
var combat := Combat.new()
var retreating := false

func input(space) -> Dictionary:
	var story = space.story
	if story == null or story.cast.is_empty() or not space.player.alive: return {}
	var guide = story.cast[0]
	if not guide.alive: return {}
	if not guide.visible:
		return navigation.steer(space, space.wormhole.pos, false, false)
	combat.protected_allies = [guide]
	var controls: Dictionary = combat.input(space, space.hostiles())
	if space.hostiles().is_empty():
		controls = navigation.steer(space, guide.pos + Vector3(-20000, 12000, -15000), false, false)
	return guard(space, controls)

func guard(space, proposed: Dictionary) -> Dictionary:
	var radial: Vector3 = space.player.pos - space.wormhole.pos
	var distance := radial.length()
	if distance <= 0.0: return {}
	radial /= distance
	var facing_out: float = space.player.forward().dot(radial)
	# Hysteresis permits real attack passes instead of following a distant
	# moving waypoint forever. No actor or portal state is written here.
	if distance < 44000.0 and facing_out < 0.2: retreating = true
	if distance > 58000.0: retreating = false
	if retreating:
		combat.mode = "portal_retreat"
		var controls: Dictionary = navigation.steer(space, space.player.pos + radial * 40000.0, facing_out > 0.65, false)
		controls.fire = bool(proposed.get("fire", false))
		return controls
	var controls := proposed.duplicate()
	# Prevent a long incoming boost from carrying a safe firing pass through
	# the hard crossing radius before the ship can turn outward.
	if distance < 100000.0 and facing_out < 0.0: controls.boost = false
	return controls
