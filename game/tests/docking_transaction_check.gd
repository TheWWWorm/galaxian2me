extends SceneTree
## Explicit settlement/repair fixture, NOT an earned second-contract run.
## Starts with a COPY of an earned step-13, one-job checkpoint. Only this
## isolated copy receives synthetic freight/damage; campaign progress is loaded.
## godot --headless --path game -s res://tests/docking_transaction_check.gd -- <earned-slot.json> <out-dir>

const TestApp := preload("res://tests/support/isolated_app.gd")
var app: TestApp
var checks: Array = []
var failures := 0
var source := ""
var out := ""

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 2:
		source = args[0]
		out = args[1]
	_run.call_deferred()

func check(ok: bool, label: String) -> void:
	checks.append({"test": label, "passed": ok})
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)

func frames(count: int) -> void:
	for i in count:
		await physics_frame
		await process_frame

func snapshot() -> Dictionary:
	return JSON.parse_string(JSON.stringify(app.game.session.to_dict()))

func _run() -> void:
	if source.is_empty() or out.is_empty() or not FileAccess.file_exists(source):
		quit(2)
		return
	var digest := FileAccess.get_sha256(source)
	var original = JSON.parse_string(FileAccess.get_file_as_string(source))
	DirAccess.make_dir_recursive_absolute(out)
	app = TestApp.new()
	app.disk_saves = out.path_join("test-saves-%d" % Time.get_ticks_usec())
	root.add_child(app)
	await frames(3)
	if not original is Dictionary or not app.activate(str(original.get("content", ""))):
		check(false, "source content is installed")
		await finish()
		return
	DirAccess.make_dir_recursive_absolute(app.save_path(0).get_base_dir())
	check(DirAccess.copy_absolute(source, app.save_path(0)) == OK, "copy earned source into isolated fixture storage")
	check(app.load_game(0).is_empty(), "load the earned source through the production reader")
	var session = app.game.session
	if session.story_step != 13 or session.stat("jobs") != 1:
		check(false, "fixture input must already have earned step thirteen and one completed job")
		await finish()
		return
	var credits: int = session.credits
	# Deliberate local failure fixture: a one-ton delivery and damaged layers.
	# This proves transaction ordering, not that the second job was played.
	session.job = {"kind": 0, "station": session.station_id, "count": 1,
		"reward": 37, "client": "Settlement regression fixture", "story": false}
	session.add_cargo(116, 1)
	session.ship.hull = 1
	session.ship.armor = 0
	session.ship.shield = 0
	check(not app.game.campaign.check(true, session.station_id), "one earned job does not prematurely complete the two-job goal")
	var attempts := app.save_attempts.size()
	app.game.dock(session.station_id)
	var settled := snapshot()
	var saved := app.save_summary(app.AUTOSAVE_SLOT)
	saved.erase("saved_at")
	check(session.stat("jobs") == 2 and session.credits == credits + 37, "fixture delivery settles exactly once")
	check(session.job.is_empty() and session.cargo_count(116) == 0, "settled fixture removes its freight and active contract")
	check(session.story_step == 14 and int(saved.story_step) == 14, "delivery satisfies the story goal before the docking checkpoint")
	check(int(session.ship.hull) == int(session.ship_stats().max_hull) and int(session.ship.armor) == int(session.ship_stats().armor_plate), "damaged fixture is serviced before checkpointing")
	check(saved == settled and app.save_attempts.size() == attempts + 1, "one autosave contains the entire settled transaction")
	await frames(4)
	check(snapshot() == settled, "deferred station updates do not change the checkpointed transaction")
	check(app.load_game(app.AUTOSAVE_SLOT).is_empty(), "the settled transaction reloads")
	await frames(4)
	check(snapshot() == settled and app.save_attempts.size() == attempts + 1, "reload neither repeats rewards nor writes another checkpoint")
	check(FileAccess.get_sha256(source) == digest, "earned source remains byte-identical despite all synthetic fixture changes")
	await finish()

func finish() -> void:
	var result := {"checks": checks, "failures": failures, "fixture": true,
		"source": source, "save_root": app.disk_saves}
	app.queue_free()
	await frames(3)
	var file := FileAccess.open(out.path_join("report.json"), FileAccess.WRITE)
	if file != null: file.store_string(JSON.stringify(result, "\t"))
	print("DOCKING TRANSACTION FIXTURE: %d checks, %d failures" % [checks.size(), failures])
	quit(1 if failures else 0)
