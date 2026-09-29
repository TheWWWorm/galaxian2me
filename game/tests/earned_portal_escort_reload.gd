extends "res://tests/earned_travel_run.gd"
## Independent process; accepts only an externally hashed native41 checkpoint.
var expected_sha := ""
var header := {}
var initial_actors: Array = []
var frozen_sources := {}

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 3:
		source = args[0]
		out = args[1]
		expected_sha = args[2]
	_run.call_deferred()

func source_hashes() -> Dictionary:
	var hashes := {}
	collect_hashes("res://", hashes)
	return hashes

func collect_hashes(path: String, hashes: Dictionary) -> void:
	for dir in DirAccess.get_directories_at(path):
		if path == "res://" and dir not in ["src", "tests"]: continue
		collect_hashes(path.path_join(dir), hashes)
	for file in DirAccess.get_files_at(path):
		if file.ends_with(".gd"): hashes[path.path_join(file)] = FileAccess.get_sha256(path.path_join(file))

func _run() -> void:
	if started: return
	started = true
	if source.is_empty() or out.is_empty() or expected_sha.length() != 64 or not FileAccess.file_exists(source) or DirAccess.dir_exists_absolute(out):
		push_error("Provide an externally pinned native41 save and a NEW cold output directory.")
		quit(2)
		return
	root.size = Vector2i(1280, 800)
	DirAccess.make_dir_recursive_absolute(out)
	frozen_sources = source_hashes()
	source_bytes = FileAccess.get_file_as_bytes(source)
	header = JSON.parse_string(source_bytes.get_string_from_utf8())
	app = TestApp.new()
	save_root = out.path_join("test-saves-%d" % Time.get_ticks_usec())
	app.disk_saves = save_root
	node_added.connect(watch_flight_entry)
	root.add_child(app)
	await frames(3)
	check(FileAccess.get_sha256(source) == expected_sha, "input matches the independently recorded native crossing hash")
	if failures > 0 or not app.activate(str(header.get("content", ""))):
		check(false, "earned input and supplied content are valid")
		await finish()
		return
	input_step = int(header.story_step)
	check(input_step == 41 and bool(header.in_void) and int(header.flags.get("final_escort_hull", 0)) > 0,
		"checkpoint is the earned Void entry with actual surviving freighter health")
	DirAccess.make_dir_recursive_absolute(app.save_path(app.AUTOSAVE_SLOT).get_base_dir())
	check(DirAccess.copy_absolute(source, app.save_path(app.AUTOSAVE_SLOT)) == OK, "COPY actual autosave into fresh isolated storage")
	await title_load()
	var expected := header.duplicate(true)
	expected.erase("saved_at")
	check(app.screen is Flight and snapshot() == expected, "cold native load preserves the entire earned session without docking service")
	check(app.save_attempts.is_empty(), "cold flight load creates no autosave or replayed crossing")
	if not app.screen is Flight or failures > 0:
		await finish()
		return
	var space = app.screen.space
	var story = space.story
	check(space.clock == 0 and app.screen.menu_paused, "ordinary Pause freezes the first native flight before damage or movement")
	check(story != null and story.step == 41 and story.active() and story.cast.size() == 5,
		"cold load builds one freighter and four Void fighters at the actual -1 mission address")
	var guide: Body = story.cast[0]
	check(guide.alive and guide.ship_index == 13 and guide.hull == int(header.flags.final_escort_hull),
		"freighter restores its exact damaged crossing health, not a repaired hull")
	check(guide.hull_max == maxi((20 + mini(app.game.session.stat("rank"), 20) * 15 + 41 * 4) * 4, guide.hull),
		"carried health raises the new scene maximum only as the supplied setter does")
	check(guide.pos == Vector3(0, 0, -200000) and space.player.pos == Vector3(3000, 2000, -220000),
		"cold entry preserves the original freighter and player start poses")
	check(guide.friendly and not guide.hostile and guide.cargo.is_empty() and guide.speed == 1.0,
		"cold freighter remains moving and fixed friendly without generated loot")
	check(space.player.hull + space.player.armor == int(header.ship.hull)
		and space.player.armor == int(header.ship.armor) and space.player.shield == float(header.ship.shield),
		"cold player retains exact base hull, armor and shield from the physical crossing")
	check(not story.complete and not story.failed and not bool(app.game.session.story_mission.get("done", false)),
		"loading does not finish or fail the mothership mission")
	check(not app.game.campaign.check(false, -1, 999999), "elapsed time alone cannot complete the unfinished combat objective")
	check(app.game.session.credits == int(header.credits) and snapshot().equipment == header.equipment
		and snapshot().cargo == header.cargo and snapshot().blueprints == header.blueprints,
		"money, finite weapons, cargo and partial drive recipe survive the cold round trip")
	var invalid := expected.duplicate(true)
	invalid.flags.erase("final_escort_hull")
	check(not app.game.session._validate_save(invalid).is_empty(), "missing carried health is rejected instead of invented")
	invalid.flags.final_escort_hull = 0
	check(not app.game.session._validate_save(invalid).is_empty(), "dead freighter state cannot be loaded as a successful crossing")
	invalid.flags.final_escort_hull = "1200"
	check(not app.game.session._validate_save(invalid).is_empty(), "non-numeric carried health is rejected")
	await shot("cold_native_escort41")
	await title_load()
	check(app.screen is Flight and snapshot() == expected and app.screen.space.story.cast[0].hull == guide.hull,
		"second native title Load preserves the exact campaign and damaged freighter again")
	check(app.save_attempts.is_empty() and saved_state(app.AUTOSAVE_SLOT) == expected,
		"repeated loading never repairs, rewards, or rewrites the copied checkpoint")
	check(FileAccess.get_file_as_bytes(source) == source_bytes, "original earned autosave remains byte-identical")
	await shot("cold_native_escort41_second_load")
	await finish()

func title_load() -> void:
	app.show_title()
	await frames(3)
	app.screen._load()
	await frames(2)
	press(app.screen.panel_holder.get_child(0).get_child(0).get_child(0), "title Load earned escort Autosave")
	await frames(3)

func check_flight_entry(reference: WeakRef) -> void:
	var flight = reference.get_ref()
	if flight == null: return
	flight.set_paused(true)
	initial_actors.append({"clock": flight.space.clock, "player_hull": flight.space.player.hull,
		"armor": flight.space.player.armor, "shield": flight.space.player.shield,
		"freighter_hull": flight.space.story.cast[0].hull, "step": flight.game.session.story_step})

func finish() -> void:
	check(source_hashes() == frozen_sources, "native production and test scripts stayed frozen during independent cold verification")
	var file := FileAccess.open(out.path_join("cold-escort-ledger.json"), FileAccess.WRITE)
	if file != null: file.store_string(JSON.stringify({"source_sha256": FileAccess.get_sha256(source), "entries": initial_actors,
		"source_hashes_before": frozen_sources, "source_hashes_after": source_hashes()}, "\t"))
	await super.finish()
