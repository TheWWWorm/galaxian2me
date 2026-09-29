extends SceneTree
## The interface theme reaches the screens (the root window's theme stops at
## non-Control parents), and the Options page opened from the flight's pause
## menu survives a dropdown taking focus, which reads as the window losing it.
const Host := preload("res://tests/support/isolated_app.gd")
const UI := preload("res://src/presentation/ui.gd")
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
	app.settings.set_value("controls", "touch", "off")
	app.show_title()
	for i in 3: await process_frame
	var probe := CheckButton.new()
	app.screen.add_child(probe)
	var b := Button.new()
	app.screen.add_child(b)
	await process_frame
	check(probe.get_theme_icon("unchecked").get_size() == Vector2(44, 24), "switches use the game's drawn toggle")
	var box := b.get_theme_stylebox("normal") as StyleBoxFlat
	check(box != null and box.bg_color.is_equal_approx(Color(UI.DEEP, 0.85)), "buttons use the game's panels, not the engine's")
	var g = app._make_game()
	g.new_game()
	g.session.story_step = 20
	g.session.story_mission = {}
	app.game = g
	app.show_flight()
	for i in 4: await process_frame
	var fs = app.screen
	if fs.conversation != null: fs.conversation.queue_free(); fs.conversation = null
	fs.set_paused(true)
	await process_frame
	for button in fs.hud.find_children("*", "Button", true, false):
		if button.text == app.library.text(3): button.pressed.emit()
	await process_frame
	var options = null
	for o in fs.hud.find_children("*", "", true, false):
		if o.get_script() != null and str(o.get_script().resource_path).ends_with("options_panel.gd"): options = o
	check(options != null, "Options opens from the pause menu")
	fs._notification(Control.NOTIFICATION_WM_WINDOW_FOCUS_OUT)
	for i in 3: await process_frame
	check(is_instance_valid(options) and options.is_inside_tree(), "a dropdown taking focus leaves the Options page open")
	app.queue_free()
	await process_frame
	print("UI OPTIONS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
