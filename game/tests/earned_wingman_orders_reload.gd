extends "res://tests/earned_wingman_orders_run.gd"
## Separate rendered process/storage. Observe the exact native output, not
## reconstructed expected fields or a regenerated contract.
func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 3: source = args[0]; out = args[1]; recorded_sha = args[2]
	branch = "wingman-orders-cold"
	_run.call_deferred()

func _run() -> void:
	if started: return
	started = true
	node_added.connect(watch_flight_entry)
	if recorded_sha.length() != 64: quit(2); return
	if not await start_host(recorded_sha): return
	var expected := header.duplicate(true); expected.erase("saved_at")
	check(int(header.flags.wingmen_remaining_ms) > 0 and int(header.flags.wingmen_remaining_ms) < 467312,
		"cold inspection starts with genuinely spent inherited contract time")
	for iteration in 2:
		await click_button(app.screen.menu.get_child(1), "cold native crew Lounge")
		await click_button(app.screen.menu.get_child(3), "cold native Missions")
		check(snapshot() == expected and app.save_attempts.is_empty() and app.screen.conversation == null,
			"cold station panels never recharge, rehire, repay or replay a debrief")
		app.show_title(); await frames(3); app.screen._load(); await frames(2)
		press(app.screen.panel_holder.get_child(0).get_child(0).get_child(0), "repeat native cold Load")
		await frames(4)
		check(snapshot() == expected, "repeated native loads preserve the entire actual tactical-flight result")
	await save_checkpoint()
	check(snapshot() == expected and saved_state(app.AUTOSAVE_SLOT) == expected,
		"separate cold manual Save and Load preserve every earned field")
	await shot("orders_cold_station")
	if failures == 0:
		pilot_mode = "hold"
		await click_button(app.screen.launch_button, "cold native departure with the actual surviving crew")
		resume_focus()
		await open_crew_menu()
		check(crew_entries.size() == 1 and crew(app.screen.space).all(func(b): return b.ai.wingman_order == 2 and b.ai.wingman_weapon == 0),
			"cold world reconstructs source default orders and guns rather than persisting stale tactical targets")
		var before := snapshot(); var world := Observation.capture(app.screen.space)
		await frames(12)
		check(snapshot() == before and Observation.capture(app.screen.space) == world,
			"cold tactical menu remains a real flight pause, not a timer-only display freeze")
		check(int(app.game.session.flags.wingmen_remaining_ms) == int(header.flags.wingmen_remaining_ms)
			- (app.game.session.playtime_ms - int(header.playtime_ms)), "cold departure spends only its actual newly simulated flight time")
		await shot("orders_cold_default_panel")
	await finish()
