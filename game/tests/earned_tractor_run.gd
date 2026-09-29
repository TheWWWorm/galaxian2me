extends "res://tests/earned_drive_branches.gd"
## COPY the actual prepared E save. Every live mutation comes from normal
## viewport controls, native physics or native saving; no fixture is loaded.
const PREPARED_SHA := "6667f8c9c5d65182f96dc9a6160e7e575c23f362f8c03f68ee41b4beb750dbe5"
const RecoveryPilot := preload("res://tests/support/recovery_pilot.gd")
const Crew := preload("res://src/flight/wingmen.gd")
var recovery_pilot := RecoveryPilot.new()
var tractor_events := []
var tractor_samples := []
var crew_orders := []
var native_checkpoints := []
var recoveries := []
var last_sample := -1000
var target_ordered := false
var stopped_pending := false
var extraction_state := {}

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 3: source = args[0]; out = args[1]; recorded_sha = args[2]
	branch = "tractor-recovery"
	_run.call_deferred()

func check_flight_entry(reference: WeakRef) -> void:
	super.check_flight_entry(reference)
	var flight = reference.get_ref()
	if flight == null: return
	flight.controls.scripted = tractor_input.bind(reference, observers.back())
	flight.space.event.connect(tractor_event.bind(reference))
	last_sample = -1000

func tractor_input(reference: WeakRef, observer) -> Dictionary:
	var flight = reference.get_ref()
	if flight == null: return {}
	var sim = flight.space
	observer.observe(sim)
	var before := Observation.capture(sim)
	var input: Dictionary = input_queue.duplicate()
	input_queue.clear()
	if input.is_empty():
		if pilot_mode == "recover": input = recovery_pilot.input(sim)
		elif pilot_mode == "dock":
			input = controller.input(sim, sim.station)
			# An unpaid entrusted carrier must not become collateral damage.
			if not app.game.session.job.is_empty(): input.fire = false; input.secondary = false
	decisions += 1
	decisions_readonly = decisions_readonly and Observation.capture(sim) == before
	if sim.clock - last_sample >= 1000:
		last_sample = sim.clock
		var row := {"clock": sim.clock, "station": sim.station.station_id, "mode": pilot_mode,
			"input": input.duplicate(), "tractor": sim.tractor_status(), "scanner": sim.scanned_cargo(),
			"hull": sim.player.hull, "armor": sim.player.armor, "shield": sim.player.shield,
			"crew_ms": app.game.session.flags.get("wingmen_remaining_ms", 0), "observation": before}
		tractor_samples.append(row)
		print("RECOVERY FLIGHT ", sim.clock, " hull=", sim.player.hull, " shield=", int(sim.player.shield),
			" phase=", sim.tractor_status(), " pilot=", recovery_pilot.mode)
	return input

func tractor_event(kind: String, data: Dictionary, reference: WeakRef) -> void:
	var flight = reference.get_ref()
	if flight == null: return
	if kind in ["tractor_started", "tractor_finished", "job_report", "destroyed"]:
		tractor_events.append({"kind": kind, "clock": flight.space.clock, "data": Observation.value(data),
			"tractor": flight.space.tractor_status(), "state": snapshot(), "observation": Observation.capture(flight.space)})
		print("RECOVERY NATIVE EVENT ", kind, " ", JSON.stringify(Observation.value(data)))
	elif kind == "wingman_order":
		crew_orders.append({"clock": flight.space.clock, "data": Observation.value(data), "state": snapshot()})

func crew_order(text_id: int) -> void:
	resume_focus()
	input_queue = {"action_menu": true}
	await frames(3)
	var flight = app.screen
	check(flight is Flight and flight.navigation_layer != null and flight.paused, "ordinary Actions input opens a paused tactical menu")
	if failures: return
	await click_button(named_button(flight.navigation_panel, app.library.text(146)), "native Wingmen action")
	var before := snapshot(); var physical := Observation.capture(flight.space)
	await frames(5)
	check(snapshot() == before and Observation.capture(flight.space) == physical, "tactical menu freezes real charge, ammunition, defenses and paid time")
	await shot("tractor_order_%d_%d" % [text_id, crew_orders.size()])
	await click_button(named_button(flight.navigation_panel, app.library.text(text_id)), "native tactical command %d" % text_id)

func station_depart(station_id: int) -> void:
	pilot_mode = "hold"
	preflight_saves = app.save_attempts.size()
	await click_button(app.screen.menu.get_child(2), "actual recovery route Map")
	var map = app.screen.current_panel
	var system: int = app.catalogue.system_of_station(station_id)
	check(map._known(system), "recovery destination is already genuinely discovered")
	if failures: return
	await click_button(await map_station(map, station_id), "actual recovery destination")
	await click_button(named_button(map.side, app.library.text(38)), "confirm actual fitted-drive departure")
	if failures: return
	await await_drive(app.screen, false, "tractor_route_%d" % station_id)

func flight_return(station_id: int) -> void:
	# An earned container need not be carried back through the hostile
	# retrieval orbit's station. Use the already-fitted drive via its real
	# Actions/confirmation UI, then physically dock at the recorded client.
	pilot_mode = "hold"
	resume_focus()
	preflight_saves = app.save_attempts.size()
	var flight = app.screen
	input_queue = {"action_menu": true}
	await frames(3)
	check(flight is Flight and flight.navigation_layer != null and flight.paused,
		"ordinary Actions pauses the actual extraction flight")
	if failures: return
	await click_button(named_button(flight.navigation_panel, app.catalogue.item_name(85)), "fitted Khador Drive after extraction")
	await click_button(named_button(flight.navigation_panel, app.library.text(39)), "No to Void; return to the actual client")
	var map = flight.navigation_panel
	check(map is Map and map.flight_mode == "drive", "client return uses the native in-flight drive Map")
	if failures: return
	var before := snapshot(); var physical := Observation.capture(flight.space)
	await frames(5)
	check(snapshot() == before and Observation.capture(flight.space) == physical,
		"return planning freezes the actual container, ammunition, defenses and crew contract")
	var system: int = app.catalogue.system_of_station(station_id)
	await click_button(await map_station(map, station_id), "the recorded recovery client destination")
	await shot("tractor_actual_client_return_confirmation")
	await click_button(named_button(map.side, app.library.text(38)), "confirm actual post-retrieval drive")
	if failures: return
	await await_drive(flight, false, "tractor_client_return")
	if failures: return
	check(app.game.session.station_id == station_id and app.game.session.cargo_count(116) == 1
		and not app.game.session.job.is_empty() and app.game.session.credits == int(header.credits),
		"client orbit retains the earned unpaid container; arrival is not delivery")

func dock_checkpoint(station_id: int, label: String) -> void:
	pilot_mode = "dock"
	controller = Transit.new()
	for tick in 14000:
		resume_focus()
		if app.screen is Station or (app.screen is Flight and app.screen.defeated): break
		await frames(1)
	check(app.screen is Station and app.game.session.station_id == station_id, "native steering earns physical docking: " + label)
	if failures: await shot("tractor_failed_dock_" + label); return
	await frames(3)
	check(saved_state(app.AUTOSAVE_SLOT) == snapshot(), "actual docking autosave stores its settled recovery state")
	await native_dialogue()
	await save_checkpoint()
	var path := out.path_join("earned-tractor-" + label + "45.json")
	check(not FileAccess.file_exists(path) and DirAccess.copy_absolute(app.save_path(0), path) == OK, "preserve actual native checkpoint: " + label)
	var record := {"path": path, "sha256": FileAccess.get_sha256(path), "state": snapshot()}
	native_checkpoints.append(record)
	accepted = record
	await shot("tractor_docked_" + label)

func native_dialogue() -> void:
	for i in 20:
		var panel := dialogue(app.screen)
		if panel == null: return
		await shot("tractor_dialogue_%d_%d" % [native_checkpoints.size(), i])
		await click_button(panel.next_button, "acknowledge actual recovery dialogue")
	check(false, "recovery dialogue terminates within its bounded lines")

func _run() -> void:
	if started: return
	started = true
	if recorded_sha != PREPARED_SHA: quit(2); return
	node_added.connect(watch_flight_entry)
	if not await start_host(PREPARED_SHA): return
	check(app.game.session.station_id == 15 and app.game.session.credits == 12955
		and int(app.game.session.flags.wingmen_remaining_ms) == 199920 and int(app.game.session.job.station) == 97,
		"continue the exact prepared native ship, remaining paid crew and actual Amaror job")
	if failures == 0: await station_depart(97)
	if failures == 0: await crew_order(151)
	if failures == 0: await crew_order(149)
	if failures == 0:
		check(Crew.living(app.screen.space).all(func(b): return b.ai.wingman_weapon == 1), "both actual paid pilots use their native EMP guns")
		pilot_mode = "recover"
		for tick in 11000:
			resume_focus()
			if not app.screen is Flight or app.screen.defeated or app.game.session.job.is_empty(): break
			if bool(app.game.session.job.get("recovered", false)): break
			var sim = app.screen.space
			if sim.player.hull < 70 or int(app.game.session.flags.get("wingmen_remaining_ms", 0)) < 60000:
				stopped_pending = true; break
			if recovery_pilot.identified != null and not target_ordered and sim.target == recovery_pilot.identified.get_ref() and sim.locked:
				await shot("tractor_actual_scanner_identification")
				await crew_order(148)
				target_ordered = failures == 0
			if not sim.tractor_status().is_empty():
				await shot("tractor_actual_" + str(sim.tractor_status().phase))
			await frames(1)
		check(app.screen is Flight and not app.screen.defeated and not app.game.session.job.is_empty(), "bounded recovery attempt preserves the living pilot and entrusted job")
	if failures == 0:
		var retrieved: bool = bool(app.game.session.job.get("recovered", false))
		check(app.game.session.credits == int(header.credits) and app.game.session.stat("jobs") == int(header.stats.jobs), "in-space recovery never pays or counts the return early")
		if retrieved:
			check(recovery_pilot.identified != null and not recovery_pilot.scans.is_empty()
				and tractor_events.any(func(e): return e.kind == "tractor_finished" and int(e.data.count) == 1),
				"native scanner identification and a physical timed pull precede actual retrieval")
		else: print("RECOVERY PENDING: finite retreat; no fabricated success, ammunition or crew time")
		await native_dialogue()
		if failures == 0 and not retrieved: await dock_checkpoint(97, "attempted")
		if failures == 0 and retrieved:
			check(app.game.session.cargo_count(116) == 1 and int(app.game.session.job.station) == 95
				and app.game.session.credits == int(header.credits), "actual extraction holds one protected container and the still-unpaid return address")
			extraction_state = snapshot()
			await flight_return(95)
			if failures == 0: await dock_checkpoint(95, "completed")
			if failures == 0:
				check(app.game.session.job.is_empty() and app.game.session.cargo_count(116) == 0
					and app.game.session.credits == int(header.credits) + int(header.job.reward)
					and app.game.session.stat("jobs") == int(header.stats.jobs) + 1,
					"physical client return consumes one actual container and pays/counts exactly once")
	if failures == 0:
		check(decisions > 0 and decisions_readonly and observers.all(func(o): return o.errors.is_empty()),
			"all pilot decisions are read-only and native cargo/payload/salvage evidence reconciles")
		check(app.game.session.story_step == 45 and snapshot().blueprints == header.blueprints
			and app.game.session.stat("jumpgates") == int(header.stats.jumpgates), "recovery leaves the ending, production and gate count untouched")
		var elapsed: int = app.game.session.playtime_ms - int(header.playtime_ms)
		check(int(app.game.session.flags.get("wingmen_remaining_ms", 0)) == maxi(0, int(header.flags.wingmen_remaining_ms) - elapsed),
			"the same paid contract spends exactly actual unpaused flight milliseconds")
	await finish()

func finish() -> void:
	if app != null and app.game != null:
		var file := FileAccess.open(out.path_join("tractor-ledger.json"), FileAccess.WRITE)
		if file != null: file.store_string(JSON.stringify({"input_sha256": recorded_sha, "checkpoints": native_checkpoints,
			"extraction": extraction_state,
			"events": tractor_events, "orders": crew_orders, "samples": tractor_samples, "scans": recovery_pilot.scans,
			"secondary_requests": recovery_pilot.secondary_requests, "decisions": decisions, "readonly": decisions_readonly,
			"stopped_pending": stopped_pending, "final": snapshot()}, "\t"))
	await super.finish()
