extends SceneTree
## Steer from anywhere: a finger on free screen space (either side, not on a
## button) becomes the stick where it lands; the resting stick is not drawn
## and the look-around drag is off.
const TouchControls := preload("res://src/flight/touch_controls.gd")
var checks := 0
var failures := 0
class FakeApp:
	var values := {}
	func setting(section: String, key: String, fallback = null):
		return values.get(section + "/" + key, fallback)

func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)

func touch(t, index: int, at: Vector2, pressed := true) -> void:
	var e := InputEventScreenTouch.new(); e.index = index; e.position = at; e.pressed = pressed
	t.handle_touch(e)

func drag(t, index: int, at: Vector2) -> void:
	var e := InputEventScreenDrag.new(); e.index = index; e.position = at
	t.handle_touch(e)

func run() -> void:
	var host := Control.new()
	host.size = Vector2(1280, 800)
	root.add_child(host)
	var app := FakeApp.new()
	var t = TouchControls.new()
	t.app = app
	host.add_child(t)
	await process_frame
	t.size = Vector2(1280, 800)
	t._layout()
	t.set_context(true, false)
	# Standard mode: a finger on the right half away from buttons looks around.
	touch(t, 0, Vector2(800, 300))
	check(t.look_id == 0 and t.stick_id < 0, "normally a free right-hand finger looks around")
	touch(t, 0, Vector2(800, 300), false)
	app.values["controls/touch_steer_anywhere"] = true
	touch(t, 1, Vector2(800, 300))
	check(t.stick_id == 1 and t.look_id < 0 and t.stick_center == Vector2(800, 300), "steering from anywhere, it becomes the stick where it lands")
	drag(t, 1, Vector2(800 + t.stick_radius, 300))
	var v: Dictionary = t.sample()
	check(float(v.get("yaw", 0.0)) != 0.0 or t.stick.x > 0.5, "and dragging it steers")
	touch(t, 1, Vector2(800 + t.stick_radius, 300), false)
	check(t.stick_id < 0 and t.stick == Vector2.ZERO, "letting go centres the helm")
	var fire: Rect2 = t.buttons.fire
	touch(t, 2, fire.get_center())
	check(t.stick_id < 0 and t.fingers.get(2) == "fire", "buttons still take their own touches")
	host.queue_free()
	await process_frame
	print("TOUCH ANYWHERE: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
