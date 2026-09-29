extends "res://tests/earned_nehma_run.gd"
## Earned, externally pinned V38 or pre-departure C38 COPY -> Dekato -> Nehma.
## Only native UI and ordinary pilot controls; never assign mission/resources.
const V38_SHA := "d98c305a96d1ca07b6a5d0cdf465fc695953f6b7c14a54342974c3c2919b5dae"
const C38_SHA := "9958884bdca3e953fd0736523d26bf07aec779a8200c574e29bda9519d3fa7b7"
const CombatPilot := preload("res://tests/support/combat_pilot.gd")
const MissileObserver := preload("res://tests/support/missile_observer.gd")
const EquipmentOracle := preload("res://tests/earned_challenge_run.gd")
var combat_pilot := CombatPilot.new()
var missile_observer := MissileObserver.new()
var rescue_seen := false
var rescue_initial: Array = []
var rescue_events: Array = []
var rescue_result := {}
var rescue_failure := {}
var rescue_samples: Array = []
var rescue_radio: Array = []
var rescue_sample_clock := -1000
var run_sources := {}

func source_hashes() -> Dictionary:
	var hashes := {}
	var pending := ["res://src", "res://tests"]
	while not pending.is_empty():
		var folder: String = pending.pop_back()
		for name in DirAccess.get_files_at(folder):
			if name.ends_with(".gd"): hashes[folder.path_join(name)] = FileAccess.get_sha256(folder.path_join(name))
		for name in DirAccess.get_directories_at(folder): pending.append(folder.path_join(name))
	return hashes

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 2:
		source = args[0]
		out = args[1]
	_run.call_deferred()

func _run() -> void:
	if started: return
	started = true
	if source.is_empty() or out.is_empty() or not FileAccess.file_exists(source) or DirAccess.dir_exists_absolute(out):
		push_error("Provide an exact accepted step38 input and a NEW isolated output directory.")
		quit(2)
		return
	root.size = Vector2i(1280, 800)
	DirAccess.make_dir_recursive_absolute(out)
	run_sources = source_hashes()
	source_bytes = FileAccess.get_file_as_bytes(source)
	input_header = JSON.parse_string(source_bytes.get_string_from_utf8())
	app = TestApp.new()
	save_root = out.path_join("test-saves-%d" % Time.get_ticks_usec())
	app.disk_saves = save_root
	node_added.connect(watch_flight_entry)
	node_added.connect(trace_flight_node)
	root.add_child(app)
	await frames(3)
	var source_hash := FileAccess.get_sha256(source)
	check(source_hash in [V38_SHA, C38_SHA], "exact externally accepted native step38 docking save, not a report snapshot")
	if failures > 0 or not input_header is Dictionary or not app.activate(str(input_header.get("content", ""))):
		check(false, "earned input and supplied content are valid")
		await finish()
		return
	input_step = int(input_header.story_step)
	DirAccess.make_dir_recursive_absolute(app.save_path(0).get_base_dir())
	check(DirAccess.copy_absolute(source, app.save_path(0)) == OK, "COPY accepted step38 into NEW isolated native storage")
	app.show_title()
	await frames(3)
	app.screen._load()
	await frames(2)
	press(app.screen.panel_holder.get_child(0).get_child(0).get_child(1), "native title Load accepted step38")
	await frames(3)
	var expected := input_header.duplicate(true)
	expected.erase("saved_at")
	check(app.screen is Station and snapshot() == expected and app.save_attempts.is_empty(),
		"native title Load preserves every accepted field without repair or settlement")
	var expected_station := 85 if source_hash == C38_SHA else 27
	var expected_system := 17 if source_hash == C38_SHA else 5
	check(input_step == 38 and app.game.session.station_id == expected_station
		and app.game.session.system_index == expected_system and int(app.game.session.story_mission.station) == 22,
		"actual accepted pre-rescue checkpoint still requires the Dekato rescue")
	seen_screen = app.screen.get_instance_id()
	last_earned_kills = app.game.session.stat("kills")
	await shot("accepted_step38_input")
	if failures == 0: await route_to(22)
	if failures == 0:
		check(rescue_seen and not rescue_result.is_empty() and bool(rescue_result.won), "native Dekato rescue is earned by five settled captor deaths")
		check(app.game.session.story_step == 39 and app.game.session.station_id == 22
			and int(app.game.session.story_mission.station) == 30, "physical Dekato docking retains the original Nehma return objective")
		check(continuation_lines.get("38", []) == app.game.campaign.dialogue(38, 0), "original rescue briefing is displayed through native Next")
		check(continuation_lines.get("39", []) == app.game.campaign.dialogue(38, 1), "both original rescue result lines are displayed through native Next")
		check(rescue_radio.size() == 1 and rescue_radio[0].text == app.library.text(1146), "actual supplied captor radio is displayed before acknowledgement")
		check_continuation_resources()
		if failures == 0: await retain_continuation("earned-dekato39.json")
	if failures == 0: await route_to(30)
	if failures == 0:
		var s = app.game.session
		check(s.story_step == 40 and s.station_id == 30 and s.system_index == 2 and not s.in_void,
			"physical Nehma return earns the supplied escort40 continuation")
		check(int(s.story_mission.kind) == 25 and int(s.story_mission.station) == -1
			and not bool(s.story_mission.get("done", false)), "the supplied portal escort remains uncompleted")
		check(continuation_lines.get("40", []) == app.game.campaign.dialogue(39, 1), "all nine original Nehma planning lines are displayed through native Next")
		check_continuation_resources()
		if failures == 0:
			await retain_continuation("earned-dekato-return40.json")
			await shot("earned_nehma40")
			await save_checkpoint()
	check(FileAccess.get_file_as_bytes(source) == source_bytes, "original accepted step38 bytes are unchanged")
	await finish()

func check_flight_entry(reference: WeakRef) -> void:
	super.check_flight_entry(reference)
	var flight = reference.get_ref()
	if flight == null or flight.space.story == null: return
	var story = flight.space.story
	if story.step != 38 or not story.active(): return
	rescue_seen = true
	combat_pilot = CombatPilot.new()
	check(story.cast.size() == 7 and flight.space.station.station_id == 22, "real Dekato arrival builds exactly two captives and five captors")
	if story.cast.size() != 7: return
	combat_pilot.protected_allies = story.cast.slice(0, 2)
	check(story.cast.slice(0, 2).all(func(b): return b.alive and b.friendly and not b.hostile and b.ai.mode == "hold"),
		"actual stationary captives have the source fixed-friendly allegiance")
	check(story.cast.slice(2).all(func(b): return b.alive and b.hostile and not b.combat_active), "actual captors start in the source dormant encounter state")
	for b in story.cast:
		rescue_initial.append({"faction": b.faction, "hull": b.hull, "position": str(b.pos),
			"friendly": b.friendly, "hostile": b.hostile, "mode": b.ai.mode, "active": b.combat_active})
	flight.space.event.connect(rescue_event.bind(reference))

func rescue_event(kind: String, data: Dictionary, reference: WeakRef) -> void:
	var flight = reference.get_ref()
	if flight == null or flight.space.story == null: return
	var space = flight.space
	missile_observer.observe_event(kind, data, space, space.story.cast)
	if kind != "killed": return
	var body: Body = data.body
	var row := {"clock": space.clock, "frame": frame, "index": space.story.cast.find(body),
		"faction": body.faction, "hull": body.hull, "alive": body.alive, "dead_timer": body.dead_timer,
		"player_kills": app.game.session.stat("kills"), "shots": space.shots_fired}
	rescue_events.append(row)
	print("RESCUE DEATH ", JSON.stringify(row))

func pilot(reference: WeakRef) -> Dictionary:
	if not is_instance_valid(app) or app.is_queued_for_deletion(): return {}
	var flight = reference.get_ref()
	if flight == null: return {}
	var space = flight.space
	var story = space.story
	if story == null or story.step != 38 or story.cast.size() != 7 or story.complete or story.failed:
		return super.pilot(reference)
	var controls: Dictionary = combat_pilot.input(space, story.cast.slice(2))
	missile_observer.sample(space, story.cast)
	if space.clock - rescue_sample_clock >= 1000:
		rescue_sample_clock = space.clock
		var row := {"clock": space.clock, "mode": combat_pilot.mode, "hull": space.player.hull,
			"recovery_started": combat_pilot.recovery_started, "boosting": space.player.boosting,
			"priority": story.cast.find(combat_pilot.protection_priority(space, story.cast.slice(2))),
			"armor": space.player.armor, "shield": space.player.shield, "shots": space.shots_fired,
			"position": str(space.player.pos), "gap": combat_pilot.gap, "controls": controls.duplicate(),
			"target": story.cast.find(space.target), "opponent": story.cast.find(combat_pilot.opponent.get_ref()) if combat_pilot.opponent != null else -1,
			"forward": str(space.player.forward()), "steering_point": str(combat_pilot.navigation.steering_point),
			"avoided": combat_pilot.navigation.avoided, "friendly_lane_clear": combat_pilot.friendly_corridor_clear(space),
			"ammunition": space.player.weapons.filter(func(w): return w.kind == "missile").map(func(w): return {"id": w.id, "count": w.count, "cooldown": w.cooldown}),
			"cast": story.cast.map(func(b): return {"alive": b.alive, "hull": b.hull, "timer": b.dead_timer,
				"position": str(b.pos), "active": b.combat_active, "friendly": b.friendly, "hostile": b.hostile,
				"ai_target": story.cast.find(b.ai.get("target")), "targets_player": b.ai.get("target") == space.player,
				"forward": str(b.forward()), "speed": b.speed, "emp": b.emp, "disabled": b.disabled, "mode": b.ai.mode})}
		rescue_samples.append(row)
		if space.clock % 10000 < 1000: print("RESCUE PILOT ", JSON.stringify(row))
	return controls

func observe() -> void:
	if app.screen is Flight and app.screen.space.story != null and rescue_seen:
		var space = app.screen.space
		var story = space.story
		if story.cast.size() == 7 and space.station.station_id == 22:
			if not story.message().is_empty() and rescue_radio.is_empty(): rescue_radio.append(story.message().duplicate(true))
			if space.shots_fired > 0: await shot("actual_dekato_combat")
			if (story.failed or not space.player.alive) and rescue_failure.is_empty():
				rescue_failure = {"clock": space.clock, "player_alive": space.player.alive,
					"cast": story.cast.map(func(b): return {"alive": b.alive, "hull": b.hull, "timer": b.dead_timer})}
			if story.complete and not story.failed and rescue_result.is_empty():
				var settled: bool = story.cast.slice(2).all(func(b): return not b.alive and b.dead_timer <= 0.0)
				var survivors: int = story.cast.slice(0, 2).filter(func(b): return b.alive).size()
				rescue_result = {"clock": space.clock, "frame": frame, "settled": settled, "survivors": survivors,
					"won": settled and survivors > 0 and space.player.alive, "hull": space.player.hull,
					"armor": space.player.armor, "shield": space.player.shield, "shots": space.shots_fired}
				check(bool(rescue_result.won), "five settled deaths and surviving captives earn the real rescue")
				await shot("actual_dekato_victory")
	await super.observe()

func fly_to_dock() -> bool:
	for tick in 40000:
		frame += 1
		await observe()
		await clear_dialogue()
		if failures > 0: return false
		if app.screen is Station:
			await observe()
			return true
		if app.screen is Flight and (app.screen.defeated or (app.screen.space.story != null and app.screen.space.story.failed)):
			await shot("actual_dekato_defeat")
			check(false, "actual earned player and required rescue targets survive")
			return false
		await frames(1)
	check(false, "rescue flight and physical docking finish within the bounded window")
	return false

func check_continuation_equipment() -> void:
	var spent: int = missile_observer.launches.size()
	var expected := EquipmentOracle.expected_continuation_equipment(input_header.equipment, spent)
	check(spent <= 4 and app.game.session.credits == int(input_header.credits) and snapshot().equipment == expected,
		"real credits and equipment remain unchanged except the observed finite EMP launches")
	var valid := missile_observer.active.is_empty() and missile_observer.outcomes.size() == spent
	for i in spent:
		var launch: Dictionary = missile_observer.launches[i]
		valid = valid and int(launch.weapon) == 35 and int(launch.count_before) == 4 - i and int(launch.target) in range(2, 7)
	check(valid, "every finite EMP launch has one native terminal observation at a designated captor")

func finish() -> void:
	check(source_hashes() == run_sources, "all native source and test scripts stayed frozen during this run")
	var file := FileAccess.open(out.path_join("rescue-ledger.json"), FileAccess.WRITE)
	if file != null:
		file.store_string(JSON.stringify({"initial": rescue_initial, "events": rescue_events, "result": rescue_result,
			"failure": rescue_failure, "radio": rescue_radio, "samples": rescue_samples, "missiles": missile_observer.report(),
			"input_sha256": FileAccess.get_sha256(source), "source_hashes_before": run_sources, "source_hashes_after": source_hashes()}, "\t"))
	await super.finish()
