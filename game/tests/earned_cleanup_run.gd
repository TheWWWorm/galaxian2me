extends "res://tests/earned_epilogue_run.gd"
## COPY actual earned terminal45. Only lounge/Map/flight/projectiles/Next and
## native docking/Save/Load may change this run's state. No scenario fixtures.
const FREEPLAY_SHA := "8d9e3826cfcf1b08f8ffeb9cb5f675e6b0be57e66c1c0319a11400437c14a3b4"
const Cleanup := preload("res://tests/support/cleanup_pilot.gd")
var cleaner := Cleanup.new()
var scenes: Array = []
var junk_deaths: Array = []
var reports: Array = []
var report_lines: Array = []
var earned_contract := {}

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 2: source = args[0]; out = args[1]
	_run.call_deferred()

func _run() -> void:
	if started: return
	started = true
	if FileAccess.get_sha256(source) != FREEPLAY_SHA or out.is_empty() or DirAccess.dir_exists_absolute(out):
		push_error("Provide the accepted native freeplay45 and a NEW output directory.")
		quit(2)
		return
	root.size = Vector2i(1280, 800)
	DirAccess.make_dir_recursive_absolute(out)
	frozen_sources = source_hashes()
	source_bytes = FileAccess.get_file_as_bytes(source)
	header = JSON.parse_string(source_bytes.get_string_from_utf8())
	input_step = int(header.story_step)
	last_native_kills = int(header.stats.kills)
	app = TestApp.new()
	save_root = out.path_join("test-saves-%d" % Time.get_ticks_usec())
	app.disk_saves = save_root
	node_added.connect(watch_flight_entry)
	node_added.connect(trace_flight_node)
	root.add_child(app)
	await frames(3)
	check(app.activate(str(header.content)), "accepted freeplay content is installed")
	DirAccess.make_dir_recursive_absolute(app.save_path(app.AUTOSAVE_SLOT).get_base_dir())
	check(DirAccess.copy_absolute(source, app.save_path(app.AUTOSAVE_SLOT)) == OK, "COPY actual freeplay45 into fresh isolated native storage")
	app.show_title()
	await frames(3)
	app.screen._load()
	await frames(2)
	press(app.screen.panel_holder.get_child(0).get_child(0).get_child(0), "title Load accepted freeplay")
	await frames(4)
	var expected := header.duplicate(true)
	expected.erase("saved_at")
	check(app.screen is Station and snapshot() == expected and app.save_attempts.is_empty(),
		"actual freeplay title load preserves all state without new saves or rewards")
	check(input_step == 45 and app.game.session.job.is_empty() and app.game.session.credits == 42337,
		"the already-earned ending is the sole starting point")
	if failures == 0: await accept_cleanup()
	if failures == 0:
		await save_checkpoint()
		check(DirAccess.copy_absolute(app.save_path(0), out.path_join("earned-accepted-cleanup.json")) == OK,
			"retain native accepted-job save before the actual flight")
		seen_screen = app.screen.get_instance_id()
		if await choose_destination(int(chosen_contract.station)) and await fly_to_dock():
			await retain_dock()
	if failures == 0:
		check(app.game.session.station_id == 96 and app.game.session.system_index == 19 and app.screen is Station,
			"actual map flight and docking reach Kalun Amir96")
		check(reports.size() == 1 and junk_deaths.size() == 36 and shots > 0,
			"actual native projectiles destroy every required junk and produce one completion report")
		check(not reports.is_empty() and bool(reports[0].complete) and not bool(reports[0].failed)
			and int(reports[0].clock) < 121000 and int(reports[0].junk_destroyed) == 36,
			"cleanup completes within its unmodified deadline with observed junk accounting")
		check(app.game.session.credits == 45687 and app.game.session.stat("jobs") == 3
			and app.game.session.job.is_empty(), "earned cleanup pays exactly3350 once and records the third real contract")
		check(app.game.session.story_step == 45 and app.game.session.story_mission.is_empty()
			and int(app.game.session.flags.wormhole_station) == -1 and int(app.game.session.flags.wormhole_system) == -1,
			"freelance completion cannot restart the finale or reopen closed portals")
		check(report_lines.size() == 1 and not reports.is_empty() and str(report_lines[0].text) == str(reports[0].report.text),
			"the actual native client report was displayed and acknowledged through Next")
		check(app.game.session.equipment == header.equipment and app.game.session.blueprints == header.blueprints,
			"the original finite equipment and unfinished drive remain unchanged")
		var gains := {}
		var valid := true
		for observer in observers.values():
			valid = valid and observer.errors.is_empty()
			for key in observer.totals: gains[key] = int(gains.get(key, 0)) + int(observer.totals[key])
		var cargo: Dictionary = header.cargo.duplicate(true)
		var gained := 0
		for key in gains: cargo[key] = int(cargo.get(key, 0)) + int(gains[key]); gained += int(gains[key])
		check(valid and cargo == app.game.session.cargo and app.game.session.cargo_free() >= 0
			and gained == app.game.session.stat("cargo_salvaged") - int(header.stats.cargo_salvaged),
			"every cargo change matches a consumed physical payload and the salvage counter")
		check(app.game.session.stat("kills") == last_native_kills and gate_events.is_empty()
			and app.game.session.stat("jumpgates") == int(header.stats.jumpgates),
			"cleanup records no phantom ship kill or gate crossing")
		check(saved_state(app.AUTOSAVE_SLOT) == snapshot(), "native docking autosave contains the complete paid cleanup state")
		await shot("actual_cleanup_paid_dock")
		await save_checkpoint()
		check(app.game.session.credits == 45687 and app.game.session.stat("jobs") == 3,
			"manual Save and title Load preserve the once-paid freelance reward")
		if failures == 0:
			var path := out.path_join("earned-cleanup45.json")
			check(DirAccess.copy_absolute(app.save_path(0), path) == OK, "retain actual paid cleanup continuation")
			earned_contract = {"path": path, "sha256": FileAccess.get_sha256(path), "state": snapshot()}
			completed_contract = failures == 0
	check(decisions > 0 and decisions_readonly, "all cleanup and travel input decisions preserve world, session and RNG")
	check(FileAccess.get_file_as_bytes(source) == source_bytes, "original accepted ending/freeplay input remains byte-identical")
	await finish()

func accept_cleanup() -> void:
	press(app.screen.menu.get_child(1), "Space Lounge after the ending")
	await frames(3)
	var lounge = app.screen.current_panel
	var people: Array = app.game.lounge()
	var choice := -1
	for index in people.size():
		var offer: Dictionary = people[index].get("job", {})
		if int(offer.get("kind", -1)) == 7 and int(offer.get("station", -1)) == 96:
			choice = index
			chosen_contract = offer.duplicate(true)
			break
	check(choice >= 0 and int(chosen_contract.get("difficulty", -1)) == 6
		and int(chosen_contract.get("reward", -1)) == 3350, "the real saved lounge still offers the audited cleanup contract")
	if choice < 0: return
	print("ACTUAL CLEANUP OFFER ", JSON.stringify(people[choice]))
	var label := "%s — %s" % [people[choice].name, app.catalogue.faction_name(int(people[choice].race))]
	if not press(item_row(lounge.list, label), "select the displayed cleanup client"): return
	await frames(3)
	await shot("actual_cleanup_offer")
	if not press(named_button(lounge.detail, app.library.text(38)), "accept actual cleanup offer"): return
	await frames(3)
	check(app.game.session.job == chosen_contract and app.game.session.credits == 42337
		and app.game.session.stat("jobs") == 2 and app.game.session.cargo == header.cargo,
		"native lounge acceptance records the offer without paying, consuming or inventing cargo")
	await shot("actual_cleanup_accepted")

func check_flight_entry(reference: WeakRef) -> void:
	super.check_flight_entry(reference)
	cleaner = Cleanup.new()
	var flight = reference.get_ref()
	if flight == null: return
	flight.space.event.connect(cleanup_event.bind(reference))
	var story = flight.space.story
	if story != null and not story.job.is_empty() and int(story.job.kind) == 7:
		check(flight.space.station.station_id == 96 and story.cast.size() == 37
			and int(story.failure.ms) == 121000, "actual arrival creates the source cleanup scene, not a substituted encounter")
		scenes.append({"station": flight.space.station.station_id, "job": story.job.duplicate(true),
			"initial": Observation.capture(flight.space)})

func cleanup_event(kind: String, data: Dictionary, reference: WeakRef) -> void:
	var flight = reference.get_ref()
	if flight == null: return
	var space = flight.space
	if kind == "killed" and data.body.is_junk():
		junk_deaths.append({"clock": space.clock, "body": Observation.fields(data.body),
			"kills": app.game.session.stat("kills"), "junk_destroyed": int(space.stats.get("junk_destroyed", 0))})
	if kind == "job_report":
		reports.append({"clock": space.clock, "complete": space.story.complete, "failed": space.story.failed,
			"junk_destroyed": int(space.stats.get("junk_destroyed", 0)), "report": data.duplicate(true),
			"state": snapshot(), "observation": Observation.capture(space)})
		print("ACTUAL CLEANUP REPORT ", space.clock, " complete=", space.story.complete, " junk=", space.stats.get("junk_destroyed", 0))

func pilot(reference: WeakRef) -> Dictionary:
	var flight = reference.get_ref()
	if flight == null: return {}
	var space = flight.space
	var story = space.story
	if story == null or story.job.is_empty() or int(story.job.kind) != 7 or story.complete or story.failed:
		return super.pilot(reference)
	var observer = observers.get(space.get_instance_id())
	if observer != null: observer.observe(space)
	var before := Observation.capture(space)
	var controls: Dictionary = cleaner.input(space)
	decisions += 1
	decisions_readonly = decisions_readonly and before == Observation.capture(space)
	if space.clock - sampled_clock >= 1000:
		sampled_clock = space.clock
		samples.append({"clock": space.clock, "station": space.station.station_id, "mode": cleaner.mode,
			"controls": controls.duplicate(), "native_observation": before})
	return controls

func observe() -> void:
	await super.observe()
	if app.screen is Flight and app.screen.space.story != null and not app.screen.space.story.job.is_empty():
		await shot("actual_cleanup_active_%d" % (app.screen.space.clock / 30000))

func clear_dialogue() -> void:
	for index in 10:
		var talk := dialogue(app.screen)
		if talk == null: return
		var line: Dictionary = talk.lines[talk.index].duplicate(true)
		report_lines.append(line)
		await shot("actual_cleanup_report_%d" % (report_lines.size() - 1))
		press(talk.next_button, "acknowledge actual cleanup client report")
		await frames(1)
	check(false, "cleanup dialogue closes within a bounded number of native lines")

func finish() -> void:
	var file := FileAccess.open(out.path_join("cleanup-ledger.json"), FileAccess.WRITE)
	if file != null: file.store_string(JSON.stringify({"scenes": scenes, "deaths": junk_deaths,
		"reports": reports, "lines": report_lines, "earned": earned_contract, "completed": completed_contract}, "\t"))
	await super.finish()
