extends SceneTree
## Deterministic input regression check; no JAR, saves, devices or rendering needed.
## godot --headless --path game -s res://tests/touch_controls_check.gd

const Touch := preload("res://src/flight/touch_controls.gd")
const Controls := preload("res://src/flight/controls.gd")

class SettingsStub extends RefCounted:
	var values := {"touch": "on", "mouse": true}
	func setting(_section: String, key: String, fallback = null):
		return values.get(key, fallback)
	func set_setting(_section: String, key: String, value) -> void:
		values[key] = value

var failures := 0
var checks := 0
var touch: Touch
var controls: Controls
var settings := SettingsStub.new()
class SectionStub extends RefCounted:
	var values := {}
	func setting(section: String, key: String, fallback = null):
		return values.get(section + "/" + key, fallback)
	func set_setting(section: String, key: String, value) -> void:
		values[section + "/" + key] = value
var pauses := 0
var radios := 0

func _init() -> void:
	_run.call_deferred()

func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("FAIL: " + label)

func point(action: String) -> Vector2:
	return touch.buttons[action].get_center()

func finger(index: int, pos: Vector2, down := true, canceled := false) -> bool:
	var event := InputEventScreenTouch.new()
	event.index = index
	event.position = pos
	event.pressed = down
	event.canceled = canceled
	return touch.handle_touch(event)

func drag(index: int, pos: Vector2) -> bool:
	var event := InputEventScreenDrag.new()
	event.index = index
	event.position = pos
	return touch.handle_touch(event)

func _run() -> void:
	root.size = Vector2i(1280, 800)
	touch = Touch.new()
	root.add_child(touch)
	controls = Controls.new()
	controls.app = settings
	controls.touch = touch
	root.add_child(controls)
	touch.pause_requested.connect(func(): pauses += 1)
	touch.radio_requested.connect(func(): radios += 1)
	await process_frame
	check(Touch.wanted(settings), "forced-on touch preference")
	check(not controls.mouse_steer, "emulated mouse cannot steer/fire in touch mode")
	settings.values.touch = "off"
	check(not Touch.wanted(settings), "forced-off touch preference")
	settings.values.touch = "on"

	var counts := {}
	for action in Controls.ACTIONS: counts[action] = InputMap.action_get_events(action).size()
	for i in 6: Controls.ensure_actions()
	for action in counts:
		check(InputMap.action_get_events(action).size() == counts[action], "stable mapping: " + action)
	var start := InputEventJoypadButton.new()
	start.button_index = JOY_BUTTON_START
	check(InputMap.action_has_event("pause", start), "gamepad Start pauses")

	# The overlay has usable hit areas at both the minimum and default sizes.
	touch.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	for dimensions in [Vector2(640, 400), Vector2(1280, 800), Vector2(1920, 800)]:
		touch.size = dimensions
		touch._layout()
		var bounds := Rect2(Vector2.ZERO, dimensions)
		for action in touch.buttons:
			var rect: Rect2 = touch.buttons[action]
			check(bounds.encloses(rect), "on-screen control %s at %s" % [action, dimensions])
			check(rect.size.x >= 48 and rect.size.y >= 48, "touch target size: " + action)
		check(bounds.encloses(Rect2(touch.stick_center - Vector2.ONE * touch.stick_radius, Vector2.ONE * touch.stick_radius * 2)), "stick within viewport")
	touch.size = Vector2(1280, 800)
	touch._layout()

	var center: Vector2 = touch.stick_center
	check(finger(10, center + Vector2(touch.stick_radius * 0.8, 0)), "capture steering finger")
	finger(11, center)
	check(touch.stick_id == 10 and touch.fingers.get(11) == "look", "second finger cannot steal steering (it looks around instead)")
	check(finger(20, point("fire")), "capture fire finger")
	check(finger(30, point("boost")), "capture boost finger")
	var state := controls.state(null)
	check(state.yaw > 0.7 and is_zero_approx(state.pitch), "analogue steering")
	check(state.fire and state.fire_pressed and state.boost, "simultaneous steer/fire/boost")
	check(not Input.is_action_pressed("fire") and not Input.is_action_pressed("boost"), "touch does not pollute global actions")
	state = controls.state(null)
	check(state.fire and not state.fire_pressed, "held fire has one rising edge")
	check(finger(21, point("fire")), "two fingers may hold one button")
	finger(20, Vector2.ZERO, false)
	check(controls.state(null).fire, "releasing one fire finger keeps the other held")
	finger(21, Vector2.ZERO, false)
	check(not controls.state(null).fire, "release outside button clears fire")
	check(drag(10, center + Vector2(1000, -1000)), "drag outside joystick remains captured")
	state = controls.state(null)
	check(Vector2(state.yaw, state.pitch).length() <= 1.001 and state.pitch > 0.6, "radial steering clamp")
	settings.values.invert = true
	check(controls.state(null).pitch < -0.6, "invert pitch applies to touch")
	settings.values.invert = false
	drag(10, center + Vector2(1, 1))
	check(is_zero_approx(controls.state(null).yaw), "stick dead zone")
	finger(10, Vector2.ZERO, false)
	finger(30, Vector2.ZERO, false)
	state = controls.state(null)
	check(state.yaw == 0 and state.pitch == 0 and not state.boost, "all fingers released")

	for action in ["secondary", "next_target", "autopilot", "fire", "boost"]:
		finger(1, point(action))
		finger(1, Vector2.ZERO, false)
		state = controls.state(null)
		check(bool(state.get(action, false)), "short tap survives until physics: " + action)
		check(not bool(controls.state(null).get(action, false)), "short tap is consumed once: " + action)
		if action == "fire": check(state.fire_pressed, "short fire tap activates locked objects")

	finger(1, point("auto_fire"))
	finger(1, Vector2.ZERO, false)
	check(controls.state(null).auto_fire, "touch auto fire toggle")
	check(controls.state(null).auto_fire, "auto fire toggle is not repeated")
	settings.values.auto_fire = false
	Input.action_press("steer_left")
	check(controls.state(null).yaw == -1.0, "keyboard still works beside touch")
	Input.action_release("steer_left")

	finger(1, point("fire"))
	finger(1, point("fire"), true, true)
	check(not controls.state(null).fire, "canceled touch must not become a queued shot")
	finger(2, point("fire"))
	touch.visible = false
	check(not controls.state(null).fire and touch.fingers.is_empty(), "hiding overlay releases holds and queued edges")
	touch.visible = true
	finger(3, point("secondary"))
	touch.set_context(false, false)
	touch.set_context(true, false)
	check(not controls.state(null).secondary, "cinematic transition clears pending presses")
	finger(4, point("boost"))
	touch.notification(Node.NOTIFICATION_WM_WINDOW_FOCUS_OUT)
	check(not controls.state(null).boost, "focus loss clears touch state")
	finger(5, point("fire"))
	controls.reset()
	check(not controls.state(null).fire and not controls.fire_was, "pause/reset clears fire edge history")

	# A floating stick comes to the thumb and returns to rest on release.
	var home: Vector2 = touch.stick_home
	var landing := home + Vector2(touch.stick_radius * 2.5, -touch.stick_radius * 0.5)
	check(finger(40, landing) and touch.stick_center == landing, "floating stick comes to the thumb")
	check(is_zero_approx(controls.state(null).yaw), "a landed stick starts centred")
	drag(40, landing + Vector2(touch.stick_radius * 0.8, 0))
	check(controls.state(null).yaw > 0.7, "floating stick steers from where it landed")
	finger(40, Vector2.ZERO, false)
	check(touch.stick_center == home, "released stick returns to rest")
	touch.app = settings
	settings.values.touch_fixed_stick = true
	finger(41, landing)
	check(touch.stick_id < 0 and touch.stick_center == home, "a fixed stick ignores touches away from it")
	# That free-space finger looks around while held, and lets go to centre.
	drag(41, landing + Vector2(touch.size.y * 0.35, 0))
	check(is_equal_approx(controls.state(null).get("yaw", 0.0), 0.0) and touch.look.x > 0.95, "a free-space drag looks around without steering")
	finger(41, Vector2.ZERO, false)
	check(touch.look == Vector2.ZERO, "releasing the look finger recentres the view")
	settings.values.touch_look = false
	check(not finger(42, landing), "look-around by dragging can be switched off")
	settings.values.erase("touch_look")
	settings.values.erase("touch_fixed_stick")
	touch.app = null

	finger(7, point("pause"))
	check(pauses == 1 and not controls.state(null).fire, "pause does not fire")
	finger(7, Vector2.ZERO, false)
	finger(8, point("radio"))
	check(radios == 0 and touch.fingers.get(8) != "radio", "radio hit area is absent without a message")
	finger(8, Vector2.ZERO, false)
	touch.set_context(false, true)
	check(finger(8, point("radio")) and radios == 1, "radio navigation during locked cinematic")
	check(not finger(9, point("fire")), "no gameplay buttons during cinematic")
	finger(8, Vector2.ZERO, false)
	# Placement editing: drag a button and the stick, save, and a fresh
	# overlay uses the saved places; Reset restores the layout.
	var store := SectionStub.new()
	var editor := Touch.new()
	editor.app = store
	editor.editing = true
	editor.size = Vector2(1280, 800)
	root.add_child(editor)
	editor._layout()
	var boost_before: Rect2 = editor.buttons.boost
	var stick_before: Vector2 = editor.stick_center
	var press := func(pos: Vector2, on: bool):
		var e := InputEventMouseButton.new()
		e.button_index = MOUSE_BUTTON_LEFT
		e.pressed = on
		e.position = pos
		return editor._edit(e)
	var move := func(pos: Vector2):
		var e := InputEventMouseMotion.new()
		e.position = pos
		return editor._edit(e)
	check(press.call(boost_before.get_center(), true), "editing picks up a button")
	move.call(boost_before.get_center() + Vector2(-300, -100))
	press.call(boost_before.get_center() + Vector2(-300, -100), false)
	check(editor.buttons.boost.position.distance_to(boost_before.position + Vector2(-300, -100)) < 1.0, "a dragged button moves with the pointer")
	press.call(stick_before, true)
	move.call(stick_before + Vector2(120, -60))
	press.call(stick_before + Vector2(120, -60), false)
	check(editor.stick_center.distance_to(stick_before + Vector2(120, -60)) < 1.0, "the stick can be moved too")
	# The last control pressed is selected and can be resized, 60%-200%.
	check(editor.selected == "stick", "the control last pressed is selected")
	var radius_before := editor.stick_radius
	editor.resize_selected(0.5)
	check(is_equal_approx(editor.stick_radius, radius_before * 1.5), "the selected stick grows")
	press.call(editor.buttons.boost.get_center(), true)
	press.call(editor.buttons.boost.get_center(), false)
	var centre: Vector2 = editor.buttons.boost.get_center()
	for i in 20: editor.resize_selected(0.1)
	check(is_equal_approx(editor.selected_size(), 2.0) and editor.buttons.boost.size.is_equal_approx(boost_before.size * 2.0)
		and editor.buttons.boost.get_center().distance_to(centre) < 1.0, "a button grows about its centre up to 200%")
	for i in 20: editor.resize_selected(-0.1)
	check(is_equal_approx(editor.selected_size(), 0.6), "and shrinks no smaller than 60%")
	editor.resize_selected(0.1)
	editor.save_offsets()
	var fresh := Touch.new()
	fresh.app = store
	fresh.size = Vector2(1280, 800)
	root.add_child(fresh)
	fresh._layout()
	check(fresh.buttons.boost.position.distance_to(editor.buttons.boost.position) < 1.0 and fresh.stick_home.distance_to(editor.stick_center) < 1.0,
		"saved placement applies to the flight controls")
	check(fresh.buttons.boost.size.is_equal_approx(boost_before.size * 0.7) and is_equal_approx(fresh.stick_radius, radius_before * 1.5),
		"saved sizes apply to the flight controls")
	press.call(Vector2(640, 20), true)
	press.call(Vector2(640, 20), false)
	editor.reset_offsets()
	check(editor.buttons.boost == boost_before and editor.stick_center == stick_before and editor.stick_radius == radius_before, "Reset restores the default places and sizes")
	editor.queue_free()
	fresh.queue_free()
	print("TOUCH CONTROLS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
