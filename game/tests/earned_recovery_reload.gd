extends "res://tests/earned_recovery_run.gd"
## Separate rendered process and storage: never regenerate offers or gear.
func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 3: source = args[0]; out = args[1]; recorded_sha = args[2]
	branch = "recovery-cold"
	_run.call_deferred()

func _run() -> void:
	if started: return
	started = true
	if recorded_sha.length() != 64: quit(2); return
	if not await start_host(recorded_sha): return
	var expected := header.duplicate(true); expected.erase("saved_at")
	recovery_offer = expected.job.duplicate(true)
	check(int(recovery_offer.get("return_station", -1)) == 95 and int(recovery_offer.kind) == 3
		and not bool(recovery_offer.get("recovered", false)), "cold load keeps the real uncompleted contract and its client address")
	for repeat in 2:
		await click_button(app.screen.menu.get_child(3), "cold recovery Missions")
		await click_button(app.screen.menu.get_child(0), "cold purchased equipment Hangar")
		check(snapshot() == expected and app.save_attempts.is_empty() and app.screen.conversation == null,
			"cold panels cannot reaccept, repay, rehire or recreate equipment")
		app.show_title(); await frames(3); app.screen._load(); await frames(2)
		press(app.screen.panel_holder.get_child(0).get_child(0).get_child(0), "repeat real cold Load")
		await frames(4)
		check(snapshot() == expected, "repeated cold Load preserves every earned field")
	await save_checkpoint()
	check(snapshot() == expected and saved_state(app.AUTOSAVE_SLOT) == expected,
		"separate cold manual Save and Load preserve pending recovery and all finite resources")
	await click_button(app.screen.menu.get_child(3), "cold pending recovery Missions")
	await shot("recovery_cold_missions")
	await finish()
