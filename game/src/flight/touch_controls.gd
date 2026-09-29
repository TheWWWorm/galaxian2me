extends Control
## Native touch input, kept separate from Input's global keyboard/gamepad state.
## Each finger owns its control until release, even when it leaves the button.
## One-shot presses are queued until the next physics sample (including short taps).

const UI := preload("res://src/presentation/ui.gd")
const DEAD_ZONE := 0.12
const LABELS := {
	"next_target": "Target", "autopilot": "Autopilot", "auto_fire": "Auto fire",
	"rear_view": "Rear view", "secondary": "Secondary", "boost": "Boost",
	"fire": "Fire / use", "pause": "Pause", "radio": "Next radio",
	"action_menu": "Actions",
}

signal pause_requested
signal radio_requested

## Optional app, for the player's size and handedness preferences.
var app = null
var gameplay_enabled := true
var radio_visible := false
## The time speed-up button's caption; empty hides the button.
var warp_label := ""
## The radio button's caption when it skips a cinematic's wait instead.
var radio_label := ""
## The fire button's caption while it docks, flies in or mines instead of
## firing; it pulses then. Empty for the ordinary caption.
var use_label := ""
var fingers := {}
var edges := {}
var stick_id := -1
var stick := Vector2.ZERO
var stick_center := Vector2.ZERO
## Where the stick rests; a floating stick moves to the thumb and back.
var stick_home := Vector2.ZERO
var stick_radius := 92.0
var buttons := {}
## Buttons for equipment the ship may lack ("boost", "secondary"): false
## hides the button until the equipment is fitted (the flight screen sets it).
var fitted := {}
## Fire tapped twice in quick succession toggles automatic fire; while it is
## on, one tap stops it.
const DOUBLE_TAP_MS := 320
var _last_fire_ms := -100000
## Looking around: a finger on free screen space swings the camera while it
## is held; letting go brings the view back behind the ship.
var look_id := -1
var look_origin := Vector2.ZERO
var look := Vector2.ZERO
## Placement editing: every control shows and a drag moves it. Offsets are
## fractions of the screen, saved in the settings' touch_layout section.
var editing := false
var offsets := {}
## Each control's own size, 60%-200% of the layout's (settings touch_size).
var sizes := {}
## The control last pressed while editing, which the size buttons change.
var selected := ""
const MIN_SIZE := 0.6
const MAX_SIZE := 2.0

signal selection_changed
var _drag := ""
var _drag_from := Vector2.ZERO
var _drag_offset := Vector2.ZERO

static func wanted(app) -> bool:
	match str(app.setting("controls", "touch", "auto")):
		"on": return true
		"off": return false
	return OS.has_feature("mobile") or DisplayServer.is_touchscreen_available()

func _ready() -> void:
	add_to_group("touch_controls")
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	resized.connect(_layout)
	visibility_changed.connect(reset)
	_layout()

func _layout() -> void:
	# Leave the hull/shield bars free. In touch mode the HUD moves its radar
	# between the two hands, rather than underneath the action buttons.
	reset()
	var scale := clampf(minf(size.x / 1280.0, size.y / 800.0), 0.6, 1.25)
	if app != null: scale *= clampf(float(app.setting("controls", "touch_scale", 1.0)), 0.7, 1.4)
	var margin := maxf(12.0, 18.0 * scale)
	var cell := Vector2(maxf(64.0, 96.0 * scale), maxf(48.0, 56.0 * scale))
	var gap := maxf(6.0, 8.0 * scale)
	var bottom := size.y - margin - 110.0 * scale
	stick_radius = maxf(64.0, 92.0 * scale)
	stick_center = Vector2(margin + stick_radius, bottom - stick_radius)
	var origin := Vector2(size.x - margin - cell.x * 2.0 - gap, bottom - cell.y * 4.0 - gap * 3.0)
	buttons.clear()
	var rows := [["next_target", "autopilot"], ["auto_fire", "rear_view"], ["secondary", "boost"]]
	for row in rows.size():
		for col in 2:
			buttons[rows[row][col]] = Rect2(origin + Vector2(col * (cell.x + gap), row * (cell.y + gap)), cell)
	buttons.fire = Rect2(origin + Vector2(0, 3.0 * (cell.y + gap)), Vector2(cell.x * 2.0 + gap, cell.y))
	if app != null and bool(app.setting("controls", "touch_mirror", false)):
		# Left-handed: stick on the right, the action cluster on the left.
		stick_center.x = size.x - stick_center.x
		for action in buttons.keys():
			var r: Rect2 = buttons[action]
			buttons[action] = Rect2(Vector2(size.x - r.position.x - r.size.x, r.position.y), r.size)
	buttons.pause = Rect2(Vector2(size.x - margin - cell.x, margin), cell)
	buttons.action_menu = Rect2(Vector2(size.x - margin - cell.x * 2.0 - gap, margin), cell)
	buttons.time_warp = Rect2(Vector2(size.x - margin - cell.x * 3.0 - gap * 2.0, margin), cell)
	buttons.radio = Rect2(Vector2(size.x / 2.0 - 72.0, 146.0), Vector2(144, cell.y))
	if not editing: _load_offsets()
	for action in buttons.keys():
		var r: Rect2 = buttons[action]
		var grow := float(sizes.get(action, 1.0))
		if grow != 1.0: r = Rect2(r.get_center() - r.size * grow / 2.0, r.size * grow)
		r.position += Vector2(offsets.get(action, Vector2.ZERO)) * size
		r.position = r.position.clamp(Vector2.ZERO, (size - r.size).max(Vector2.ZERO))
		buttons[action] = r
	stick_radius *= float(sizes.get("stick", 1.0))
	stick_center += Vector2(offsets.get("stick", Vector2.ZERO)) * size
	stick_center = stick_center.clamp(Vector2.ONE * stick_radius, (size - Vector2.ONE * stick_radius).max(Vector2.ONE * stick_radius))
	stick_home = stick_center
	queue_redraw()

func _load_offsets() -> void:
	offsets.clear()
	if app == null: return
	for key in LABELS.keys() + ["time_warp", "stick"]:
		# A null fallback would make the settings file report a missing key.
		var v = app.setting("touch_layout", key, false)
		if v is Vector2: offsets[key] = v
	sizes.clear()
	for key in LABELS.keys() + ["time_warp", "stick"]:
		var s = app.setting("touch_size", key, 1.0)
		if (s is float or s is int) and not is_equal_approx(float(s), 1.0): sizes[key] = clampf(float(s), MIN_SIZE, MAX_SIZE)

## Saves the edited placement.
func save_offsets() -> void:
	if app == null: return
	for key in LABELS.keys() + ["time_warp", "stick"]:
		app.set_setting("touch_layout", key, offsets.get(key, Vector2.ZERO))
		app.set_setting("touch_size", key, float(sizes.get(key, 1.0)))

## Puts every control back where the layout places it.
func reset_offsets() -> void:
	offsets.clear()
	sizes.clear()
	_layout()
	selection_changed.emit()

## Puts the selected control back in its place at its standard size.
func reset_selected() -> void:
	if selected.is_empty(): return
	offsets.erase(selected)
	sizes.erase(selected)
	_layout()
	selection_changed.emit()

## Grows or shrinks the selected control by `step` (0.1 is ten per cent).
func resize_selected(step: float) -> void:
	if selected.is_empty(): return
	var now := clampf(snappedf(float(sizes.get(selected, 1.0)) + step, 0.1), MIN_SIZE, MAX_SIZE)
	if is_equal_approx(now, 1.0): sizes.erase(selected)
	else: sizes[selected] = now
	_layout()
	selection_changed.emit()

## What a control is called in the editor.
func control_name(key: String) -> String:
	if key == "stick": return "Steer / drill"
	if key == "time_warp": return "Faster"
	return str(LABELS.get(key, key))

func selected_size() -> float:
	return float(sizes.get(selected, 1.0))

func set_context(gameplay: bool, radio: bool) -> void:
	if gameplay_enabled == gameplay and radio_visible == radio: return
	if gameplay_enabled != gameplay: reset()
	gameplay_enabled = gameplay
	radio_visible = radio
	queue_redraw()

func set_fitted(map: Dictionary) -> void:
	if map == fitted: return
	fitted = map
	queue_redraw()

func _auto_fire_on() -> bool:
	return app != null and bool(app.setting("controls", "auto_fire", false))

func set_use(label: String) -> void:
	if use_label == label: return
	use_label = label
	queue_redraw()

func set_warp(label: String) -> void:
	if warp_label == label: return
	warp_label = label
	queue_redraw()

func reset() -> void:
	fingers.clear()
	edges.clear()
	stick_id = -1
	stick = Vector2.ZERO
	look_id = -1
	look = Vector2.ZERO
	if stick_home != Vector2.ZERO: stick_center = stick_home
	queue_redraw()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT: reset()

func _available(action: String) -> bool:
	if editing: return true
	if fitted.has(action) and not bool(fitted[action]): return false
	if action == "pause": return true
	if action == "radio": return radio_visible
	if action == "time_warp": return gameplay_enabled and not warp_label.is_empty()
	return gameplay_enabled

func _input(event: InputEvent) -> void:
	if editing:
		if _edit(event): get_viewport().set_input_as_handled()
		return
	if handle_touch(event): get_viewport().set_input_as_handled()

## Placement editing with a finger or the mouse: press on a control, drag it.
func _edit(event: InputEvent) -> bool:
	var pressed := false
	var released := false
	var moved := false
	var at := Vector2.ZERO
	if event is InputEventScreenTouch:
		pressed = event.pressed
		released = not event.pressed
		at = event.position
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		pressed = event.pressed
		released = not event.pressed
		at = event.position
	elif event is InputEventScreenDrag or (event is InputEventMouseMotion and _drag != ""):
		moved = true
		at = event.position
	else:
		return false
	var pos: Vector2 = get_global_transform_with_canvas().affine_inverse() * at
	if pressed:
		_drag = ""
		if pos.distance_to(stick_center) <= stick_radius: _drag = "stick"
		for action in buttons:
			if buttons[action].has_point(pos): _drag = action
		if _drag == "": return false
		selected = _drag
		selection_changed.emit()
		queue_redraw()
		_drag_from = pos
		_drag_offset = Vector2(offsets.get(_drag, Vector2.ZERO))
		return true
	if moved and _drag != "":
		offsets[_drag] = _drag_offset + (pos - _drag_from) / size
		_layout()
		return true
	if released and _drag != "":
		_drag = ""
		return true
	return false

## Returns whether the event belongs to this overlay. Positions are viewport pixels.
func handle_touch(event: InputEvent) -> bool:
	if not is_visible_in_tree(): return false
	if event is InputEventScreenTouch:
		if not event.pressed or event.canceled:
			if not fingers.has(event.index): return false
			var action: String = fingers[event.index]
			fingers.erase(event.index)
			if event.canceled and not fingers.values().has(action): edges.erase(action)
			if event.index == stick_id:
				stick_id = -1
				stick = Vector2.ZERO
				stick_center = stick_home
			if event.index == look_id:
				look_id = -1
				look = Vector2.ZERO
			queue_redraw()
			return true
		if fingers.has(event.index): return true
		var pos: Vector2 = get_global_transform_with_canvas().affine_inverse() * event.position
		if gameplay_enabled and stick_id < 0 and _floating() and (anywhere() or pos.distance_to(stick_center) > stick_radius) and _in_stick_zone(pos) and not _on_button(pos):
			# The stick comes to the thumb wherever it lands on its side;
			# a touch on the resting stick steers from where it is.
			stick_center = pos
		if gameplay_enabled and stick_id < 0 and pos.distance_to(stick_center) <= stick_radius:
			stick_id = event.index
			fingers[event.index] = "steer"
			_move_stick(pos)
			return true
		for action in buttons:
			if not _available(action) or not buttons[action].has_point(pos): continue
			var held_elsewhere: bool = fingers.values().has(action)
			fingers[event.index] = action
			if action == "pause": pause_requested.emit()
			elif action == "radio": radio_requested.emit()
			elif action == "fire" and not held_elsewhere and (_auto_fire_on() or Time.get_ticks_msec() - _last_fire_ms < DOUBLE_TAP_MS):
				# Double tap: automatic fire on; a tap while it runs: off.
				# Only separate single-finger taps count, never a second
				# finger joining one that holds the button.
				edges["auto_fire"] = true
				fingers[event.index] = "fire_toggle"
				_last_fire_ms = -100000
			else:
				if action == "fire":
					_last_fire_ms = -100000 if held_elsewhere else Time.get_ticks_msec()
				edges[action] = true
			queue_redraw()
			return true
		if gameplay_enabled and look_id < 0 and _look_enabled():
			look_id = event.index
			fingers[event.index] = "look"
			look_origin = pos
			look = Vector2.ZERO
			return true
	elif event is InputEventScreenDrag and fingers.has(event.index):
		var at: Vector2 = get_global_transform_with_canvas().affine_inverse() * event.position
		if event.index == stick_id:
			_move_stick(at)
		elif event.index == look_id:
			var reach := size.y * 0.35 / _look_sensitivity()
			var v := (at - look_origin) / maxf(1.0, reach)
			look = Vector2(clampf(v.x, -1.0, 1.0), clampf(v.y, -1.0, 1.0))
		return true
	return false

func _look_enabled() -> bool:
	return not anywhere() and (app == null or bool(app.setting("controls", "touch_look", true)))

func _look_sensitivity() -> float:
	return 1.0 if app == null else clampf(float(app.setting("controls", "touch_look_sensitivity", 1.0)), 0.5, 2.0)

func _floating() -> bool:
	return anywhere() or app == null or not bool(app.setting("controls", "touch_fixed_stick", false))

## Steer from anywhere: no resting stick and no look-around drag; a finger
## on any free part of the screen becomes the stick where it lands.
func anywhere() -> bool:
	return app != null and bool(app.setting("controls", "touch_steer_anywhere", false)) and not editing

## The stick's half of the screen, below the top panels.
func _in_stick_zone(pos: Vector2) -> bool:
	if anywhere(): return true
	if pos.y < size.y * 0.25: return false
	var left: bool = stick_home.x < size.x / 2.0
	return pos.x < size.x * 0.45 if left else pos.x > size.x * 0.55

func _on_button(pos: Vector2) -> bool:
	for action in buttons:
		if _available(action) and buttons[action].has_point(pos): return true
	return false

func _move_stick(pos: Vector2) -> void:
	var raw := (pos - stick_center) / stick_radius
	var length := minf(raw.length(), 1.0)
	stick = Vector2.ZERO if length <= DEAD_ZONE else raw.normalized() * ((length - DEAD_ZONE) / (1.0 - DEAD_ZONE))
	queue_redraw()

func sample() -> Dictionary:
	if not is_visible_in_tree() or not gameplay_enabled:
		return {"yaw": 0.0, "pitch": 0.0}
	var out := edges.duplicate()
	out.yaw = stick.x
	out.pitch = -stick.y
	out.look = look
	out.fire_pressed = bool(edges.get("fire", false))
	for action in ["fire", "boost"]:
		out[action] = bool(edges.get(action, false)) or fingers.values().has(action)
	edges.clear()
	return out

func _draw() -> void:
	var font := get_theme_default_font()
	if gameplay_enabled and (stick_id >= 0 or not anywhere()):
		draw_circle(stick_center, stick_radius, Color(0.01, 0.04, 0.08, 0.55))
		draw_arc(stick_center, stick_radius, 0, TAU, 64, UI.TEXT_GOOD if editing and selected == "stick" else UI.BORDER, 2.0, true)
		draw_circle(stick_center + stick * stick_radius * 0.7, stick_radius * 0.28, Color(UI.TEXT_GOOD, 0.65))
		draw_string(font, stick_center + Vector2(-stick_radius, -stick_radius - 10), "Steer / drill", HORIZONTAL_ALIGNMENT_CENTER, stick_radius * 2, 14, UI.TEXT_DIM)
	for action in buttons:
		if not _available(action): continue
		var rect: Rect2 = buttons[action]
		var held: bool = fingers.values().has(action) or (editing and (_drag == action or selected == action))
		var auto: bool = action == "fire" and not editing and _auto_fire_on()
		var use: bool = action == "fire" and not editing and not use_label.is_empty()
		draw_rect(rect, Color(0.05, 0.23, 0.34, 0.9) if held else Color(0.01, 0.04, 0.08, 0.65))
		var rim := UI.TEXT_GOOD if held or auto else UI.BORDER
		if use and not held:
			var pulse := 0.5 + 0.5 * sin(Time.get_ticks_msec() / 1000.0 * TAU)
			rim = UI.BORDER.lerp(UI.TEXT_GOOD, pulse)
		draw_rect(rect, rim, false, 3.0 if auto or use else 2.0)
		var font_size := 14 if rect.size.x >= 90 else 12
		var caption: String = LABELS.get(action, "")
		if action == "time_warp": caption = warp_label if not editing else "Faster"
		if action == "radio" and not radio_label.is_empty() and not editing: caption = radio_label
		if auto: caption = "AUTO · tap to stop"
		if use: caption = use_label
		draw_string(font, rect.position + Vector2(2, rect.size.y / 2.0 + 5), caption, HORIZONTAL_ALIGNMENT_CENTER, rect.size.x - 4, font_size, UI.TEXT)
