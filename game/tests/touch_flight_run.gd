extends SceneTree
## Integration check using installed JAR data and real native flight/mining.
## The free-flight setup is a test fixture, not an earned campaign playthrough.
## Screenshots are optional; player saves and settings are never written.
## godot --path game -s res://tests/touch_flight_run.gd -- <out-dir> [hold]

const TestApp := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Body := preload("res://src/flight/body.gd")
const Catalogue := preload("res://src/content/catalogue.gd")
const Controls := preload("res://src/flight/controls.gd")

var app: TestApp
var failures := 0
var checks: Array = []
var out := ""
var hold := false

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty(): out = args[0]
	hold = args.size() > 1 and args[1] == "hold"
	_run.call_deferred()

func check(ok: bool, label: String) -> void:
	checks.append({"test": label, "passed": ok})
	print("PASS: " if ok else "FAIL: ", label)
	if not ok: failures += 1

func frames(count: int) -> void:
	for i in count:
		await physics_frame
		await process_frame

func touch(index: int, pos: Vector2, down := true) -> void:
	var event := InputEventScreenTouch.new()
	event.index = index
	event.position = pos
	event.pressed = down
	Input.parse_input_event(event)
	Input.flush_buffered_events()

func button_pos(flight, action: String) -> Vector2:
	return flight.touch.buttons[action].get_center()

func tap(flight, action: String) -> void:
	var pos := button_pos(flight, action)
	touch(99, pos)
	touch(99, pos, false)

func shot(name: String) -> void:
	if out.is_empty() or DisplayServer.get_name() == "headless": return
	await RenderingServer.frame_post_draw
	var error := root.get_texture().get_image().save_png(out.path_join(name + ".png"))
	check(error == OK, "capture " + name)

func _fixture() -> void:
	# Use an existing hull, station and equipment; only remove the story lock
	# for this input check. This does not assert campaign progression works.
	app.game = Game.new(app.library, app.catalogue)
	app.game.new_game()
	app.game.session.story_step = 45
	app.game.session.story_mission = {}
	app.game.depart({})
	app.show_flight()

func _run() -> void:
	root.size = Vector2i(1280, 800)
	if not out.is_empty(): DirAccess.make_dir_recursive_absolute(out)
	app = TestApp.new()
	root.add_child(app)
	await frames(3)
	if app.library == null:
		push_error("Import a supplied JAR before running this integration check.")
		quit(2)
		return
	app.screen._options()
	await frames(2)
	await shot("options")
	_fixture()
	await frames(3)
	var flight = app.screen
	check(flight.touch != null and flight.touch.visible, "touch overlay in actual flight")
	check(flight.touch.gameplay_enabled and not flight.paused, "free-flight controls enabled")
	check(flight.hud.touch_layout and not flight.controls.mouse_steer, "HUD and mouse respect touch mode")
	var binding_counts := {}
	for action in Controls.ACTIONS: binding_counts[action] = InputMap.action_get_events(action).size()
	# Avoid the launch corridor while checking free steering and live weapons.
	flight.space.player.pos = Vector3(18000, 12000, 20000)
	var before_basis: Basis = flight.space.player.basis
	var before_shots: int = flight.space.shots_fired
	var stick_pos: Vector2 = flight.touch.stick_center + Vector2(flight.touch.stick_radius * 0.8, 0)
	touch(10, stick_pos)
	touch(20, button_pos(flight, "fire"))
	await frames(25)
	check(not flight.space.player.basis.is_equal_approx(before_basis), "screen-touch events steer the native ship")
	check(flight.space.shots_fired > before_shots, "second finger fires native weapons while steering")
	await shot("flight")
	tap(flight, "pause")
	check(flight.paused and flight.hud.pause_panel != null, "touch Pause opens the pause menu")
	check(flight.touch.fingers.is_empty() and not flight.touch.visible, "pause releases all captured fingers")
	var frozen_clock: int = flight.space.clock
	var frozen_pos: Vector3 = flight.space.player.pos
	await frames(6)
	check(flight.space.clock == frozen_clock and flight.space.player.pos == frozen_pos, "native simulation freezes while paused")
	var pause_rect: Rect2 = flight.hud.pause_panel.get_global_rect()
	check(root.get_visible_rect().encloses(pause_rect), "pause menu stays fully on screen")
	check(pause_rect.get_center().distance_to(root.get_visible_rect().get_center()) < 2.0, "pause menu is centered")
	await shot("paused")
	# Exercise the real Resume button's callback, not a direct bool assignment.
	var resume: Button = flight.hud.pause_panel.get_child(0).get_child(0)
	resume.pressed.emit()
	before_shots = flight.space.shots_fired
	await frames(6)
	check(not flight.paused and flight.touch.visible and flight.space.clock > frozen_clock, "Resume button restores flight and touch controls")
	check(flight.space.shots_fired == before_shots, "held touch fire does not stick after resume")
	touch(10, Vector2.ZERO, false)
	touch(20, Vector2.ZERO, false)
	flight.notification(Node.NOTIFICATION_WM_WINDOW_FOCUS_OUT)
	check(flight.paused and flight.menu_paused, "window focus loss pauses flight")
	flight.set_paused(false)
	flight._conversation([{"speaker": -1, "name": "Input check", "text": app.library.text(20)}])
	flight.set_paused(false)
	check(flight.paused and not flight.touch.visible, "menu resume cannot bypass a conversation lock")
	flight.conversation.finished.emit()
	await frames(2)
	check(not flight.paused and flight.touch.visible, "conversation completion restores touch input")
	tap(flight, "autopilot")
	await frames(1)
	check(flight.space.autopilot, "touch autopilot reaches simulation")
	tap(flight, "autopilot")
	await frames(1)
	check(not flight.space.autopilot, "autopilot is one-shot, not repeatedly toggled")

	# Fit a mining laser from the supplied catalogue and approach a real rock.
	var laser := -1
	for id in app.library.data.items.size():
		if app.catalogue.type(id) == Catalogue.Type.MINING_LASER:
			laser = id
			break
	var rock: Body
	for body in flight.space.bodies:
		if body.kind == Body.Kind.ASTEROID and body.alive and body.ore >= 0:
			rock = body
			break
	check(laser >= 0 and rock != null and not app.game.session.equipment[3].is_empty(), "supplied content provides a mining fixture")
	if laser >= 0 and rock != null and not app.game.session.equipment[3].is_empty():
		app.game.session.equipment[3][0] = {"id": laser, "count": 1}
		var reach: float = 1500.0 * (rock.scale.x + rock.scale.y + rock.scale.z) / 2.0 + flight.space.PLAYER_RADIUS
		flight.space.player.pos = rock.pos - Vector3(0, 0, reach * 0.95)
		flight.space._begin_mining(rock)
		await frames(2)
		check(flight.space.mining != null, "native mining minigame starts")
		if flight.space.mining != null:
			touch(30, stick_pos)
			await frames(10)
			check(flight.space.mining != null and flight.space.mining.steer < 0, "touch stick steers the native mining drill")
			await shot("mining")
			touch(30, Vector2.ZERO, false)
			await frames(2)
			check(flight.space.mining != null and is_zero_approx(flight.space.mining.steer), "releasing stick stops drill input")

	# Re-enter the real opening and wait for an imported radio line.
	var previous_game: WeakRef = weakref(app.game)
	var previous_space: WeakRef = weakref(flight.space)
	app.new_game()
	await frames(3)
	flight = app.screen
	check(previous_game.get_ref() == null, "restarting releases the previous session")
	check(previous_space.get_ref() == null, "restarting releases the previous flight world")
	if flight.conversation != null: flight.conversation.finished.emit()
	await frames(2)
	check(not flight.touch.gameplay_enabled, "opening cinematic hides gameplay controls")
	var radio_budget := 20000
	if flight.space.story != null:
		for record in flight.space.story.records:
			if int(record[2]) == 5:
				radio_budget = maxi(radio_budget, int(record[3]) + 4000)
				break
	for i in mini(4000, int(radio_budget / 16.0) + 60):
		if flight.space.story != null and not flight.space.story.message().is_empty(): break
		await frames(1)
	if flight.space.story != null and flight.space.story.message().is_empty():
		print("Radio timeout: paused=", flight.paused, " clock=", flight.space.story.clock,
			" records=", flight.space.story.records.size(), " first=", flight.space.story.records.slice(0, 1))
	check(flight.space.story != null and not flight.space.story.message().is_empty(), "opening displays a real imported radio line")
	if flight.space.story != null and not flight.space.story.message().is_empty():
		await frames(1)
		check(flight.touch.radio_visible, "Next radio is available during the cinematic")
		await shot("radio")
		var previous: int = flight.space.story.current
		tap(flight, "radio")
		check(flight.space.story.current != previous, "touch advances the imported radio line")
	for action in binding_counts:
		check(InputMap.action_get_events(action).size() == binding_counts[action], "bindings stable after flight rebuild: " + action)
	var previous_story: WeakRef = weakref(flight.space.story)
	previous_space = weakref(flight.space)
	previous_game = weakref(app.game)
	_fixture()
	await frames(3)
	flight = app.screen
	check(previous_story.get_ref() == null, "leaving a cinematic releases its story")
	check(previous_space.get_ref() == null and previous_game.get_ref() == null, "leaving a cinematic releases its world and session")
	flight.set_physics_process(false)
	await shot("final_flight")
	if hold and DisplayServer.get_name() != "headless": await create_timer(60.0).timeout
	var content_id: String = app.library.id
	previous_space = weakref(flight.space)
	previous_game = weakref(app.game)
	var previous_library: WeakRef = weakref(app.library)
	app.queue_free()
	app = null
	flight = null
	await frames(3)
	check(previous_space.get_ref() == null and previous_game.get_ref() == null, "closing the app releases its world and session")
	check(previous_library.get_ref() == null, "closing the app releases the content resource cache")
	print("TOUCH FLIGHT: %d checks, %d failures" % [checks.size(), failures])
	if not out.is_empty():
		var report := FileAccess.open(out.path_join("report.json"), FileAccess.WRITE)
		if report != null:
			report.store_string(JSON.stringify({"content": content_id, "checks": checks, "failures": failures}, "\t"))
	quit(1 if failures else 0)
