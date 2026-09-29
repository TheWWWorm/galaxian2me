extends "res://tests/earned_wingmen_run.gd"
## One NEW isolated COPY of the accepted travelled crew. Only viewport input,
## native menu callbacks and read-only steering decisions change the live game.
const CREW_SHA := "0f112a4fcc3fffc987ef0eb940f0d3c19e7a067de38c023196d2da1525ec090f"
const Orders := preload("res://src/flight/wingmen.gd")
var order_events := []

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 3: source = args[0]; out = args[1]; recorded_sha = args[2]
	branch = "wingman-orders"
	_run.call_deferred()

func crew_record(space) -> Array:
	var rows := super.crew_record(space)
	var pilots := crew(space)
	for i in rows.size():
		rows[i].order = int(pilots[i].ai.get("wingman_order", -1))
		rows[i].weapon = int(pilots[i].ai.get("wingman_weapon", -1))
	return rows

func check_flight_entry(reference: WeakRef) -> void:
	super.check_flight_entry(reference)
	var flight = reference.get_ref()
	if flight == null: return
	check(crew_record(flight.space).all(func(r): return r.order == 2 and r.weapon == 0 and r.weapons.size() == 2),
		"actual area entry resets transient orders and builds both source guns without rehiring")
	flight.space.event.connect(observe_order.bind(reference))

func observe_order(kind: String, data: Dictionary, reference: WeakRef) -> void:
	if kind != "wingman_order": return
	var flight = reference.get_ref()
	if flight == null: return
	order_events.append({"clock": flight.space.clock, "data": Observation.value(data),
		"state": snapshot(), "crew": crew_record(flight.space)})
	print("NATIVE WINGMAN ORDER ", JSON.stringify(order_events.back()))

func open_crew_menu() -> void:
	resume_focus()
	await key_tap(KEY_M)
	var flight = app.screen
	check(flight is Flight and flight.paused and flight.navigation_layer != null,
		"physical M opens the native Actions menu")
	if failures > 0: return
	await click_button(named_button(flight.navigation_panel, app.library.text(146)), "Wingmen in actual Actions")
	check(flight.paused and named_button(flight.navigation_panel, app.library.text(147)) != null,
		"viewport click opens the native tactical crew panel")

func _run() -> void:
	if started: return
	started = true
	node_added.connect(watch_flight_entry)
	if recorded_sha != CREW_SHA: quit(2); return
	if not await start_host(CREW_SHA): return
	check(app.game.session.station_id == 95 and app.game.session.credits == 30959
		and int(app.game.session.flags.wingmen_remaining_ms) == 467312,
		"continue the exact travelled paid crew, never restart or recharge its contract")
	if failures == 0:
		pilot_mode = "hold"
		await click_button(app.screen.launch_button, "Depart Gome C with the retained paid pilots")
		resume_focus()
		await open_crew_menu()
	if failures == 0:
		var flight = app.screen
		var before := snapshot(); var world := Observation.capture(flight.space)
		await frames(12)
		check(snapshot() == before and Observation.capture(flight.space) == world,
			"actual rendered tactical modal freezes ships, projectiles, playtime and paid contract time")
		check(named_button(flight.navigation_panel, app.library.text(148)).disabled
			and named_button(flight.navigation_panel, app.library.text(149)).disabled,
			"ordinary Gome C departure has neither a locked attack ship nor an invented mission waypoint")
		await shot("orders_native_initial_panel")
		await click_button(named_button(flight.navigation_panel, app.library.text(151)), "actual Use EMP order")
		check(not flight.paused and crew(flight.space).all(func(b): return b.ai.wingman_weapon == 1 and b.ai.wingman_order == 1),
			"actual UI order resumes the rendered world with only EMP selected")
	if failures == 0:
		await open_crew_menu()
		await click_button(named_button(app.screen.navigation_panel, app.library.text(147)), "actual Fire at will with EMP")
		check(crew(app.screen.space).all(func(b): return b.ai.wingman_order == 2 and b.ai.wingman_weapon == 1),
			"actual tactical order restores formation without silently changing the chosen weapon")
		await open_crew_menu()
		check(named_button(app.screen.navigation_panel, app.library.text(150)) != null,
			"reopened native panel derives its switch label from actual EMP selection")
		await shot("orders_native_emp_panel")
		# Fire at will owns initial focus; disabled attack/waypoint buttons
		# are skipped by normal keyboard focus navigation to the switch.
		await key_tap(KEY_DOWN)
		check(root.gui_get_focus_owner() == named_button(app.screen.navigation_panel, app.library.text(150)),
			"real keyboard focus skips both disabled tactical rows to Use laser")
		await shot("orders_native_keyboard_focus")
		await key_tap(KEY_ENTER)
		check(app.screen.navigation_layer == null and crew(app.screen.space).all(func(b): return b.ai.wingman_weapon == 0),
			"real keyboard focus and Enter switch the physical crew back to ordinary guns")
	if failures == 0:
		await frames(60)
		await shot("orders_native_physical_crew")
		await physical_dock(95)
	if failures == 0:
		check(order_events.size() == 3 and order_events.map(func(e): return int(e.data.command)) == [1, 2, 1],
			"exactly the three visible native orders were accepted")
		await save_checkpoint()
		var path := out.path_join("earned-wingman-orders45.json")
		check(not FileAccess.file_exists(path) and DirAccess.copy_absolute(app.save_path(0), path) == OK,
			"preserve the real manually saved-and-reloaded tactical flight checkpoint")
		accepted = {"path": path, "sha256": FileAccess.get_sha256(path), "state": snapshot()}
		print("ORDERS NATIVE CHECKPOINT ", JSON.stringify(accepted))
		await shot("orders_native_saved_station")
	await finish()

func physical_dock(station_id: int) -> void:
	pilot_mode = "dock"
	app.screen.controls.scripted = drive_input.bind(weakref(app.screen), observers.back())
	for tick in 16000:
		resume_focus()
		if app.screen is Station or (app.screen is Flight and app.screen.defeated): break
		await frames(1)
	check(app.screen is Station and app.game.session.station_id == station_id,
		"ordinary steering physically returns the commanded crew to its real station")
	if failures > 0: await shot("orders_failed_dock"); return
	check(saved_state(app.AUTOSAVE_SLOT) == snapshot(), "native docking autosave includes the actually elapsed paid time")
	var elapsed: int = app.game.session.playtime_ms - int(header.playtime_ms)
	check(elapsed > 0 and int(app.game.session.flags.wingmen_remaining_ms) == int(header.flags.wingmen_remaining_ms) - elapsed,
		"orders and docking spend exactly actual unpaused flight time, with no contract refresh")
	check(app.game.session.flags.wingmen == header.flags.wingmen and app.game.session.credits == int(header.credits),
		"both surviving paid pilots return without another hire or payment")
	var flags: Dictionary = header.flags.duplicate(true)
	flags.wingmen_remaining_ms = int(header.flags.wingmen_remaining_ms) - elapsed
	check(snapshot().flags == normalized(flags), "tactical state is transient and never sneaks into the earned save flags")
	var cargo: Dictionary = header.cargo.duplicate(true)
	var salvage := 0
	for observer in observers:
		check(observer.errors.is_empty(), "actual tactical flight pickup observer has no unexplained inventory changes")
		for key in observer.totals:
			cargo[key] = int(cargo.get(key, 0)) + int(observer.totals[key])
			salvage += int(observer.totals[key])
	check(snapshot().cargo == normalized(cargo) and app.game.session.stat("cargo_salvaged") == int(header.stats.cargo_salvaged) + salvage,
		"every final cargo unit is inherited or accounted for by native collection")
	check(snapshot().equipment == header.equipment and snapshot().blueprints == header.blueprints
		and app.game.session.story_step == 45 and app.game.session.story_mission.is_empty()
		and app.game.session.stat("jobs") == int(header.stats.jobs) and app.game.session.stat("jumpgates") == int(header.stats.jumpgates),
		"commanding pilots cannot replay the ending, production, ammunition purchases, jobs or gate rewards")
	check(decisions > 0 and decisions_readonly, "rendered docking uses only observation-checked ordinary flight controls")
	dock_states.append({"station": station_id, "state": snapshot(), "autosave": saved_state(app.AUTOSAVE_SLOT)})

func finish() -> void:
	var file := FileAccess.open(out.path_join("orders-ledger.json"), FileAccess.WRITE)
	if file != null: file.store_string(JSON.stringify({"input_sha256": recorded_sha,
		"orders": order_events, "entries": crew_entries, "docks": dock_states,
		"accepted": accepted, "input_events": dispatched}, "\t"))
	await super.finish()
