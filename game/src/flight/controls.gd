extends Node
## Flight input: keyboard, mouse, gamepad and touch mapped onto the original's
## phone controls (steer, fire, secondary weapon, booster, autopilot, auto
## fire, rear view, target selection, action menu).

var app
var mouse_steer := true
## The pointer steers only while it was the last thing used: moving it
## takes the helm, a steering key or the pad's stick hands it back, so a
## resting cursor never turns the ship.
var mouse_owns := false
const MOUSE_TAKEOVER_PX := 6.0
## While flying with the mouse the pointer is captured (as in Deep) and its
## motion turns the ship directly: it is queued and paid out over a short
## response time, up to three times the rate the keys turn at (Deep's
## ceiling), so a flick of the wrist brings the ship round.
var captured := false
var mouse_turn := Vector2.ZERO
## Alt held with the captured mouse: where the view is swung to.
var mouse_look := Vector2.ZERO
## Pixels of motion that make one tick's full-rate turn, the most the mouse
## may turn in a tick (in full-rate turns), how quickly queued motion is
## paid out and the most that may wait.
const MOUSE_PX_PER_TICK := 4.0
const MOUSE_RATE := 3.0
const MOUSE_RESPONSE_MS := 80.0
const MOUSE_BACKLOG_PX := 600.0
var fire_was := false
var pressed := {}
## The eased steering of the smooth helm.
var helm := Vector2.ZERO
var touch: Control

const TouchControls := preload("res://src/flight/touch_controls.gd")
const Prefs := preload("res://src/presentation/preferences.gd")

const ACTIONS := {
	"steer_left": [KEY_LEFT, KEY_A], "steer_right": [KEY_RIGHT, KEY_D],
	"steer_up": [KEY_UP], "steer_down": [KEY_DOWN],
	"throttle_up": [KEY_W], "throttle_down": [KEY_S],
	"fire": [KEY_SPACE, KEY_CTRL], "secondary": [KEY_E], "boost": [KEY_SHIFT],
	"autopilot": [KEY_Q], "autopilot_menu": [KEY_R], "auto_fire": [KEY_F], "rear_view": [KEY_C],
	"next_target": [KEY_TAB], "action_menu": [KEY_M], "map": [KEY_N],
	"pause": [KEY_ESCAPE], "photo": [KEY_P], "cloak": [KEY_V], "time_warp": [KEY_T],
}
const PAD := {
	"fire": JOY_BUTTON_RIGHT_SHOULDER, "secondary": JOY_BUTTON_LEFT_SHOULDER,
	"boost": JOY_BUTTON_A, "autopilot": JOY_BUTTON_Y, "next_target": JOY_BUTTON_X,
	"rear_view": JOY_BUTTON_RIGHT_STICK, "action_menu": JOY_BUTTON_BACK,
	"pause": JOY_BUTTON_START,
}

func _ready() -> void:
	ensure_actions()
	Prefs.apply_bindings(app, ACTIONS)
	mouse_steer = bool(app.setting("controls", "mouse", true)) and not OS.has_feature("mobile") and not TouchControls.wanted(app)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if captured:
			if Input.is_key_pressed(KEY_ALT):
				mouse_look = (mouse_look + event.relative / 240.0).limit_length(1.0)
			else:
				mouse_turn = (mouse_turn + event.relative * Prefs.mouse_sensitivity(app)).limit_length(MOUSE_BACKLOG_PX)
			mouse_owns = true
		elif event.relative.length() >= MOUSE_TAKEOVER_PX: mouse_owns = true
	elif event is InputEventJoypadMotion:
		if event.axis in [JOY_AXIS_LEFT_X, JOY_AXIS_LEFT_Y] and absf(event.axis_value) > Prefs.deadzone(app): mouse_owns = false
	elif event is InputEventKey or event is InputEventJoypadButton:
		if event.pressed:
			# Strafing keys leave the helm with the mouse.
			var steering: Array = ["steer_up", "steer_down"] if strafing() else ["steer_left", "steer_right", "steer_up", "steer_down"]
			for action in steering:
				if event.is_action(action): mouse_owns = false

## Screens are recreated on every arrival. Never accumulate duplicate bindings.
static func ensure_actions() -> void:
	# W and S once pitched the nose; they are the throttle now, as in Deep.
	for pair in [["steer_up", KEY_W], ["steer_down", KEY_S]]:
		if not InputMap.has_action(pair[0]): continue
		for e in InputMap.action_get_events(pair[0]):
			if e is InputEventKey and (e as InputEventKey).physical_keycode == pair[1]: InputMap.action_erase_event(pair[0], e)
	for action in ACTIONS:
		if not InputMap.has_action(action): InputMap.add_action(action, 0.2)
		for key in ACTIONS[action]:
			var e := InputEventKey.new()
			e.physical_keycode = key
			if not InputMap.action_has_event(action, e): InputMap.action_add_event(action, e)
		if PAD.has(action):
			var j := InputEventJoypadButton.new()
			j.button_index = PAD[action]
			if not InputMap.action_has_event(action, j): InputMap.action_add_event(action, j)
	for pair in [["steer_left", JOY_AXIS_LEFT_X, -1.0], ["steer_right", JOY_AXIS_LEFT_X, 1.0], ["steer_up", JOY_AXIS_LEFT_Y, -1.0], ["steer_down", JOY_AXIS_LEFT_Y, 1.0]]:
		var m := InputEventJoypadMotion.new()
		m.axis = pair[1]
		m.axis_value = pair[2]
		if not InputMap.action_has_event(pair[0], m): InputMap.action_add_event(pair[0], m)
	var trigger := InputEventJoypadMotion.new()
	trigger.axis = JOY_AXIS_TRIGGER_RIGHT
	trigger.axis_value = 1.0
	if not InputMap.action_has_event("fire", trigger): InputMap.action_add_event("fire", trigger)

## How far the captured pointer's stick reaches, in pixels: a full turn.
func stick_radius() -> float:
	var size := get_viewport().get_visible_rect().size if is_inside_tree() else Vector2(1280, 800)
	return minf(size.x, size.y) * 0.35 / Prefs.mouse_sensitivity(app)

## Deep's strafe: when something else turns the ship (the captured mouse),
## left and right slide it sideways instead. Auto, Always or Never.
func strafing() -> bool:
	match str(app.setting("controls", "strafe", "auto")):
		"always": return true
		"never": return false
	return captured and mouse_steer

func reset() -> void:
	mouse_turn = Vector2.ZERO
	mouse_look = Vector2.ZERO
	fire_was = false
	helm = Vector2.ZERO
	pressed.clear()
	_pilot_down = -1
	if is_instance_valid(touch): touch.reset()

func _just(action: String) -> bool:
	return Input.is_action_just_pressed(action)

## Options → Controls → Hold autopilot for the list (after Deep's
## tap / hold autopilot key): a tap acts on release as the original's key
## does, holding it opens the autopilot list. Off, the key acts at once.
const HOLD_MS := 450
var _pilot_down := -1
var _pilot_held := false
func _autopilot_key() -> Array:
	if not bool(app.setting("controls", "autopilot_hold", false)):
		return [_just("autopilot"), false]
	var now := Time.get_ticks_msec()
	if Input.is_action_just_pressed("autopilot"):
		_pilot_down = now
		_pilot_held = false
	if _pilot_down < 0: return [false, false]
	if Input.is_action_pressed("autopilot"):
		if not _pilot_held and now - _pilot_down >= HOLD_MS:
			_pilot_held = true
			return [false, true]
		return [false, false]
	var tap := not _pilot_held
	_pilot_down = -1
	return [tap, false]

## Set by automated checks to drive the ship without devices.
var scripted: Callable = Callable()

## The steering and trigger state for this frame.
func state(view) -> Dictionary:
	if scripted.is_valid(): return scripted.call()
	var virtual: Dictionary = touch.sample() if is_instance_valid(touch) else {}
	var invert := -1.0 if bool(app.setting("controls", "invert", false)) else 1.0
	var yaw := Input.get_axis("steer_left", "steer_right")
	var strafe := 0.0
	if strafing():
		strafe = yaw
		yaw = 0.0
	var pitch := Input.get_axis("steer_down", "steer_up") * invert
	var lean := Prefs.tilt(app)
	yaw = clampf(yaw + float(virtual.get("yaw", 0.0)) + lean.x, -1.0, 1.0)
	pitch = clampf(pitch + lean.y * invert, -1.0, 1.0)
	pitch = clampf(pitch + float(virtual.get("pitch", 0.0)) * invert, -1.0, 1.0)
	var fire := Input.is_action_pressed("fire") or bool(virtual.get("fire", false))
	var secondary := _just("secondary") or bool(virtual.get("secondary", false))
	# Looking around: Alt (or the right stick) swings the camera round the
	# ship instead of steering it.
	var look := Vector2.ZERO
	for pad in Input.get_connected_joypads():
		var stick := Vector2(Input.get_joy_axis(pad, JOY_AXIS_RIGHT_X), Input.get_joy_axis(pad, JOY_AXIS_RIGHT_Y))
		if stick.length() > Prefs.deadzone(app): look = stick.limit_length(1.0)
	var touch_look: Vector2 = virtual.get("look", Vector2.ZERO)
	if touch_look != Vector2.ZERO: look = touch_look
	if mouse_steer and DisplayServer.window_is_focused():
		var vp := get_viewport()
		var size := vp.get_visible_rect().size
		var m := vp.get_mouse_position() - size / 2.0
		var r := stick_radius()
		var v := m / r
		if captured:
			if Input.is_key_pressed(KEY_ALT): look = mouse_look
			else: mouse_look = Vector2.ZERO
			var tick_ms := 1000.0 / float(Engine.physics_ticks_per_second)
			var wanted := mouse_turn * (1.0 - exp(-tick_ms / MOUSE_RESPONSE_MS))
			# The tail is finished outright rather than creeping for ever.
			if mouse_turn.length() < 3.0: wanted = mouse_turn
			var ceiling := MOUSE_PX_PER_TICK * MOUSE_RATE
			wanted = Vector2(clampf(wanted.x, -ceiling, ceiling), clampf(wanted.y, -ceiling, ceiling))
			mouse_turn -= wanted
			var turn := wanted / MOUSE_PX_PER_TICK
			if turn.length() > 0.02 and absf(yaw) < 0.01 and absf(pitch) < 0.01:
				yaw = turn.x
				pitch = -turn.y * invert
		elif Input.is_key_pressed(KEY_ALT):
			look = Vector2(clampf(v.x, -1.0, 1.0), clampf(v.y, -1.0, 1.0))
		elif mouse_owns and v.length() > 0.08 and absf(yaw) < 0.01 and absf(pitch) < 0.01:
			yaw = clampf(v.x, -1.0, 1.0)
			pitch = clampf(-v.y, -1.0, 1.0) * invert
		fire = fire or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
		secondary = secondary or (Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and not pressed.get("rmb", false))
		pressed["rmb"] = Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
	if str(app.setting("controls", "helm", "direct")) == "smooth":
		# Eases into a turn over a fraction of a second and out of it again.
		var step := 4.0 / float(Engine.physics_ticks_per_second)
		helm = Vector2(move_toward(helm.x, yaw, step), move_toward(helm.y, pitch, step))
		yaw = helm.x
		pitch = helm.y
	else:
		helm = Vector2(yaw, pitch)
	var fire_pressed := (fire and not fire_was) or bool(virtual.get("fire_pressed", false))
	fire_was = fire
	if view != null: view.look_input = look
	if (_just("rear_view") or bool(virtual.get("rear_view", false))) and view != null: view.toggle_look()
	var pilot := _autopilot_key()
	var auto_toggled: bool = _just("auto_fire") or bool(virtual.get("auto_fire", false))
	if auto_toggled:
		app.set_setting("controls", "auto_fire", not bool(app.setting("controls", "auto_fire", false)))
	return {"yaw": yaw, "pitch": pitch, "strafe": strafe, "fire": fire, "fire_pressed": fire_pressed, "secondary": secondary,
		"boost": Input.is_action_pressed("boost") or bool(virtual.get("boost", false)),
		"throttle": int(Input.get_axis("throttle_down", "throttle_up")),
		"next_target": _just("next_target") or bool(virtual.get("next_target", false)),
		"autopilot": bool(pilot[0]) or bool(virtual.get("autopilot", false)), "autopilot_list": bool(pilot[1]) or _just("autopilot_menu"),
		"cloak": _just("cloak"), "time_warp": _just("time_warp") or bool(virtual.get("time_warp", false)),
		"action_menu": _just("action_menu") or bool(virtual.get("action_menu", false)), "map": _just("map") or bool(virtual.get("map", false)),
		"auto_fire": bool(app.setting("controls", "auto_fire", false)), "auto_fire_toggled": auto_toggled}
