extends Control
## Native touch input, kept separate from Input's global keyboard/gamepad state.
## Each finger owns its control until release, even when it leaves the button.
## One-shot presses are queued until the next physics sample (including short taps).

const UI := preload("res://src/presentation/ui.gd")
const DEAD_ZONE := 0.12
const LABELS := {
	"next_target": "Target", "autopilot": "Autopilot",
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

## Buttons drawn as text pills rather than round icons.
const PILLS := ["radio"]
## The buttons curved around fire, as the iOS release sets them: their
## angles about the fire button (degrees, 180 is left, 270 straight up).
const ARC := {"secondary": [172.0, 206.0], "next_target": [210.0, 244.0], "rear_view": [248.0, 282.0]}
## Each arc segment's shape once placed: hub, inner and outer radius and
## the angles it spans (radians), following any moving or resizing.
var sectors := {}

## The original HUD's scale on this screen (see Hud._draw_original), so the
## controls keep clear of its corner icons and the bars along the foot.
func _hud_scale() -> float:
	return clampf(minf(size.x, size.y) / 240.0 * 0.6, 1.5, 4.0)

func _layout() -> void:
	# The iOS release's arrangement in the J2ME HUD's colours: the stick at
	# the bottom left with boost beside it and, as Deep stacks them, the
	# autopilot and the speed-up above it along the edge; fire at the bottom
	# right with secondary, target and rear view curved around it; the menu
	# and pause at the top right beside the HUD's corner icons. Automatic
	# fire is a double tap on fire, as in the iOS release.
	reset()
	var u := clampf(minf(size.x, size.y) / 640.0, 0.75, 1.35)
	if app != null: u *= clampf(float(app.setting("controls", "touch_scale", 1.0)), 0.7, 1.4)
	var margin := maxf(12.0, 16.0 * u)
	var hud := _hud_scale()
	var bottom := size.y - margin - 30.0 * hud
	var small := maxf(26.0, 30.0 * u)
	var big := maxf(44.0, 60.0 * u)
	var gap := maxf(6.0, 10.0 * u)
	stick_radius = maxf(64.0, 78.0 * u)
	stick_center = Vector2(margin + stick_radius, bottom - stick_radius)
	buttons.clear()
	sectors.clear()
	var round_at := func(c: Vector2, r: float) -> Rect2: return Rect2(c - Vector2(r, r), Vector2(r, r) * 2.0)
	var reach := stick_radius + gap + small
	buttons.boost = round_at.call(stick_center + Vector2.from_angle(deg_to_rad(20.0)) * reach, small)
	var column := Vector2(margin + small, stick_center.y - stick_radius - gap * 2.0 - 24.0 * u - small)
	buttons.autopilot = round_at.call(column, small)
	# Room under the speed-up for its "×4".
	buttons.time_warp = round_at.call(column - Vector2(0, small * 2.0 + gap * 2.0 + 14.0), small)
	var fire_c := Vector2(size.x - margin - big, bottom - big)
	buttons.fire = round_at.call(fire_c, big)
	var r0 := big + maxf(5.0, 6.0 * u)
	var r1 := r0 + maxf(50.0, 54.0 * u)
	var mirror := app != null and bool(app.setting("controls", "touch_mirror", false))
	for action in ARC:
		var a0 := deg_to_rad(float(ARC[action][0]))
		var a1 := deg_to_rad(float(ARC[action][1]))
		sectors[action] = {"hub": fire_c, "r0": r0, "r1": r1, "a0": a0, "a1": a1}
		buttons[action] = _sector_box(sectors[action])
	if mirror:
		# Left-handed: stick on the right, the fire cluster on the left.
		stick_center.x = size.x - stick_center.x
		for action in buttons.keys():
			var r: Rect2 = buttons[action]
			buttons[action] = Rect2(Vector2(size.x - r.position.x - r.size.x, r.position.y), r.size)
		for action in sectors:
			var sec: Dictionary = sectors[action]
			sec.hub = Vector2(size.x - sec.hub.x, sec.hub.y)
			var a0: float = sec.a0
			sec.a0 = PI - float(sec.a1)
			sec.a1 = PI - a0
	var corner := 36.0 * hud
	var top_c := Vector2(size.x - corner - gap - small, margin * 0.5 + small)
	buttons.pause = round_at.call(top_c, small)
	buttons.action_menu = round_at.call(top_c - Vector2(small * 2.0 + gap, 0), small)
	var pill := Vector2(maxf(96.0, 118.0 * u), small * 2.0)
	buttons.radio = Rect2(Vector2(size.x / 2.0 - pill.x * 0.65, 146.0), Vector2(pill.x * 1.3, pill.y))
	if not editing: _load_offsets()
	for action in buttons.keys():
		var before: Rect2 = buttons[action]
		var r := before
		var grow := float(sizes.get(action, 1.0))
		if grow != 1.0: r = Rect2(r.get_center() - r.size * grow / 2.0, r.size * grow)
		r.position += Vector2(offsets.get(action, Vector2.ZERO)) * size
		r.position = r.position.clamp(Vector2.ZERO, (size - r.size).max(Vector2.ZERO))
		buttons[action] = r
		if sectors.has(action):
			# The segment keeps its shape about wherever its box went.
			var sec: Dictionary = sectors[action]
			var k := r.size.x / maxf(1.0, before.size.x)
			sec.hub = r.get_center() + (Vector2(sec.hub) - before.get_center()) * k
			sec.r0 = float(sec.r0) * k
			sec.r1 = float(sec.r1) * k
	stick_radius *= float(sizes.get("stick", 1.0))
	stick_center += Vector2(offsets.get("stick", Vector2.ZERO)) * size
	stick_center = stick_center.clamp(Vector2.ONE * stick_radius, (size - Vector2.ONE * stick_radius).max(Vector2.ONE * stick_radius))
	stick_home = stick_center
	queue_redraw()

## The outline of an arc segment, outer edge first.
func _sector_points(sec: Dictionary, steps := 20) -> PackedVector2Array:
	var pts := PackedVector2Array()
	var hub: Vector2 = sec.hub
	for n in steps + 1:
		pts.append(hub + Vector2.from_angle(lerpf(sec.a0, sec.a1, float(n) / steps)) * float(sec.r1))
	for n in range(steps, -1, -1):
		pts.append(hub + Vector2.from_angle(lerpf(sec.a0, sec.a1, float(n) / steps)) * float(sec.r0))
	return pts

func _sector_box(sec: Dictionary) -> Rect2:
	var pts := _sector_points(sec, 12)
	var box := Rect2(pts[0], Vector2.ZERO)
	for p in pts: box = box.expand(p)
	return box

## Whether `pos` falls on `action`'s button: round buttons by their circle,
## the arc segments by their curved shape.
func _hit(action: String, pos: Vector2) -> bool:
	var r: Rect2 = buttons[action]
	if action in PILLS: return r.has_point(pos)
	if sectors.has(action):
		var sec: Dictionary = sectors[action]
		var d := pos - Vector2(sec.hub)
		if d.length() < float(sec.r0) - 4.0 or d.length() > float(sec.r1) + 6.0: return false
		var a := fposmod(d.angle() - float(sec.a0), TAU)
		var slack := 0.06
		return a <= float(sec.a1) - float(sec.a0) + slack or a >= TAU - slack
	return pos.distance_to(r.get_center()) <= r.size.x / 2.0

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
			if _hit(action, pos): _drag = action
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
			if not _available(action) or not _hit(action, pos): continue
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
		if _available(action) and _hit(action, pos): return true
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

const GLASS := Color(0.02, 0.06, 0.11, 0.66)
const GLASS_LIT := Color(0.09, 0.3, 0.5, 0.9)
const INK := Color(0.62, 0.84, 1.0)
const INK_LIT := Color(0.9, 0.97, 1.0)

func _draw() -> void:
	var font := get_theme_default_font()
	if gameplay_enabled and (stick_id >= 0 or not anywhere()):
		_draw_stick(font)
	for action in buttons:
		if not _available(action): continue
		var rect: Rect2 = buttons[action]
		var held: bool = fingers.values().has(action) or (editing and (_drag == action or selected == action))
		if action in PILLS:
			var caption: String = LABELS.get(action, "")
			if action == "radio" and not radio_label.is_empty() and not editing: caption = radio_label
			_pill(rect, held)
			draw_string(font, rect.position + Vector2(0, rect.size.y / 2.0 + 6), caption, HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, int(clampf(rect.size.y * 0.3, 12, 18)), UI.TEXT)
		elif action == "fire":
			_draw_fire(font, rect, held)
		elif sectors.has(action):
			var sec: Dictionary = sectors[action]
			_segment(sec, held)
			var mid := (float(sec.a0) + float(sec.a1)) / 2.0
			var at: Vector2 = Vector2(sec.hub) + Vector2.from_angle(mid) * (float(sec.r0) + float(sec.r1)) / 2.0
			var room := minf(float(sec.r1) - float(sec.r0), (float(sec.a1) - float(sec.a0)) * (float(sec.r0) + float(sec.r1)) / 2.0)
			_glyph(action, at, room * 0.26, INK_LIT if held else INK)
			continue
		else:
			var c := rect.get_center()
			var r := rect.size.x / 2.0
			var on: bool = held or (action == "autopilot" and _autopilot_on()) or (action == "time_warp" and warp_label.contains("×"))
			_disc(c, r, on)
			_glyph(action, c, r * 0.42, INK_LIT if on else INK)
			if action == "time_warp" and not editing and warp_label.contains("×"):
				# How much faster time runs, under the button as Deep shows it.
				var times := warp_label.substr(warp_label.find("×"))
				draw_string(font, c + Vector2(-r, r + 14), times, HORIZONTAL_ALIGNMENT_CENTER, r * 2.0, 13, INK_LIT)

func _autopilot_on() -> bool:
	var screen = get_parent()
	return screen != null and "space" in screen and screen.space != null and bool(screen.space.autopilot)

## A round button: dark glass in a blue rim lit from the top left, the
## J2ME HUD's icon frames made round.
func _disc(c: Vector2, r: float, lit: bool) -> void:
	draw_circle(c + Vector2(0, 2), r + 1.0, Color(0, 0, 0, 0.3))
	draw_circle(c, r, GLASS_LIT if lit else GLASS)
	draw_arc(c, r - 1.25, 0, TAU, 64, UI.BORDER_DARK, 2.5, true)
	draw_arc(c, r - 1.25, PI * 0.8, PI * 1.7, 40, UI.ACCENT if lit else Color(UI.ACCENT, 0.75), 2.0, true)
	draw_arc(c, r - 5.0, 0, TAU, 64, Color(UI.ACCENT, 0.16), 1.0, true)

## One of the segments curved around fire.
func _segment(sec: Dictionary, lit: bool) -> void:
	var pts := _sector_points(sec)
	draw_colored_polygon(pts, GLASS_LIT if lit else GLASS)
	var ring := pts.duplicate()
	ring.append(pts[0])
	draw_polyline(ring, UI.BORDER_DARK, 2.5, true)
	draw_arc(Vector2(sec.hub), float(sec.r1) - 1.25, float(sec.a0) + 0.02, float(sec.a1) - 0.02, 20, UI.ACCENT if lit else Color(UI.ACCENT, 0.7), 2.0, true)
	draw_arc(Vector2(sec.hub), float(sec.r1) - 5.0, float(sec.a0) + 0.05, float(sec.a1) - 0.05, 20, Color(UI.ACCENT, 0.14), 1.0, true)

## Fire: a raised button in a wide rim. It pulses with its caption while
## it docks, flies in or mines, and shows AUTO while automatic fire runs.
func _draw_fire(font: Font, rect: Rect2, held: bool) -> void:
	var c := rect.get_center()
	var r := rect.size.x / 2.0
	var auto: bool = not editing and _auto_fire_on()
	var use: bool = not editing and not use_label.is_empty()
	var pulse := 0.0
	if use and not held: pulse = 0.5 + 0.5 * sin(Time.get_ticks_msec() / 1000.0 * TAU)
	draw_circle(c + Vector2(0, 3), r + 1.0, Color(0, 0, 0, 0.3))
	draw_circle(c, r, GLASS)
	draw_arc(c, r - 1.25, 0, TAU, 96, UI.BORDER_DARK, 2.5, true)
	draw_arc(c, r - 1.25, PI * 0.8, PI * 1.7, 48, Color(UI.ACCENT, 0.75), 2.0, true)
	var face := r * 0.74
	var fill := Color(0.06, 0.2, 0.34, 0.9).lerp(Color(0.12, 0.42, 0.62, 0.95), pulse)
	if held: fill = Color(0.22, 0.55, 0.82, 0.95)
	draw_circle(c, face, fill)
	# Lit from the top left, shaded to the bottom right: a raised button.
	draw_arc(c, face - 1.5, PI * 0.85, PI * 1.65, 40, Color(0.7, 0.88, 1.0, 0.55), 3.0, true)
	draw_arc(c, face - 1.5, -PI * 0.15, PI * 0.65, 40, Color(0, 0, 0, 0.35), 3.0, true)
	draw_arc(c, face, 0, TAU, 80, UI.ACCENT.lerp(UI.TEXT_GOOD, pulse) if auto or use else Color(UI.ACCENT, 0.5), 2.0 if not auto else 3.0, true)
	var word := use_label if use else ("AUTO" if auto else "")
	if not word.is_empty():
		draw_string(font, c + Vector2(-face, 6), word, HORIZONTAL_ALIGNMENT_CENTER, face * 2.0, int(clampf(r * 0.3, 12, 20)), INK_LIT)

func _pill(rect: Rect2, lit: bool) -> void:
	var box := StyleBoxFlat.new()
	box.bg_color = GLASS_LIT if lit else GLASS
	box.border_color = UI.ACCENT if lit else UI.BORDER
	box.set_border_width_all(2)
	box.set_corner_radius_all(int(rect.size.y / 2.0))
	box.anti_aliasing = true
	draw_style_box(box, rect)

## The stick: a ring with the four directions marked and a knob on top.
func _draw_stick(font: Font) -> void:
	var c := stick_center
	var r := stick_radius
	var active := stick_id >= 0
	draw_circle(c, r, Color(0.02, 0.06, 0.11, 0.45))
	draw_arc(c, r - 1.25, 0, TAU, 96, UI.TEXT_GOOD if editing and selected == "stick" else UI.BORDER_DARK, 2.5, true)
	draw_arc(c, r - 1.25, PI * 0.8, PI * 1.7, 64, Color(UI.ACCENT, 0.7), 2.0, true)
	draw_arc(c, r * 0.7, 0, TAU, 80, Color(UI.ACCENT, 0.12), 1.0, true)
	for k in 4:
		var d := Vector2.from_angle(k * PI / 2.0)
		var tip := c + d * (r - 9.0)
		var side := d.orthogonal() * r * 0.08
		var arrow := PackedVector2Array([tip, tip - d * r * 0.1 + side, tip - d * r * 0.1 - side])
		var col := Color(UI.ACCENT, 0.9 if active and stick.dot(d) > 0.3 else 0.45)
		draw_colored_polygon(arrow, col)
		arrow.append(tip)
		draw_polyline(arrow, col, 1.0, true)
	var knob := c + stick * r * 0.6
	var kr := r * 0.4
	draw_circle(knob + Vector2(0, 2), kr + 1.0, Color(0, 0, 0, 0.3))
	draw_circle(knob, kr, Color(0.07, 0.24, 0.4, 0.92) if active else Color(0.05, 0.16, 0.28, 0.88))
	draw_arc(knob, kr - 1.25, 0, TAU, 48, UI.BORDER_DARK, 2.5, true)
	draw_arc(knob, kr - 1.5, PI * 0.85, PI * 1.65, 32, Color(0.7, 0.88, 1.0, 0.5), 2.5, true)
	draw_arc(knob, kr * 0.55, 0, TAU, 40, Color(UI.ACCENT, 0.25), 1.0, true)

## A filled shape with a smoothed edge.
func _shape(pts: PackedVector2Array, ink: Color) -> void:
	draw_colored_polygon(pts, ink)
	var edge := pts.duplicate()
	edge.append(pts[0])
	draw_polyline(edge, ink, 1.0, true)

## The buttons' marks, drawn at any size in the spirit of the J2ME HUD's
## icons; `h` is half the mark's height.
func _glyph(action: String, c: Vector2, h: float, ink: Color) -> void:
	var w := maxf(2.0, h * 0.2)
	match action:
		"pause":
			for x in [-0.42, 0.14]:
				_shape(PackedVector2Array([c + Vector2(x, -0.75) * h, c + Vector2(x + 0.28, -0.75) * h, c + Vector2(x + 0.28, 0.75) * h, c + Vector2(x, 0.75) * h]), ink)
		"action_menu":
			for k in 3:
				var y := (-0.6 + k * 0.6) * h
				draw_line(c + Vector2(-0.7 * h, y), c + Vector2(0.7 * h, y), ink, w, true)
		"next_target":
			# The lock brackets of the HUD, with the aim point inside.
			var e := 0.85 * h
			var l := 0.4 * h
			for sx in [-1.0, 1.0]:
				for sy in [-1.0, 1.0]:
					var corner := c + Vector2(sx, sy) * e
					draw_polyline(PackedVector2Array([corner - Vector2(sx * l, 0), corner, corner - Vector2(0, sy * l)]), ink, w, true)
			draw_circle(c, h * 0.16, ink)
		"autopilot":
			# The original's autopilot mark: a pointed A.
			draw_polyline(PackedVector2Array([c + Vector2(-0.7, 0.85) * h, c + Vector2(0, -0.85) * h, c + Vector2(0.7, 0.85) * h]), ink, w * 1.2, true)
			draw_line(c + Vector2(-0.3, 0.3) * h, c + Vector2(0.3, 0.3) * h, ink, w, true)
		"secondary":
			# A missile, nose up and to the right.
			var d := Vector2(1, -1).normalized()
			var n := d.orthogonal()
			_shape(PackedVector2Array([c + d * h * 0.95, c + d * h * 0.55 + n * h * 0.2, c - d * h * 0.6 + n * h * 0.2,
				c - d * h * 0.6 - n * h * 0.2, c + d * h * 0.55 - n * h * 0.2]), ink)
			for side in [1.0, -1.0]:
				_shape(PackedVector2Array([c - d * h * 0.3 + n * h * 0.2 * side, c - d * h * 0.85 + n * h * 0.5 * side, c - d * h * 0.6 + n * h * 0.2 * side]), ink)
		"time_warp":
			# Fast forward: two arrowheads.
			for x in [-0.72, 0.0]:
				_shape(PackedVector2Array([c + Vector2(x, -0.6) * h, c + Vector2(x + 0.72, 0) * h, c + Vector2(x, 0.6) * h]), ink)
		"boost":
			# Two chevrons pointing ahead.
			for y in [-0.05, 0.55]:
				draw_polyline(PackedVector2Array([c + Vector2(-0.65, y + 0.25) * h, c + Vector2(0, y - 0.4) * h, c + Vector2(0.65, y + 0.25) * h]), ink, w * 1.2, true)
		"rear_view":
			# Turning about: an arc with its arrowhead.
			var rr := 0.62 * h
			draw_arc(c, rr, -PI * 0.1, PI * 1.35, 28, ink, w, true)
			var end := c + Vector2.from_angle(-PI * 0.1) * rr
			var t := Vector2.from_angle(-PI * 0.1 + PI / 2.0)
			_shape(PackedVector2Array([end + t * h * 0.38, end - t.orthogonal() * h * 0.3, end + t.orthogonal() * h * 0.3]), ink)
