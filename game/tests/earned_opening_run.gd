extends SceneTree
## Earn the opening, the mining tutorial and the first tradable checkpoint.
## Uses native controls/projectiles/mining/docking; never assigns a campaign
## cursor, mission completion, cargo, credits, ship position or enemy damage.
## Optional output stores real JSON saves under that check's own directory.
## godot --headless --path game --fixed-fps 60 -s res://tests/smoke.gd -- <out-dir>

const TestApp := preload("res://tests/support/isolated_app.gd")
const Body := preload("res://src/flight/body.gd")
const Dialogue := preload("res://src/screens/dialogue_panel.gd")
const Flight := preload("res://src/screens/flight_screen.gd")
const Station := preload("res://src/screens/station_screen.gd")

var app: TestApp
var checks: Array = []
var failures := 0
var out := ""
var frame := 0
var timeline: Array = []
var pilot_rock: Body
var seen_screen := 0
var seen_step := -1
var captured := {}
var shots := 0
var last_shots := 0
var first_station := false
var first_autosave := {}
var save_root := ""
var focus_resumes := 0
var mining_departures: Array[int] = []
var mined_before_second := -1
var second_return_cargo := {}
var player_hits: Array = []

## Autosave, three manual slots, Import save… (not on the web) and Back.
var LOAD_ROWS := 5 + (0 if OS.has_feature("web") else 1)

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty(): out = args[0]
	_run.call_deferred()

func check(ok: bool, label: String) -> void:
	checks.append({"test": label, "passed": ok})
	print("PASS: " if ok else "FAIL: ", label)
	if not ok: failures += 1

func frames(count: int) -> void:
	for i in count:
		await physics_frame
		await process_frame

func shot(name: String) -> void:
	if captured.has(name) or out.is_empty() or DisplayServer.get_name() == "headless": return
	captured[name] = true
	await RenderingServer.frame_post_draw
	check(root.get_texture().get_image().save_png(out.path_join(name + ".png")) == OK, "capture " + name)

func dialogue(screen: Node) -> Dialogue:
	for child in screen.get_children():
		if child is Dialogue and not child.is_queued_for_deletion(): return child
	return null

func snapshot() -> Dictionary:
	return JSON.parse_string(JSON.stringify(app.game.session.to_dict()))

func saved_state(slot: int) -> Dictionary:
	var d := app.save_summary(slot)
	d.erase("saved_at")
	return d

func trace_flight_node(node: Node) -> void:
	if node is Flight:
		node.ready.connect(trace_flight_ready.bind(weakref(node)), CONNECT_ONE_SHOT)

func trace_flight_ready(reference: WeakRef) -> void:
	var flight = reference.get_ref()
	if flight != null: flight.space.event.connect(trace_flight_event.bind(reference))

func trace_flight_event(kind: String, data: Dictionary, reference: WeakRef) -> void:
	if kind != "hit": return
	var flight = reference.get_ref()
	if flight == null: return
	var space = flight.space
	var hit := {"step": flight.game.session.story_step, "clock": space.clock,
		"position": str(space.player.pos), "from": str(data.get("from", Vector3.ZERO)),
		"hull": space.player.hull, "armor": space.player.armor,
		"mining": space.mining_target != null, "asteroids": []}
	for body in space.bodies:
		if body.kind == Body.Kind.ASTEROID and body.pos.distance_to(space.player.pos) < 6000:
			hit.asteroids.append({"alive": body.alive, "distance": body.pos.distance_to(space.player.pos), "size": body.size})
	player_hits.append(hit)
	print("PLAYER HIT ", JSON.stringify(hit))

## The pilot only returns the same controls as a player. The weak binding
## cannot keep a discarded flight screen/world alive after docking.
var opening_target: WeakRef

func pilot(reference: WeakRef) -> Dictionary:
	var flight = reference.get_ref()
	if flight == null: return {}
	var space = flight.space
	if space.story != null and space.story.controls_locked: return {}
	if space.mining != null:
		var drill: float = space.mining.drill
		return {"yaw": -1.0 if drill > 1.0 else (1.0 if drill < -1.0 else 0.0)}
	if space.mining_target != null: return {}
	var step: int = app.game.session.story_step
	if step == 0:
		var enemy: Body = opening_target.get_ref() if opening_target != null else null
		var nearest: Body
		for b in space.hostiles():
			if not b.visible or b.friendly or b.ai.get("mode", "") == "hold": continue
			if nearest == null or b.pos.distance_to(space.player.pos) < nearest.pos.distance_to(space.player.pos): nearest = b
		if enemy == null or not enemy.alive or not enemy.visible or enemy.friendly:
			enemy = nearest
		elif nearest != null and enemy.pos.distance_to(space.player.pos) > 12000.0 and nearest.pos.distance_to(space.player.pos) < enemy.pos.distance_to(space.player.pos) * 0.6:
			enemy = nearest
		opening_target = weakref(enemy) if enemy != null else null
		if enemy == null: return {}
		var distance: float = enemy.pos.distance_to(space.player.pos)
		var speed := 16.0
		var reach := 30000.0
		if not space.player.weapons.is_empty():
			speed = float(space.player.weapons[0].speed) + space.player.speed
			reach = float(space.player.weapons[0].life) * speed
		var aim: Vector3 = enemy.pos + enemy.forward() * enemy.speed * distance / maxf(1.0, speed)
		var steer: Vector2 = space._steer_towards(space.player, aim)
		# Holding the normal primary trigger and committing to a target avoids
		# a robot-only stalemate. No weapon stats or enemy health are changed.
		return {"yaw": clampf(steer.x * 2.0, -1.0, 1.0), "pitch": clampf(steer.y * 2.0, -1.0, 1.0), "fire": distance < reach}
	if step in [2, 4]:
		if pilot_rock == null or not pilot_rock.alive or pilot_rock.ore < 0:
			pilot_rock = null
			for b in space.bodies:
				if b.kind != Body.Kind.ASTEROID or not b.alive or b.ore < 0 or space._inside_station(b.pos): continue
				if pilot_rock == null or b.pos.distance_to(space.player.pos) < pilot_rock.pos.distance_to(space.player.pos): pilot_rock = b
		if pilot_rock == null: return {}
		var steer: Vector2 = space._steer_towards(space.player, pilot_rock.pos)
		return {"yaw": steer.x, "pitch": steer.y,
			"fire_pressed": space.target == pilot_rock and space.locked and space.mining_target == null}
	# After each mining goal the real campaign requests a return to station.
	if step in [3, 5]:
		var steer: Vector2 = space._steer_towards(space.player, space.station.pos)
		return {"yaw": steer.x, "pitch": steer.y,
			"fire_pressed": space.target == space.station and space.locked and not space.autopilot}
	return {}

func _run() -> void:
	root.size = Vector2i(1280, 800)
	app = TestApp.new()
	node_added.connect(trace_flight_node)
	if not out.is_empty():
		DirAccess.make_dir_recursive_absolute(out)
		# A new directory per invocation prevents stale checkpoints passing a run.
		save_root = out.path_join("test-saves-%d" % Time.get_ticks_usec())
		app.disk_saves = save_root
	root.add_child(app)
	await frames(3)
	if app.library == null:
		check(false, "a supplied JAR must be imported before this check")
		await finish()
		return
	print("CONTENT ", app.library.id)
	for record in app.library.data.campaign.steps:
		if int(record.step) < 8: print("PROGRESSION ", JSON.stringify(record))
	await shot("title")
	app.screen._new_game()
	await frames(3)
	check(app.screen is Flight and app.game.session.story_step == 0, "new game starts in the opening flight")
	check(app.save_attempts.is_empty(), "new game does not overwrite a docking checkpoint")
	var reached_trade := false
	for tick in 48000:
		frame = tick
		var screen = app.screen
		var step: int = app.game.session.story_step
		if step != seen_step:
			if step == 5: second_return_cargo = app.game.session.cargo.duplicate(true)
			timeline.append({"frame": frame, "step": step, "station": app.game.session.station_id,
				"credits": app.game.session.credits, "cargo": app.game.session.cargo.duplicate(true)})
			print("EARNED ", JSON.stringify(timeline.back()))
			seen_step = step
		if screen.get_instance_id() != seen_screen:
			seen_screen = screen.get_instance_id()
			pilot_rock = null
			if screen is Flight:
				screen.controls.scripted = pilot.bind(weakref(screen))
				last_shots = 0
				if step in [2, 4]:
					mining_departures.append(step)
					if step == 4: mined_before_second = app.game.session.stat("ore_mined")
				if step == 2:
					check(not app.game.campaign.dialogue(step, 0).is_empty() and screen.conversation != null,
						"first mining flight shows its imported tutorial briefing")
			elif screen is Station:
				print("DOCKED ", step, " cargo=", app.game.session.cargo, " autosaves=", app.save_attempts)
		var talk := dialogue(screen)
		if talk != null:
			await shot("dialogue_step%d" % step)
			talk.next_button.pressed.emit()
			await frames(1)
			continue
		if screen is Flight:
			# A desktop check may lose focus while the owner keeps working.
			# Resume through the actual button, never disable the game's focus
			# protection or release conversation/defeat locks directly.
			if screen.menu_paused and screen.hud.pause_panel != null:
				screen.hud.pause_panel.get_child(0).get_child(0).pressed.emit()
				focus_resumes += 1
			shots += maxi(0, screen.space.shots_fired - last_shots)
			last_shots = screen.space.shots_fired
			if screen.space.story != null and not screen.space.story.message().is_empty():
				await shot("radio_step%d" % step)
				screen._next_radio()
			if screen.space.mining != null: await shot("mining_step%d" % step)
			if step == 0 and screen.space.story.stage == 7: await shot("opening_combat")
			if tick % 1800 == 0:
				print("FLIGHT frame=", tick, " step=", step, " paused=", screen.paused,
					" clock=", screen.space.clock, " pos=", screen.space.player.pos,
					" story_stage=", screen.space.story.stage if screen.space.story != null else -1,
					" radio=", screen.space.story.current if screen.space.story != null else -1,
					" mined=", app.game.session.stat("ore_mined"), " shots=", shots)
			if screen.defeated:
				check(false, "earned run survives its native flight and mining")
				break
		elif screen is Station:
			if step == 4:
				check(app.game.session.cargo_used() == 0, "Gunant takes the first haul before the second mining departure")
			if not first_station:
				first_station = true
				check(step == 2 and app.game.session.station_id == 78, "opening and rescue earn the first station at step 2")
				check(app.game.session.ship.index == 0 and app.game.session.flags.get("step1_ship", false), "rescue awards the mining ship")
				first_autosave = saved_state(app.AUTOSAVE_SLOT)
				check(int(first_autosave.get("story_step", -1)) == 2, "docking autosaves after the campaign advances")
				check(app.save_attempts == [app.AUTOSAVE_SLOT], "first earned docking saves exactly once")
				screen._open_section(2)
				check(screen.current_panel == null, "early map stays story-locked")
				check(screen.launch_button.visible and not screen.launch_button.disabled, "Launch is available despite the early map lock")
				await shot("first_station")
			if step >= 5:
				reached_trade = true
				break
			if not step in [2, 4]:
				check(false, "unexpected docked campaign step %d" % step)
				break
			screen.launch_button.pressed.emit()
		await frames(1)
	check(reached_trade, "native mining and docking reach the unlocked hangar")
	if reached_trade:
		check(shots > 0 and app.game.session.stat("kills") > 0, "opening combat uses player projectiles and credits real kills")
		check(mining_departures == [2, 4], "both distinct mining flights depart through the real station control")
		var full_hold := 0
		for count in second_return_cargo.values(): full_hold += int(count)
		# The supplied goal measures total cargo, including a found core or
		# salvaged ore. Requiring 25 pure ore rejects a legitimate full hold.
		check(mined_before_second >= 10 and app.game.session.stat("ore_mined") > mined_before_second and full_hold == 25,
			"second mining flight earns a new full 25-ton hold after the first handover")
		check(app.game.session.story_step == 6 and app.game.session.cargo_used() == 0,
			"Gunant takes the second haul at the earned equipment checkpoint")
		await trade_and_saves()
	else:
		await shot("failure")
	await finish()

func trade_and_saves() -> void:
	var station = app.screen
	var g = app.game
	var auto_before := saved_state(app.AUTOSAVE_SLOT)
	station._open_section(0)
	await frames(3)
	check(station.current_panel is TabContainer, "earned hangar opens through the station menu")
	if not station.current_panel is TabContainer: return
	var shop = station.current_panel.get_child(0)
	# The original takes both tutorial hauls. Exercise the real starter shelf,
	# not an invented sale of Gunant's ore. Its initial items can be free.
	var item := -1
	for entry in g.shelf():
		if int(entry.count) > 0 and g.price_here(int(entry.id)) <= g.session.credits:
			item = int(entry.id)
			break
	check(item >= 0, "actual starter shelf offers an affordable tutorial item")
	if item < 0: return
	var before_credits: int = g.session.credits
	var before_count: int = g.session.cargo_count(item)
	var price: int = g.price_here(item)
	shop._select(item, 0)
	await frames(2)
	shop.detail.get_child(shop.detail.get_child_count() - 1).pressed.emit()
	await frames(2)
	check(g.session.credits == before_credits - price and g.session.cargo_count(item) == before_count + 1,
		"shop Buy obtains the supplied starter item at its actual price")
	shop._select(item, 1)
	await frames(2)
	shop.detail.get_child(shop.detail.get_child_count() - 1).pressed.emit()
	await frames(2)
	check(g.session.credits == before_credits and g.session.cargo_count(item) == before_count,
		"shop Sell returns the starter item and refunds its actual price")
	await shot("trade")
	check(saved_state(app.AUTOSAVE_SLOT) == auto_before, "trading does not mutate the docking snapshot")
	var traded := snapshot()
	station._open_section(5)
	await frames(2)
	var panel = station.current_panel
	panel._save()
	await frames(2)
	panel.box.get_child(0).pressed.emit()
	# An occupied slot asks before it is overwritten.
	for layer in panel.get_children():
		if layer is CanvasLayer and layer.get_child_count() > 0 and layer.get_child(0).has_method("_answer"): layer.get_child(0)._answer(true)
	await frames(2)
	check(saved_state(0) == traded, "manual Save button persists the earned trade state")
	check(saved_state(app.AUTOSAVE_SLOT) == auto_before, "manual save never overwrites autosave")
	var attempts := app.save_attempts.size()
	app.show_title()
	await frames(3)
	app.screen._load()
	await frames(2)
	var load_box = app.screen.panel_holder.get_child(0).get_child(0)
	check(load_box.get_child_count() == LOAD_ROWS and load_box.get_child(0).text.begins_with("Autosave"), "title load menu exposes autosave plus three manual slots")
	await shot("load_menu")
	load_box.get_child(0).pressed.emit()
	await frames(3)
	check(app.screen is Station and snapshot() == auto_before, "title Autosave restores settled campaign, cargo, credits and market")
	check(app.save_attempts.size() == attempts, "loading does not create another autosave or replay rewards")
	app.screen._open_section(5)
	await frames(2)
	panel = app.screen.current_panel
	panel._load()
	await frames(2)
	check(panel.box.get_child_count() == LOAD_ROWS, "station load menu includes the same four checkpoints")
	panel.box.get_child(1).pressed.emit()
	await frames(3)
	check(snapshot() == traded, "station manual Load restores the earned trade checkpoint")
	check(app.save_attempts.size() == attempts, "manual reload preserves the docking save")
	if not out.is_empty():
		check(FileAccess.file_exists(app.save_path(0)) and FileAccess.file_exists(app.save_path(app.AUTOSAVE_SLOT)), "actual JSON files exist only in the isolated check directory")
		check(not FileAccess.file_exists(app.save_path(0) + ".tmp"), "successful save leaves no temporary file")
	await shot("reloaded_station")

func finish() -> void:
	var content_id: String = app.library.id if app.library != null else ""
	var result := {"content": content_id, "checks": checks, "failures": failures,
		"timeline": timeline, "frames": frame, "player_shots": shots, "save_root": save_root,
		"focus_resumes": focus_resumes, "mining_departures": mining_departures,
		"mined_before_second": mined_before_second, "second_return_cargo": second_return_cargo,
		"player_hits": player_hits}
	if app.game != null: result["final_session"] = snapshot()
	pilot_rock = null
	app.queue_free()
	app = null
	await frames(3)
	print("EARNED OPENING: %d checks, %d failures" % [checks.size(), failures])
	if not out.is_empty():
		var f := FileAccess.open(out.path_join("report.json"), FileAccess.WRITE)
		if f != null: f.store_string(JSON.stringify(result, "\t"))
	quit(1 if failures else 0)
