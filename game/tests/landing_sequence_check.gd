extends SceneTree
## Memory-only presentation/transaction boundaries using supplied assets.
## The one-unit purchase and damaged hull below are explicit test fixtures,
## not earned campaign progress, and are never written to player saves.

const Host := preload("res://tests/support/isolated_app.gd")
const Landing := preload("res://src/screens/landing_screen.gd")
const Station := preload("res://src/screens/station_screen.gd")
const CameraPath := preload("res://src/presentation/camera_path.gd")
var app
var checks := 0
var failures := 0

func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)
func state() -> String: return JSON.stringify(app.game.session.to_dict())
func frames() -> void:
	await process_frame
	await process_frame

func dock_fixture():
	app.game = app._make_game()
	var g = app.game
	g.new_game()
	g.session.story_step = 20
	g.session.story_mission = {}
	g.pending_dialogue.clear()
	g.session.add_cargo(149, 1)
	g.session.job = {"kind": 8, "item": 149, "count": 1, "reward": 123,
		"station": g.session.station_id, "client": "Memory fixture"}
	app.show_flight()
	var flight = app.screen
	flight.set_physics_process(false)
	flight.set_process(false)
	flight.space.player.hull = 1
	flight.space.player.armor = 0
	flight.space.player.shield = 0
	app.save_attempts.clear()
	var credits: int = g.session.credits
	flight.space.docking = flight.Space.DOCKING_TIME
	flight.space._fly_player(0.016, 16, {})
	check(flight.space.completed_flight, "physical docking retires flight before presentation")
	check(g.session.job.is_empty() and g.session.credits == credits + 123 and g.session.cargo_count(149) == 0,
		"physical docking settles a purchase exactly once before presentation")
	check(g.session.ship.hull == g.session.ship_stats().max_hull and g.session.ship.shield == g.session.ship_stats().shield,
		"dock repair is complete before presentation")
	check(app.save_attempts == [app.AUTOSAVE_SLOT] and int(app.save_summary(app.AUTOSAVE_SLOT).credits) == credits + 123,
		"one autosave contains the settled reward before presentation")
	return app.screen

func run() -> void:
	app = Host.new()
	root.add_child(app)
	await frames()
	check(app.library != null, "supplied content available")
	if app.library == null: quit(2); return
	# Structural table lookup must work across independently obfuscated builds.
	for content_id in app.Library.installed():
		if not app.activate(str(content_id)): continue
		for faction in [0, 1, 2]:
			check(Landing.LandingView.supported(app.library, faction, 5), "supplied entry assets resolve: %s faction %d" % [content_id.substr(0, 8), faction])
		var path = Landing.LandingView.landing_path(app.library)
		if path != null:
			check(path.sample(6000.0, false).transform.origin.is_equal_approx(Vector3(10, 10, -70)),
				"retained six-second position is read from this JAR")
			var expected := Basis.from_euler(Vector3(-256, 1848, 0) * TAU / 4096.0, EULER_ORDER_YXZ)
			check(path.sample(6000.0, false).transform.basis.is_equal_approx(expected), "landing camera applies supplied YXZ rotation order")
	check(not CameraPath.new([0, 0, 0]).valid(), "truncated camera data is rejected")
	check(not CameraPath.new([0,0,0,0,0,0,0,1000, 0,0,0,0,0,0,0,1000]).valid(), "repeated camera times are rejected")
	check(not CameraPath.new([0,0,0,0,0,0,0,1000, 1000,NAN,0,0,0,0,0,1000]).valid(), "non-finite camera data is rejected")
	var finite := CameraPath.new([0,0,0,0,0,0,0,1000, 1000,100,0,0,0,0,0,1000])
	check(finite.sample(2000.0, false).transform.origin == Vector3(1,0,0), "finite playback holds at the last key without wrapping")
	var landing = dock_fixture()
	check(landing is Landing, "station entry is on by default without a saved preference")
	if landing is Landing:
		landing.set_process(false)
		var settled := state()
		var key := InputEventKey.new()
		key.keycode = KEY_SPACE
		key.pressed = true
		landing._unhandled_input(key)
		check(app.screen == landing, "the arrival frame ignores the preceding docking input")
		landing._process(0.5)
		key.echo = true
		landing._unhandled_input(key)
		check(app.screen == landing, "a held key cannot skip the sequence")
		key.echo = false
		landing._unhandled_input(key)
		landing.finish()
		await frames()
		check(app.screen is Station and state() == settled and app.save_attempts.size() == 1,
			"key skip and a repeated completion preserve rewards, repairs and the single save")
		check(app.screen.conversation != null, "station UI presents the dock debrief after skipping")
	# Separate finite playback, mouse/touch and controller paths.
	for kind in ["natural", "mouse", "touch", "gamepad", "button"]:
		landing = dock_fixture()
		if not landing is Landing: check(false, "entry available: " + kind); continue
		landing.set_process(false)
		var settled := state()
		landing._process(0.5)
		match kind:
			"natural": landing._process(10.0)
			"mouse":
				var event := InputEventMouseButton.new()
				event.button_index = MOUSE_BUTTON_LEFT; event.pressed = true
				landing._unhandled_input(event)
			"touch":
				var event := InputEventScreenTouch.new()
				event.pressed = true
				landing._unhandled_input(event)
			"gamepad":
				var event := InputEventJoypadButton.new()
				event.button_index = JOY_BUTTON_A; event.pressed = true
				landing._unhandled_input(event)
			"button": landing.skip_button.pressed.emit()
		await frames()
		check(app.screen is Station and state() == settled and app.save_attempts.size() == 1,
			"completion opens station without repeating transactions: " + kind)
	# Drive the viewport input dispatch, including touch's emulated click.
	# No debrief covers the station's Depart button in this boundary.
	landing = dock_fixture()
	if landing is Landing:
		landing.set_process(false)
		landing._process(0.5)
		app.game.pending_dialogue.clear()
		app.game.new_medals.clear()
		await frames()
		var settled := state()
		var touch := InputEventScreenTouch.new()
		touch.position = landing.skip_button.get_global_rect().get_center()
		touch.pressed = true
		Input.parse_input_event(touch)
		Input.flush_buffered_events()
		var click := InputEventMouseButton.new()
		click.position = touch.position
		click.global_position = touch.position
		click.device = InputEvent.DEVICE_ID_EMULATION
		click.button_index = MOUSE_BUTTON_LEFT
		click.pressed = true
		Input.parse_input_event(click)
		Input.flush_buffered_events()
		await frames()
		touch.pressed = false
		Input.parse_input_event(touch)
		click.pressed = false
		Input.parse_input_event(click)
		Input.flush_buffered_events()
		await frames()
		check(app.screen is Station and state() == settled and app.save_attempts.size() == 1,
			"touch plus its emulated mouse click cannot activate the newly opened station")
	# A queued skip must not override a newer navigation request.
	landing = dock_fixture()
	if landing is Landing:
		landing.finish()
		app.show_title()
		var title = app.screen
		await frames()
		check(app.screen == title, "a retired sequence cannot reopen the station")
	app.set_setting("interface", "landing_sequence", false)
	check(dock_fixture() is Station, "disabled entry goes straight to the station")
	await frames()
	app.set_setting("interface", "landing_sequence", true)
	var settled := state()
	app.show_station()
	check(app.screen is Station and state() == settled and app.save_attempts.size() == 1,
		"generic Continue/load screen never replays entry or docking")
	await frames()
	var constants: Dictionary = app.library.data.constants
	app.library.data.constants = {}
	app.library._found.clear()
	check(not Landing.supported(app), "a JAR without camera or hangar data cannot play an invented sequence")
	# Restore hangar tables but leave the camera track absent, as a partial JAR.
	app.library.data.constants = constants.duplicate(true)
	for key in app.library.data.constants.keys():
		if key.ends_with(":[[I") and app.library.data.constants[key].size() == 2:
			app.library.data.constants.erase(key)
	app.library._found.clear()
	app.show_docked_station()
	check(app.screen is Station and app.screen.toast.text == "Station-entry animation is unavailable for this JAR.",
		"missing camera reports unsupported entry and keeps the station usable")
	app.library.data.constants = constants
	app.library._found.clear()
	await frames()
	check(app.disk_saves.is_empty(), "all docking saves remain in the isolated memory host")
	app.queue_free()
	await frames()
	print("LANDING SEQUENCE: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
