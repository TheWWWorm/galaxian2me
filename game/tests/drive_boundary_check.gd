extends SceneTree
## Memory-only boundary probes. These deliberately construct invalid actions;
## none of their states is an earned continuation or written to player saves.
const TestApp := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
const Body := preload("res://src/flight/body.gd")
var app
var checks := 0
var failures := 0

func _init() -> void: run.call_deferred()
func check(ok: bool, text: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", text)

func fresh(fitted := true):
	var game := Game.new(app.library, app.catalogue)
	game.new_game()
	game.session.story_step = 45
	game.session.story_mission = {}
	game.session.job = {}
	game.session.station_id = 96
	game.session.system_index = 19
	game.session.equipment[3].fill(null)
	if fitted: game.session.equipment[3][0] = {"id": 85, "count": 1}
	game.session.add_cargo(85, 1)
	var sim := Space.new(game)
	sim.player = Body.new()
	sim.player.kind = Body.Kind.PLAYER
	sim.player.hull = 100
	sim.station = Body.new()
	sim.station.station_id = 96
	return sim

func rejected(sim, destination: int, label: String) -> void:
	var before := JSON.stringify(sim.game.session.to_dict())
	var route: Dictionary = sim.game.destination.duplicate(true)
	sim.jump_to(destination)
	check(sim.jumping < 0 and sim.game.destination == route
		and JSON.stringify(sim.game.session.to_dict()) == before, label)
	sim.dispose()

func run() -> void:
	app = TestApp.new()
	root.add_child(app)
	await process_frame
	check(app.library != null, "supplied content exists for isolated boundary probes")
	if app.library == null: quit(1); return
	rejected(fresh(false), 95, "cargo ownership without fitting cannot activate the drive")
	rejected(fresh(), 999999, "unknown station cannot become a drive destination")
	rejected(fresh(), 96, "drive does not jump to the same normal orbit")
	var sim = fresh()
	sim.game.session.story_mission = {"kind": 4, "station": 96}
	rejected(sim, 95, "local combat mission blocks drive escape")
	sim = fresh()
	sim.game.session.job = {"kind": 1, "station": 96}
	rejected(sim, 95, "local freelance combat blocks drive escape")
	sim = fresh(); sim.docking = 0
	rejected(sim, 95, "docking cannot be replaced by drive activation")
	sim = fresh(); sim.travelling = 0
	rejected(sim, 95, "star transit cannot be replaced by drive activation")
	sim = fresh(); sim.player.alive = false
	rejected(sim, 95, "destroyed player cannot activate the drive")
	sim = fresh(); sim.completed_flight = true
	rejected(sim, 95, "retired world cannot activate the drive")
	sim = fresh(); sim.game.session.in_void = true; sim.in_void = true
	rejected(sim, 95, "Void exit cannot replace the retained return address")
	for kind in [0, 11, 23]:
		sim = fresh()
		sim.game.session.story_mission = {"kind": kind, "station": 96}
		sim.jump_to(95)
		check(sim.jumping == 0, "source-allowed local mission kind%d admits the drive" % kind)
		sim.dispose()
	sim = fresh()
	sim.game.session.story_mission = {"kind": 4, "station": 95}
	sim.jump_to(95)
	check(sim.jumping == 0, "remote combat objective does not prohibit leaving this orbit")
	sim.dispose()
	sim = fresh()
	var events: Array = []
	sim.event.connect(func(kind, data): events.append({"kind": kind, "data": data.duplicate(true)}))
	var before := JSON.stringify(sim.game.session.to_dict())
	sim.jump_to(95)
	check(sim.jumping == 0 and JSON.stringify(sim.game.session.to_dict()) == before,
		"drive activation spends no invented crystals, credits or equipment")
	check(events.any(func(e): return e.kind == "drive") and not events.any(func(e): return e.kind == "gate"),
		"drive starts its own cinematic event rather than a physical gate event")
	var gates: int = sim.game.session.stat("jumpgates")
	sim._fly_player(2.6, 2600, {})
	check(sim.game.session.stat("jumpgates") == gates and sim.completed_flight,
		"completed drive transit retires the world without incrementing gates")
	check(events.any(func(e): return e.kind == "drive_arrived"),
		"drive arrival has its own transaction, including Void handling")
	sim.dispose()
	sim = fresh()
	var nonlinked := -1
	var links: Array = app.catalogue.system(19).get("links", [])
	for sys in app.catalogue.system_count():
		if sys == 19 or links.any(func(link): return int(link) == sys): continue
		var stations: Array = app.catalogue.system(sys).get("stations", [])
		if not stations.is_empty(): nonlinked = int(stations[0]); break
	check(nonlinked >= 0, "supplied graph contains a non-linked gate counterexample")
	sim.gate = Body.new(); sim.gate.kind = Body.Kind.GATE
	sim.target = sim.gate
	sim.game.destination = {"station": nonlinked}
	sim._use_gate()
	check(sim.jumping < 0, "physical gate rejects non-linked destination even with fitted drive")
	sim.dispose()
	check(app.save_attempts.is_empty(), "synthetic drive probes never save progression")
	for kind in [8, 19, 16, 14, 13]:
		sim = fresh()
		sim.game.session.story_mission = {"kind": kind, "station": 96}
		sim.jump_to(95)
		check(sim.jumping == 0, "source station-only mission kind%d does not prevent departure" % kind)
		sim.dispose()
	sim = fresh()
	sim.game.session.story_mission = {"kind": 25, "station": -1}
	sim.game.session.flags.wormhole_station = 96
	rejected(sim, 95, "source local portal escort takes priority over the sentinel mission address")
	sim = fresh()
	var initial: Dictionary = JSON.parse_string(JSON.stringify(sim.game.session.to_dict()))
	var to_void := {"station": -1, "system": -1, "void": true}
	sim.jump_to(-1)
	check(sim.jumping == 0 and sim.jump_destination == to_void, "confirmed Void jump is supported independently of a physical portal")
	check(sim.game.drive_arrive(to_void), "native Void arrival accepts the explicit drive address")
	var expected: Dictionary = initial.duplicate(true)
	expected.in_void = true
	check(JSON.parse_string(JSON.stringify(sim.game.session.to_dict())) == expected,
		"Void arrival changes only the location mode and retains all normal return-address/resources")
	check(not sim.game.drive_arrive(to_void), "duplicate Void arrival cannot teleport again or grant anything")
	check(not sim.game.drive_arrive({"station": 95, "system": 19, "void": false}),
		"forged Void return cannot choose a different station")
	check(sim.game.drive_arrive({"station": 96, "system": 19, "void": false}),
		"drive returns from Void to the retained normal orbit")
	expected = initial.duplicate(true)
	expected.visited_systems["19"] = true
	# The return also joins the chart's trail of recent trips.
	var trail: Array = (initial.flags.get("recent_systems", []) as Array).duplicate()
	if trail.is_empty() or int(trail.back()) != 19: trail.append(19)
	expected.flags["recent_systems"] = JSON.parse_string(JSON.stringify(trail.slice(maxi(0, trail.size() - 6))))
	check(JSON.parse_string(JSON.stringify(sim.game.session.to_dict())) == expected,
		"Void round trip preserves cargo, credits, ending flags, production and gate statistics")
	check(not sim.game.drive_arrive({"station": 96, "system": 19, "void": false}),
		"duplicate normal drive arrival is rejected without state changes")
	sim.dispose()
	sim = fresh()
	sim.jump_to(95)
	var first: Dictionary = sim.jump_destination.duplicate()
	sim.jump_to(-1)
	check(sim.jump_destination == first and sim.jumping == 0, "second activation cannot replace an in-progress drive destination")
	var defenses := [sim.player.hull, sim.player.armor, sim.player.shield]
	sim._harm(sim.player, 9999, 9999, null)
	check([sim.player.hull, sim.player.armor, sim.player.shield] == defenses and sim.player.alive,
		"source drive cinematic rejects damage without repairing existing damage")
	sim.dispose()
	app.queue_free()
	await process_frame
	await process_frame
	print("DRIVE BOUNDARIES: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
