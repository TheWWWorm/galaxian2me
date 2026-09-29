extends "res://tests/earned_capacity_run.gd"
## Cold title/menu test of an ACTUAL earned Thynome docking autosave.
## Caller supplies its independently recorded SHA, never a fixture payload.
var expected_source_sha := ""
func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 3:
		source = args[0]
		out = args[1]
		expected_source_sha = args[2]
	_run.call_deferred()
func _run() -> void:
	if started: return
	started = true
	if source.is_empty() or out.is_empty() or expected_source_sha.length() != 64 or not FileAccess.file_exists(source) or DirAccess.dir_exists_absolute(out):
		push_error("Provide earned Thynome autosave, NEW output directory and its recorded SHA256.")
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
	check(FileAccess.get_sha256(source) == expected_source_sha, "cold input matches independently recorded earned handover hash")
	if failures > 0 or not input_header is Dictionary or not app.activate(str(input_header.get("content", ""))):
		check(false, "earned handover input and supplied content are valid")
		await finish()
		return
	check(int(input_header.story_step) == 34 and int(input_header.station) == 10 and int(input_header.system) == 6 and not bool(input_header.in_void),
		"actual input is settled Thynome34, not a synthetic mining state")
	if failures > 0:
		await finish()
		return
	input_step = 34
	DirAccess.make_dir_recursive_absolute(app.save_path(app.AUTOSAVE_SLOT).get_base_dir())
	check(DirAccess.copy_absolute(source, app.save_path(app.AUTOSAVE_SLOT)) == OK,
		"COPY real docking autosave into fresh host without inventing a save transaction")
	app.show_title()
	await frames(3)
	app.screen._load()
	await frames(2)
	press(app.screen.panel_holder.get_child(0).get_child(0).get_child(0), "native title Load actual Autosave")
	await frames(4)
	var expected := input_header.duplicate(true)
	expected.erase("saved_at")
	check(app.screen is Station and snapshot() == expected and app.save_attempts.is_empty(),
		"fresh native process restores every earned field without another settlement or save")
	var s = app.game.session
	var blueprint: Dictionary = s.blueprints.get("85", {})
	var progress: Dictionary = blueprint.get("progress", {})
	check(progress.size() == 1 and int(progress.get("164", 0)) == 50 and int(blueprint.get("cost", -1)) == 0,
		"cold reload retains exactly fifty contributed crystals at zero blueprint cost")
	check(not blueprint.has("station") and s.cargo_count(85) == 0 and not bool(s.ship_stats().jump_drive),
		"cold partial recipe is neither a production order nor a completed drive")
	check(int(s.story_mission.kind) == 11 and int(s.story_mission.station) == 30,
		"cold campaign retains supplied Nehma continuation rather than advancing it")
	check(s.credits == 530 and int(s.ship.index) == 5 and s.ship_stats().cargo_capacity == 60,
		"earned money and purchased Inflict survive loading")
	check(s.cargo == expected.cargo and snapshot().equipment == expected.equipment and snapshot().stats == expected.stats,
		"all excess crystals, cores, salvage, equipment and statistics survive exactly")
	check(dialogue(app.screen) == null and app.game.pending_dialogue.is_empty(),
		"loading does not replay delivery dialogue or consume a second crystal batch")
	press(app.screen.menu.get_child(0), "inspect cold handover Hangar")
	await frames(3)
	var tabs = app.screen.current_panel
	tabs.current_tab = 1
	await frames(3)
	var fitting = tabs.get_child(1)
	check(fitting.ship_frame.title == app.catalogue.ship_name(5), "native fitting labels the actually owned Inflict")
	var rows: Array = fitting.slots_list.get_children().filter(func(n): return n is Button and not n.is_queued_for_deletion())
	press(rows.back(), "inspect cold fitted mining drill")
	await frames(3)
	await shot("cold_handover_inflict_drill")
	check(snapshot() == expected, "viewing the earned fitting state changes no resources")
	await save_checkpoint()
	check(snapshot() == expected and saved_state(app.AUTOSAVE_SLOT) == expected,
		"manual Save and second title Load preserve exact handover and original docking autosave")
	check(FileAccess.get_file_as_bytes(source) == source_bytes and FileAccess.get_sha256(source) == expected_source_sha,
		"original earned handover source remains byte-identical")
	await finish()
