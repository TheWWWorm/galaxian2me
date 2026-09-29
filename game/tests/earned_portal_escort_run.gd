extends "res://tests/earned_travel_run.gd"
## H40 COPY -> real Map/gates -> original portal escort -> actual Void entry.
## Only UI and ordinary controls; never assigns campaign, positions or damage.
const H40_SHA := "285f67c8e047cf9bcf014e748c721dcee8a34d5171fd706942fd40bac754c776"
const Transit := preload("res://tests/support/transit_pilot.gd")
const Combat := preload("res://tests/support/combat_pilot.gd")
const EscortPilot := preload("res://tests/support/portal_escort_pilot.gd")
const Observation := preload("res://tests/support/simulation_snapshot.gd")
var transit := Transit.new()
var defender := Combat.new()
var escort_pilot := EscortPilot.new()
var header := {}
var frozen_sources := {}
var escort_events: Array = []
var escort_entries: Array = []
var samples: Array = []
var sample_clock := -1000
var native_checkpoint := {}
var radios: Array = []
var last_kills := 0
var decisions_readonly := true
var decisions_observed := 0

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 2:
		source = args[0]
		out = args[1]
	_run.call_deferred()

func source_hashes() -> Dictionary:
	var result := {}
	collect_hashes("res://", result)
	return result

func collect_hashes(path: String, result: Dictionary) -> void:
	for dir in DirAccess.get_directories_at(path):
		if path == "res://" and dir not in ["src", "tests"]: continue
		collect_hashes(path.path_join(dir), result)
	for file in DirAccess.get_files_at(path):
		if file.ends_with(".gd"): result[path.path_join(file)] = FileAccess.get_sha256(path.path_join(file))

func _run() -> void:
	if started: return
	started = true
	if source.is_empty() or out.is_empty() or not FileAccess.file_exists(source) or DirAccess.dir_exists_absolute(out):
		push_error("Provide accepted H40 and a NEW isolated output directory.")
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
	node_added.connect(trace_flight_node)
	root.add_child(app)
	await frames(3)
	check(FileAccess.get_sha256(source) == H40_SHA, "input is the independently accepted immutable H40 native save")
	if failures > 0 or not app.activate(str(header.get("content", ""))):
		check(false, "accepted input and supplied content are available")
		await finish()
		return
	input_step = int(header.story_step)
	DirAccess.make_dir_recursive_absolute(app.save_path(0).get_base_dir())
	check(DirAccess.copy_absolute(source, app.save_path(0)) == OK, "COPY H40 into fresh isolated native storage")
	app.show_title()
	await frames(3)
	app.screen._load()
	await frames(2)
	press(app.screen.panel_holder.get_child(0).get_child(0).get_child(1), "title Load actual H40")
	await frames(3)
	var expected := header.duplicate(true)
	expected.erase("saved_at")
	check(app.screen is Station and snapshot() == expected and app.save_attempts.is_empty(),
		"native cold load changes no earned field and creates no reward or save")
	check(input_step == 40 and app.game.session.station_id == 30 and int(app.game.session.flags.wormhole_station) == 91,
		"actual Nehma40 points to retained portal91, not a fabricated Void checkpoint")
	last_kills = app.game.session.stat("kills")
	seen_screen = app.screen.get_instance_id()
	await shot("accepted_nehma40")
	for trip in 16:
		if failures > 0 or app.game.session.story_step >= 41: break
		if app.screen is Station:
			var next := next_route_station(91)
			if next < 0 or not await choose_destination(next): break
		if not await fly_to_boundary(): break
	if failures == 0:
		var s = app.game.session
		check(s.story_step == 41 and s.in_void and app.screen is Flight,
			"real escort survival and physical player crossing earn the uncompleted Void finale")
		check(int(s.story_mission.kind) == 4 and int(s.story_mission.station) == -1
			and not bool(s.story_mission.get("done", false)), "arrival does not pre-win the mothership mission")
		check(s.credits == int(header.credits) and snapshot().equipment == header.equipment
			and s.blueprints == header.blueprints and s.cargo_count(164) == 4 and s.cargo_count(85) == 0,
			"escort invents no money, ammunition, completed drive or crystals")
		check(s.stat("jobs") == 2 and s.stat("kills") == last_kills
			and s.stat("jumpgates") == int(header.stats.jumpgates) + gate_events.size(),
			"statistics reflect only observed physical gates and native kills")
		var saved := saved_state(app.AUTOSAVE_SLOT)
		check(saved == snapshot(), "actual physical crossing creates an exact native flight autosave")
		if failures == 0:
			var path := out.path_join("earned-portal-entry.json")
			check(DirAccess.copy_absolute(app.save_path(app.AUTOSAVE_SLOT), path) == OK, "retain the actual native Void-entry autosave")
			native_checkpoint = {"path": path, "sha256": FileAccess.get_sha256(path), "state": saved}
		await shot("earned_void_escort41")
	check(FileAccess.get_file_as_bytes(source) == source_bytes, "original H40 remains byte-identical")
	await finish()

func check_flight_entry(reference: WeakRef) -> void:
	super.check_flight_entry(reference)
	var flight = reference.get_ref()
	if flight == null: return
	transit = Transit.new()
	defender = Combat.new()
	escort_pilot = EscortPilot.new()
	escort_pilot.combat = defender
	sample_clock = -1000
	flight.controls.scripted = pilot.bind(reference)
	flight.space.event.connect(escort_event.bind(reference))
	var story = flight.space.story
	if story != null and story.step in [40, 41]:
		escort_entries.append({"step": story.step, "station": flight.game.session.station_id,
			"in_void": flight.space.in_void, "position": str(flight.space.player.pos), "cast": cast_state(story),
			"portal": str(flight.space.wormhole.pos), "records": story.records.duplicate(true),
			"native_observation": Observation.capture(flight.space)})
		check(story.cast.size() == (9 if story.step == 40 else 5), "native arrival creates the source escort actor count")
		if story.step == 41:
			# Ordinary Pause freezes the newly earned boundary before a tick;
			# its native crossing callback still performs the actual autosave.
			flight.set_paused(true)

func cast_state(story) -> Array:
	return story.cast.map(func(b): return {"hull": b.hull, "maximum": b.hull_max, "alive": b.alive,
		"visible": b.visible, "position": str(b.pos), "faction": b.faction, "ship": b.ship_index,
		"friendly": b.friendly, "hostile": b.hostile, "speed": b.speed, "mode": b.ai.get("mode", ""),
		"basis": var_to_str(b.basis), "forward": str(b.forward()), "ai": Observation.value(b.ai),
		"disabled": b.disabled, "emp": b.emp, "emp_timer": b.emp_timer,
		"weapons": Observation.value(b.weapons)})

func escort_event(kind: String, data: Dictionary, reference: WeakRef) -> void:
	var flight = reference.get_ref()
	if flight == null: return
	if kind == "killed":
		var now: int = app.game.session.stat("kills")
		if now > last_kills:
			check(now == last_kills + 1 and not data.body.alive and data.body.hostile and not data.body.friendly,
				"one observed native hostile death earns exactly one player kill")
		last_kills = now
	if kind not in ["escort_entered_portal", "escort_delivered", "escort_escape_failed", "wormhole_crossed", "killed", "destroyed"]: return
	var record := {"event": kind, "clock": flight.space.clock, "frame": frame,
		"story": flight.space.story.step if flight.space.story != null else -1,
		"data": data.duplicate(true), "player_hull": flight.space.player.hull,
		"cast": cast_state(flight.space.story) if flight.space.story != null else []}
	if kind == "killed": record.data = {"faction": data.body.faction, "hull": data.body.hull}
	escort_events.append(record)
	print("ESCORT EVENT ", JSON.stringify(record))

func pilot(reference: WeakRef) -> Dictionary:
	var flight = reference.get_ref()
	if flight == null: return {}
	var space = flight.space
	var story = space.story
	if space.portal_arriving() or (story != null and story.controls_locked): return {}
	var before := Observation.capture(space)
	var controls := {}
	if story != null and story.step == 40 and story.active() and not story.cast.is_empty():
		controls = escort_pilot.input(space)
	else:
		var goal: Body = space.station
		var sid := int(app.game.destination.get("station", -1))
		if sid >= 0 and sid != space.station.station_id:
			if app.catalogue.system_of_station(sid) != app.game.session.system_index:
				goal = space.gate
			else:
				for b in space.bodies:
					if b.kind == Body.Kind.STAR and b.station_id == sid: goal = b; break
		controls = transit.input(space, goal)
	decisions_readonly = decisions_readonly and before == Observation.capture(space)
	decisions_observed += 1
	if space.clock - sample_clock >= 1000:
		sample_clock = space.clock
		var sample := {"clock": space.clock, "station": app.game.session.station_id, "step": app.game.session.story_step,
			"position": str(space.player.pos), "hull": space.player.hull, "armor": space.player.armor,
			"shield": space.player.shield, "controls": controls.duplicate(), "mode": defender.mode,
			"shots": space.shots_fired, "cast": cast_state(story) if story != null else [],
			"basis": var_to_str(space.player.basis), "forward": str(space.player.forward()),
			"boosting": space.player.boosting, "boost_ready": space.boost_ready, "boost_time": space.boost_time,
			"desired": str(defender.desired), "escape_direction": str(defender.escape_direction),
			"rng_state": str(space.rng.state), "native_observation": before,
			"policy_observation": var_to_str([Observation.fields(defender), Observation.fields(defender.navigation),
				Observation.fields(escort_pilot), Observation.fields(escort_pilot.navigation)])}
		samples.append(sample)
		if story != null and space.clock % 10000 < 1000:
			print("ESCORT PILOT ", JSON.stringify({"clock": space.clock, "mode": defender.mode,
				"hull": space.player.hull, "shield": space.player.shield, "shots": space.shots_fired,
				"boost_ready": space.boost_ready, "boost_time": space.boost_time,
				"cast": cast_state(story)}))
	return controls

func fly_to_boundary() -> bool:
	for tick in 40000:
		frame += 1
		if app.game.session.story_step == 41 and app.game.session.in_void: return true
		await observe()
		await clear_dialogue()
		if failures > 0: return false
		if app.screen is Station: return true
		if app.screen is Flight:
			var story = app.screen.space.story
			if app.screen.defeated or (story != null and story.failed):
				await shot("actual_escort_failure")
				check(false, "real player and required freighter survive the native escort")
				return false
			if story != null and story.step == 40:
				if not story.message().is_empty(): radios.append(story.message().duplicate(true))
				if app.screen.space.clock > 5000: await shot("actual_portal_escort40")
				if app.screen.space.shots_fired > 0: await shot("actual_escort_defense")
		await frames(1)
	check(false, "actual flight reaches a native boundary within its bounded window")
	return false

func finish() -> void:
	check(source_hashes() == frozen_sources, "all native scripts and test controls remained frozen throughout the run")
	check(decisions_observed > 0 and decisions_readonly, "every observed pilot decision left native world, session and RNG untouched")
	var file := FileAccess.open(out.path_join("escort-ledger.json"), FileAccess.WRITE)
	if file != null:
		file.store_string(JSON.stringify({"source_sha256": FileAccess.get_sha256(source), "source_hashes_before": frozen_sources,
			"source_hashes_after": source_hashes(), "entries": escort_entries, "events": escort_events,
			"samples": samples, "checkpoint": native_checkpoint, "radio": radios,
			"decisions_readonly": decisions_readonly, "decisions_observed": decisions_observed}, "\t"))
	await super.finish()
