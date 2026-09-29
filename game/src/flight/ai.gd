extends RefCounted
## Native behaviour for other ships, built on the original's parameters.
## Fighters stay upright (their orientation is rebuilt from the flight
## direction with world up, never rolled about their own axes) and turn by
## blending their direction towards the goal at `handling` 4096ths of a unit
## per millisecond: 2 when cruising, 1.3 while boosting. Every five seconds
## they reconsider their target (the player for ships set against them,
## with a 30% chance of another ship they fight, all within the 50 000-unit
## sight box) and may stray, holding their heading for a while.
## Inside 8 000 units of the target they swing towards their own right side,
## breaking off rather than ramming, and fire once the target sits within a
## narrow cone and 35 000 units. Boosts come by chance or after losing 40%
## of their durability. Without a target they fly their route: a square
## about the station for ordinary traffic. They steer clear of the station's
## modules and of asteroids. Disabled ships lose forward propulsion until
## their EMP energy recovers.

const Body := preload("res://src/flight/body.gd")
const Wingmen := preload("res://src/flight/wingmen.gd")

const RETARGET_MS := 5000
const RANGE := 50000.0
const HANDLING := 2.0
const BOOST_SPEED := 1.5
const BOOST_HANDLING := 1.3
const BOOST_CHANCE := 20
const BREAK_BOX := 8000.0
const FIRE_BOX := 35000.0
## 500/4096 of a unit either side of the nose: the original's firing cone.
const AIM := 500.0 / 4096.0
const AVOID_HANDLING := 5.0
const WAYPOINT_REACH := 5000.0
## The default patrol square about the station (Void ships fly a wider one).
const PATROL := [Vector3(20000, 0, 20000), Vector3(20000, 0, -20000), Vector3(-20000, 0, -20000), Vector3(-20000, 0, 20000)]

## A route for ordinary traffic: the original's square about the origin.
static func patrol_route(void_ship: bool) -> Array:
	return PATROL.map(func(p): return p * (2.0 if void_ship else 1.0))

static func step(space, b, delta: float, ms: int) -> void:
	var ai: Dictionary = b.ai
	for w in b.weapons: w.cooldown = maxi(0, int(w.cooldown) - ms)
	var mode := str(ai.get("mode", ""))
	if mode == "final_freighter" or mode == "freighter":
		# Big ships advance along world +z without steering; EMP stops that
		# movement rather than adding drift.
		if b.visible and not b.disabled: b.pos.z += b.speed * ms
		return
	if mode == "jump_out":
		# A departing ship accelerates by a tenth each frame of the original
		# (about 30 Hz) until it vanishes into its jump.
		b.speed *= pow(1.1, ms / 33.0)
		b.pos += b.forward() * b.speed * ms
		if b.speed > 100.0:
			b.visible = false
			b.combat_active = false
			ai.mode = "jumped"
			space.event.emit("npc_jumped", {"body": b})
		return
	if mode == "jumped": return
	if b.disabled:
		# The supplied fighter's EMP branch does not moveForward. Invented
		# residual thrust can make a four-second tractor approach impossible
		# even at ordinary player cruise. Recovery and cooldowns still tick.
		return
	if not b.visible: return
	if mode == "encounter_wait":
		# Original state five: wait at the supplied route point until the
		# player enters the 50,000-unit sight box (ordinary, non-Void space).
		var gap: Vector3 = (space.player.pos - b.pos).abs()
		if space.player.alive and space.cloak <= 0 and maxf(gap.x, maxf(gap.y, gap.z)) < 50000.0:
			b.combat_active = true
			ai.mode = "patrol"
		return
	if mode == "hold": return
	ai.timer = int(ai.get("timer", 0)) + ms
	if int(ai.timer) > RETARGET_MS:
		ai.timer = 0
		_choose_target(space, b)
		# A ship that strayed last time always resumes its pursuit.
		ai.stray = not bool(ai.get("stray", false)) and space.rng.randi_range(0, 99) < 20
	elif ai.get("target") == null:
		# Between the five-second reviews a ship without a target takes the
		# first one in sight at once, as PlayerFighter does every frame.
		_choose_target(space, b, false)
	var tgt = ai.get("target")
	var hired := bool(ai.get("wingman", false))
	if tgt != null:
		var lost: bool = not tgt.alive or not tgt.visible or tgt.pos.distance_to(b.pos) > RANGE * 1.5 or (tgt == space.player and space.cloak > 0)
		if hired:
			if int(ai.get("wingman_order", 2)) == Wingmen.ATTACK_TARGET and ai.get("wingman_target") == tgt:
				# cb.java checks each sight axis. A spherical fallback would
				# silently discard a valid diagonal command after acquisition.
				lost = Wingmen.focus_target(space, b) != tgt
			else:
				lost = lost or not Wingmen.valid_target(space, tgt) or not tgt.hostile
		if lost:
			ai.target = null
			tgt = null
	_boost(space, b, ms, hired)
	var handling: float = float(ai.get("handling", HANDLING)) * (BOOST_HANDLING / HANDLING if b.boosting else 1.0)
	var pace: float = b.speed * (BOOST_SPEED if b.boosting else 1.0)
	var secure = Wingmen.secure_goal(b) if hired else null
	if secure == null and tgt == null and mode == "escort":
		# Formation is the idle behaviour, not an early return that prevents
		# wingmen acquiring enemies and reaching the ordinary firing logic.
		var offset: Vector3 = ai.get("escort_offset", Vector3(900, 100, 1200))
		if hired and int(ai.get("wingman_order", 2)) != Wingmen.FIRE_AT_WILL: offset = Vector3.ZERO
		var side: Vector3 = space.player.pos + space.player.basis * offset
		var gap: float = b.pos.distance_to(side)
		# Close in on the slot quickly, then match the leader's heading.
		var aim: Vector3 = (side - b.pos) if gap > 1500.0 else (side - b.pos) * 0.5 + space.player.forward() * 3000.0
		if not _avoiding(b, ms): turn_towards(b, aim, handling * 2.0, ms, delta)
		b.pos += b.forward() * clampf(gap / 1000.0, 0.5, 3.0) * b.speed * ms
		_avoid(space, b, ms, delta)
		return
	# A route point flown through counts even mid-fight, so a ship that
	# returns to its route does not turn back for a point it already passed.
	if ai.has("route") and not (ai.route as Array).is_empty():
		var points: Array = ai.route
		var leg: int = int(ai.get("leg", 0)) % points.size()
		if b.pos.distance_to(points[leg]) < WAYPOINT_REACH: ai.leg = (leg + 1) % points.size()
	var goal = null
	var following_route := false
	if secure != null:
		goal = secure
		following_route = true
	elif tgt != null:
		goal = tgt.pos
	elif mode == "arrive":
		goal = space.station.pos
		following_route = true
		if b.pos.distance_to(goal) < space.station.radius + 8000.0:
			ai.mode = "patrol"
	else:
		# A fighter without its own route flies the original's default square
		# about the station (the wider one for Void ships), wherever it was
		# placed: the fights of a scene come together there.
		if not ai.has("route") or (ai.route as Array).is_empty():
			ai.route = patrol_route(b.faction == 9)
		# Flies its route point by point, round and round.
		var route: Array = ai.route
		var at: int = int(ai.get("leg", 0)) % route.size()
		if b.pos.distance_to(route[at]) < WAYPOINT_REACH:
			at = (at + 1) % route.size()
			ai.leg = at
		goal = route[at]
		following_route = true
		if mode == "jumper":
			# Departing traffic jumps out after twenty seconds on its way.
			ai.jump_ms = int(ai.get("jump_ms", 0)) + ms
			if int(ai.jump_ms) >= 20000:
				ai.jump_ms = 0
				ai.mode = "jump_out"
				b.combat_active = false
				space.event.emit("npc_jumping", {"body": b})
	if _avoiding(b, ms):
		_level_bank(b, delta)
	elif goal != null and not (tgt != null and bool(ai.get("stray", false))):
		var to: Vector3 = goal - b.pos
		if tgt != null and not following_route and _box(to) < BREAK_BOX:
			# Too close: swing away to the right, as the original does, and
			# come round for another pass.
			to = b.basis.x
		turn_towards(b, to, handling, ms, delta)
	else:
		_level_bank(b, delta)
	b.pos += b.forward() * pace * ms
	_avoid(space, b, ms, delta)
	if tgt != null and not following_route:
		var to2: Vector3 = tgt.pos - b.pos
		if _box(to2) < FIRE_BOX:
			var local: Vector3 = b.basis.inverse() * to2.normalized()
			if local.z > 0.0 and absf(local.x) < AIM and absf(local.y) < AIM:
				for index in b.weapons.size():
					var w: Dictionary = b.weapons[index]
					if int(w.cooldown) > 0: continue
					if hired and not Wingmen.can_fire(space, b, w, index): continue
					space.npc_fire(b, w)

## The largest axis distance, as the original's box tests use.
static func _box(v: Vector3) -> float:
	return maxf(absf(v.x), maxf(absf(v.y), absf(v.z)))

## An upright orientation (world up, no roll) whose nose points along `dir`.
static func upright(dir: Vector3, previous: Basis) -> Basis:
	var z := dir.normalized()
	var x := Vector3.UP.cross(z)
	if x.length_squared() < 0.0001: x = previous.x
	x = x.normalized()
	var y := z.cross(x).normalized()
	return Basis(x, y, z)

## Blends the flight direction towards `want` by handling × ms / 4096 and
## rebuilds an upright basis. The turn feeds a purely visual bank.
## A goal behind the ship is steered for by its sideways part (the ship's
## right when it lies dead astern): blending straight towards the tail
## barely turns and, in floating point, flickers from side to side.
static func turn_towards(b, want: Vector3, handling: float, ms: int, delta: float) -> void:
	if want.length_squared() < 1.0:
		_level_bank(b, delta)
		return
	var dir := want.normalized()
	var fwd: Vector3 = b.forward()
	if dir.dot(fwd) < 0.0:
		var across := dir - fwd * dir.dot(fwd)
		dir = across.normalized() if across.length_squared() > 0.01 else (b.basis.x as Vector3).normalized()
	var step_len := float(ms) * handling / 4096.0
	var diff := dir - fwd
	var next := dir
	if diff.length() > step_len:
		next = (fwd + diff.normalized() * step_len).normalized()
	var side: float = b.basis.x.dot(next)
	b.basis = upright(next, b.basis)
	# A left turn swings the nose towards +x; bank into the turn.
	var rate := clampf(side / maxf(0.0001, step_len), -1.0, 1.0)
	b.ai["bank"] = move_toward(float(b.ai.get("bank", 0.0)), rate * 0.6, delta * 1.5)

static func _level_bank(b, delta: float) -> void:
	if b.ai.has("bank"): b.ai.bank = move_toward(float(b.ai.bank), 0.0, delta * 1.5)

## Random boosts and damage escapes (never for hired pilots or ships whose
## speed a scene fixed).
static func _boost(space, b, ms: int, hired: bool) -> void:
	var ai: Dictionary = b.ai
	if hired or not bool(ai.get("can_boost", true)) or b.speed <= 0.0 or b.kind != Body.Kind.SHIP:
		b.boosting = false
		return
	ai.boost_tick = int(ai.get("boost_tick", 0)) + ms
	var health: float = float(b.hull + b.armor) + b.shield
	var seen: float = float(ai.get("health_seen", health))
	if health < seen:
		ai.damage_taken = float(ai.get("damage_taken", 0.0)) + seen - health
		var most: float = float(maxi(1, b.hull_max + b.armor_max + b.shield_max))
		if float(ai.damage_taken) / most > 0.4:
			ai.damage_taken = 0.0
			ai.boost_tick = RETARGET_MS + 1
			ai.escape = true
	ai.health_seen = health
	if b.boosting:
		if int(ai.boost_tick) > int(ai.get("boost_limit", 0)):
			b.boosting = false
			ai.boost_tick = 0
			ai.escape = false
	elif int(ai.boost_tick) > RETARGET_MS:
		ai.boost_tick = 0
		if bool(ai.get("escape", false)) or space.rng.randi_range(0, 99) < BOOST_CHANCE:
			ai.boost_limit = 5000 + space.rng.randi_range(0, 2999)
			b.boosting = true

## Keeps ships out of the station's modules and away from asteroids: the
## original turns sharply away from a landmark it is about to enter.
static func _avoid(space, b, ms: int, delta: float) -> void:
	var ahead: Vector3 = b.pos + b.forward() * 3000.0
	if space.station != null and space.station.solid:
		var hit = space.station_box_at(ahead, 1500.0)
		if hit == null: hit = space.station_box_at(b.pos, 1500.0)
		if hit != null:
			_swerve(b, b.pos - hit, ms, delta)
			return
	for a in space.bodies:
		if a.kind != Body.Kind.ASTEROID or not a.alive: continue
		var r: float = 1500.0 * a.scale.length() / 1.7 + 2500.0
		var gap: Vector3 = ahead - a.pos
		if _box(gap) < r:
			_swerve(b, b.pos - a.pos, ms, delta)
			return

## After a swerve the ship holds its new heading briefly instead of turning
## straight back at the obstacle, which would make it chatter between the two.
const AVOID_HOLD_MS := 700

static func _avoiding(b, ms: int) -> bool:
	var left := int(b.ai.get("avoid_ms", 0))
	if left <= 0: return false
	b.ai.avoid_ms = left - ms
	return true

## Turns sharply to pass beside an obstacle rather than reversing into it.
## A ship already flying away from the obstacle keeps its heading: the
## sideways part of a nearly parallel offset is noise, and steering by it
## flipped the nose left and right every frame.
static func _swerve(b, off: Vector3, ms: int, delta: float) -> void:
	b.ai.avoid_ms = AVOID_HOLD_MS
	var fwd: Vector3 = b.forward()
	if off.length_squared() < 1.0 or off.normalized().dot(fwd) > 0.5:
		_level_bank(b, delta)
		return
	var side: Vector3 = off - fwd * off.dot(fwd)
	if side.length() < off.length() * 0.2: side = b.basis.x
	turn_towards(b, fwd + side.normalized() * 1.5, AVOID_HANDLING, ms, delta)

## PlayerFighter's choice: a ship set against the player goes for the
## player, but at each five-second review a 30% chance sends it after the
## first ship of a race it fights instead; other ships take the first such
## ship. Only targets inside the 50 000-unit sight box count.
static func _choose_target(space, b, review := true) -> void:
	if bool(b.ai.get("wingman", false)):
		var focus = Wingmen.focus_target(space, b)
		if focus != null:
			b.ai.target = focus
			return
		var old = b.ai.get("target")
		if old != null and (not Wingmen.valid_target(space, old) or not old.hostile): b.ai.target = null
	var enemies: Array = []
	if b.hostile and space.player.alive and space.cloak <= 0 and not bool(space.player.ai.get("portal_cinematic", false)):
		enemies.append(space.player)
	for other in space.bodies:
		if other == b or not other.alive or not other.visible or not other.combat_active or not other.is_ship() or other == space.player: continue
		# Debris (no faction) is the player's to clear, not a ship to fight.
		if other.faction < 0: continue
		if _enemies(b, other): enemies.append(other)
	var near: Array = enemies.filter(func(e): return _box(e.pos - b.pos) < RANGE)
	if near.is_empty():
		b.ai.target = null
		return
	if bool(b.ai.get("wingman", false)):
		b.ai.target = near[0]
		return
	var others: Array = near.filter(func(e): return e != space.player)
	var wants_player: bool = near.has(space.player)
	if wants_player and (others.is_empty() or not review or space.rng.randi_range(0, 99) >= 30):
		b.ai.target = space.player
	else:
		b.ai.target = others[0] if not others.is_empty() else space.player

static func _enemies(a, b) -> bool:
	# Hired pilots choose enemies of the player, even if the pilot's race
	# would normally fight a neutral or friendly ship in this area.
	if bool(a.ai.get("wingman", false)):
		return b.hostile and not bool(b.ai.get("fixed_friendly", false)) and not bool(b.ai.get("wingman", false))
	# Ships on the player's side and ships out for the player are at war.
	if (a.hostile and b.friendly) or (a.friendly and b.hostile): return true
	if a.faction == b.faction: return false
	if a.faction == 8 or b.faction == 8: return true
	if a.faction == 9 or b.faction == 9: return true
	# Terran and Vossk, Nivelian and Midorian are at war.
	if (a.faction == 0 and b.faction == 1) or (a.faction == 1 and b.faction == 0): return true
	if (a.faction == 2 and b.faction == 3) or (a.faction == 3 and b.faction == 2): return true
	return false
