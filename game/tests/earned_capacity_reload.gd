extends "res://tests/earned_capacity_run.gd"
## Cold native load of the actual earned Inflict/drill checkpoint. The
## separate autosave input is the real earlier Nepis docking transaction.
const READY_SHA := "5af8f3aeff1b370d9403a382d18c5b6546517a603c5b6346a88b31977f833d2c"
var autosave_source := ""
func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 3:
		source = args[0]
		autosave_source = args[1]
		out = args[2]
	_run.call_deferred()
func _run() -> void:
	if started: return
	started = true
	if source.is_empty() or autosave_source.is_empty() or out.is_empty() or DirAccess.dir_exists_absolute(out):
		push_error("Provide actual capacity-ready JSON, actual earlier docking JSON, and NEW private output directory.")
		quit(2)
		return
	root.size = Vector2i(1280, 800)
	DirAccess.make_dir_recursive_absolute(out)
	source_bytes = FileAccess.get_file_as_bytes(source)
	var auto_bytes := FileAccess.get_file_as_bytes(autosave_source)
	input_header = JSON.parse_string(source_bytes.get_string_from_utf8())
	var auto_header = JSON.parse_string(auto_bytes.get_string_from_utf8())
	app = TestApp.new()
	save_root = out.path_join("test-saves-%d" % Time.get_ticks_usec())
	app.disk_saves = save_root
	root.add_child(app)
	await frames(3)
	check(FileAccess.get_sha256(source) == READY_SHA, "exact genuinely earned Inflict/drill input hash")
	if failures > 0 or not auto_header is Dictionary or not app.activate(str(input_header.get("content", ""))):
		check(false, "valid earned inputs and supplied content are installed")
		await finish()
		return
	input_step = int(input_header.story_step)
	DirAccess.make_dir_recursive_absolute(app.save_path(0).get_base_dir())
	check(DirAccess.copy_absolute(source, app.save_path(0)) == OK, "COPY capacity-ready checkpoint into fresh isolated host")
	app.show_title()
	await frames(3)
	app.screen._load()
	await frames(2)
	press(app.screen.panel_holder.get_child(0).get_child(0).get_child(1), "native title Load actual capacity-ready slot")
	await frames(4)
	var expected := input_header.duplicate(true)
	expected.erase("saved_at")
	check(app.screen is Station and snapshot() == expected and app.save_attempts.is_empty(),
		"cold load restores every field without resettlement or a new save")
	var s = app.game.session
	check(s.story_step == 33 and s.station_id == 38 and s.system_index == 7 and not s.in_void,
		"earned capacity state remains normal-space Nepis awaiting crystal mining")
	check(int(s.ship.index) == 5 and s.ship_stats().cargo_capacity == 60 and s.cargo_used() == 6 and s.cargo_free() == 54,
		"actual supplied Inflict has 54 free tonnes with no cargo override")
	check(s.credits == 530 and s.cargo_count(133) == 2 and int(s.equipment[1][0].count) == 7,
		"cold reload preserves last530credits, both genuine whiskey units and all seven rockets")
	check(s.equipped_of_type(app.catalogue.Type.MINING_LASER).id == 87,
		"the actual purchased IMT Extract2.7 remains fitted")
	check(dialogue(app.screen) == null and app.game.pending_dialogue.is_empty(), "no already-seen reward dialogue replays")
	check(s.cargo_count(164) == 0 and s.blueprints.is_empty() and not app.game.campaign.check(true, 10),
		"a large hold and drill cannot substitute for fifty genuinely mined crystals")
	press(app.screen.menu.get_child(0), "inspect cold-loaded Hangar")
	await frames(3)
	var tabs = app.screen.current_panel
	tabs.current_tab = 1
	await frames(3)
	var fitting = tabs.get_child(1)
	check(fitting.ship_frame.title == app.catalogue.ship_name(5), "native fitting panel labels the actual Inflict")
	var rows: Array = fitting.slots_list.get_children().filter(func(n): return n is Button and not n.is_queued_for_deletion())
	press(rows.back(), "inspect fitted mining drill")
	await frames(3)
	await shot("cold_capacity_fitting")
	check(snapshot() == expected, "viewing fitted gear changes no earned resources")
	await inspect_warning("capacity_cold")
	check(int(auto_header.station) == 38 and int(auto_header.credits) == 18261 and auto_header.cargo == input_header.cargo,
		"autosave comparator is the real preceding Nepis docking before17731credit drill purchase")
	check(DirAccess.copy_absolute(autosave_source, app.save_path(app.AUTOSAVE_SLOT)) == OK,
		"copy actual prior docking save without inventing an autosave transaction")
	await save_checkpoint()
	check(snapshot() == expected, "native manual save and second title load preserve full earned capacity state")
	check(FileAccess.get_file_as_bytes(source) == source_bytes and FileAccess.get_file_as_bytes(autosave_source) == auto_bytes,
		"both original earned manual and docking input files remain byte-identical")
	await finish()
