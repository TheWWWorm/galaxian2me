extends "res://tests/earned_blueprint_run.gd"
## Genuine collected drive -> real fitting -> confirmed drive flight -> dock.
## Only visible UI callbacks and normal controls mutate live gameplay. No
## position, cargo, durability, seed, mission, stock or reward assignments.
const MATERIAL_SHA := "b52f2e8d6541f269d668669f2641830aea934bccbb05600de6d0016dd4682904"
const FITTED_SHA := "23aea272d2ee97d8f898841c3b977e429f71c0629949c316cb921b3363bd1d75"
const Transit := preload("res://tests/support/transit_pilot.gd")
const Observation := preload("res://tests/support/simulation_snapshot.gd")
const Pickup := preload("res://tests/support/cargo_pickup_observer.gd")
const Map := preload("res://src/screens/station/map_panel.gd")
var pilot_mode := "hold"
var controller := Transit.new()
var input_queue := {}
var decisions := 0
var decisions_readonly := true
var observers := []
var events := []
var samples := []
var drive_entries := []
var sample_at := -1000
var fitted := {}
var fitted_checkpoint := {}
var chosen_system := -1
var chosen_station := -1
var drive_before := {}
var drive_after := {}
var drive_durability := []
var preflight_saves := 0

func _run() -> void:
	if started: return
	started = true
	node_added.connect(watch_flight_entry)
	var resume_fitting := FileAccess.get_sha256(source) == FITTED_SHA
	if not await start_host(FITTED_SHA if resume_fitting else MATERIAL_SHA): return
	check(input_step == 45 and int(header.station) == 96 and int(header.system) == 19,
		"drive use starts from the recorded material-product lineage at its actual origin")
	if resume_fitting:
		check(app.game.session.ship_stats().jump_drive and app.game.session.cargo_count(85) == 0
			and app.game.session.cargo_count(77) == 1 and int(app.game.session.equipment[3][3].id) == 85,
			"resume the genuine UI-saved fitting, never repeat production or replace a save with expected fields")
		fitted = snapshot()
		fitted_checkpoint = {"path": source, "sha256": FITTED_SHA, "state": fitted}
	else:
		check(app.game.session.cargo_count(85) == 1 and not app.game.session.ship_stats().jump_drive,
			"unfitted branch requires the genuine single collected drive")
		if failures == 0: await fit_drive()
	if failures == 0 and not resume_fitting:
		await save_checkpoint()
		var path := out.path_join("earned-drive-fitted45.json")
		check(DirAccess.copy_absolute(app.save_path(0), path) == OK, "preserve the genuine fitting before attempting flight")
		fitted_checkpoint = {"path": path, "sha256": FileAccess.get_sha256(path), "state": snapshot()}
		fitted = snapshot()
	preflight_saves = app.save_attempts.size()
	if failures == 0: await drive_flight()
	if failures == 0:
		await save_checkpoint()
		var path := out.path_join("earned-drive45.json")
		check(DirAccess.copy_absolute(app.save_path(0), path) == OK, "retain the actual driven-and-docked native save")
		accepted = {"path": path, "sha256": FileAccess.get_sha256(path), "state": snapshot()}
		await shot("actual_drive_final_reloaded")
	await finish()

func fit_drive() -> void:
	press(app.screen.menu.get_child(0), "Hangar for the actually collected drive")
	await frames(3)
	var tabs: TabContainer = app.screen.current_panel
	tabs.current_tab = 1
	await frames(3)
	var fitting = tabs.get_child(1)
	# Keep the earned shield52, armor56 and booster71. Slot3 holds steering77;
	# demount it normally rather than enlarging the ship's equipment capacity.
	var old_id := int(app.game.session.equipment[3][3].id)
	check(old_id == 77 and app.catalogue.type(old_id) == app.catalogue.Type.STEERING,
		"source catalogue identifies the replaceable earned steering unit, not shield, armor or boost")
	if failures > 0: return
	var row_index := 3
	for category in 3: row_index += app.game.session.equipment[category].size()
	var rows: Array = fitting.slots_list.get_children().filter(func(n): return n is Button and not n.is_queued_for_deletion())
	press(rows[row_index], "select actual steering-equipment slot")
	await frames(2)
	var before := snapshot()
	press(named_button(fitting.detail, app.library.text(138)), "demount steering equipment into finite cargo")
	await frames(3)
	var expected := before.duplicate(true)
	expected.cargo["77"] = int(expected.cargo.get("77", 0)) + 1
	expected.equipment[3][3] = null
	check(snapshot() == normalized(expected), "native demount returns exactly the steering unit without repairing or charging")
	press(item_row(fitting.detail, app.catalogue.item_name(85)), "mount the collected Khador Drive")
	await frames(3)
	expected.cargo.erase("85")
	expected.equipment[3][3] = {"id": 85, "count": 1}
	check(snapshot() == normalized(expected) and app.game.session.ship_stats().jump_drive,
		"native fitting moves the one earned drive out of cargo into the real slot")
	transactions.append({"kind": "fit", "before": before, "after": snapshot(), "demounted": old_id})
	await shot("actual_drive_fitted")

func normalized(value): return JSON.parse_string(JSON.stringify(value))

func check_flight_entry(reference: WeakRef) -> void:
	super.check_flight_entry(reference)
	var flight = reference.get_ref()
	if flight == null: return
	controller = Transit.new()
	sample_at = -1000
	var observer := Pickup.new()
	observer.begin_world(flight.space)
	observers.append(observer)
	flight.controls.scripted = drive_input.bind(reference, observer)
	flight.space.event.connect(drive_event.bind(reference, observer))
	drive_entries.append({"mode": flight.space.entry_mode, "state": snapshot(),
		"observation": Observation.capture(flight.space)})

func drive_input(reference: WeakRef, observer) -> Dictionary:
	var flight = reference.get_ref()
	if flight == null: return {}
	var sim = flight.space
	observer.observe(sim)
	var before := Observation.capture(sim)
	var input: Dictionary = input_queue.duplicate()
	input_queue.clear()
	if input.is_empty() and pilot_mode == "dock": input = controller.input(sim, sim.station)
	decisions += 1
	decisions_readonly = decisions_readonly and Observation.capture(sim) == before
	if sim.clock - sample_at >= 1000:
		sample_at = sim.clock
		samples.append({"clock": sim.clock, "station": sim.station.station_id, "input": input.duplicate(), "observation": before})
	return input

func drive_event(kind: String, data: Dictionary, reference: WeakRef, observer) -> void:
	var flight = reference.get_ref()
	if flight == null: return
	var sim = flight.space
	observer.observe(sim)
	if kind in ["drive", "drive_arrived", "docked", "gate", "jumped", "destroyed", "killed", "wormhole_crossed"]:
		events.append({"kind": kind, "clock": sim.clock, "data": Observation.value(data),
			"state": snapshot(), "observation": Observation.capture(sim)})
		print("DRIVE EVENT ", kind, " clock=", sim.clock, " station=", sim.station.station_id)
	if kind == "drive":
		drive_before = snapshot()
		drive_durability = [sim.player.hull, sim.player.armor, sim.player.shield]
	if kind == "drive_arrived":
		drive_after = snapshot()
		check(sim.completed_flight and [sim.player.hull, sim.player.armor, sim.player.shield] == drive_durability,
			"drive cinematic retires the origin with exactly its actual pre-jump defenses")
		check(app.screen is Flight and app.screen != flight and app.screen.space.entry_mode == "drive",
			"native drive arrival replaces the old world with a genuine new flight")

func resume_focus() -> void:
	if app.screen is Flight and app.screen.menu_paused and app.screen.navigation_layer == null:
		var key := InputEventAction.new()
		key.action = "pause"; key.pressed = true
		app.screen._unhandled_input(key)
		focus_resumes += 1

func open_normal_drive_map() -> bool:
	resume_focus()
	input_queue = {"action_menu": true}
	await frames(3)
	var flight = app.screen
	check(flight is Flight and flight.navigation_layer != null and flight.paused,
		"ordinary Actions input opens a paused native equipment menu")
	if failures > 0: return false
	press(named_button(flight.navigation_panel, app.catalogue.item_name(85)), "activate fitted drive")
	await frames(2)
	var question = flight.navigation_panel.get_child(0)
	check(question is Label and question.text == app.library.text(243),
		"drive first asks the supplied Void-space question")
	if failures > 0: return false
	await shot("actual_drive_void_question")
	press(named_button(flight.navigation_panel, app.library.text(39)), "No to Void, choose a normal orbit")
	await frames(3)
	check(flight.navigation_panel is Map and flight.navigation_panel.flight_mode == "drive",
		"declining Void opens the actual unrestricted drive map")
	return failures == 0

func pick_station(map) -> void:
	press(await map_station(map, chosen_station), "choose actual destination station")
	await frames(2)

func drive_flight() -> void:
	var navigation = preload("res://src/simulation/navigation.gd")
	var safety := -1
	for system in app.catalogue.system_count():
		if system == app.game.session.system_index or not navigation.known(app.game.session, app.catalogue, system): continue
		if navigation.linked(app.game.session, app.catalogue, system): continue
		var record: Dictionary = app.catalogue.system(system)
		if record.get("stations", []).is_empty() or int(record.safety) <= safety: continue
		chosen_system = system; safety = int(record.safety)
		chosen_station = int(record.stations[0])
		for id in record.stations:
			if int(id) != int(record.get("jumpgate_station", -1)): chosen_station = int(id); break
	check(chosen_station >= 0, "a known non-linked system is chosen from supplied safety/geometry, not market previews or RNG")
	print("DRIVE ROUTE ", JSON.stringify({"from": 96, "to": chosen_station, "system": chosen_system,
		"name": app.catalogue.station_name(chosen_station), "safety": safety}))
	press(app.screen.launch_button, "leave the real station without a programmed destination")
	await frames(3)
	if failures > 0 or not await open_normal_drive_map(): return
	var flight = app.screen
	var frozen := snapshot()
	var frozen_world := Observation.capture(flight.space)
	await frames(5)
	check(snapshot() == frozen and Observation.capture(flight.space) == frozen_world,
		"drive map pauses both the native world and playtime without resetting anything")
	await pick_station(flight.navigation_panel)
	var map = flight.navigation_panel
	var expected_text: String = app.library.text(295) + ": " + app.catalogue.station_name(chosen_station) + "\n" + app.library.text(242)
	check(map.side.get_child(0).text == expected_text and snapshot() == frozen,
		"source destination confirmation appears before moving or spending anything")
	await shot("actual_drive_destination_confirmation")
	press(named_button(map.side, app.library.text(39)), "cancel the drive destination")
	await frames(3)
	check(snapshot() == frozen and Observation.capture(flight.space) == frozen_world and app.game.destination.is_empty(),
		"canceling a drive destination leaves the complete native world and route unchanged")
	await pick_station(map)
	if failures > 0: return
	press(named_button(map.side, app.library.text(38)), "confirm the actual non-linked drive jump")
	await frames(35)
	check(app.screen == flight and flight.space.using_jump_drive and flight.space.jumping >= 0
		and flight.navigation_layer == null and not flight.paused and is_instance_valid(flight.view.drive_node),
		"confirmation starts the visible supplied drive-flash cinematic in the real origin orbit")
	await shot("actual_drive_flash")
	for tick in 200:
		resume_focus()
		if app.screen != flight: break
		await frames(1)
	check(app.screen is Flight and app.game.session.station_id == chosen_station
		and app.game.session.system_index == chosen_system and not app.game.session.in_void,
		"the native drive reaches the chosen non-linked normal orbit without a gate")
	if failures > 0: return
	check(drive_after.cargo == drive_before.cargo and drive_after.credits == drive_before.credits
		and drive_after.equipment == drive_before.equipment and drive_after.stats == drive_before.stats
		and drive_after.blueprints == drive_before.blueprints and drive_after.flags == drive_before.flags,
		"drive transit consumes no crystals, cargo, credits or equipment and grants no production, gate or mission statistic")
	check(app.save_attempts.size() == preflight_saves, "orbit arrival is not docking and writes no autosave")
	await shot("actual_drive_arrival")
	pilot_mode = "dock"
	for tick in 16000:
		resume_focus()
		if app.screen is Station: break
		if app.screen is Flight and app.screen.defeated: break
		await frames(1)
	check(app.screen is Station and app.game.session.station_id == chosen_station,
		"read-only pilot controls physically dock at the actual drive destination")
	if failures > 0: await shot("actual_drive_failed_docking"); return
	check(saved_state(app.AUTOSAVE_SLOT) == snapshot(), "physical destination docking settles before its native autosave")
	check(events.filter(func(e): return e.kind == "drive").size() == 1
		and events.filter(func(e): return e.kind == "drive_arrived").size() == 1
		and events.filter(func(e): return e.kind == "docked").size() == 1
		and not events.any(func(e): return e.kind in ["gate", "jumped", "wormhole_crossed"]),
		"one confirmed drive and one physical docking earn this route, not a hidden gate or portal replay")
	var cargo: Dictionary = fitted.cargo.duplicate(true)
	var gained := 0
	for observer in observers:
		check(observer.errors.is_empty(), "flight inventory changes match actual consumed native pickup payloads")
		for key in observer.totals:
			cargo[key] = int(cargo.get(key, 0)) + int(observer.totals[key])
			gained += int(observer.totals[key])
	check(snapshot().cargo == normalized(cargo) and app.game.session.stat("cargo_salvaged") == int(fitted.stats.cargo_salvaged) + gained,
		"every additional cargo unit after fitting is accounted for by real salvage")
	check(app.game.session.stat("jumpgates") == int(header.stats.jumpgates)
		and app.game.session.credits == int(header.credits) and snapshot().equipment == fitted.equipment
		and snapshot().blueprints == header.blueprints and snapshot().flags == header.flags
		and app.game.session.story_step == 45 and app.game.session.job.is_empty() and app.game.session.story_mission.is_empty(),
		"drive travel preserves earned production, finite fitting, closed ending, credits and gate count")
	check(decisions > 0 and decisions_readonly, "all pilot decisions are read-only and return ordinary controls")
	await shot("actual_drive_destination_docked")

func finish() -> void:
	var pickups := []
	for observer in observers: pickups.append({"events": observer.events, "totals": observer.totals, "errors": observer.errors})
	var file := FileAccess.open(out.path_join("drive-ledger.json"), FileAccess.WRITE)
	if file != null: file.store_string(JSON.stringify({"source_before": frozen_sources, "source_after": source_hashes(),
		"fitted": fitted, "fitted_checkpoint": fitted_checkpoint, "events": events, "entries": drive_entries,
		"samples": samples, "pickups": pickups, "decisions": decisions, "decisions_readonly": decisions_readonly,
		"drive_before": drive_before, "drive_after": drive_after, "target_system": chosen_system, "target_station": chosen_station,
		"accepted": accepted}, "\t"))
	await super.finish()
