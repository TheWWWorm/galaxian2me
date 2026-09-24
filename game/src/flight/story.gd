extends RefCounted
## Story in flight: the imported radio checkpoints of the current step with
## the original's timing (checked every 500 ms, shown 2 s after they trigger,
## on screen for about 2 s per line plus 1.5 s), the step's objectives, and
## native versions of the scenes the original scripts in code (who appears
## where, camera shots keyed to radio lines). Lines, speakers, triggers and
## missions come from the supplied game; the choreography is engine code.

const Body := preload("res://src/flight/body.gd")
const Catalogue := preload("res://src/content/catalogue.gd")

signal radio(line: Dictionary)

var space
var game
var lib
var step := 0
var records: Array = []
var fired: Array = []
var finished: Array = []
var current := -1
var shown_at := 0
var duration := 0
var poll := 0
var clock := 0
var stage := 0
## The scene's cast in the original's order (radio triggers refer to them).
var cast: Array = []
var waypoints: Array = []
var waypoint := 0
var objective := {}
var failure := {}
var complete := false
var failed := false
## Presentation requests read by the view and HUD.
var hud_hidden := false
var controls_locked := false
var camera_mode := "chase"
var camera_target: Body = null
var camera_offset := Vector3.ZERO
var camera_position := Vector3.ZERO
var flash := 0.0

func _init(sim) -> void:
	space = sim
	game = sim.game
	lib = sim.lib
	step = int(game.session.story_step)

func active() -> bool:
	var m: Dictionary = game.session.story_mission
	return not m.is_empty() and int(m.get("station", -2)) in [space.station.station_id, -1]

## Story steps whose scene the original builds by hand.
const STORY_SCENES := [0, 1, 4, 7, 14, 16, 21, 24, 25, 26, 28, 29, 38, 40, 41]
## Freelance kinds that are played out in space at the job's station.
const JOB_SCENES := [1, 2, 3, 4, 5, 6, 7, 9, 10, 12]

var job := {}

## Builds this station's mission scene; returns false when nothing but the
## ordinary traffic belongs here.
func setup() -> bool:
	var here: int = space.station.station_id
	var story_here: bool = step <= 1 or (active() and step in STORY_SCENES)
	var j: Dictionary = game.session.job
	if not story_here:
		if j.is_empty() or int(j.station) != here or not int(j.kind) in JOB_SCENES or bool(j.get("done", false)):
			return false
		job = j
		_clear_traffic()
		_scene_job()
		return true
	var table: Dictionary = lib.data.get("campaign", {}).get("radio", {})
	records = table.get(str(step), [])
	fired.resize(records.size()); fired.fill(false)
	finished.resize(records.size()); finished.fill(false)
	_clear_traffic()
	match step:
		0: _scene_opening()
		1: _scene_rescue()
		4: _scene_raider()
		7: _scene_hideout()
		14: _scene_convoy_attack()
		16, 24, 28: _scene_voids()
		21: _scene_escort_flight()
		25, 29: _scene_void_hunters()
		26: _scene_void_ambush()
		38: _scene_convoy_rescue()
		40, 41: _scene_final()
	return true

func _clear_traffic() -> void:
	space.bodies = space.bodies.filter(func(b): return not b.is_ship() or b == space.player)

# ------------------------------------------------------------------ scenes

func _ship(faction: int, index: int, at: Vector3) -> Body:
	var b: Body = space._spawn_ship(faction, at, false)
	b.ship_index = index
	b.pos = at
	b.ai.home = at
	cast.append(b)
	return b

## Step 0: the ambush that strands Keith. Three pirates wait by the asteroids;
## the camera cuts between them as the narration runs, then the fight, then
## the crash.
func _scene_opening() -> void:
	space.bodies = space.bodies.filter(func(b): return not b.is_ship() or b == space.player)
	var rocks: Array = space.bodies.filter(func(b): return b.kind == Body.Kind.ASTEROID)
	for i in 3:
		var at: Vector3 = rocks[rocks.size() - 1 - i].pos + Vector3(0, 0, 2000) if rocks.size() > i else Vector3(i * 3000, 0, 30000)
		var p := _ship(8, 10, at)
		p.hull = 150; p.hull_max = 150
		p.hostile = true
		p.visible = i != 2
		p.ai.mode = "hold"
	cast[2].pos = Vector3(0, 0, -40000)
	waypoints = [Vector3(0, 0, -30000), Vector3.ZERO]
	space.player.pos = Vector3(0, 0, 120000)
	space.player.hull = 9999999
	space.player.hull_max = 9999999
	hud_hidden = true
	controls_locked = true
	camera_mode = "fixed"
	camera_position = Vector3.ZERO
	camera_target = null
	camera_offset = Vector3(0, 1800, 0)

## Step 1: the drifting wreck is found by Gunant's ship.
func _scene_rescue() -> void:
	space.bodies = space.bodies.filter(func(b): return not b.is_ship() or b == space.player)
	var g := _ship(3, 1, Vector3(300, 50, -8000))
	g.hostile = false
	g.friendly = true
	g.ai.mode = "approach"
	g.ai.waypoint = Vector3(0, 0, -5000)
	space.player.pos = Vector3.ZERO
	space.player.basis = space.player.basis.rotated(Vector3.UP, 0.2)
	hud_hidden = true
	controls_locked = true
	camera_mode = "shot"
	camera_target = space.player
	camera_offset = Vector3(1500, 600, -3000)

## Step 4: a pirate raider waits far out, out of play, until the hold is full.
func _scene_raider() -> void:
	var p := _ship(8, 1, Vector3(0, 0, -200000))
	p.hostile = true
	p.visible = false
	p.ai.mode = "hold"

## Step 7: the pirates' hideout: three pirates on a waypoint, Gunant along.
func _scene_hideout() -> void:
	waypoints = [Vector3(20000, 7000, 120000)]
	for i in 3:
		var p := _ship(8, 2, waypoints[0])
		p.hostile = true
		p.ai.mode = "patrol"
	var g := _ship(3, 1, space.player.pos + Vector3(700, 50, 1000))
	g.hostile = false
	g.friendly = true
	g.hull = 9999999; g.hull_max = 9999999
	g.name = lib.text(Catalogue.STRING_SPEAKERS + 2)
	g.ai.mode = "escort"
	objective = {"kind": "destroyed", "from": 0, "to": 3}

func _rand_sign() -> int:
	return 1 if space.rng.randi_range(0, 1) == 0 else -1

func _far(lo: int, span: int) -> int:
	return (lo + space.rng.randi_range(0, span - 1)) * _rand_sign()

func _freighter(faction: int, at: Vector3) -> Body:
	var b: Body = space._spawn_ship(faction, at, true)
	b.pos = at
	b.ai.home = at
	cast.append(b)
	return b

## Step 14: pirates and a Terran convoy under attack.
func _scene_convoy_attack() -> void:
	var at := Vector3(0, 0, 50000)
	for i in 3: _ship(8, 0, at).hostile = true
	for i in 2: _ship(0, 1, at).friendly = true
	for i in 2: _freighter(0, at).friendly = true
	objective = {"kind": "radio_end"}

## Steps 16, 24, 28: Void fighters where the story sends Keith.
func _scene_voids() -> void:
	var at := Vector3(0, 0, 130000) if step == 16 else (Vector3(100000, 0, 0) if step == 24 else Vector3(0, 0, 90000))
	var n := 4 if step == 16 else (3 if step == 24 else 5)
	for i in n:
		var v := _ship(9, 8, at)
		v.hostile = true
	if step == 16:
		for i in 3:
			var w := _ship(0, 1, space.player.pos + Vector3(space.rng.randi_range(-2000, 2000), space.rng.randi_range(-1700, 1700), 2000))
			w.friendly = true
			w.ai.mode = "escort"
	objective = {"kind": "destroyed", "from": 0, "to": n}

## Step 21: an escort flight with two Terran fighters and a named ship.
func _scene_escort_flight() -> void:
	var at := Vector3(40000, -40000, 120000)
	var lead := _ship(0, 1, at)
	lead.name = lib.text(Catalogue.STRING_SPEAKERS + 14)
	for i in 2: _ship(0, 0, at)
	for b in cast:
		b.hostile = false
		b.ai.mode = "patrol"
	objective = {"kind": "radio_end"}

## Steps 25 and 29: Voids roaming the void system.
func _scene_void_hunters() -> void:
	for i in 3:
		var v := _ship(9, 8, Vector3(_far(20000, 80000), _far(20000, 80000), _far(20000, 80000)))
		v.hostile = true
	objective = {"kind": "destroyed", "from": 0, "to": 3}

## Step 26: two Voids jump the player.
func _scene_void_ambush() -> void:
	for i in 2:
		var v := _ship(9, 8, space.player.pos + Vector3(space.rng.randi_range(-700, 700), space.rng.randi_range(-700, 700), 2000))
		v.hostile = true
	objective = {"kind": "destroyed", "from": 0, "to": 2}

## Step 38: two freighters and their Midorian captors.
func _scene_convoy_rescue() -> void:
	var at := Vector3(0, 10000, 50000)
	for i in 2:
		var f := _freighter(2, at + Vector3(space.rng.randi_range(-10000, 10000), space.rng.randi_range(-10000, 10000), space.rng.randi_range(-10000, 10000)))
		f.friendly = true
	for i in 5:
		_ship(3, space._hull_for(3, false), at).hostile = true
	objective = {"kind": "destroyed", "from": 2, "to": 7}
	failure = {"kind": "destroyed", "from": 0, "to": 2}

## Steps 40 and 41: the escort to the wormhole and the Void mothership fight.
func _scene_final() -> void:
	var escort := _freighter(0 if step == 40 else 1, Vector3(-20000, -3000, 65000))
	escort.name = lib.text(Catalogue.STRING_SPEAKERS + 7)
	escort.friendly = true
	escort.hull *= 4; escort.hull_max = escort.hull
	for i in 4:
		var w := _ship(0, 1, escort.pos)
		w.friendly = true
		w.ai.mode = "escort"
	for i in 4:
		_ship(9, 8, Vector3(-20000, -3000, 200000)).hostile = true
	objective = {"kind": "radio_end"}
	failure = {"kind": "destroyed", "from": 0, "to": 1}

# ------------------------------------------------------------------ jobs

## Freelance scenes as the original sets them up for each job kind.
func _scene_job() -> void:
	var d := int(job.get("difficulty", 1))
	var client_race := int(job.get("race", 0))
	var rival: int = 8 if space.rng.randi_range(0, 99) < 75 else space._rival(client_race)
	match int(job.kind):
		4:
			var at := Vector3(space.rng.randi_range(-50000, 50000), 0, space.rng.randi_range(50000, 100000))
			var n := 2 + int(5.0 * d / 10.0)
			for i in n: _ship(8, space._hull_for(8, false), at).hostile = true
			objective = {"kind": "destroyed", "from": 0, "to": n}
		7:
			var at := Vector3(space.rng.randi_range(-20000, 20000), 0, space.rng.randi_range(20000, 60000))
			var pirates := int(2.0 * d / 10.0)
			var junk := 15 + int(35.0 * d / 10.0)
			for i in junk:
				var j := Body.new()
				j.kind = Body.Kind.SHIP
				j.model = "spacejunk"
				j.ship_index = -1
				j.hull = 1; j.hull_max = 1
				j.faction = -1
				j.radius = 1000.0
				j.name = lib.text(186)
				j.pos = at + Vector3(space.rng.randi_range(-10000, 10000), space.rng.randi_range(-10000, 10000), space.rng.randi_range(-10000, 10000))
				j.ai = {"mode": "hold"}
				space.bodies.append(j)
				cast.append(j)
			for i in pirates: _ship(8, space._hull_for(8, false), Vector3.ZERO).hostile = true
			objective = {"kind": "destroyed", "from": 0, "to": junk}
			failure = {"kind": "timer", "ms": 121000}
		6:
			var boss := _ship(8, space._hull_for(8, false), Vector3(_far(60000, 80000), 0, _far(60000, 80000)))
			boss.hostile = true
			boss.name = str(job.get("wanted", boss.name))
			boss.hull = d * mini(int(game.session.stat("rank")), 20) + 300
			boss.hull_max = boss.hull
			objective = {"kind": "destroyed", "from": 0, "to": 1}
		1:
			var attackers := 3 + int(5.0 * d / 10.0)
			for i in attackers:
				_ship(rival, space._hull_for(rival, false), Vector3(space.rng.randi_range(-50000, 50000), 0, _far(50000, 50000))).hostile = true
			for i in 2 + space.rng.randi_range(0, 5):
				_ship(int(space.station.faction), space._hull_for(int(space.station.faction), false), Vector3.ZERO).friendly = true
			objective = {"kind": "destroyed", "from": 0, "to": attackers}
		2:
			var attackers := 2 + int(4.0 * d / 10.0)
			var point := Vector3(_far(20000, 20000), 0, _far(20000, 20000))
			for i in attackers:
				_ship(rival, space._hull_for(rival, false), point + Vector3(i * 2000, i * 2000, i * 2000)).hostile = true
			var rocks: Array = space.bodies.filter(func(b): return b.kind == Body.Kind.ASTEROID)
			for i in int(job.get("count", 2)):
				var at: Vector3 = rocks[rocks.size() / 2 + i].pos + Vector3(0, 2000, 0) if rocks.size() > rocks.size() / 2 + i else Vector3(i * 3000, 0, 20000)
				var miner := _freighter(int(space.station.faction), at)
				miner.friendly = true
				miner.ai.mode = "hold"
				miner.hull *= 3; miner.hull_max = miner.hull
			objective = {"kind": "destroyed", "from": 0, "to": attackers}
			failure = {"kind": "destroyed", "from": attackers, "to": attackers + int(job.get("count", 2))}
		9:
			var attackers := 2 + int(6.0 * d / 10.0)
			for i in attackers:
				_ship(rival, space._hull_for(rival, false), Vector3(10000, 0, 100000 + i * 50000)).hostile = true
			var spots := [Vector3(-2500, -300, 27000), Vector3(6500, 3000, 24000), Vector3(-4000, -2000, 19000), Vector3(9000, -6000, 17000), Vector3(3000, 7000, 15000)]
			for p in spots:
				var f := _freighter(client_race, p)
				f.friendly = true
				f.ai.mode = "hold"
			objective = {"kind": "destroyed", "from": 0, "to": attackers}
			failure = {"kind": "destroyed", "from": attackers, "to": attackers + 5}
		10:
			var route := Vector3(space.rng.randi_range(-2500, 2500), space.rng.randi_range(-2500, 2500), 120000 + space.rng.randi_range(0, 30000))
			var freighters: int = 2 + space.rng.randi_range(0, 1)
			for i in freighters:
				var f := _freighter(rival, route + Vector3(space.rng.randi_range(-10000, 10000), space.rng.randi_range(-10000, 10000), space.rng.randi_range(-10000, 10000)))
				f.hostile = true
			for i in 2 + int(2.0 * d / 10.0):
				_ship(rival, space._hull_for(rival, false), route).hostile = true
			objective = {"kind": "destroyed", "from": 0, "to": freighters}
		3, 5:
			var at := Vector3(_far(40000, 80000), 0, _far(40000, 80000))
			var n := maxi(1, int(job.get("count", 2)))
			for i in n: _ship(8, space._hull_for(8, false), at).hostile = true
			# The last ship carries the container: disable it with EMP and
			# take the cargo; shooting it down loses the container.
			var carrier: Body = cast[n - 1]
			carrier.name = lib.text(833)
			carrier.cargo = [int(job.get("item", 116)), 1]
			carrier.ai["no_drop"] = true
			objective = {"kind": "collected", "item": int(job.get("item", 116))}
			failure = {"kind": "lost", "index": n - 1, "item": int(job.get("item", 116))}
		12:
			var pirates := 3 + int(4.0 * d / 10.0)
			if pirates % 2 == 0: pirates += 1
			var rival_pilot := _ship(client_race, space._hull_for(client_race, false), space.player.pos + Vector3(space.rng.randi_range(-700, 700), 0, 1000))
			rival_pilot.name = str(job.client)
			rival_pilot.hull = 9999999; rival_pilot.hull_max = 9999999
			rival_pilot.hostile = false
			rival_pilot.ai.mode = "patrol"
			rival_pilot.ai["rival"] = true
			for i in pirates:
				_ship(8, space._hull_for(8, false), Vector3(_far(50000, 30000), space.rng.randi_range(-10000, 10000), 50000 + i * 20000)).hostile = true
			objective = {"kind": "challenge", "from": 1, "to": pirates + 1}

# ------------------------------------------------------------------ running

func step_scene(ms: int) -> void:
	clock += ms
	poll += ms
	if current >= 0:
		if clock > shown_at + 2000 + duration:
			finished[current] = true
			current = -1
	elif poll > 500:
		poll = 0
		for i in records.size():
			if fired[i]: continue
			if _triggered(i):
				fired[i] = true
				current = i
				shown_at = clock
				var rec: Array = records[i]
				var text: String = lib.text(int(rec[0]))
				duration = _lines(text) * 2000 + 1500
				break
	match step:
		0: _run_opening(ms)
		1: _run_rescue(ms)
	_check_objectives()
	flash = maxf(0.0, flash - ms / 1000.0)

func _lines(text: String) -> int:
	var n := 0
	for para in text.split("\n"):
		n += maxi(1, int(ceil(para.length() / 36.0)))
	return n

## The radio line on screen now: {speaker, name, text, face} or {}.
func message() -> Dictionary:
	if current < 0 or clock < shown_at + 2000: return {}
	var rec: Array = records[current]
	var speaker: int = rec[1]
	return {"speaker": speaker, "name": lib.text(Catalogue.STRING_SPEAKERS + speaker), "text": lib.text(int(rec[0]))}

func skip_message() -> void:
	if current >= 0 and clock >= shown_at + 2000:
		finished[current] = true
		current = -1

func _alive(i: int) -> bool:
	return i < cast.size() and cast[i].alive

func _dead(i: int) -> bool:
	return i < cast.size() and not cast[i].alive

## The original's trigger kinds, on the scene's cast.
func _triggered(i: int) -> bool:
	var rec: Array = records[i]
	var kind: int = rec[2]
	var param = rec[3]
	var list: Array = param if param is Array else [param]
	match kind:
		0: return waypoint > int(param)
		1:
			for k in list:
				if _dead(int(k)): return true
			return false
		3: return space.hostiles().is_empty()
		5: return clock >= int(param)
		6: return int(param) < finished.size() and finished[int(param)]
		9:
			for k in list:
				if not _dead(int(k)): return false
			return true
		12, 19:
			var limit := 0.5 if kind == 12 else 0.75
			for k in list:
				if int(k) < cast.size() and float(cast[int(k)].hull) < float(cast[int(k)].hull_max) * limit: return true
			return false
		15:
			for b in cast:
				if not b.alive and not b.hostile: return true
			return false
		17:
			for j in cast.size():
				if j != int(param) and cast[j].alive and not cast[j].hostile: return false
			return true
		20:
			var n := 0
			for b in cast:
				if not b.alive: n += 1
			return n >= int(param)
		22: return int(space.stats.get("collected", 0)) >= int(param)
		23: return space.target != null and space.target.kind == Body.Kind.STATION
		24: return int(param) < cast.size() and not cast[int(param)].visible and cast[int(param)].alive
	return false

func _done(i: int) -> bool:
	return i < finished.size() and finished[i]

func _fired(i: int) -> bool:
	return i < fired.size() and fired[i]

## Step 0 choreography, keyed to the radio lines as the original keys it.
func _run_opening(ms: int) -> void:
	if not _fired(1):
		camera_offset = Vector3(0, 1800 + clock * 0.06, 0)
		return
	match stage:
		0:
			controls_locked = true
			space.player.basis = Basis.IDENTITY.rotated(Vector3.UP, PI)
			camera_mode = "look"
			camera_position = Vector3(-1000, -500, 110000)
			camera_target = space.player
			stage = 1
		1:
			if _done(2):
				_shot(cast[0], Vector3(1000, 700, 1500)); stage = 2
		2:
			if _done(3):
				_shot(cast[1], Vector3(-2300, 300, 200)); stage = 3
		3:
			if _done(5):
				cast[2].visible = true
				_shot(cast[2], Vector3(1000, 200, 6000)); stage = 4
		4:
			if _done(6):
				_shot(cast[1], Vector3(-1300, 300, 1700)); stage = 5
		5:
			if _done(7):
				hud_hidden = false
				controls_locked = false
				camera_mode = "chase"
				stage = 6
				space.event.emit("music", {"name": "gof2_gaction"})
		6:
			if _done(8):
				for b in cast:
					b.visible = true
					b.ai.mode = "patrol"
				stage = 7
		7:
			if _fired(10):
				# The crash: control is lost and the guns go dead.
				hud_hidden = true
				controls_locked = true
				space.player.weapons = []
				camera_mode = "look"
				camera_position = space.player.pos + Vector3(1000, -200, -60000)
				camera_target = space.player
				stage = 8
		8:
			if _done(12):
				flash = 1.0
				stage = 9
		9:
			space.player.basis = space.player.basis.rotated(Vector3(1, 1, 1).normalized(), ms / 1000.0 * 0.8).orthonormalized()
			if _done(16): stage = 10
		10:
			camera_position = space.player.pos + Vector3(-1000, -700, -1500)
			if _done(14):
				camera_position = space.player.pos + Vector3(1000, 200, 15000)
				stage = 11
	if stage >= 9 and stage < 11:
		space.player.basis = space.player.basis.rotated(Vector3.RIGHT, ms / 2000.0).orthonormalized()
	if _done(records.size() - 1):
		complete = true
		space.event.emit("story_next", {"to": "flight"})

## Step 1: Gunant's ship closes in on the wreck, then the story moves to the
## station.
func _run_rescue(ms: int) -> void:
	space.player.basis = space.player.basis.rotated(Vector3.UP, ms / 8000.0).orthonormalized()
	if cast.size() > 0:
		var g: Body = cast[0]
		if g.pos.z < -1800.0:
			g.pos.z += ms * 0.5
		g.ai.mode = "hold"
	if _done(2) or (records.size() > 0 and _done(records.size() - 1)):
		complete = true
		space.event.emit("story_next", {"to": "station"})

## The story moved on while in space. Step 5: the raider waiting far out
## comes in on the player, as the original moves it next to the ship.
func step_changed(new_step: int) -> void:
	if new_step == 5 and step == 4 and cast.size() > 0:
		var raider: Body = cast[0]
		raider.pos = space.player.pos + Vector3(5000, 0, 30000)
		raider.basis = Basis(Vector3.UP, PI)
		raider.visible = true
		raider.ai.mode = "patrol"
		raider.ai.target = space.player
	step = new_step

func _shot(target: Body, offset: Vector3) -> void:
	camera_mode = "shot"
	camera_target = target
	camera_offset = offset

func _check_objectives() -> void:
	if complete or failed: return
	if _met(failure):
		failed = true
		_fail()
		return
	if objective.is_empty() or not _met(objective): return
	complete = true
	if not job.is_empty():
		_job_done()
	else:
		game.session.story_mission["done"] = true
		space.event.emit("message", {"text": lib.text(97), "time": 5.0})

func _met(goal: Dictionary) -> bool:
	if goal.is_empty(): return false
	match str(goal.kind):
		"destroyed":
			for i in range(int(goal.from), int(goal.to)):
				if _alive(i): return false
			return true
		"timer":
			return clock >= int(goal.ms)
		"collected":
			return game.session.cargo_count(int(goal.item)) > 0
		"radio_end":
			return records.size() > 0 and _done(records.size() - 1)
		"challenge":
			for i in range(int(goal.from), int(goal.to)):
				if _alive(i): return false
			return true
		"lost":
			return _dead(int(goal.index)) and game.session.cargo_count(int(goal.item)) == 0
	return false

## A freelance job done in space: the client pays and the player's standing
## with the client's people improves.
func _job_done() -> void:
	var s = game.session
	var mine := int(space.kills)
	var theirs := int(space.stats.get("rival_kills", 0))
	if int(job.kind) == 12 and mine <= theirs:
		_fail()
		return
	s.credits += int(job.reward)
	s.add_stat("jobs")
	_standing_up(int(job.get("race", 0)))
	s.job = {}
	var text: String = lib.text(195 + space.rng.randi_range(0, 4))
	if int(job.kind) == 12:
		text = lib.text(192).replace("#Q1", str(mine)).replace("#Q2", str(theirs))
	space.event.emit("message", {"text": lib.text(97) + "  +" + preload("res://src/presentation/ui.gd").money(int(job.reward)), "time": 6.0})
	space.event.emit("job_report", {"name": str(job.client), "face": job.get("face", []), "text": text})

func _standing_up(race: int) -> void:
	var rep: Array = game.session.reputation
	match race:
		0: rep[0] = clampi(int(rep[0]) + 2, -100, 100)
		1: rep[0] = clampi(int(rep[0]) - 2, -100, 100)
		2: rep[1] = clampi(int(rep[1]) - 2, -100, 100)
		3: rep[1] = clampi(int(rep[1]) + 2, -100, 100)

func _fail() -> void:
	if not job.is_empty():
		game.session.job = {}
		game.session.add_stat("jobs_failed")
		space.event.emit("job_report", {"name": str(job.client), "face": job.get("face", []),
			"text": lib.text(206 + space.rng.randi_range(0, 4)) + "\n\n" + lib.text(213)})
	space.event.emit("message", {"text": lib.text(213), "time": 6.0})
