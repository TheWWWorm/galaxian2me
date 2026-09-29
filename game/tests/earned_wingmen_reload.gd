extends "res://tests/earned_wingmen_run.gd"
## Separate-process cold inspection of one exact native travelled-crew save.
## Loading/screen inspection does not grant time, pilots, money or a save.
func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 3: source = args[0]; out = args[1]; recorded_sha = args[2]
	branch = "wingmen-cold"
	_run.call_deferred()

func _run() -> void:
	if started: return
	started = true
	node_added.connect(watch_flight_entry)
	if recorded_sha.length() != 64: quit(2); return
	if not await start_host(recorded_sha): return
	var expected := header.duplicate(true); expected.erase("saved_at")
	check(header.flags.get("wingmen", []) == ["Stu Adlam", "Cody Hamilton"]
		and int(header.flags.get("wingmen_remaining_ms", 0)) > 0 and int(header.flags.wingmen_remaining_ms) < 600000,
		"cold process receives a genuinely travelled paid-crew checkpoint, not a new contract")
	for iteration in 2:
		await click_button(app.screen.menu.get_child(1), "cold native Lounge")
		await click_button(app.screen.menu.get_child(3), "cold native Missions")
		check(snapshot() == expected and app.save_attempts.is_empty() and app.screen.conversation == null,
			"cold station screens neither recharge crew time nor repeat any payment or debrief")
		app.show_title(); await frames(3); app.screen._load(); await frames(2)
		press(app.screen.panel_holder.get_child(0).get_child(0).get_child(0), "repeat cold native Load")
		await frames(4)
		check(snapshot() == expected, "repeated title loads preserve every earned field and remaining millisecond")
	await save_checkpoint()
	check(snapshot() == expected and saved_state(app.AUTOSAVE_SLOT) == expected,
		"cold manual Save and title Load preserve the entire actual paid-crew state")
	await shot("wingmen_cold_retained_station")
	if failures == 0:
		pilot_mode = "hold"
		await click_button(app.screen.launch_button, "cold Depart with saved survivors")
		resume_focus()
		await key_tap(KEY_N)
		check(app.screen is Flight and app.screen.paused and crew_entries.size() == 1,
			"cold native departure reconstructs the two saved pilots in the real rendered world")
		check(int(app.game.session.flags.wingmen_remaining_ms) == int(header.flags.wingmen_remaining_ms)
			- (app.game.session.playtime_ms - int(header.playtime_ms)), "cold departure spends only its actual new flight time")
		await shot("wingmen_cold_physical_crew")
	await finish()
