extends "res://tests/earned_blueprint_run.gd"
## A separate rendered process and exact native save; no reward replay.
var recorded_sha := ""
func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 3: source = args[0]; out = args[1]; recorded_sha = args[2]
	_run.call_deferred()
func text_in(node: Node) -> String:
	var result: String = node.text + "\n" if node is Label else ""
	for child in node.get_children():
		if not child.is_queued_for_deletion(): result += text_in(child)
	return result
func _run() -> void:
	if started: return
	started = true
	if recorded_sha.length() != 64: quit(2); return
	if not await start_host(recorded_sha): return
	var expected := header.duplicate(true); expected.erase("saved_at")
	for iteration in 2:
		press(app.screen.menu.get_child(3), "cold buyer Missions")
		await frames(3)
		var text := text_in(app.screen.current_panel)
		if header.job.is_empty():
			check(text.contains(app.library.text(141)) and app.screen.conversation == null,
				"paid buyer remains closed without another debrief")
		else:
			check(text.contains(str(header.job.client)) and text.contains("%d × %s" % [int(header.job.count), app.catalogue.item_name(int(header.job.item))]),
				"pending native order retains its client, quantity and goods on cold load")
		await shot("cold_buyer_missions_%d" % iteration)
		press(app.screen.menu.get_child(0), "cold buyer equipment")
		await frames(3)
		var tabs: TabContainer = app.screen.current_panel
		tabs.current_tab = 1; await frames(3)
		check(item_row(tabs.get_child(1).slots_list, app.catalogue.item_name(85)) != null,
			"buyer checkpoint still displays its genuinely produced fitted drive")
		check(snapshot() == expected and app.save_attempts.is_empty(),
			"cold buyer screens change no goods, credits, statistics or saves")
		app.show_title(); await frames(3)
		app.screen._load(); await frames(2)
		press(app.screen.panel_holder.get_child(0).get_child(0).get_child(0), "repeat cold native Load")
		await frames(4)
		check(snapshot() == expected and app.screen.conversation == null,
			"repeated title load cannot repeat buyer settlement")
	await save_checkpoint()
	check(snapshot() == expected and saved_state(app.AUTOSAVE_SLOT) == expected,
		"manual Save and title Load preserve every actual buyer-checkpoint field")
	await finish()
