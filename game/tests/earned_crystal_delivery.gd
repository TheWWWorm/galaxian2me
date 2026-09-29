extends "res://tests/earned_crystal_run.gd"
## Resume only the retained ACTUAL Ehna docking save before A's later death.
## Never load its defeated final state or edit resources to undo the defeat.
const MINED_ROUTE_SHA := "6247fbf493621328a7318df4c1a2715b85d34a6bce6922074183c83fa5be1a12"
var combat_events: Array = []
var last_earned_kills := 0
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
		push_error("Provide actual mined-route docking input and a NEW isolated output directory.")
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
	check(FileAccess.get_sha256(source) == MINED_ROUTE_SHA, "exact retained earned Ehna docking checkpoint, not defeated final state")
	if failures > 0 or not input_header is Dictionary or not app.activate(str(input_header.get("content", ""))):
		check(false, "earned input and supplied content are valid")
		await finish()
		return
	input_step = int(input_header.story_step)
	DirAccess.make_dir_recursive_absolute(app.save_path(0).get_base_dir())
	check(DirAccess.copy_absolute(source, app.save_path(0)) == OK, "COPY earned mined cargo into a fresh native host")
	app.show_title()
	await frames(3)
	app.screen._load()
	await frames(2)
	press(app.screen.panel_holder.get_child(0).get_child(0).get_child(1), "native title Load real mined cargo")
	await frames(3)
	var expected := input_header.duplicate(true)
	expected.erase("saved_at")
	check(app.screen is Station and snapshot() == expected and app.save_attempts.is_empty(), "cold load preserves every earned field and does not repair a defeated session")
	check(app.game.session.story_step == 33 and app.game.session.station_id == 45 and app.game.session.cargo_count(164) == 54
		and app.game.session.stat("ore_mined") == 101 and app.game.session.cargo_free() == 0,
		"actual54 mined crystals and full60t hold came from the verified A docking save")
	seen_screen = app.screen.get_instance_id()
	last_earned_kills = app.game.session.stat("kills")
	pre_delivery = snapshot()
	await shot("earned_mined_route_input")
	if failures == 0: await route_to(10)
	if failures == 0:
		var s = app.game.session
		check(s.story_step == 34 and s.station_id == 10 and not s.in_void, "physical Thynome delivery earns campaign34")
		check(s.cargo_count(164) == 4 and s.stat("ore_mined") == 101, "Khador consumes exactly50 already mined crystals and retains4 excess")
		var recipe: Dictionary = s.blueprints.get("85", {})
		check(recipe.get("progress", {}) == {"164": 50} and int(recipe.get("cost", -1)) == 0 and not recipe.has("station") and s.cargo_count(85) == 0,
			"source reward is only the partially contributed recipe, not a completed drive")
		check(s.credits == 530 and snapshot().equipment == input_header.equipment,
			"actual money, fitted equipment and seven finite rockets are preserved")
		check(s.stat("jobs") == 2 and s.stat("kills") == last_earned_kills,
			"only recorded native kills change statistics; delivery invents no freelance completions")
		check(int(s.story_mission.kind) == 11 and int(s.story_mission.station) == 30,
			"original Nehma continuation begins without being pre-completed")
		check(delivery_lines == app.game.campaign.dialogue(33, 1), "all original handover dialogue shown through native Next")
		check(DirAccess.copy_absolute(app.save_path(app.AUTOSAVE_SLOT), out.path_join("earned-crystal-handover.json")) == OK,
			"retain actual settled Thynome34 docking autosave")
		await shot("earned_crystal_handover")
		await save_checkpoint()
	check(FileAccess.get_file_as_bytes(source) == source_bytes, "original pre-defeat earned docking bytes remain unchanged")
	await finish()
func check_flight_entry(reference: WeakRef) -> void:
	super.check_flight_entry(reference)
	var flight = reference.get_ref()
	if flight != null: flight.space.event.connect(defense_event.bind(reference))
func defense_event(kind: String, data: Dictionary, reference: WeakRef) -> void:
	if kind != "killed": return
	var flight = reference.get_ref()
	if flight == null: return
	var body: Body = data.body
	var current: int = app.game.session.stat("kills")
	var entry := {"frame": frame, "clock": flight.space.clock, "faction": body.faction,
		"hostile": body.hostile, "friendly": body.friendly, "hull": body.hull,
		"player_kills_before": last_earned_kills, "player_kills_after": current}
	combat_events.append(entry)
	if current > last_earned_kills:
		check(current == last_earned_kills + 1 and body.hostile and not body.friendly and not body.alive,
			"actual player projectiles destroy one hostile without a synthetic kill credit")
		last_earned_kills = current
	print("DELIVERY COMBAT ", JSON.stringify(entry))
func pilot(reference: WeakRef) -> Dictionary:
	var flight = reference.get_ref()
	if flight == null: return {}
	var space = flight.space
	if space.docking >= 0 or space.jumping >= 0 or space.travelling >= 0: return {}
	if phase == "route" and not space.portal_arriving():
		var distance: float = space.player.pos.distance_to(space.station.pos)
		var docking_soon: bool = space.target == space.station and space.locked and distance < 12000.0
		if not docking_soon:
			for hostile in space.hostiles():
				if hostile.visible and not hostile.friendly and not hostile.disabled and hostile.pos.distance_to(space.player.pos) < 45000.0:
					return defend_primary(space)
	return super.pilot(reference)
func observe() -> void:
	await super.observe()
	if app.screen is Flight and app.screen.space.shots_fired > 0:
		await shot("actual_delivery_defense_%d" % app.game.session.station_id)
func finish() -> void:
	var file := FileAccess.open(out.path_join("delivery-combat.json"), FileAccess.WRITE)
	if file != null: file.store_string(JSON.stringify({"events": combat_events}, "\t"))
	await super.finish()
