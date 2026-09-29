extends "res://tests/earned_travel_run.gd"
## Exact COPY of earned A32; title/map/button callbacks and flight controls
## only. No cursor, cargo, capacity, durability or world-position assignment.
const INPUT_SHA := "9515f53e26071cf293e32187c60d787c99694f1ea46a99a8d9d3ce98448f64ba"
var input_header := {}
var khador_lines: Array = []
var cargo_balance := {}

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
		push_error("Provide the earned A32 JSON and a NEW isolated output directory.")
		quit(2)
		return
	root.size = Vector2i(1280, 800)
	DirAccess.make_dir_recursive_absolute(out)
	source_bytes = FileAccess.get_file_as_bytes(source)
	app = TestApp.new()
	save_root = out.path_join("test-saves-%d" % Time.get_ticks_usec())
	app.disk_saves = save_root
	node_added.connect(watch_flight_entry)
	node_added.connect(trace_flight_node)
	root.add_child(app)
	await frames(3)
	var header = JSON.parse_string(source_bytes.get_string_from_utf8())
	check(FileAccess.get_sha256(source) == INPUT_SHA, "input is the exact retained earned A32 Alioth checkpoint")
	if not header is Dictionary or not app.activate(str(header.get("content", ""))):
		check(false, "earned A32 content is installed")
		await finish()
		return
	input_header = header
	input_step = int(header.get("story_step", -1))
	check(input_step == 32 and not bool(header.in_void) and int(header.station) == 98 and int(header.system) == 19,
		"earned input is normal-space Alioth at cursor32")
	check(int(header.credits) == 30531 and int(header.equipment[1][0].count) == 7,
		"input retains the real report reward and seven finite rockets")
	if failures > 0:
		await finish()
		return
	DirAccess.make_dir_recursive_absolute(app.save_path(0).get_base_dir())
	check(DirAccess.copy_absolute(source, app.save_path(0)) == OK, "COPY A32 into a fresh isolated host")
	app.show_title()
	await frames(3)
	app.screen._load()
	await frames(2)
	press(app.screen.panel_holder.get_child(0).get_child(0).get_child(1), "title Load earned A32")
	await frames(3)
	check(app.screen is Station and app.game.session.story_step == 32 and app.save_attempts.is_empty(),
		"native title load restores Alioth without another report settlement")
	await shot("earned_a32_alioth_input")
	await inspect_warning("a32")
	for trip in 12:
		if failures > 0 or app.game.session.station_id == 10: break
		var next := next_route_station(10)
		if next < 0 or not await choose_destination(next): break
		if not await fly_to_dock(): break
		await clear_dialogue()
	check(app.screen is Station and app.game.session.station_id == 10 and app.game.session.system_index == 6
		and app.game.session.story_step == 33, "real travel and Thynome docking earn Khador's crystal mission")
	if failures == 0:
		var s = app.game.session
		check(int(s.story_mission.kind) == 8 and int(s.story_mission.station) == 10
			and int(s.story_mission.item) == 164 and int(s.story_mission.amount) == 50,
			"supplied next mission requires fifty actual crystals delivered to Thynome")
		check_resources(input_header)
		check(s.blueprints.is_empty() and not app.game.campaign.check(true, 10),
			"missing crystals cannot grant the drive blueprint or advance to step34")
		check(khador_lines.size() == 8, "all eight original Khador-result lines were presented through Next controls")
		check(DirAccess.copy_absolute(app.save_path(app.AUTOSAVE_SLOT), out.path_join("earned-khador-request.json")) == OK,
			"retain actual Thynome docking autosave as the next earned input")
		await shot("earned_khador_request_docked")
		await inspect_warning("a33")
		await save_checkpoint()
		await inspect_warning("reload33")
		check(s.credits == 30531 and app.game.session.story_step == 33,
			"saved Khador request reloads without repeating rewards or advancing progress")
	check(FileAccess.get_file_as_bytes(source) == source_bytes and FileAccess.get_sha256(source) == INPUT_SHA,
		"original A32 source remains byte-identical")
	await finish()

func check_resources(before: Dictionary) -> void:
	var after := snapshot()
	check(after.credits == before.credits and after.equipment == before.equipment,
		"earned travel preserves money, fitted equipment and all seven finite rockets")
	var additions := {}
	var original_hold := 0
	var gained := 0
	var preserved := true
	for key in before.cargo:
		original_hold += int(before.cargo[key])
		if int(after.cargo.get(key, 0)) < int(before.cargo[key]): preserved = false
	for key in after.cargo:
		var delta := int(after.cargo[key]) - int(before.cargo.get(key, 0))
		if delta != 0: additions[key] = delta
		gained += delta
	var salvaged := int(after.stats.get("cargo_salvaged", 0)) - int(before.stats.get("cargo_salvaged", 0))
	cargo_balance = {"original_hold": original_hold, "additions": additions, "salvaged_delta": salvaged,
		"hold": app.game.session.cargo_used(), "capacity": app.game.session.ship_stats().cargo_capacity}
	print("EARNED CARGO BALANCE ", JSON.stringify(cargo_balance))
	check(preserved and gained == salvaged and salvaged >= 0 and cargo_balance.capacity == 25
		and cargo_balance.hold == original_hold + salvaged and app.game.session.cargo_count(164) == 0,
		"all original cargo survives; only real accounted salvage is added within the unchanged hold")

func check_flight_entry(reference: WeakRef) -> void:
	super.check_flight_entry(reference)
	var flight = reference.get_ref()
	if flight != null: flight.controls.scripted = pilot.bind(reference)

func pilot(reference: WeakRef) -> Dictionary:
	var flight = reference.get_ref()
	if flight == null: return {}
	var space = flight.space
	if space.story != null and space.story.controls_locked: return {}
	if space.docking >= 0 or space.jumping >= 0 or space.travelling >= 0: return {}
	var goal: Body = space.station
	var sid := int(app.game.destination.get("station", -1))
	if sid >= 0 and sid != space.station.station_id:
		if app.catalogue.system_of_station(sid) != app.game.session.system_index:
			goal = space.gate
		else:
			for b in space.bodies:
				if b.kind == Body.Kind.STAR and b.station_id == sid: goal = b; break
	if goal == null: return {}
	var origin: Vector3 = space.player.pos
	var at: Vector3 = origin + space._star_direction(goal) * 100000.0 if goal.kind == Body.Kind.STAR else goal.pos
	var distance: float = origin.distance_to(at)
	var threat := false
	for enemy in space.hostiles():
		if not enemy.friendly and enemy.visible and not enemy.disabled and enemy.pos.distance_to(origin) < 45000.0:
			threat = true
			break
	if threat and distance > 13000.0:
		return defend_primary(space)
	# Actual stick/booster controls and rock avoidance, not an invulnerable
	# transport or an enemy reset. Keep the finite missiles in reserve.
	var direction: Vector3 = (at - origin).normalized()
	for b in space.bodies:
		if not b.alive or b.kind != Body.Kind.ASTEROID or b.size <= 30: continue
		var relative: Vector3 = b.pos - origin
		var ahead := relative.dot(direction)
		var radius: float = 1500.0 * b.scale.length() / 1.7 + space.PLAYER_RADIUS + 2500.0
		if ahead > -radius and ahead < 18000.0 and (relative - direction * ahead).length() < radius:
			at = b.pos + Vector3.UP * radius * 2.0
			break
	var steering: Vector2 = space._steer_towards(space.player, at)
	return {"yaw": clampf(steering.x * 2.0, -1.0, 1.0), "pitch": clampf(steering.y * 2.0, -1.0, 1.0),
		"boost": distance > 10000.0, "autopilot": space.autopilot,
		"fire_pressed": goal.kind == Body.Kind.STAR and space.target == goal and space.locked}

func defend_primary(space) -> Dictionary:
	var enemy: Body = combat_target.get_ref() if combat_target != null else null
	var nearest: Body
	for body in space.hostiles():
		if body.friendly or not body.visible or body.disabled: continue
		if nearest == null or body.pos.distance_to(space.player.pos) < nearest.pos.distance_to(space.player.pos): nearest = body
	if nearest == null: return navigation_input(space)
	if enemy == null or not enemy.alive or enemy.friendly or enemy.disabled or enemy.pos.distance_to(space.player.pos) > nearest.pos.distance_to(space.player.pos) * 1.5:
		enemy = nearest
		combat_target = weakref(enemy)
	var distance: float = enemy.pos.distance_to(space.player.pos)
	var weapon: Dictionary = space.player.weapons[0]
	var speed: float = float(weapon.speed) + space.player.speed
	var reach: float = speed * float(weapon.life)
	var aim: Vector3 = enemy.pos + enemy.forward() * enemy.speed * distance / maxf(speed, 1.0)
	var stick: Vector2 = space._steer_towards(space.player, aim)
	var forward: Vector3 = space.player.forward()
	var sight = space._sweep({"owner": space.player, "pos": space.player.pos + forward * 400.0}, forward * minf(reach, distance + enemy.radius))
	var safe_shot: bool = sight != null and sight.is_ship() and sight.hostile and not sight.friendly
	return {"yaw": clampf(stick.x * 2.0, -1.0, 1.0), "pitch": clampf(stick.y * 2.0, -1.0, 1.0),
		"fire": safe_shot and distance < reach, "boost": distance > 20000.0, "autopilot": space.autopilot}

func select_system(map, id: int) -> void:
	var click := InputEventMouseButton.new()
	click.button_index = MOUSE_BUTTON_LEFT
	click.pressed = true
	click.position = map._to_screen(map.canvas, app.catalogue.system(id))
	map.canvas._gui_input(click)
	await frames(3)
	check(map.selected_system == id, "real map pointer selects warning/mission system %d" % id)

func inspect_warning(label: String) -> void:
	var before := snapshot()
	if not press(app.screen.menu.get_child(2), "Map warning inspection"): return
	await frames(4)
	var map = app.screen.current_panel
	check(map.wormhole_address() == {"station": 91, "system": 18}, "earned map warning uses actual Dima portal address")
	check(map.story_address() == {"station": 10, "system": 6}, "earned map retains Thynome story destination")
	await select_system(map, 18)
	var dima := named_button(map.side, app.catalogue.station_name(91))
	check(dima != null and dima.has_meta("wormhole_station") and not dima.has_meta("story_station"),
		"original portal animation marks Dima's station row, separate from the crystal delivery")
	await shot(label + "_map_portal_warning")
	await frames(18)
	await shot(label + "_map_portal_animated")
	await select_system(map, 6)
	var thynome := named_button(map.side, app.catalogue.station_name(10))
	check(thynome != null and thynome.has_meta("story_station") and not thynome.has_meta("wormhole_station"),
		"Thynome keeps only the correct mission marker")
	await shot(label + "_map_thynome_mission")
	check(snapshot() == before, "viewing the warning does not mutate earned state")

func clear_dialogue() -> void:
	for i in 100:
		var talk := dialogue(app.screen)
		if talk == null: return
		if app.game.session.story_step == 33 and app.game.session.station_id == 10:
			var line: Dictionary = talk.lines[talk.index]
			if not khador_lines.has(line): khador_lines.append(line.duplicate(true))
			await shot("khador_result_line_%d" % talk.index)
		else:
			await shot("dialogue_step%d" % app.game.session.story_step)
		press(talk.next_button, "original dialogue Next")
		await frames(1)
	check(false, "dialogue ends within its native line count")

func finish() -> void:
	var file := FileAccess.open(out.path_join("khador-dialogue.json"), FileAccess.WRITE)
	if file != null: file.store_string(JSON.stringify(khador_lines, "\t"))
	file = FileAccess.open(out.path_join("cargo-balance.json"), FileAccess.WRITE)
	if file != null: file.store_string(JSON.stringify(cargo_balance, "\t"))
	await super.finish()
