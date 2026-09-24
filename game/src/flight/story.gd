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

## Builds the step's scene; returns false when the story has nothing here.
func setup() -> bool:
	if not active() and step > 1: return false
	var table: Dictionary = lib.data.get("campaign", {}).get("radio", {})
	records = table.get(str(step), [])
	fired.resize(records.size()); fired.fill(false)
	finished.resize(records.size()); finished.fill(false)
	match step:
		0: _scene_opening()
		1: _scene_rescue()
		4: _scene_raider()
		7: _scene_hideout()
		_: _scene_mission()
	return true

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

## Step 4: an unarmed pirate raider far out; Keith is to flee to the station.
func _scene_raider() -> void:
	var p := _ship(8, 1, Vector3(0, 0, -200000))
	p.hostile = true
	p.weapons = []
	objective = {"kind": "dock"}

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

## Other story steps: the mission's own kind decides what waits in space.
func _scene_mission() -> void:
	var m: Dictionary = game.session.story_mission
	if m.is_empty(): return
	match int(m.get("kind", -1)):
		4:
			var at := Vector3(space.rng.randi_range(-50000, 50000), 0, space.rng.randi_range(50000, 100000))
			var n := 2 + int(5.0 * float(m.get("difficulty", 3)) / 10.0)
			for i in n:
				var p := _ship(8, space._hull_for(8, false), at)
				p.hostile = true
			objective = {"kind": "destroyed", "from": 0, "to": n}

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

func _shot(target: Body, offset: Vector3) -> void:
	camera_mode = "shot"
	camera_target = target
	camera_offset = offset

func _check_objectives() -> void:
	if complete or objective.is_empty(): return
	match str(objective.kind):
		"destroyed":
			for i in range(int(objective.from), int(objective.to)):
				if _alive(i): return
			complete = true
			game.session.story_mission["done"] = true
			space.event.emit("message", {"text": lib.text(97)})
