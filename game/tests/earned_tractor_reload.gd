extends "res://tests/earned_tractor_run.gd"
## Separate rendered process and storage; COPY only its independently checked
## native checkpoint. No reacceptance, battle replay, reward or crew renewal.
func _run() -> void:
	if started: return
	started = true
	if recorded_sha.length() != 64: quit(2); return
	if not await start_host(recorded_sha): return
	var expected := header.duplicate(true); expected.erase("saved_at")
	for i in 2:
		await click_button(app.screen.menu.get_child(3), "cold recovery Missions")
		await shot("tractor_cold_missions_%d" % i)
		await click_button(app.screen.menu.get_child(0), "cold recovery Hangar")
		check(snapshot() == expected and app.save_attempts.is_empty() and app.screen.conversation == null,
			"cold panels cannot reaccept, pay, recreate the crate, ammunition or paid time")
		app.show_title(); await frames(3); app.screen._load(); await frames(2)
		await click_button(app.screen.panel_holder.get_child(0).get_child(0).get_child(0), "cold native Load")
		check(snapshot() == expected, "repeat cold native Load preserves every earned field")
	await save_checkpoint()
	check(snapshot() == expected and saved_state(app.AUTOSAVE_SLOT) == expected,
		"cold manual Save and Load preserve the exact native recovery checkpoint")
	await finish()
