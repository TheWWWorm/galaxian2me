extends "res://tests/earned_travel_run.gd"
## Separate native process and separate disk host; never synthesizes an ending.
var recorded_sha := ""
var header := {}
func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 3:
		source = args[0]
		out = args[1]
		recorded_sha = args[2]
	_run.call_deferred()

func _run() -> void:
	if started: return
	started = true
	if recorded_sha.length() != 64 or FileAccess.get_sha256(source) != recorded_sha or out.is_empty() or DirAccess.dir_exists_absolute(out):
		push_error("Provide the real earned ending, NEW output and independently recorded hash.")
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
	check(app.activate(str(header.content)), "earned ending supplied content is installed")
	check(int(header.story_step) == 45 and header.story_mission.is_empty() and not bool(header.in_void)
		and int(header.station) == 98 and int(header.credits) == 42337, "only the actual Alioth45 ending and exact once-paid balance are accepted")
	if failures > 0:
		await finish()
		return
	DirAccess.make_dir_recursive_absolute(app.save_path(app.AUTOSAVE_SLOT).get_base_dir())
	check(DirAccess.copy_absolute(source, app.save_path(app.AUTOSAVE_SLOT)) == OK, "COPY earned ending into independent native storage")
	var expected := header.duplicate(true)
	expected.erase("saved_at")
	for index in 2:
		app.show_title()
		await frames(3)
		app.screen._load()
		await frames(2)
		press(app.screen.panel_holder.get_child(0).get_child(0).get_child(0), "title Load actual ending")
		await frames(4)
		check(app.screen is Station and snapshot() == expected, "cold title load preserves the complete native terminal state")
		check(app.save_attempts.is_empty(), "cold title load writes no autosave and replays no reward")
		check(dialogue(app.screen) == null and app.game.pending_dialogue.is_empty(), "acknowledged epilogues never replay after cold load")
		press(app.screen.menu.get_child(2), "inspect terminal Map")
		await frames(3)
		var map = app.screen.current_panel
		check(map.story_address().is_empty() and map.wormhole_address().is_empty() and map.portal_view == null,
			"finished campaign exposes neither a ghost story marker nor a closed wormhole")
		await shot("cold_ending_map_%d" % index)
		for section in [0, 1, 3, 4, 5]:
			press(app.screen.menu.get_child(section), "post-ending station section")
			await frames(3)
			check(app.screen.current_panel != null, "post-ending station section%d remains usable" % section)
		check(snapshot() == expected, "post-ending menu inspection changes no saved resources or flags")
		await shot("cold_ending_station_%d" % index)
	await save_checkpoint()
	check(snapshot() == expected and saved_state(app.AUTOSAVE_SLOT) == expected, "manual save and title reload preserve the once-paid ending")
	check(FileAccess.get_file_as_bytes(source) == source_bytes, "accepted earned ending remains byte-identical")
	await finish()
