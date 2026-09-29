extends "res://tests/earned_khador_run.gd"
## Fresh-process native reload of the genuinely earned C33 checkpoint.
## Original A32 is read only to audit resources; it is never loaded into
## this host or combined with C33. No replay outcome is silently rewritten.
const EARNED_SHA := "cf1b478a661e3c5563b273609fe71110858a83e1f2eaaf3492ad45b1d2c4897f"
var original_source := ""
func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 3:
		source = args[0]
		original_source = args[1]
		out = args[2]
	_run.call_deferred()
func _run() -> void:
	if started: return
	started = true
	if source.is_empty() or original_source.is_empty() or out.is_empty() or DirAccess.dir_exists_absolute(out):
		push_error("Provide C33, original A32, and a NEW private output directory.")
		quit(2)
		return
	root.size = Vector2i(1280, 800)
	DirAccess.make_dir_recursive_absolute(out)
	source_bytes = FileAccess.get_file_as_bytes(source)
	app = TestApp.new()
	save_root = out.path_join("test-saves-%d" % Time.get_ticks_usec())
	app.disk_saves = save_root
	root.add_child(app)
	await frames(3)
	check(FileAccess.get_sha256(source) == EARNED_SHA and FileAccess.get_sha256(original_source) == INPUT_SHA,
		"both earned C33 and its original A32 ancestor have their exact retained hashes")
	var header = JSON.parse_string(source_bytes.get_string_from_utf8())
	input_header = JSON.parse_string(FileAccess.get_file_as_string(original_source))
	if not header is Dictionary or failures > 0 or not app.activate(str(header.get("content", ""))):
		check(false, "valid earned input and installed supplied content")
		await finish()
		return
	input_step = int(header.story_step)
	DirAccess.make_dir_recursive_absolute(app.save_path(0).get_base_dir())
	check(DirAccess.copy_absolute(source, app.save_path(0)) == OK, "COPY actual C33 into a fresh isolated process")
	app.show_title()
	await frames(3)
	app.screen._load()
	await frames(2)
	press(app.screen.panel_holder.get_child(0).get_child(0).get_child(1), "native title Load earned C33")
	await frames(4)
	header.erase("saved_at")
	check(app.screen is Station and snapshot() == header and app.save_attempts.is_empty(),
		"cold title load restores every earned C33 field without writing a new docking result")
	check(app.game.session.story_step == 33 and app.game.session.station_id == 10
		and app.game.session.system_index == 6 and not app.game.session.in_void,
		"earned state remains normal-space Thynome, awaiting actual crystals")
	check_resources(input_header)
	check(dialogue(app.screen) == null and app.game.pending_dialogue.is_empty(),
		"loading never replays the already-seen Khador result")
	check(app.game.session.blueprints.is_empty() and not app.game.campaign.check(true, 10),
		"zero crystals still cannot advance or grant a blueprint after a cold load")
	await shot("cold_c33_native_station")
	await inspect_warning("cold33")
	# The fresh host has no autosave: do not manufacture a docking event just
	# to create one. Copy the real earned autosave as the control comparator.
	check(DirAccess.copy_absolute(source, app.save_path(app.AUTOSAVE_SLOT)) == OK,
		"copy the actual earned docking checkpoint without settling the mission again")
	await save_checkpoint()
	check_resources(input_header)
	check(FileAccess.get_file_as_bytes(source) == source_bytes and FileAccess.get_sha256(original_source) == INPUT_SHA,
		"cold save/reload leaves both earned ancestors untouched")
	await finish()
