extends "res://tests/earned_drive_branches.gd"
## COPY the accepted native buyer checkpoint. Only visible UI input and
## ordinary flight controls may alter the live crew, funds, world or timer.
const BUYER_SHA := "0c9c85d42e2639cd67adc7874681a9fedd091e80b3743321af263b14f953668e"
var crew_entries := []
var milestones := []
var offer := {}
var dock_states := []

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 3: source = args[0]; out = args[1]; recorded_sha = args[2]
	branch = "wingmen"
	_run.call_deferred()

func text_in(node: Node) -> String:
	var text: String = node.text + "\n" if node is Label else ""
	for child in node.get_children():
		if not child.is_queued_for_deletion(): text += text_in(child)
	return text

func crew(space) -> Array:
	return space.bodies.filter(func(b): return bool(b.ai.get("wingman", false)))

func crew_record(space) -> Array:
	return crew(space).map(func(b): return {"name": b.name, "ship": b.ship_index, "race": b.faction,
		"hull": b.hull, "max_hull": b.hull_max, "friendly": b.friendly, "hostile": b.hostile,
		"fixed_friendly": b.ai.get("fixed_friendly", false), "mode": b.ai.mode,
		"position": Observation.value(b.pos), "weapons": Observation.value(b.weapons)})

func check_flight_entry(reference: WeakRef) -> void:
	super.check_flight_entry(reference)
	var flight = reference.get_ref()
	if flight == null: return
	var rows := crew_record(flight.space)
	check(rows.size() == 2 and rows.map(func(r): return r.name) == ["Stu Adlam", "Cody Hamilton"],
		"each genuine flight builds both actually hired pilots before its first tick")
	check(rows.all(func(r): return (r.hull == 600 and r.max_hull == 600 and r.friendly and not r.hostile
		and r.fixed_friendly and r.mode == "escort" and not r.weapons.is_empty())),
		"native paid pilots spawn with supplied durability, fixed allegiance and default guns")
	crew_entries.append({"mode": flight.space.entry_mode, "clock": flight.space.clock,
		"state": snapshot(), "crew": rows, "player": Observation.value(flight.space.player.pos),
		"arrival": Observation.value(flight.space.arrival.pos)})

func _run() -> void:
	if started: return
	started = true
	node_added.connect(watch_flight_entry)
	if recorded_sha != BUYER_SHA: quit(2); return
	if not await start_host(BUYER_SHA): return
	check(input_step == 45 and app.game.session.station_id == 96 and app.game.session.credits == 32501
		and app.game.session.flags.get("wingmen", []).is_empty(), "start from the exact earned unspent two-wingman offer")
	if failures == 0: await hire()
	if failures == 0: await save_crew("hired")
	if failures == 0:
		pilot_mode = "hold"
		await click_button(app.screen.launch_button, "Depart with the paid crew")
		resume_focus()
		check(app.screen is Flight and crew(app.screen.space).size() == 2, "real Depart creates a playable paid-crew flight")
	if failures == 0:
		var flight = app.screen
		await shot("wingmen_actual_departure")
		await key_tap(KEY_N)
		check(flight.paused and flight.navigation_layer != null, "native route Map pauses hired-crew flight")
		var before := snapshot(); var observed := Observation.capture(flight.space)
		await frames(12)
		check(snapshot() == before and Observation.capture(flight.space) == observed,
			"paused Map freezes crew time, playtime and all physical ships")
		check(flight.hud.wingmen_remaining_ms() == int(before.flags.wingmen_remaining_ms),
			"HUD displays the actual saved contract time, not a fresh display timer")
		await shot("wingmen_paused_map")
		await key_tap(KEY_ESCAPE)
		if failures == 0: await physical_dock(96)
	if failures == 0: await save_crew("first_dock")
	if failures == 0:
		# This named destination is from the supplied catalogue, not a fabricated
		# market or a previewed random flight. The actual Map must confirm it.
		chosen_station = 95
		chosen_system = app.catalogue.system_of_station(chosen_station)
		check(chosen_system == 19, "the supplied catalogue locates the next orbit in Augmenta")
		pilot_mode = "hold"
		preflight_saves = app.save_attempts.size()
		await click_button(app.screen.menu.get_child(2), "Map with the retained hired crew")
		var map = app.screen.current_panel
		var before := snapshot()
		await pointer_at(map.canvas.get_global_transform_with_canvas() * map._to_screen(map.canvas, app.catalogue.system(chosen_system)))
		await click_button(named_button(map.side, app.catalogue.station_name(chosen_station)), "select actual Augmenta destination")
		check(snapshot() == before and app.screen is Station, "Map selection alone neither spends crew time nor travels")
		await click_button(named_button(map.side, app.library.text(38)), "confirm crew's native station drive")
		if failures == 0:
			check(app.screen is Flight and app.screen.space.using_jump_drive, "confirmation launches the real fitted drive with both pilots")
			await await_drive(app.screen, false, "wingmen_drive")
		if failures == 0:
			check(crew(app.screen.space).size() == 2 and app.screen.space.entry_mode == "drive", "both pilots follow the real inter-area drive arrival")
			await shot("wingmen_actual_drive_arrival")
			await physical_dock(95)
	if failures == 0: await save_crew("travelled")
	if failures == 0:
		check(crew_entries.size() == 3 and dock_states.size() == 2,
			"evidence contains the real launch, second launch, drive arrival and two physical docks")
		check(decisions > 0 and decisions_readonly, "docking pilot only observes the world and returns ordinary controls")
		await shot("wingmen_final_native_save")
	await finish()

func hire() -> void:
	await click_button(app.screen.menu.get_child(1), "retained Space Lounge")
	var lounge = app.screen.current_panel
	offer = normalized(app.game.lounge()[0])
	check(int(offer.kind) == 6 and int(offer.price) == 1542 and offer.pilots == ["Stu Adlam", "Cody Hamilton"],
		"visible retained offer contains the two named pilots at 1542 credits")
	await click_button(lounge.list.get_child(0), "talk to actual Stu Adlam")
	check(text_in(lounge.detail).contains("Cody Hamilton"), "the native hiring dialogue identifies the second pilot")
	await shot("wingmen_retained_offer")
	var before := snapshot()
	await click_button(named_button(lounge.detail, app.library.text(38)), "pay for actual two-pilot contract")
	var expected := before.duplicate(true)
	expected.credits = int(expected.credits) - 1542
	expected.flags.wingmen = offer.pilots.duplicate()
	expected.flags.wingmen_race = int(offer.race)
	expected.flags.wingmen_remaining_ms = 600000
	expected.flags.wingmen_face = offer.face.duplicate()
	expected.stats.commanded_wingmen = int(expected.stats.get("commanded_wingmen", 0)) + 2
	expected.markets[0].lounge[0].kind = 1
	expected.markets[0].lounge[0].speech = app.library.text(492)
	check(snapshot() == normalized(expected) and app.save_attempts.is_empty(),
		"actual Yes spends exactly 1542 once, preserves resources and records the source's ten-minute crew")
	transactions.append({"kind": "hire", "before": before, "after": snapshot(), "offer": offer})
	check(named_button(lounge.detail, app.library.text(38)) == null,
		"the paid retained offer cannot be accepted for a duplicate charge")
	await shot("wingmen_hired_lounge")

func physical_dock(station_id: int) -> void:
	pilot_mode = "dock"
	app.screen.controls.scripted = drive_input.bind(weakref(app.screen), observers.back())
	for tick in 16000:
		resume_focus()
		if app.screen is Station or (app.screen is Flight and app.screen.defeated): break
		await frames(1)
	check(app.screen is Station and app.game.session.station_id == station_id, "ordinary flight physically docks the paid crew at its real destination")
	if failures > 0: await shot("wingmen_failed_dock"); return
	check(saved_state(app.AUTOSAVE_SLOT) == snapshot(), "crew time and roster are included in the settled docking autosave")
	check(app.game.session.flags.get("wingmen", []) == offer.pilots, "both actually surviving pilots persist at docking")
	var elapsed: int = app.game.session.playtime_ms - int(header.playtime_ms)
	check(int(app.game.session.flags.wingmen_remaining_ms) == 600000 - elapsed and elapsed > 0,
		"contract time decreases by exactly the accumulated native unpaused flight time, including drive cinematic")
	var cargo: Dictionary = header.cargo.duplicate(true)
	var salvage := 0
	for observer in observers:
		check(observer.errors.is_empty(), "native crew-flight pickup observer has no unexplained cargo changes")
		for key in observer.totals:
			cargo[key] = int(cargo.get(key, 0)) + int(observer.totals[key])
			salvage += int(observer.totals[key])
	check(snapshot().cargo == normalized(cargo) and app.game.session.stat("cargo_salvaged") == int(header.stats.cargo_salvaged) + salvage,
		"all final cargo is inherited or genuinely collected during native flight")
	check(app.game.session.credits == 30959 and app.game.session.stat("commanded_wingmen") == 2
		and app.game.session.stat("jobs") == int(header.stats.jobs) and app.game.session.stat("jumpgates") == int(header.stats.jumpgates),
		"only the one real hire changes credits or hire count; crew travel grants no job or gate reward")
	for key in header.flags:
		check(snapshot().flags.get(key) == header.flags[key], "crew flight preserves inherited flag: " + str(key))
	check(snapshot().blueprints == header.blueprints and snapshot().equipment == header.equipment
		and app.game.session.story_step == 45 and app.game.session.story_mission.is_empty(),
		"crew travel preserves the closed campaign and once-produced fitted drive")
	dock_states.append({"station": station_id, "state": snapshot(), "autosave": saved_state(app.AUTOSAVE_SLOT)})
	await shot("wingmen_docked_%d" % station_id)

func save_crew(stage: String) -> void:
	await save_checkpoint()
	if failures > 0: return
	var path := out.path_join("earned-wingmen-" + stage + "45.json")
	check(not FileAccess.file_exists(path) and DirAccess.copy_absolute(app.save_path(0), path) == OK,
		"preserve the genuine native crew checkpoint: " + stage)
	accepted = {"stage": stage, "path": path, "sha256": FileAccess.get_sha256(path), "state": snapshot()}
	milestones.append(accepted.duplicate(true))
	print("WINGMEN NATIVE CHECKPOINT ", JSON.stringify({"stage": stage, "path": path, "sha256": accepted.sha256,
		"station": app.game.session.station_id, "credits": app.game.session.credits, "remaining": app.game.session.flags.wingmen_remaining_ms}))

func finish() -> void:
	var file := FileAccess.open(out.path_join("wingmen-ledger.json"), FileAccess.WRITE)
	if file != null: file.store_string(JSON.stringify({"input_sha256": recorded_sha, "offer": offer,
		"transactions": transactions, "entries": crew_entries, "docks": dock_states, "milestones": milestones,
		"accepted": accepted, "input_events": dispatched}, "\t"))
	await super.finish()
