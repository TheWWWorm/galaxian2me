extends "res://tests/earned_material_supply_run.gd"
## Separate process and save root. Only load an independently recorded digest.
var recorded_sha := ""
func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 3: source = args[0]; out = args[1]; recorded_sha = args[2]
	run_kind = "cold"
	_run.call_deferred()

func _run() -> void:
	if started: return
	started = true
	if recorded_sha.length() != 64: quit(2); return
	if not await start_host(recorded_sha): return
	var expected := header.duplicate(true)
	expected.erase("saved_at")
	check(int(header.story_step) == 45 and header.job.is_empty() and header.story_mission.is_empty(),
		"independent cold host loads the actual post-story material checkpoint")
	for index in 2:
		var panel = await open_blueprints()
		check(panel != null and snapshot() == expected and panel.pending_order.is_empty() and not panel.confirmation.visible,
			"cold Blueprints does not re-charge shipping, consume goods or produce another drive")
		var data: Dictionary = app.game.workshop.details(85)
		check(data.ingredients.size() == 8 and int(data.produced) == int(header.blueprints["85"].get("produced", 0))
			and data.pending == header.blueprints["85"].get("pending", {}),
			"independent load preserves the exact production count and any uncollected batch")
		await shot("cold_material_recipe_%d" % index)
		press(app.screen.menu.get_child(2), "cold post-story Map")
		await frames(3)
		var map = app.screen.current_panel
		check(map.story_address().is_empty() and map.wormhole_address().is_empty() and map.portal_view == null,
			"material production does not resurrect completed story objectives or portals")
		check(snapshot() == expected and app.save_attempts.is_empty(), "cold inspection changes no state and writes no save")
		app.show_title()
		await frames(3)
		app.screen._load()
		await frames(2)
		press(app.screen.panel_holder.get_child(0).get_child(0).get_child(0), "cold title Load again")
		await frames(4)
		check(snapshot() == expected, "repeated native title Load neither loses nor duplicates the earned result")
	await save_checkpoint()
	check(snapshot() == expected and saved_state(app.AUTOSAVE_SLOT) == expected,
		"independent manual Save and title reload preserve all actual material and product fields")
	await open_blueprints()
	await shot("cold_material_after_manual_reload")
	await finish()
