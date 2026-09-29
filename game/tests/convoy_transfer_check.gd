extends SceneTree
## Synthetic objective-completion fixture, NOT an earned save. The separate
## earned-travel run must prove native battle completion. All saves are memory.
const TestApp := preload("res://tests/support/isolated_app.gd")
const Flight := preload("res://src/screens/flight_screen.gd")
const Station := preload("res://src/screens/station_screen.gd")
var app: TestApp
var checks := 0
var failures := 0

func _init() -> void:
	run.call_deferred()

func check(ok: bool, text: String) -> void:
	checks += 1
	print("PASS: " if ok else "FAIL: ", text)
	if not ok: failures += 1

func frames(n: int) -> void:
	for i in n:
		await physics_frame
		await process_frame

func dismiss_flight_lines() -> void:
	for i in 100:
		if not app.screen is Flight or app.screen.conversation == null: return
		app.screen.conversation.next_button.pressed.emit()
		await frames(1)
	check(false, "bounded result dialogue")

func run() -> void:
	app = TestApp.new()
	root.add_child(app)
	await frames(2)
	if app.library == null:
		check(false, "supplied content installed")
	else:
		app.game = app._make_game()
		app.game.new_game()
		# Fixture only: construct the real convoy scene, then satisfy its
		# objective to isolate the result UI and arrival transaction boundary.
		app.game.session.story_step = 13
		app.game.campaign.advance()
		app.game.arrive(79)
		app.show_flight()
		await frames(2)
		await dismiss_flight_lines()
		app.game.session.story_mission.done = true
		for i in 90:
			await frames(1)
			if app.screen is Flight and app.screen.conversation != null: break
		check(app.game.session.story_step == 14 and app.screen is Flight
			and app.screen.conversation != null, "earned-objective fixture opens the convoy debrief before transfer")
		check(app.game.session.station_id == 79 and app.save_attempts.is_empty(),
			"result waits for the player; it neither moves nor autosaves early")
		var jumps: int = app.game.session.stat("jumpgates")
		await dismiss_flight_lines()
		check(app.screen is Station and app.game.session.station_id == 98,
			"finishing the convoy debrief transfers to its supplied destination station")
		check(app.game.session.story_step == 16, "automatic arrival earns the next mission normally")
		check(app.save_attempts == [app.AUTOSAVE_SLOT], "completed transfer creates exactly one settled docking autosave")
		check(app.game.session.stat("jumpgates") == jumps, "scripted transport is not a fabricated jump-gate trip")
		if app.screen is Station and app.game.session.station_id == 98:
			var state = JSON.parse_string(JSON.stringify(app.game.session.to_dict()))
			app.save_game(0)
			var attempts := app.save_attempts.size()
			check(app.load_game(0).is_empty(), "post-transfer checkpoint reloads")
			check(JSON.parse_string(JSON.stringify(app.game.session.to_dict())) == state and app.save_attempts.size() == attempts,
				"reload does not repeat transport, progression, rewards or autosave")
	app.queue_free()
	await frames(3)
	print("CONVOY TRANSFER: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
