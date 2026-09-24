extends Node
## Flight input: keyboard, mouse and gamepad mapped onto the original's
## phone controls (steer, fire, secondary weapon, booster, autopilot, auto
## fire, rear view, target selection, action menu).

var app
var mouse_steer := true
var fire_was := false
var pressed := {}

const ACTIONS := {
	"steer_left": [KEY_LEFT, KEY_A], "steer_right": [KEY_RIGHT, KEY_D],
	"steer_up": [KEY_UP, KEY_W], "steer_down": [KEY_DOWN, KEY_S],
	"fire": [KEY_SPACE, KEY_CTRL], "secondary": [KEY_E], "boost": [KEY_SHIFT],
	"autopilot": [KEY_Q], "auto_fire": [KEY_F], "rear_view": [KEY_C],
	"next_target": [KEY_TAB], "action_menu": [KEY_M], "map": [KEY_N],
}
const PAD := {
	"fire": JOY_BUTTON_RIGHT_SHOULDER, "secondary": JOY_BUTTON_LEFT_SHOULDER,
	"boost": JOY_BUTTON_A, "autopilot": JOY_BUTTON_Y, "next_target": JOY_BUTTON_X,
	"rear_view": JOY_BUTTON_RIGHT_STICK, "action_menu": JOY_BUTTON_BACK,
}

func _ready() -> void:
	for action in ACTIONS:
		if InputMap.has_action(action): continue
		InputMap.add_action(action, 0.2)
		for key in ACTIONS[action]:
			var e := InputEventKey.new()
			e.physical_keycode = key
			InputMap.action_add_event(action, e)
		if PAD.has(action):
			var j := InputEventJoypadButton.new()
			j.button_index = PAD[action]
			InputMap.action_add_event(action, j)
	for pair in [["steer_left", JOY_AXIS_LEFT_X, -1.0], ["steer_right", JOY_AXIS_LEFT_X, 1.0], ["steer_up", JOY_AXIS_LEFT_Y, -1.0], ["steer_down", JOY_AXIS_LEFT_Y, 1.0]]:
		var m := InputEventJoypadMotion.new()
		m.axis = pair[1]
		m.axis_value = pair[2]
		InputMap.action_add_event(pair[0], m)
	var trigger := InputEventJoypadMotion.new()
	trigger.axis = JOY_AXIS_TRIGGER_RIGHT
	trigger.axis_value = 1.0
	InputMap.action_add_event("fire", trigger)
	mouse_steer = bool(app.setting("controls", "mouse", true)) and not OS.has_feature("mobile")

func _just(action: String) -> bool:
	return Input.is_action_just_pressed(action)

## The steering and trigger state for this frame.
func state(view) -> Dictionary:
	var invert := -1.0 if bool(app.setting("controls", "invert", false)) else 1.0
	var yaw := Input.get_axis("steer_left", "steer_right")
	var pitch := Input.get_axis("steer_down", "steer_up") * invert
	var fire := Input.is_action_pressed("fire")
	var secondary := _just("secondary")
	if mouse_steer and DisplayServer.window_is_focused():
		var vp := get_viewport()
		var size := vp.get_visible_rect().size
		var m := vp.get_mouse_position() - size / 2.0
		var r := minf(size.x, size.y) * 0.35
		var v := m / r
		if v.length() > 0.08 and absf(yaw) < 0.01 and absf(pitch) < 0.01:
			yaw = clampf(v.x, -1.0, 1.0)
			pitch = clampf(-v.y, -1.0, 1.0) * invert
		fire = fire or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
		secondary = secondary or (Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and not pressed.get("rmb", false))
		pressed["rmb"] = Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
	var fire_pressed := fire and not fire_was
	fire_was = fire
	if _just("rear_view") and view != null: view.rear_view = not view.rear_view
	if _just("auto_fire"):
		app.set_setting("controls", "auto_fire", not bool(app.setting("controls", "auto_fire", false)))
	return {"yaw": yaw, "pitch": pitch, "fire": fire, "fire_pressed": fire_pressed, "secondary": secondary,
		"boost": Input.is_action_pressed("boost"), "next_target": _just("next_target"),
		"autopilot": _just("autopilot"), "action_menu": _just("action_menu"), "map": _just("map"),
		"auto_fire": bool(app.setting("controls", "auto_fire", false))}
