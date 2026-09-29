extends SceneTree
## Mouse steering follows the last device used: moving the pointer takes
## the helm, a steering key or the pad's stick hands it back, a click does
## neither. Memory-only.
const Host := preload("res://tests/support/isolated_app.gd")
const Controls := preload("res://src/flight/controls.gd")
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
	var c := Controls.new()
	c.app = app
	root.add_child(c)
	check(not c.mouse_owns, "a resting pointer does not steer at the start")
	var jitter := InputEventMouseMotion.new()
	jitter.relative = Vector2(2, 1)
	c._input(jitter)
	check(not c.mouse_owns, "a pointer twitch does not take the helm")
	var move := InputEventMouseMotion.new()
	move.relative = Vector2(30, 0)
	c._input(move)
	check(c.mouse_owns, "moving the pointer takes the helm")
	var click := InputEventMouseButton.new()
	click.button_index = MOUSE_BUTTON_LEFT
	click.pressed = true
	c._input(click)
	check(c.mouse_owns, "a click leaves it with the pointer")
	var key := InputEventKey.new()
	key.physical_keycode = KEY_A
	key.pressed = true
	c._input(key)
	check(not c.mouse_owns, "a steering key hands the helm back")
	c._input(move)
	var fire := InputEventKey.new()
	fire.physical_keycode = KEY_SPACE
	fire.pressed = true
	c._input(fire)
	check(c.mouse_owns, "other keys leave it with the pointer")
	var stick := InputEventJoypadMotion.new()
	stick.axis = JOY_AXIS_LEFT_X
	stick.axis_value = 0.8
	c._input(stick)
	check(not c.mouse_owns, "the pad's stick hands the helm back")
	c.queue_free()
	print("MOUSE OWNER: %d checks, %d failures" % [checks, failures])
	app.queue_free()
	quit(1 if failures else 0)
