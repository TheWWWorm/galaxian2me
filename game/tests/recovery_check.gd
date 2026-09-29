extends SceneTree
## Explicit MEMORY-ONLY recovery boundaries. Synthetic fitting, cargo and
## geometry below are fixtures; no fixture is written to any save file.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
const Navigation := preload("res://src/simulation/navigation.gd")
const INPUT := "res://../../local/checks/earned-wingman-orders-rendered-b-20260928/earned-wingman-orders45.json"
const SHA := "36ceb3fb85159fcd924ee195b1a5b02970f3537e70cbe001365f273d188ff836"
var app
var header := {}
var checks := 0
var failures := 0
var scanner := -1
var tractor := -1

func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)
func normalized(value): return JSON.parse_string(JSON.stringify(value))
func state(game) -> Dictionary: return normalized(game.session.to_dict())
func fixture(kind := 3):
	var game := Game.new(app.library, app.catalogue)
	check(game.session.from_dict(header).is_empty(), "memory fixture loads immutable paid-crew schema")
	var index := 3 if kind == 3 else 1
	check(game.accept_job(index).is_empty(), "actual lounge transaction accepts the retained recovery offer")
	check(int(game.session.job.get("return_station", -1)) == 95, "acceptance preserves the actual client's origin station")
	return game
func world(kind := 3):
	var game = fixture(kind)
	var target := int(game.session.job.station)
	game.jump_arrive(app.catalogue.system_of_station(target), target)
	var sim := Space.new(game)
	sim.build()
	return sim
func fit_transfer(sim) -> void:
	# Memory-only equipment/geometry, never an earned transaction or flight.
	sim.game.session.equipment[3][1] = {"id": tractor, "count": 1}
	var carrier = sim.story.cast.back()
	carrier.disabled = true
	carrier.pos = sim.player.pos + Vector3(0, 0, 1000)
	sim.target = carrier
	sim.locked = true

func complete_memory_pull(sim) -> void:
	# Explicit memory-only integration: let the real tractor accrue its
	# equipment-defined charge and move its crate. Do not authorize _loot
	# by assigning tractor state or inventing an earned flight checkpoint.
	var carrier = sim.story.cast.back()
	sim.player.pos = Vector3(200000, 0, 0)
	sim.player.basis = Basis.IDENTITY
	carrier.pos = sim.player.pos + Vector3(0, 0, 1000)
	for body in sim.bodies:
		if body != carrier and body != sim.player: body.visible = false
	sim._tractor_step(app.catalogue.attr(tractor, app.catalogue.A_TRACTOR_SPEED) + 1)
	sim._tractor_step(60)
	sim._tractor_step(1)

func run() -> void:
	check(FileAccess.get_sha256(INPUT) == SHA, "accepted native input is byte-identical")
	if failures: quit(2); return
	header = JSON.parse_string(FileAccess.get_file_as_string(INPUT))
	app = Host.new(); root.add_child(app)
	await process_frame; await process_frame
	check(app.activate(str(header.content)), "read supplied catalogue without creating content")
	for id in app.catalogue.item_count():
		var type: int = app.catalogue.type(id)
		if type in [app.catalogue.Type.SCANNER, app.catalogue.Type.TRACTOR_BEAM]:
			print("RECOVERY CATALOGUE ", JSON.stringify({"id": id, "name": app.catalogue.item_name(id), "attributes": app.catalogue.item(id).attributes}))
		if type == app.catalogue.Type.SCANNER and app.catalogue.attr(id, app.catalogue.A_SCAN_CARGO) == 1: scanner = id
		if type == app.catalogue.Type.TRACTOR_BEAM: tractor = id
	check(scanner >= 0 and tractor >= 0, "supplied catalogue contains cargo scanners and tractor equipment")
	for id in [9, 22, 261, 270, 439]: print("RECOVERY TEXT ", id, " ", app.library.text(id))
	var route_game := Game.new(app.library, app.catalogue)
	route_game.session.from_dict(header)
	var home: int = app.catalogue.attr(82, app.catalogue.A_HOME_STATION)
	var home_system: int = app.catalogue.system_of_station(home)
	print("RECOVERY PUBLIC ROUTE ", JSON.stringify({"station": app.catalogue.station(home), "system": app.catalogue.system(home_system),
		"known": Navigation.known(route_game.session, app.catalogue, home_system)}))
	for kind in [3, 5]:
		check_unrelated_cargo(kind)
		check_transfer_and_return(kind)
	check_scan()
	check_failed_transfers()
	check_return_boundaries()
	check(app.save_attempts.is_empty() and app.disk_saves.is_empty(), "synthetic boundaries never save fixture state")
	check(FileAccess.get_sha256(INPUT) == SHA, "memory checks never alter the accepted continuation")
	app.queue_free(); await process_frame; await process_frame
	print("RECOVERY: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)

func check_unrelated_cargo(kind: int) -> void:
	var sim = world(kind)
	var item := 117 if kind == 3 else 116 # Source physical payload, not the offer label.
	sim.game.session.add_cargo(item, 1)
	var before := state(sim.game)
	sim.story._check_objectives()
	check(not sim.story.complete and state(sim.game) == before, "unrelated matching cargo cannot complete recovery or pay its reward")
	var carrier = sim.story.cast.back()
	# Explicit memory approach wakes the source-inactive carrier before
	# this lethal-damage boundary; inactive distant ships cannot be harmed.
	sim.player.pos = carrier.pos + Vector3(0, 0, 49999)
	preload("res://src/flight/ai.gd").step(sim, carrier, 0.016, 16)
	check(carrier.combat_active and state(sim.game) == before, "memory lethal fixture first earns native encounter activation without changing saved resources")
	sim._harm(carrier, 100000.0, 0.0, sim.player)
	sim.story._check_objectives()
	check(sim.story.failed and sim.game.session.job.is_empty(), "matching unrelated cargo cannot hide destruction of the designated carrier")
	check(sim.game.session.cargo_count(item) == 1 and sim.game.session.credits == int(header.credits), "failed recovery preserves unrelated goods and grants no payment")
	sim.dispose()

func check_transfer_and_return(kind: int) -> void:
	var sim = world(kind)
	var game = sim.game
	var item := 117 if kind == 3 else 116
	var reward := int(game.session.job.reward)
	var carrier = sim.story.cast.back()
	carrier.disabled = true; carrier.pos = sim.player.pos + Vector3(0, 0, 1000)
	sim.target = carrier; sim.locked = true
	var before := state(game)
	sim._loot(carrier)
	check(state(game) == before and carrier.cargo.size() == 2, "mission transfer without fitted tractor cannot consume the container")
	fit_transfer(sim)
	sim.locked = false; before = state(game)
	sim._loot(carrier)
	check(state(game) == before, "unlocked mission carrier cannot be silently looted by proximity")
	sim.locked = true
	complete_memory_pull(sim)
	sim.story._check_objectives()
	check(sim.story.complete and bool(game.session.job.get("recovered", false)), "actual designated-carrier transfer changes recovery into a return leg")
	check(game.session.credits == int(header.credits) and game.session.stat("jobs") == int(header.stats.jobs), "retrieval grants neither premature reward nor completed-job credit")
	check(int(game.session.job.get("station", -1)) == 95 and game.session.cargo_count(item) == 1, "return leg carries its one real container to the client's recorded origin")
	if game.session.job.is_empty(): sim.dispose(); return
	check(not game.can_sell_cargo(item), "recovered mission cargo cannot be sold before delivery")
	before = state(game)
	sim._loot(carrier); sim.story._check_objectives(); game.settle_job(97 if kind == 3 else 90)
	check(state(game) == before, "repeated collection and docking at the recovery orbit cannot pay")
	var cold := Game.new(app.library, app.catalogue)
	check(cold.session.from_dict(state(game)).is_empty() and state(cold) == state(game), "JSON-shaped reload preserves pending return and finite resources without settlement")
	game.settle_job(95)
	check(game.session.job.is_empty() and game.session.cargo_count(item) == 0, "client delivery consumes exactly the recovered container and closes the job")
	check(game.session.credits == int(header.credits) + reward and game.session.stat("jobs") == int(header.stats.jobs) + 1, "delivery pays and counts the actual accepted job exactly once")
	before = state(game); game.settle_job(95)
	check(state(game) == before, "repeated destination settlement cannot replay delivery")
	sim.dispose()

func check_scan() -> void:
	var sim = world()
	check(sim.has_method("scanned_cargo"), "native flight exposes the same cargo readout the HUD displays")
	if not sim.has_method("scanned_cargo"): sim.dispose(); return
	var carrier = sim.story.cast.back()
	sim.target = carrier; sim.locked = true
	check(sim.scanned_cargo().is_empty(), "no fitted cargo scanner means no hidden inventory readout")
	sim.game.session.equipment[3][1] = {"id": scanner, "count": 1}
	sim.locked = false
	check(sim.scanned_cargo().is_empty(), "unfinished lock cannot reveal cargo")
	sim.locked = true
	var before := state(sim.game)
	var readout: Dictionary = sim.scanned_cargo()
	check(int(readout.get("item", -1)) == 117 and int(readout.get("count", 0)) == 1, "fitted scanner identifies the actual locked carrier's physical cargo")
	readout.item = 116
	check(int(sim.scanned_cargo().item) == 117 and state(sim.game) == before, "HUD readout is detached observation, never a writable inventory alias")
	sim.game.session.equipment[3][1] = {"id": 81, "count": 1}
	check(sim.scanned_cargo().is_empty(), "basic Quickscan without SHOW_CARGO cannot identify inventories")
	sim.game.session.equipment[3][1] = {"id": scanner, "count": 1}
	carrier.visible = false
	check(sim.scanned_cargo().is_empty(), "hidden stale target cannot leak cargo")
	carrier.visible = true; carrier.alive = false
	check(sim.scanned_cargo().is_empty(), "destroyed target cannot retain a live scan readout")
	carrier.alive = true; sim.bodies.erase(carrier)
	check(sim.scanned_cargo().is_empty(), "removed stale target cannot retain a cargo readout")
	sim.dispose()

func check_failed_transfers() -> void:
	var sim = world()
	check(not Navigation.drive_allowed(sim.game.session), "unretrieved recovery still blocks drive escape from its active encounter")
	fit_transfer(sim)
	var carrier = sim.story.cast.back()
	for reason in ["active", "hidden", "range", "unlocked"]:
		carrier.disabled = reason != "active"
		carrier.visible = reason != "hidden"
		carrier.pos = sim.player.pos + Vector3(0, 0, 9000 if reason == "range" else 1000)
		sim.locked = reason != "unlocked"
		var before := state(sim.game)
		sim._loot(carrier)
		check(state(sim.game) == before and carrier.cargo == [117, 1], "invalid mission transfer is inert: " + reason)
	carrier.disabled = true; carrier.visible = true; carrier.pos = sim.player.pos + Vector3(0, 0, 1000); sim.locked = true
	sim.game.session.add_cargo(99, sim.game.session.cargo_free())
	var before := state(sim.game)
	complete_memory_pull(sim); sim.story._check_objectives()
	check(sim.story.failed and sim.game.session.job.is_empty() and carrier.cargo.is_empty(), "full-hold recovery loses its entrusted container exactly as the source does")
	check(state(sim.game).cargo == before.cargo and sim.game.session.credits == int(before.credits), "failed full-hold transfer adds no goods or reward")
	sim.dispose()

func check_return_boundaries() -> void:
	var accepted_game = fixture()
	var round_trip := Game.new(app.library, app.catalogue)
	check(round_trip.session.from_dict(state(accepted_game)).is_empty(), "accepted recovery JSON is loadable before any retrieval")
	check(typeof(accepted_game.session.job.return_station) == TYPE_INT
		and typeof(round_trip.session.job.return_station) == TYPE_FLOAT
		and normalized(accepted_game.session.job) == normalized(round_trip.session.job),
		"observer compares normalized job values across native integer and JSON float representations")
	var sim = world()
	fit_transfer(sim)
	complete_memory_pull(sim); sim.story._check_objectives()
	var pending := state(sim.game)
	var cold := Game.new(app.library, app.catalogue)
	for reason in ["missing_origin", "wrong_station", "missing_cargo", "wrong_item", "invalid_phase", "invalid_origin"]:
		var invalid := pending.duplicate(true)
		match reason:
			"missing_origin": invalid.job.erase("return_station")
			"wrong_station": invalid.job.station = 96
			"missing_cargo": invalid.cargo.erase("117")
			"wrong_item": invalid.job.item = 117
			"invalid_phase": invalid.job.recovered = "true"
			"invalid_origin": invalid.job.return_station = -1
		var before := state(cold)
		check(not cold.session.from_dict(invalid).is_empty() and state(cold) == before, "invalid return save is rejected atomically: " + reason)
	check(cold.session.from_dict(pending).is_empty(), "valid return remains loadable after rejected states")
	cold.jump_arrive(app.catalogue.system_of_station(95), 95)
	check(Navigation.current_mission(cold.session).is_empty() and Navigation.drive_allowed(cold.session),
		"recovered return transport does not recreate a combat navigation lock at the client's orbit")
	var orbit := Space.new(cold); orbit.build()
	check(orbit.story == null or (orbit.story.job.is_empty() and orbit.story.cast.is_empty()), "return orbit never respawns the already recovered mission carrier")
	orbit.dispose()
	sim.game.session.add_cargo(117, 2)
	var before := state(sim.game)
	sim.game.cancel_job()
	check(sim.game.session.job.is_empty() and sim.game.session.cargo_count(117) == 2 and sim.game.session.credits == int(before.credits), "cancellation takes only the one entrusted container, not unrelated units or credits")
	check(sim.game.can_sell_cargo(117), "closed recovery releases unrelated same-type goods for normal trading")
	var legacy := pending.duplicate(true)
	legacy.job.erase("return_station"); legacy.job.erase("recovered"); legacy.job.erase("recovery_item"); legacy.job.station = 97
	check(cold.session.from_dict(legacy).is_empty() and not cold.departure_error().is_empty(), "legacy recovery without agent address stays readable but cannot guess a return route")
	sim.dispose()
