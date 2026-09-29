extends "res://tests/earned_capacity_run.gd"
## COPY a genuine capacity checkpoint. Native map, flight sticks, scanner,
## drill steering and docking only. All resource changes are game transactions.
const CAPACITY_SHA := "5af8f3aeff1b370d9403a382d18c5b6546517a603c5b6346a88b31977f833d2c"
var phase := "route"
var crystal_events: Array = []
var delivery_lines: Array = []
var pre_delivery := {}
var crossing_count := 0
var rock_choice: WeakRef
var mined_total := 0
var core_total := 0
var ore_before_trip := 0
var cores_before_trip := 0
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
		push_error("Provide the exact earned capacity JSON and a NEW isolated output directory.")
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
	check(FileAccess.get_sha256(source) == CAPACITY_SHA, "exact earned E33 Inflict and drill input hash")
	if failures > 0 or not input_header is Dictionary or not app.activate(str(input_header.get("content", ""))):
		check(false, "earned input and supplied content are valid")
		await finish()
		return
	input_step = int(input_header.story_step)
	DirAccess.make_dir_recursive_absolute(app.save_path(0).get_base_dir())
	check(DirAccess.copy_absolute(source, app.save_path(0)) == OK, "COPY earned capacity input into fresh isolated host")
	app.show_title()
	await frames(3)
	app.screen._load()
	await frames(2)
	press(app.screen.panel_holder.get_child(0).get_child(0).get_child(1), "native title Load E33")
	await frames(3)
	var expected := input_header.duplicate(true)
	expected.erase("saved_at")
	check(app.screen is Station and snapshot() == expected and app.save_attempts.is_empty(), "cold native load preserves every earned field without settlement")
	check(app.game.session.cargo_free() == 54 and app.game.session.equipped_of_type(app.catalogue.Type.MINING_LASER).id == 87,
		"actual fitted drill87 and 54 free tonnes, not a fixture upgrade")
	seen_screen = app.screen.get_instance_id()
	ore_before_trip = app.game.session.stat("ore_mined")
	cores_before_trip = app.game.session.stat("cores_mined")
	await shot("earned_capacity_input")
	if failures == 0: await route_to(91)
	if failures == 0:
		check(app.game.session.station_id == 91 and app.game.session.system_index == 18 and app.game.session.story_step == 33,
			"real known-gate flight reaches Dima with crystal mission unchanged")
		check(DirAccess.copy_absolute(app.save_path(app.AUTOSAVE_SLOT), out.path_join("earned-dima-miner.json")) == OK,
			"retain actual Dima docking checkpoint before dangerous Void flight")
		phase = "enter"
		press(app.screen.launch_button, "Launch for the actual Dima portal")
		await frames(3)
		for tick in 90000:
			frame += 1
			await observe()
			await clear_dialogue()
			if failures > 0: break
			if app.screen is Station:
				await observe()
				check(crossing_count == 2 and app.game.session.cargo_count(164) >= 50 and not app.game.session.in_void,
					"two physical portal crossings return an actually mined crystal cargo to a real station")
				await retain_dock()
				check(DirAccess.copy_absolute(app.save_path(app.AUTOSAVE_SLOT), out.path_join("earned-crystals-returned.json")) == OK,
					"retain real post-mining docking autosave")
				break
			if app.screen is Flight and app.screen.defeated:
				await shot("crystal_flight_defeat")
				check(false, "survive actual portal and mining flight")
				break
			await frames(1)
		check(app.screen is Station and phase == "return", "bounded mining trip ends with earned normal-space docking")
	if failures == 0:
		check_mining_ledger()
		pre_delivery = snapshot()
		phase = "route"
		await route_to(10)
	if failures == 0:
		var s = app.game.session
		check(s.story_step == 34 and s.station_id == 10 and not s.in_void, "physical Thynome delivery earns campaign34")
		check(s.cargo_count(164) == int(pre_delivery.cargo.get("164", 0)) - 50,
			"Khador consumes exactly fifty mined crystals and preserves excess")
		check(s.blueprints.get("85", {}).get("progress", {}) == {"164": 50} and s.cargo_count(85) == 0,
			"delivery grants only the partially contributed recipe, not a completed drive")
		check(s.credits == 530 and int(s.story_mission.kind) == 11 and int(s.story_mission.station) == 30,
			"source continuation begins with unchanged earned credits")
		check(delivery_lines == app.game.campaign.dialogue(33, 1), "all original delivery result lines shown through native Next")
		check(DirAccess.copy_absolute(app.save_path(app.AUTOSAVE_SLOT), out.path_join("earned-crystal-handover.json")) == OK,
			"retain settled actual Thynome34 autosave")
		await shot("earned_crystal_handover")
		await save_checkpoint()
	check(FileAccess.get_file_as_bytes(source) == source_bytes, "original earned E33 bytes remain unchanged")
	await finish()
func route_to(destination: int) -> void:
	for trip in 16:
		if failures > 0 or app.game.session.station_id == destination: break
		var next := next_route_station(destination)
		if next < 0 or not await choose_destination(next) or not await fly_to_dock(): return
		await retain_dock()
	check(app.screen is Station and app.game.session.station_id == destination, "native route docks at station%d" % destination)
func check_flight_entry(reference: WeakRef) -> void:
	super.check_flight_entry(reference)
	var flight = reference.get_ref()
	if flight == null: return
	rock_choice = null
	flight.space.event.connect(crystal_event.bind(reference))
	if app.game.session.in_void:
		check(flight.space.bodies.filter(func(b): return b.kind == Body.Kind.ASTEROID).all(func(b): return b.ore == 164),
			"actual Void field contains supplied crystal ore164")
		phase = "mine"
func crystal_event(kind: String, data: Dictionary, reference: WeakRef) -> void:
	if kind not in ["wormhole_crossed", "mining_started", "mining_finished"]: return
	var flight = reference.get_ref()
	if flight == null: return
	var record := {"event": kind, "clock": flight.space.clock, "frame": frame, "data": data.duplicate(true),
		"cargo": app.game.session.cargo.duplicate(true), "hull": flight.space.player.hull,
		"armor": flight.space.player.armor, "shield": flight.space.player.shield}
	crystal_events.append(record)
	print("CRYSTAL EVENT ", JSON.stringify(record))
	if kind == "wormhole_crossed":
		crossing_count += 1
		check(int(data.step) == 33 and float(data.distance) < 4096, "actual portal threshold crossing preserves crystal mission33")
		if bool(data.from_void): phase = "return"
	elif kind == "mining_started":
		check(int(data.ore) == 164 and int(data.drill) == 87 and bool(data.locked), "real scanner lock starts actual equipped87 crystal drilling")
	elif kind == "mining_finished":
		mined_total += int(data.accepted_ore)
		core_total += int(data.accepted_core)
func pilot(reference: WeakRef) -> Dictionary:
	var flight = reference.get_ref()
	if flight == null: return {}
	var space = flight.space
	if space.portal_arriving() or (space.story != null and space.story.controls_locked): return {}
	if space.mining != null:
		return {"yaw": -1.0 if space.mining.drill > 1.0 else (1.0 if space.mining.drill < -1.0 else 0.0)}
	if space.mining_target != null: return {}
	if phase in ["enter", "exit"]:
		if space.wormhole == null or not space.wormhole.visible: return {}
		return point_at(space, space.wormhole.pos, space.wormhole)
	if phase == "mine":
		if app.game.session.cargo_count(164) >= 50:
			phase = "exit"
			return {}
		var rock: Body = rock_choice.get_ref() if rock_choice != null else null
		if rock == null or not rock.alive or rock.ore != 164:
			rock = null
			for b in space.bodies:
				if not b.alive or b.kind != Body.Kind.ASTEROID or b.ore != 164 or space._inside_mothership(b.pos): continue
				if rock == null or b.pos.distance_to(space.player.pos) < rock.pos.distance_to(space.player.pos): rock = b
			rock_choice = weakref(rock) if rock != null else null
		return point_at(space, rock.pos, rock) if rock != null else {}
	return super.pilot(reference)
func point_at(space, position: Vector3, goal: Body) -> Dictionary:
	var steer: Vector2 = space._steer_towards(space.player, position)
	return {"yaw": clampf(steer.x * 3.0, -1.0, 1.0), "pitch": clampf(steer.y * 3.0, -1.0, 1.0),
		"autopilot": space.autopilot, "fire_pressed": space.target == goal and space.locked and goal.kind == Body.Kind.ASTEROID}
func observe() -> void:
	await super.observe()
	if app.screen is Flight:
		var space = app.screen.space
		if phase == "enter": await shot("dima_portal_approach")
		if space.in_void and space.portal_arriving(): await shot("crystal_void_arrival")
		if space.mining != null:
			await shot("actual_crystal_drilling_%d" % mined_total)
		if phase == "exit": await shot("earned_crystals_exit")
		if phase == "return": await shot("earned_crystal_normal_return")
func clear_dialogue() -> void:
	for i in 100:
		var talk := dialogue(app.screen)
		if talk == null: return
		if app.game.session.story_step == 34:
			var line: Dictionary = talk.lines[talk.index]
			if delivery_lines.size() <= talk.index: delivery_lines.append(line.duplicate(true))
			await shot("crystal_delivery_line_%d" % talk.index)
		press(talk.next_button, "original dialogue Next")
		await frames(1)
	check(false, "original dialogue terminates")
func check_mining_ledger() -> void:
	var s = app.game.session
	check(mined_total >= 50 and s.cargo_count(164) == mined_total and s.stat("ore_mined") - ore_before_trip == mined_total,
		"accepted native drill yields exactly reconcile crystals and ore statistics")
	check(s.cargo_count(175) == core_total and s.stat("cores_mined") - cores_before_trip == core_total,
		"native core-first mining accounting reconciles every actual Void core")
	var preserved := true
	for key in input_header.cargo:
		preserved = preserved and int(s.cargo.get(key, 0)) >= int(input_header.cargo[key])
	check(preserved and s.cargo_free() >= 0 and s.credits == 530, "mining retains original cargo and credits within actual hull capacity")
	var salvage: int = s.stat("cargo_salvaged") - int(input_header.stats.get("cargo_salvaged", 0))
	check(s.cargo_used() == 6 + mined_total + core_total + salvage, "full hold accounts for original cargo plus mining, cores and real salvage")
func finish() -> void:
	var file := FileAccess.open(out.path_join("crystal-ledger.json"), FileAccess.WRITE)
	if file != null:
		file.store_string(JSON.stringify({"events": crystal_events, "ore": mined_total, "cores": core_total,
			"crossings": crossing_count, "delivery_lines": delivery_lines, "pre_delivery": pre_delivery}, "\t"))
	rock_choice = null
	await super.finish()
