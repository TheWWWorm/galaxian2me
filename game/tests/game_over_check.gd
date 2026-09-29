extends SceneTree
## Losing the ship: the wreck burns out, then Game Over offers the way on
## (the last docking, or the opening when there is none) and the title.
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
	app.settings.set_value("controls", "touch", "off")
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
	fs.space.event.emit("destroyed", {})
	await create_timer(1.0).timeout
	check(fs.defeated and fs.hud.game_over_layer == null, "the wreck burns for a moment first")
	await create_timer(2.5).timeout
	check(fs.hud.game_over_layer != null, "then Game Over is offered")
	var buttons: Array = fs.hud.game_over_layer.find_children("*", "Button", true, false)
	check(buttons.size() == 2 and buttons[0].text == "Start again" and buttons[1].text == app.library.text(67),
		"with no docking yet: start again, or the menu")
	buttons[1].pressed.emit()
	for i in 3: await process_frame
	check(app.screen != fs and app.screen.get_script().resource_path.ends_with("title_screen.gd"), "Menu goes to the title")
	app.queue_free()
	await process_frame
	print("GAME OVER: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
