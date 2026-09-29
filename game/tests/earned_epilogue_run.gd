extends "res://tests/earned_travel_run.gd"
## COPY a verified native finale return, then use Map/flight/dock/Next only.
## This is an earned run, not a fixture: no RNG, resource or pose assignments.
const RETURN_SHA := "1d2c41c321a70cfd6f0019624aea3319beaf0cc4503039c19b275f40868859f3"
const Transit := preload("res://tests/support/transit_pilot.gd")
const Observation := preload("res://tests/support/simulation_snapshot.gd")
const Pickup := preload("res://tests/support/cargo_pickup_observer.gd")
var header := {}
var controller := Transit.new()
var observers := {}
var samples: Array = []
var native_events: Array = []
var epilogue_lines: Array = []
var retained: Array = []
var decisions := 0
var decisions_readonly := true
var sampled_clock := -1000
var frozen_sources := {}
var ending := {}
var last_native_kills := 0
var combat_events: Array = []

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 2:
		source = args[0]
		out = args[1]
	_run.call_deferred()

func collect_sources(folder: String, result: Dictionary) -> void:
	for file in DirAccess.get_files_at(folder):
		if file.ends_with(".gd"): result[folder.path_join(file)] = FileAccess.get_sha256(folder.path_join(file))
	for child in DirAccess.get_directories_at(folder): collect_sources(folder.path_join(child), result)

func source_hashes() -> Dictionary:
	var result := {}
	collect_sources("res://src", result)
	collect_sources("res://tests", result)
	return result

func _run() -> void:
	if started: return
	started = true
	if FileAccess.get_sha256(source) != RETURN_SHA or out.is_empty() or DirAccess.dir_exists_absolute(out):
		push_error("Provide the accepted native C43 and a NEW isolated output directory.")
		quit(2)
		return
	root.size = Vector2i(1280, 800)
	DirAccess.make_dir_recursive_absolute(out)
	frozen_sources = source_hashes()
	source_bytes = FileAccess.get_file_as_bytes(source)
	header = JSON.parse_string(source_bytes.get_string_from_utf8())
	input_step = int(header.story_step)
	last_native_kills = int(header.stats.kills)
	app = TestApp.new()
	save_root = out.path_join("test-saves-%d" % Time.get_ticks_usec())
	app.disk_saves = save_root
	node_added.connect(watch_flight_entry)
	node_added.connect(trace_flight_node)
	root.add_child(app)
	await frames(3)
	check(app.activate(str(header.content)), "accepted return content is installed")
	DirAccess.make_dir_recursive_absolute(app.save_path(app.AUTOSAVE_SLOT).get_base_dir())
	check(DirAccess.copy_absolute(source, app.save_path(app.AUTOSAVE_SLOT)) == OK, "COPY actual C43 into fresh native storage")
	app.show_title()
	await frames(3)
	app.screen._load()
	await frames(2)
	press(app.screen.panel_holder.get_child(0).get_child(0).get_child(0), "title Load earned return")
	await frames(3)
	var expected := header.duplicate(true)
	expected.erase("saved_at")
	check(app.screen is Station and snapshot() == expected and app.save_attempts.is_empty(), "native C43 load preserves every field without new payment or save")
	check(input_step == 43 and app.game.session.station_id == 91 and not app.game.session.in_void, "actual Dima43 is the sole starting point")
	for step in range(43, 46):
		print("EPILOGUE SOURCE ", step, " ", JSON.stringify(app.game.campaign.step_record(step)))
		print("EPILOGUE DIALOGUE ", step, " ", JSON.stringify(app.game.campaign.dialogue(step, 1)))
	seen_screen = app.screen.get_instance_id()
	await shot("actual_return43_input")
	for trip in 16:
		if failures > 0 or app.game.session.station_id == 98: break
		var next := next_route_station(98)
		if next < 0 or not await choose_destination(next) or not await fly_to_dock(): break
		await retain_dock()
	if failures == 0:
		check(app.screen is Station and app.game.session.station_id == 98 and app.game.session.system_index == 19,
			"actual native gate route reaches Alioth98 in system19")
		check(app.game.session.story_step == 45 and app.game.session.story_mission.is_empty()
			and not bool(app.game.session.flags.get("story_halted", false)), "both real Alioth epilogues earn terminal45 without a fabricated mission")
		check(epilogue_lines == app.game.campaign.dialogue(43, 1) + app.game.campaign.dialogue(44, 1),
			"every supplied epilogue line was displayed and acknowledged through native Next")
		check(app.game.session.credits == int(header.credits) + 40000, "real ending pays exactly the supplied forty thousand credits")
		check(snapshot().equipment == header.equipment and app.game.session.blueprints == header.blueprints,
			"ending preserves finite loadout and unfinished drive")
		check(app.game.session.stat("kills") == last_native_kills and app.game.session.stat("jobs") == int(header.stats.jobs)
			and app.game.session.stat("jumpgates") == int(header.stats.jumpgates) + gate_events.size(), "only physically observed gates and actual defensive kills change progression statistics")
		var gains := {}
		var payloads_valid := true
		for observer in observers.values():
			payloads_valid = payloads_valid and observer.errors.is_empty()
			for key in observer.totals: gains[key] = int(gains.get(key, 0)) + int(observer.totals[key])
		var cargo: Dictionary = header.cargo.duplicate(true)
		var gained := 0
		for key in gains:
			cargo[key] = int(cargo.get(key, 0)) + int(gains[key])
			gained += int(gains[key])
		check(payloads_valid and cargo == app.game.session.cargo and gained == app.game.session.stat("cargo_salvaged") - int(header.stats.cargo_salvaged)
			and app.game.session.cargo_free() >= 0, "cargo gains reconcile with consumed physical payloads and salvage count")
		check(saved_state(app.AUTOSAVE_SLOT) == snapshot(), "actual ending docking autosave contains the complete settled result")
		if failures == 0:
			var path := out.path_join("earned-ending45.json")
			check(DirAccess.copy_absolute(app.save_path(app.AUTOSAVE_SLOT), path) == OK, "retain the actual native ending autosave")
			ending = {"path": path, "sha256": FileAccess.get_sha256(path), "state": snapshot()}
		await shot("actual_alioth_ending45")
	check(decisions_readonly and decisions > 0, "all transit decisions preserve native world, session and RNG")
	check(FileAccess.get_file_as_bytes(source) == source_bytes, "original C43 remains byte-identical")
	await finish()

func check_flight_entry(reference: WeakRef) -> void:
	super.check_flight_entry(reference)
	var flight = reference.get_ref()
	if flight == null: return
	controller = Transit.new()
	sampled_clock = -1000
	var observer := Pickup.new()
	observer.begin_world(flight.space)
	observers[flight.space.get_instance_id()] = observer
	flight.controls.scripted = pilot.bind(reference)
	flight.space.event.connect(epilogue_event.bind(reference, observer))

func epilogue_event(kind: String, data: Dictionary, reference: WeakRef, observer) -> void:
	var flight = reference.get_ref()
	if flight == null: return
	observer.observe(flight.space)
	if kind == "killed":
		var count: int = app.game.session.stat("kills")
		var body: Body = data.body
		combat_events.append({"clock": flight.space.clock, "before": last_native_kills, "after": count,
			"body": Observation.fields(body)})
		if count != last_native_kills:
			check(count == last_native_kills + 1 and body.hostile and not body.friendly and not body.alive,
				"a native destroyed hostile accounts for each earned defensive kill")
		last_native_kills = count
	if kind not in ["gate", "jumped", "docked", "destroyed"]: return
	native_events.append({"kind": kind, "clock": flight.space.clock, "station": flight.space.station.station_id,
		"data": Observation.value(data), "native_observation": Observation.capture(flight.space)})
	print("EPILOGUE EVENT ", kind, " ", flight.space.clock, " station ", flight.space.station.station_id)

func pilot(reference: WeakRef) -> Dictionary:
	if not is_instance_valid(app) or app.is_queued_for_deletion(): return {}
	var flight = reference.get_ref()
	if flight == null: return {}
	var space = flight.space
	var observer = observers.get(space.get_instance_id())
	if observer != null: observer.observe(space)
	var goal: Body = space.station
	var sid := int(app.game.destination.get("station", -1))
	if sid >= 0 and sid != space.station.station_id:
		if app.catalogue.system_of_station(sid) != app.game.session.system_index: goal = space.gate
		else:
			for body in space.bodies:
				if body.kind == Body.Kind.STAR and body.station_id == sid: goal = body; break
	var before := Observation.capture(space)
	var controls: Dictionary = controller.input(space, goal)
	decisions += 1
	decisions_readonly = decisions_readonly and Observation.capture(space) == before
	if space.clock - sampled_clock >= 1000:
		sampled_clock = space.clock
		samples.append({"clock": space.clock, "station": space.station.station_id, "mode": controller.mode,
			"controls": controls.duplicate(), "native_observation": before})
	return controls

func clear_dialogue() -> void:
	for index in 100:
		var talk := dialogue(app.screen)
		if talk == null: return
		if app.game.session.story_step == 45:
			epilogue_lines.append(talk.lines[talk.index].duplicate(true))
			await shot("actual_epilogue_line_%02d" % (epilogue_lines.size() - 1))
		press(talk.next_button, "original epilogue Next")
		await frames(1)
	check(false, "epilogue dialogue closes within supplied line count")

func retain_dock() -> void:
	check(saved_state(app.AUTOSAVE_SLOT) == snapshot(), "native intermediate docking is already settled")
	var path := out.path_join("earned-stop-%02d.json" % retained.size())
	check(DirAccess.copy_absolute(app.save_path(app.AUTOSAVE_SLOT), path) == OK, "retain actual intermediate docking autosave")
	retained.append({"path": path, "sha256": FileAccess.get_sha256(path), "state": snapshot()})

func finish() -> void:
	check(source_hashes() == frozen_sources, "candidate sources remain unchanged throughout the native attempt")
	var pickups := []
	for observer in observers.values(): pickups.append({"events": observer.events, "totals": observer.totals, "errors": observer.errors})
	var file := FileAccess.open(out.path_join("epilogue-ledger.json"), FileAccess.WRITE)
	if file != null: file.store_string(JSON.stringify({"source_before": frozen_sources, "source_after": source_hashes(),
		"decisions": decisions, "decisions_readonly": decisions_readonly, "samples": samples,
		"events": native_events, "combat_events": combat_events, "lines": epilogue_lines,
		"retained": retained, "ending": ending, "pickups": pickups}, "\t"))
	await super.finish()
