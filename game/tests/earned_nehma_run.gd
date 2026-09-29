extends "res://tests/earned_crystal_delivery.gd"
## Real B34 COPY -> known gates -> Nehma35 -> Ga'kkrr36. No fixture saves,
## position/cursor assignments, market resets or generated resources.
const CRYSTAL_HANDOVER_SHA := "48b0e0eaf86b3d2b20e804284f8fd7823065f9c7c01f08f32467a9fc22a71d51"
const NEHMA_RESULT_SHA := "ab7d5a5bf54e1291a981e9c34b1246b39b6832d8ef3a364301f9b622394a54e9"
var continuation_lines := {}
var continuation_saves: Array = []
const TransitPilot := preload("res://tests/support/transit_pilot.gd")
var transit_pilot := TransitPilot.new()
var pilot_samples: Array = []
var sampled_clock := -1000
func check_flight_entry(reference: WeakRef) -> void:
	super.check_flight_entry(reference)
	transit_pilot = TransitPilot.new()
	sampled_clock = -1000
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
		push_error("Provide actual B34 docking input and a NEW isolated output directory.")
		quit(2)
		return
	root.size = Vector2i(1280, 800)
	DirAccess.make_dir_recursive_absolute(out)
	source_bytes = FileAccess.get_file_as_bytes(source)
	input_header = JSON.parse_string(source_bytes.get_string_from_utf8())
	app = TestApp.new()
	save_root = out.path_join("test-saves-%d" % Time.get_ticks_usec())
	app.disk_saves = save_root
	node_added.connect(watch_flight_entry)
	node_added.connect(trace_flight_node)
	root.add_child(app)
	await frames(3)
	check(FileAccess.get_sha256(source) in [CRYSTAL_HANDOVER_SHA, NEHMA_RESULT_SHA], "exact immutable earned handover or Nehma input")
	if failures > 0 or not input_header is Dictionary or not app.activate(str(input_header.get("content", ""))):
		check(false, "earned input and supplied content are valid")
		await finish()
		return
	input_step = int(input_header.story_step)
	DirAccess.make_dir_recursive_absolute(app.save_path(0).get_base_dir())
	check(DirAccess.copy_absolute(source, app.save_path(0)) == OK, "COPY actual crystal handover into fresh native storage")
	app.show_title()
	await frames(3)
	app.screen._load()
	await frames(2)
	press(app.screen.panel_holder.get_child(0).get_child(0).get_child(1), "native title Load B34")
	await frames(3)
	var expected := input_header.duplicate(true)
	expected.erase("saved_at")
	check(app.screen is Station and snapshot() == expected and app.save_attempts.is_empty(),
		"native cold load preserves every earned field without settlement or repair")
	check((input_step == 34 and app.game.session.station_id == 10 and int(app.game.session.story_mission.station) == 30)
		or (input_step == 35 and app.game.session.station_id == 30 and int(app.game.session.story_mission.station) == 29),
		"earned input has its actual supplied docking continuation")
	seen_screen = app.screen.get_instance_id()
	last_earned_kills = app.game.session.stat("kills")
	await shot("earned_b34_input")
	if failures == 0 and input_step == 34: await route_to(30)
	if failures == 0 and input_step == 34:
		check(app.game.session.story_step == 35 and int(app.game.session.story_mission.kind) == 11
			and int(app.game.session.story_mission.station) == 29, "real Nehma docking opens supplied Ga'kkrr visit35")
		check(continuation_lines.get("35", []) == app.game.campaign.dialogue(34, 1),
			"all nine original Nehma result lines are shown through native Next")
		await retain_continuation("earned-nehma-result.json")
		await shot("earned_nehma35")
	if failures == 0: await route_to(29)
	if failures == 0:
		check(app.game.session.story_step == 36 and app.game.session.station_id == 29
			and int(app.game.session.story_mission.kind) == 12 and int(app.game.session.story_mission.station) == 27,
			"real Ga'kkrr docking earns the uncompleted B'akka contest36")
		check(continuation_lines.get("36", []) == app.game.campaign.dialogue(35, 1),
			"all twelve original Errkt result lines are shown through native Next")
		check(not bool(app.game.session.story_mission.get("done", false)), "visiting Errkt does not pre-win his contest")
		check_continuation_resources()
		await retain_continuation("earned-errkt-request.json")
		await shot("earned_errkt36")
		await save_checkpoint()
	check(FileAccess.get_file_as_bytes(source) == source_bytes, "original earned B34 remains byte-identical")
	await finish()
func pilot(reference: WeakRef) -> Dictionary:
	if not is_instance_valid(app) or app.is_queued_for_deletion(): return {}
	var flight = reference.get_ref()
	if flight == null: return {}
	var space = flight.space
	if space.docking >= 0 or space.jumping >= 0 or space.travelling >= 0: return {}
	var goal: Body = space.station
	var sid := int(app.game.destination.get("station", -1))
	if sid >= 0 and sid != space.station.station_id:
		if app.catalogue.system_of_station(sid) != app.game.session.system_index:
			goal = space.gate
		else:
			for b in space.bodies:
				if b.kind == Body.Kind.STAR and b.station_id == sid: goal = b; break
	var controls: Dictionary = transit_pilot.input(space, goal)
	if space.clock - sampled_clock >= 1000:
		sampled_clock = space.clock
		var row := {"station": space.station.station_id, "clock": space.clock,
			"mode": transit_pilot.mode, "avoided": transit_pilot.avoided, "position": str(space.player.pos),
			"goal": goal.kind if goal != null else -1, "hull": space.player.hull,
			"armor": space.player.armor, "shield": space.player.shield, "shots": space.shots_fired,
			"controls": controls.duplicate(), "hostiles": space.hostiles().size(),
			"forward": str(space.player.forward()), "steering_point": str(transit_pilot.steering_point),
			"boost_time": space.boost_time, "boost_ready": space.boost_ready,
			"opponents": space.hostiles().map(func(b): return {"position": str(b.pos), "basis": var_to_str(b.basis),
				"speed": b.speed, "hull": b.hull, "faction": b.faction, "disabled": b.disabled,
				"visible": b.visible, "mode": b.ai.get("mode", ""), "weapons": var_to_str(b.weapons)})}
		pilot_samples.append(row)
		if space.clock % 10000 < 1000: print("TRANSIT PILOT ", JSON.stringify(row))
	return controls
func retain_continuation(name: String) -> void:
	check(saved_state(app.AUTOSAVE_SLOT) == snapshot(), "continuation uses the actual settled docking transaction")
	var path := out.path_join(name)
	check(DirAccess.copy_absolute(app.save_path(app.AUTOSAVE_SLOT), path) == OK, "retain earned continuation " + name)
	continuation_saves.append({"path": path, "sha256": FileAccess.get_sha256(path), "state": snapshot()})
func clear_dialogue() -> void:
	for i in 100:
		var talk := dialogue(app.screen)
		if talk == null: return
		var key := str(app.game.session.story_step)
		if not continuation_lines.has(key): continuation_lines[key] = []
		var rows: Array = continuation_lines[key]
		if rows.size() <= talk.index: rows.append(talk.lines[talk.index].duplicate(true))
		await shot("continuation_%s_line_%d" % [key, talk.index])
		press(talk.next_button, "original continuation Next")
		await frames(1)
	check(false, "original continuation dialogue terminates")
func check_continuation_resources() -> void:
	var s = app.game.session
	var after := snapshot()
	check_continuation_equipment()
	check(after.blueprints == input_header.blueprints and s.cargo_count(164) == 4
		and s.cargo_count(85) == 0 and not bool(s.ship_stats().jump_drive),
		"Nehma and Errkt neither consume spare crystals nor finish the partial drive")
	var added := 0
	var original := 0
	var preserved := true
	for key in input_header.cargo:
		original += int(input_header.cargo[key])
		preserved = preserved and int(after.cargo.get(key, 0)) >= int(input_header.cargo[key])
	for key in after.cargo: added += int(after.cargo[key]) - int(input_header.cargo.get(key, 0))
	var salvage: int = s.stat("cargo_salvaged") - int(input_header.stats.get("cargo_salvaged", 0))
	check(preserved and added == salvage and s.cargo_used() == original + salvage and s.cargo_free() >= 0,
		"cargo changes are exactly real flight salvage within the purchased60t hold")
	check(s.stat("jumpgates") == int(input_header.stats.get("jumpgates", 0)) + gate_events.size()
		and s.stat("kills") == last_earned_kills and s.stat("jobs") == 2,
		"only recorded gate crossings and native kills change progression statistics")
func check_continuation_equipment() -> void:
	check(app.game.session.credits == int(input_header.credits) and snapshot().equipment == input_header.equipment,
		"zero-reward visits preserve real credits, equipment and all seven finite rockets")
func finish() -> void:
	var pilot_file := FileAccess.open(out.path_join("pilot-samples.json"), FileAccess.WRITE)
	if pilot_file != null: pilot_file.store_string(JSON.stringify(pilot_samples, "\t"))
	var file := FileAccess.open(out.path_join("continuation-ledger.json"), FileAccess.WRITE)
	if file != null: file.store_string(JSON.stringify({"lines": continuation_lines, "saves": continuation_saves}, "\t"))
	await super.finish()
