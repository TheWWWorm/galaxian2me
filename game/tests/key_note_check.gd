extends SceneTree
## Game lines that name the phone's keys carry a note of what to press here;
## lines that name none carry nothing.
const Host := preload("res://tests/support/isolated_app.gd")
const Help := preload("res://src/screens/help_panel.gd")
const Prefs := preload("res://src/presentation/preferences.gd")
var checks := 0
var failures := 0

func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	app.settings.set_value("controls", "touch", "off")
	check(Help.key_note(app, "Destroy all pirate ships.").is_empty(), "a line without keys has no note")
	var n := Help.key_note(app, "Press ‘9’ to activate the autopilot. Press 'Fire' to shoot.")
	check(n.contains("'9': " + Prefs.key_name("autopilot")) and n.contains("'Fire': " + Prefs.key_name("fire")), "the autopilot and fire keys are named (%s)" % n)
	n = Help.key_note(app, "Control the ship with the directional keys or 2, 4, 6 and 8.")
	check(n.contains("steer:") and n.contains("left stick"), "steering names the keys and the stick")
	n = Help.key_note(app, "Press the right softbutton to bring up the action menu.")
	check(n.contains(Prefs.key_name("action_menu")), "the right softbutton is the action-menu key")
	app.settings.set_value("controls", "touch", "on")
	n = Help.key_note(app, "Press ‘9’ to activate the autopilot.")
	check(n.contains("Autopilot") and not n.contains(Prefs.key_name("autopilot") + " ·"), "on touch it names the on-screen button")
	# In flight the radio box grows to show a long line whole, with its note,
	# and the readouts under it follow its lower edge.
	if app.library != null:
		app.settings.set_value("controls", "touch", "off")
		var g = app._make_game()
		g.new_game()
		g.session.story_step = maxi(g.session.story_step, 20)
		g.session.story_mission = {}
		app.game = g
		app.show_flight()
		for i in 5: await process_frame
		var hud = app.screen.hud
		var short: Rect2 = hud._radio_rect(hud.size, {"text": "Hello."})
		var long_text: String = app.library.text(890)
		var tall: Rect2 = hud._radio_rect(hud.size, {"text": long_text})
		var width: float = hud._radio_text_width(tall)
		var needed: float = 46.0 + 18.0 * hud._wrap(long_text, width, 14).size()
		check(tall.size.y > short.size.y and tall.size.y >= needed, "a long line gets a taller box (%d > %d)" % [tall.size.y, short.size.y])
		app.screen.space.radio = {"speaker": 0, "name": "Test", "text": long_text}
		app.screen.space.radio_until = app.screen.space.clock + 100000
		hud.queue_redraw()
		await process_frame
		await process_frame
		check(is_equal_approx(hud.radio_bottom, tall.end.y) and hud.alarm_top() > tall.end.y, "the readouts below keep clear of it")
	app.queue_free()
	await process_frame
	print("KEY NOTE: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
