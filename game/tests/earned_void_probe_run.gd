extends "res://tests/earned_travel_run.gd"
## Real Map/shop/fitting/flight/radio controls, starting from a COPY of B28.
## No assignments to campaign, inventory, health, enemy damage or position.
const INPUT_SHA := "3faf7a1730fbc0ed0cf468e2d2be4a1677045c8275bd0370c5b18624b4085754"
const DIMA_INPUT_SHA := "544d08daafa0039af87ca10aa2a4f245d28bfa25330b2bb193fa7056d59ff0ae"
var dima_only := false
var enter_portal := false
var probe_events: Array = []
var crossings := 0
var saw_launch := false
var saw_scan := false
var saw_result := false
var checkpoint_reloaded := false
var scan_started_clock := -1
var scan_result_clock := -1

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 2 or (args.size() == 3 and args[2] == "--dima-only"):
		source = args[0]
		out = args[1]
		dima_only = args.size() == 3
	_run.call_deferred()

func _run() -> void:
	if started: return
	started = true
	if source.is_empty() or out.is_empty() or not FileAccess.file_exists(source):
		push_error("Provide the retained earned B28 JSON and a fresh output directory.")
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
	var expected_sha := DIMA_INPUT_SHA if dima_only else INPUT_SHA
	check(FileAccess.get_sha256(source) == expected_sha, "input is the retained genuine earned rendered lineage")
	if not header is Dictionary or not app.activate(str(header.get("content", ""))):
		check(false, "earned input content is installed")
		await finish()
		return
	input_step = int(header.get("story_step", -1))
	check(input_step == 28 and not bool(header.get("in_void", false)), "input is the earned station-side step twenty-eight")
	if dima_only: check(int(header.get("station", -1)) == 91 and int(header.get("system", -1)) == 18,
		"focused input is the actual six-gate Dima docking checkpoint")
	if failures > 0:
		await finish()
		return
	DirAccess.make_dir_recursive_absolute(app.save_path(0).get_base_dir())
	check(DirAccess.copy_absolute(source, app.save_path(0)) == OK, "copy B28 into a fresh isolated host")
	app.show_title()
	await frames(3)
	app.screen._load()
	await frames(2)
	press(app.screen.panel_holder.get_child(0).get_child(0).get_child(1), "title Load earned B28")
	await frames(3)
	check(app.screen is Station and app.game.session.story_step == 28 and app.save_attempts.is_empty(), "title load restores B28 without inventing a docking transaction")
	seen_screen = app.screen.get_instance_id()
	await clear_dialogue()
	await shot("earned_b28_input")
	# Buy only these verified, affordable offers from the retained station.
	if not dima_only:
		await buy_and_mount(8, 0, 0)
		if failures == 0: await buy_ammunition()
	else:
		await buy_and_mount(71, 3, 1)
		if failures == 0: await buy_and_mount(56, 3, 2)
	if failures == 0: await route_and_probe()
	check(FileAccess.get_file_as_bytes(source) == source_bytes and FileAccess.get_sha256(source) == expected_sha,
		"original earned source remains byte-identical after the replay")
	await finish()

func buy_ammunition() -> void:
	var id := 35
	if not press(app.screen.menu.get_child(0), "Hangar ammunition"): return
	await frames(3)
	var tabs = app.screen.current_panel
	var shop = tabs.get_child(0)
	var fitting = tabs.get_child(1)
	check(app.catalogue.category(id) == 1, "retained ammunition offer is a secondary weapon")
	if failures > 0: return
	if not press(item_row(shop.shelf_list, app.catalogue.item_name(id)), "select actual ammunition offer"): return
	await frames(2)
	var amount: int = shop._available()
	var before: int = app.game.session.credits
	var price: int = app.game.price_here(id)
	if not press(named_button(shop.detail, "Max"), "choose affordable ammunition quantity"): return
	await frames(2)
	if not press(named_button(shop.detail, "Buy"), "Buy actual ammunition"): return
	await frames(3)
	check(app.game.session.credits == before - price * amount and app.game.session.cargo_count(id) == amount,
		"ammunition spends earned credits at the real shelf price")
	tabs.current_tab = 1
	await frames(3)
	var rows: Array = fitting.slots_list.get_children().filter(func(n): return n is Button and not n.is_queued_for_deletion())
	if not press(rows[app.game.session.equipment[0].size()], "select secondary slot"): return
	await frames(2)
	if not press(item_row(fitting.detail, app.catalogue.item_name(id)), "fit purchased ammunition"): return
	await frames(3)
	check(int(app.game.session.equipment[1][0].id) == id and int(app.game.session.equipment[1][0].count) == amount
		and app.game.session.cargo_count(id) == 0, "fitting transfers the actual purchased ammunition stack")
	gear_purchases.append({"id": id, "count": amount, "price": price, "station": app.game.session.station_id})
	await shot("earned_ammunition_purchase")

func check_flight_entry(reference: WeakRef) -> void:
	super.check_flight_entry(reference)
	var flight = reference.get_ref()
	if flight == null: return
	flight.space.event.connect(probe_event.bind(reference))
	if app.game.session.story_step == 28 and app.game.session.station_id == 91:
		check(flight.space.story != null and flight.space.story.cast.size() == 5 and flight.space.story.objective.is_empty(),
			"earned Dima arrival builds the source five-fighter portal encounter")
	if app.game.session.story_step == 29:
		check(app.game.session.in_void and flight.space.story != null and flight.space.story.cast.size() == 3
			and flight.space.mothership != null, "earned portal entry builds the real Void scan world")
		check(flight.space.portal_arriving() and flight.space.wormhole.elapsed == 39000
			and flight.space.wormhole.pos.is_equal_approx(flight.space.player.pos - flight.space.player.forward() * 8192.0),
			"earned Void entry begins the source closing-portal arrival shot")

func probe_event(kind: String, data: Dictionary, reference: WeakRef) -> void:
	if kind not in ["wormhole_crossed", "probe_launched", "probe_scan_started", "probe_escape_failed"]: return
	var flight = reference.get_ref()
	if flight == null: return
	var record := {"event": kind, "clock": flight.space.clock, "frame": frame, "data": data.duplicate(true),
		"hull": flight.space.player.hull, "armor": flight.space.player.armor}
	probe_events.append(record)
	print("PROBE EVENT ", JSON.stringify(record))
	if kind == "wormhole_crossed":
		crossings += 1
		check(int(data.step) == 28 and not bool(data.from_void) and float(data.distance) < 4096,
			"mission twenty-eight advances by a real physical portal threshold crossing")
	elif kind == "probe_launched":
		saw_launch = true
		check(bool(data.locked) and flight.space.target == flight.space.mothership,
			"earned probe launches after actual mothership scanner lock")
	elif kind == "probe_scan_started":
		saw_scan = true
		scan_started_clock = int(data.clock)
		check(flight.space.story._done(2) and int(data.duration) == 180000, "all three actual probe radios precede the full scan countdown")
	elif kind == "probe_escape_failed":
		check(false, "test pilot does not abandon the active scan")

func pilot(reference: WeakRef) -> Dictionary:
	var flight = reference.get_ref()
	if flight == null: return {}
	var space = flight.space
	var step: int = app.game.session.story_step
	if space.story != null and space.story.controls_locked: return {}
	if step == 28 and app.game.session.station_id == 91:
		if not enter_portal: return navigation_input(space)
		return steer_at(space, space.wormhole.pos)
	if step == 29 and space.story != null:
		if space.story.stage < 2: return steer_at(space, space.mothership.pos, false)
		# Fight with the purchased primary and finite EMP rockets. These are
		# ordinary stick, target-cycle, boost and weapon controls only.
		var controls: Dictionary = super.pilot(reference)
		var enemy: Body = combat_target.get_ref() if combat_target != null else null
		if enemy != null and enemy.alive:
			var distance: float = enemy.pos.distance_to(space.player.pos)
			var direction: Vector3 = (enemy.pos - space.player.pos).normalized()
			var guided_in_flight := false
			for projectile in space.projectiles:
				if projectile.owner == space.player and projectile.weapon.kind == "missile" and projectile.target == enemy:
					guided_in_flight = true
			controls.next_target = space.target != enemy and space.clock % 320 == 0
			controls.secondary = space.target == enemy and space.locked and not enemy.disabled and not guided_in_flight
			controls.secondary = controls.secondary and distance < 18000.0 and space.player.forward().dot(direction) > 0.94
			controls.boost = distance > 24000.0
			return controls
		# Keep within the playable world, away from the still-fatal exit.
		var radial: Vector3 = space.player.pos.normalized()
		var direction: Vector3 = radial.cross(Vector3.UP).normalized()
		if space.player.pos.length() > 240000.0: direction = (direction - radial * 0.6).normalized()
		if space.player.pos.length() < 100000.0: direction = (direction + radial).normalized()
		return steer_at(space, space.player.pos + direction * 80000.0)
	return super.pilot(reference)

func steer_at(space, destination: Vector3, weapons := true) -> Dictionary:
	var at := destination
	var direction: Vector3 = (at - space.player.pos).normalized()
	for b in space.bodies:
		if not b.alive or b.kind != Body.Kind.ASTEROID or b.size <= 30: continue
		var relative: Vector3 = b.pos - space.player.pos
		var ahead := relative.dot(direction)
		var radius: float = 1500.0 * b.scale.length() / 1.7 + space.PLAYER_RADIUS + 2500.0
		if ahead > -radius and ahead < 18000.0 and (relative - direction * ahead).length() < radius:
			at = b.pos + Vector3.UP * radius * 2.0
			break
	var steer: Vector2 = space._steer_towards(space.player, at)
	var forward: Vector3 = space.player.forward()
	var hit = space._sweep({"owner": space.player, "pos": space.player.pos + forward * 400.0}, forward * 18000.0)
	var fire: bool = weapons and hit != null and hit.is_ship() and hit.hostile and not hit.friendly
	return {"yaw": clampf(steer.x * 2.0, -1.0, 1.0), "pitch": clampf(steer.y * 2.0, -1.0, 1.0),
		"fire": fire, "secondary": fire and space.locked and space.target == hit, "boost": weapons, "autopilot": space.autopilot}

func observe() -> void:
	if app.screen is Flight:
		var story = app.screen.space.story
		if app.game.session.story_step == 29 and story != null:
			if app.screen.space.portal_arriving():
				if app.screen.space.clock < 1000: await shot("earned_void_entry_arrival_camera")
				if app.screen.space.clock > 1600 and app.screen.space.clock < 4000: await shot("earned_void_entry_portal_closing")
			if story.probe_visible: await shot("earned_probe_cinematic")
			if not story.message().is_empty(): await shot("earned_probe_radio_%d" % story.current)
			if story.stage == 2:
				await shot("earned_scan_countdown")
				if app.screen.space.shots_fired > 5: await shot("earned_scan_combat")
				if story.probe_remaining_ms() < 60000: await shot("earned_scan_last_minute")
			if story.complete and not saw_result:
				saw_result = true
				scan_result_clock = story.clock
				check(scan_result_clock - scan_started_clock > 180000 and app.screen.space.player.alive,
					"actual unpaused survival beyond three minutes earns the success result")
				await shot("earned_probe_success_dialogue")
		if app.game.session.story_step == 28 and app.game.session.station_id == 91:
			await shot("earned_nehma_portal_encounter")
	await super.observe()

func route_and_probe() -> void:
	for trip in 18:
		if app.game.session.station_id == 91: break
		var next := next_route_station(91)
		if next < 0 or not await choose_destination(next): return
		if not await fly_to_dock(): return
		await clear_dialogue()
		if failures > 0: return
	check(app.screen is Station and app.game.session.station_id == 91 and app.game.session.system_index == 18,
		"real gate and in-system travel reaches Dima without assigning a location")
	if failures > 0: return
	if not dima_only:
		check(DirAccess.copy_absolute(app.save_path(app.AUTOSAVE_SLOT), out.path_join("earned-dima-arrival.json")) == OK,
			"retain actual settled Dima docking autosave as an independent earned checkpoint")
	await shot("earned_nehma_docking_checkpoint")
	enter_portal = true
	if not press(app.screen.launch_button, "launch for actual Dima portal encounter"): return
	await frames(3)
	for tick in 50000:
		frame += 1
		await observe()
		await clear_dialogue()
		if failures > 0: return
		if app.screen is Flight and app.screen.defeated:
			await shot("earned_probe_defeat")
			check(false, "survive the earned portal and scan flight")
			return
		if app.game.session.story_step == 30 and app.game.session.in_void:
			check(crossings == 1 and saw_launch and saw_scan and saw_result, "physical entry, scanner lock, radios and survival all precede the earned result")
			await preserve_scan_checkpoint()
			return
		await frames(1)
	check(false, "earned scan reaches its result within the bounded run")

func preserve_scan_checkpoint() -> void:
	app.screen.set_paused(true)
	var checkpoint := app.save_summary(app.AUTOSAVE_SLOT)
	check(int(checkpoint.get("story_step", -1)) == 30 and bool(checkpoint.get("in_void", false)),
		"native result autosave contains earned step thirty in Void space")
	check(DirAccess.copy_absolute(app.save_path(app.AUTOSAVE_SLOT), app.save_path(0)) == OK,
		"retain the native earned scan autosave verbatim as manual checkpoint")
	check(DirAccess.copy_absolute(app.save_path(0), out.path_join("earned-probe-result.json")) == OK,
		"retain a separate earned probe result artifact")
	var attempts := app.save_attempts.size()
	app.show_title()
	await frames(3)
	app.screen._load()
	await frames(2)
	press(app.screen.panel_holder.get_child(0).get_child(0).get_child(1), "title reload earned probe result")
	await frames(3)
	check(app.screen is Flight and app.game.session.in_void and app.game.session.story_step == 30,
		"title reload resumes the earned Void result without opening a station")
	check(app.save_attempts.size() == attempts and app.game.session.ship == checkpoint.ship
		and app.game.session.cargo == checkpoint.cargo and app.game.session.markets == checkpoint.markets,
		"earned result reload neither heals, resaves, changes cargo nor rolls station inventory")
	checkpoint_reloaded = failures == 0
	app.screen.set_paused(true)
	await shot("earned_probe_checkpoint_reload")

func finish() -> void:
	if app != null:
		var file := FileAccess.open(out.path_join("probe-events.json"), FileAccess.WRITE)
		if file != null: file.store_string(JSON.stringify({"events": probe_events, "crossings": crossings, "scan_started": scan_started_clock,
			"scan_result": scan_result_clock, "checkpoint_reloaded": checkpoint_reloaded}, "\t"))
	await super.finish()
