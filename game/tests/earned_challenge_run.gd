extends "res://tests/earned_nehma_run.gd"
## Actual earned story36 COPY -> native B'akka arrival -> seven-pirate contest -> dock.
## All targeting is ordinary stick/trigger input. Neither rival nor pirates
## are changed, and no source cursor, score, inventory or RNG is assigned.
const ERRKT_REQUEST_SHA := "02568ed3e6000b9bfd0c92e1d10789a9cbc2d5deffae9b2139d18fed2912bb69"
## Six paid native station transactions, then independent native cold Load.
## This accepts that exact preparation, not arbitrary modified story36 saves.
const COMBAT_REFIT_SHA := "022f7a10e3fc906555476b6bdfdd7948e827d09f4ffe32135f6f0e7619d5e544"
var run_sources := {}

func source_hashes() -> Dictionary:
	var hashes := {}
	for path in ["tests/earned_challenge_run.gd", "tests/support/combat_pilot.gd",
		"tests/support/transit_pilot.gd", "tests/support/missile_observer.gd",
		"tests/earned_nehma_run.gd", "tests/earned_travel_run.gd",
		"src/flight/space.gd", "src/flight/body.gd", "src/flight/ai.gd", "src/flight/story.gd"]:
		hashes[path] = FileAccess.get_sha256("res://" + path)
	return hashes

var contest_events: Array = []
var contest_cast: Array = []
var contest_result := {}
var contest_failure := {}
var contest_seen := false
var scored_mine := 0
var scored_rival := 0
const CombatPilot := preload("res://tests/support/combat_pilot.gd")
var combat_pilot := CombatPilot.new()
var combat_samples: Array = []
var combat_sample_clock := -1000
var previous_combat_mode := ""
var ammunition_events: Array = []
var rival_observations: Array = []
var last_rival_hull := 9999999
const MissileObserver := preload("res://tests/support/missile_observer.gd")
var missile_observer := MissileObserver.new()
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
		push_error("Provide an accepted earned story36 input and a NEW isolated output directory.")
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
	check(FileAccess.get_sha256(source) in [ERRKT_REQUEST_SHA, COMBAT_REFIT_SHA],
		"exact independently earned and cold-verified story36 input")
	if failures > 0 or not input_header is Dictionary or not app.activate(str(input_header.get("content", ""))):
		check(false, "earned input and supplied content are valid")
		await finish()
		return
	input_step = int(input_header.story_step)
	DirAccess.make_dir_recursive_absolute(app.save_path(0).get_base_dir())
	check(DirAccess.copy_absolute(source, app.save_path(0)) == OK, "COPY earned Errkt36 into fresh native storage")
	app.show_title()
	await frames(3)
	app.screen._load()
	await frames(2)
	press(app.screen.panel_holder.get_child(0).get_child(0).get_child(1), "native title Load accepted story36")
	await frames(3)
	var expected := input_header.duplicate(true)
	expected.erase("saved_at")
	check(app.screen is Station and snapshot() == expected and app.save_attempts.is_empty(),
		"native cold Load preserves every earned field without settlement or repair")
	check(input_step == 36 and app.game.session.station_id == 29 and int(app.game.session.story_mission.station) == 27,
		"actual Ga'kkrr checkpoint retains the uncompleted B'akka contest")
	seen_screen = app.screen.get_instance_id()
	last_earned_kills = app.game.session.stat("kills")
	await shot("earned_errkt_input")
	if failures == 0 and await choose_destination(27): await fly_to_dock()
	if failures == 0:
		var s = app.game.session
		check(contest_seen and not contest_result.is_empty() and bool(contest_result.won),
			"actual native contest wins with more player kills than the untouched rival")
		check(s.story_step == 38 and s.station_id == 27 and s.system_index == 5,
			"physical B'akka docking earns the supplied post-contest continuation38")
		check(continuation_lines.get("36", []) == app.game.campaign.dialogue(36, 0),
			"both original contest briefing lines are displayed through native Next")
		check(continuation_lines.get("37", []) == app.game.campaign.dialogue(36, 1),
			"both original victory result lines are displayed through native Next")
		check(continuation_lines.get("38", []) == app.game.campaign.dialogue(37, 1),
			"all eight original post-contest docking lines are displayed through native Next")
		check(int(s.story_mission.kind) == 4 and int(s.story_mission.station) == 22
			and not bool(s.story_mission.get("done", false)), "Dekato rescue remains uncompleted")
		check_continuation_resources()
		if failures == 0:
			await retain_continuation("earned-challenge-result.json")
			await shot("earned_challenge38")
			await save_checkpoint()
	check(FileAccess.get_file_as_bytes(source) == source_bytes, "original accepted cold-verified input remains byte-identical")
	await finish()

func check_flight_entry(reference: WeakRef) -> void:
	super.check_flight_entry(reference)
	var flight = reference.get_ref()
	if flight == null or flight.space.story == null or flight.space.story.step != 36: return
	var space = flight.space
	var encounter = space.story
	contest_seen = true
	combat_pilot = CombatPilot.new()
	combat_sample_clock = -1000
	check(encounter.cast.size() == 8 and encounter.objective == {"kind": "challenge", "from": 1, "to": 8},
		"native B'akka scene builds the supplied rival and exactly seven designated pirates")
	if encounter.cast.size() != 8: return
	var rival: Body = encounter.cast[0]
	check(rival.alive and rival.friendly and not rival.hostile and rival.faction == 1
		and rival.hull == 9999999 and rival.ai.route == encounter.CHALLENGE_ROUTE,
		"original rival starts friendly with unchanged source durability and patrol route")
	check(encounter.cast.slice(1).all(func(b): return b.alive and b.hostile and b.faction == 8 and encounter.CHALLENGE_ROUTE.has(b.pos)),
		"all seven original pirates begin live at source route points")
	for b in encounter.cast:
		contest_cast.append({"name": b.name, "faction": b.faction, "position": str(b.pos),
			"hull": b.hull, "friendly": b.friendly, "hostile": b.hostile,
			"speed": b.speed, "weapons": b.weapons.duplicate(true)})
	print("CONTEST PLAYER ", JSON.stringify({"stats": app.game.session.ship_stats(), "weapons": space.player.weapons}))
	space.event.connect(contest_event.bind(reference))
	space.event.connect(ammunition_event.bind(reference))
	space.event.connect(missile_event.bind(reference))

func missile_event(kind: String, data: Dictionary, reference: WeakRef) -> void:
	var flight = reference.get_ref()
	if flight == null or flight.space.story == null: return
	missile_observer.observe_event(kind, data, flight.space, flight.space.story.cast)

func ammunition_event(kind: String, data: Dictionary, reference: WeakRef) -> void:
	if kind != "sound" or data.get("name", "") != "wpn_rocket_02": return
	var flight = reference.get_ref()
	if flight == null: return
	var space = flight.space
	var launcher: Dictionary = space.player.weapons.filter(func(w): return w.kind == "missile")[0]
	var index: int = space.story.cast.find(space.target)
	var row := {"clock": space.clock, "frame": frame, "before": int(launcher.count),
		"id": int(launcher.id), "target": index, "shots": space.shots_fired,
		"gap": space.player.pos.distance_to(space.target.pos) if space.target != null else -1.0}
	check(index >= 1 and launcher.id == 35 and int(launcher.count) == 7 - ammunition_events.size(),
		"one actual native EMP launch spends the next finite rocket at a designated pirate")
	ammunition_events.append(row)
	print("NATIVE EMP ", JSON.stringify(row))

static func expected_continuation_equipment(equipment: Array, spent: int) -> Array:
	var expected_equipment: Array = equipment.duplicate(true)
	var remaining := int(equipment[1][0].count) - spent
	if remaining == 0: expected_equipment[1][0] = null
	# snapshot() JSON-round-trips numbers to floats. Nested Array/Dictionary
	# equality distinguishes integer 4 from floating 4 even though 4 == 4.0.
	# Match that representation, not a different ammunition quantity.
	else: expected_equipment[1][0].count = float(remaining)
	return expected_equipment

func check_continuation_equipment() -> void:
	var expected_equipment := expected_continuation_equipment(input_header.equipment, ammunition_events.size())
	check(ammunition_events.size() <= 7 and app.game.session.credits == int(input_header.credits)
		and snapshot().equipment == expected_equipment,
		"equipment is unchanged except exactly the finite rockets observed firing natively")

func contest_event(kind: String, data: Dictionary, reference: WeakRef) -> void:
	if kind != "killed": return
	var flight = reference.get_ref()
	if flight == null or flight.space.story == null: return
	var space = flight.space
	var body: Body = data.body
	var index: int = space.story.cast.find(body)
	var mine: int = space.kills
	var theirs := int(space.stats.get("rival_kills", 0))
	var row := {"frame": frame, "clock": space.clock, "index": index, "faction": body.faction,
		"mine_before": scored_mine, "mine_after": mine, "rival_before": scored_rival, "rival_after": theirs,
		"hull": body.hull, "alive": body.alive, "death_timer": body.dead_timer}
	contest_events.append(row)
	if index >= 1:
		check(not body.alive and body.faction == 8 and mine - scored_mine + theirs - scored_rival == 1,
			"one actual designated pirate death credits exactly one pilot")
	else:
		check(mine == scored_mine and theirs == scored_rival, "non-contest debris awards neither pilot a ship kill")
	scored_mine = mine
	scored_rival = theirs
	print("CONTEST DEATH ", JSON.stringify(row))

func pilot(reference: WeakRef) -> Dictionary:
	if not is_instance_valid(app) or app.is_queued_for_deletion(): return {}
	var flight = reference.get_ref()
	if flight == null: return {}
	var space = flight.space
	var encounter = space.story
	if encounter == null or encounter.complete or encounter.failed or encounter.objective.get("kind", "") != "challenge":
		return super.pilot(reference)
	if encounter.controls_locked or space.portal_arriving() or not space.player.alive: return {}
	var controls: Dictionary = combat_pilot.input(space, encounter.cast.slice(1))
	missile_observer.sample(space, encounter.cast)
	var rival: Body = encounter.cast[0]
	if rival.hull != last_rival_hull:
		var ally_row := {"clock": space.clock, "hull": rival.hull, "hostile": rival.hostile,
			"friendly": rival.friendly, "position": str(rival.pos), "targets_player": rival.ai.get("target") == space.player,
			"reputation": app.game.session.reputation.duplicate()}
		rival_observations.append(ally_row)
		print("RIVAL OBSERVED ", JSON.stringify(ally_row))
		last_rival_hull = rival.hull
	if space.clock - combat_sample_clock >= 1000 or combat_pilot.mode != previous_combat_mode:
		combat_sample_clock = space.clock
		var enemy: Body = combat_pilot.opponent.get_ref() if combat_pilot.opponent != null else null
		var row := {"clock": space.clock, "mode": combat_pilot.mode, "position": str(space.player.pos),
			"gap": combat_pilot.gap, "hull": space.player.hull, "armor": space.player.armor,
			"shield": space.player.shield, "mine": space.kills, "rival": int(space.stats.get("rival_kills", 0)),
			"enemy": encounter.cast.find(enemy), "enemy_hull": enemy.hull if enemy != null else -1,
			"desired": str(combat_pilot.desired), "controls": controls.duplicate(), "shots": space.shots_fired,
			"rival_hostile": rival.hostile, "rival_hull": rival.hull,
			"forward": str(space.player.forward()), "speed": space.player.speed,
			"friendly_lane_clear": combat_pilot.friendly_corridor_clear(space),
			"aim_lane_clear": combat_pilot.friendly_corridor_clear_at(space, space.player.pos,
				Body.facing(enemy.pos - space.player.pos)) if enemy != null and enemy.alive else true,
			"flank_offset": str(combat_pilot.flank_offset),
			"flank_feasible": combat_pilot.flank_feasible,
			"blocked_candidates": combat_pilot.blocked_candidates.map(func(b): return encounter.cast.find(b)),
			"navigation_avoided": combat_pilot.navigation.avoided,
			"steering_point": str(combat_pilot.navigation.steering_point),
			"boosting": space.player.boosting, "boost_ready": space.boost_ready, "boost_time": space.boost_time,
			"threats": space.hostiles().map(func(b): return {"cast": encounter.cast.find(b), "faction": b.faction,
				"friendly": b.friendly, "gap": b.pos.distance_to(space.player.pos), "position": str(b.pos),
				"forward": str(b.forward()), "speed": b.speed, "emp": b.emp, "disabled": b.disabled,
				"hull": b.hull, "targets_player": b.ai.get("target") == space.player,
				"aim": b.forward().dot(b.pos.direction_to(space.player.pos)),
				"transverse": space.player.forward().cross(b.pos.direction_to(space.player.pos)).length()})}
		combat_samples.append(row)
		if space.clock % 10000 < 1000 or combat_pilot.mode != previous_combat_mode: print("COMBAT PILOT ", JSON.stringify(row))
		previous_combat_mode = combat_pilot.mode
	return controls

func observe() -> void:
	if app.screen is Flight and app.screen.space.story != null and contest_seen:
		var space = app.screen.space
		var encounter = space.story
		if encounter.failed and contest_failure.is_empty():
			contest_failure = {"clock": space.clock, "mine": space.kills,
				"rival": int(space.stats.get("rival_kills", 0)), "player_alive": space.player.alive,
				"hull": space.player.hull, "armor": space.player.armor, "shield": space.player.shield,
				"settled": encounter.cast.slice(1).all(func(b): return not b.alive and b.dead_timer <= 0.0)}
		if space.shots_fired > 0: await shot("actual_contest_primaries")
		if encounter.complete and not encounter.failed and contest_result.is_empty():
			var settled: bool = encounter.cast.slice(1).all(func(b): return not b.alive and b.dead_timer <= 0.0 and b.faction == 8)
			contest_result = {"clock": space.clock, "frame": frame, "mine": space.kills,
				"rival": int(space.stats.get("rival_kills", 0)), "settled": settled,
				"won": settled and space.kills > int(space.stats.get("rival_kills", 0)),
				"rival_friendly": encounter.cast[0].friendly, "shots": space.shots_fired,
				"hull": space.player.hull, "armor": space.player.armor, "shield": space.player.shield}
			check(contest_result.won and contest_result.rival_friendly and scored_mine + scored_rival == 7,
				"settled seventh native death determines the victory without altering rival allegiance")
			await shot("actual_contest_victory")
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
			await shot("actual_contest_defeat")
			check(false, "actual earned player survives and wins the native contest")
			return false
		await frames(1)
	check(false, "native contest and docking finish within the bounded flight window")
	return false

func finish() -> void:
	check(source_hashes() == run_sources, "pilot, harness, observer and native combat sources remain unchanged throughout this run")
	var missile_file := FileAccess.open(out.path_join("missile-observations.json"), FileAccess.WRITE)
	if missile_file != null: missile_file.store_string(JSON.stringify(missile_observer.report(), "\t"))
	var samples_file := FileAccess.open(out.path_join("combat-pilot-samples.json"), FileAccess.WRITE)
	if samples_file != null: samples_file.store_string(JSON.stringify(combat_samples, "\t"))
	var file := FileAccess.open(out.path_join("contest-ledger.json"), FileAccess.WRITE)
	if file != null: file.store_string(JSON.stringify({"cast": contest_cast, "events": contest_events,
		"failure": contest_failure,
		"source_hashes_before": run_sources, "source_hashes_after": source_hashes(),
		"input_sha256": FileAccess.get_sha256(source),
		"ammunition": ammunition_events, "rival_observations": rival_observations,
		"result": contest_result, "pilot_sha256": FileAccess.get_sha256("res://tests/support/transit_pilot.gd"),
		"combat_pilot_sha256": FileAccess.get_sha256("res://tests/support/combat_pilot.gd"),
		"harness_sha256": FileAccess.get_sha256("res://tests/earned_challenge_run.gd")}, "\t"))
	await super.finish()
