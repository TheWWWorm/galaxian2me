extends RefCounted
## The space around one station, simulated natively. The layout follows the
## original's scene builder: the station at the origin, the system's jump gate
## at its gate station, an arrival point further out, two asteroid fields
## whose ores come from the station's distance to each ore's home system,
## and the ambient traffic of locals, arrivals, freighters and pirates by the
## system's safety. Ship figures and weapons come from the imported tables.

const Body := preload("res://src/flight/body.gd")
const Catalogue := preload("res://src/content/catalogue.gd")
const Assembly := preload("res://src/presentation/assembly.gd")
const JavaRandom := preload("res://src/simulation/java_random.gd")
const AI := preload("res://src/flight/ai.gd")
const Backdrop := preload("res://src/presentation/backdrop.gd")
const Story := preload("res://src/flight/story.gd")
const Mining := preload("res://src/flight/mining.gd")

signal event(kind: String, data: Dictionary)

## The player's cruising speed and hit box (original units per millisecond
## and units); boost adds up to twice the booster's percentage.
const PLAYER_SPEED := 2.0
const PLAYER_RADIUS := 1200.0
const DOCKING_SPEED := 8.0
const DOCKING_TIME := 3000
const GATE_ZONE := 7500.0
const GATE_DISTANCE := 90000.0
const ARRIVAL_DISTANCE := 120000.0
const ASTEROIDS := 50
const LOOT_RADIUS := 1000.0
const TRAVEL_FLASH := 2000

var game
var cat
var lib
var rng := RandomNumberGenerator.new()
var bodies: Array = []
var player: Body
var station: Body
var gate: Body
var arrival: Body
var projectiles: Array = []
var effects: Array = []
var target: Body = null
var lock_time := 0.0
var locked := false
var lock_needed := 4000.0
var clock := 0
var autopilot := false
var docking := -1
var jumping := -1
var jump_destination := {}
var travelling := -1
var travel_station := -1
var boost_time := 0
var boost_ready := true
var cloak := 0
var station_boxes: Array = []
var stats := {}
var in_void := false
var shots_fired := 0
var kills := 0
var story: Story = null
var mining: Mining = null
var mining_target: Body = null

func _init(owner) -> void:
	game = owner
	cat = owner.cat
	lib = owner.library
	rng.randomize()

# ------------------------------------------------------------------ layout

func build() -> void:
	var s = game.session
	var st: Dictionary = cat.station(s.station_id)
	var sys: Dictionary = cat.system(s.system_index)
	in_void = false
	# The station and its module boxes.
	station = Body.new()
	station.kind = Body.Kind.STATION
	station.name = str(st.get("name", ""))
	station.station_id = s.station_id
	station.faction = int(sys.faction)
	station.radius = 0.0
	station.hull = 999999
	bodies.append(station)
	_station_boxes(s.station_id, int(sys.faction))
	# Gate and arrival point, placed as the original places them.
	var r := JavaRandom.new(s.station_id << 1)
	var turn := 0
	for n in [1, 2]:
		turn += (-250 - r.next_int(500)) if r.next_int(2) == 0 else (250 + r.next_int(500))
		var distance := (GATE_DISTANCE if n == 1 else ARRIVAL_DISTANCE) + turn * 3
		var p := Assembly.basis(0, turn, 0) * Assembly.position([0, 0, distance]) / Assembly.UNIT
		if n == 1 and int(sys.get("jumpgate_station", -1)) == s.station_id:
			gate = Body.new()
			gate.kind = Body.Kind.GATE
			gate.name = lib.text(271)
			gate.pos = p
			gate.radius = 15000.0
			gate.model = lib.model_name(15)
			gate.hull = 999999
			bodies.append(gate)
		elif n == 2:
			arrival = Body.new()
			arrival.kind = Body.Kind.ARRIVAL
			arrival.pos = p
			arrival.visible = false
			arrival.solid = false
	_asteroids(s.station_id)
	_stars(s.station_id, sys)
	_player()
	_traffic()
	_place_player()
	var scanner: Dictionary = s.equipped_of_type(Catalogue.Type.SCANNER)
	lock_needed = float(cat.attr(int(scanner.id), Catalogue.A_SCAN_LOCK)) if not scanner.is_empty() else 4000.0
	game.arrival_mode = ""
	story = Story.new(self)
	if not story.setup(): story = null

## Collision boxes of the station's modules: the original's per-module table
## (centre and half-extents, plus a 5000-unit margin), turned with each part.
func _station_boxes(station_id: int, faction: int) -> void:
	var table = lib.constant("cw#b:[I")
	var key := "100" if faction == 1 else str(station_id)
	var entry = lib.data.station_parts.get(key)
	var parts: Array = []
	if entry != null and not entry.parts.is_empty():
		parts.append({"model": entry.root, "position": [0, 0, 0], "rotation": [0, 2048, 0]})
		parts.append_array(entry.parts)
	else:
		parts.append({"model": 3337, "position": [0, 0, 0], "rotation": [0, 0, 0]})
	var extent := 0.0
	for part in parts:
		var id := int(part.model)
		var b := Assembly.basis(part.rotation[0], part.rotation[1], part.rotation[2])
		var origin := Assembly.position(part.position) / Assembly.UNIT
		var centre := Vector3.ZERO
		var half := Vector3(5000, 5000, 5000)
		var i := (id - 3301) * 6
		if table is Array and i >= 0 and i + 5 < table.size():
			centre = Vector3(table[i], table[i + 1], table[i + 2])
			half = Vector3(table[i + 3], table[i + 4], table[i + 5]) + Vector3(5000, 5000, 5000)
		station_boxes.append({"basis": b, "origin": origin, "centre": centre, "half": half})
		extent = maxf(extent, origin.length() + half.length())
	station.radius = extent

func _inside_station(p: Vector3, margin := 0.0) -> bool:
	for box in station_boxes:
		var local: Vector3 = box.basis.inverse() * (p - box.origin) - box.centre
		var h: Vector3 = box.half + Vector3.ONE * margin
		if absf(local.x) < h.x and absf(local.y) < h.y and absf(local.z) < h.z: return true
	return false

## Asteroid fields: half near the station, half around a field centre fixed
## per station. Ores are drawn by the original's weighted table.
func _asteroids(station_id: int) -> void:
	var weights := _ore_table(station_id)
	var seeded := JavaRandom.new(station_id)
	var field := Vector3(-50000 + seeded.next_int(100000), -50000 + seeded.next_int(100000), 10000 + seeded.next_int(100000))
	for i in ASTEROIDS:
		var ore := 154
		var cursor := 0
		var tries := 0
		while tries < 200:
			tries += 1
			if weights.is_empty(): break
			if rng.randi_range(0, 99) < int(weights[cursor + 1]):
				var candidate: int = weights[cursor]
				if candidate < 164:
					ore = candidate
					break
			cursor += 2
			if cursor >= weights.size(): cursor = 0
		var centre := Vector3(0, 0, 20000) if i < ASTEROIDS / 2 else field
		var p := centre + Vector3(rng.randi_range(-30000, 30000), rng.randi_range(-30000, 30000), rng.randi_range(-30000, 30000))
		var a := Body.new()
		a.kind = Body.Kind.ASTEROID
		a.model = "asteroid"
		a.ore = ore
		a.pattern_frame = ore - 154
		a.pos = p
		var q := 1024 + rng.randi_range(0, 2447)
		var rr := 1024 + rng.randi_range(0, 2447)
		var ss := 1024 + rng.randi_range(0, 2447)
		a.scale = Vector3(q, rr, ss) / 4096.0
		a.size = int(float((q + rr + ss) / 3) / 3072.0 * 100.0)
		a.hull_max = 30 + a.size
		a.hull = a.hull_max
		a.ore_class = mini(7, 2 + int(float(a.size + 15) / 100.0 * 5.0))
		a.radius = 1500.0
		a.faction = -1
		a.basis = Basis.from_euler(Vector3(rng.randf() * TAU, rng.randf() * TAU, rng.randf() * TAU))
		a.name = lib.text(274)
		bodies.append(a)

## Ore kinds with their chances, most likely first: ores whose home system
## lies close to this station's system, less 2 points per rank.
func _ore_table(station_id: int) -> Array:
	var here: int = cat.system_of_station(station_id)
	var ores: Array = []
	for id in range(154, 164):
		var closeness: int = cat.system_closeness(here, cat.attr(id, Catalogue.A_ORIGIN))
		ores.append([id, closeness if closeness >= 50 else 0])
	ores.append([164, 0])
	ores.sort_custom(func(a, b): return a[1] > b[1])
	var out: Array = []
	for i in ores.size():
		var w: int = ores[i][1]
		if w > 0: w -= i * 2
		out.append_array([ores[i][0], w])
	return out

## The other stations of the system, shown as bright stars: locking one and
## firing travels there.
func _stars(station_id: int, sys: Dictionary) -> void:
	var sky: Dictionary = Backdrop.layout(lib, cat, station_id)
	for sid in sys.get("stations", []):
		if int(sid) == station_id or not sky.stars.has(int(sid)): continue
		var b := Body.new()
		b.ai = {"direction": sky.stars[int(sid)].direction}
		b.kind = Body.Kind.STAR
		b.station_id = int(sid)
		b.name = cat.station_name(int(sid))
		b.solid = false
		b.visible = false
		bodies.append(b)

func _player() -> void:
	var s = game.session
	var st: Dictionary = s.ship_stats()
	player = Body.new()
	player.kind = Body.Kind.PLAYER
	player.name = cat.ship_name(int(s.ship.index))
	player.ship_index = int(s.ship.index)
	player.pattern_frame = Assembly.ship_frame(int(s.ship.faction))
	player.radius = PLAYER_RADIUS
	player.hull_max = int(st.armor)
	player.hull = clampi(int(s.ship.hull) - int(st.armor_plate), 1, player.hull_max) if int(s.ship.hull) > 0 else player.hull_max
	player.armor_max = int(st.armor_plate)
	player.armor = mini(int(s.ship.get("armor", st.armor_plate)), player.armor_max)
	player.shield_max = int(st.shield)
	player.shield = float(s.ship.get("shield", st.shield))
	player.shield_recharge = int(st.shield_recharge)
	player.faction = 0
	player.speed = PLAYER_SPEED
	player.weapons = _player_weapons()
	bodies.append(player)

func _player_weapons() -> Array:
	var out: Array = []
	var s = game.session
	for c in 3:
		var slots: Array = s.equipment[c]
		for i in slots.size():
			var e = slots[i]
			if e == null: continue
			var w := weapon(int(e.id))
			w.slot = [c, i]
			w.count = int(e.count)
			w.offset = _mount_offset(slots.size(), i)
			out.append(w)
	return out

## Gun mount offsets: the original spreads a ship's guns by their count.
func _mount_offset(count: int, index: int) -> Vector3:
	var table = lib.constant("bp.a:[[[S")
	if table is Array and count >= 1 and count <= table.size():
		var row: Array = table[count - 1]
		if index < row.size():
			var p: Array = row[index]
			return Vector3(p[0], p[1], p[2])
	return Vector3.ZERO

## A weapon record for an item: damage, EMP damage, reload, lifetime (the
## item's range, in ms), projectile speed and its kind of projectile.
func weapon(id: int) -> Dictionary:
	var t: int = cat.type(id)
	var kind := "gun"
	if t == Catalogue.Type.ROCKET or t == Catalogue.Type.TORPEDO: kind = "missile"
	elif t == Catalogue.Type.EMP_BOMB: kind = "emp"
	elif t == Catalogue.Type.NUKE: kind = "nuke"
	elif t == Catalogue.Type.TURRET: kind = "turret"
	var models = lib.constant("an.b:[S")
	var model := -1
	if models is Array and id < models.size(): model = int(models[id])
	return {"id": id, "kind": kind, "type": t, "damage": cat.attr(id, Catalogue.A_DAMAGE),
		"emp": maxi(0, cat.attr(id, Catalogue.A_EMP_DAMAGE, 0)),
		"reload": maxi(60, cat.attr(id, Catalogue.A_RELOAD, 400)),
		"life": maxi(300, cat.attr(id, Catalogue.A_RANGE, 2000)),
		"speed": float(maxi(4, cat.attr(id, Catalogue.A_SPEED, 12))),
		"blast": float(cat.attr(id, Catalogue.A_BLAST_RADIUS, 0)),
		"model": lib.model_name(model) if model >= 0 else "", "cooldown": 0, "count": 1, "offset": Vector3.ZERO}

## Ambient traffic when no mission shapes the scene: locals of the system's
## faction, jump-in arrivals, freighters and, by safety, pirates.
func _traffic() -> void:
	var s = game.session
	var sys: Dictionary = cat.system(s.system_index)
	var faction: int = int(sys.faction)
	var safety: int = int(sys.safety)
	var mido_early: bool = s.system_index == 15 and s.story_step < 16
	var home: bool = s.station_id == 78
	var pirate_chance: int = [80, 60, 35, 10][clampi(safety, 0, 3)]
	var pirates: bool = not mido_early and rng.randi_range(0, 99) < pirate_chance
	var other: int = 8 if rng.randi_range(0, 99) < 75 else _rival(faction)
	var y := rng.randi_range(0, 3) if pirates else 0
	var w := 0 if home else rng.randi_range(0, 1)
	var x := 0 if (home or mido_early) else rng.randi_range(0, 4)
	var v := (0 if home else rng.randi_range(0, 1)) + (0 if mido_early else safety) + x / 4
	if s.station_id == 10 or v + w + x + y == 0: v = 4
	for _i in v: _spawn_ship(faction, Vector3(0, 0, 10000), false)
	for _i in w:
		var b := _spawn_ship(other, Vector3(rng.randi_range(-200000, 200000), rng.randi_range(-100000, 100000), rng.randi_range(50000, 150000)), false)
		b.ai.mode = "arrive"
	for i in x:
		var fp := Vector3(rng.randi_range(-80000, -20000) * (1 if rng.randi_range(0, 1) == 0 else -1), rng.randi_range(-20000, 20000), -rng.randi_range(-80000, 80000))
		_spawn_ship(faction, fp, true)
	if y > 0:
		var camp := Vector3(rng.randi_range(-50000, 50000), 0, rng.randi_range(50000, 100000))
		for _i in y:
			var p := _spawn_ship(8, camp, false)
			p.ai.home = camp

func _rival(faction: int) -> int:
	match faction:
		0: return 1
		1: return 0
		2: return 3
		3: return 2
	return 8

## A ship of a faction near `around`. Its hull and EMP resistance grow with
## the player's rank and the story, as the original's formula does.
func _spawn_ship(faction: int, around: Vector3, freighter: bool) -> Body:
	var s = game.session
	var b := Body.new()
	b.kind = Body.Kind.FREIGHTER if freighter else Body.Kind.SHIP
	b.faction = faction
	var rank := mini(int(s.stat("rank")), 20)
	var hull: int = 20 + rank * 15 + int(s.story_step) * 4
	var emp := 40 + rank * 5
	var regen := 15000
	var index := _hull_for(faction, freighter)
	if freighter:
		hull *= 4; emp *= 3; regen *= 3
		if index == 14: hull *= 5
	b.ship_index = index
	b.pattern_frame = Assembly.ship_frame(faction)
	b.hull_max = hull
	b.hull = hull
	b.emp_max = emp
	b.emp = emp
	b.emp_regen = regen
	b.radius = 2000.0
	b.pos = around + Vector3(rng.randi_range(-20000, 20000), rng.randi_range(-20000, 20000), rng.randi_range(-20000, 20000))
	b.basis = Basis.from_euler(Vector3(0, rng.randf() * TAU, 0))
	b.speed = 2.0
	b.name = cat.faction_name(faction)
	b.hostile = faction == 8 or faction == 9 or _hates_player(faction)
	if not freighter:
		var level := int(float(rank) / 1.8) + int(s.story_step / 5.0)
		b.weapons = [_npc_gun(faction, level + 2)]
	b.cargo = _npc_cargo()
	b.ai = {"mode": "patrol", "home": around, "timer": 0, "target": null, "evade": 0}
	bodies.append(b)
	return b

func _hull_for(faction: int, freighter: bool) -> int:
	if freighter: return 13 if faction == 1 else 15
	if faction == 9: return 8
	if faction == 1: return 9
	var n: int = lib.data.ship_parts.size()
	var index := 0
	for _t in 64:
		index = rng.randi_range(0, mini(n, cat.ship_count()) - 1)
		if not index in [0, 8, 9, 10, 13, 14, 15]: break
	return index

## The standard NPC gun: four rounds in flight, 3 s lifetime, speed 16,
## reload shortening with the story; its look depends on the faction.
func _npc_gun(faction: int, damage: int) -> Dictionary:
	var look := 7 if faction == 9 else (1 if faction == 0 else (3 if faction == 1 else 4))
	var models = lib.constant("an.b:[S")
	var model := int(models[look]) if models is Array and look < models.size() else -1
	return {"id": -1, "kind": "gun", "type": 0, "damage": damage, "emp": 0,
		"reload": maxi(200, 600 - (game.session.story_step << 1)), "life": 3000, "speed": 16.0, "blast": 0.0,
		"model": lib.model_name(model) if model >= 0 else "", "cooldown": rng.randi_range(0, 600), "count": 1, "offset": Vector3.ZERO}

## What a ship leaves behind: one or two kinds from the shelves the lounge
## traders draw from, commodities by the handful.
func _npc_cargo() -> Array:
	if rng.randi_range(0, 99) >= 50: return []
	var id := rng.randi_range(97, 153)
	if cat.price_mid(id) <= 0: return []
	return [id, 1 + rng.randi_range(0, 4)]

func _hates_player(faction: int) -> bool:
	var rep: Array = game.session.reputation
	match faction:
		0: return int(rep[0]) < -60
		1: return int(rep[0]) > 60
		2: return int(rep[1]) > 60
		3: return int(rep[1]) < -60
	return false

func _place_player() -> void:
	match game.arrival_mode:
		"jump", "travel":
			var from: Vector3 = arrival.pos if arrival != null else Vector3(0, 0, 40000)
			player.pos = from
			player.basis = Body.facing(station.pos - from)
		_:
			# Launching: the original starts the ship just outside the hangar,
			# heading away from it.
			player.pos = Vector3(10, 10, 10000)
			player.basis = Basis.IDENTITY
	if game.session.story_step == 1:
		player.pos = Vector3(0, 0, -110000)

# ------------------------------------------------------------------ stepping

func step(delta: float, input: Dictionary) -> void:
	var ms := int(delta * 1000.0)
	clock += ms
	if story != null:
		story.step_scene(ms)
		if story.controls_locked:
			input = {"yaw": 0.0, "pitch": 0.0}
	if input.get("autopilot", false): autopilot = not autopilot
	if mining_target != null:
		_mining_step(delta, ms, input)
	elif player.alive:
		_fly_player(delta, ms, input)
		_player_weapons_step(ms, input)
		_targeting(ms, input)
		_regenerate(ms)
	for b in bodies:
		if b == player or not b.alive: continue
		if b.is_ship():
			b.recover(ms)
			AI.step(self, b, delta, ms)
		elif b.kind == Body.Kind.ASTEROID:
			b.basis = b.basis.rotated(Vector3.UP, delta * 0.05)
	_projectiles_step(delta, ms)
	_collisions()
	_cleanup(ms)
	for e in effects: e.time += delta
	effects = effects.filter(func(e): return e.time < e.life)

func _fly_player(delta: float, ms: int, input: Dictionary) -> void:
	var s = game.session
	var st: Dictionary = s.ship_stats()
	var handling: float = float(st.handling) + float(st.steering) / 100.0
	if docking >= 0:
		docking += ms
		player.pos += player.forward() * DOCKING_SPEED * ms
		if docking > DOCKING_TIME:
			docking = -1
			_store_ship_state()
			event.emit("docked", {"station": station.station_id})
		return
	if jumping >= 0:
		jumping += ms
		player.speed = minf(100.0, player.speed + 5.0 * delta * 30.0)
		player.pos += player.forward() * player.speed * ms
		if jumping > 2500:
			jumping = -1
			_store_ship_state()
			s.add_stat("jumpgates")
			event.emit("jumped", jump_destination)
		return
	if travelling >= 0:
		travelling += ms
		player.pos += player.forward() * 40.0 * ms
		if travelling > TRAVEL_FLASH:
			travelling = -1
			_store_ship_state()
			event.emit("jumped", {"station": travel_station, "system": s.system_index, "travel": true})
		return
	var yaw: float = input.get("yaw", 0.0)
	var pitch: float = input.get("pitch", 0.0)
	if autopilot:
		var goal = _autopilot_goal()
		if goal != null:
			var steer := _steer_towards(player, goal)
			yaw = steer.x; pitch = steer.y
	# Turn rates: the original turns handling × ms / 3 units (4096 per turn)
	# per frame about the ship's own axes.
	var rate := handling * 1000.0 / 3.0 / 4096.0 * TAU
	# The nose is +z: a right turn swings it towards −x, pulling up towards +y.
	player.basis = player.basis.rotated(player.basis.y, -yaw * rate * delta)
	player.basis = player.basis.rotated(player.basis.x, -pitch * rate * delta).orthonormalized()
	# Bank for the look of it, levelling out again when not turning.
	player.ai["bank"] = move_toward(float(player.ai.get("bank", 0.0)), -yaw * 0.5, delta * 1.5)
	# Boost: the booster's speed for its duration, then its reload time.
	var boost_speed := 2.0 + float(st.boost_speed) / 100.0 * 2.0
	if input.get("boost", false) and boost_ready and int(st.boost_length) > 0 and not player.boosting:
		player.boosting = true
		boost_time = 0
		boost_ready = false
		event.emit("sound", {"name": "fx_boost_01"})
	if player.boosting:
		boost_time += ms
		if boost_time > int(st.boost_length):
			player.boosting = false
			boost_time = -int(st.boost_reload)
	elif not boost_ready:
		boost_time += ms
		if boost_time >= 0: boost_ready = true
	player.speed = boost_speed if player.boosting else PLAYER_SPEED
	player.pos += player.forward() * player.speed * ms
	# Bounds: far out, the original pulls the ship back in.
	if player.pos.length() > 500000.0:
		player.pos = player.pos.normalized() * 480000.0

func _regenerate(ms: int) -> void:
	var st: Dictionary = game.session.ship_stats()
	# Shields refill completely over their recharge time.
	if player.shield_max > 0 and player.shield_recharge > 0:
		player.shield = minf(float(player.shield_max), player.shield + float(player.shield_max) * ms / float(player.shield_recharge))
	if bool(st.repair):
		player.ai["repair_hull"] = int(player.ai.get("repair_hull", 0)) + ms
		player.ai["repair_armor"] = int(player.ai.get("repair_armor", 0)) + ms
		if int(player.ai.repair_hull) > 600:
			player.ai.repair_hull = 0
			player.hull = mini(player.hull + 1, player.hull_max)
		if int(player.ai.repair_armor) > 1000:
			player.ai.repair_armor = 0
			player.armor = mini(player.armor + 1, player.armor_max)

func _store_ship_state() -> void:
	var s = game.session
	s.ship.hull = player.hull + player.armor
	s.ship.armor = player.armor
	s.ship.shield = player.shield
	# Secondary weapons use ammunition; write back what is left.
	for w in player.weapons:
		if w.kind == "gun" or w.kind == "turret": continue
		var slot: Array = w.slot
		var e = s.equipment[slot[0]][slot[1]]
		if e == null: continue
		if int(w.count) <= 0: s.equipment[slot[0]][slot[1]] = null
		else: e.count = int(w.count)

# ------------------------------------------------------------------ steering

func _steer_towards(b: Body, goal: Vector3) -> Vector2:
	var to := (goal - b.pos)
	if to.length() < 1.0: return Vector2.ZERO
	var local := b.basis.inverse() * to.normalized()
	# In the ship's frame the nose is +z, left is +x and up is +y; answer as
	# stick input (right and up positive).
	var yaw := clampf(-atan2(local.x, local.z) * 2.0, -1.0, 1.0)
	var pitch := clampf(atan2(local.y, local.z) * 2.0, -1.0, 1.0)
	return Vector2(yaw, pitch)

func _autopilot_goal():
	if target != null and target.alive:
		if target.kind == Body.Kind.STAR:
			return player.pos + _star_direction(target) * 100000.0
		return target.pos
	var dest: Dictionary = game.destination
	if not dest.is_empty():
		var sid := int(dest.get("station", -1))
		if sid == station.station_id: return station.pos
		if cat.system_of_station(sid) != game.session.system_index and gate != null: return gate.pos
		for b in bodies:
			if b.kind == Body.Kind.STAR and b.station_id == sid:
				return player.pos + _star_direction(b) * 100000.0
	return null

## Direction of another station's star, matching the backdrop's ring.
func _star_direction(b: Body) -> Vector3:
	var dir = b.ai.get("direction")
	if dir == null: return Vector3.FORWARD
	return dir

# ------------------------------------------------------------------ weapons

func _player_weapons_step(ms: int, input: Dictionary) -> void:
	var auto: bool = bool(input.get("auto_fire", false))
	var fire: bool = input.get("fire", false)
	var special: bool = input.get("secondary", false)
	for w in player.weapons:
		w.cooldown = maxi(0, int(w.cooldown) - ms)
	if docking >= 0 or jumping >= 0 or travelling >= 0: return
	# Firing at a locked station, star, gate or asteroid acts on it instead.
	if input.get("fire_pressed", false) and locked and target != null and not target.is_ship():
		_act_on_target()
		return
	var shooting := fire or (auto and locked and target != null and target.is_ship() and target.hostile)
	if shooting:
		for w in player.weapons:
			if w.kind == "gun" and int(w.cooldown) == 0:
				_fire(player, w)
	if special:
		for w in player.weapons:
			if w.kind != "gun" and w.kind != "turret" and int(w.cooldown) == 0 and int(w.count) > 0:
				_fire(player, w)
				w.count = int(w.count) - 1
				break
	for w in player.weapons:
		if w.kind == "turret" and int(w.cooldown) == 0 and target != null and target.is_ship() and target.hostile and target.pos.distance_to(player.pos) < float(w.life) * float(w.speed):
			_fire(player, w, (target.pos - player.pos).normalized())

func _fire(owner: Body, w: Dictionary, direction := Vector3.ZERO) -> void:
	w.cooldown = int(w.reload)
	var dir := direction if direction != Vector3.ZERO else owner.forward()
	var origin: Vector3 = owner.pos + owner.basis * (w.offset as Vector3) + dir * 400.0
	var p := {"pos": origin, "vel": dir * float(w.speed) + owner.forward() * owner.speed, "life": int(w.life),
		"owner": owner, "weapon": w, "target": target if owner == player else owner.ai.get("target")}
	projectiles.append(p)
	if owner == player:
		shots_fired += 1
		event.emit("sound", {"name": "wpn_rocket_02" if w.kind == "missile" else "fx_menu_04", "volume": 0.35 if w.kind == "gun" else 0.8})

func npc_fire(b: Body, w: Dictionary) -> void:
	_fire(b, w)

func _projectiles_step(delta: float, ms: int) -> void:
	var keep: Array = []
	for p in projectiles:
		var w: Dictionary = p.weapon
		p.life = int(p.life) - ms
		if w.kind == "missile" and p.target != null and p.target.alive:
			var want: Vector3 = (p.target.pos - p.pos).normalized() * p.vel.length()
			p.vel = p.vel.lerp(want, minf(1.0, delta * 2.5))
		var step_vec: Vector3 = p.vel * ms
		var hit: Body = _sweep(p, step_vec)
		p.pos += step_vec
		if hit != null:
			_impact(p, hit)
			continue
		if int(p.life) <= 0:
			if w.kind == "emp" or w.kind == "nuke": _blast(p)
			continue
		keep.append(p)
	projectiles = keep

## The first body the projectile's path passes within that body's box.
func _sweep(p: Dictionary, step_vec: Vector3) -> Body:
	var owner: Body = p.owner
	var best: Body = null
	var best_t := 2.0
	for b in bodies:
		if b == owner or not b.alive or not b.solid: continue
		if b.kind == Body.Kind.STAR or b.kind == Body.Kind.ARRIVAL: continue
		if b.kind == Body.Kind.STATION:
			if _inside_station(p.pos + step_vec): return b
			continue
		# Friendly fire between NPCs of one side is ignored.
		if owner != player and b != player and b.faction == owner.faction: continue
		var rel: Vector3 = b.pos - p.pos
		var t := clampf(rel.dot(step_vec) / maxf(1.0, step_vec.length_squared()), 0.0, 1.0)
		var closest: Vector3 = p.pos + step_vec * t
		var d: Vector3 = closest - b.pos
		var r: float = b.radius
		if absf(d.x) < r and absf(d.y) < r and absf(d.z) < r and t < best_t:
			best_t = t; best = b
	return best

func _impact(p: Dictionary, hit: Body) -> void:
	var w: Dictionary = p.weapon
	if w.kind == "emp" or w.kind == "nuke":
		_blast(p)
		return
	effects.append({"kind": "spark", "pos": p.pos, "time": 0.0, "life": 0.3})
	if hit.kind == Body.Kind.STATION or hit.kind == Body.Kind.GATE: return
	_harm(hit, float(w.damage), float(w.emp), p.owner)

## EMP bombs and nukes: everything within the blast radius takes a share
## falling off with distance.
func _blast(p: Dictionary) -> void:
	var w: Dictionary = p.weapon
	var radius: float = maxf(1.0, float(w.blast))
	effects.append({"kind": "blast", "pos": p.pos, "time": 0.0, "life": 1.2, "radius": radius, "emp": w.kind == "emp"})
	event.emit("sound", {"name": "wpn_nuke_02"})
	for b in bodies:
		if not b.alive or not (b.is_ship() or b.kind == Body.Kind.ASTEROID): continue
		var d: float = b.pos.distance_to(p.pos)
		if d >= radius: continue
		var f := clampf((radius - d) / radius, 0.0, 1.0)
		if w.kind == "emp":
			_harm(b, 0.0, (float(w.emp) if w.emp > 0 else 9999.0) * f, p.owner)
		else:
			_harm(b, float(w.damage) * f * (0.6 if b == player else 1.0), float(w.emp) * f, p.owner)

func _harm(b: Body, damage: float, emp_damage: float, source: Body) -> void:
	var was_alive := b.alive
	if b.kind == Body.Kind.ASTEROID:
		b.hull -= int(ceil(damage))
		if b.hull <= 0: _break_asteroid(b)
		return
	b.damage(damage, emp_damage)
	if source == player and b.is_ship() and b != player:
		b.hostile = true
		b.ai.target = player
		if b.faction >= 0 and b.faction <= 3:
			game.reputation_hit(b.faction, not b.alive)
	if b == player:
		event.emit("hit", {"from": source.pos if source != null else player.pos})
	if was_alive and not b.alive:
		_destroyed(b, source)

func _destroyed(b: Body, source: Body) -> void:
	effects.append({"kind": "explosion", "pos": b.pos, "time": 0.0, "life": 1.6, "scale": 1.0 if b.kind != Body.Kind.FREIGHTER else 2.5})
	event.emit("sound", {"name": "fx_explosion_01"})
	if b == player:
		event.emit("destroyed", {})
		return
	if source == player:
		kills += 1
		game.session.add_stat("kills")
		if b.faction == 8: game.session.add_stat("pirates")
	elif source != null and bool(source.ai.get("rival", false)):
		stats["rival_kills"] = int(stats.get("rival_kills", 0)) + 1
	if not b.cargo.is_empty() and not bool(b.ai.get("no_drop", false)):
		_drop(b.pos, int(b.cargo[0]), int(b.cargo[1]), "box")
	b.dead_timer = 1.0
	event.emit("killed", {"body": b})

func _break_asteroid(a: Body) -> void:
	a.alive = false
	effects.append({"kind": "asteroid", "pos": a.pos, "time": 0.0, "life": 1.6, "scale": a.scale.x})
	event.emit("sound", {"name": "fx_explosion_03"})
	# Ore chunks now and then; class A cores more often. A mined-out
	# asteroid leaves nothing.
	if a.ore >= 154 and a.ore != 164:
		if a.ore_class == 7 and rng.randi_range(0, 99) < 40:
			_drop(a.pos, a.ore + 11, 1, "asteroid")
		elif a.ore_class < 7 and rng.randi_range(0, 99) < 20:
			_drop(a.pos, a.ore, 1 + rng.randi_range(0, 2), "asteroid")

func _drop(at: Vector3, item: int, count: int, look: String) -> void:
	var l := Body.new()
	l.kind = Body.Kind.LOOT
	l.pos = at
	l.cargo = [item, count]
	l.model = "box" if look == "box" else "asteroid"
	l.scale = Vector3.ONE * (4.0 if look == "box" else 0.125)
	l.radius = LOOT_RADIUS
	l.faction = -1
	l.name = cat.item_name(item)
	l.basis = Basis.from_euler(Vector3(rng.randf(), rng.randf(), rng.randf()) * TAU)
	bodies.append(l)

# ------------------------------------------------------------------ collisions

func _collisions() -> void:
	if not player.alive or docking >= 0: return
	# Station: bounce off its modules; flying in with the station targeted docks.
	if _inside_station(player.pos, -3500.0):
		if target == station and not in_void:
			_begin_docking()
		else:
			var away := (player.pos - station.pos).normalized()
			player.basis = Body.facing(away, player.basis.y)
			player.pos += away * 800.0
	for b in bodies:
		if not b.alive or b == player: continue
		match b.kind:
			Body.Kind.ASTEROID:
				var d: Vector3 = b.pos - player.pos
				var r: float = 1500.0 * b.scale.length() / 1.7 + PLAYER_RADIUS
				if d.length() < r:
					# Ramming an asteroid breaks it; a large one hurts.
					_break_asteroid(b)
					if b.size > 30: _harm(player, 40.0, 0.0, null)
			Body.Kind.LOOT:
				if player.pos.distance_to(b.pos) < PLAYER_RADIUS + LOOT_RADIUS + _tractor_reach():
					_collect(b)
			Body.Kind.GATE:
				if player.pos.distance_to(b.pos) < GATE_ZONE and target == b:
					_use_gate()
			Body.Kind.SHIP, Body.Kind.FREIGHTER:
				# A ship disabled by EMP can be looted until it recovers.
				if b.disabled and not b.cargo.is_empty() and player.pos.distance_to(b.pos) < 3000.0 + _tractor_reach():
					_loot(b)

func _tractor_reach() -> float:
	return 6000.0 if game.session.has_equipped_type(Catalogue.Type.TRACTOR_BEAM) else 0.0

func _collect(l: Body) -> void:
	var item: int = l.cargo[0]
	var count: int = l.cargo[1]
	var free: int = game.session.cargo_free()
	if free <= 0:
		event.emit("message", {"text": lib.text(159)})
		return
	count = mini(count, free)
	game.session.add_cargo(item, count)
	game.session.add_stat("cargo_salvaged", count)
	l.alive = false
	event.emit("message", {"text": lib.format(261, {"#Q": str(count), "#N": cat.item_name(item)})})
	event.emit("sound", {"name": "fx_message_03"})

func _loot(b: Body) -> void:
	var item: int = b.cargo[0]
	var count: int = mini(int(b.cargo[1]), game.session.cargo_free())
	if count <= 0:
		event.emit("message", {"text": lib.text(159)})
		return
	game.session.add_cargo(item, count)
	game.session.add_stat("cargo_salvaged", count)
	stats["collected"] = int(stats.get("collected", 0)) + count
	b.cargo = []
	if b.faction >= 0 and b.faction <= 3: game.reputation_hit(b.faction, false)
	event.emit("message", {"text": lib.format(261, {"#Q": str(count), "#N": cat.item_name(item)})})
	event.emit("sound", {"name": "fx_message_03"})

func _begin_docking() -> void:
	if docking >= 0: return
	docking = 0
	autopilot = false
	player.basis = Body.facing(station.pos - player.pos, player.basis.y)
	event.emit("docking", {})

func _use_gate() -> void:
	if jumping >= 0: return
	var dest: Dictionary = game.destination
	var sid := int(dest.get("station", -1))
	if sid < 0 or cat.system_of_station(sid) == game.session.system_index:
		event.emit("gate_menu", {})
		return
	jump_destination = {"station": sid, "system": cat.system_of_station(sid)}
	jumping = 0
	autopilot = false
	event.emit("sound", {"name": "fx_thunder_01"})
	event.emit("gate", {})

func jump_to(station_id: int) -> void:
	game.destination = {"station": station_id}
	jump_destination = {"station": station_id, "system": cat.system_of_station(station_id)}
	jumping = 0
	event.emit("gate", {})

## Acting on a locked target that is not a ship.
func _act_on_target() -> void:
	match target.kind:
		Body.Kind.STATION:
			autopilot = true
			event.emit("message", {"text": lib.text(276)})
		Body.Kind.GATE:
			autopilot = true
		Body.Kind.STAR:
			travel_station = target.station_id
			travelling = 0
			game.destination = {"station": travel_station}
			event.emit("sound", {"name": "fx_boost_02"})
		Body.Kind.ASTEROID:
			_begin_mining(target)

# ------------------------------------------------------------------ mining

func _begin_mining(a: Body) -> void:
	var laser: Dictionary = game.session.equipped_of_type(Catalogue.Type.MINING_LASER)
	if laser.is_empty():
		event.emit("message", {"text": lib.text(265)})
		return
	if game.session.cargo_free() <= 0:
		event.emit("message", {"text": lib.text(159)})
		return
	if a.ore < 0:
		event.emit("message", {"text": lib.text(266)})
		return
	mining_target = a
	mining = null
	autopilot = false
	event.emit("message", {"text": lib.text(296)})

## Flies up to the asteroid, then runs the drill until it is through or wrecked.
func _mining_step(delta: float, ms: int, input: Dictionary) -> void:
	var a: Body = mining_target
	if not a.alive:
		mining_target = null
		mining = null
		return
	var reach: float = 1500.0 * (a.scale.x + a.scale.y + a.scale.z) / 2.0 + PLAYER_RADIUS
	if mining == null:
		var steer := _steer_towards(player, a.pos)
		var rate := 1.5
		player.basis = player.basis.rotated(player.basis.y, -steer.x * rate * delta)
		player.basis = player.basis.rotated(player.basis.x, -steer.y * rate * delta).orthonormalized()
		if player.pos.distance_to(a.pos) > reach:
			player.pos += player.forward() * PLAYER_SPEED * ms
			return
		var laser: Dictionary = game.session.equipped_of_type(Catalogue.Type.MINING_LASER)
		mining = Mining.new(a.ore_class, a.ore, int(laser.id), cat)
		event.emit("sound", {"name": "fx_mining_05"})
		return
	var yaw: float = input.get("yaw", 0.0)
	if mining.step(ms, yaw < -0.3, yaw > 0.3): return
	_finish_mining()

func _finish_mining() -> void:
	var a: Body = mining_target
	var s = game.session
	var amount: int = mini(s.cargo_free(), int(mining.tons))
	if mining.core_found() and s.cargo_free() > 0:
		var core: int = a.ore - 154 + 165
		s.add_cargo(core, 1)
		s.add_stat("cores_mined")
		event.emit("message", {"text": lib.format(261, {"#Q": "1", "#N": cat.item_name(core)})})
		amount = mini(amount, s.cargo_free())
	if amount > 0:
		s.add_cargo(a.ore, amount)
		s.add_stat("ore_mined", amount)
		event.emit("message", {"text": lib.format(262, {"#Q": str(amount), "#N": cat.item_name(a.ore)})})
	else:
		event.emit("message", {"text": lib.text(263)})
	if s.cargo_free() <= 0: event.emit("message", {"text": lib.text(319), "time": 5.0})
	# A mined asteroid is spent and breaks up.
	a.ore = -1
	_break_asteroid(a)
	mining_target = null
	mining = null

# ------------------------------------------------------------------ targeting

## The original locks whatever sits under the crosshair for long enough; the
## scanner sets how long.
func _targeting(ms: int, input: Dictionary) -> void:
	if input.get("next_target", false):
		_cycle_target()
	var aim := _aimed_body()
	if aim != null and aim != target:
		target = aim
		lock_time = 0.0
		locked = false
	if target != null:
		if not target.alive:
			target = null; locked = false; return
		if aim == target or locked:
			lock_time += ms
			if lock_time >= lock_needed and not locked:
				locked = true
				event.emit("sound", {"name": "fx_message_05", "volume": 0.5})

func _aimed_body() -> Body:
	var best: Body = null
	var best_dot := 0.985
	var fwd := player.forward()
	for b in bodies:
		if not b.alive or b == player or b.kind == Body.Kind.ARRIVAL or b.kind == Body.Kind.LOOT: continue
		var dir: Vector3
		if b.kind == Body.Kind.STAR: dir = _star_direction(b)
		else:
			var to: Vector3 = b.pos - player.pos
			if to.length() > 300000.0: continue
			dir = to.normalized()
		var d := fwd.dot(dir)
		if d > best_dot:
			best_dot = d; best = b
	return best

func _cycle_target() -> void:
	var candidates: Array = []
	for b in bodies:
		if b.alive and b != player and b.kind != Body.Kind.ARRIVAL and b.kind != Body.Kind.LOOT and b.kind != Body.Kind.ASTEROID:
			candidates.append(b)
	if candidates.is_empty(): return
	var i := candidates.find(target)
	target = candidates[(i + 1) % candidates.size()]
	lock_time = lock_needed
	locked = true

# ------------------------------------------------------------------ upkeep

func _cleanup(ms: int) -> void:
	var keep: Array = []
	for b in bodies:
		if not b.alive and b.dead_timer > 0.0:
			b.dead_timer -= ms / 1000.0
			if b.dead_timer > 0.0: keep.append(b)
			continue
		if not b.alive and b != player: continue
		keep.append(b)
	bodies = keep
	if target != null and not bodies.has(target): target = null

func hostiles() -> Array:
	return bodies.filter(func(b): return b.alive and b.is_ship() and b != player and b.hostile)
