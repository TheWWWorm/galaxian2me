extends "res://tests/earned_capacity_run.gd"
## Independent native process; COPY only an externally hashed earned save.
var recorded_sha := ""
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
	if source.is_empty() or out.is_empty() or recorded_sha.length() != 64 or not FileAccess.file_exists(source) or DirAccess.dir_exists_absolute(out):
		push_error("Provide earned continuation, NEW output directory and independently recorded SHA256.")
		quit(2)
		return
	root.size = Vector2i(1280, 800)
	DirAccess.make_dir_recursive_absolute(out)
	source_bytes = FileAccess.get_file_as_bytes(source)
	input_header = JSON.parse_string(source_bytes.get_string_from_utf8())
	app = TestApp.new()
	save_root = out.path_join("test-saves-%d" % Time.get_ticks_usec())
	app.disk_saves = save_root
	root.add_child(app)
	await frames(3)
	check(FileAccess.get_sha256(source) == recorded_sha, "cold input matches the independently retained native checkpoint hash")
	if failures > 0 or not input_header is Dictionary or not app.activate(str(input_header.get("content", ""))):
		check(false, "earned input and supplied content are valid")
		await finish()
		return
	input_step = int(input_header.story_step)
	check(input_step in [35, 36, 38, 39, 40] and not bool(input_header.in_void), "input is an earned normal-space continuation")
	DirAccess.make_dir_recursive_absolute(app.save_path(app.AUTOSAVE_SLOT).get_base_dir())
	check(DirAccess.copy_absolute(source, app.save_path(app.AUTOSAVE_SLOT)) == OK, "COPY the actual earned checkpoint into a fresh native autosave slot")
	app.show_title()
	await frames(3)
	app.screen._load()
	await frames(2)
	press(app.screen.panel_holder.get_child(0).get_child(0).get_child(0), "native title Load earned Autosave")
	await frames(4)
	var expected := input_header.duplicate(true)
	expected.erase("saved_at")
	check(app.screen is Station and snapshot() == expected and app.save_attempts.is_empty(),
		"cold native load preserves every resource and flag without reward, repair or autosave")
	var s = app.game.session
	var next: Array = app.game.campaign.step_record(input_step).missions.back()
	check(int(s.story_mission.kind) == int(next[0]) and int(s.story_mission.station) == int(next[2])
		and not bool(s.story_mission.get("done", false)), "cold continuation keeps the actual supplied next objective uncompleted")
	check(s.blueprints == expected.blueprints and s.cargo_count(164) == 4 and s.cargo_count(85) == 0
		and not bool(s.ship_stats().jump_drive), "partial Khador recipe and four spare crystals survive without a completed drive")
	check(s.credits == int(expected.credits) and int(s.ship.index) == 5 and s.equipment[1] == expected.equipment[1],
		"cold Inflict retains real money and the exact earned finite ammunition count")
	check(dialogue(app.screen) == null and app.game.pending_dialogue.is_empty(), "cold load never replays the earned result dialogue")
	press(app.screen.menu.get_child(2), "inspect cold continuation Map")
	await frames(4)
	var map = app.screen.current_panel
	var expected_marker := {"station": int(next[2]), "system": app.catalogue.system_of_station(int(next[2]))}
	if int(next[2]) == -1:
		# The source Map resolves later Void missions through saved g/h;
		# -1 is the mission address, not a normal-space station marker.
		expected_marker = {"station": int(expected.flags.get("wormhole_station", -1)),
			"system": int(expected.flags.get("wormhole_system", -1))}
	check(expected_marker.station >= 0 and app.catalogue.system_of_station(expected_marker.station) == expected_marker.system
		and map.story_address() == expected_marker, "native Map marks the supplied continuation or its retained portal address")
	await shot("cold_continuation_map")
	press(app.screen.menu.get_child(0), "inspect cold continuation Hangar")
	await frames(3)
	var tabs = app.screen.current_panel
	tabs.current_tab = 1
	await frames(3)
	check(tabs.get_child(1).ship_frame.title == app.catalogue.ship_name(5), "native fitting shows the actually purchased Inflict")
	await shot("cold_continuation_inflict")
	check(snapshot() == expected, "Map and fitting inspection change no earned fields")
	await save_checkpoint()
	check(snapshot() == expected and saved_state(app.AUTOSAVE_SLOT) == expected,
		"native manual Save and second title Load preserve the exact earned checkpoint")
	check(FileAccess.get_file_as_bytes(source) == source_bytes, "original earned continuation remains byte-identical")
	await finish()
