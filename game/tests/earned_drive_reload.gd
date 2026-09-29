extends "res://tests/earned_blueprint_run.gd"
## Separate rendered process, independent storage, exact recorded earned hash.
var recorded_sha := ""
func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 3: source = args[0]; out = args[1]; recorded_sha = args[2]
	_run.call_deferred()
func _run() -> void:
	if started: return
	started = true
	if recorded_sha.length() != 64: quit(2); return
	if not await start_host(recorded_sha): return
	var expected := header.duplicate(true)
	expected.erase("saved_at")
	for iteration in 2:
		check(app.game.session.ship_stats().jump_drive and app.game.session.cargo_count(85) == 0
			and int(header.blueprints["85"].produced) == 1 and app.game.session.story_step == 45,
			"cold load retains the actual fitted drive and single earned product")
		press(app.screen.menu.get_child(0), "cold Hangar equipment")
		await frames(3)
		var tabs: TabContainer = app.screen.current_panel
		tabs.current_tab = 1
		await frames(3)
		check(item_row(tabs.get_child(1).slots_list, app.catalogue.item_name(85)) != null,
			"cold native equipment panel displays the fitted drive")
		await shot("cold_drive_equipment_%d" % iteration)
		press(app.screen.menu.get_child(2), "cold destination Map")
		await frames(3)
		var map = app.screen.current_panel
		check(map.selected_system == app.game.session.system_index and map.story_address().is_empty()
			and map.wormhole_address().is_empty(), "cold Map shows the earned destination without reviving the ending")
		await shot("cold_drive_map_%d" % iteration)
		check(snapshot() == expected and app.save_attempts.is_empty(), "cold UI inspection neither changes resources nor saves")
		app.show_title()
		await frames(3)
		app.screen._load()
		await frames(2)
		press(app.screen.panel_holder.get_child(0).get_child(0).get_child(0), "repeat cold title Load")
		await frames(4)
		check(snapshot() == expected, "repeated native Load retains every earned field")
	await save_checkpoint()
	check(snapshot() == expected and saved_state(app.AUTOSAVE_SLOT) == expected,
		"cold manual Save and title Load preserve the complete drive checkpoint")
	await finish()
