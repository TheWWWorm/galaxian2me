extends SceneTree
## Touch set to Auto: a key or a pad puts the on-screen controls away and
## the HUD back in its desktop layout; a touch brings them back. Mouse
## events a touch generates and slight stick drift change nothing.
const Host := preload("res://tests/support/isolated_app.gd")
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
	if app.library == null:
		print("SKIP: no supplied content"); app.queue_free(); await process_frame; quit(2); return
	app.settings.set_value("controls", "touch", "on")
	var g = app._make_game()
	g.new_game()
	g.session.story_step = 20
	g.session.story_mission = {}
	app.game = g
	app.show_flight()
	for i in 4: await process_frame
	var fs = app.screen
	if fs.conversation != null: fs.conversation.queue_free(); fs.conversation = null
	fs.set_paused(false)
	app.settings.set_value("controls", "touch", "auto")
	check(fs.touch.visible and fs.hud.touch_layout, "the touch controls start out shown")
	var drift := InputEventJoypadMotion.new(); drift.axis = JOY_AXIS_LEFT_X; drift.axis_value = 0.2
	fs._input(drift)
	var ghost := InputEventMouseButton.new(); ghost.pressed = true; ghost.device = InputEvent.DEVICE_ID_EMULATION
	fs._input(ghost)
	check(fs.touch.visible, "stick drift and a touch's own mouse events leave them")
	var key := InputEventKey.new(); key.pressed = true; key.keycode = KEY_W
	fs._input(key)
	check(not fs.touch.visible and not fs.hud.touch_layout and fs.hud.touch == null, "a key puts them away and the HUD takes its desktop layout")
	check(fs.controls.mouse_steer == bool(app.setting("controls", "mouse", true)), "and the mouse steers again")
	var tap := InputEventScreenTouch.new(); tap.pressed = true
	fs._input(tap)
	check(fs.touch.visible and fs.hud.touch_layout and not fs.controls.mouse_steer, "a touch brings them back")
	var pad := InputEventJoypadButton.new(); pad.pressed = true; pad.button_index = JOY_BUTTON_A
	fs._input(pad)
	check(not fs.touch.visible, "so does a pad button put them away")
	fs.set_paused(true); fs.set_paused(false)
	check(not fs.touch.visible, "and a pause does not bring them back")
	fs._input(tap)
	app.settings.set_value("controls", "touch", "on")
	fs._input(key)
	check(fs.touch.visible, "set to On, they stay whatever is pressed")
	app.queue_free()
	await process_frame
	print("TOUCH AUTO: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
