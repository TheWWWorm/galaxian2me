extends "res://tests/earned_travel_run.gd"
## Controller-only replay from the genuine E24 reward save. No assigned
## campaign progress, positions, damage, cargo, weapons or money.
var portal_events: Array = []
var crossing_count := 0
var saw_void := false
var checkpoint_reloaded := false

func check_flight_entry(reference: WeakRef) -> void:
	super.check_flight_entry(reference)
	var flight = reference.get_ref()
	if flight == null: return
	flight.space.event.connect(trace_portal.bind(reference))
	if flight.space.in_void:
		saw_void = true
		check(flight.game.session.story_step in [25, 26] and flight.space.station.station_id == -1,
			"actual rebuilt flight has the Void world identity and earned arrival cursor")
		check(not flight.space.station.visible and flight.space.gate == null and flight.space.station_boxes.is_empty(),
			"actual Void flight contains no normal dock or gate")

func trace_portal(kind: String, data: Dictionary, reference: WeakRef) -> void:
	if kind not in ["wormhole_cinematic", "wormhole_revealed", "wormhole_crossed", "wormhole_relocated", "void_regenerated"]: return
	var flight = reference.get_ref()
	if flight == null: return
	var space = flight.space
	var record := {"event": kind, "frame": frame, "clock": space.clock, "world": space.station.station_id,
		"collected": int(space.stats.get("collected", 0)), "hull": space.player.hull, "armor": space.player.armor}
	if kind == "wormhole_crossed":
		crossing_count += 1
		record.distance = data.distance
		record.step = data.step
		record.radios_finished = space.story.finished.duplicate() if space.story != null else []
		check(float(data.distance) < 4096 and space.wormhole.usable() and not bool(data.from_void),
			"actual entry physically crosses the open portal threshold from normal space")
		void_salvaged_units = int(space.stats.get("collected", 0))
		void_salvage_completed = void_salvaged_units >= 3 and app.game.session.cargo_count(131) >= 3
		check(void_salvage_completed, "physical entry carries genuinely salvaged alien remains")
	portal_events.append(record)
	print("PORTAL EVENT ", JSON.stringify(record))

func pilot(reference: WeakRef) -> Dictionary:
	var flight = reference.get_ref()
	if flight == null: return {}
	var space = flight.space
	if space.story != null and space.story.controls_locked: return {}
	if not space.in_void and (space.story == null or not space.story.active()):
		# The objective is at Sahi. Travel need not clear every unrelated
		# hostile encountered along the way; real navigation still has to
		# survive fire, dodge rocks and reach the actual gates and docks.
		var evasion := defensive_emp_input(space)
		if not evasion.is_empty(): return evasion
		return navigation_input(space)
	if app.game.session.story_step == 24 and space.story != null and space.story.active():
		# Salvage available wreckage while fighting instead of waiting for a
		# permanently empty world when the original regenerates dead Voids.
		var closest: Body
		for body in space.bodies:
			if body.kind != Body.Kind.LOOT or not body.alive: continue
			if closest == null or body.pos.distance_to(space.player.pos) < closest.pos.distance_to(space.player.pos): closest = body
		if closest != null and int(space.stats.get("collected", 0)) < 3:
			var steering: Vector2 = space._steer_towards(space.player, closest.pos)
			return {"yaw": clampf(steering.x * 2.0, -1.0, 1.0), "pitch": clampf(steering.y * 2.0, -1.0, 1.0)}
	return super.pilot(reference)

## Use already-earned EMP rounds against a close pursuer, rather than
## either clearing the whole sector or flying straight under continuous
## fire. This returns ordinary steering/secondary input, never a stun call.
func defensive_emp_input(space) -> Dictionary:
	var bomb: Dictionary = {}
	for weapon in space.player.weapons:
		if weapon.kind == "emp" and int(weapon.count) > 0: bomb = weapon; break
	if bomb.is_empty(): return {}
	var enemy: Body
	for body in space.hostiles():
		if body.disabled or not body.visible or not body.combat_active or body.ai.get("target") != space.player: continue
		if body.pos.distance_to(space.player.pos) > 16000: continue
		if enemy == null or body.pos.distance_to(space.player.pos) < enemy.pos.distance_to(space.player.pos): enemy = body
	if enemy == null: return {}
	var distance: float = enemy.pos.distance_to(space.player.pos)
	var speed: float = float(bomb.speed) + space.player.speed
	var aim: Vector3 = enemy.pos + enemy.forward() * enemy.speed * distance / maxf(speed, 1.0)
	var stick: Vector2 = space._steer_towards(space.player, aim)
	var in_flight := false
	for projectile in space.projectiles:
		if projectile.owner == space.player and projectile.weapon.kind == "emp": in_flight = true
	var aligned: bool = space.player.forward().dot((aim - space.player.pos).normalized()) > 0.995
	return {"yaw": clampf(stick.x * 2.0, -1.0, 1.0), "pitch": clampf(stick.y * 2.0, -1.0, 1.0),
		"secondary": aligned and not in_flight and distance < float(bomb.life) * speed * 0.8}

func observe() -> void:
	await super.observe()
	if app.screen is Flight:
		var space = app.screen.space
		if space.story != null and space.story.stage == 1 and app.game.session.story_step == 24: await shot("wormhole_hidden_cinematic")
		if space.wormhole != null and space.wormhole.visible and space.story != null and space.story.controls_locked:
			await shot("wormhole_revealed_cinematic")
			if not app.screen.view.camera.is_position_behind(space.wormhole.pos * app.screen.view.UNIT):
				await shot("wormhole_visible_approach")
		if space.in_void: await shot("earned_void_arrival")

func void_salvage_checkpoint() -> void:
	seen_screen = app.screen.get_instance_id()
	check(FileAccess.get_sha256(source) == "924468065466180d7f4cef4ff8070852f288d5c58d72e99305c0f33cd654fd9d",
		"wormhole replay uses the retained genuine E24 pre-battle lineage")
	if failures > 0: return
	await fit_available_shield()
	# Keep the earned long-range weapon. A higher paper damage rate alone
	# is not a reason for this pilot to spend its money on a short-range gun.
	if failures > 0: return
	var credits: int = app.game.session.credits
	var jobs: int = app.game.session.stat("jobs")
	var ammo := emp_ammo()
	for trip in 20:
		var next := next_route_station(48)
		if next < 0: return
		if next == app.game.session.station_id:
			if not press(app.screen.launch_button, "Depart for genuine salvage and wormhole flight"): return
			await frames(3)
		elif not await choose_destination(next): return
		for tick in 30000:
			frame += 1
			await observe()
			await clear_dialogue()
			if failures > 0: return
			if app.screen is Station: break
			if app.screen is Flight and app.screen.defeated:
				await shot("wormhole_run_defeat")
				check(false, "survive the earned wormhole flight")
				return
			if app.game.session.in_void and app.game.session.story_step == 26:
				check(crossing_count == 1 and saw_void, "one actual portal crossing and real ten-second Void arrival earn the next result")
				check(app.game.session.credits == credits and app.game.session.stat("jobs") == jobs and emp_ammo() <= ammo,
					"portal arrival invents no money, freelance reward or EMP ammunition")
				await preserve_void_checkpoint()
				return
			await frames(1)
		if not app.screen is Station:
			check(false, "earned portal reaches the next checkpoint within its bounded flight")
			return
	check(false, "actual route reaches station forty-eight within bounded trips")

func preserve_void_checkpoint() -> void:
	var flight = app.screen
	flight.set_paused(true)
	var checkpoint := app.save_summary(app.AUTOSAVE_SLOT)
	check(checkpoint.get("in_void", false) and int(checkpoint.get("story_step", -1)) == 26,
		"native post-result autosave retains the earned Void world and next mission")
	check(int(checkpoint.ship.hull) <= int(app.game.session.ship_stats().max_hull),
		"earned autosave contains bounded real durability, not cinematic invulnerability")
	await shot("earned_void_result_checkpoint")
	check(DirAccess.copy_absolute(app.save_path(app.AUTOSAVE_SLOT), app.save_path(0)) == OK,
		"retain the native earned autosave verbatim as the isolated manual checkpoint")
	check(FileAccess.get_sha256(app.save_path(0)) == FileAccess.get_sha256(app.save_path(app.AUTOSAVE_SLOT)),
		"retained manual and autosave checkpoint bytes are identical")
	var attempts := app.save_attempts.size()
	app.show_title()
	await frames(3)
	app.screen._load()
	await frames(2)
	var box = app.screen.panel_holder.get_child(0).get_child(0)
	if not press(box.get_child(1), "title reload genuine Void checkpoint"): return
	await frames(3)
	check(app.screen is Flight and app.game.session.in_void and app.game.session.story_step == 26,
		"real title reload resumes the earned Void flight instead of falsely docking")
	check(app.save_attempts.size() == attempts and app.game.session.ship == checkpoint.ship
		and app.game.session.cargo == checkpoint.cargo and app.game.session.markets == checkpoint.markets,
		"Void reload neither resaves nor heals, replaces cargo or rolls station inventory")
	check(not app.game.can_sell_cargo(131), "earned mission remains stay protected after Void reload")
	checkpoint_reloaded = failures == 0
	if app.screen is Flight: app.screen.set_paused(true)
	await shot("earned_void_checkpoint_reload")

func finish() -> void:
	if app != null:
		var file := FileAccess.open(out.path_join("wormhole-events.json"), FileAccess.WRITE)
		if file != null:
			file.store_string(JSON.stringify({"events": portal_events, "crossings": crossing_count,
				"saw_void": saw_void, "checkpoint_reloaded": checkpoint_reloaded}, "\t"))
	await super.finish()
