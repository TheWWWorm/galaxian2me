extends "res://tests/earned_travel_run.gd"
## Independent process and storage: cold-load the actual paid contract save.
var recorded_sha := ""
var header := {}
func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 3: source = args[0]; out = args[1]; recorded_sha = args[2]
	_run.call_deferred()

func _run() -> void:
	if started: return
	started = true
	if recorded_sha.length() != 64 or FileAccess.get_sha256(source) != recorded_sha or out.is_empty() or DirAccess.dir_exists_absolute(out):
		push_error("Provide actual earned cleanup45, NEW output, and independently recorded SHA256.")
		quit(2)
		return
	root.size = Vector2i(1280, 800)
	DirAccess.make_dir_recursive_absolute(out)
	source_bytes = FileAccess.get_file_as_bytes(source)
	header = JSON.parse_string(source_bytes.get_string_from_utf8())
	app = TestApp.new()
	save_root = out.path_join("test-saves-%d" % Time.get_ticks_usec())
	app.disk_saves = save_root
	root.add_child(app)
	await frames(3)
	check(app.activate(str(header.content)), "actual cleanup content is installed")
	check(int(header.story_step) == 45 and int(header.station) == 96 and int(header.credits) == 45687
		and int(header.stats.jobs) == 3 and header.job.is_empty() and header.story_mission.is_empty(),
		"only the recorded paid cleanup result is accepted")
	if failures > 0: await finish(); return
	DirAccess.make_dir_recursive_absolute(app.save_path(app.AUTOSAVE_SLOT).get_base_dir())
	check(DirAccess.copy_absolute(source, app.save_path(app.AUTOSAVE_SLOT)) == OK, "COPY actual paid cleanup into an independent cold host")
	var expected := header.duplicate(true)
	expected.erase("saved_at")
	for index in 2:
		app.show_title()
		await frames(3)
		app.screen._load()
		await frames(2)
		press(app.screen.panel_holder.get_child(0).get_child(0).get_child(0), "cold title Load paid cleanup")
		await frames(4)
		check(app.screen is Station and snapshot() == expected, "independent cold title load preserves every earned field")
		check(app.save_attempts.is_empty() and dialogue(app.screen) == null and app.game.pending_dialogue.is_empty(),
			"cold load neither saves nor replays freelance or ending rewards/dialogue")
		press(app.screen.menu.get_child(2), "cold freeplay Map")
		await frames(3)
		var map = app.screen.current_panel
		check(map.story_address().is_empty() and map.wormhole_address().is_empty() and map.portal_view == null,
			"paid freeplay Map has no ghost campaign or closed portal")
		await shot("cold_cleanup_map_%d" % index)
		for section in [0, 1, 3, 4, 5]:
			press(app.screen.menu.get_child(section), "cold cleanup station section")
			await frames(3)
			check(app.screen.current_panel != null, "cold cleanup station section%d remains available" % section)
		check(snapshot() == expected, "station panels preserve paid resources, cargo, job count and flags")
		await shot("cold_cleanup_station_%d" % index)
	await save_checkpoint()
	check(snapshot() == expected and saved_state(app.AUTOSAVE_SLOT) == expected,
		"manual Save/title reload preserves the independently cold-loaded result")
	check(FileAccess.get_file_as_bytes(source) == source_bytes, "actual earned cleanup input stays byte-identical")
	await finish()
