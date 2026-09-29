extends "res://tests/earned_travel_run.gd"
## COPY of the genuine B30 scan result. All gameplay changes come from
## visible UI callbacks and the same flight-control dictionary as a player.
## No campaign, inventory, durability, damage or position assignments.
const INPUT_SHA := "fda488949bba6dfa35ae3a720a0ba7ea56ffa03cebf17ce172b29fa3f8e95617"
var return_events: Array = []
var crossings := 0
var arrivals := 0
var saw_result := false
var saw_delivery := false
var input_header := {}

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 2:
		source = args[0]
		out = args[1]
	_run.call_deferred()

func _run() -> void:
	if started: return
	started = true
	if source.is_empty() or out.is_empty() or not FileAccess.file_exists(source):
		push_error("Provide the retained earned B30 JSON and a fresh output directory.")
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
	check(FileAccess.get_sha256(source) == INPUT_SHA, "input is the exact retained earned B30 scan checkpoint")
	if not header is Dictionary or not app.activate(str(header.get("content", ""))):
		check(false, "earned B30 content is installed")
		await finish()
		return
	input_header = header
	input_step = int(header.get("story_step", -1))
	check(input_step == 30 and bool(header.get("in_void", false)) and int(header.station) == 91 and int(header.system) == 18,
		"earned input is still in Void with the real Dima return address")
	check(int(header.credits) == 531 and int(header.ship.hull) == 175
		and int(header.equipment[1][0].id) == 35 and int(header.equipment[1][0].count) == 7,
		"input retains earned money, durability and seven finite rockets")
	if failures > 0:
		await finish()
		return
	DirAccess.make_dir_recursive_absolute(app.save_path(0).get_base_dir())
	check(DirAccess.copy_absolute(source, app.save_path(0)) == OK, "copy B30 into a fresh isolated host")
	app.show_title()
	await frames(3)
	app.screen._load()
	await frames(2)
	press(app.screen.panel_holder.get_child(0).get_child(0).get_child(1), "title Load earned B30")
	await frames(3)
	check(app.screen is Flight and app.game.session.in_void and app.game.session.story_step == 30
		and app.save_attempts.is_empty(), "real title load reopens Void flight without false station settlement")
	check(not app.screen.space.portal_arriving() and int(app.game.session.ship.hull) == 175
		and app.game.session.credits == 531, "loading is not another physical portal arrival or a repair")
	await shot("earned_b30_void_input")
	if failures == 0 and await fly_to_dock():
		check(crossings == 1 and arrivals == 1 and saw_result and app.game.session.station_id == 91
			and app.game.session.story_step == 31, "physical escape, full arrival shot and source result precede real Dima docking")
		check(app.game.session.credits == 531, "return and Dima docking award no invented scan reward")
		check(DirAccess.copy_absolute(app.save_path(app.AUTOSAVE_SLOT), out.path_join("earned-dima-return.json")) == OK,
			"retain the actual earned Dima docking autosave")
		await shot("earned_dima_return_docked")
		if failures == 0: await route_and_report()
	check(FileAccess.get_file_as_bytes(source) == source_bytes and FileAccess.get_sha256(source) == INPUT_SHA,
		"original B30 source remains byte-identical after the replay")
	await finish()

func check_flight_entry(reference: WeakRef) -> void:
	super.check_flight_entry(reference)
	var flight = reference.get_ref()
	if flight == null: return
	flight.controls.scripted = pilot.bind(reference)
	flight.space.event.connect(return_event.bind(reference))
	var space = flight.space
	if space.portal_arriving():
		check(not space.in_void and app.game.session.story_step == 30 and space.station.station_id == 91,
			"physical return opens Dima flight without skipping mission thirty")
		check(space.wormhole.elapsed == 39000 and space.wormhole.pos.is_equal_approx(space.player.pos - space.player.forward() * 8192.0),
			"earned return starts the source closing portal behind the player")
		check(app.save_attempts.is_empty() and app.game.session.credits == 531,
			"physical crossing grants no station service, reward or docking save")
		return_events.append({"event": "arrival_started", "clock": space.clock,
			"position": str(space.player.pos), "portal": str(space.wormhole.pos), "camera": str(space.portal_arrival_camera),
			"hull": space.player.hull, "armor": space.player.armor, "shield": space.player.shield})

func return_event(kind: String, data: Dictionary, reference: WeakRef) -> void:
	if kind not in ["wormhole_crossed", "portal_arrival_finished", "wormhole_relocated"]: return
	var flight = reference.get_ref()
	if flight == null: return
	var space = flight.space
	var record := {"event": kind, "clock": space.clock, "data": data.duplicate(true), "frame": frame,
		"hull": space.player.hull, "armor": space.player.armor, "shield": space.player.shield,
		"position": str(space.player.pos), "equipment": app.game.session.equipment.duplicate(true)}
	return_events.append(record)
	print("RETURN EVENT ", JSON.stringify(record))
	if kind == "wormhole_crossed":
		crossings += 1
		check(bool(data.from_void) and int(data.step) == 30 and float(data.distance) < 4096.0,
			"earned scan escape physically crosses the portal threshold in mission thirty")
	elif kind == "portal_arrival_finished":
		arrivals += 1
		check(int(data.elapsed) > 7000 and int(data.elapsed) <= 7032 and not space.in_void
			and app.game.session.story_step == 30, "source arrival camera completes before the ten-second return objective")

func pilot(reference: WeakRef) -> Dictionary:
	var flight = reference.get_ref()
	if flight == null: return {}
	var space = flight.space
	if space.portal_arriving(): return {}
	if not space.in_void: return super.pilot(reference)
	# Flight controls only: pursue the current physical exit and avoid the
	# supplied mothership bounds and large asteroids along that flight path.
	var at: Vector3 = space.wormhole.pos
	var origin: Vector3 = space.player.pos
	if space.mothership != null:
		var centre: Vector3 = space.mothership.pos + space.mothership.ai.centre
		var half: Vector3 = space.mothership.ai.half + Vector3.ONE * 8000.0
		var box := AABB(centre - half, half * 2.0)
		if box.intersects_segment(origin, at):
			var side := 1.0 if origin.x >= centre.x else -1.0
			at = Vector3(centre.x + side * (half.x + 15000.0), origin.y, at.z)
	var direction: Vector3 = (at - origin).normalized()
	for b in space.bodies:
		if not b.alive or b.kind != Body.Kind.ASTEROID or b.size <= 30: continue
		var relative: Vector3 = b.pos - origin
		var ahead := relative.dot(direction)
		var radius: float = 1500.0 * b.scale.length() / 1.7 + space.PLAYER_RADIUS + 2500.0
		if ahead > -radius and ahead < 18000.0 and (relative - direction * ahead).length() < radius:
			at = b.pos + Vector3.UP * radius * 2.0
			break
	var steer: Vector2 = space._steer_towards(space.player, at)
	var forward: Vector3 = space.player.forward()
	var hit = space._sweep({"owner": space.player, "pos": origin + forward * 400.0}, forward * 18000.0)
	var fire: bool = hit != null and hit.is_ship() and hit.hostile and not hit.friendly
	return {"yaw": clampf(steer.x * 2.0, -1.0, 1.0), "pitch": clampf(steer.y * 2.0, -1.0, 1.0),
		"boost": true, "fire": fire, "secondary": fire and space.locked and space.target == hit,
		"autopilot": space.autopilot}

func observe() -> void:
	if app.screen is Flight:
		var space = app.screen.space
		if space.portal_arriving():
			if space.clock < 1000: await shot("earned_return_arrival_camera")
			if space.clock > 1600 and space.clock < 4000: await shot("earned_return_portal_closing")
			if space.clock > 5000: await shot("earned_return_late_arrival_camera")
		elif not space.in_void and app.game.session.story_step == 30:
			await shot("earned_return_controls_restored")
		if app.game.session.story_step == 31 and not saw_result:
			saw_result = true
			check(crossings == 1 and arrivals == 1 and app.screen.flight_ms > 10000
				and app.game.session.station_id == 91 and int(app.game.session.story_mission.station) == 98,
				"actual Dima flight time earns Brent's Alioth report continuation")
			check(app.screen.conversation != null and app.game.session.credits == 531,
				"original return conversation is shown without paying the later report reward")
			await shot("earned_brent_return_result")
	await super.observe()

func route_and_report() -> void:
	for trip in 10:
		if app.game.session.station_id == 98: break
		var next := next_route_station(98)
		if next < 0 or not await choose_destination(next): return
		if not await fly_to_dock(): return
		await clear_dialogue()
		if failures > 0: return
	check(app.screen is Station and app.game.session.station_id == 98 and app.game.session.system_index == 19
		and app.game.session.story_step == 32, "real gate travel and Alioth docking complete the supplied report mission")
	check(app.game.session.credits == 30531 and app.game.session.stat("jobs") == 2,
		"only the source thirty-thousand-credit story reward is paid; freelance count is unchanged")
	if failures > 0: return
	saw_delivery = true
	check(DirAccess.copy_absolute(app.save_path(app.AUTOSAVE_SLOT), out.path_join("earned-alioth-report.json")) == OK,
		"retain the actual Alioth report docking autosave")
	await shot("earned_alioth_report_docked")
	await save_checkpoint()
	check(app.game.session.story_step == 32 and app.game.session.credits == 30531,
		"title reload cannot repeat the report reward or advance the next mission")

func finish() -> void:
	var file := FileAccess.open(out.path_join("return-events.json"), FileAccess.WRITE)
	if file != null: file.store_string(JSON.stringify({"events": return_events, "crossings": crossings,
		"arrivals": arrivals, "saw_result": saw_result, "saw_delivery": saw_delivery}, "\t"))
	await super.finish()
