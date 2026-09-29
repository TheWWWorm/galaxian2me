extends SceneTree
## Storage/recovery regressions using a COPY of an earned checkpoint from a
## separate smoke run. Deliberately malformed saves and lethal player damage
## below are failure fixtures, not claims of earned campaign progression.
## Never accesses player saves/settings; all writes stay under <out-dir>.
## godot --headless --path game --fixed-fps 60 -s res://tests/save_recovery_check.gd -- <earned-slot.json> <out-dir>

const TestApp := preload("res://tests/support/isolated_app.gd")
const Session := preload("res://src/simulation/session.gd")
const Flight := preload("res://src/screens/flight_screen.gd")
const Station := preload("res://src/screens/station_screen.gd")

var app: TestApp
var source := ""
var out := ""
var checks: Array = []
var failures := 0

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 2:
		source = args[0]
		out = args[1]
	_run.call_deferred()

func check(ok: bool, label: String) -> void:
	checks.append({"test": label, "passed": ok})
	print("PASS: " if ok else "FAIL: ", label)
	if not ok: failures += 1

func frames(count: int) -> void:
	for i in count:
		await physics_frame
		await process_frame

func snapshot() -> Dictionary:
	return JSON.parse_string(JSON.stringify(app.game.session.to_dict()))

func write_slot(slot: int, text: String) -> void:
	var f := FileAccess.open(app.save_path(slot), FileAccess.WRITE)
	check(f != null, "write isolated slot fixture %d" % slot)
	if f != null: f.store_string(text)

func reject(d: Dictionary, label: String) -> void:
	var original = app.game
	var state := snapshot()
	write_slot(1, JSON.stringify(d))
	var error := app.load_game(1)
	check(not error.is_empty() and app.game == original and snapshot() == state, label)
	if error.is_empty(): app.load_game(0)
	await frames(3)

func _run() -> void:
	if source.is_empty() or out.is_empty() or not FileAccess.file_exists(source):
		push_error("Provide an existing earned JSON slot and an isolated output directory.")
		quit(2)
		return
	DirAccess.make_dir_recursive_absolute(out)
	var source_hash := FileAccess.get_sha256(source)
	var original = JSON.parse_string(FileAccess.get_file_as_string(source))
	app = TestApp.new()
	app.disk_saves = out.path_join("fixtures-%d" % Time.get_ticks_usec())
	root.add_child(app)
	await frames(3)
	if not original is Dictionary or not app.activate(str(original.get("content", ""))):
		check(false, "source JAR must still be installed")
		await finish()
		return
	DirAccess.make_dir_recursive_absolute(app.save_path(0).get_base_dir())
	check(DirAccess.copy_absolute(source, app.save_path(0)) == OK, "copy earned checkpoint into independent process storage")
	var error := app.load_game(0)
	check(error.is_empty() and app.screen is Station, "fresh process loads the earned checkpoint through production JSON reader")
	if not error.is_empty():
		await finish()
		return
	await frames(3)
	var baseline := snapshot()
	# Opening combat can award salvage which also fills the hold. A valid
	# earned step-six snapshot need not contain exactly 25 mined tons.
	check(int(baseline.story_step) == int(original.story_step) and int(baseline.story_step) >= 6 and app.game.session.stat("ore_mined") >= 10,
		"checkpoint retains its earned post-mining campaign progress and ore statistics")
	check(baseline.stats == original.stats and baseline.cargo == original.cargo and baseline.credits == original.credits,
		"fresh process preserves earned jobs, inventory and money without replaying rewards")
	check(app.save_attempts.is_empty(), "fresh-process reload does not autosave")
	var original_bytes := FileAccess.get_file_as_bytes(app.save_path(0))
	# A directory at the temporary-file path simulates a denied/failed write
	# without permissions changes or touching any player file.
	var temporary := app.save_path(0) + ".tmp"
	check(DirAccess.make_dir_absolute(temporary) == OK, "create isolated write-failure fixture")
	check(not app.save_game(0) and not app.last_save_error.is_empty(), "save reports a temporary-file write failure")
	check(FileAccess.get_file_as_bytes(app.save_path(0)) == original_bytes, "failed write preserves the previous manual checkpoint byte-for-byte")
	DirAccess.remove_absolute(temporary)
	check(app.save_game(0) and app.last_save_error.is_empty(), "save recovers after the temporary failure is removed")
	check(not FileAccess.file_exists(temporary), "successful atomic replacement leaves no temporary file")
	var before = app.game
	write_slot(1, "{")
	check(not app.load_game(1).is_empty() and app.game == before, "truncated JSON is rejected without replacing the live game")
	var bad := baseline.duplicate(true)
	bad.content = "a-different-supplied-game"
	await reject(bad, "cross-content save cannot replace the active content session")
	bad = baseline.duplicate(true)
	bad.format = 999
	await reject(bad, "incompatible save format is rejected")
	bad = baseline.duplicate(true)
	bad.erase("cargo")
	await reject(bad, "missing required state is rejected without a script error")
	bad = baseline.duplicate(true)
	bad.equipment = [null, [], [], []]
	await reject(bad, "malformed equipment arrays are rejected before screen construction")
	bad = baseline.duplicate(true)
	bad.ship = {"index": 0}
	await reject(bad, "incomplete ship state is rejected")
	bad = baseline.duplicate(true)
	bad.credits = -1
	await reject(bad, "negative credits are rejected")
	bad = baseline.duplicate(true)
	bad.story_step = 6.5
	await reject(bad, "fractional campaign cursor is rejected rather than truncated")
	bad = baseline.duplicate(true)
	bad.markets = [42]
	await reject(bad, "invalid market entries are rejected before station setup")
	bad = baseline.duplicate(true)
	bad.cargo = {"not-an-item": 1}
	await reject(bad, "invalid cargo item keys are rejected")
	bad = baseline.duplicate(true)
	bad.station = []
	write_slot(1, JSON.stringify(bad))
	check(app.save_summary(1).is_empty(), "malformed station header is safe to list in the load menu")
	bad = baseline.duplicate(true)
	bad.credits = "many"
	write_slot(1, JSON.stringify(bad))
	check(app.save_summary(1).is_empty(), "malformed credits header is safe to list in the load menu")
	# Session validation itself must be transactional, not just protected by
	# main.load_game constructing a new Game.
	var session := Session.new(app.catalogue)
	session.content_id = app.library.id
	check(session.from_dict(baseline).is_empty(), "valid session fixture loads")
	bad = baseline.duplicate(true)
	bad.station = 999999
	check(not session.from_dict(bad).is_empty(), "unknown station is rejected")
	check(JSON.parse_string(JSON.stringify(session.to_dict())) == baseline, "failed session validation leaves every field unchanged")
	var detached := baseline.duplicate(true)
	check(session.from_dict(detached).is_empty(), "valid detached snapshot loads")
	detached.ship.hull = 0
	detached.cargo.clear()
	check(JSON.parse_string(JSON.stringify(session.to_dict())) == baseline, "loaded session owns its nested containers independently")
	app.load_game(0)
	await frames(3)
	baseline = snapshot()
	var attempts := app.save_attempts.size()
	app.game.dock(app.game.session.station_id)
	check(app.save_attempts.size() == attempts + 1 and app.save_attempts.back() == app.AUTOSAVE_SLOT, "docking routes exactly one save through the isolated app")
	var auto := app.save_summary(app.AUTOSAVE_SLOT)
	auto.erase("saved_at")
	check(auto == snapshot(), "docking snapshot includes all final session fields")
	app.screen.launch_button.pressed.emit()
	await frames(3)
	check(app.screen is Flight, "recovery fixture launches through the actual station button")
	var flight = app.screen
	# A synthetic fatal hit exercises the real damage -> destroyed event ->
	# pause -> delayed recovery path, without waiting for a random attacker.
	flight.space._harm(flight.space.player, 100000000.0, 0.0, null)
	check(flight.defeated and flight.paused, "fatal hit locks the real flight screen")
	# Game Over offers the checkpoint; Continue takes it, as a player would.
	for i in 240:
		if flight.hud.game_over_layer != null: break
		await frames(1)
	var offered: bool = flight.hud.game_over_layer != null
	if offered:
		var buttons: Array = flight.hud.game_over_layer.find_children("*", "Button", true, false)
		(buttons[0] as Button).pressed.emit()
	for i in 60:
		if app.screen is Station: break
		await frames(1)
	check(offered and app.screen is Station and snapshot() == auto, "defeat reloads the settled docking checkpoint")
	check(app.save_attempts.size() == attempts + 1, "defeat recovery does not overwrite the checkpoint")
	app.disk_saves = out.path_join("no-checkpoint-%d" % Time.get_ticks_usec())
	app.recover_from_defeat()
	await frames(3)
	check(app.screen is Flight and app.game.session.story_step == 0, "without autosave, defeat restarts the opening instead of skipping to a station")
	check(app.save_attempts.size() == attempts + 1, "no-checkpoint fallback does not write a new save")
	check(FileAccess.get_sha256(source) == source_hash, "source earned checkpoint remains byte-identical after all recovery fixtures")
	await finish()

func finish() -> void:
	var result := {"source": source, "checks": checks, "failures": failures}
	if app != null:
		result["save_root"] = app.disk_saves
		app.queue_free()
		app = null
	await frames(3)
	print("SAVE RECOVERY: %d checks, %d failures" % [checks.size(), failures])
	if not out.is_empty():
		var f := FileAccess.open(out.path_join("report.json"), FileAccess.WRITE)
		if f != null: f.store_string(JSON.stringify(result, "\t"))
	quit(1 if failures else 0)
