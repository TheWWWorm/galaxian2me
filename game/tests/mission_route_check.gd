extends SceneTree
## Mission routes: every job kind the original gives a route has one, its
## points follow the original's generators, reaching a point announces it,
## and the autopilot flies the route point by point. Memory-only.
const Host := preload("res://tests/support/isolated_app.gd")
const Space := preload("res://src/flight/space.gd")
var checks := 0
var failures := 0
var app
func _init() -> void:
	run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	print("PASS: " if ok else "FAIL: ", label)
	if not ok: failures += 1

func world(kind: int, seed_value: int):
	var game = app._make_game()
	game.new_game()
	game.session.story_step = maxi(game.session.story_step, 20)
	game.session.job = {"kind": kind, "station": game.session.station_id, "difficulty": 5, "count": 2,
		"race": 0, "client": "Route fixture", "item": 116, "reward": 0}
	var sim := Space.new(game)
	sim.rng.seed = seed_value
	sim.build()
	return sim

## The original's createRoute: sideways 50,000-80,000 either way, height
## within ±10,000, each point 50,000-80,000 further on than the one before.
func generated(route: Array, lo: int, hi: int) -> bool:
	if route.size() < lo or route.size() > hi: return false
	var z := 0.0
	for p in route:
		if absf(p.x) < 50000 or absf(p.x) >= 80000 or p.y < -10000 or p.y >= 10000: return false
		if p.z - z < 50000 or p.z - z >= 80000: return false
		z = p.z
	return true

func run() -> void:
	app = Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		check(false, "supplied content installed")
	else:
		var field_seen := false
		var route_seen := false
		for seed_value in 12:
			var sim = world(4, seed_value)
			var route: Array = sim.story.wingman_route
			if route.size() == 1:
				field_seen = true
				check(route[0] == sim.field_centre, "a one-point hideout is the asteroid field centre")
			else:
				route_seen = true
				check(generated(route, 2, 3), "a hideout route follows the original generator")
			var near := true
			for b in sim.story.cast:
				var best := INF
				for p in route: best = minf(best, (b.pos - p).abs()[(b.pos - p).abs().max_axis_index()])
				near = near and best <= 20000
			check(near, "every pirate sleeps within its scatter of a route point")
			sim.dispose()
		check(field_seen and route_seen, "hideouts use both the field and generated routes")

		var sim = world(10, 3)
		var route: Array = sim.story.wingman_route
		check(route.size() == 2 and route[0].z >= 80000 and route[0].z < 110000 and route[1].z >= 120000 and route[1].z < 150000,
			"intercept route is the near and far point")
		sim.dispose()

		sim = world(12, 4)
		route = sim.story.wingman_route
		var rival = sim.story.cast[0]
		check(generated(route, 3, 4), "challenge course follows the original generator")
		check(rival.ai.route == route, "the rival flies the player's course")
		sim.dispose()

		# Reaching points: messages 267 then 268, and the autopilot flies on.
		sim = world(10, 5)
		route = sim.story.wingman_route.duplicate()
		var messages: Array = []
		sim.event.connect(func(kind, data): if kind == "message": messages.append(str(data.text)))
		sim.target = null
		check(sim.fly_to_waypoint() and sim.autopilot and sim.autopilot_waypoint, "Target: Waypoint starts the autopilot")
		check(sim._autopilot_goal() == route[0], "the autopilot heads for the first point")
		sim.player.pos = route[0] + Vector3(1500, -1500, 1500)
		sim.story.step_scene(16)
		check(messages.has(app.library.text(267)), "reaching a point says Waypoint reached")
		check(sim._autopilot_goal() == route[1], "the autopilot flies on to the next point")
		sim.player.pos = route[1]
		sim.story.step_scene(16)
		check(messages.has(app.library.text(268)), "reaching the last point says Last waypoint reached")
		sim._targeting(16, {})
		check(not sim.autopilot and not sim.autopilot_waypoint, "the autopilot stops at the end of the route")
		sim.dispose()

		# The autopilot key with nothing locked takes the route too.
		sim = world(4, 6)
		sim.target = null
		sim.step(0.016, {"autopilot": true})
		check(sim.autopilot and sim.autopilot_waypoint, "the autopilot key with nothing locked follows the route")
		var said: Array = []
		sim.event.connect(func(kind, data): said.append([kind, data.get("text", "")]))
		sim.step(0.016, {"autopilot": true})
		check(not sim.autopilot and said.has(["message", app.library.text(292) + " " + app.library.text(16)]), "the key turns the autopilot off with Autopilot Off")
		sim.story.wingman_route = []
		sim.target = null
		said.clear()
		sim.step(0.016, {"autopilot": true})
		check(not sim.autopilot and said.any(func(e): return e[0] == "autopilot_list"), "with nowhere to go the key opens the autopilot list")
		sim.dispose()
		# A fight under way keeps the pilot here until it is won or lost.
		sim = world(4, 8)
		var held: Array = []
		sim.event.connect(func(kind, data): if kind == "message": held.append(str(data.text)))
		check(sim.mission_holds_here(), "a pirate hunt under way holds the pilot in the area")
		sim.target = sim.station
		sim.player.pos = sim.station.pos
		sim._collisions()
		check(sim.docking < 0 and held.has(app.library.text(254)), "docking is refused with Not possible while on a mission")
		sim.story.complete = true
		sim.player.pos = sim.station.pos
		sim._collisions()
		check(not sim.mission_holds_here() and sim.docking >= 0, "once the mission is over the station takes the ship in")
		sim.dispose()
		# The way to a chosen destination: this station, the gate, or a star.
		sim = world(4, 7)
		sim.game.destination = {}
		check(sim.course_body() == null, "no destination, no course marker")
		sim.game.destination = {"station": sim.station.station_id}
		check(sim.course_body() == sim.station, "a destination here marks the station")
		var elsewhere := -1
		for sid in 200:
			var sys: int = app.catalogue.system_of_station(sid)
			if sys >= 0 and sys != sim.game.session.system_index and not app.catalogue.station(sid).is_empty():
				elsewhere = sid
				break
		sim.game.destination = {"station": elsewhere}
		var way = sim.course_body()
		if sim.gate != null:
			check(way == sim.gate, "a destination in another system marks the gate")
		else:
			var gate_station := int(app.catalogue.system(sim.game.session.system_index).get("jumpgate_station", -1))
			if gate_station < 0:
				check(way == null, "a system without a gate offers no course out")
			else:
				check(elsewhere >= 0 and way != null and way.kind == way.Kind.STAR and way.station_id == gate_station,
					"without a gate here, another system is reached via the gate station's star")
				check(sim._autopilot_goal() != null, "the autopilot has a course towards another system")
		sim.game.destination = {}
		sim.dispose()
		# A station in a system with a gate station, but not that station.
		var from := -1
		var gate_sid := -1
		for sys_i in app.catalogue.system_count():
			var sd: Dictionary = app.catalogue.system(sys_i)
			var jg := int(sd.get("jumpgate_station", -1))
			if jg < 0: continue
			for st in sd.get("stations", []):
				if int(st) != jg:
					from = int(st); gate_sid = jg
					break
			if from >= 0: break
		var g2 = app._make_game()
		g2.new_game()
		g2.session.story_step = maxi(g2.session.story_step, 20)
		g2.jump_arrive(app.catalogue.system_of_station(from), from)
		var sim2 := Space.new(g2)
		sim2.build()
		var far := -1
		for sid in 200:
			var sys2: int = app.catalogue.system_of_station(sid)
			if sys2 >= 0 and sys2 != g2.session.system_index and not app.catalogue.station(sid).is_empty():
				far = sid
				break
		g2.destination = {"station": far}
		var via = sim2.course_body()
		check(sim2.gate == null and via != null and via.kind == via.Kind.STAR and via.station_id == gate_sid,
			"another system is reached via this system's gate station")
		check(sim2._autopilot_goal() != null, "the autopilot has a course towards another system")
		# The original's autopilot list offers only what exists here.
		var keys: Array = sim2.autopilot_choices().map(func(c): return c.key)
		check(keys.has("destination") and keys.has("station") and keys.has("field") and not keys.has("gate") and not keys.has("waypoint"),
			"the autopilot list offers destination, station and field here (%s)" % str(keys))
		check(sim2.autopilot_to("field") and sim2._autopilot_goal() == sim2.field_centre, "Asteroid field flies to the field")
		sim2.player.pos = sim2.field_centre + Vector3(0, 0, 9000)
		sim2._targeting(16, {})
		check(not sim2.autopilot, "the autopilot stops among the field's rocks")
		check(sim2.autopilot_to("station") and sim2.target == sim2.station and sim2._autopilot_goal() == sim2.station.pos, "Station locks and flies to this station")
		sim2.target = null
		check(sim2.autopilot_to("destination") and sim2._autopilot_goal() != null, "the programmed destination is flown without a lock")
		sim2._targeting(16, {})
		check(sim2.autopilot, "the destination course keeps the autopilot on with nothing locked")
		sim2.dispose()
	print("MISSION ROUTES: %d checks, %d failures" % [checks, failures])
	app.queue_free()
	quit(1 if failures else 0)
