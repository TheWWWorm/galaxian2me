extends Control
## Flight HUD: the original's crosshair, brackets, lock-on scan and radar
## icons set in translucent instrument plates: location and objective, hull,
## armour, shield and booster, the weapon bank, the target, a radar scope,
## and labelled markers with edge arrows for objects out of view.

const SafeMargins := preload("res://src/presentation/safe_margins.gd")
const UI := preload("res://src/presentation/ui.gd")
const Body := preload("res://src/flight/body.gd")
const Catalogue := preload("res://src/content/catalogue.gd")
const Prefs := preload("res://src/presentation/preferences.gd")

const SCALE := 2.0

var app
var space
var view
var messages: Array = []
var paused := false
var pause_panel: Control
var pause_layer: Control
var font: Font
var touch_layout := false
## The touch controls, to keep the radio box clear of their top row.
var touch = null
## Whether a radio line is up, and a clock or score sits at the top centre.
var radio_showing := false
## The radio box's lower edge, which the readouts below it keep clear of.
var radio_bottom := 0.0
## The lowest edge of the panels along the top (last frame's, and this
## frame's as it is drawn); the transform _shift last set.
var top_stack := 0.0
var _stack_now := 0.0
var _shift_by := Vector2.ZERO
var top_readout := false
## False while a box over the flight takes Enter (the flight screen sets it).
var skip_hint := true
var _note_for := ""
var _note := ""
## Text goes on its own layer with smooth filtering: the HUD itself samples
## the original's pixel art crisply, which would make small glyphs uneven
## at fractional window scales.
var text_layer := Control.new()

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	font = get_theme_default_font()
	text_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	text_layer.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	text_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(text_layer, false, Node.INTERNAL_MODE_FRONT)
	space.event.connect(_on_event)

## Recent hits, remembered by where they came from, fading over a second.
var hits: Array = []
const HIT_TIME := 1.2

## The original's hull alarm: blinking for three seconds after the hull
## itself takes damage.
var last_hull := -1
var hull_alarm := 0.0

func _process(delta: float) -> void:
	if space != null and space.player != null:
		var hull: int = space.player.hull
		if last_hull >= 0 and hull < last_hull and space.player.hull_max < 999999: hull_alarm = 3.0
		last_hull = hull
	hull_alarm = maxf(0.0, hull_alarm - delta)
	for h in hits: h.time -= delta
	hits = hits.filter(func(h): return h.time > 0.0)
	for m in messages: m.time -= delta
	messages = messages.filter(func(m): return m.time > 0.0)
	queue_redraw()

func message(text: String, time := 3.0) -> void:
	# As in the original, a message already showing is not repeated; it
	# just stays up longer.
	for m in messages:
		if m.text == text:
			m.time = maxf(float(m.time), time * Prefs.message_time(app))
			return
	messages.append({"text": text, "time": time * Prefs.message_time(app)})
	while messages.size() > 4: messages.pop_front()

func _on_event(kind: String, data: Dictionary) -> void:
	match kind:
		"docking": message(app.library.text(40) + " " + space.station.name, 3.0)
		"gate_menu": message(app.library.text(241), 3.0)
		"hit":
			if hits.size() > 6: hits.pop_front()
			hits.append({"from": data.get("from", Vector3.ZERO), "time": HIT_TIME})
		"killed": pass

func _tex(name: String) -> Texture2D:
	return app.library.texture(name)

func _draw_tex(name: String, pos: Vector2, centered := true, modulate := Color.WHITE) -> void:
	var t := _tex(name)
	if t == null: return
	var s := t.get_size() * SCALE
	draw_texture_rect(t, Rect2(pos - (s / 2.0 if centered else Vector2.ZERO), s), false, modulate)

func _draw_region(name: String, region: Rect2, pos: Vector2, centered := true) -> void:
	var t := _tex(name)
	if t == null: return
	var s := region.size * SCALE
	draw_texture_rect_region(t, Rect2(pos - (s / 2.0 if centered else Vector2.ZERO), s), region)

func _standing(b: Body) -> String:
	if b.kind in [Body.Kind.STATION, Body.Kind.GATE, Body.Kind.STAR, Body.Kind.WORMHOLE, Body.Kind.MOTHERSHIP]: return "waypoint"
	if b.kind == Body.Kind.ASTEROID or b.kind == Body.Kind.LOOT: return "neutral"
	if b.hostile: return "enemy"
	if b.friendly: return "friend"
	return "neutral"

func _screen(p: Vector3) -> Variant:
	var cam: Camera3D = view.camera
	var world: Vector3 = p * view.UNIT
	# A point on the camera plane is not "behind" it but cannot be projected.
	if cam.to_local(world).z >= -cam.near: return null
	return cam.unproject_position(world)

## Where the guns point on screen. The original projects the point five
## (4096-scaled) direction lengths ahead of the ship, or of the turret, so
## the crosshair sits on the line of fire rather than at the screen centre,
## which the chase camera aims above the ship.
func aim_point(fallback: Vector2) -> Vector2:
	if view == null or space.player == null: return fallback
	var p = space.player
	var origin: Vector3 = p.pos + p.basis * Vector3(0, 900, 0) if space.turret_mode else p.pos
	var at = _screen(origin + space.aim_direction() * 5.0 * 4096.0)
	return at if at != null else fallback

func countdown_remaining_ms() -> int:
	if space == null or space.story == null: return -1
	var remaining: int = space.story.probe_remaining_ms()
	if remaining < 0: remaining = space.story.escape_remaining_ms()
	if remaining < 0: remaining = space.story.job_remaining_ms()
	return remaining

func wingmen_remaining_ms() -> int:
	if space == null or space.game.session.flags.get("wingmen", []).is_empty(): return -1
	return int(space.game.session.flags.get("wingmen_remaining_ms", 0))

## Sizes follow the window height so the instruments stay legible on large
## displays without crowding small ones.
var k := 1.0
const MARGIN := 14.0
const PANEL := Color(0.02, 0.07, 0.12, 0.55)
const RULE := Color(0.25, 0.45, 0.62, 0.45)
const LABEL := Color8(0x7f, 0xa9, 0xcc)
const ACCENT := Color8(0x5c, 0xb8, 0xff)
var ENEMY := Color8(0xff, 0x6a, 0x4f)
var FRIEND := Color8(0x6a, 0xd8, 0x74)
var NEUTRAL := Color8(0xd8, 0xd0, 0x9a)
var WAYPOINT := Color8(0x7c, 0xc4, 0xff)
const ARMOR_COLOR := Color8(0xd9, 0xb2, 0x62)
const SHIELD_COLOR := Color8(0x5c, 0xb8, 0xff)
const HULL_COLOR := Color8(0x8e, 0xd6, 0x8a)
const RADAR_REACH := 60000.0
## The way to the chosen destination.
const COURSE := Color8(0xf2, 0xc2, 0x4e)

func _draw() -> void:
	RenderingServer.canvas_item_clear(text_layer.get_canvas_item())
	if space == null or space.player == null: return
	if space.portal_arriving(): return
	if space.using_jump_drive and space.jumping >= 0: return
	var size := get_viewport_rect().size
	k = clampf(minf(size.x, size.y) / 800.0 * 0.85, 0.72, 1.4) * Prefs.hud_scale(app)
	if space.starting():
		_draw_start(size)
		return
	self_modulate.a = Prefs.hud_opacity(app)
	text_layer.self_modulate.a = self_modulate.a
	var colours: Dictionary = Prefs.palette(app)
	ENEMY = colours.enemy
	FRIEND = colours.friend
	NEUTRAL = colours.neutral
	WAYPOINT = colours.waypoint
	var centre := size / 2.0
	var story = space.story
	var radio_line: Dictionary = space.radio
	if story != null and not story.message().is_empty(): radio_line = story.message()
	var radio_on := not radio_line.is_empty()
	radio_showing = radio_on
	top_stack = _stack_now
	_stack_now = 0.0
	radio_bottom = _radio_rect(size, radio_line).end.y if radio_on else 0.0
	top_readout = countdown_remaining_ms() >= 0 or _challenge() or space.mining != null
	if story != null:
		if story.flash > 0.0:
			var peak := 0.25 if Prefs.reduce_flashing(app) else 1.0
			draw_rect(Rect2(Vector2.ZERO, size), Color(1, 1, 1, clampf(story.flash, 0.0, peak)))
		if story.hud_hidden: _draw_radio(size, radio_line)
		if not touch_layout and skip_hint and (story.can_skip_wait() or radio_on and story.hud_hidden):
			_centered(Vector2(size.x / 2.0, size.y - 28.0 * k), "Enter / click / A: skip", 12, Color(UI.TEXT_DIM, 0.8), true)
		if story.hud_hidden: return
	# Looking around moves the view off the ship's line of fire.
	if view == null or (absf(view.look_yaw) < 0.15 and absf(view.look_pitch) < 0.15):
		_draw_tex("hud_crosshair_png24", aim_point(centre))
	_draw_hits(centre)
	_draw_hull_alarm(size)
	_draw_markers(size)
	_draw_tractor(centre)
	# The instrument panels keep clear of a phone's notch; the markers above
	# stay over the 3D view they point into.
	var safe := SafeMargins.margins(size, touch_layout)
	area = size - Vector2(safe.side * 2.0, safe.top + safe.bottom)
	_shift(Vector2(safe.side, safe.top))
	# The opening fight keeps only the crosshair and the markers over ships:
	# the original's intro never turns its HUD on (hud.drawUI), and it has
	# no radar scope at all.
	var radar_only: bool = story != null and story.radar_only
	if not radar_only and original_style():
		_draw_original(area)
	elif not radar_only:
		_draw_location()
		_draw_vitals(area)
		_draw_weapons(area)
		if bool(app.setting("interface", "radar_scope", true)): _draw_radar(area)
		_draw_target(area)
	if space.mining != null: _draw_mining(area)
	_shift(Vector2.ZERO)
	_draw_radio(size, radio_line)
	# Messages sit under the radio box, clear of the crosshair.
	var y := (radio_bottom + 22.0 * k if radio_on else 130.0 * k) + (58.0 * k if radio_on and top_readout else 0.0)
	if hull_alarm > 0.0: y = maxf(y, alarm_bottom() + 24.0 * k)
	for m in messages:
		var alpha := clampf(float(m.time) / 0.5, 0.0, 1.0)
		_centered(Vector2(size.x / 2.0, y), str(m.text), 15, Color(UI.TEXT, alpha), true)
		y += 22.0 * k
	if space.autopilot:
		var pilot: String = app.library.text(292).to_upper()
		if space.time_scale > 1: pilot += "  ×%d" % space.time_scale
		elif not touch_layout and space.time_warp_allowed(): pilot += "  ·  %s: faster" % Prefs.key_name("time_warp")
		_centered(Vector2(size.x / 2.0, centre.y + 64 * k), pilot, 12, FRIEND, true)
	var hint := action_hint() if bool(app.setting("interface", "hints", true)) else ""
	if not hint.is_empty():
		# Above the crosshair: the original captions landmarks below and right of it.
		_centered(aim_point(centre) - Vector2(0, 34 * k), hint, 12, Color(UI.TEXT, 0.9), true)
	if bool(app.setting("interface", "hints", true)) and not touch_layout and space.target == null:
		var four: Array = ["steer_up", "steer_left", "steer_down", "steer_right"].map(func(a): return Prefs.key_name(a))
		var keys_text: String = "/".join(four)
		if four == ["Up", "Left", "Down", "Right"]: keys_text = "Arrows"
		elif four == ["W", "A", "S", "D"]: keys_text = "WASD"
		var steer := ("Mouse / " if not touch_layout else "") + keys_text
		var keys := "%s steer  ·  %s fire  ·  %s boost  ·  %s autopilot  ·  %s target  ·  %s actions" % [steer,
			Prefs.key_name("fire"), Prefs.key_name("boost"), Prefs.key_name("autopilot"),
			Prefs.key_name("next_target"), Prefs.key_name("action_menu")]
		var room := size.x - 2.0 * (320.0 * k + MARGIN * 2.0)
		var foot := size.y - MARGIN - 4 * k
		if room > 200.0:
			_string(Vector2(size.x / 2.0 - room / 2.0, foot), keys,
				HORIZONTAL_ALIGNMENT_CENTER, room, _px(11), Color(UI.TEXT_DIM, 0.75))

# ------------------------------------------------------------------ drawing kit

## One of the original's 15-pixel HUD state icons (hud_icons.png): 1/2
## autopilot on/off, 4/5 boost ready/charging, 7/9 cargo space/full, 11/12
## cloak on/off, 14/15 auto fire on/off.
func _icon(frame: int, at: Vector2, extent: float, fill := 1.0) -> void:
	var sheet := _tex("hud_icons")
	if sheet == null: return
	var cell := float(sheet.get_height())
	var src := Rect2(frame * cell, 0, cell, cell)
	if fill >= 1.0:
		draw_texture_rect_region(sheet, Rect2(at, Vector2(extent, extent)), src)
		return
	# Partially filled: the lit frame rises from the bottom, as the original
	# clips its boost and cloak icons.
	var f := clampf(fill, 0.0, 1.0)
	draw_texture_rect_region(sheet, Rect2(at + Vector2(0, extent * (1.0 - f)), Vector2(extent, extent * f)),
		Rect2(src.position + Vector2(0, cell * (1.0 - f)), Vector2(cell, cell * f)))

## The instrument panels' share of the screen, inside the safe margins.
var area := Vector2.ZERO

## Moves the following drawing, text included, by `by`.
func _shift(by: Vector2) -> void:
	_shift_by = by
	draw_set_transform(by)
	RenderingServer.canvas_item_add_set_transform(text_layer.get_canvas_item(), Transform2D(0.0, by))

func _px(n: float) -> int:
	return int(round(n * k))

func _string(at: Vector2, value: String, align := HORIZONTAL_ALIGNMENT_LEFT, width := -1.0, px := 16, color := Color.WHITE) -> void:
	font.draw_string(text_layer.get_canvas_item(), at, value, align, width, px, color)

func _text(at: Vector2, value: String, px: float, color: Color, width := -1.0, align := HORIZONTAL_ALIGNMENT_LEFT) -> void:
	_string(at, value, align, width, _px(px), color)

func _centered(at: Vector2, value: String, px: float, color: Color, shadow := false) -> void:
	if shadow: _string(at + Vector2(1, 1) - Vector2(400, 0), value, HORIZONTAL_ALIGNMENT_CENTER, 800, _px(px), Color(0, 0, 0, color.a * 0.8))
	_string(at - Vector2(400, 0), value, HORIZONTAL_ALIGNMENT_CENTER, 800, _px(px), color)

func _width(value: String, px: float) -> float:
	return font.get_string_size(value, HORIZONTAL_ALIGNMENT_LEFT, -1, _px(px)).x

## A translucent instrument plate with clipped corners and an accent rule.
func _plate(rect: Rect2, accent := ACCENT) -> void:
	# Panels hanging from the top edge: how far down they reach, so an
	# upright screen's radio box can sit below them.
	if rect.position.y + _shift_by.y < size.y * 0.35: _stack_now = maxf(_stack_now, rect.end.y + _shift_by.y)
	var c := 8.0 * k
	var x := rect.position.x
	var y := rect.position.y
	var w := rect.size.x
	var h := rect.size.y
	var pts := PackedVector2Array([Vector2(x + c, y), Vector2(x + w, y), Vector2(x + w, y + h - c),
		Vector2(x + w - c, y + h), Vector2(x, y + h), Vector2(x, y + c)])
	# No outline: a quiet translucent backing, as the original's HUD keeps
	# its figures floating over the view. The accent survives as a short tick.
	draw_colored_polygon(pts, PANEL)
	draw_line(Vector2(x + c, y + 1), Vector2(x + c + 22 * k, y + 1), Color(accent, 0.55), 2.0)

## A thin segmented gauge filling left to right.
func _gauge(at: Vector2, width: float, frac: float, color: Color, segments := 24) -> void:
	var h := 6.0 * k
	var cell := width / segments
	for i in segments:
		var lit := (float(i) + 0.5) / segments <= clampf(frac, 0.0, 1.0)
		draw_rect(Rect2(at + Vector2(i * cell, 0), Vector2(cell - 1.5, h)), color if lit else Color(color, 0.16))

func _standing_color(b: Body) -> Color:
	match _standing(b):
		"enemy": return ENEMY
		"friend": return FRIEND
		"waypoint": return WAYPOINT
	return NEUTRAL

## Distances as the original shows them: a tenth of a unit is a metre.
func _metres(units: float) -> String:
	var m := units / 10.0
	return "%.1f km" % (m / 1000.0) if m >= 10000.0 else "%d m" % int(m)

# ------------------------------------------------------------------ panels

## Top left: where you are, the hold and the purse, and what to do next.
func _draw_location() -> void:
	var s = app.game.session
	var cat = app.catalogue
	var w := 330.0 * k
	var place: String = space.station.name if not space.in_void else app.library.text(238)
	var system: String = cat.system_name(s.system_index) if not space.in_void else ""
	var objective := _objective()
	var h := (56.0 if objective.is_empty() else 74.0) * k
	var r := Rect2(Vector2(MARGIN, MARGIN), Vector2(w, h))
	_plate(r)
	location_bottom = r.end.y
	var x := r.position.x + 12 * k
	var title := (system + "  /  " + place) if not system.is_empty() else place
	if not space.in_void:
		# The original's orbit information: faction emblem and safety.
		var sys: Dictionary = cat.system(s.system_index)
		var logo := _tex("logo_%d" % int(sys.get("faction", 0)))
		if logo != null:
			var e := 24.0 * k
			draw_texture_rect(logo, Rect2(Vector2(r.end.x - e - 10 * k, r.position.y + 6 * k), Vector2(e, e)), false, Color(1, 1, 1, 0.85))
		var safety := clampi(int(sys.get("safety", 0)), 0, 3)
		_text(Vector2(r.end.x - 150 * k, r.position.y + 44 * k), "%s: %s" % [app.library.text(220), app.library.text(225 + safety)], 10,
			[ENEMY, NEUTRAL, UI.TEXT_DIM, FRIEND][safety], 100 * k, HORIZONTAL_ALIGNMENT_RIGHT)
	_text(Vector2(x, r.position.y + 19 * k), title.to_upper(), 15, UI.TEXT, w - 90 * k)
	var st: Dictionary = s.ship_stats()
	_text(Vector2(x, r.position.y + 36 * k), "CARGO  %d / %d t" % [s.cargo_used(), int(st.cargo_capacity)], 11, LABEL)
	_text(Vector2(x + 150 * k, r.position.y + 36 * k), UI.money(int(s.credits)), 11, UI.TEXT_GOOD)
	var fill := float(s.cargo_used()) / maxf(1.0, float(st.cargo_capacity))
	_gauge(Vector2(x, r.position.y + 42 * k), 130 * k, fill, WAYPOINT if fill < 1.0 else UI.TEXT_WARN, 20)
	if not objective.is_empty():
		_text(Vector2(x, r.position.y + 66 * k), objective, 12, NEUTRAL, w - 24 * k)
	_draw_readouts()

## Top centre: the job's clock, the contest's score or the hold while mining.
func _draw_readouts() -> void:
	var s = app.game.session
	var remaining := countdown_remaining_ms()
	var size := area
	# Under the radio box while someone is talking.
	var top := radio_bottom + 2.0 if radio_showing else 0.0
	if remaining >= 0:
		var seconds := int(ceil(remaining / 1000.0))
		var clock := "%02d:%02d" % [seconds / 60, seconds % 60]
		_centered(Vector2(size.x / 2.0, top + 30 * k), clock, 22, UI.TEXT_WARN if seconds < 10 else UI.TEXT, true)
	elif _challenge():
		# The contest's running score: your kills against the rival's.
		_centered(Vector2(size.x / 2.0, top + 30 * k), "%d : %d" % [int(space.kills), int(space.stats.get("rival_kills", 0))], 22, UI.TEXT, true)
		_centered(Vector2(size.x / 2.0, top + 50 * k), "KILLS  YOU : RIVAL", 11, UI.TEXT_DIM, true)
	if space.mining != null:
		var st2: Dictionary = s.ship_stats()
		var load: int = s.cargo_used() + int(space.mining.tons)
		_centered(Vector2(size.x / 2.0, top + 30 * k), "%d / %d t" % [load, int(st2.cargo_capacity)], 18, UI.TEXT_WARN if load > int(st2.cargo_capacity) else UI.TEXT, true)

## The original's own HUD (the default): its corner panels and state icons,
## the armour and shield bars at the foot, the chosen secondary weapon and
## the hull in percent once damaged. "Extended" keeps the fuller plates.
func original_style() -> bool:
	return str(app.setting("interface", "hud_style", "original")) == "original"

## The original's start sequence: the orbit information at the top left
## (faction emblem, station, system and its safety) and one of the loading
## tips in a box along the bottom; no other HUD.
func _draw_start(size: Vector2) -> void:
	var s = app.game.session
	var cat = app.catalogue
	var sys: Dictionary = cat.system(s.system_index)
	var x := float(MARGIN)
	var y := float(MARGIN)
	var logo := _tex("logo_%d" % int(sys.get("faction", 0)))
	if logo != null:
		var e := logo.get_size() * 1.5 * k
		draw_texture_rect(logo, Rect2(Vector2(x, y), e), false)
		x += e.x + 10 * k
	var line := 20.0 * k
	_text(Vector2(x, y + line * 0.8), str(space.station.name) if space.station != null else "", 16, UI.TEXT, 400 * k)
	_text(Vector2(x, y + line * 1.8), "%s %s" % [cat.system_name(s.system_index), app.library.text(41)], 13, UI.TEXT_DIM, 400 * k)
	var safety := clampi(int(sys.get("safety", 0)), 0, 3)
	_text(Vector2(x, y + line * 2.8), "%s: %s" % [app.library.text(220), app.library.text(225 + safety)], 13, UI.TEXT_DIM, 400 * k)
	if space.start_tip < 0: return
	var font := get_theme_default_font()
	var fs := int(14 * k)
	var w := minf(size.x - 2.0 * MARGIN, 900 * k)
	var tip: String = app.library.text(space.start_tip)
	var text_h := font.get_multiline_string_size(tip, HORIZONTAL_ALIGNMENT_LEFT, w - 24 * k, fs).y
	var box := Rect2(Vector2((size.x - w) / 2.0, size.y - MARGIN - text_h - 44 * k), Vector2(w, text_h + 44 * k))
	_plate(box)
	_text(Vector2(box.position.x + 12 * k, box.position.y + 20 * k), app.library.text(277), 14, UI.TEXT, w - 24 * k)
	draw_multiline_string(font, box.position + Vector2(12 * k, 36 * k + fs * 0.8), tip, HORIZONTAL_ALIGNMENT_LEFT, w - 24 * k, fs, -1, UI.TEXT_DIM)

func _draw_original(size: Vector2) -> void:
	var p: Body = space.player
	var s = app.game.session
	var st: Dictionary = s.ship_stats()
	# The original's 240-pixel-wide screen, scaled to this one.
	var S := clampf(minf(size.x, size.y) / 240.0 * 0.6, 1.5, 4.0) * Prefs.hud_scale(app)
	var ul := _tex("hud_panel_upper_left_png24")
	var ll := _tex("hud_panel_lower_left_png24")
	var ll_size := ll.get_size() * S if ll != null else Vector2(60, 20) * S
	if ul != null: _mirrored_pair(ul, Vector2.ZERO, ul.get_size() * S, size.x)
	if ll != null: _mirrored_pair(ll, Vector2(0, size.y - ll_size.y), ll_size, size.x)
	_stack_now = maxf(_stack_now, (ul.get_height() * S if ul != null else 0.0) + _shift_by.y)
	var ic := 15.0 * S
	var gap := 2.0 * S
	# Top left: booster (refilling while it recharges), autopilot, auto fire.
	if int(st.boost_length) > 0:
		var rate := 1.0
		if not p.boosting and not space.boost_ready:
			rate = clampf(1.0 + float(space.boost_time) / maxf(1.0, float(st.boost_reload)), 0.0, 1.0)
		_icon(5 if rate < 1.0 else 4, Vector2(gap, gap), ic)
		if rate < 1.0: _icon(4, Vector2(gap, gap), ic, rate)
	_icon(1 if space.autopilot else 2, Vector2(gap * 2.0 + ic, gap), ic)
	var armed := p.weapons.any(func(w): return w.kind == "gun" or w.kind == "turret")
	if armed: _icon(14 if bool(app.setting("controls", "auto_fire", false)) else 15, Vector2(gap, gap * 2.0 + ic), ic)
	# Top right: the cloak (draining while on, refilling after), the menu
	# mark and the hold (full or not).
	if space.has_cloak():
		var frac: float = 1.0 - space.cloak_progress() if space.cloak > 0 else space.cloak_progress()
		_icon(12, Vector2(size.x - gap - ic, gap), ic)
		_icon(11, Vector2(size.x - gap - ic, gap), ic, frac)
	_icon(17, Vector2(size.x - gap * 2.0 - ic * 2.0, gap), ic)
	_icon(7 if s.cargo_used() < int(st.cargo_capacity) else 9, Vector2(size.x - gap - ic, gap * 2.0 + ic), ic)
	# The foot: armour on the left, shield on the right, each emptying
	# towards the middle of the screen.
	var bar_empty := _tex("hud_hull_bar_empty_png24")
	var bar_full := _tex("hud_hull_bar_full_png24")
	if bar_empty != null and bar_full != null:
		var bs := bar_empty.get_size() * S
		var bar_y := size.y - 13.0 * S - bs.y
		var sym_y := size.y - ll_size.y - 3.0 * S
		if p.armor_max > 0:
			var sym := _tex("hud_symbol_hull_png24")
			if sym != null: draw_texture_rect(sym, Rect2(Vector2(4.0 * S, sym_y - sym.get_height() * S), sym.get_size() * S), false)
			var x0 := ll_size.x - bs.x
			draw_texture_rect(bar_empty, Rect2(Vector2(x0, bar_y), bs), false)
			var f := clampf(float(p.armor) / float(p.armor_max), 0.0, 1.0)
			var src_w := bar_full.get_width() * f
			draw_texture_rect_region(bar_full, Rect2(Vector2(ll_size.x - src_w * S, bar_y), Vector2(src_w * S, bs.y)),
				Rect2(bar_full.get_width() - src_w, 0, src_w, bar_full.get_height()))
		if p.shield_max > 0:
			var sym2 := _tex("hud_symbol_shield_png24")
			if sym2 != null: draw_texture_rect(sym2, Rect2(Vector2(size.x - 4.0 * S - sym2.get_width() * S, sym_y - sym2.get_height() * S), sym2.get_size() * S), false)
			# The armour bar's mirror image on the right.
			var f2 := clampf(p.shield / float(p.shield_max), 0.0, 1.0)
			var src_w2 := bar_full.get_width() * f2
			_mirrored(size.x, func():
				draw_texture_rect(bar_empty, Rect2(Vector2(ll_size.x - bs.x, bar_y), bs), false)
				draw_texture_rect_region(bar_full, Rect2(Vector2(ll_size.x - src_w2 * S, bar_y), Vector2(src_w2 * S, bs.y)),
					Rect2(bar_full.get_width() - src_w2, 0, src_w2, bar_full.get_height())))
	# Bottom left: the chosen secondary weapon and what is left of it.
	var secondary = space.current_secondary()
	if not secondary.is_empty():
		var sheet := _tex("items")
		var line_y := size.y - 2.0 * S
		if sheet != null:
			var cell := sheet.get_width() / float(maxi(1, app.library.data.items.size()))
			var region := Rect2(int(secondary.id) * cell, 0, cell, sheet.get_height())
			var icon_s := region.size * S
			draw_texture_rect_region(sheet, Rect2(Vector2(0, line_y - _px(14) - icon_s.y), icon_s), region)
		_text(Vector2(4.0 * S, line_y), "x%d" % int(secondary.count), 13, UI.TEXT)
	# Bottom centre: the hull once it has taken damage.
	if p.hull_max > 0 and p.hull < p.hull_max and hull_alarm <= 0.0:
		var percent := int(100.0 * p.hull / float(p.hull_max))
		var ship := _tex("hud_hull_alarm_shipicon")
		var base_y := size.y - ll_size.y + 15.0 * S
		if ship != null: draw_texture_rect(ship, Rect2(Vector2(size.x / 2.0 - 4.0 * S - ship.get_width() * S, base_y - ship.get_height() * S), ship.get_size() * S), false)
		_text(Vector2(size.x / 2.0, base_y), "%d%%" % percent, 14, UI.TEXT)
	if space.turret_mode: _centered(Vector2(size.x / 2.0, size.y - ll_size.y - 8.0 * S), "TURRET VIEW", 11, FRIEND, true)
	_draw_current_lock(size, S)
	_draw_readouts()

## A texture at `at` and its mirror image against the screen's right edge.
func _mirrored_pair(tex: Texture2D, at: Vector2, extent: Vector2, width: float) -> void:
	draw_texture_rect(tex, Rect2(at, extent), false)
	_mirrored(width, func(): draw_texture_rect(tex, Rect2(at, extent), false))

## Draws with x mirrored about the middle of a `width`-wide area.
func _mirrored(width: float, paint: Callable) -> void:
	draw_set_transform(_shift_by + Vector2(width, 0), 0.0, Vector2(-1, 1))
	paint.call()
	draw_set_transform(_shift_by)

func _challenge() -> bool:
	var story = space.story
	if story == null: return false
	return str(story.objective.get("kind", "")) == "challenge"

func _objective() -> String:
	var s = app.game.session
	var cat = app.catalogue
	var job: Dictionary = s.job
	if not job.is_empty():
		var returning := bool(job.get("recovered", false))
		var kind: String = app.library.text(Catalogue.STRING_MISSION_TYPES + (11 if returning else int(job.kind)))
		return "▸ %s  →  %s" % [kind, cat.station_name(int(job.station))]
	var m: Dictionary = s.story_mission
	if not m.is_empty() and int(m.get("station", -1)) >= 0:
		return "▸ %s  →  %s" % [app.library.text(278), cat.station_name(int(m.station))]
	var dest: Dictionary = space.game.destination
	if not dest.is_empty() and int(dest.get("station", -1)) >= 0:
		return "▸ %s" % cat.station_name(int(dest.station))
	return ""

## Top right (touch: top left, under the location): hull, armour and shield
## with their values, the booster and any hired pilots' remaining time.
## Where the vitals plate ends (touch puts the weapons under it).
var vitals_bottom := 0.0
## Where the location plate ends (touch stacks the vitals under it).
var location_bottom := 0.0

func _draw_vitals(size: Vector2) -> void:
	var p: Body = space.player
	var s = app.game.session
	var st: Dictionary = s.ship_stats()
	var w := 330.0 * k
	var crew_time := wingmen_remaining_ms()
	var h := (80.0 if crew_time > 0 else 64.0) * k
	var at := Vector2(size.x - MARGIN - w, MARGIN) if not touch_layout else Vector2(MARGIN, location_bottom + 8 * k)
	var r := Rect2(at, Vector2(w, h))
	vitals_bottom = r.end.y
	_plate(r)
	var col := (w - 24 * k) / 3.0
	var rows := [["HULL", p.hull, p.hull_max, HULL_COLOR], ["ARMOR", p.armor, p.armor_max, ARMOR_COLOR],
		["SHIELD", int(p.shield), p.shield_max, SHIELD_COLOR]]
	for i in 3:
		var x := r.position.x + 12 * k + i * col
		var row: Array = rows[i]
		var frac := float(row[1]) / maxf(1.0, float(row[2]))
		var color: Color = row[3]
		if i == 0 and frac < 0.3: color = ENEMY
		_text(Vector2(x, r.position.y + 16 * k), row[0], 10, LABEL)
		if int(row[2]) >= 999999:
			# Scripted scenes make the ship indestructible; no figure to show.
			_text(Vector2(x, r.position.y + 33 * k), "∞", 17, UI.TEXT)
		elif int(row[2]) > 0:
			var value := "%d" % int(row[1])
			_text(Vector2(x, r.position.y + 33 * k), value, 17, UI.TEXT)
			_text(Vector2(x + _width(value, 17) + 3 * k, r.position.y + 33 * k), "/%d" % int(row[2]), 10, UI.TEXT_DIM)
		else:
			_text(Vector2(x, r.position.y + 33 * k), "—", 17, UI.TEXT_DIM)
		_gauge(Vector2(x, r.position.y + 39 * k), col - 12 * k, frac if int(row[2]) > 0 else 0.0, color, 12)
	var y := r.position.y + 57 * k
	var x0 := r.position.x + 12 * k
	if int(st.boost_length) > 0:
		var frac := 1.0
		var label := "BOOST READY"
		var color := FRIEND
		if p.boosting:
			frac = 1.0 - float(space.boost_time) / maxf(1.0, float(st.boost_length))
			label = "BOOSTING"
			color = ACCENT
		elif not space.boost_ready:
			frac = 1.0 + float(space.boost_time) / maxf(1.0, float(st.boost_reload))
			label = "BOOST CHARGING"
			color = UI.TEXT_DIM
		var ic := 16.0 * k
		_icon(5, Vector2(x0, y - ic + 3 * k), ic)
		_icon(4, Vector2(x0, y - ic + 3 * k), ic, frac if not p.boosting else 1.0)
		_text(Vector2(x0 + ic + 5 * k, y), label, 10, color)
		_gauge(Vector2(x0 + 116 * k, y - 7 * k), 110 * k, frac, color, 16)
	else:
		_text(Vector2(x0, y), "NO BOOSTER", 10, UI.TEXT_DIM)
	if space.has_cloak():
		var cx := x0 + 240 * k
		var label := "CLOAK READY" if space.cloak_ready() else ("CLOAKED" if space.cloak > 0 else "CLOAK")
		var color := FRIEND if space.cloak_ready() else (ACCENT if space.cloak > 0 else UI.TEXT_DIM)
		var frac: float = 1.0 - space.cloak_progress() if space.cloak > 0 else space.cloak_progress()
		var ic := 16.0 * k
		_icon(12, Vector2(cx, y - ic + 3 * k), ic)
		_icon(11, Vector2(cx, y - ic + 3 * k), ic, frac)
		_text(Vector2(cx + ic + 4 * k, y), label.replace("CLOAK ", ""), 10, color)
	if crew_time > 0:
		var seconds := int(ceil(crew_time / 1000.0))
		_text(Vector2(x0, y + 17 * k), (app.library.text(152) + "  %02d:%02d" % [seconds / 60, seconds % 60]).to_upper(), 10, FRIEND)

## Bottom left: the weapon bank. Primaries with their reload, the secondary
## launcher's icon and ammunition, and the flight assists.
func _draw_weapons(size: Vector2) -> void:
	var p: Body = space.player
	var guns := {}
	# The launcher the secondary button fires, else the first fitted one.
	var secondary = space.current_secondary()
	if secondary.is_empty():
		var launchers: Array = space.secondary_launchers()
		secondary = launchers[0] if not launchers.is_empty() else null
	for w in p.weapons:
		if w.kind == "gun" or w.kind == "turret":
			var key := int(w.id)
			if not guns.has(key): guns[key] = {"count": 0, "ready": 1.0}
			guns[key].count += 1
			guns[key].ready = minf(guns[key].ready, 1.0 - float(w.cooldown) / maxf(1.0, float(w.reload)))
	var rows := guns.size() + (1 if secondary != null else 0)
	var w := 300.0 * k
	var h := (30.0 + maxi(1, rows) * 20.0) * k
	var r := Rect2(Vector2(MARGIN, size.y - MARGIN - h), Vector2(w, h))
	# Touch: the stick has the bottom left, so the weapons sit under the
	# vitals in the top-left column.
	if touch_layout: r.position.y = vitals_bottom + 8 * k
	_plate(r)
	var x := r.position.x + 12 * k
	var y := r.position.y + 16 * k
	_text(Vector2(x, y), "WEAPONS", 10, LABEL)
	if space.turret_mode: _text(Vector2(x + 70 * k, y), "TURRET VIEW", 10, FRIEND)
	var ic := 16.0 * k
	_icon(1 if space.autopilot else 2, Vector2(r.end.x - 12 * k - ic * 2 - 4 * k, y - ic + 4 * k), ic)
	_icon(14 if bool(app.setting("controls", "auto_fire", false)) else 15, Vector2(r.end.x - 12 * k - ic, y - ic + 4 * k), ic)
	y += 20 * k
	if rows == 0:
		_text(Vector2(x, y), "—", 13, UI.TEXT_DIM)
	for id in guns:
		var g: Dictionary = guns[id]
		var name: String = app.catalogue.item_name(int(id)) if int(id) >= 0 else "Gun"
		_text(Vector2(x, y), ("%d × " % int(g.count)) + name, 13, UI.TEXT, 190 * k)
		_gauge(Vector2(r.end.x - 82 * k, y - 8 * k), 70 * k, g.ready, ACCENT if g.ready >= 1.0 else UI.TEXT_DIM, 8)
		y += 20 * k
	if secondary != null:
		var sheet := _tex("items")
		var ix := x
		if sheet != null:
			var cell := sheet.get_width() / float(maxi(1, app.library.data.items.size()))
			var region := Rect2(int(secondary.id) * cell, 0, cell, sheet.get_height())
			var icon_h := 18.0 * k
			var icon_w := region.size.x / region.size.y * icon_h
			draw_texture_rect_region(sheet, Rect2(Vector2(x, y - icon_h + 3 * k), Vector2(icon_w, icon_h)), region)
			ix += icon_w + 6 * k
		var ammo := int(secondary.count)
		_text(Vector2(ix, y), "%s  ×%d" % [app.catalogue.item_name(int(secondary.id)), ammo], 13, UI.TEXT if ammo > 0 else UI.TEXT_DIM, 200 * k)
		var ready := 1.0 - float(secondary.cooldown) / maxf(1.0, float(secondary.reload))
		_gauge(Vector2(r.end.x - 82 * k, y - 8 * k), 70 * k, ready if ammo > 0 else 0.0, ARMOR_COLOR, 8)

## The original marks an asteroid at the crosshair rather than on the rock:
## the scan animation runs there once the rock has been held for half a
## second, and once locked its last full frame blinks.
func _draw_asteroid_lock(size: Vector2) -> void:
	if space.mining != null or not space.tractor_status().is_empty(): return
	var sheet := _tex("hud_scanprocess_anim_png24")
	if sheet == null: return
	var cell := sheet.get_height()
	var frames := maxi(2, sheet.get_width() / cell)
	var at := aim_point(size / 2.0)
	var frame := -1
	if space.locked:
		if _quick_clock_high(): frame = frames - 2
	elif space.lock_time > 500.0:
		frame = int((frames - 1) * (space.lock_time - 500.0) / maxf(1.0, space.lock_needed - 500.0))
		if frame >= frames - 1: frame = -1
	if frame >= 0: _draw_region("hud_scanprocess_anim_png24", Rect2(frame * cell, 0, cell, cell), at)

## Radar.java's landmark caption beside the bracket: the station's name
## with "Station", its Tec Level and the distance, or a gate's name and
## distance.
func _landmark_label(b: Body, at: Vector2, dist: float) -> void:
	var lines: Array = []
	var x := 50.0 if b.kind == Body.Kind.STATION else 10.0
	if b.kind == Body.Kind.STATION:
		lines.append("%s %s" % [b.name, app.library.text(40)])
		var st: Dictionary = app.catalogue.station(int(app.game.session.station_id)) if b == space.station else {}
		if not st.is_empty(): lines.append("%s: %d" % [app.library.text(37), int(st.get("tech", 0))])
	else:
		lines.append(b.name)
	lines.append(_metres(dist))
	for i in lines.size():
		var spot := at + Vector2(x, 12.0 + i * 20.0) * k
		# A dark shadow keeps the caption readable over a lit hull.
		_text(spot + Vector2(1, 1), str(lines[i]), 11, Color(0, 0, 0, 0.85))
		_text(spot, str(lines[i]), 11, UI.TEXT)

## The original's quick blink: on for the second half of every 600 ms.
func _quick_clock_high() -> bool:
	return Time.get_ticks_msec() % 600 >= 300

## The original's current lock at the bottom right of its HUD: an asteroid's
## ore, class and name; a ship's race, name and hull; a station's name.
func _draw_current_lock(size: Vector2, S: float) -> void:
	var t: Body = space.target
	if t == null or not t.alive or not space.locked: return
	var right := size.x - 2.0 * S
	var base := size.y - _px(14) - 2.0 * S
	var label := ""
	if t.kind == Body.Kind.ASTEROID:
		var classes := _tex("hud_meteor_class")
		if classes != null:
			var c := 11.0
			var frame := clampi(7 - int(t.ore_class), 0, int(classes.get_width() / c) - 1)
			draw_texture_rect_region(classes, Rect2(Vector2(right - c * S, size.y - 2.0 * S - c * S), Vector2(c, c) * S), Rect2(frame * c, 0, c, c))
			right -= (c + 2.0) * S
		var items := _tex("items")
		if items != null and t.ore >= 0:
			var cw := items.get_width() / float(maxi(1, app.library.data.items.size()))
			var region := Rect2(int(t.ore) * cw, 0, cw, items.get_height())
			draw_texture_rect_region(items, Rect2(Vector2(size.x - 2.0 * S - region.size.x * S, base - region.size.y * S), region.size * S), region)
		label = app.catalogue.item_name(int(t.ore))
	elif t.is_ship():
		label = (t.name if not t.name.is_empty() else app.library.text(270)) + " %d%%" % int(100.0 * t.hull / maxf(1.0, float(t.hull_max)))
	elif t.kind != Body.Kind.STAR:
		label = t.name
	if not label.is_empty():
		_string(Vector2(right - 400.0, base + _px(12)), label, HORIZONTAL_ALIGNMENT_RIGHT, 400.0, _px(12), UI.TEXT)

## What the fire button does to the locked station, gate or asteroid, or
## that holding it in the crosshair locks it; empty when nothing applies.
func action_hint() -> String:
	var t: Body = space.target
	if t == null or not t.alive or t.is_ship() or space.autopilot or space.mining != null: return ""
	if not space.locked:
		# Asteroids drift across the reticle all the time in a field; only
		# places to fly to get the reminder.
		return "Hold it in the crosshair to lock on" if t.kind in [Body.Kind.STATION, Body.Kind.GATE, Body.Kind.WORMHOLE] else ""
	var what: String = {"dock": "fly in and dock", "gate": "fly into the gate",
		"wormhole": "fly into the wormhole", "mine": "mine"}.get(space.target_action(), "")
	if what.is_empty(): return ""
	var press := "Fire" if touch_layout else "%s / left click / RT" % Prefs.key_name("fire")
	return "%s: %s" % [press, what]

## Bottom centre: the locked or selected object.
func _draw_target(size: Vector2) -> void:
	var t: Body = space.target
	if t == null or not t.alive: return
	var p: Body = space.player
	var w := 340.0 * k
	var ship := t.is_ship()
	var cargo: Dictionary = space.scanned_cargo() if ship else {}
	var h := (58.0 if ship else 40.0) * k + (16.0 * k if not cargo.is_empty() else 0.0)
	var r := Rect2(Vector2(size.x / 2.0 - w / 2.0, size.y - MARGIN - h), Vector2(w, h))
	var color := _standing_color(t)
	_plate(r, color)
	var x := r.position.x + 12 * k
	var label: String = t.name if not t.name.is_empty() else app.library.text(270)
	_text(Vector2(x, r.position.y + 18 * k), label.to_upper(), 14, color, w - 120 * k)
	var dist := p.pos.distance_to(t.pos) if t.kind != Body.Kind.STAR else -1.0
	if dist >= 0.0:
		_text(Vector2(r.end.x - 112 * k, r.position.y + 18 * k), _metres(dist), 13, UI.TEXT, 100 * k, HORIZONTAL_ALIGNMENT_RIGHT)
	var status := "LOCKED" if space.locked else "SCANNING %d%%" % int(clampf(space.lock_time / space.lock_needed, 0.0, 1.0) * 100)
	_text(Vector2(x, r.position.y + 32 * k), status, 10, FRIEND if space.locked else LABEL)
	if ship:
		if t.disabled: _text(Vector2(x + 110 * k, r.position.y + 32 * k), "EMP DISABLED", 10, SHIELD_COLOR)
		var gw := (w - 36 * k) / 2.0
		var hull_frac := float(t.hull + t.armor) / maxf(1.0, float(t.hull_max + t.armor_max))
		_text(Vector2(x, r.position.y + 49 * k), "HULL", 9, LABEL)
		_gauge(Vector2(x + 34 * k, r.position.y + 42 * k), gw - 34 * k, hull_frac, ENEMY if t.hostile else HULL_COLOR, 14)
		if t.shield_max > 0:
			_text(Vector2(x + gw + 12 * k, r.position.y + 49 * k), "SHLD", 9, LABEL)
			_gauge(Vector2(x + gw + 46 * k, r.position.y + 42 * k), gw - 34 * k, t.shield / maxf(1.0, float(t.shield_max)), SHIELD_COLOR, 14)
		if not cargo.is_empty():
			var parts: Array = []
			var pairs: Array = cargo.get("pairs", [])
			for p_i in range(0, pairs.size() - 1, 2):
				if int(pairs[p_i + 1]) > 0: parts.append("%d × %s" % [int(pairs[p_i + 1]), app.catalogue.item_name(int(pairs[p_i]))])
			var description := "—" if parts.is_empty() else ",  ".join(parts)
			_text(Vector2(x, r.position.y + 67 * k), "CARGO  " + description, 11, UI.TEXT_GOOD, w - 24 * k)

func _draw_tractor(centre: Vector2) -> void:
	var tractor: Dictionary = space.tractor_status()
	if tractor.is_empty(): return
	if tractor.phase == "charging" and int(tractor.elapsed_ms) > 500:
		var sheet := _tex("hud_scanprocess_anim_png24")
		if sheet != null:
			var frames := maxi(1, sheet.get_width() / sheet.get_height() - 2)
			var frame := mini(frames - 1, int(float(tractor.progress) * frames))
			var cell := sheet.get_height()
			_draw_region("hud_scanprocess_anim_png24", Rect2(frame * cell, 0, cell, cell), centre)
	var caption: String = app.catalogue.item_name(int(tractor.equipment)) + "  %d%%" % int(float(tractor.progress) * 100.0)
	_centered(Vector2(centre.x, centre.y + 90 * k), caption, 14, UI.TEXT_GOOD, true)

func _draw_hull_alarm(size: Vector2) -> void:
	if hull_alarm <= 0.0 or fmod(hull_alarm, 0.4) < 0.2: return
	var p: Body = space.player
	var percent := int(100.0 * p.hull / maxf(1.0, float(p.hull_max)))
	var art := _tex("hud_hull_alarm")
	# Under the radio box and the clock or score, the percentage beside it
	# in the original's alarm digits (13x12 frames: 0-9, then %).
	var y := alarm_top()
	var digits := _tex("hud_hull_alarm_numbers")
	var s2 := art.get_size() * 2.0 * k if art != null else Vector2.ZERO
	var frames := [mini(percent, 99) / 10, mini(percent, 99) % 10, 10]
	var cell := Vector2(13, 12) * 2.0 * k
	var lw := cell.x * 3.0 if digits != null else _width("%d%%" % percent, 24)
	var x := size.x / 2.0 - (s2.x + 12.0 * k + lw) / 2.0
	if art != null: draw_texture_rect(art, Rect2(Vector2(x, y), s2), false)
	x += s2.x + 12.0 * k
	if digits == null:
		_centered(Vector2(x + lw / 2.0, y + s2.y / 2.0 + _px(24) * 0.35), "%d%%" % percent, 24, ENEMY, true)
		return
	var top := y + (s2.y - cell.y) / 2.0
	for i in frames.size():
		draw_texture_rect_region(digits, Rect2(Vector2(x + i * cell.x, top), cell), Rect2(int(frames[i]) * 13, 0, 13, 12))

## The top of the hull alarm, and the line under it where messages start.
func alarm_top() -> float:
	return (radio_bottom + 2.0 if radio_showing else 0.0) + (72.0 if top_readout else 16.0) * k

func alarm_bottom() -> float:
	var art := _tex("hud_hull_alarm")
	return alarm_top() + maxf(art.get_height() * 2.0 * k if art != null else 0.0, 28.0 * k)

## Where recent hits came from, as arcs around the crosshair: up is ahead
## and above, the sides are the ship's sides, a hit from behind shows low.
func _draw_hits(centre: Vector2) -> void:
	if hits.is_empty(): return
	var p: Body = space.player
	var inv := p.basis.inverse()
	var radius := 120.0 * k
	for h in hits:
		var local: Vector3 = inv * ((h.from as Vector3) - p.pos)
		if local.length_squared() < 1.0: continue
		# Screen bearing: the ship's left (+x) is screen left, above is up;
		# a source behind the ship pushes the arc towards the bottom.
		var dir := Vector2(-local.x, -local.y)
		if local.z < 0.0: dir.y += -local.z
		if dir.length_squared() < 0.0001: dir = Vector2(0, 1)
		var angle := dir.angle()
		var alpha := clampf(float(h.time) / HIT_TIME, 0.0, 1.0)
		draw_arc(centre, radius, angle - 0.35, angle + 0.35, 24, Color(ENEMY, 0.85 * alpha), 5.0 * k, true)
		draw_arc(centre, radius + 8 * k, angle - 0.22, angle + 0.22, 16, Color(ENEMY, 0.4 * alpha), 2.0 * k, true)

# ------------------------------------------------------------------ markers

## The original's brackets on ships and the lock-on frame on the target, a
## name and range label on navigation objects, and arrows at the screen edge
## towards the target, the station and nearby threats that are out of view.
## Edge captions drawn this frame, so the next one steps aside.
var edge_labels: Array[Rect2] = []

func _draw_markers(size: Vector2) -> void:
	edge_labels.clear()
	var p: Body = space.player
	var t: Body = space.target
	var edge := Rect2(Vector2(70, 70) * k, size - Vector2(140, 190) * k)
	if touch_layout:
		# Keep edge markers clear of the stick and the button column.
		var side := maxf(70.0 * k, size.x * 0.19)
		edge = Rect2(Vector2(side, 70.0 * k), size - Vector2(side * 2.0, 190.0 * k))
	var course: Body = space.course_body()
	for b in space.bodies:
		if b == p or not b.alive: continue
		if not b.visible and b.kind != Body.Kind.STAR: continue
		if b.kind == Body.Kind.LOOT:
			# The original's box bracket on wreck crates in view and range,
			# so they can be put under the crosshair for the tractor.
			if b.model == "box" and p.pos.distance_to(b.pos) <= 24000.0:
				var spot = _screen(b.pos)
				if spot != null and Rect2(Vector2.ZERO, size).has_point(spot): _draw_tex("bracket_box", spot)
			continue
		if b.kind == Body.Kind.ASTEROID and b == t: _draw_asteroid_lock(size)
		if b.kind in [Body.Kind.ARRIVAL, Body.Kind.ASTEROID]: continue
		var is_target: bool = b == t
		var on_course: bool = b == course and not is_target
		if b.kind == Body.Kind.STAR and not is_target and not on_course and not original_style(): continue
		var nav: bool = b.kind in [Body.Kind.STATION, Body.Kind.GATE, Body.Kind.WORMHOLE, Body.Kind.MOTHERSHIP]
		var threat: bool = b.is_ship() and b.hostile and b.combat_active
		var world: Vector3 = p.pos + space._star_direction(b) * 200000.0 if b.kind == Body.Kind.STAR else b.pos
		var dist: float = p.pos.distance_to(b.pos) if b.kind != Body.Kind.STAR else -1.0
		var at = _screen(world)
		var color := _standing_color(b)
		if at != null and Rect2(Vector2.ZERO, size).has_point(at):
			if is_target:
				_draw_tex("hud_lockon_" + _standing(b), at)
				if b.is_ship() and dist <= NEAR_BARS: _draw_ship_bars(b, at)
				if not space.locked and space.tractor_status().is_empty():
					var f := int(clampf(space.lock_time / space.lock_needed, 0.0, 0.999) * 32)
					_draw_region("hud_scanprocess_anim_png24", Rect2(f * 25, 0, 25, 25), at)
			elif b.is_ship():
				if dist > RADAR_REACH: continue
				# Near ships carry the original's two bars instead of a bracket.
				if dist <= NEAR_BARS: _draw_ship_bars(b, at)
				else:
					var kind := _standing(b)
					_draw_tex("bracket_%s_far" % ("enemy" if kind == "enemy" else ("friend" if kind == "friend" else "waypoint")), at)
			elif nav and original_style() and b.kind in [Body.Kind.STATION, Body.Kind.GATE]:
				_draw_tex("hud_lockon_waypoint", at)
			elif nav:
				draw_arc(at, 7 * k, 0, TAU, 16, Color(color, 0.8), 1.5, true)
			elif on_course:
				draw_arc(at, 7 * k, 0, TAU, 16, Color(COURSE, 0.9), 1.5, true)
			if original_style() and b.kind in [Body.Kind.STATION, Body.Kind.GATE] and bool(app.setting("interface", "labels", true)):
				_landmark_label(b, at, dist)
			elif original_style() and b.kind == Body.Kind.STAR and bool(app.setting("interface", "labels", true)):
				# Radar.java names each planet in view above and to its right.
				_text(at + Vector2(20, -20) * k, b.name, 11, UI.TEXT)
			elif (nav or is_target or on_course) and bool(app.setting("interface", "labels", true)):
				var label: String = b.name if not b.name.is_empty() else app.library.text(270)
				# The chosen destination's way is labelled in gold.
				_text(at + Vector2(24, 5) * k, label + ("  ·  " + _metres(dist) if dist >= 0.0 else ""), 11, Color(COURSE if on_course else color, 0.95))
		elif on_course:
			_edge_arrow(size, edge, world, COURSE, true, _metres(dist) if dist >= 0.0 else "")
		elif is_target or (threat and dist < RADAR_REACH) or b == space.station:
			_edge_arrow(size, edge, world, color, is_target, _metres(dist) if is_target and dist >= 0.0 else "")
	_draw_waypoint(size, edge)

## Within this range (the original's 24,000 units) a ship shows its bars.
const NEAR_BARS := 24000.0

## The original's pair of 16-pixel bars beside a nearby ship (hud_bars:
## lit/dark pairs, red enemy, blue EMP, orange neutral, green friend): its
## hull in its standing's colour, and its EMP charge in blue, each filled
## from the bottom.
func _draw_ship_bars(b: Body, at: Vector2) -> void:
	var sheet := _tex("hud_bars")
	if sheet == null: return
	var frame := {"enemy": 0, "friend": 6}.get(_standing(b), 4) as int
	var hull := float(b.hull) / maxf(1.0, float(b.hull_max))
	var emp := float(b.emp) / maxf(1.0, float(b.emp_max)) if b.emp_max > 0 else 1.0
	for bar in [[frame, hull, 10.0], [2, emp, 15.0]]:
		var origin: Vector2 = at + Vector2(float(bar[2]), -8.0) * SCALE
		draw_texture_rect_region(sheet, Rect2(origin, Vector2(2, 16) * SCALE), Rect2(int(bar[0]) * 2 + 2, 0, 2, 16))
		var lit := clampf(float(bar[1]), 0.0, 1.0) * 16.0
		if lit > 0.0:
			draw_texture_rect_region(sheet, Rect2(origin + Vector2(0, 16.0 - lit) * SCALE, Vector2(2, lit) * SCALE), Rect2(int(bar[0]) * 2, 16.0 - lit, 2, lit))

## The mission route's next point: the original's waypoint lock-on frame
## with its distance in view, an edge arrow towards it otherwise.
func _draw_waypoint(size: Vector2, edge: Rect2) -> void:
	var goal = space.mission_waypoint()
	if goal == null: return
	var dist: float = space.player.pos.distance_to(goal)
	var at = _screen(goal)
	if at != null and Rect2(Vector2.ZERO, size).has_point(at):
		_draw_tex("hud_lockon_waypoint", at)
		_text(at + Vector2(24, 5) * k, app.library.text(272) + "  ·  " + _metres(dist), 11, Color(WAYPOINT, 0.95))
	else:
		_edge_arrow(size, edge, goal, WAYPOINT, space.autopilot_waypoint, _metres(dist))

## An arrow pinned to the screen edge, pointing towards an out-of-view object.
func _edge_arrow(size: Vector2, edge: Rect2, world: Vector3, color: Color, strong: bool, caption: String) -> void:
	var cam: Camera3D = view.camera
	var local: Vector3 = cam.global_transform.basis.inverse() * (world * view.UNIT - cam.global_position)
	var dir := Vector2(local.x, -local.y)
	if dir.length_squared() < 0.000001: dir = Vector2(0, 1)
	dir = dir.normalized()
	var c := size / 2.0
	var reach := minf(edge.size.x / 2.0 / maxf(0.001, absf(dir.x)), edge.size.y / 2.0 / maxf(0.001, absf(dir.y)))
	var pin := c + dir * reach
	var s := (10.0 if strong else 7.0) * k
	var side := Vector2(-dir.y, dir.x) * s * 0.8
	draw_colored_polygon(PackedVector2Array([pin + dir * s, pin - dir * s * 0.6 + side, pin - dir * s * 0.6 - side]),
		Color(color, 0.95 if strong else 0.7))
	if not caption.is_empty():
		var spot := pin - dir * 24 * k + Vector2(0, 4) * k
		var w := _width(caption, 10) + 6.0 * k
		var h := 13.0 * k
		# Arrows share an edge when their objects lie the same way: stack the
		# captions along the edge instead of printing one over another.
		var step := Vector2(0, h) if absf(dir.x) >= absf(dir.y) else Vector2(w, 0)
		var box := Rect2(spot - Vector2(w / 2.0, h - 3.0 * k), Vector2(w, h))
		for i in 6:
			if not edge_labels.any(func(r: Rect2): return r.intersects(box)): break
			box.position += step
		edge_labels.append(box)
		_text(Vector2(box.get_center().x - 50 * k, box.position.y + h - 3.0 * k), caption, 10, color, 100 * k, HORIZONTAL_ALIGNMENT_CENTER)

## The mining gauge as the original draws it: the rock layers stacked above
## the background, completed layers green, the current layer filling, red
## zones either side growing with drill damage, and the cursor.
func _draw_mining(size: Vector2) -> void:
	var m = space.mining
	var bg := _tex("mining_background")
	if bg == null: return
	var S := SCALE * 1.5
	var bs := bg.get_size() * S
	var origin := Vector2(size.x / 2.0 - bs.x / 2.0, size.y * 0.72)
	draw_texture_rect(bg, Rect2(origin - Vector2(0, bs.y), bs), false)
	var empty := _tex("mining_green_empty")
	var full := _tex("mining_green_complete")
	var red := _tex("mining_redarea")
	var cursor := _tex("mining_cursor")
	var x50 := origin.x + 50 * S
	if empty != null:
		var h: float = m.layers * 7.0
		draw_texture_rect_region(empty, Rect2(Vector2(x50, origin.y - h * S), Vector2(empty.get_width(), h) * S), Rect2(0, empty.get_height() - h, empty.get_width(), h))
	if full != null and m.layer > 0:
		var h2: float = m.layer * 7.0
		draw_texture_rect_region(full, Rect2(Vector2(x50, origin.y - h2 * S), Vector2(full.get_width(), h2) * S), Rect2(0, full.get_height() - h2, full.get_width(), h2))
	var width: int = m.WIDTHS[m.layer]
	if full != null:
		var part := float(m.layer_time) / float(m.layer_needed) * width
		var row_y: float = full.get_height() - (m.layer + 1) * 7.0
		var cx := size.x / 2.0
		draw_texture_rect_region(full, Rect2(Vector2(cx - part * S / 2.0, origin.y - (m.layer + 1) * 7.0 * S), Vector2(part, 7) * S),
			Rect2(full.get_width() / 2.0 - part / 2.0, row_y, part, 7))
	var row: float = origin.y - m.layer * 7.0 * S
	if red != null:
		var grow: float = m.red / m.RED_LIMIT * (width + 5)
		var left: float = origin.x + (bg.get_width() - 2 * m.MARGIN - width * 3) / 2.0 * S
		draw_texture_rect_region(red, Rect2(Vector2(left + (width - grow) * S, row - 5 * S), Vector2(grow, 5) * S), Rect2(0, 0, grow, 5))
		draw_texture_rect_region(red, Rect2(Vector2(left + (width * 2 + 2 * m.MARGIN) * S, row - 5 * S), Vector2(grow, 5) * S), Rect2(0, 0, grow, 5))
	if cursor != null:
		var cs := cursor.get_size() * S
		draw_texture_rect(cursor, Rect2(Vector2(size.x / 2.0 + m.drill * S - cs.x / 2.0, row + 2 * S - cs.y), cs), false)
	var label := "%d t %s" % [int(m.tons), app.catalogue.item_name(int(m.ore))]
	_string(Vector2(size.x / 2.0 - 200, origin.y + 22), label, HORIZONTAL_ALIGNMENT_CENTER, 400, 16, UI.TEXT)

## A radio line in the original's box: the speaker's portrait on the left,
## the name in the header, the text beside the portrait.
var radio_face := {}

## Where the radio box goes and how tall it is: between the location plate
## on the left and the vitals (or the touch buttons) on the right, unless the
## HUD is hidden for a cinematic; tall enough for the whole line and, room
## allowing, the note of which keys it means here.
func _radio_rect(size: Vector2, line: Dictionary) -> Rect2:
	var band := Vector2(20.0, size.x - 20.0)
	var top := 12.0
	if space.story == null or not space.story.hud_hidden:
		var safe := SafeMargins.margins(size, touch_layout)
		band.x = safe.side + MARGIN + 330.0 * k + 10.0
		band.y = size.x - safe.side - MARGIN - 330.0 * k - 10.0
		if touch != null:
			band.y = size.x - safe.side - MARGIN - 10.0
			for r in touch.buttons.values():
				if r.position.y < 150.0 and r.position.x > size.x / 2.0: band.y = minf(band.y, touch.position.x + r.position.x - 10.0)
		if band.y - band.x < 420.0:
			# No room between the panels (an upright phone): the width of
			# the screen, just under them.
			band = Vector2(20.0, size.x - 20.0)
			top = top_stack + 8.0
	var w := minf(band.y - band.x, 760.0)
	var rect := Rect2(Vector2((band.x + band.y - w) / 2.0, top), Vector2(w, 126))
	if str(line.get("text", "")) != _note_for:
		_note_for = str(line.get("text", ""))
		_note = preload("res://src/screens/help_panel.gd").key_note(app, _note_for)
	var width := _radio_text_width(rect)
	var text_lines := mini(_wrap(_note_for, width, 14).size(), RADIO_MAX_LINES)
	var note_lines := _wrap(_note, width, 12).size() if not _note.is_empty() else 0
	rect.size.y = maxf(126.0, 46.0 + 18.0 * text_lines + 15.0 * note_lines - 4.0)
	return rect

const RADIO_MAX_LINES := 9
func _radio_text_width(rect: Rect2) -> float:
	return rect.size.x - 8.0 - preload("res://src/presentation/portrait.gd").FRAME.x * 1.7 - 10.0 - 10.0

func _draw_radio(size: Vector2, line: Dictionary) -> void:
	for n in radio_face.values(): n.visible = false
	if line.is_empty(): return
	var rect := _radio_rect(size, line)
	var bg := _tex("menu_background")
	if bg != null: draw_texture_rect(bg, rect, true)
	draw_rect(rect, Color.BLACK, false, 2.0)
	draw_rect(rect.grow(-2), UI.BORDER, false, 2.0)
	var header := Rect2(rect.position + Vector2(3, 3), Vector2(rect.size.x - 6, 22))
	var pattern := _tex("menu_header_pattern")
	if pattern != null: draw_texture_rect(pattern, header, true)
	_string(header.position + Vector2(8, 17), str(line.name), HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Color.WHITE)
	var key: Variant = int(line.speaker) if not line.has("face") else str(line.face)
	if not radio_face.has(key):
		var face := preload("res://src/presentation/portrait.gd").make(app.library, int(line.speaker), line.get("face", []), 1.7)
		add_child(face)
		radio_face[key] = face
	var node: Control = radio_face[key]
	node.visible = true
	node.position = rect.position + Vector2(8, 30)
	var width := _radio_text_width(rect)
	var text_x := rect.end.x - 10 - width
	var lines := _wrap(str(line.text), width, 14)
	var y := rect.position.y + 46
	for l in lines.slice(0, RADIO_MAX_LINES):
		_string(Vector2(text_x, y), l, HORIZONTAL_ALIGNMENT_LEFT, width, 14, UI.TEXT)
		y += 18
	# A line naming the phone's keys gets what to press here.
	if not _note.is_empty():
		for l in _wrap(_note, width, 12):
			_string(Vector2(text_x, y - 2), l, HORIZONTAL_ALIGNMENT_LEFT, width, 12, UI.TEXT_DIM)
			y += 15

func _wrap(text: String, width: float, size: int) -> PackedStringArray:
	var out := PackedStringArray()
	for para in text.split("\n"):
		var line := ""
		for word in para.split(" "):
			var trial := word if line.is_empty() else line + " " + word
			if font.get_string_size(trial, HORIZONTAL_ALIGNMENT_LEFT, -1, size).x > width and not line.is_empty():
				out.append(line)
				line = word
			else:
				line = trial
		out.append(line)
	return out

## Radar scope in the corner: ahead is up, contacts in the original's
## standing icons, a stem showing whether each lies above or below, range
## rings and a slow sweep. Distant stations, gates and threats stay pinned
## to the rim.
func _draw_radar(size: Vector2) -> void:
	if touch_layout and space.mining != null: return
	var r := (92.0 if not touch_layout else 66.0) * k
	var c := Vector2(size.x - MARGIN - r - 6 * k, size.y - MARGIN - r - 6 * k)
	if touch_layout:
		# Under whatever buttons hold the top-right corner, caption included.
		var top := 92.0 * k
		if touch != null:
			for b in touch.buttons.values():
				if b.position.y < 150.0 and b.position.x > size.x / 2.0: top = maxf(top, touch.position.y + b.end.y - _shift_by.y + 24.0 * k)
		c = Vector2(size.x - MARGIN - r - 6 * k, top + r)
	if c.y + _shift_by.y < self.size.y * 0.35: _stack_now = maxf(_stack_now, c.y + r + 6 * k + _shift_by.y)
	draw_circle(c, r + 6 * k, PANEL)
	draw_arc(c, r + 6 * k, 0, TAU, 96, Color(UI.BORDER, 0.9), 1.0, true)
	draw_arc(c, r, 0, TAU, 96, Color(ACCENT, 0.55), 1.0, true)
	for ring in [0.25, 0.5, 0.75]:
		draw_arc(c, r * ring, 0, TAU, 64, RULE, 1.0, true)
	draw_line(c - Vector2(r, 0), c + Vector2(r, 0), Color(RULE, 0.3), 1.0)
	draw_line(c - Vector2(0, r), c + Vector2(0, r), Color(RULE, 0.3), 1.0)
	# The forward view cone.
	for side in [-1.0, 1.0]:
		draw_line(c, c + Vector2(side * 0.55, -1.0).normalized() * r, Color(ACCENT, 0.22), 1.0, true)
	var sweep := float(space.clock) / 1000.0 * 1.6
	for j in 16:
		draw_line(c, c + Vector2.from_angle(sweep - j * 0.03) * r, Color(ACCENT, (1.0 - j / 16.0) * 0.10), 2.0, true)
	var p: Body = space.player
	var inv := p.basis.inverse()
	for b in space.bodies:
		if b == p or not b.alive or not b.visible or b.kind == Body.Kind.STAR or b.kind == Body.Kind.ARRIVAL: continue
		var local: Vector3 = inv * (b.pos - p.pos)
		# Ahead (+z) is up on the radar, the ship's left (+x) is left.
		var flat := Vector2(-local.x, -local.z) / RADAR_REACH * r
		var height := clampf(local.y / RADAR_REACH * r, -r * 0.3, r * 0.3)
		var pinned := false
		if flat.length() > r:
			if not (b.kind in [Body.Kind.STATION, Body.Kind.GATE, Body.Kind.WORMHOLE] or b.hostile or b == space.target): continue
			flat = flat.normalized() * r
			height = 0.0
			pinned = true
		if b.kind == Body.Kind.ASTEROID:
			draw_rect(Rect2(c + flat - Vector2(1, 1), Vector2(2, 2)), Color(0.6, 0.55, 0.45, 0.6))
			continue
		var color := _standing_color(b)
		var at := c + flat - Vector2(0, height)
		if absf(height) > 1.5:
			draw_line(c + flat, at, Color(color, 0.5), 1.0)
			draw_circle(c + flat, 1.2, Color(color, 0.5))
		var icon := "hud_radaricon_" + _standing(b)
		if b.kind == Body.Kind.STATION or b.kind == Body.Kind.GATE: icon = "hud_radaricon_friend"
		if b.kind == Body.Kind.LOOT:
			icon = "hud_spacejunk" if b.cargo.size() >= 2 and int(b.cargo[0]) == 99 \
				else ("hud_crate_void" if int(b.ai.get("race", -1)) == 9 else "hud_crate")
		if b == space.target: icon += "_lock"
		var t := _tex(icon)
		if t != null:
			var s := t.get_size() * SCALE * clampf(k, 1.0, 1.4)
			draw_texture_rect(t, Rect2(at - s / 2.0, s), false, Color(1, 1, 1, 0.55 if pinned else 1.0))
		else:
			draw_circle(at, 2.5 * k, color)
	var goal = space.mission_waypoint()
	if goal != null:
		# The route point stays on the scope, pinned to its rim when far.
		var local: Vector3 = inv * (goal - p.pos)
		var flat := Vector2(-local.x, -local.z) / RADAR_REACH * r
		if flat.length() > r: flat = flat.normalized() * r
		var t := _tex("hud_waypoint")
		if t != null:
			var s := t.get_size() * clampf(k, 1.0, 1.4)
			draw_texture_rect(t, Rect2(c + flat - s / 2.0, s), false)
		else:
			draw_arc(c + flat, 4 * k, 0, TAU, 12, WAYPOINT, 1.5, true)
	draw_colored_polygon(PackedVector2Array([c + Vector2(0, -5) * k, c + Vector2(-4, 4) * k, c + Vector2(4, 4) * k]), UI.TEXT)
	_text(c + Vector2(-r - 4 * k, -r - 4 * k), "RADAR", 10, LABEL)
	_text(c + Vector2(r - 60 * k, -r - 4 * k), _metres(RADAR_REACH), 10, UI.TEXT_DIM, 64 * k, HORIZONTAL_ALIGNMENT_RIGHT)
	var threats: int = space.hostiles().filter(func(h): return h.combat_active and h.pos.distance_to(p.pos) < RADAR_REACH).size()
	if threats > 0:
		var warning := "·  %d HOSTILE" % threats
		var at := c + Vector2(-r + 44 * k, -r - 4 * k)
		# On the small touch scope the header has no room between the title
		# and the range; the count goes under the scope instead.
		if at.x + _width(warning, 10) > c.x + r - _width(_metres(RADAR_REACH), 10) - 6 * k:
			at = c + Vector2(-_width(warning, 10) / 2.0, r + 20 * k)
		_text(at, warning, 10, ENEMY)

## After the ship is lost: the original's "Game Over" with the way on,
## from the last docking (or the opening again) or back to the title.
var game_over_layer: Control

func game_over(continue_label: String, on_continue: Callable, on_menu: Callable) -> void:
	if game_over_layer != null: return
	game_over_layer = Control.new()
	game_over_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(game_over_layer)
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.45)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	game_over_layer.add_child(shade)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	game_over_layer.add_child(center)
	var f := UI.Frame.new(app.library.text(156))
	f.custom_minimum_size = Vector2(400, 0)
	var box := VBoxContainer.new()
	f.add_child(box)
	box.add_child(UI.button(continue_label, on_continue))
	box.add_child(UI.button(app.library.text(67), on_menu))
	if touch_layout:
		for button in box.get_children(): button.custom_minimum_size.y = 52
	center.add_child(f)
	(box.get_child(0) as Control).grab_focus.call_deferred()

func set_paused(on: bool) -> void:
	# Already up: a second pause (a dropdown taking focus reads as the window
	# losing it) must not rebuild the menu under an open Options page.
	if on and paused and pause_layer != null: return
	paused = on
	if pause_layer != null:
		pause_layer.queue_free()
		pause_layer = null
	pause_panel = null
	if not on: return
	pause_layer = Control.new()
	pause_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(pause_layer)
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.4)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	pause_layer.add_child(shade)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	pause_layer.add_child(center)
	var f := UI.Frame.new(app.library.text(17))
	f.custom_minimum_size = Vector2(360, 0)
	var box := VBoxContainer.new()
	f.add_child(box)
	box.add_child(UI.button(app.library.text(18), func(): get_parent().set_paused(false)))
	box.add_child(UI.button(app.library.text(3), func():
		f.visible = false
		var options := preload("res://src/screens/options_panel.gd").new()
		options.app = app
		options.closed.connect(func():
			f.visible = true
			(box.get_child(1) as Control).grab_focus.call_deferred())
		center.add_child(options)))
	box.add_child(UI.button("Photo mode", func():
		get_parent().set_paused(false)
		get_parent().set_photo(true), not space.navigation_locked()))
	box.add_child(UI.button(app.library.text(4), func():
		f.visible = false
		var help := preload("res://src/screens/help_panel.gd").new()
		help.app = app
		help.closed.connect(func():
			f.visible = true
			(box.get_child(3) as Control).grab_focus.call_deferred())
		center.add_child(help)))
	# 31: "Are you sure you want to quit?" Unsaved flight progress is lost.
	box.add_child(UI.button(app.library.text(67), func():
		UI.ask(pause_layer, app.library.text(31), func(): app.show_title(),
			func(): (box.get_child(box.get_child_count() - 1) as Control).grab_focus())))
	if touch_layout:
		for button in box.get_children(): button.custom_minimum_size.y = 52
	center.add_child(f)
	pause_panel = f
	(box.get_child(0) as Control).grab_focus.call_deferred()
