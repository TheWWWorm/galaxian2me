extends "res://tests/earned_drive_run.gd"
## Continue only copied native checkpoints. Keyboard, pointer and screen-touch
## events traverse the real viewport and Controls; the docking pilot returns
## ordinary steering/target/fire controls. No live gameplay state is assigned.
var recorded_sha := ""
var branch := "void"
var dispatched := []
var branch_start := {}
var void_state := {}
var returned_state := {}

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 4:
		source = args[0]; out = args[1]; recorded_sha = args[2]; branch = args[3]
	_run.call_deferred()

func check_flight_entry(reference: WeakRef) -> void:
	super.check_flight_entry(reference)
	var flight = reference.get_ref()
	if flight != null and pilot_mode != "dock": flight.controls.scripted = Callable()

func key_tap(code: int) -> void:
	for down in [true, false]:
		var event := InputEventKey.new()
		event.physical_keycode = code; event.keycode = code; event.pressed = down
		Input.parse_input_event(event)
		Input.flush_buffered_events()
		await frames(2)
	dispatched.append({"kind": "keyboard", "physical_keycode": code, "state": snapshot()})

func pointer_at(pos: Vector2) -> void:
	var motion := InputEventMouseMotion.new()
	motion.position = pos; motion.global_position = pos
	Input.parse_input_event(motion)
	for down in [true, false]:
		var event := InputEventMouseButton.new()
		event.position = pos; event.global_position = pos
		event.button_index = MOUSE_BUTTON_LEFT; event.pressed = down
		Input.parse_input_event(event)
		Input.flush_buffered_events()
	await frames(3)

func click_button(button: Button, label: String) -> void:
	check(button != null and not button.disabled and button.is_visible_in_tree(), "visible pointer control: " + label)
	if button == null or button.disabled or not button.is_visible_in_tree(): return
	var pos := button.get_global_rect().get_center()
	await pointer_at(pos)
	dispatched.append({"kind": "pointer", "label": label, "position": [pos.x, pos.y], "state": snapshot()})

func touch_actions() -> void:
	var flight = app.screen
	check(flight is Flight and flight.touch != null and flight.touch.is_visible_in_tree()
		and not flight.controls.scripted.is_valid(), "native touch overlay and device Controls own the Void return input")
	if failures > 0: return
	var pos: Vector2 = flight.touch.get_global_transform_with_canvas() * flight.touch.buttons.action_menu.get_center()
	for down in [true, false]:
		var event := InputEventScreenTouch.new()
		event.index = 7; event.position = pos; event.pressed = down
		Input.parse_input_event(event)
		Input.flush_buffered_events()
	await frames(3)
	dispatched.append({"kind": "screen_touch", "action": "action_menu", "position": [pos.x, pos.y], "state": snapshot()})
	check(flight.navigation_layer != null and flight.paused and flight.touch.fingers.is_empty(),
		"a real short screen-touch tap opens Actions once and releases its finger")

func await_drive(origin, expected_void: bool, label: String) -> void:
	await frames(35)
	check(app.screen == origin and origin.space.using_jump_drive and origin.space.jumping >= 0
		and is_instance_valid(origin.view.drive_node) and not origin.paused,
		label + " starts the real supplied-geometry drive cinematic")
	if failures > 0: return
	await shot(label + "_flash")
	for tick in 220:
		resume_focus()
		if app.screen != origin: break
		await frames(1)
	check(app.screen is Flight and app.screen != origin and app.screen.space.entry_mode == "drive"
		and app.game.session.in_void == expected_void, label + " creates the native destination flight")
	check(app.save_attempts.size() == preflight_saves, label + " is not docking and writes no checkpoint")
	if failures == 0: await shot(label + "_arrival")

func void_roundtrip() -> void:
	await click_button(app.screen.launch_button, "Depart Suttnar without a programmed route")
	if failures > 0: return
	resume_focus()
	var origin = app.screen
	check(origin is Flight and not origin.controls.scripted.is_valid(), "keyboard navigation uses real Controls, not scripted input")
	if failures > 0: return
	await key_tap(KEY_N)
	check(origin.navigation_panel is Map and origin.navigation_panel.flight_mode == "route" and origin.paused,
		"physical N key events open the real paused route Map")
	if failures > 0: return
	var frozen := snapshot()
	var world := Observation.capture(origin.space)
	await frames(5)
	check(snapshot() == frozen and Observation.capture(origin.space) == world, "keyboard Map freezes both flight and playtime")
	await shot("keyboard_route_map")
	await key_tap(KEY_ESCAPE)
	check(origin.navigation_layer == null and not origin.paused and app.game.destination.is_empty(),
		"physical Escape closes Map without programming a trip")
	await key_tap(KEY_M)
	check(origin.navigation_layer != null and origin.paused, "physical M key events open native Actions")
	if failures > 0: return
	await click_button(named_button(origin.navigation_panel, app.catalogue.item_name(85)), "Khador Drive from keyboard Actions")
	check(origin.navigation_panel != null and origin.navigation_panel.get_child(0) is Label
		and origin.navigation_panel.get_child(0).text == app.library.text(243), "actual Khador action asks the supplied Void question")
	if failures > 0: return
	frozen = snapshot(); world = Observation.capture(origin.space)
	await shot("void_question_keyboard")
	await key_tap(KEY_ESCAPE)
	check(origin.navigation_layer == null and app.game.destination.is_empty(), "Void question can be canceled without starting a drive")
	await key_tap(KEY_M)
	await click_button(named_button(origin.navigation_panel, app.catalogue.item_name(85)), "reopen Khador after cancellation")
	check(events.is_empty() and snapshot().cargo == frozen.cargo and snapshot().credits == frozen.credits,
		"canceled Void question neither travels nor spends resources")
	if failures > 0: return
	await click_button(named_button(origin.navigation_panel, app.library.text(38)), "Yes to actual Void travel")
	await await_drive(origin, true, "void_outbound")
	if failures > 0: return
	var flight = app.screen
	void_state = snapshot()
	check(app.game.session.station_id == int(header.station) and app.game.session.system_index == int(header.system)
		and app.game.session.location_id() == -1 and flight.space.in_void,
		"actual Void arrival retains Suttnar56/Union11 as its normal return address")
	check(flight.space.mothership != null and not flight.space.station.visible and flight.space.wormhole == null,
		"post-ending Void contains its native mothership but no revived campaign portal")
	check(void_state.flags == header.flags and void_state.blueprints == header.blueprints
		and void_state.stats == header.stats and void_state.cargo == header.cargo,
		"entering Void preserves the closed ending, one production batch, gate count and cargo")
	resume_focus()
	await touch_actions()
	if failures > 0: return
	await shot("void_touch_actions")
	await click_button(named_button(flight.navigation_panel, app.catalogue.item_name(85)), "Khador retained-address return from touch Actions")
	await await_drive(flight, false, "void_return")
	if failures > 0: return
	returned_state = snapshot()
	check(app.game.session.station_id == int(header.station) and app.game.session.system_index == int(header.system),
		"native return drive reaches exactly the retained Suttnar orbit")
	check(events.map(func(e): return e.kind) == ["drive", "drive_arrived", "drive", "drive_arrived"],
		"Void round trip contains exactly two native drives, no hidden gate or wormhole crossing")
	await physical_dock(int(header.station))

func station_drive() -> void:
	var navigation = preload("res://src/simulation/navigation.gd")
	var best_safety := -1
	for system in app.catalogue.system_count():
		if system == app.game.session.system_index or not navigation.known(app.game.session, app.catalogue, system): continue
		if navigation.linked(app.game.session, app.catalogue, system): continue
		var record: Dictionary = app.catalogue.system(system)
		if record.get("stations", []).is_empty() or int(record.safety) <= best_safety: continue
		chosen_system = system; best_safety = int(record.safety)
		chosen_station = int(record.stations[0])
		for id in record.stations:
			if int(id) != int(record.get("jumpgate_station", -1)): chosen_station = int(id); break
	check(chosen_station >= 0, "station drive chooses a known non-linked supplied safe orbit without market or RNG previews")
	if failures > 0: return
	await click_button(app.screen.menu.get_child(2), "station Map")
	var station = app.screen
	var map = station.current_panel
	var initial := snapshot()
	await pointer_at(map.canvas.get_global_transform_with_canvas() * map._to_screen(map.canvas, app.catalogue.system(chosen_system)))
	check(map.selected_system == chosen_system, "viewport pointer selects the actual non-linked station system")
	await click_button(named_button(map.side, app.catalogue.station_name(chosen_station)), "station Map destination")
	check(snapshot() == initial and app.game.destination.is_empty() and app.screen == station,
		"station destination confirmation precedes any departure or resource mutation")
	await shot("station_drive_confirmation")
	await click_button(named_button(map.side, app.library.text(39)), "cancel station drive")
	check(snapshot() == initial and app.screen == station and app.game.destination.is_empty(),
		"cancel station drive preserves the entire station state")
	await click_button(named_button(map.side, app.catalogue.station_name(chosen_station)), "reselect station Map destination")
	await click_button(named_button(map.side, app.library.text(38)), "confirm station drive departure")
	check(app.screen is Flight and app.screen.space.using_jump_drive,
		"confirmed station Map departure automatically activates fitted drive in a native origin flight")
	if failures > 0: return
	var origin = app.screen
	await await_drive(origin, false, "station_drive")
	if failures > 0: return
	check(app.game.session.station_id == chosen_station and app.game.session.system_index == chosen_system,
		"station-programmed drive reaches the confirmed non-linked orbit")
	await physical_dock(chosen_station)

func physical_dock(station_id: int) -> void:
	pilot_mode = "dock"
	app.screen.controls.scripted = drive_input.bind(weakref(app.screen), observers.back())
	for tick in 16000:
		resume_focus()
		if app.screen is Station: break
		if app.screen is Flight and app.screen.defeated: break
		await frames(1)
	check(app.screen is Station and app.game.session.station_id == station_id,
		"ordinary read-only pilot inputs earn physical destination docking")
	if failures > 0: await shot(branch + "_failed_dock"); return
	check(saved_state(app.AUTOSAVE_SLOT) == snapshot(), "physical docking settles before the actual native autosave")
	check(events.back().kind == "docked" and events.filter(func(e): return e.kind == "docked").size() == 1,
		"one actual docking follows this drive branch")
	for observer in observers:
		check(observer.errors.is_empty(), "every native world has consistent observed pickup accounting")
	var cargo: Dictionary = header.cargo.duplicate(true)
	var gained := 0
	for observer in observers:
		for item in observer.totals:
			cargo[item] = int(cargo.get(item, 0)) + int(observer.totals[item])
			gained += int(observer.totals[item])
	check(snapshot().cargo == normalized(cargo)
		and app.game.session.stat("cargo_salvaged") == int(header.stats.cargo_salvaged) + gained,
		"every resulting cargo unit is inherited or a genuine native pickup")
	check(snapshot().equipment == header.equipment and snapshot().blueprints == header.blueprints
		and snapshot().flags == header.flags and app.game.session.credits == int(header.credits)
		and app.game.session.stat("jumpgates") == int(header.stats.jumpgates)
		and app.game.session.story_step == 45 and app.game.session.story_mission.is_empty() and app.game.session.job.is_empty(),
		"earned branch preserves finite fitting, production, credits, gate statistics and closed campaign")
	check(decisions > 0 and decisions_readonly, "docking controller observes without mutating the native simulation")
	await shot(branch + "_physically_docked")

func _run() -> void:
	if started: return
	started = true
	if recorded_sha.length() != 64 or branch not in ["void", "station"]: quit(2); return
	node_added.connect(watch_flight_entry)
	if not await start_host(recorded_sha): return
	check(input_step == 45 and not app.game.session.in_void and app.game.session.ship_stats().jump_drive,
		"branch starts from the copied genuine fitted-drive post-ending checkpoint")
	fitted = snapshot(); branch_start = snapshot()
	fitted_checkpoint = {"path": source, "sha256": recorded_sha, "state": fitted}
	preflight_saves = app.save_attempts.size()
	if branch == "void":
		check(recorded_sha == "003587f3c6465d829bd7b44550817935a18c1ea93970586a14f05b000e11154d"
			and int(header.station) == 56 and int(header.system) == 11, "Void trip starts only from accepted earned Suttnar C")
		if failures == 0: await void_roundtrip()
	elif failures == 0: await station_drive()
	if failures == 0:
		await save_checkpoint()
		var path := out.path_join("earned-drive-" + branch + "45.json")
		check(DirAccess.copy_absolute(app.save_path(0), path) == OK, "preserve the actual drive-branch native save")
		accepted = {"path": path, "sha256": FileAccess.get_sha256(path), "state": snapshot()}
		await shot(branch + "_saved_reloaded")
	await finish()

func finish() -> void:
	var file := FileAccess.open(out.path_join("branch-ledger.json"), FileAccess.WRITE)
	if file != null: file.store_string(JSON.stringify({"branch": branch, "input_sha256": recorded_sha,
		"input": branch_start, "void": void_state, "returned": returned_state, "dispatched": dispatched}, "\t"))
	await super.finish()
