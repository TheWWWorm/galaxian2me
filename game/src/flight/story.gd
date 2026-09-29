extends RefCounted
## Story in flight: the imported radio checkpoints of the current step with
## the original's timing (checked every 500 ms, shown 2 s after they trigger,
## on screen for about 2 s per line plus 1.5 s), the step's objectives, and
## native versions of the scenes the original scripts in code (who appears
## where, camera shots keyed to radio lines). Lines, speakers, triggers and
## missions come from the supplied game; the choreography is engine code.

const Body := preload("res://src/flight/body.gd")
const Catalogue := preload("res://src/content/catalogue.gd")
const AI := preload("res://src/flight/ai.gd")

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
## Only player mission routes, never NPC patrol paths or map destinations.
## Every job kind and story scene the original gives a route sets one.
var wingman_route: Array = []
var wingman_route_index := 0
var objective := {}
var failure := {}
var complete := false
var failed := false
## Presentation requests read by the view and HUD.
var hud_hidden := false
## Only the crosshair and the ship markers are up: the opening's fight.
var radar_only := false
## The ship is held where it is (the original's setFreeze): no flight at all.
var frozen := false
var controls_locked := false
var camera_mode := "chase"
var camera_target: Body = null
var camera_offset := Vector3.ZERO
var camera_position := Vector3.ZERO
var flash := 0.0
## The supplied probe shot is presentation, not purchased ammunition.
var probe_visible := false
var probe_position := Vector3.ZERO
var probe_basis := Basis.IDENTITY
var probe_started_at := -1
const PROBE_SCAN_MS := 180000
## The original's turn for the opening (Euler Y Q_PI_HALF, which is 2048 of
## the engine's 4096 per revolution: half a turn). From its start at z 120 000
## the ship heads back along -z, towards the waiting pirates.
const HALF_TURN := Basis(Vector3(-1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, -1))
const FINAL_ESCAPE_MS := 60000
var escape_started_at := -1

func _init(sim) -> void:
	space = sim
	game = sim.game
	lib = sim.lib
	step = int(game.session.story_step)

func active() -> bool:
	var m: Dictionary = game.session.story_mission
	# cf.java selects kind25 at the saved portal address. Its -1 mission
	# station is not a wildcard and must not start this escort in the Void.
	if step == 40 and int(m.get("kind", -1)) == 25:
		var s = game.session
		var portal_station := int(s.flags.get("wormhole_station", -1))
		return not s.in_void and portal_station >= 0 and s.station_id == portal_station
	return not m.is_empty() and int(m.get("station", -2)) == game.session.location_id()

## Story steps whose scene the original builds by hand.
const STORY_SCENES := [0, 1, 4, 7, 14, 16, 21, 24, 25, 26, 28, 29, 36, 38, 40, 41]
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
		if j.is_empty() or int(j.station) != here or not int(j.kind) in JOB_SCENES or bool(j.get("done", false)) or bool(j.get("recovered", false)):
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
		16: _scene_voids()
		28: _scene_void_entry()
		24: _scene_void_salvage()
		21: _scene_escort_flight()
		25, 29: _scene_void_hunters()
		26: _scene_void_ambush()
		36: _scene_challenge()
		38: _scene_convoy_rescue()
		40, 41: _scene_final()
	# The player's mission route: the supplied scenes' single route points
	# and the challenge course.
	match step:
		7, 21: wingman_route = waypoints.duplicate()
		36: wingman_route = CHALLENGE_ROUTE.duplicate()
	return true

func wingman_waypoint():
	if complete or failed or wingman_route_index >= wingman_route.size(): return null
	return wingman_route[wingman_route_index]

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
		# All three are in sight from the start; only their engines are out.
		p.exhaust = false
		p.ai.mode = "hold"
	cast[2].pos = Vector3(0, 0, -40000)
	waypoints = [Vector3(0, 0, -30000), Vector3.ZERO]
	# The first two keep the fighters' default square about the origin; the
	# third flies in along its own route.
	for i in 2: cast[i].ai.route = AI.patrol_route(false)
	cast[2].ai.route = waypoints.duplicate()
	space.player.pos = Vector3(0, 0, 120000)
	space.player.hull = 9999999
	space.player.hull_max = 9999999
	hud_hidden = true
	controls_locked = true
	frozen = true
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
	space.player.exhaust = false
	hud_hidden = true
	controls_locked = true
	frozen = true
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
	# Gunant leads the imported tutorial route; he is not a close formation
	# wingman parked in front of the player's gun. His briefing promises that
	# the player's weapons cannot penetrate his shields.
	g.ai.mode = "patrol"
	g.ai.route = waypoints
	g.ai.player_protected = true
	objective = {"kind": "destroyed", "from": 0, "to": 3}

func _rand_sign() -> int:
	return 1 if space.rng.randi_range(0, 1) == 0 else -1

## A mission route as the original draws it: each point lies 50,000 to
## 80,000 to one side and 50,000 to 80,000 further on than the one before.
func _create_route(length: int) -> Array:
	var out: Array = []
	var z := 0
	for i in length:
		var x := _far(50000, 30000)
		var y: int = -10000 + space.rng.randi_range(0, 19999)
		z += 50000 + space.rng.randi_range(0, 29999)
		out.append(Vector3(x, y, z))
	return out

func _far(lo: int, span: int) -> int:
	return (lo + space.rng.randi_range(0, span - 1)) * _rand_sign()

## The supplied fighter constructor scatters each coordinate by
## nextInt(40000)-20000. A null route point means the origin, not a far camp.
## A fighter asleep at its route point (the original's setToSleep): it
## waits there until the player comes within sight.
func _sleeper(faction: int, around: Vector3) -> Body:
	var b := _defense_fighter(faction, around)
	b.ai.mode = "encounter_wait"
	b.combat_active = false
	return b

func _defense_fighter(faction: int, around: Vector3) -> Body:
	var offset := Vector3(space.rng.randi_range(-20000, 19999), space.rng.randi_range(-20000, 19999), space.rng.randi_range(-20000, 19999))
	return _ship(faction, space._hull_for(faction, false), around + offset)

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

## Step 28: the portal, not a fabricated kill-all goal, is the objective.
## ed.java scatters five fighters around the portal's actual position.
func _scene_void_entry() -> void:
	if space.wormhole == null: return
	for i in 5:
		var offset := Vector3(space.rng.randi_range(-20000, 19999), space.rng.randi_range(-20000, 19999), space.rng.randi_range(-20000, 19999))
		_ship(9, 8, space.wormhole.pos + offset).hostile = true

## Step 16: the Alioth fight and its Terran wingmen.
func _scene_voids() -> void:
	var at := Vector3(0, 0, 130000) if step == 16 else Vector3(0, 0, 90000)
	var n := 4 if step == 16 else 5
	for i in n:
		var v := _ship(9, 8, at)
		v.hostile = true
	if step == 16:
		for i in 3:
			# The supplied Alioth scene gives these three wingmen 600 hull,
			# not the rank-scaled durability of ordinary traffic (ed.java).
			var offset := Vector3(space.rng.randi_range(-2000, 1999), space.rng.randi_range(-1700, 1699), space.rng.randi_range(0, 3999))
			var w := _ship(0, 1, space.player.pos + offset)
			w.friendly = true
			w.hostile = false
			w.hull = 600; w.hull_max = 600
			# Original ak.b(true) is a fixed-friendly override; cb applies it
			# after retaliation. It is not invulnerability to friendly fire.
			w.ai.fixed_friendly = true
			w.ai.mode = "escort"
			w.ai.escort_offset = offset
	objective = {"kind": "destroyed", "from": 0, "to": n}

## Step 24: three routed Void fighters, then salvage and Carla's radio.
## ed.java's cl(22) waits for the LAST radio, not the last destroyed ship.
## The supplied first radio checks three accepted cargo units in this flight.
func _scene_void_salvage() -> void:
	if space.wormhole != null: space.wormhole.visible = false
	waypoints = [Vector3(100000, 0, 0), Vector3(100000, 0, -30000)]
	for i in 3:
		var offset := Vector3(space.rng.randi_range(-20000, 19999), space.rng.randi_range(-20000, 19999), space.rng.randi_range(-20000, 19999))
		var ship := _ship(9, 8, waypoints[0] + offset)
		ship.hostile = true
		ship.ai.route = waypoints.duplicate()
	objective = {"kind": "radio_end"}

## Step 21: disable the named ship with EMP, without destroying it. The
## supplied scene waits at a single route point with two Terran companions.
func _scene_escort_flight() -> void:
	var at := Vector3(40000, -40000, 120000)
	waypoints = [at]
	var lead := _ship(0, 1, at)
	lead.name = lib.text(Catalogue.STRING_SPEAKERS + 14)
	for i in 2: _ship(0, 0, at)
	for b in cast:
		b.hostile = false
		# The original createShip scatters each hull within 20,000 units of
		# the shared waypoint; the ships must not occupy the same position.
		b.pos += Vector3(space.rng.randi_range(-20000, 19999), space.rng.randi_range(-20000, 19999), space.rng.randi_range(-20000, 19999))
		b.basis = Basis(Vector3.UP, PI)
		b.combat_active = false
		b.ai.mode = "encounter_wait"
		b.ai.route = waypoints
	objective = {"kind": "radio_end"}
	# ed.java's cl(7, 1): only the first, named actor must survive.
	failure = {"kind": "destroyed", "from": 0, "to": 1}

## Steps 25 and 29: Voids roaming the void system.
func _scene_void_hunters() -> void:
	for i in 3:
		var v := _ship(9, 8, Vector3(_far(20000, 80000), _far(20000, 80000), _far(20000, 80000)))
		v.hostile = true
	# The supplied scene creates opponents, not a destroy-all requirement.
	# Step 25 is the campaign's ten-second arrival at world -1.
	objective = {}

## Step 26: two Voids jump the player.
func _scene_void_ambush() -> void:
	for i in 2:
		var v := _ship(9, 8, space.player.pos + Vector3(space.rng.randi_range(-700, 699), space.rng.randi_range(-700, 699), 2000))
		# ed.java copies the arriving player's basis before placing each
		# fighter. Do not retain the generic traffic's randomized heading.
		v.basis = space.player.basis
		v.hostile = true
	# cl(7, 2) checks x.boolean_e(): completed death, not merely zero hull.
	objective = {"kind": "destroyed", "from": 0, "to": 2, "settled_deaths": true}

## Step 36: Errkt Uggut's contest. Seven pirates spread over the original's
## four route points; whoever shoots down more of them wins. The briefing's
## first speaker is the rival.
const CHALLENGE_ROUTE := [Vector3(80000, -20000, 80000), Vector3(70000, 0, -80000),
	Vector3(-100000, 10000, -80000), Vector3(-80000, 20000, 90000)]

func _scene_challenge() -> void:
	var brief: Array = game.campaign.dialogue(step, 0)
	var speaker: int = int(brief[0].speaker) if not brief.is_empty() else 0
	var rival_pilot := _ship(1, space._hull_for(1, false), space.player.pos + Vector3(space.rng.randi_range(-700, 699), space.rng.randi_range(-700, 699), 1000))
	rival_pilot.name = lib.text(Catalogue.STRING_SPEAKERS + speaker)
	rival_pilot.hull = 9999999; rival_pilot.hull_max = 9999999
	rival_pilot.hostile = false
	rival_pilot.friendly = true
	rival_pilot.ai.mode = "patrol"
	rival_pilot.ai["rival"] = true
	rival_pilot.ai["route"] = CHALLENGE_ROUTE
	for i in 7:
		_ship(8, space._hull_for(8, false), CHALLENGE_ROUTE[space.rng.randi_range(0, 3)]).hostile = true
	objective = {"kind": "challenge", "from": 1, "to": 8}

## Step 38: two freighters and their Midorian captors.
func _scene_convoy_rescue() -> void:
	var at := Vector3(0, 10000, 50000)
	for i in 2:
		var f := _freighter(2, at + Vector3(space.rng.randi_range(-10000, 9999), space.rng.randi_range(-10000, 9999), space.rng.randi_range(-10000, 9999)))
		f.friendly = true
		f.hostile = false
		# The supplied scene fixes allegiance and disables freighter motion.
		# Zero speed also preserves that stationary state while EMP-disabled.
		f.ai.mode = "hold"
		f.ai.fixed_friendly = true
		f.speed = 0.0
	for i in 5:
		var offset := Vector3(space.rng.randi_range(-20000, 19999), space.rng.randi_range(-20000, 19999), space.rng.randi_range(-20000, 19999))
		var captor := _ship(3, space._hull_for(3, false), at + offset)
		captor.hostile = true
		# Original state five waits for the player to enter the sight box.
		captor.combat_active = false
		captor.ai.mode = "encounter_wait"
	# Both conditions count finished deaths: all five captors for success,
	# both freighters for failure. Losing only one freighter is not failure.
	objective = {"kind": "destroyed", "from": 2, "to": 7, "settled_deaths": true}
	failure = {"kind": "destroyed", "from": 0, "to": 2, "settled_deaths": true}

## Two distinct final escorts. Actor order, routes and radio records follow
## the supplied scenes; scene40 has NO radio-based success condition.
func _scene_final() -> void:
	var origin := Vector3(-20000, -3000, 65000) if step == 40 else Vector3(0, 0, -200000)
	var escort := _freighter(0 if step == 40 else 1, origin)
	escort.ship_index = 13
	escort.name = lib.text(826)
	escort.friendly = true
	escort.hostile = false
	escort.ai.fixed_friendly = true
	escort.ai.mode = "final_freighter"
	escort.speed = 1.0
	escort.basis = Basis.IDENTITY
	escort.cargo = []
	failure = {"kind": "destroyed", "from": 0, "to": 1, "settled_deaths": true}
	if step == 40:
		escort.hull = 1200 + 5 * int(game.session.stat("rank"))
		escort.hull_max = escort.hull
		var portal := Vector3(-20000, -3000, 200000)
		for i in 4:
			var wingman := _ship(0, space._hull_for(0, false), _final_scatter(Vector3.ZERO))
			wingman.friendly = true
			wingman.hostile = false
			wingman.ai.fixed_friendly = true
			wingman.ai.route = [origin, portal]
			if i == 1: wingman.name = lib.text(827)
		for i in 4:
			var enemy := _ship(9, 8, _final_scatter(portal))
			enemy.hostile = true
		space.wormhole.pos = portal
		space.wormhole.reveal()
		if space.entry_mode in ["jump", "travel", "wormhole"]:
			space.player.pos = Vector3(-65000, 0, 80000)
			space.player.basis = Basis(Vector3.UP, PI * 0.5)
	else:
		# Main/o.java carries actual remaining health through the crossing;
		# ak.b raises the new maximum only when that health exceeds it.
		escort.hull = int(game.session.flags.get("final_escort_hull", 0))
		escort.hull_max = maxi(escort.hull_max, escort.hull)
		if escort.hull <= 0:
			escort.alive = false
			escort.speed = 0.0
		for i in 4:
			_ship(9, 8, Vector3(_far(20000, 80000), _far(20000, 80000), _far(20000, 80000))).hostile = true
		space.player.pos = Vector3(3000, 2000, -220000)
		space.player.basis = Basis.IDENTITY
		# Re-anchor the already-started entry shot after scripted placement.
		if space.portal_arriving(): space._begin_portal_arrival()
		objective = {"kind": "freighter_arrival", "index": 0}

func _final_scatter(around: Vector3) -> Vector3:
	return around + Vector3(space.rng.randi_range(-20000, 19999), space.rng.randi_range(-20000, 19999), space.rng.randi_range(-20000, 19999))

func _run_final(ms: int) -> void:
	if cast.is_empty() or failed or not cast[0].alive: return
	var escort: Body = cast[0]
	if step == 40:
		if stage == 0:
			escort.faction = 1
			stage = 1
		elif stage == 1 and escort.pos.z >= space.wormhole.pos.z:
			stage = 2
		elif stage == 2:
			# Source portal acceleration is in addition to ordinary forward
			# motion, followed by hiding the living actor on the other side.
			escort.pos.z += escort.pos.z - 200000.0 - ms
			if escort.pos.z > 500000.0:
				escort.pos = Vector3(0, 0, -200000)
				escort.visible = false
				escort.solid = false
				escort.combat_active = false
				stage = 3
				space.event.emit("escort_entered_portal", {"hull": escort.hull, "clock": clock})
	elif step == 41 and stage == 0 and escort.pos.z > -10000.0:
		stage = 1
		escort.speed = 0.0
		# The source shields the delivered ship with enormous HP. Native
		# protection is transient, never an invented persistent health value.
		escort.combat_active = false
		space.wormhole.pos = Vector3(5000, -40000, 10000)
		space.event.emit("escort_delivered", {"hull": escort.hull, "clock": clock})

## Only the flight screen's physical crossing event can settle scene40.
## Radio acknowledgement and docking cannot invoke this transition early.
func finish_portal_escort() -> bool:
	if step != 40 or game.session.story_step != 40 or not active() or not space.portal_crossed: return false
	if failed or cast.is_empty() or not cast[0].alive or cast[0].visible or stage != 3: return false
	game.session.flags["final_escort_hull"] = int(cast[0].hull)
	game.campaign.advance()
	game.pending_dialogue = []
	return true

func portal_escape_forbidden() -> bool:
	if step == 42 and space.in_void:
		return failed or escape_started_at < 0 or clock - escape_started_at > FINAL_ESCAPE_MS
	if not active(): return false
	if step in [29, 41]: return true
	return step == 40 and (failed or cast.is_empty() or not cast[0].alive or cast[0].visible or stage != 3)

## The source starts the sixty-second escape only AFTER the delivered
## freighter's result dialogue is acknowledged. It is not a timer victory.
func begin_final_escape() -> bool:
	if step != 41 or game.session.story_step != 42 or not space.in_void: return false
	if not complete or failed or cast.is_empty() or not cast[0].alive or cast[0].speed != 0.0: return false
	step = 42
	complete = false
	escape_started_at = clock
	objective = {}
	failure = {"kind": "timer", "ms": FINAL_ESCAPE_MS, "after": clock, "strict": true}
	space.event.emit("final_escape_started", {"clock": clock, "duration": FINAL_ESCAPE_MS})
	return true

func escape_remaining_ms() -> int:
	if step != 42 or escape_started_at < 0 or not space.in_void or space.portal_crossed: return -1
	return maxi(0, FINAL_ESCAPE_MS - (clock - escape_started_at))

# ------------------------------------------------------------------ jobs

## Freelance scenes as the original sets them up for each job kind.
func _scene_job() -> void:
	var d := int(job.get("difficulty", 1))
	var client_race := int(job.get("race", 0))
	# Defense opposes the system's people, even for a visiting employer.
	var opposed_race := int(space.station.faction) if int(job.kind) == 1 else client_race
	var rival: int = 8 if space.rng.randi_range(0, 99) < 75 else space._rival(opposed_race)
	match int(job.kind):
		4:
			# The hideout is the asteroid field, or a route of two or three
			# points; the pirates sleep around its points until found.
			if space.rng.randi_range(0, 1) == 0:
				wingman_route = [space.field_centre]
			else:
				wingman_route = _create_route(2 + space.rng.randi_range(0, 1))
			var n := 2 + int(5.0 * d / 10.0)
			for i in n: _sleeper(8, wingman_route[space.rng.randi_range(0, wingman_route.size() - 1)]).hostile = true
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
				# ed.java marks cleanup debris AlwaysEnemy for radar/targeting.
				j.hostile = true
				j.radius = 1000.0
				j.name = lib.text(186)
				j.pos = at + Vector3(space.rng.randi_range(-10000, 10000), space.rng.randi_range(-10000, 10000), space.rng.randi_range(-10000, 10000))
				j.ai = {"mode": "hold"}
				space.bodies.append(j)
				cast.append(j)
			for i in pirates: _defense_fighter(8, Vector3.ZERO).hostile = true
			# cl(7) waits for x's settled death state, not the last impact.
			objective = {"kind": "destroyed", "from": 0, "to": junk, "settled_deaths": true}
			failure = {"kind": "timer", "ms": 121000}
		6:
			var boss := _ship(8, space._hull_for(8, false), Vector3(_far(60000, 80000), 0, _far(60000, 80000)))
			wingman_route = [boss.pos]
			boss.hostile = true
			# The supplied bounty waits in actor state five at its route
			# point. Ordinary per-axis sight activates the encounter.
			boss.ai.mode = "encounter_wait"
			boss.combat_active = false
			boss.name = str(job.get("wanted", boss.name))
			boss.hull = d * mini(int(game.session.stat("rank")), 20) + 300
			boss.hull_max = boss.hull
			# cl(1) asks for the designated actor's settled death, not its
			# lethal impact or another pirate's death.
			objective = {"kind": "destroyed", "from": 0, "to": 1, "settled_deaths": true}
		1:
			var side := _rand_sign()
			var support_points: Array = []
			for z in [50000, 75000, 100000]:
				support_points.append(Vector3(space.rng.randi_range(-50000, 49999), 0, side * z))
			var attackers := 3 + int(5.0 * d / 10.0)
			var support: int = 2 + space.rng.randi_range(0, 5)
			for i in attackers:
				_defense_fighter(rival, Vector3.ZERO).hostile = true
			for i in support:
				var ally := _defense_fighter(int(space.station.faction), support_points[space.rng.randi_range(0, 2)])
				ally.friendly = true
				ally.hostile = false
				# AlwaysFriend is an allegiance override, not a damage shield.
				ally.ai.fixed_friendly = true
			# cl(7) counts every designated settled death, including allied
			# kills. Losing support is not a separate failure condition.
			objective = {"kind": "destroyed", "from": 0, "to": attackers, "settled_deaths": true}
		2:
			var attackers := 2 + int(4.0 * d / 10.0)
			var point := Vector3(_far(20000, 20000), 0, _far(20000, 20000))
			for i in attackers:
				var raider := _ship(rival, space._hull_for(rival, false), point + Vector3(i * 2000, i * 2000, i * 2000))
				raider.hostile = true
				# They make for the station, then back out to their start.
				raider.ai.route = [point, Vector3.ZERO]
				raider.ai.leg = 1
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
			var ambush := [Vector3(10000, 0, 100000), Vector3(10000, 0, 150000), Vector3(10000, 0, 200000)]
			for i in attackers:
				_sleeper(rival, ambush[space.rng.randi_range(0, 2)]).hostile = true
			# The convoy flies on along its heading into the ambush.
			var spots := [Vector3(-2500, -300, 27000), Vector3(6500, 3000, 24000), Vector3(-4000, -2000, 19000), Vector3(9000, -6000, 17000), Vector3(3000, 7000, 15000)]
			for p in spots:
				var f := _freighter(client_race, p)
				f.friendly = true
			objective = {"kind": "destroyed", "from": 0, "to": attackers}
			failure = {"kind": "destroyed", "from": attackers, "to": attackers + 5}
		10:
			var near := Vector3(space.rng.randi_range(-2500, 2500), space.rng.randi_range(-2500, 2500), 80000 + space.rng.randi_range(0, 30000))
			var route := Vector3(space.rng.randi_range(-2500, 2500), space.rng.randi_range(-2500, 2500), 120000 + space.rng.randi_range(0, 30000))
			wingman_route = [near, route]
			var freighters: int = 2 + space.rng.randi_range(0, 1)
			for i in freighters:
				# The cargo ships lie still at the far point.
				var f := _freighter(rival, route + Vector3(space.rng.randi_range(-10000, 10000), space.rng.randi_range(-10000, 10000), space.rng.randi_range(-10000, 10000)))
				f.hostile = true
				f.ai.mode = "hold"
			for i in 2 + int(2.0 * d / 10.0):
				_sleeper(rival, [near, route][space.rng.randi_range(0, 1)]).hostile = true
			objective = {"kind": "destroyed", "from": 0, "to": freighters}
		3, 5:
			var at := Vector3(_far(40000, 80000), 0, _far(40000, 80000))
			wingman_route = [at]
			var n := maxi(1, int(job.get("count", 2)))
			for i in n:
				# The supplied constructor scatters each fighter around the
				# route point; state five waits for its own sight boundary.
				var offset := Vector3(space.rng.randi_range(-20000, 19999), space.rng.randi_range(-20000, 19999), space.rng.randi_range(-20000, 19999))
				var pirate := _ship(8, space._hull_for(8, false), at + offset)
				pirate.hostile = true
				pirate.ai.mode = "encounter_wait"
				pirate.combat_active = false
			# The last ship carries the container: disable it with EMP and
			# take the cargo; shooting it down loses the container.
			var carrier: Body = cast[n - 1]
			carrier.name = lib.text(833)
			carrier.cargo = [game.session.recovery_cargo_item(), 1]
			carrier.ai["no_drop"] = true
			carrier.ai["recovery_container"] = true
			# cl(11/12) asks this carrier whether its mission crate was
			# transferred or destroyed; unrelated matching cargo is no proof.
			objective = {"kind": "recovery_transferred", "index": n - 1}
			failure = {"kind": "recovery_lost", "index": n - 1}
		12:
			var pirates := 3 + int(4.0 * d / 10.0)
			if pirates % 2 == 0: pirates += 1
			var rival_pilot := _ship(client_race, space._hull_for(client_race, false), space.player.pos + Vector3(space.rng.randi_range(-700, 700), 0, 1000))
			rival_pilot.name = str(job.client)
			rival_pilot.hull = 9999999; rival_pilot.hull_max = 9999999
			rival_pilot.hostile = false
			rival_pilot.friendly = true
			rival_pilot.ai.mode = "patrol"
			rival_pilot.ai["rival"] = true
			# The contest is fair: the rival's gun hits as hard as your fitting.
			for w in rival_pilot.weapons: w.damage = int(space.game.session.ship_stats().damage) + 2
			var route := _create_route(3 + space.rng.randi_range(0, 1))
			wingman_route = route.duplicate()
			rival_pilot.ai["route"] = route
			for i in pirates:
				_sleeper(8, route[space.rng.randi_range(0, route.size() - 1)]).hostile = true
			objective = {"kind": "challenge", "from": 1, "to": pirates + 1}

# ------------------------------------------------------------------ running

## Timed freelance missions share the native scene clock with their failure
## condition. A completed/failed job must not leave a ghost countdown.
func job_remaining_ms() -> int:
	if job.is_empty() or complete or failed or str(failure.get("kind", "")) != "timer": return -1
	return maxi(0, int(failure.ms) - (clock - int(failure.get("after", 0))))

func step_scene(ms: int) -> void:
	clock += ms
	var crew_goal = wingman_waypoint()
	if crew_goal != null:
		var gap: Vector3 = (crew_goal - space.player.pos).abs()
		if maxf(gap.x, maxf(gap.y, gap.z)) < 2000.0:
			wingman_route_index += 1
			# 267 "Waypoint reached", 268 "Last waypoint reached".
			space.event.emit("message", {"text": lib.text(268 if wingman_route_index >= wingman_route.size() else 267)})
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
		24: _run_void_reveal()
		29: _run_void_probe(ms)
		40, 41: _run_final(ms)
	_check_objectives()
	flash = maxf(0.0, flash - ms / 1000.0)

func _lines(text: String) -> int:
	var n := 0
	for para in text.split("\n"):
		n += maxi(1, int(ceil(para.length() / 36.0)))
	return n

## The first salvage radio starts the supplied portal shot. Protection is
## transient rather than saving the phone cinematic's enormous hull value.
func _run_void_reveal() -> void:
	if space.wormhole == null: return
	if stage == 0 and _fired(0):
		hud_hidden = true
		controls_locked = true
		space.autopilot = false
		space.player.ai["portal_cinematic"] = true
		space.player.basis = Basis(Vector3.UP, PI * 0.5)
		space.wormhole.pos = space.player.pos + space.player.forward() * 40960.0
		camera_mode = "look"
		camera_target = space.player
		camera_position = space.player.pos + Vector3(30500, 700, 1000)
		for actor in cast: actor.ai.target = null
		stage = 1
		space.event.emit("wormhole_cinematic", {"position": space.wormhole.pos})
	if stage == 1 and _done(0):
		space.wormhole.reveal()
		stage = 2
		space.event.emit("wormhole_revealed", {"position": space.wormhole.pos})

## The radio line on screen now: {speaker, name, text, face} or {}.
## ch.java starts the shot on the first radio and starts the three-minute
## clock only after the third radio finishes. Never save invented health.
func _run_void_probe(ms: int) -> void:
	if stage == 0 and _fired(0):
		stage = 1
		hud_hidden = true
		controls_locked = true
		space.autopilot = false
		space.player.ai["probe_cinematic"] = true
		camera_mode = "look"
		camera_target = space.player
		camera_position = space.player.pos + space.player.forward() * 16384.0 + space.player.basis.y * 1024.0
		probe_position = space.player.pos
		probe_basis = space.player.basis
		probe_visible = true
		space.event.emit("probe_launched", {"position": probe_position, "locked": space.locked})
	if stage == 1:
		if _done(2):
			stage = 2
			hud_hidden = false
			controls_locked = false
			space.player.ai.erase("probe_cinematic")
			camera_mode = "chase"
			probe_visible = false
			probe_started_at = clock
			objective = {"kind": "timer", "ms": PROBE_SCAN_MS, "after": clock, "strict": true}
			space.event.emit("probe_scan_started", {"clock": clock, "duration": PROBE_SCAN_MS})
		else:
			probe_position += probe_basis.z * ms * 3.0

func probe_remaining_ms() -> int:
	if step != 29 or probe_started_at < 0 or complete: return -1
	return maxi(0, PROBE_SCAN_MS - (clock - probe_started_at))

## The radio line on screen now: {speaker, name, text, face} or {}.
func message() -> Dictionary:
	if current < 0 or clock < shown_at + 2000: return {}
	var rec: Array = records[current]
	var speaker: int = rec[1]
	return {"speaker": speaker, "name": lib.text(Catalogue.STRING_SPEAKERS + speaker), "text": lib.text(int(rec[0]))}

## While a cinematic holds the controls and nothing is being said, the wait
## for a line on a timer can be skipped (Enter, a tap on Skip, the pad's A):
## the opening's slow rise over the field is fifteen silent seconds. Only
## when that timed line is the next in the scene's order.
func can_skip_wait() -> bool:
	return controls_locked and hud_hidden and current < 0 and _next_timed_at() > clock

func skip_wait() -> bool:
	if not can_skip_wait(): return false
	clock = _next_timed_at()
	poll = 501
	return true

func _next_timed_at() -> int:
	for i in records.size():
		if fired[i]: continue
		var rec: Array = records[i]
		if int(rec[2]) != 5: return -1
		var base := probe_started_at if step == 29 and probe_started_at >= 0 else 0
		return base + int(rec[3])
	return -1

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
		5: return clock - (probe_started_at if step == 29 and probe_started_at >= 0 else 0) >= int(param)
		6: return int(param) < finished.size() and finished[int(param)]
		8:
			for k in list:
				var index := int(k)
				if index >= 0 and index < cast.size() and cast[index].alive and cast[index].combat_active: return true
			return false
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
		21:
			var index := int(param)
			return index >= 0 and index < cast.size() and cast[index].alive and cast[index].disabled
		22: return int(space.stats.get("collected", 0)) >= int(param)
		23: return space.locked and space.target != null and space.target.kind in [Body.Kind.STATION, Body.Kind.MOTHERSHIP]
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
			frozen = false
			space.player.basis = HALF_TURN
			camera_mode = "look"
			camera_position = Vector3(-1000, -500, 110000)
			camera_target = space.player
			stage = 1
		1:
			if _done(2):
				frozen = true
				_shot(cast[0], Vector3(1000, 700, 1500)); stage = 2
		2:
			if _done(3):
				_shot(cast[1], Vector3(-2300, 300, 200)); stage = 3
		3:
			if _done(5):
				cast[2].ai.mode = "patrol"
				_shot(cast[2], Vector3(1000, 200, 6000)); stage = 4
		4:
			if _done(6):
				_shot(cast[1], Vector3(-1300, 300, 1700)); stage = 5
		5:
			if _done(7):
				hud_hidden = false
				radar_only = true
				frozen = false
				camera_mode = "chase"
				stage = 6
				space.event.emit("music", {"name": "gof2_gaction"})
		6:
			# The ship stays on its course until the pirates wake.
			if _done(8):
				controls_locked = false
				for b in cast:
					b.exhaust = true
					b.ai.mode = "patrol"
				stage = 7
		7:
			if _fired(10):
				# The crash: control is lost and the guns go dead.
				hud_hidden = true
				controls_locked = true
				space.player.weapons = []
				space.player.basis = HALF_TURN
				camera_mode = "look"
				camera_position = space.player.pos + Vector3(1000, -200, -60000)
				camera_target = space.player
				stage = 8
		8:
			if _done(12):
				flash = 1.0
				space.player.exhaust = false
				frozen = true
				stage = 9
		9:
			# Half a unit per millisecond about each axis, as the original tumbles.
			space.player.basis = space.player.basis.rotated(Vector3(1, 1, 1).normalized(), ms / 1000.0 * 1.33).orthonormalized()
			if _done(16):
				frozen = false
				stage = 10
		10:
			camera_position = space.player.pos + Vector3(-1000, -700, -1500)
			if _done(14):
				space.player.exhaust = true
				space.player.basis = Basis.IDENTITY
				camera_position = space.player.pos + Vector3(1000, 200, 15000)
				stage = 11
	# The two waiting pirates drift gently until they wake.
	if stage >= 1 and stage < 6:
		for i in mini(2, cast.size()):
			cast[i].pos.y += sin(clock * TAU / 4096.0) * ms * 0.12
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
		else:
			g.exhaust = false
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
	elif str(objective.kind) == "challenge":
		_story_challenge_done()
	else:
		game.session.story_mission["done"] = true
		space.event.emit("message", {"text": lib.text(97), "time": 5.0})

func _met(goal: Dictionary) -> bool:
	if goal.is_empty(): return false
	match str(goal.kind):
		"destroyed":
			for i in range(int(goal.from), int(goal.to)):
				if _alive(i): return false
				if bool(goal.get("settled_deaths", false)) and cast[i].dead_timer > 0.0: return false
			return true
		"timer":
			var elapsed := clock - int(goal.get("after", 0))
			return elapsed > int(goal.ms) if bool(goal.get("strict", false)) else elapsed >= int(goal.ms)
		"collected":
			return game.session.cargo_count(int(goal.item)) > 0
		"recovery_transferred":
			return bool(cast[int(goal.index)].ai.get("recovery_transferred", false))
		"recovery_lost":
			var carrier: Body = cast[int(goal.index)]
			return bool(carrier.ai.get("recovery_lost", false)) or (not carrier.alive and not bool(carrier.ai.get("recovery_transferred", false)))
		"radio_end":
			return records.size() > 0 and _done(records.size() - 1)
		"freighter_arrival":
			var index := int(goal.index)
			return stage > 0 and _alive(index) and cast[index].speed == 0.0
		"challenge":
			# Original cl(20/21) waits for all designated pirate deaths to
			# finish, rather than declaring a winner on the last impact.
			for i in range(int(goal.from), int(goal.to)):
				if i >= cast.size() or cast[i].faction != 8 or _alive(i) or cast[i].dead_timer > 0.0: return false
			return true
		"lost":
			return _dead(int(goal.index)) and game.session.cargo_count(int(goal.item)) == 0
	return false

## A freelance job done in space: the client pays and the player's standing
## with the client's people improves.
func _job_done() -> void:
	var s = game.session
	if int(job.kind) in [3, 5]:
		if bool(job.get("recovered", false)): return
		var destination := int(job.get("return_station", -1))
		# Older incomplete saves have no agent address. Never guess a
		# station, erase the contract, or pay early to hide that boundary.
		if space.cat.station(destination).is_empty(): return
		# Represent Main/o's recovery -> transport conversion explicitly,
		# without interpreting the original pirate count as cabin capacity.
		job["recovered"] = true
		job.station = destination
		objective = {}; failure = {}; wingman_route = []
		space.event.emit("job_report", {"name": str(job.client), "face": job.get("face", []),
			"text": lib.text(439).replace("#S", space.cat.station_name(destination))})
		return
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

## The story contest: out-shooting the rival finishes the step; losing it
## leaves the step open to be flown again on the next arrival.
func _story_challenge_done() -> void:
	var mine := int(space.kills)
	var theirs := int(space.stats.get("rival_kills", 0))
	if mine > theirs:
		game.session.story_mission["done"] = true
		space.event.emit("message", {"text": lib.text(97), "time": 5.0})
	else:
		failed = true
		space.event.emit("message", {"text": lib.text(193).replace("#Q1", str(mine)).replace("#Q2", str(theirs)), "time": 6.0})

func _standing_up(race: int) -> void:
	var rep: Array = game.session.reputation
	match race:
		0: rep[0] = clampi(int(rep[0]) + 2, -100, 100)
		1: rep[0] = clampi(int(rep[0]) - 2, -100, 100)
		2: rep[1] = clampi(int(rep[1]) + 2, -100, 100)
		3: rep[1] = clampi(int(rep[1]) - 2, -100, 100)

func _fail() -> void:
	if step == 42 and escape_started_at >= 0:
		space.event.emit("final_escape_failed", {"clock": clock, "elapsed": clock - escape_started_at})
		return
	if not job.is_empty():
		game.session.job = {}
		game.session.add_stat("jobs_failed")
		space.event.emit("job_report", {"name": str(job.client), "face": job.get("face", []),
			"text": lib.text(206 + space.rng.randi_range(0, 4)) + "\n\n" + lib.text(213)})
	space.event.emit("message", {"text": lib.text(213), "time": 6.0})
