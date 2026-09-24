extends RefCounted
## Native behaviour for other ships, built on the original's parameters:
## hostility from standing (pirates and Voids always hostile), a new target
## choice every five seconds with a 30% chance of picking a random enemy
## within 50 000 units, a 20% chance of flying evasively, patrols around a
## home point, and firing when the target sits in front within range.
## Disabled ships (EMP energy at zero) drift until they recover.

const Body := preload("res://src/flight/body.gd")

const RETARGET_MS := 5000
const RANGE := 50000.0
const TURN := 1.1

static func step(space, b, delta: float, ms: int) -> void:
	var ai: Dictionary = b.ai
	for w in b.weapons: w.cooldown = maxi(0, int(w.cooldown) - ms)
	if b.disabled:
		b.pos += b.forward() * b.speed * 0.2 * ms
		return
	if not b.visible: return
	match str(ai.get("mode", "")):
		"hold":
			return
		"escort":
			# Keeps station beside the player and joins the player's fight.
			var side: Vector3 = space.player.pos + space.player.basis * Vector3(900, 100, 1200)
			var steer_e: Vector2 = space._steer_towards(b, side)
			b.basis = b.basis.rotated(b.basis.y, -steer_e.x * TURN * 2.0 * delta)
			b.basis = b.basis.rotated(b.basis.x, -steer_e.y * TURN * 2.0 * delta).orthonormalized()
			var gap: float = b.pos.distance_to(side)
			b.pos += b.forward() * clampf(gap / 1000.0, 0.5, 3.0) * b.speed * ms
			if gap > 20000.0: b.pos = side
			return
	ai.timer = int(ai.get("timer", 0)) + ms
	if int(ai.timer) > RETARGET_MS:
		ai.timer = 0
		_choose_target(space, b)
		ai.evade = 1500 if space.rng.randi_range(0, 99) < 20 else 0
	var goal = null
	var tgt = ai.get("target")
	if tgt != null and (not tgt.alive or tgt.pos.distance_to(b.pos) > RANGE * 1.5):
		ai.target = null
		tgt = null
	if tgt != null:
		goal = tgt.pos
		if int(ai.get("evade", 0)) > 0:
			ai.evade = int(ai.evade) - ms
			goal = b.pos + (b.pos - tgt.pos).normalized() * 20000.0 + b.basis.x * 15000.0
	elif ai.mode == "arrive":
		goal = space.station.pos
		if b.pos.distance_to(goal) < space.station.radius + 8000.0:
			ai.mode = "patrol"
	else:
		var home: Vector3 = ai.get("home", Vector3.ZERO)
		var wp = ai.get("waypoint")
		if wp == null or b.pos.distance_to(wp) < 5000.0:
			wp = home + Vector3(space.rng.randf_range(-30000, 30000), space.rng.randf_range(-10000, 10000), space.rng.randf_range(-30000, 30000))
			ai.waypoint = wp
		goal = wp
	if goal != null:
		var steer: Vector2 = space._steer_towards(b, goal)
		b.basis = b.basis.rotated(b.basis.y, -steer.x * TURN * delta)
		b.basis = b.basis.rotated(b.basis.x, -steer.y * TURN * delta).orthonormalized()
	var pace: float = b.speed * (0.6 if b.kind == Body.Kind.FREIGHTER else 1.0)
	b.pos += b.forward() * pace * ms
	# Keep clear of the station's modules.
	if space._inside_station(b.pos, -2000.0):
		b.pos -= b.forward() * pace * ms * 2.0
		b.basis = b.basis.rotated(b.basis.y, PI * 0.5 * delta * 4.0)
	if tgt != null and int(ai.get("evade", 0)) <= 0:
		var to: Vector3 = tgt.pos - b.pos
		var d := to.length()
		for w in b.weapons:
			if int(w.cooldown) > 0: continue
			if d < float(w.life) * float(w.speed) * 0.8 and b.forward().dot(to / maxf(1.0, d)) > 0.97:
				space.npc_fire(b, w)

static func _choose_target(space, b) -> void:
	var enemies: Array = []
	if b.hostile and space.player.alive and space.cloak <= 0:
		enemies.append(space.player)
	for other in space.bodies:
		if other == b or not other.alive or not other.is_ship() or other == space.player: continue
		if _enemies(b, other): enemies.append(other)
	var current = b.ai.get("target")
	if current != null and current.alive and space.rng.randi_range(0, 99) >= 30: return
	var near: Array = enemies.filter(func(e): return e.pos.distance_to(b.pos) < RANGE)
	if near.is_empty():
		b.ai.target = null
		return
	b.ai.target = near[space.rng.randi_range(0, near.size() - 1)]

static func _enemies(a, b) -> bool:
	if a.faction == b.faction: return false
	if a.faction == 8 or b.faction == 8: return true
	if a.faction == 9 or b.faction == 9: return true
	return false
