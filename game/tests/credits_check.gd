extends SceneTree
## Title → Credits shows the supplied game's own credits and copyright,
## rolls by itself, and stops rolling once the player scrolls.
const Host := preload("res://tests/support/isolated_app.gd")
const Credits := preload("res://src/screens/credits_panel.gd")
var checks := 0
var failures := 0

func _init() -> void:
	run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	print("PASS: " if ok else "FAIL: ", label)
	if not ok: failures += 1

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		check(false, "supplied content installed")
	else:
		var p := Credits.new()
		p.app = app
		app.ui_layer.add_child(p)
		await process_frame
		var texts: Array = p.find_children("*", "Label", true, false).map(func(l): return (l as Label).text)
		check(texts.has(app.library.text(25)) and texts.has(app.library.text(23)), "the game's credits and copyright are shown")
		check(p.title == app.library.text(21), "titled with the game's own word for credits")
		for i in 30: p._process(0.1)
		check(p.roll > 0.0, "the roll advances by itself")
		var wheel := InputEventMouseButton.new()
		wheel.button_index = MOUSE_BUTTON_WHEEL_DOWN
		wheel.pressed = true
		p._take_over(wheel)
		var at: float = p.roll
		p._process(0.5)
		check(not p.rolling and p.roll == at, "scrolling by hand stops the roll")
		p.queue_free()
	print("CREDITS: %d checks, %d failures" % [checks, failures])
	app.queue_free()
	quit(1 if failures else 0)
