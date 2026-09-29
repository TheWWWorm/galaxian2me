extends "res://tests/earned_blueprint_run.gd"
## A second native process copies only the recorded real production checkpoint.
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
	check(int(header.station) == 96 and int(header.story_step) == 45 and int(header.credits) == 39806
		and int(header.blueprints["85"].station) == 96 and int(header.blueprints["85"].cost) == 5947,
		"cold input is the independently recorded genuine partial-production result")
	for index in 2:
		var panel = await open_blueprints()
		check(panel != null and snapshot() == expected, "opening the cold blueprint panel never repeats contributions")
		var data: Dictionary = app.game.workshop.details(85)
		check(data.ingredients.size() == 8 and int(data.station) == 96 and int(data.produced) == 0
			and data.pending.is_empty() and is_equal_approx(float(data.fraction), (3.0 + 9.0 / 70.0) / 8.0),
			"cold native panel displays the exact partial recipe and original production location")
		await shot("cold_blueprint_panel_%d" % index)
		press(app.screen.menu.get_child(2), "cold freeplay Map")
		await frames(3)
		var map = app.screen.current_panel
		check(map.story_address().is_empty() and map.wormhole_address().is_empty() and map.portal_view == null,
			"partial construction does not resurrect closed portals or story objectives")
		check(app.save_attempts.is_empty() and dialogue(app.screen) == null
			and app.game.pending_dialogue.is_empty() and snapshot() == expected,
			"cold inspection neither saves nor replays production, ending or contract results")
		app.show_title()
		await frames(3)
		app.screen._load()
		await frames(2)
		press(app.screen.panel_holder.get_child(0).get_child(0).get_child(0), "cold title Load recorded production again")
		await frames(4)
		check(snapshot() == expected, "repeated independent title loading preserves every recorded field")
	await save_checkpoint()
	check(snapshot() == expected and saved_state(app.AUTOSAVE_SLOT) == expected,
		"cold manual Save/title reload preserves the actual partial-production checkpoint")
	await open_blueprints()
	await shot("cold_blueprint_after_manual_reload")
	await finish()
