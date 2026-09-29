extends "res://tests/earned_wormhole_run.gd"
## COPY the retained earned D26 Void save. All progress comes from ordinary
## flight input, native combat and Map/docking/save UI callbacks.
const INPUT_SHA := "9235dd444672db4e8fd3dce2169b54e6af221ec3502836a8c824b02fb09ac7f3"
var return_state := {}
var ambush_verified := false
var result_verified := false
var final_verified := false

func _init() -> void:
	# Own initialization replaces the inherited constructor, including its
	# deferred start. Accept only the two paths and the optional focus flag.
	var args := OS.get_cmdline_user_args()
	if args.size() == 2 or (args.size() == 3 and args[2] == "--ambush-only"):
		source = args[0]
		out = args[1]
	_run.call_deferred()

func _run() -> void:
	if started: return
	started = true
	if source.is_empty() or out.is_empty() or not FileAccess.file_exists(source):
		push_error("Provide the earned D26 JSON slot and a fresh output directory.")
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
	check(FileAccess.get_sha256(source) == INPUT_SHA, "retained input is the genuine earned rendered D26 lineage")
	if not header is Dictionary or not app.activate(str(header.get("content", ""))):
		check(false, "earned checkpoint's supplied content is installed")
		await finish()
		return
	input_step = int(header.get("story_step", -1))
	check(input_step == 26 and header.get("in_void", false), "input is actually in Void space at earned step twenty-six")
	if failures > 0:
		await finish()
		return
	DirAccess.make_dir_recursive_absolute(app.save_path(0).get_base_dir())
	check(DirAccess.copy_absolute(source, app.save_path(0)) == OK, "copy earned save into a fresh isolated disk host")
	app.show_title()
	await frames(3)
	app.screen._load()
	await frames(2)
	var box = app.screen.panel_holder.get_child(0).get_child(0)
	press(box.get_child(1), "title Load earned Void input")
	await frames(3)
	check(app.screen is Flight and app.game.session.in_void and app.game.session.story_step == 26,
		"real title load reopens Void flight without advancing its station-side mission")
	check(app.save_attempts.is_empty() and app.game.session.ship == header.ship,
		"loading the damaged earned input neither repairs nor writes a new save")
	await observe()
	await shot("earned_return_input_void")
	if failures == 0: await return_and_delivery()
	check(FileAccess.get_file_as_bytes(source) == source_bytes and FileAccess.get_sha256(source) == INPUT_SHA,
		"retained D26 source remains byte-identical after the entire replay")
	await finish()

func check_flight_entry(reference: WeakRef) -> void:
	super.check_flight_entry(reference)
	var flight = reference.get_ref()
	if flight == null: return
	var space = flight.space
	if space.in_void:
		check(space.story == null, "station-side ambush does not activate in Void world minus one")
	elif app.game.session.story_step == 26:
		check(space.station.station_id == 48 and app.game.session.system_index == 9,
			"physical return rebuilds the retained Sahi station and system")
		check(space.story != null and space.story.cast.size() == 2,
			"earned return creates exactly the two supplied ambush actors")
		if space.story != null:
			var formation := true
			for body in space.story.cast:
				var offset: Vector3 = body.pos - space.player.pos
				formation = formation and body.faction == 9 and body.ship_index == 8 and absf(offset.x) <= 700
				formation = formation and absf(offset.y) <= 700 and is_equal_approx(offset.z, 2000)
				formation = formation and body.basis.is_equal_approx(space.player.basis)
			check(formation, "ambush hulls and spawn offsets match the supplied scene")
		ambush_verified = failures == 0

func trace_portal(kind: String, data: Dictionary, reference: WeakRef) -> void:
	if kind not in ["wormhole_crossed", "wormhole_relocated"]: return
	var flight = reference.get_ref()
	if flight == null: return
	var space = flight.space
	var record := {"event": kind, "clock": space.clock, "frame": frame, "world": space.station.station_id,
		"step": app.game.session.story_step, "hull": space.player.hull, "armor": space.player.armor}
	if kind == "wormhole_crossed":
		crossing_count += 1
		record.distance = data.distance
		check(bool(data.from_void) and int(data.step) == 26 and float(data.distance) < 4096 and space.wormhole.usable(),
			"actual return crosses the open portal physically without skipping mission twenty-six")
		# The event follows the native durability store; this is read-only.
		return_state = {"ship": app.game.session.ship.duplicate(true), "cargo": app.game.session.cargo.duplicate(true),
			"markets": app.game.session.markets.duplicate(true), "saves": app.save_attempts.size()}
		# The native event listener rebuilds the next scene synchronously,
		# before this observer runs. Compare it with the still-live old ship.
		var returned = app.screen.space
		check(not returned.in_void and returned.player.hull == space.player.hull
			and returned.player.armor == space.player.armor and is_equal_approx(returned.player.shield, space.player.shield)
			and app.save_attempts.is_empty(), "physical return preserves actual damage and creates no docking save")
	portal_events.append(record)
	print("RETURN EVENT ", JSON.stringify(record))

func pilot(reference: WeakRef) -> Dictionary:
	var flight = reference.get_ref()
	if flight == null: return {}
	var space = flight.space
	if space.in_void:
		var defense := defensive_emp_input(space)
		if not defense.is_empty(): return defense
		if space.wormhole == null or not space.wormhole.visible: return {}
		var steering: Vector2 = space._steer_towards(space.player, space.wormhole.pos)
		return {"yaw": clampf(steering.x * 2.0, -1.0, 1.0), "pitch": clampf(steering.y * 2.0, -1.0, 1.0),
			"autopilot": space.autopilot}
	var input := super.pilot(reference)
	if app.game.session.story_step == 26 and bool(input.get("fire", false)):
		# Keep the primary pilot's stable target and firing solution. Giving
		# a nearest-pursuer EMP policy exclusive steering control starves
		# primary fire in a close two-ship circle.
		var emp_in_flight := false
		for projectile in space.projectiles:
			if projectile.owner == space.player and projectile.weapon.kind == "emp": emp_in_flight = true
		input.secondary = not emp_in_flight
	return input

func observe() -> void:
	await super.observe()
	if not app.screen is Flight: return
	var flight = app.screen
	var space = flight.space
	if space.in_void and space.wormhole != null and space.wormhole.visible:
		var distance: float = space.player.pos.distance_to(space.wormhole.pos)
		if not flight.view.camera.is_position_behind(space.wormhole.pos * flight.view.UNIT):
			if distance < 25000: await shot("return_vortex_approach_25000")
			if distance < 12000: await shot("return_vortex_approach_12000")
			if distance < 5500: await shot("return_vortex_crossing_5500")
	if not space.in_void and app.game.session.story_step == 26:
		await shot("earned_return_sahi_ambush")
		if space.shots_fired > 8: await shot("earned_return_ambush_combat")
	if app.game.session.story_step == 27 and not result_verified:
		var story = space.story
		check(crossing_count == 1 and ambush_verified and story != null and story.complete
			and story.cast.size() == 2 and story.cast.all(func(body): return not body.alive and body.dead_timer <= 0.0),
			"real combat and both completed deaths earn the delivery mission")
		check(app.game.session.cargo_count(131) >= 3 and not app.game.can_sell_cargo(131),
			"alien remains stay carried and protected until the actual delivery")
		result_verified = failures == 0
		await shot("earned_return_ambush_result")

func return_and_delivery() -> void:
	var credits: int = app.game.session.credits
	var jobs: int = app.game.session.stat("jobs")
	if not await fly_to_dock(): return
	check(result_verified and app.game.session.story_step == 27 and app.game.session.station_id == 48,
		"physical Sahi docking follows the earned return ambush and result")
	if failures > 0: return
	await save_checkpoint()
	check(DirAccess.copy_absolute(app.save_path(0), out.path_join("earned-return-ambush.json")) == OK,
		"retain the earned ambush save before continuing delivery")
	checkpoint_reloaded = failures == 0
	if OS.get_cmdline_user_args().has("--ambush-only"): return
	for trip in 20:
		if app.game.session.station_id == 10: break
		var next := next_route_station(10)
		if next < 0 or not await choose_destination(next): return
		if not await fly_to_dock(): return
		await shot("return_delivery_dock_%d" % app.game.session.station_id)
	check(app.screen is Station and app.game.session.station_id == 10 and app.game.session.story_step == 28,
		"actual travel and Thynome docking earn the following campaign mission")
	check(app.game.session.cargo_count(131) == 0 and app.game.can_sell_cargo(131),
		"actual delivery removes alien remains and clears the mission cargo lock")
	check(app.game.session.credits == credits and app.game.session.stat("jobs") == jobs,
		"zero-reward story return and delivery add no money or freelance completion")
	check(saved_state(app.AUTOSAVE_SLOT) == snapshot(), "native docking autosave contains the settled earned delivery")
	if failures > 0: return
	await shot("earned_return_delivery_checkpoint")
	await save_checkpoint()
	final_verified = failures == 0
	checkpoint_reloaded = final_verified
