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
const Wormhole := preload("res://src/flight/wormhole.gd")
const Navigation := preload("res://src/simulation/navigation.gd")
const Wingmen := preload("res://src/flight/wingmen.gd")
const Tractor := preload("res://src/flight/tractor.gd")
const Medals := preload("res://src/simulation/medals.gd")

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
## The station's far asteroid field, where pirate hideouts may lie.
var field_centre := Vector3(0, 0, 60000)
var player: Body
var station: Body
var mothership: Body
var gate: Body
var arrival: Body
var projectiles: Array = []
var effects: Array = []
var target: Body = null
var lock_time := 0.0
var locked := false
var lock_needed := 4000.0
var clock := 0
## A docking/star/gate callback replaces this world synchronously. It must
## not finish its old physics frame against the newly settled session.
var completed_flight := false
var autopilot := false
## The autopilot is flying the mission route rather than to a target.
var autopilot_waypoint := false
## The autopilot is flying to the asteroid field.
var autopilot_field := false
const FIELD_ARRIVAL := 15000.0
## Time acceleration during autopilot travel (1 = normal).
var time_scale := 1
const TIME_SCALES := [1, 2, 4, 8]
const WARP_CLEARANCE := 25000.0

## Whether the flight may run faster than real time: only while the
## autopilot flies, with no hostile near and nothing staged.
func time_warp_allowed() -> bool:
	if not autopilot or not player.alive or docking >= 0 or jumping >= 0 or using_jump_drive: return false
	if mining_target != null or portal_arriving() or starting(): return false
	if story != null and (story.controls_locked or story.hud_hidden): return false
	for h in hostiles():
		if h.pos.distance_to(player.pos) < WARP_CLEARANCE: return false
	return true
var docking := -1
var jumping := -1
var jump_destination := {}
var using_jump_drive := false
var drive_origin := Vector3.ZERO
var drive_basis := Basis.IDENTITY
var travelling := -1
var travel_station := -1
var boost_time := 0
var boost_ready := true
var boost_length := 0
## Sideways speed as a share of forward speed, as Deep's strafe.
const STRAFE_RATE := 0.6
## Cloaking device: while `cloak` is positive the player is hidden from
## other ships. `cloak_time` counts up while cloaked (to the device's
## duration) and while recharging (to its reload); -1 means ready.
var cloak := 0
var cloak_time := -1
var cloak_duration := 0
var cloak_reload := 0
## Presentation: the ship's sideways stretch-and-collapse as it cloaks.
var cloak_coef := 0.0
## Turret view: the ship holds its course while the player swings the
## fitted turret (yaw all round, pitch up to 500/4096 of a turn) and fires it.
var turret_mode := false
var turret_yaw := 0.0
var turret_pitch := 0.0
const TURRET_PITCH_MAX := 500.0 / 4096.0 * TAU
var station_boxes: Array = []
var stats := {}
var in_void := false
var wormhole: Wormhole
## Preserve entry context for source-scripted arrival poses after setup.
var entry_mode := ""
var portal_crossed := false
## Physical portal arrival has its own camera and collision/input boundary;
## it also exists when the current mission has no scripted Story scene.
const PORTAL_ARRIVAL_MS := 7000
var portal_arrival_ms := -1
## The original's start sequence (LevelScript, every area after the opening):
## for seven seconds the camera holds where the chase camera begins and
## watches the ship fly off. Controls and collisions wait meanwhile, and
## the orbit information and a tip take the HUD's place.
const START_MS := 7000
var start_ms := -1
## Whether areas open with it (the flight screen sets this from Options).
var start_sequence := false
var start_camera := Vector3.ZERO
## The tip shown during it (one of the original's loading tips).
var start_tip := -1
var portal_arrival_camera := Vector3.ZERO
var void_regeneration_ms := 0
var fallen_voids: Array = []
var shots_fired := 0
var kills := 0
var story: Story = null
## A call from the local ships over the radio (friendly fire, the alarm):
## {speaker, name, text, face} while `radio_until` is ahead of the clock.
var radio := {}
var radio_until := 0
## The original warns once per visit that you hit a local ship and raises
## the alarm once when the locals turn on you.
var friendly_fire_alerted := false
var locals_alarmed := false
## The generic speakers of the original's radio calls, by race (texts 819+):
## Terran, Vossk, Nivelian, Midorian.
const RACE_SPEAKERS := {0: 23, 1: 22, 2: 24, 3: 21}
var mining: Mining = null
var mining_target: Body = null
var tractor := Tractor.new()

func _init(owner) -> void:
	game = owner
	cat = owner.cat
	lib = owner.library
	rng.randomize()

## Called by the owning flight screen after it leaves the tree. Story owns a
## back-reference to this simulation and ships can target one another, so
## reference counting alone cannot release a discarded flight world.
func dispose() -> void:
	tractor.reset()
	var pending: Array = bodies.duplicate()
	pending.append_array(fallen_voids)
	pending.append_array(ambient)
	pending.append_array([player, station, gate, arrival, target, mining_target])
	if story != null:
		pending.append_array(story.cast)
		story.space = null
		story = null
	for projectile in projectiles:
		pending.append(projectile.get("owner"))
		pending.append(projectile.get("target"))
	var seen := {}
	while not pending.is_empty():
		var body = pending.pop_back()
		if not (body is Body) or seen.has(body.get_instance_id()): continue
		seen[body.get_instance_id()] = true
		# Include targets already removed from the active body list.
		for value in body.ai.values():
			if value is Body: pending.append(value)
		body.ai.clear()
	bodies.clear()
	fallen_voids.clear()
	ambient.clear()
	wormhole = null
	projectiles.clear()
	effects.clear()
	player = null
	station = null
	mothership = null
	gate = null
	arrival = null
	target = null
	mining_target = null
	mining = null
	game = null
	cat = null
	lib = null

# ------------------------------------------------------------------ layout

var empty_orbit := false

func build() -> void:
	var s = game.session
	var st: Dictionary = cat.station(s.station_id)
	var sys: Dictionary = cat.system(s.system_index)
	in_void = s.in_void
	# The station and its module boxes.
	station = Body.new()
	station.kind = Body.Kind.STATION
	station.name = str(st.get("name", ""))
	station.station_id = s.location_id()
	station.faction = int(sys.faction)
	station.radius = 0.0
	station.hull = 999999
	# The first two story scenes play in an empty orbit: the original builds
	# no station there, and the opening camera sits where it would be.
	empty_orbit = not in_void and s.story_step < 2 and s.station_id == 78
	station.visible = not in_void and not empty_orbit
	station.solid = station.visible
	if station.visible:
		bodies.append(station)
		_station_boxes(s.station_id, int(sys.faction))
	elif in_void:
		_build_mothership()
	# Gate and arrival point, placed as the original places them.
	var r := JavaRandom.new(s.station_id << 1)
	var turn := 0
	for n in [1, 2]:
		turn += (-250 - r.next_int(500)) if r.next_int(2) == 0 else (250 + r.next_int(500))
		var distance := (GATE_DISTANCE if n == 1 else ARRIVAL_DISTANCE) + turn * 3
		var p := Assembly.basis(0, turn, 0) * Assembly.position([0, 0, distance]) / Assembly.UNIT
		if n == 1 and not in_void and int(sys.get("jumpgate_station", -1)) == s.station_id:
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
	if in_void:
		arrival.pos = Vector3(_void_arrival_coordinate(), _void_arrival_coordinate(), _void_arrival_coordinate())
	_asteroids(s.location_id())
	if not in_void: _stars(s.station_id, sys)
	if s.story_step <= 42:
		wormhole = Wormhole.new()
		wormhole.name = lib.text(269)
		wormhole.model = lib.model_name(6805)
		wormhole.pos = Vector3(rng.randi_range(-40000, 39999), rng.randi_range(-20000, 19999), rng.randi_range(40000, 79999))
		if _recurring_wormhole(): wormhole.reveal()
		bodies.append(wormhole)
	_player()
	_traffic()
	_place_player()
	if game.arrival_mode == "wormhole" and s.story_step > 1 and s.story_step < 43:
		_begin_portal_arrival()
	var device: Dictionary = s.equipped_of_type(Catalogue.Type.CLOAK)
	if not device.is_empty():
		cloak_duration = maxi(1, cat.attr(int(device.id), Catalogue.A_CLOAK_LENGTH))
		cloak_reload = maxi(1, cat.attr(int(device.id), Catalogue.A_CLOAK_RELOAD))
	var scanner: Dictionary = s.equipped_of_type(Catalogue.Type.SCANNER)
	lock_needed = float(cat.attr(int(scanner.id), Catalogue.A_SCAN_LOCK)) if not scanner.is_empty() else 4000.0
	entry_mode = game.arrival_mode
	game.arrival_mode = ""
	story = Story.new(self)
	if not story.setup(): story = null
	Wingmen.spawn(self)
	if start_sequence and s.story_step > 1 and not in_void and not (entry_mode in ["wormhole", "drive", "void_resume"]) \
			and (story == null or (story.camera_mode == "chase" and not story.controls_locked)):
		start_ms = 0
		start_camera = player.pos + player.basis * Vector3(0, 700, -2000)
		start_tip = START_TIPS[rng.randi_range(0, START_TIPS.size() - 1)]

func _void_arrival_coordinate() -> float:
	return float(rng.randi_range(50000, 99999)) * (1.0 if rng.randi_range(0, 1) == 0 else -1.0)

## cw.java uses model 3337 at the origin in Void space. It is a lockable
## mothership, never a normal station or a valid docking destination.
func _build_mothership() -> void:
	mothership = Body.new()
	mothership.kind = Body.Kind.MOTHERSHIP
	mothership.name = lib.text(238) + " " + lib.text(40)
	mothership.model = lib.model_name(3337)
	mothership.faction = 9
	mothership.combat_active = false
	var table = lib.constant("cw#b:[I")
	var i := (3337 - 3301) * 6
	if table is Array and table.size() > i + 5:
		mothership.ai.centre = Vector3(table[i], table[i + 1], table[i + 2])
		# The same source box constructor as normal station modules takes
		# padded FULL dimensions and halves each integer, including odd sizes.
		mothership.ai.half = Vector3((int(table[i + 3]) + 5000) >> 1,
			(int(table[i + 4]) + 5000) >> 1, (int(table[i + 5]) + 5000) >> 1)
		mothership.radius = mothership.ai.half.length()
	bodies.append(mothership)

func _inside_mothership(p: Vector3) -> bool:
	if mothership == null or not mothership.ai.has("half"): return false
	var d: Vector3 = (p - mothership.pos - mothership.ai.centre).abs()
	var half: Vector3 = mothership.ai.half
	return d.x < half.x and d.y < half.y and d.z < half.z

func _recurring_wormhole() -> bool:
	return in_void or int(game.session.flags.get("wormhole_station", -2)) == game.session.station_id

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
			# The supplied station table stores full dimensions. Its box
			# constructor halves each integer after the 5000-unit padding;
			# treating these as half-extents doubles every module's collision.
			half = Vector3((int(table[i + 3]) + 5000) >> 1,
				(int(table[i + 4]) + 5000) >> 1, (int(table[i + 5]) + 5000) >> 1)
		station_boxes.append({"basis": b, "origin": origin, "centre": centre, "half": half})
		extent = maxf(extent, origin.length() + half.length())
	station.radius = extent

## The world centre of the station module containing `p`, or null.
func station_box_at(p: Vector3, margin := 0.0):
	for box in station_boxes:
		var local: Vector3 = box.basis.inverse() * (p - box.origin) - box.centre
		var h: Vector3 = box.half + Vector3.ONE * margin
		if absf(local.x) < h.x and absf(local.y) < h.y and absf(local.z) < h.z:
			return box.origin + box.basis * box.centre
	return null

func _inside_station(p: Vector3, margin := 0.0) -> bool:
	for box in station_boxes:
		var local: Vector3 = box.basis.inverse() * (p - box.origin) - box.centre
		var h: Vector3 = box.half + Vector3.ONE * margin
		if absf(local.x) < h.x and absf(local.y) < h.y and absf(local.z) < h.z: return true
	return false

## Asteroid fields: half near the station, half around a field centre fixed
## per station. Ores are drawn by the original's weighted table.
func _asteroids(station_id: int) -> void:
	var weights: Array = [] if in_void or empty_orbit else _ore_table(station_id)
	var seeded := JavaRandom.new(station_id)
	var field := Vector3(-50000 + seeded.next_int(100000), -50000 + seeded.next_int(100000), 10000 + seeded.next_int(100000))
	field_centre = field
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
		a.model = lib.model_name(6804) if in_void else "asteroid"
		a.ore = 164 if in_void else ore
		a.pattern_frame = 0 if in_void else ore - 154
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
	player.armor_max = int(st.armor_plate)
	player.armor = clampi(int(s.ship.get("armor", st.armor_plate)), 0, player.armor_max)
	player.hull = clampi(int(s.ship.hull) - player.armor, 1, player.hull_max) if int(s.ship.hull) > 0 else player.hull_max
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

## Ambient traffic when no mission shapes the scene, as the original's
## level builder lays it out: local fighters patrolling a square about the
## station, departing ships that launch and jump away, big freighters
## drifting through, raiders (pirates or the local enemy race) by the
## system's safety, and pirates lying in wait on courier and passenger jobs.
## Destroyed locals and departing ships return from the station later;
## raiders come back for up to two more waves.
var ambient: Array = []
var ambient_ms := 0
var jumper_ms := 0
var raid_waves := 0

func _traffic() -> void:
	ambient.clear()
	if in_void:
		for _i in rng.randi_range(1, 3):
			var b := _spawn_ship(9, Vector3.ZERO, false)
			b.pos = Vector3(rng.randi_range(-40000, 39999), rng.randi_range(-40000, 39999), rng.randi_range(-40000, 39999))
			b.ai.route = AI.patrol_route(true)
		return
	var s = game.session
	var sys: Dictionary = cat.system(s.system_index)
	var faction: int = int(sys.faction)
	var safety: int = int(sys.safety)
	var mido_early: bool = s.system_index == 15 and s.story_step < 16
	var home: bool = s.station_id == 78
	var pirate_chance: int = [80, 60, 35, 10][clampi(safety, 0, 3)]
	var raid: bool = not mido_early and rng.randi_range(0, 99) < pirate_chance
	var camp := Vector3(rng.randi_range(-50000, 49999), 0, rng.randi_range(50000, 99999))
	var attacker: int = 8 if rng.randi_range(0, 99) < 75 else _rival(faction)
	var raiders := rng.randi_range(0, 3) if raid else 0
	var jumpers := 0 if home else rng.randi_range(0, 1)
	var big := 0 if (home or mido_early) else rng.randi_range(0, 4)
	var locals := (0 if home else rng.randi_range(0, 1)) + (0 if mido_early else safety) + big / 4
	var lurkers := 0
	var job: Dictionary = s.job
	if not job.is_empty() and int(job.get("kind", -1)) in [0, 11] and not bool(job.get("done", false)):
		lurkers = int(5.0 * float(job.get("difficulty", 0)) / 10.0)
	if s.station_id == 10 or locals + jumpers + big + raiders + lurkers == 0: locals = 4
	for _i in locals:
		var b := _spawn_ship(faction, Vector3(0, 0, 10000), false)
		b.ai.route = AI.patrol_route(false)
		b.ai.leg = rng.randi_range(0, 3)
		b.ai.role = "local"
		ambient.append(b)
	for _i in jumpers:
		var b := _spawn_ship(faction, Vector3.ZERO, false, _hull_for(attacker, false))
		b.ai.role = "jumper"
		b.ai.route = [Vector3(rng.randi_range(-200000, 199999), rng.randi_range(-100000, 99999), rng.randi_range(50000, 149999))]
		_retire(b)
		ambient.append(b)
	var carrier: bool = faction == 0 and rng.randi_range(0, 99) < 30
	for i in big:
		var b: Body
		if carrier and i == 0:
			b = _spawn_ship(faction, Vector3.ZERO, true, 14)
			b.pos = Vector3(rng.randi_range(-40000, 39999), rng.randi_range(-5000, 4999), rng.randi_range(40000, 119999))
			b.ai.mode = "hold"
			b.speed = 0.0
		else:
			b = _spawn_ship(faction, Vector3.ZERO, true)
			b.pos = Vector3(rng.randi_range(-80000, -20001) * (1 if rng.randi_range(0, 1) == 0 else -1), rng.randi_range(-20000, 19999), rng.randi_range(-80000, 79999))
			b.ai.mode = "freighter"
			b.speed = 1.0
		b.basis = Basis.IDENTITY
		b.ai.role = "freighter"
		ambient.append(b)
	var raider_hull := _hull_for(attacker, false)
	for _i in raiders:
		var p := _spawn_ship(attacker, camp, false, raider_hull)
		p.ai.route = AI.patrol_route(false)
		p.ai.role = "raider"
		p.ai.spawn = p.pos
		ambient.append(p)
	for _i in lurkers:
		var p := _spawn_ship(8, Vector3.ZERO, false)
		p.pos = player.pos + Vector3(rng.randi_range(-30000, 29999), rng.randi_range(-30000, 29999), rng.randi_range(-30000, 29999))
		p.ai.route = AI.patrol_route(false)
		p.ai.role = "lurker"

## A departing ship waits unseen at the station until it launches.
func _retire(b: Body) -> void:
	b.visible = false
	b.combat_active = false
	b.ai.mode = "jumped"

## Brings a destroyed or departed ambient ship back as a fresh one.
func _revive(b: Body, at: Vector3) -> void:
	b.alive = true
	b.visible = true
	b.combat_active = true
	b.hull = b.hull_max
	b.armor = b.armor_max
	b.shield = b.shield_max
	b.emp = b.emp_max
	b.disabled = false
	b.emp_timer = 0
	b.dead_timer = 0.0
	b.boosting = false
	b.speed = 2.0
	b.pos = at
	b.basis = Basis.IDENTITY
	b.cargo = _npc_cargo()
	b.hostile = b.faction == 8 or b.faction == 9 or _hates_player(b.faction)
	b.ai.target = null
	b.ai.leg = 0
	b.ai.jump_ms = 0
	b.ai.erase("bank")
	b.ai.mode = "jumper" if str(b.ai.get("role", "")) == "jumper" else "patrol"
	if not bodies.has(b): bodies.append(b)
	event.emit("npc_launched", {"body": b})

func _ambient_step(ms: int) -> void:
	if story != null or ambient.is_empty() or in_void: return
	jumper_ms += ms
	ambient_ms += ms
	var gone := func(b): return (not b.alive and b.dead_timer <= 0.0) or str(b.ai.get("mode", "")) == "jumped"
	if jumper_ms > 20000:
		jumper_ms = 0
		for b in ambient:
			if str(b.ai.get("role", "")) == "jumper" and gone.call(b):
				_revive(b, Vector3(0, 0, 10000))
				break
	if ambient_ms > 40000:
		ambient_ms = 0
		var fallen: Array = ambient.filter(func(b): return str(b.ai.get("role", "")) == "raider" and gone.call(b))
		var wave: bool = fallen.size() >= 2 and raid_waves < 2
		for b in ambient:
			if str(b.ai.get("role", "")) == "local" and gone.call(b):
				_revive(b, Vector3(0, 0, 10000))
		if wave:
			raid_waves += 1
			for b in fallen:
				var at: Vector3 = b.ai.get("spawn", Vector3.ZERO)
				_revive(b, Vector3(at.x, at.y, player.pos.z + 40000.0))
				b.basis = Basis(Vector3.UP, PI)

func _rival(faction: int) -> int:
	match faction:
		0: return 1
		1: return 0
		2: return 3
		3: return 2
	return 8

## A ship of a faction near `around`. Its hull and EMP resistance grow with
## the player's rank and the story, as the original's formula does.
func _spawn_ship(faction: int, around: Vector3, freighter: bool, hull_index := -1) -> Body:
	var s = game.session
	var b := Body.new()
	b.kind = Body.Kind.FREIGHTER if freighter else Body.Kind.SHIP
	b.faction = faction
	var rank := mini(int(s.stat("rank")), 20)
	var hull: int = 20 + rank * 15 + int(s.story_step) * 4
	var emp := 40 + rank * 5
	var regen := 15000
	var index := hull_index if hull_index >= 0 else _hull_for(faction, freighter)
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
	b.radius = 4000.0 if freighter else 2000.0
	b.pos = around + Vector3(rng.randi_range(-20000, 20000), rng.randi_range(-20000, 20000), rng.randi_range(-20000, 20000))
	b.basis = AI.upright(Vector3(rng.randf_range(-1, 1), 0, rng.randf_range(-1, 1)), Basis.IDENTITY)
	b.speed = 2.0
	b.name = cat.faction_name(faction)
	b.hostile = faction == 8 or faction == 9 or _hates_player(faction)
	if not freighter:
		var level := int(float(rank) / 1.8) + int(s.story_step / 5.0)
		b.weapons = [_npc_gun(faction, level + 2)]
	b.cargo = _npc_cargo()
	b.ai = {"mode": "patrol", "home": around, "timer": rng.randi_range(0, AI.RETARGET_MS), "target": null}
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
	# The original disarms every gun to a single point for campaign mission 4.
	if int(game.session.story_step) == 4: damage = 1
	var look := 7 if faction == 9 else (1 if faction == 0 else (3 if faction == 1 else 4))
	var models = lib.constant("an.b:[S")
	var model := int(models[look]) if models is Array and look < models.size() else -1
	return {"id": -1, "kind": "gun", "type": 0, "damage": damage, "emp": 0,
		"reload": maxi(200, 600 - (game.session.story_step << 1)), "life": 3000, "speed": 16.0, "blast": 0.0,
		"model": lib.model_name(model) if model >= 0 else "", "cooldown": rng.randi_range(0, 600), "count": 1, "offset": Vector3.ZERO}

## What a ship carries, as the original's loot generator draws it: nothing
## a third of the time, otherwise one or two kinds. Each pick favours
## commodities by category chance and the item's own occurrence, skipping
## blueprint products and priceless goods and, apart from commodities,
## anything above tech level 7; failing that, raw ore. Commodities come in
## ones to nines, anything else singly.
const LOOT_CATEGORY_CHANCE := [5, 20, 2, 5, 100]

func _npc_cargo() -> Array:
	var kinds := rng.randi_range(0, 2)
	var out: Array = []
	var n: int = cat.item_count()
	for _k in kinds:
		var id := -1
		var category := 4
		for _try in 100:
			var candidate := rng.randi_range(0, n - 1)
			var c: int = cat.category(candidate)
			if cat.is_blueprint_product(candidate) or candidate == 175 or candidate == 164: continue
			if c < 0 or c >= LOOT_CATEGORY_CHANCE.size(): continue
			if rng.randi_range(0, 99) >= int(LOOT_CATEGORY_CHANCE[c]): continue
			if rng.randi_range(0, 99) >= cat.attr(candidate, Catalogue.A_OCCURRENCE): continue
			if cat.price_mid(candidate) <= 0 or (c != 4 and cat.tech(candidate) > 7): continue
			id = candidate
			category = c
			break
		if id < 0:
			id = 154 + rng.randi_range(0, 9)
			category = 4
		out.append_array([id, 1 + rng.randi_range(0, 8) if category == 4 else 1])
	return out

func _hates_player(faction: int) -> bool:
	var rep: Array = game.session.reputation
	match faction:
		0: return int(rep[0]) < -60
		1: return int(rep[0]) > 60
		2: return int(rep[1]) < -60
		3: return int(rep[1]) > 60
	return false

func _place_player() -> void:
	match game.arrival_mode:
		"jump", "travel", "wormhole", "void_resume", "drive":
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

## ch.java uses a fixed camera ahead of the ship, aimed back at it. Its
## seven-second shot disables dr's object collisions and user controls,
## but does not replace durability or stop ordinary forward flight.
func _begin_portal_arrival() -> void:
	if wormhole == null: return
	portal_arrival_ms = 0
	autopilot = false
	wormhole.arrive_behind(player.pos - player.forward() * 8192.0)
	var offset := Vector3(rng.randi_range(500, 999), rng.randi_range(500, 999), 10000)
	if rng.randi_range(0, 1) == 0: offset.x = -offset.x
	if rng.randi_range(0, 1) == 0: offset.y = -offset.y
	var yaw := atan2(player.forward().x, player.forward().z)
	portal_arrival_camera = player.pos + Basis(Vector3.UP, yaw) * offset

## GameText.tips: the texts the original's loading screen picks from.
const START_TIPS := [165, 166, 167, 168, 169, 169, 170, 171, 172, 173, 174, 175, 176, 177]

func starting() -> bool:
	return start_ms >= 0 and start_ms <= START_MS

## Ends the start sequence early (a key, click or tap, as for the story's shots).
func skip_start() -> void:
	if starting(): start_ms = START_MS + 1

func portal_arriving() -> bool:
	return portal_arrival_ms >= 0 and portal_arrival_ms <= PORTAL_ARRIVAL_MS

func _step_portal_arrival(ms: int) -> void:
	if not portal_arriving(): return
	portal_arrival_ms += ms
	if portal_arrival_ms > PORTAL_ARRIVAL_MS:
		event.emit("portal_arrival_finished", {"elapsed": portal_arrival_ms, "from_void": not in_void})

# ------------------------------------------------------------------ stepping

## Beyond this jump in one tick a body was placed, not flown: no blending.
const TELEPORT := 6000.0
var _presented: Array = []

## Puts every body between its pose before the last tick and its current
## one (`alpha` of the way) for drawing; the next step or
## restore_poses() puts the true poses back.
func present(alpha: float) -> void:
	restore_poses()
	alpha = clampf(alpha, 0.0, 1.0)
	for b in bodies:
		if b.prev_pos == null or (b.prev_pos as Vector3).distance_to(b.pos) > TELEPORT: continue
		_presented.append([b, b.pos, b.basis])
		b.pos = (b.prev_pos as Vector3).lerp(b.pos, alpha)
		var scale: Vector3 = b.basis.get_scale()
		var q0 := Quaternion(b.prev_basis.orthonormalized())
		var q1 := Quaternion(b.basis.orthonormalized())
		b.basis = Basis(q0.slerp(q1, alpha)).scaled_local(scale)

func restore_poses() -> void:
	for entry in _presented:
		entry[0].pos = entry[1]
		entry[0].basis = entry[2]
	_presented.clear()

func step(delta: float, input: Dictionary) -> void:
	restore_poses()
	if completed_flight: return
	var ms := int(delta * 1000.0)
	clock += ms
	if not radio.is_empty() and clock >= radio_until: radio = {}
	Wingmen.tick(game.session, ms)
	# Main/o's drive cinematic disables ordinary gameplay and collisions.
	# It preserves the actual ship instead of repairing or replaying a world.
	if using_jump_drive and jumping >= 0:
		_fly_player(delta, ms, {})
		return
	_step_portal_arrival(ms)
	if starting(): start_ms += ms
	_step_wormhole(ms)
	_step_cloak(ms)
	if story != null:
		story.step_scene(ms)
		# The deadline opens a paused mission-loss result synchronously.
		# Do not move/fire/cross after that loss in the rest of this frame.
		if story.step == 42 and story.failed: return
		if story.controls_locked:
			input = {"yaw": 0.0, "pitch": 0.0}
		elif in_opening():
			# The opening's fight is only a fight: no autopilot, map, action
			# menu, time warp or cloak, as the original's intro allows none.
			var fight := {}
			for key in ["yaw", "pitch", "strafe", "fire", "fire_pressed", "secondary", "boost", "auto_fire", "auto_fire_toggled"]:
				if input.has(key): fight[key] = input[key]
			input = fight
	if portal_arriving() or starting(): input = {"yaw": 0.0, "pitch": 0.0}
	if input.get("autopilot", false):
		# The original's autopilot key: off when on ("Autopilot Off"); when
		# off, towards the locked object, else the chosen destination, else
		# the mission route, else it opens the autopilot list.
		if autopilot:
			autopilot = false
			event.emit("message", {"text": lib.text(292) + " " + lib.text(16)})
		elif target != null and target.alive:
			autopilot = true
			event.emit("sound", {"name": "fx_message_05"})
			event.emit("message", {"text": lib.text(270) + ": " + (target.name if not target.name.is_empty() else lib.text(292))})
		elif course_body() != null:
			autopilot = true
			event.emit("sound", {"name": "fx_message_05"})
			event.emit("message", {"text": lib.text(270) + ": " + cat.station_name(int(game.destination.get("station", -1)))})
		elif mission_waypoint() != null:
			fly_to_waypoint()
		else:
			event.emit("autopilot_list", {})
	if input.get("cloak", false): toggle_cloak()
	if turret_mode and (navigation_locked() or not player.alive): turret_mode = false
	if mining_target != null:
		_mining_step(delta, ms, input)
	elif player.alive:
		_fly_player(delta, ms, input)
		if completed_flight: return
		_player_weapons_step(ms, input)
		if not portal_arriving() and not starting(): _targeting(ms, input)
		_regenerate(ms)
	for b in bodies:
		if b == player or not b.alive: continue
		if b.is_ship():
			b.recover(ms)
			AI.step(self, b, delta, ms)
		elif b.kind == Body.Kind.ASTEROID:
			b.basis = b.basis.rotated(Vector3.UP, delta * 0.05)
		elif b.kind == Body.Kind.LOOT and b.alive:
			_age_crate(b, ms)
	_ambient_step(ms)
	_projectiles_step(delta, ms)
	_tractor_step(ms)
	_collisions()
	_cleanup(ms)
	_regenerate_voids(ms)
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
			completed_flight = true
			event.emit("docked", {"station": station.station_id})
		return
	if jumping >= 0:
		jumping += ms
		player.speed = minf(100.0, player.speed + 5.0 * delta * 30.0)
		player.pos += player.forward() * player.speed * ms
		if jumping > 2500:
			jumping = -1
			_store_ship_state()
			if not using_jump_drive: s.add_stat("jumpgates")
			completed_flight = true
			event.emit("drive_arrived" if using_jump_drive else "jumped", jump_destination)
		return
	if travelling >= 0:
		travelling += ms
		player.pos += player.forward() * 40.0 * ms
		if travelling > TRAVEL_FLASH:
			travelling = -1
			_store_ship_state()
			completed_flight = true
			event.emit("jumped", {"station": travel_station, "system": s.system_index, "travel": true})
		return
	# A scene holding the ship still (the original's setFreeze).
	if story != null and story.frozen: return
	var yaw: float = input.get("yaw", 0.0)
	var pitch: float = input.get("pitch", 0.0)
	if turret_mode:
		# Steering swings the turret; the ship itself flies on, levelling.
		turret_yaw -= yaw * _turret_speed() / 200.0 * ms / 4096.0 * TAU
		turret_pitch = clampf(turret_pitch + pitch * ms / 4096.0 * TAU, 0.0, TURRET_PITCH_MAX)
		yaw = 0.0
		pitch = 0.0
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
	if absf(yaw) < 0.01 and absf(pitch) < 0.01: _align_to_horizon(ms)
	# Bank for the look of it, levelling out again when not turning.
	# A sideways slide (Deep's strafe) leans the same way as a turn.
	var strafe: float = 0.0 if autopilot or turret_mode else clampf(float(input.get("strafe", 0.0)), -1.0, 1.0)
	player.ai["bank"] = move_toward(float(player.ai.get("bank", 0.0)), -(yaw + strafe * 0.6) * 0.5, delta * 1.5)
	# Boost: the booster's speed for its duration, then its reload time.
	boost_length = int(st.boost_length)
	# The original truncates: 2 + (int)(percent / 100 × 2), so a 60% or 80%
	# booster both fly at 3.
	var boost_speed := 2.0 + float(int(float(st.boost_speed) / 100.0 * 2.0))
	if input.get("boost", false) and boost_ready and int(st.boost_length) > 0 and not player.boosting:
		player.boosting = true
		boost_time = 0
		boost_ready = false
		event.emit("sound", {"name": "fx_boost_01"})
		event.emit("message", {"text": lib.text(154)})
	if player.boosting:
		boost_time += ms
		if boost_time > int(st.boost_length):
			player.boosting = false
			boost_time = -int(st.boost_reload)
	elif not boost_ready:
		boost_time += ms
		if boost_time >= 0:
			boost_ready = true
			if int(st.boost_length) > 0: event.emit("message", {"text": lib.text(155)})
	player.speed = boost_speed if player.boosting else PLAYER_SPEED
	player.pos += player.forward() * player.speed * ms
	# Right is −x in the ship's frame (a right turn swings the nose to −x).
	if strafe != 0.0: player.pos -= player.basis.x * strafe * player.speed * STRAFE_RATE * ms
	# Bounds: far out, the original pulls the ship back in.
	if player.pos.length() > 500000.0:
		player.pos = player.pos.normalized() * 480000.0

func has_turret() -> bool:
	for w in player.weapons:
		if w.kind == "turret": return true
	return false

func set_turret_mode(on: bool) -> bool:
	if on and (not has_turret() or mining_target != null or navigation_locked()): return false
	turret_mode = on
	if on:
		turret_yaw = 0.0
		turret_pitch = 0.0
	return true

## Where the player aims: the turret in turret view, otherwise the nose.
func aim_direction() -> Vector3:
	if not turret_mode: return player.forward()
	var local := Basis(Vector3.UP, turret_yaw) * Basis(Vector3.RIGHT, -turret_pitch) * Vector3(0, 0, 1)
	return (player.basis * local).normalized()

func _turret_speed() -> float:
	for w in player.weapons:
		if w.kind == "turret": return float(maxi(1, cat.attr(int(w.id), Catalogue.A_TURRET_SPEED, 40)))
	return 40.0

## The original levels the ship's wings whenever it is not being steered:
## half a 4096th of a turn per millisecond, at most 60 ms per frame.
func _align_to_horizon(ms: int) -> void:
	var step := float(mini(ms, 60)) / 2.0 / 4096.0 * TAU
	var up_y: float = player.basis.y.y
	var right_y: float = player.basis.x.y
	if up_y >= 0.0 and absf(right_y) <= 128.0 / 4096.0: return
	var fwd := aim_direction()
	var a := player.basis.rotated(fwd, step)
	var b := player.basis.rotated(fwd, -step)
	var better_a: bool = absf(a.x.y) < absf(b.x.y) if up_y >= 0.0 else a.y.y > b.y.y
	player.basis = (a if better_a else b).orthonormalized()

func has_cloak() -> bool:
	return cloak_duration > 0

func cloak_ready() -> bool:
	return has_cloak() and cloak <= 0 and cloak_time < 0

## Switches the cloaking device on (when charged) or off early.
func toggle_cloak() -> bool:
	if not has_cloak() or not player.alive: return false
	if cloak > 0:
		cloak = 0
		cloak_time = 0
		event.emit("cloak", {"on": false})
		return true
	if cloak_time >= 0 or navigation_locked(): return false
	cloak = 1
	cloak_time = 0
	# Ships hunting the player lose track at once.
	for b in bodies:
		if b.is_ship() and b != player and b.ai.get("target") == player: b.ai.target = null
	event.emit("cloak", {"on": true})
	return true

## Fraction of the current cloak or recharge phase that has elapsed.
func cloak_progress() -> float:
	if cloak > 0: return float(cloak_time) / float(maxi(1, cloak_duration))
	if cloak_time >= 0: return float(cloak_time) / float(maxi(1, cloak_reload))
	return 1.0

func _step_cloak(ms: int) -> void:
	if not has_cloak(): return
	if cloak > 0:
		cloak_coef += ms * 8.0 / 4096.0
		cloak_time += ms
		game.session.add_stat("cloaked_ms", ms)
		if cloak_time > cloak_duration:
			cloak = 0
			cloak_time = 0
			event.emit("cloak", {"on": false})
	else:
		cloak_coef = maxf(0.0, cloak_coef - ms * 8.0 / 4096.0)
		if cloak_time >= 0:
			cloak_time += ms
			if cloak_time > cloak_reload: cloak_time = -1

## The ship's sideways scale for the cloaking animation; negative = unseen.
func cloak_scale() -> float:
	if cloak_coef <= 0.0: return 1.0
	return -2.0 * (cloak_coef - 1.0) * (cloak_coef - 1.0) + 3.0

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

## The object the chosen destination is reached through: this station, the
## jump gate towards another system, or another station's star. Null when no
## destination is chosen.
func course_body() -> Body:
	var dest: Dictionary = game.destination
	if dest.is_empty(): return null
	var sid := int(dest.get("station", -1))
	if sid < 0: return null
	if station != null and sid == station.station_id: return station
	if cat.system_of_station(sid) != game.session.system_index:
		if gate != null: return gate
		# Another system is reached through this system's gate station.
		sid = int(cat.system(game.session.system_index).get("jumpgate_station", -1))
		if station != null and sid == station.station_id: return null
	for b in bodies:
		if b.kind == Body.Kind.STAR and b.station_id == sid: return b
	return null

## The next unreached point of the player's mission route, or null.
func mission_waypoint():
	return story.wingman_waypoint() if story != null else null

## Autopilot along the mission route (the original's Waypoint entry).
func fly_to_waypoint() -> bool:
	if mission_waypoint() == null or navigation_locked(): return false
	_engage_autopilot()
	autopilot_waypoint = true
	event.emit("message", {"text": lib.text(270) + ": " + lib.text(272)})
	return true

## The original's autopilot list: the programmed destination, the jump
## gate, this station, the asteroid field and the mission waypoint. Only
## the entries that exist here are offered.
func autopilot_choices() -> Array:
	var out: Array = []
	if course_body() != null and not game.destination.is_empty():
		out.append({"key": "destination", "label": lib.text(270) + ": " + cat.station_name(int(game.destination.get("station", -1)))})
	if gate != null: out.append({"key": "gate", "label": lib.text(271)})
	if station != null: out.append({"key": "station", "label": station.name + " " + lib.text(40)})
	if not in_void: out.append({"key": "field", "label": lib.text(273)})
	if mission_waypoint() != null: out.append({"key": "waypoint", "label": lib.text(294)})
	return out

func autopilot_to(key: String) -> bool:
	if navigation_locked(): return false
	match key:
		"destination":
			if course_body() == null: return false
			_engage_autopilot()
			target = null
			event.emit("message", {"text": lib.text(270) + ": " + cat.station_name(int(game.destination.get("station", -1)))})
		"gate", "station":
			var body: Body = gate if key == "gate" else station
			if body == null: return false
			_engage_autopilot()
			target = body
			locked = true
			event.emit("message", {"text": lib.text(270) + ": " + (lib.text(271) if key == "gate" else station.name + " " + lib.text(40))})
		"field":
			_engage_autopilot()
			autopilot_field = true
			event.emit("message", {"text": lib.text(270) + ": " + lib.text(273)})
		"waypoint":
			return fly_to_waypoint()
		_:
			return false
	return true

func _engage_autopilot() -> void:
	autopilot = true
	event.emit("sound", {"name": "fx_message_05"})
	autopilot_waypoint = false
	autopilot_field = false

func _autopilot_goal():
	if autopilot_waypoint:
		return mission_waypoint()
	if autopilot_field:
		return field_centre
	if target != null and target.alive:
		if target.kind == Body.Kind.STAR:
			return player.pos + _star_direction(target) * 100000.0
		return target.pos
	var way := course_body()
	if way == null: return null
	if way.kind == Body.Kind.STAR: return player.pos + _star_direction(way) * 100000.0
	return way.pos

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
			# Ab.java fires only the turret from the turret view.
			if int(w.cooldown) != 0: continue
			if turret_mode and w.kind == "turret": _fire(player, w, aim_direction())
			elif not turret_mode and w.kind == "gun": _fire(player, w)
	if special:
		# The chosen launcher fires only itself, as in the original; with no
		# loaded choice, the first ready loaded launcher in slot order.
		var choice: int = game.secondary_choice
		var chosen_loaded := secondary_launchers().any(func(o): return int(o.id) == choice and int(o.count) > 0)
		for w in player.weapons:
			# Supplied ak.java: an active area bomb ignites before checking
			# this launcher's remaining stack or reload. Secondary is a
			# press edge from Controls; holding a key must not ignite it.
			if w.kind in ["emp", "nuke"] and _ignite_player_bomb(w): continue
			if w.kind == "gun" or w.kind == "turret" or int(w.cooldown) != 0 or int(w.count) <= 0: continue
			if chosen_loaded and int(w.id) != choice: continue
			_fire(player, w)
			w.count = int(w.count) - 1
			# An emptied choice is dropped, as the original drops it.
			if chosen_loaded and not secondary_launchers().any(func(o): return int(o.id) == choice and int(o.count) > 0):
				game.secondary_choice = -1
			break

## The fitted secondary launchers (rockets, torpedoes, bombs).
func secondary_launchers() -> Array:
	return player.weapons.filter(func(w): return w.kind != "gun" and w.kind != "turret")

## The launcher the secondary button fires: the chosen weapon while it has
## rounds. The original fires nothing until one is chosen in the quick menu;
## here the first loaded launcher stands in, so the button is never dead.
func current_secondary() -> Dictionary:
	var first := {}
	for w in secondary_launchers():
		if int(w.count) <= 0: continue
		if int(w.id) == game.secondary_choice: return w
		if first.is_empty(): first = w
	return first

func choose_secondary(item_id: int) -> void:
	game.secondary_choice = item_id

## Retire the actual launcher's projectile before applying the ordinary blast.
## It remains controllable after the last round cleared the saved fitting slot.
## Reference identity avoids igniting a different, identically equipped ship.
func _ignite_player_bomb(w: Dictionary) -> bool:
	var active: Array = []
	var remaining: Array = []
	for p in projectiles:
		if p.owner == player and is_same(p.weapon, w) and int(p.life) >= 0:
			active.append(p)
		else:
			remaining.append(p)
	# Array.erase uses value equality for dictionaries; equal-looking rounds
	# from another launcher must retain their own identity and lifecycle.
	projectiles = remaining
	for p in active:
		_blast(p)
	return not active.is_empty()

func _fire(owner: Body, w: Dictionary, direction := Vector3.ZERO) -> void:
	w.cooldown = int(w.reload)
	var dir := direction if direction != Vector3.ZERO else owner.forward()
	var origin: Vector3 = owner.pos + owner.basis * (w.offset as Vector3) + dir * 400.0
	# Gun.shootAt: the round flies at its own speed along the muzzle, without
	# the ship's speed added.
	var p := {"pos": origin, "vel": dir * float(w.speed), "life": int(w.life),
		"owner": owner, "weapon": w, "target": target if owner == player else owner.ai.get("target")}
	projectiles.append(p)
	if owner == player:
		shots_fired += 1
		if w.kind == "emp" or w.kind == "nuke": game.session.add_stat("bombs_used")
		var launch := launch_sound(w)
		if not launch.is_empty(): event.emit("sound", {"name": launch, "volume": 0.8})

## The original's launch sounds: rockets, torpedoes, and one for EMP bombs
## and nukes alike. Guns fire silently, as they do in the original.
func launch_sound(w: Dictionary) -> String:
	match w.kind:
		"missile": return "wpn_rocket_03" if int(w.type) == Catalogue.Type.TORPEDO else "wpn_rocket_02"
		"emp", "nuke": return "wpn_rocket_04"
	return ""

func npc_fire(b: Body, w: Dictionary) -> void:
	_fire(b, w)

func _projectiles_step(delta: float, ms: int) -> void:
	var keep: Array = []
	for p in projectiles:
		var w: Dictionary = p.weapon
		p.life = int(p.life) - ms
		# RocketGun: only torpedoes are guided, and only after their first
		# 1.5 s; then they turn straight at the target each frame.
		if w.kind == "missile" and int(w.type) == Catalogue.Type.TORPEDO and int(w.life) - int(p.life) > 1500:
			var mark: Body = _torpedo_mark(p)
			if mark != null:
				p.vel = (mark.pos - p.pos).normalized() * p.vel.length()
		var step_vec: Vector3 = p.vel * ms
		var hit: Body = _sweep(p, step_vec)
		p.pos += step_vec
		if hit != null:
			# Report resolved missiles separately from the launch sound. A
			# homing target is not necessarily the first body along its path.
			var before := _missile_body_state(hit) if w.kind == "missile" else {}
			_impact(p, hit)
			if w.kind == "missile":
				event.emit("missile_impact", {"projectile": p, "body": hit,
					"before": before, "after": _missile_body_state(hit)})
			continue
		if int(p.life) <= 0:
			if w.kind == "emp" or w.kind == "nuke": _blast(p)
			if w.kind == "missile": event.emit("missile_expired", {"projectile": p})
			continue
		keep.append(p)
	projectiles = keep

## The player's torpedo follows the radar lock; others the nearest ship
## within 15000 units on each axis (RocketGun without a radar).
func _torpedo_mark(p: Dictionary) -> Body:
	var owner: Body = p.owner
	if owner == player:
		return target if locked and target != null and target.alive and target.is_ship() else null
	var best: Body = null
	var best_d := INF
	for b in bodies:
		if b == owner or not b.alive or not b.is_ship() or not b.combat_active: continue
		if b != player and b.faction == owner.faction: continue
		var d: Vector3 = b.pos - p.pos
		if absf(d.x) >= 15000.0 or absf(d.y) >= 15000.0 or absf(d.z) >= 15000.0: continue
		if d.length_squared() < best_d:
			best_d = d.length_squared(); best = b
	return best

func _missile_body_state(body: Body) -> Dictionary:
	return {"hull": body.hull, "armor": body.armor, "shield": body.shield,
		"emp": body.emp, "emp_max": body.emp_max, "disabled": body.disabled,
		"alive": body.alive}

## The first body the projectile's path passes within that body's box.
func _sweep(p: Dictionary, step_vec: Vector3) -> Body:
	var owner: Body = p.owner
	var best: Body = null
	var best_t := 2.0
	for b in bodies:
		if b == owner or not b.alive or not b.solid: continue
		if not b.visible and not b.combat_active: continue
		if b.kind == Body.Kind.STAR or b.kind == Body.Kind.ARRIVAL: continue
		if b.kind == Body.Kind.STATION:
			if _inside_station(p.pos + step_vec): return b
			continue
		if b.kind == Body.Kind.MOTHERSHIP:
			if _inside_mothership(p.pos + step_vec): return b
			continue
		# Ordinary NPC friendly fire stays ignored, but cb.java explicitly
		# permits commanding a non-fixed-friendly ship of the pilot's race.
		# Honour the target captured when this wingman shot was fired; a
		# later order cannot erase in-flight hits or redirect them to allies.
		if owner != player and b != player and b.faction == owner.faction:
			if not (bool(owner.ai.get("wingman", false)) and p.get("target") == b
				and Wingmen.valid_target(self, b)): continue
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
	if hit.kind in [Body.Kind.STATION, Body.Kind.GATE, Body.Kind.MOTHERSHIP]: return
	# Gun.calcCharacterCollision: a rocket or torpedo breaks an asteroid outright.
	if w.kind == "missile" and hit.kind == Body.Kind.ASTEROID:
		_harm(hit, 9999.0, 0.0, p.owner)
		return
	_harm(hit, float(w.damage), float(w.emp), p.owner)

## EMP bombs and nukes: everything within the blast radius takes a share
## falling off with distance.
func _blast(p: Dictionary) -> void:
	var w: Dictionary = p.weapon
	var radius: float = maxf(1.0, float(w.blast))
	effects.append({"kind": "blast", "pos": p.pos, "time": 0.0, "life": 1.2, "radius": radius, "emp": w.kind == "emp"})
	# A nuke goes off with the thunder, an EMP bomb with its own crackle.
	event.emit("sound", {"name": "fx_thunder_01" if w.kind == "nuke" else "wpn_nuke_02"})
	# Gun.ignite: the launcher's own targets only (never its owner); EMP
	# bombs pass asteroids by, nukes break them at 60% of the force.
	for b in bodies:
		if not b.alive or b == p.owner or not (b.is_ship() or b.kind == Body.Kind.ASTEROID): continue
		if w.kind == "emp" and b.kind == Body.Kind.ASTEROID: continue
		var d: float = b.pos.distance_to(p.pos)
		if d >= radius: continue
		var f := clampf((radius - d) / radius, 0.0, 1.0)
		if w.kind == "emp":
			_harm(b, 0.0, (float(w.emp) if w.emp > 0 else 9999.0) * f, p.owner)
		else:
			_harm(b, float(w.damage) * f * (0.6 if b.kind == Body.Kind.ASTEROID else 1.0), float(w.emp) * f, p.owner)

func _harm(b: Body, damage: float, emp_damage: float, source: Body) -> void:
	if not b.combat_active: return
	if b == player and (using_jump_drive and jumping >= 0 or bool(player.ai.get("portal_cinematic", false)) or bool(player.ai.get("probe_cinematic", false))): return
	# Some story allies explicitly reject the player's weapons. A scripted
	# shield must also prevent retaliation and reputation penalties.
	if source == player and bool(b.ai.get("player_protected", false)): return
	var was_alive := b.alive
	if b.kind == Body.Kind.ASTEROID:
		b.hull -= int(ceil(damage))
		if b.hull <= 0:
			_break_asteroid(b)
			if source == player: game.session.add_stat("asteroids_destroyed")
		return
	var was_disabled := b.disabled
	if source == player and b.is_ship() and b != player: _provoke(b, damage, emp_damage)
	b.damage(damage, emp_damage)
	if source == player and b.is_ship() and b != player and not bool(b.ai.get("fixed_friendly", false)):
		# An enemy you hit turns to you.
		if b.hostile: b.ai.target = player
		if b.disabled and not was_disabled:
			# Draining a ship's energy is a wrong against its race; the
			# system's own ships all come for you.
			if _is_local(b): _alarm(b.faction, false)
			if b.faction >= 0 and b.faction <= 3: game.standing_delict(b.faction, 2)
		# Player.damageHP: space junk is no one's kill (not asteroids either).
		if not b.alive and was_alive and not b.is_junk(): game.standing_kill(b.faction, local_race())
	if b == player:
		event.emit("hit", {"from": source.pos if source != null else player.pos})
	if was_alive and not b.alive:
		_destroyed(b, source)

## The race whose system this is: 9 in the void.
func local_race() -> int:
	if in_void: return 9
	return int(cat.system(game.session.system_index).faction)

## A ship of the system's own race, not already set against you by a job
## or a story, whose patience the original measures.
func _is_local(b: Body) -> bool:
	var race := local_race()
	if race < 0 or race > 3 or b.faction != race: return false
	return not b.hostile or bool(b.ai.get("provoked", false))

## The original's friendly-fire rules: a local ship takes a third of its
## hull (or energy) from you before it fights back and warns you over the
## radio; two thirds and the whole race in the system turns on you. Other
## races' ships shrug it off; a kill still costs standing.
func _provoke(b: Body, damage: float, emp_damage: float) -> void:
	if bool(b.ai.get("fixed_friendly", false)) or not _is_local(b): return
	b.ai["hurt"] = float(b.ai.get("hurt", 0.0)) + damage
	b.ai["emp_hurt"] = float(b.ai.get("emp_hurt", 0.0)) + (emp_damage if b.emp > 0 else 0.0)
	var hurt: float = b.ai.hurt
	if hurt > floorf(b.hull_max / 3.0) or (b.emp_max > 0 and float(b.ai.emp_hurt) > floorf(b.emp_max / 3.0)):
		b.ai["provoked"] = true
		b.hostile = true
		b.ai.target = player
		if not friendly_fire_alerted:
			friendly_fire_alerted = true
			_radio_call(b.faction, 247)
	if hurt > b.hull_max - floorf(b.hull_max / 3.0): _alarm(b.faction, true)

## Every ship of the race turns on you; the first time with a call for help.
func _alarm(race: int, call: bool) -> void:
	for s in bodies:
		if s.is_ship() and s != player and s.alive and s.faction == race and not bool(s.ai.get("fixed_friendly", false)):
			s.ai["provoked"] = true
			s.hostile = true
			s.ai.target = player
	if call and not locals_alarmed:
		locals_alarmed = true
		_radio_call(race, 250)

## One of three lines from `first` over the radio, with a face of the race,
## unless a job is under way (the original keeps the channel for it).
func _radio_call(race: int, first: int) -> void:
	if not game.session.job.is_empty() or not RACE_SPEAKERS.has(race): return
	if story != null and not story.message().is_empty(): return
	var speaker: int = RACE_SPEAKERS[race]
	var face := preload("res://src/presentation/portrait.gd").random_face(lib, rng.randi_range(0, 3) != 0, race, rng)
	radio = {"speaker": speaker, "name": lib.text(Catalogue.STRING_SPEAKERS + speaker),
		"text": lib.text(first + rng.randi_range(0, 2)), "face": face}
	radio_until = clock + 6000

func _destroyed(b: Body, source: Body) -> void:
	Wingmen.died(self, b)
	if b.kind == Body.Kind.SHIP and b.faction == 9 and _recurring_wormhole() and not fallen_voids.has(b):
		fallen_voids.append(b)
	effects.append({"kind": "explosion", "pos": b.pos, "time": 0.0, "life": 1.6, "scale": 1.0 if b.kind != Body.Kind.FREIGHTER else 2.5})
	# Ships fade out with distance as in the original; stations do not.
	event.emit("sound", {"name": "fx_explosion_01", "volume": 1.0 if b.kind == Body.Kind.STATION else _distance_volume(b.pos)})
	if b == player:
		event.emit("destroyed", {})
		return
	# A stray projectile can destroy a floating container after its carrier
	# dies. That is not another ship kill and cannot drop the same box again.
	# Keep the destruction visual/event, but not ship accounting or salvage.
	if not b.is_ship():
		b.dead_timer = 1.0
		event.emit("killed", {"body": b})
		return
	# dp.java has a separate junk-death path: no pilot/pirate/contest kill,
	# and a ten-percent chance of a physical 1..10-unit scrap container.
	# The tractor, not destruction, credits that cargo.
	if b.is_junk():
		stats["junk_destroyed"] = int(stats.get("junk_destroyed", 0)) + 1
		game.session.add_stat("junk_destroyed")
		if rng.randi_range(0, 99) < 10:
			_drop(b.pos, 99, rng.randi_range(1, 10), "box")
		b.dead_timer = 1.0
		event.emit("killed", {"body": b})
		return
	if source == player:
		kills += 1
		game.session.add_stat("kills")
		if b.faction == 8: game.session.add_stat("pirates")
	elif source != null and bool(source.ai.get("rival", false)):
		stats["rival_kills"] = int(stats.get("rival_kills", 0)) + 1
	# Original hostile Void fighter deaths replace ordinary trade cargo with
	# 1..3 alien remains (cb.java). The player must still salvage the drop.
	if b.kind == Body.Kind.SHIP and b.faction == 9 and b.hostile:
		b.cargo = [131, rng.randi_range(1, 3)]
	if not b.cargo.is_empty() and not bool(b.ai.get("no_drop", false)):
		_drop_list(b.pos, b.cargo, "box")
		bodies.back().ai["race"] = b.faction
	b.dead_timer = 1.0
	event.emit("killed", {"body": b})

## The original's explosion falloff: full at the player, silent from 40000 units.
func _distance_volume(at: Vector3) -> float:
	return 1.0 - minf(40000.0, at.distance_to(player.pos)) / 40000.0

func _break_asteroid(a: Body) -> void:
	a.alive = false
	effects.append({"kind": "asteroid", "pos": a.pos, "time": 0.0, "life": 1.6, "scale": a.scale.x})
	event.emit("sound", {"name": "fx_explosion_03", "volume": _distance_volume(a.pos)})
	# Ore chunks now and then; class A cores more often. A mined-out
	# asteroid leaves nothing.
	if a.ore >= 154 and a.ore != 164:
		if a.ore_class == 7 and rng.randi_range(0, 99) < 40:
			_drop(a.pos, a.ore + 11, 1, "asteroid")
		elif a.ore_class < 7 and rng.randi_range(0, 99) < 20:
			_drop(a.pos, a.ore, 1 + rng.randi_range(0, 2), "asteroid")

## One container holding every kind the ship carried.
func _drop_list(at: Vector3, pairs: Array, look: String) -> void:
	if pairs.size() < 2: return
	_drop(at, int(pairs[0]), int(pairs[1]), look)
	var box: Body = bodies.back()
	box.cargo = pairs.duplicate()

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
	if not player.alive or docking >= 0 or (using_jump_drive and jumping >= 0) or portal_crossed or portal_arriving() or starting(): return
	if wormhole != null and wormhole.usable() and mining_target == null and jumping < 0 and travelling < 0:
		if player.pos.distance_to(wormhole.pos) < Wormhole.CROSS_RADIUS:
			# Main/o.java: abandoning the active scan through a portal is
			# fatal. The completed result advances to 30 before escape is safe.
			if story != null and story.portal_escape_forbidden():
				player.hull = 0
				player.alive = false
				var failure_event := "probe_escape_failed" if story.step == 29 else "escort_escape_failed"
				event.emit(failure_event, {"clock": story.clock, "step": story.step})
				_destroyed(player, null)
				return
			portal_crossed = true
			_store_ship_state()
			event.emit("wormhole_crossed", {"from_void": in_void, "distance": player.pos.distance_to(wormhole.pos), "step": game.session.story_step})
			return
	# Station: bounce off its modules; flying in with the station targeted docks.
	if _inside_mothership(player.pos):
		var away := (player.pos - mothership.pos).normalized()
		if away.is_zero_approx(): away = -player.forward()
		player.basis = Body.facing(away, player.basis.y)
		player.pos += away * 800.0
	if _inside_station(player.pos, -3500.0):
		if target == station and not in_void and not mission_holds_here():
			_begin_docking()
		else:
			if target == station and mission_holds_here(): _say_held()
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
					game.session.add_stat("asteroids_destroyed")
					if b.size > 30: _harm(player, 40.0, 0.0, null)
			Body.Kind.GATE:
				if player.pos.distance_to(b.pos) < GATE_ZONE and target == b:
					_use_gate()
	# Crates and disabled ships are handled by the tractor, not contact pickup.

func _tractor_step(ms: int) -> void:
	tractor.step(self, ms)

func tractor_status() -> Dictionary:
	return tractor.status()

func _tractor_reach() -> float:
	return 6000.0 if game.session.has_equipped_type(Catalogue.Type.TRACTOR_BEAM) else 0.0

func _collect(l: Body) -> void:
	if not l.alive or l.cargo.size() < 2: return
	var remaining: Array = []
	var took := false
	for i in range(0, l.cargo.size() - 1, 2):
		var item: int = l.cargo[i]
		var count: int = l.cargo[i + 1]
		if count <= 0: continue
		var free: int = game.session.cargo_free()
		if free <= 0:
			remaining.append_array([item, count])
			continue
		var taken := mini(count, free)
		game.session.add_cargo(item, taken)
		game.session.add_stat("cargo_salvaged", taken)
		_salvage_record(item, taken)
		# x.java counts accepted units, not kills, boxes or failed full-hold
		# attempts. Preserve any remainder rather than silently discarding it.
		stats["collected"] = int(stats.get("collected", 0)) + taken
		took = true
		if count > taken: remaining.append_array([item, count - taken])
		event.emit("message", {"text": lib.format(261, {"#Q": str(taken), "#N": cat.item_name(item)})})
	l.cargo = remaining
	l.alive = not remaining.is_empty()
	if not took and not remaining.is_empty(): event.emit("message", {"text": lib.text(159)})

## A wreck crate drifts for 45 seconds, then blows up (the original's crate
## life); ore chunks from asteroids stay.
const CRATE_LIFE_MS := 45000

func _age_crate(l: Body, ms: int) -> void:
	if l.model != "box": return
	l.ai["age_ms"] = int(l.ai.get("age_ms", 0)) + ms
	if int(l.ai.age_ms) > CRATE_LIFE_MS:
		l.alive = false
		l.dead_timer = 1.0
		effects.append({"kind": "explosion", "pos": l.pos, "time": 0.0, "life": 1.0, "scale": 0.4})

## A crate the tractor has pulled in, as KIPlayer.captureCrate takes it: a
## random share (at least one unit, never the whole stack unless it is one)
## of the first cargo it holds. The crate is used up either way; with no
## room in the hold that share is lost.
func _capture_crate(l: Body) -> void:
	if not l.alive: return
	l.alive = false
	var item := -1
	var taken := 0
	for i in range(0, l.cargo.size() - 1, 2):
		var count := int(l.cargo[i + 1])
		if count <= 0: continue
		item = int(l.cargo[i])
		taken = maxi(1, rng.randi_range(0, count - 1))
		break
	l.cargo = []
	if item < 0: return
	var race := int(l.ai.get("race", -1))
	if race >= 0 and race <= 3: game.standing_delict(race, 2)
	if game.session.cargo_free() < taken:
		event.emit("message", {"text": lib.text(159)})
		return
	game.session.add_cargo(item, taken)
	game.session.add_stat("cargo_salvaged", taken)
	_salvage_record(item, taken)
	stats["collected"] = int(stats.get("collected", 0)) + taken
	event.emit("message", {"text": lib.format(261, {"#Q": str(taken), "#N": cat.item_name(item)})})

## Medal records for salvaged goods: Void remains and kinds of drink.
func _salvage_record(item: int, count: int) -> void:
	if item == 131: game.session.add_stat("alien_junk", count)
	elif item >= 132 and item <= 153: Medals.mark(game.session, "drink_types", item - 132)

func _loot(b: Body) -> void:
	if b.cargo.size() < 2 or int(b.cargo[1]) <= 0: return
	if not tractor.authorizes(self, b): return
	var recovery := bool(b.ai.get("recovery_container", false))
	if recovery:
		# A complete physical pull authorizes settlement. Scanner selection
		# alone cannot transfer it, and a canceled/replaced job cannot claim it.
		if story == null or story.job.is_empty() or story.job != game.session.job or story.cast.back() != b: return
		if int(b.cargo[0]) != game.session.recovery_cargo_item() or bool(story.job.get("recovered", false)): return
	if not recovery and b.cargo.size() > 2:
		# A carrier's whole manifest comes aboard in one pull, as far as the
		# hold allows; what does not fit stays with the carrier.
		var shell := Body.new()
		shell.cargo = b.cargo.duplicate()
		_collect(shell)
		b.cargo = shell.cargo
		if b.faction >= 0 and b.faction <= 3: game.standing_delict(b.faction, 2)
		return
	var item: int = b.cargo[0]
	var count: int = mini(int(b.cargo[1]), game.session.cargo_free())
	if count <= 0:
		# KIPlayer.captureCrate loses an entrusted recovery container when
		# its transfer finds no room. Do not silently turn that failure into
		# a later successful pickup. Ordinary salvage remains independent.
		if recovery:
			b.cargo = []
			b.ai["recovery_lost"] = true
		event.emit("message", {"text": lib.text(159)})
		return
	game.session.add_cargo(item, count)
	game.session.add_stat("cargo_salvaged", count)
	_salvage_record(item, count)
	stats["collected"] = int(stats.get("collected", 0)) + count
	if recovery: b.ai["recovery_transferred"] = true
	b.cargo[1] = int(b.cargo[1]) - count
	if int(b.cargo[1]) <= 0: b.cargo = []
	if b.faction >= 0 and b.faction <= 3: game.standing_delict(b.faction, 2)
	# The source mission toast uses the briefing ID even though captureCrate
	# transfers the carrier's opposite ID. Scanner/hold remain physical data.
	var message_item := int(story.job.item) if recovery else item
	event.emit("message", {"text": lib.format(261, {"#Q": str(count), "#N": cat.item_name(message_item)})})

## A freelance fight under way here keeps the pilot in the area: the
## original refuses docking, gates and flights to other planets until the
## mission is won or lost ("Not possible while on a mission"). Deliveries
## and passengers are exempt, and a recovered container is on its way home.
func mission_holds_here() -> bool:
	if story == null or story.job.is_empty() or story.complete or story.failed: return false
	if bool(story.job.get("recovered", false)) or bool(story.job.get("done", false)): return false
	return not int(story.job.get("kind", -1)) in [0, 11]

var _held_said_ms := -100000

func _say_held() -> void:
	if clock - _held_said_ms < 3000: return
	_held_said_ms = clock
	event.emit("message", {"text": lib.text(254)})

func _begin_docking() -> void:
	if docking >= 0: return
	docking = 0
	autopilot = false
	player.basis = Body.facing(station.pos - player.pos, player.basis.y)
	event.emit("docking", {})

func _use_gate() -> void:
	if navigation_locked() or gate == null or target != gate or player.pos.distance_to(gate.pos) >= GATE_ZONE: return
	if mission_holds_here():
		_say_held()
		return
	var dest: Dictionary = game.destination
	var sid := int(dest.get("station", -1))
	if not Navigation.gate_destination(game.session, cat, sid):
		event.emit("gate_menu", {})
		return
	using_jump_drive = false
	jump_destination = {"station": sid, "system": cat.system_of_station(sid)}
	jumping = 0
	autopilot = false
	# The original's jump sound, the same for a gate and the drive.
	event.emit("sound", {"name": "fx_boost_02"})
	event.emit("gate", {})

func navigation_locked() -> bool:
	return (completed_flight or player == null or not player.alive or docking >= 0 or jumping >= 0
		or travelling >= 0 or mining_target != null or portal_crossed or portal_arriving() or starting()
		or (story != null and story.controls_locked))

func drive_error() -> String:
	if navigation_locked(): return "The jump drive is unavailable during this action."
	if not game.session.has_equipped_type(Catalogue.Type.JUMP_DRIVE): return "Fit the jump drive in the hangar first."
	if not Navigation.drive_allowed(game.session): return "The jump drive cannot be used during this mission."
	return ""

## Called only after the player's selection/confirmation. No fuel or credit
## debit exists in the supplied J2ME drive path; do not invent one here.
func jump_to(station_id: int) -> bool:
	if not drive_error().is_empty(): return false
	var destination := Navigation.drive_destination(game.session, cat, station_id)
	if destination.is_empty(): return false
	game.destination = {"station": station_id}
	jump_destination = destination
	using_jump_drive = true
	drive_origin = player.pos
	drive_basis = player.basis
	jumping = 0
	autopilot = false
	event.emit("sound", {"name": "fx_boost_02"})
	event.emit("drive", destination.duplicate())
	return true

## Acting on a locked target that is not a ship.
func _act_on_target() -> void:
	match target.kind:
		Body.Kind.STATION:
			autopilot = true
			event.emit("message", {"text": lib.text(276)})
			event.emit("sound", {"name": "fx_message_05"})
		Body.Kind.GATE:
			autopilot = true
			event.emit("sound", {"name": "fx_message_05"})
		Body.Kind.WORMHOLE:
			if target.visible:
				autopilot = true
				event.emit("sound", {"name": "fx_message_05"})
		Body.Kind.STAR:
			if mission_holds_here():
				_say_held()
				return
			travel_station = target.station_id
			travelling = 0
			game.destination = {"station": travel_station}
			event.emit("sound", {"name": "fx_message_05"})
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
	event.emit("sound", {"name": "fx_message_05"})

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
		event.emit("mining_started", {"ore": a.ore, "class": a.ore_class, "drill": int(laser.id),
			"locked": locked and target == a, "distance": player.pos.distance_to(a.pos)})
		return
	var yaw: float = input.get("yaw", 0.0)
	if mining.step(ms, yaw < -0.3, yaw > 0.3): return
	_finish_mining()

func _finish_mining() -> void:
	var a: Body = mining_target
	var s = game.session
	var result := {"ore": a.ore, "class": a.ore_class, "yield": int(mining.tons),
		"success": mining.success, "accepted_ore": 0, "accepted_core": 0,
		"free_before": s.cargo_free()}
	var amount: int = mini(s.cargo_free(), int(mining.tons))
	if mining.core_found() and s.cargo_free() > 0:
		var core: int = a.ore - 154 + 165
		s.add_cargo(core, 1)
		s.add_stat("cores_mined")
		Medals.mark(s, "core_types", core - Medals.CORE_FIRST)
		result.accepted_core = 1
		event.emit("message", {"text": lib.format(261, {"#Q": "1", "#N": cat.item_name(core)})})
		amount = mini(amount, s.cargo_free())
	if amount > 0:
		s.add_cargo(a.ore, amount)
		s.add_stat("ore_mined", amount)
		Medals.mark(s, "ore_types", a.ore - Medals.ORE_FIRST)
		result.accepted_ore = amount
		event.emit("message", {"text": lib.format(262, {"#Q": str(amount), "#N": cat.item_name(a.ore)})})
	else:
		event.emit("message", {"text": lib.text(263)})
	if s.cargo_free() <= 0: event.emit("message", {"text": lib.text(319), "time": 5.0})
	# A mined asteroid is spent and breaks up.
	a.ore = -1
	_break_asteroid(a)
	mining_target = null
	mining = null
	result.free_after = s.cargo_free()
	event.emit("mining_finished", result)

# ------------------------------------------------------------------ targeting

## The cargo scanner's actual, detached HUD readout. A target pointer alone
## must not reveal unseen inventories; the supplied SHOW_CARGO attribute and
## completed native lock are required. This query never transfers cargo.
func scanned_cargo() -> Dictionary:
	if target == null or not locked or not target.alive or not target.visible or not target.is_ship(): return {}
	if target == player or not bodies.has(target): return {}
	var scanner: Dictionary = game.session.equipped_of_type(Catalogue.Type.SCANNER)
	if scanner.is_empty() or cat.attr(int(scanner.id), Catalogue.A_SCAN_CARGO) != 1: return {}
	if target.cargo.size() < 2 or int(target.cargo[1]) <= 0: return {"item": -1, "count": 0}
	return {"item": int(target.cargo[0]), "count": int(target.cargo[1]), "pairs": target.cargo.duplicate()}

## The original locks whatever sits under the crosshair for long enough; the
## scanner sets how long.
func _targeting(ms: int, input: Dictionary) -> void:
	if not autopilot:
		autopilot_waypoint = false
		autopilot_field = false
	elif autopilot_field:
		# The field is reached once among its rocks.
		if player.pos.distance_to(field_centre) < FIELD_ARRIVAL:
			autopilot = false
			autopilot_field = false
	elif autopilot_waypoint:
		# The route flies on point by point and ends at the last one.
		if mission_waypoint() == null:
			autopilot = false
			autopilot_waypoint = false
	elif (target == null or not target.alive) and course_body() == null:
		# Nothing locked and no destination chosen: nowhere to fly.
		autopilot = false
	if input.get("next_target", false):
		_cycle_target()
		return
	# Flying towards a locked destination must not turn into flying towards
	# an asteroid that crosses the reticle. An explicit target change above
	# still works; switching autopilot off restores ordinary crosshair aiming.
	if autopilot and target != null and target.alive and locked: return
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

## The new game's opening scene: the original's intro locks nothing but the
## ships (its radar picks contexts only once past the intro), so a station or
## planet can never be locked, flown to or docked at from it.
func in_opening() -> bool:
	return story != null and story.step == 0

func _aimed_body() -> Body:
	var best: Body = null
	var best_dot := 0.985
	var fwd := player.forward()
	for b in bodies:
		if in_opening() and not b.is_ship(): continue
		if not b.visible and b.kind != Body.Kind.STAR: continue
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
		if in_opening() and not b.is_ship(): continue
		if not b.visible and b.kind != Body.Kind.STAR: continue
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
	if target != null and not bodies.has(target):
		target = null
		locked = false
		autopilot = false

func hostiles() -> Array:
	return bodies.filter(func(b): return b.alive and b.visible and b.is_ship() and b != player and b.hostile)

# ------------------------------------------------------------------ wormholes

func _step_wormhole(ms: int) -> void:
	if wormhole == null or portal_crossed: return
	if wormhole.tick(ms, _recurring_wormhole(), game.session.story_step, player.pos, rng):
		if target == wormhole:
			autopilot = false
			target = null
			locked = false
		event.emit("wormhole_relocated", {"position": wormhole.pos, "visible": wormhole.visible})
	# dr.b(false) disables its object-collision loop, which also owns portal
	# attraction. The close animation continues while the ship coasts away.
	if portal_arriving() or not wormhole.usable() or mining_target != null or docking >= 0 or jumping >= 0 or travelling >= 0: return
	var gap := wormhole.pos - player.pos
	var distance := gap.length()
	if distance > 0.0 and distance < Wormhole.PULL_RADIUS:
		# The phone applies a pull each 30 Hz frame. Preserve that rate at
		# the native fixed physics frequency rather than doubling it at 60 Hz.
		var pull := (Wormhole.PULL_RADIUS - distance) / 256.0 * ms * 30.0 / 1000.0
		player.pos += gap.normalized() * minf(pull, distance)

func _regenerate_voids(ms: int) -> void:
	if not _recurring_wormhole(): return
	void_regeneration_ms += ms
	if void_regeneration_ms <= 40000: return
	void_regeneration_ms = 0
	# This is the world's periodic sweep, not a per-enemy death timer.
	# Retaining only fallen actors keeps removed explosion bodies eligible.
	for b in fallen_voids:
		if b.alive or b.faction != 9 or b.dead_timer > 0.0: continue
		b.alive = true
		b.visible = true
		b.hull = b.hull_max
		b.armor = b.armor_max
		b.shield = b.shield_max
		b.emp = b.emp_max
		b.disabled = false
		b.emp_timer = 0
		b.dead_timer = 0.0
		b.cargo = []
		b.combat_active = true
		b.ai.target = null
		b.ai.mode = "patrol"
		if in_void:
			# Preserve the source's unusual conditional Z expression rather
			# than silently treating it as an offset about the player.
			var z := 30000.0 if int(player.pos.z) + rng.randi_range(0, 1) == 0 else -30000.0
			b.pos = Vector3(player.pos.x + rng.randi_range(-30000, 29999), player.pos.y + rng.randi_range(-30000, 29999), z)
		elif wormhole != null:
			b.pos = wormhole.pos + Vector3(rng.randi_range(-10000, 9999), rng.randi_range(-10000, 9999), rng.randi_range(-10000, 9999))
		if not bodies.has(b): bodies.append(b)
		event.emit("void_regenerated", {"body": b, "clock": clock})
	fallen_voids = fallen_voids.filter(func(b): return not b.alive)

## How far the engine flames are drawn out: they grow over the first sixth of
## the boost, burn full, and shrink back over the last sixth.
func boost_flare() -> float:
	if not player.boosting or boost_length <= 0: return 0.0
	var t := float(boost_time) / (boost_length / 6.0)
	return t if t < 1.0 else (6.0 - t if t > 5.0 else 1.0)
