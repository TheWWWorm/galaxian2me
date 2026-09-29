extends RefCounted
## Paid crew is session data; its physical ships belong to one flight world.
## The supplied level builder recreates surviving names with 600 hull and
## clears expired contracts on entry. It does not save individual ship HP.
const JavaRandom := preload("res://src/simulation/java_random.gd")
const CONTRACT_MS := 600000
const SWITCH_GUN := 1
const FIRE_AT_WILL := 2
const SECURE_WAYPOINT := 3
const ATTACK_TARGET := 4

## Commands and weapon choice belong to this area, not to the saved contract.
static func living(space) -> Array:
	if space == null or space.game == null or space.completed_flight: return []
	return space.bodies.filter(func(b): return b.alive and bool(b.ai.get("wingman", false)))

static func valid_target(space, target) -> bool:
	return (target != null and target != space.player and space.bodies.has(target)
		and target.alive and target.visible and target.is_ship()
		and not bool(target.ai.get("fixed_friendly", false)) and not bool(target.ai.get("wingman", false)))

static func mission_waypoint(space):
	if space.story == null: return null
	return space.story.wingman_waypoint()

static func available(space, command: int) -> bool:
	var pilots := living(space)
	if pilots.is_empty() or space.navigation_locked(): return false
	match command:
		SWITCH_GUN: return pilots.any(func(b): return b.weapons.size() == 2)
		FIRE_AT_WILL: return true
		SECURE_WAYPOINT: return mission_waypoint(space) != null
		ATTACK_TARGET: return space.locked and valid_target(space, space.target)
	return false

static func switch_label(space) -> int:
	var pilots := living(space)
	return 150 if not pilots.is_empty() and int(pilots[0].ai.get("wingman_weapon", 0)) == 1 else 151

static func issue(space, command: int) -> bool:
	if not available(space, command): return false
	var pilots := living(space)
	var target = space.target if command == ATTACK_TARGET else null
	var waypoint = mission_waypoint(space) if command == SECURE_WAYPOINT else null
	for body in pilots:
		# cb.java's weapon switch also replaces the previous tactical order.
		body.ai.wingman_order = command
		body.ai.wingman_target = target
		body.ai.erase("wingman_waypoint")
		body.ai.target = null
		body.ai.evade = 0
		if command == SWITCH_GUN:
			body.ai.wingman_weapon = 1 - int(body.ai.wingman_weapon)
		elif command == SECURE_WAYPOINT:
			# Vector3 is a value copy: neither the player's route cursor nor
			# a later target/map change can move this accepted waypoint.
			body.ai.wingman_waypoint = waypoint
		if command in [SECURE_WAYPOINT, ATTACK_TARGET]: body.ai.timer = 5001
	space.event.emit("wingman_order", {"command": command, "weapon": int(pilots[0].ai.wingman_weapon),
		"pilots": pilots.map(func(b): return b.name), "target": target.name if target != null else "", "waypoint": waypoint})
	return true

static func focus_target(space, body):
	if int(body.ai.get("wingman_order", 2)) != ATTACK_TARGET: return null
	var target = body.ai.get("wingman_target")
	if not valid_target(space, target): return null
	var gap: Vector3 = (target.pos - body.pos).abs()
	return target if maxf(gap.x, maxf(gap.y, gap.z)) < 50000.0 else null

static func secure_goal(body):
	if int(body.ai.get("wingman_order", 2)) != SECURE_WAYPOINT: return null
	var goal = body.ai.get("wingman_waypoint")
	if goal == null: return null
	var gap: Vector3 = (goal - body.pos).abs()
	if maxf(gap.x, maxf(gap.y, gap.z)) < 2000.0:
		body.ai.erase("wingman_waypoint")
		body.ai.wingman_order = 0
		return null
	return goal

static func can_fire(space, body, weapon: Dictionary, index: int) -> bool:
	if index != int(body.ai.get("wingman_weapon", 0)): return false
	# Each of the two source guns has four independent projectile slots.
	return space.projectiles.filter(func(p): return p.owner == body and int(p.weapon.id) == int(weapon.id)).size() < 4

static func clear_roster(session) -> void:
	session.flags.erase("wingmen")
	session.flags.erase("wingmen_face")
	session.flags["wingmen_remaining_ms"] = 0

static func fighter_index(name: String, race: int, count: int) -> int:
	if race == 9: return 8 if count > 8 else -1
	if race == 1: return 9 if count > 9 else -1
	var allowed := false
	for index in count:
		if index not in [0, 8, 9, 10, 13, 14, 15]: allowed = true; break
	if not allowed: return -1
	# ed.java chooses the hull BEFORE resetting its RNG to wall time.
	# Java's length counts UTF-16 code units, not Unicode code points.
	var random := JavaRandom.new(int(name.to_utf16_buffer().size() / 2) * 5)
	while true:
		var index := random.next_int(count)
		if index not in [0, 8, 9, 10, 13, 14, 15]: return index
	return -1

static func spawn(space) -> void:
	var session = space.game.session
	var names: Array = session.flags.get("wingmen", [])
	if names.is_empty(): return
	# Old engine versions stored names without a timer. They must not gain
	# an invented fresh contract simply by opening a save in this version.
	if int(session.flags.get("wingmen_remaining_ms", 0)) <= 0:
		clear_roster(session)
		return
	var race := int(session.flags.get("wingmen_race", 0))
	var unarmed := space.story != null and int(space.story.job.get("kind", -1)) == 12
	for i in names.size():
		var index := fighter_index(str(names[i]), race, space.cat.ship_count())
		if index < 0 or not space.lib.data.ship_parts.has(str(index)):
			push_error("The supplied content has no supported fighter for this hired pilot.")
			continue
		# The source creates a type-five fighter, then sets the crew's race.
		var body = space._spawn_ship(5, space.player.pos, false)
		body.ship_index = index
		body.name = str(names[i])
		body.faction = race
		body.hull = 600; body.hull_max = 600
		body.friendly = true; body.hostile = false
		body.basis = space.player.basis
		if space.entry_mode in ["jump", "travel", "drive"] and space.arrival != null:
			body.pos = space.arrival.pos + Vector3(-3000, 1000, 5000)
		else:
			body.pos = space.player.pos + Vector3(space.rng.randi_range(-700, 699), space.rng.randi_range(-700, 699), 2000)
		var offset := Vector3(-2048 if i == 0 else 2048, 0, 4096) if i < 2 else Vector3(0, 0, -4096)
		body.ai = {"wingman": true, "roster_index": i, "fixed_friendly": true,
			"mode": "escort", "escort_offset": offset, "timer": 0, "target": null, "evade": 0,
			"wingman_order": FIRE_AT_WILL, "wingman_weapon": 0, "wingman_target": null}
		var rank := mini(session.stat("rank"), 20)
		var damage := int(float(rank) / 1.8) + int(session.story_step / 5.0) + 2
		body.weapons = [] if unarmed else [space._npc_gun(race, damage)]
		if not unarmed:
			var emp: Dictionary = space.weapon(18)
			emp.damage = 0; emp.reload = 400; emp.life = 3000; emp.speed = 16.0
			emp.cooldown = 400
			body.weapons.append(emp)

static func tick(session, ms: int) -> void:
	if session.flags.get("wingmen", []).is_empty(): return
	# Zero is the native representation of an elapsed contract; no negative
	# time is needed to preserve the original's <= 0 arrival/notice gates.
	session.flags["wingmen_remaining_ms"] = maxi(0, int(session.flags.get("wingmen_remaining_ms", 0)) - ms)

static func died(space, body) -> void:
	if not bool(body.ai.get("wingman", false)) or bool(body.ai.get("roster_removed", false)): return
	if space.completed_flight: return
	body.ai.roster_removed = true
	var session = space.game.session
	var names: Array = session.flags.get("wingmen", [])
	var at := int(body.ai.get("roster_index", -1))
	if at < 0 or at >= names.size() or str(names[at]) != body.name: return
	names.remove_at(at)
	# Keep surviving physical pilots aligned with the compact saved roster.
	# Repeated damage to an already dead pilot cannot remove another name.
	for other in space.bodies:
		if other != body and bool(other.ai.get("wingman", false)) and int(other.ai.get("roster_index", -1)) > at:
			other.ai.roster_index = int(other.ai.roster_index) - 1
	if names.is_empty(): clear_roster(session)
