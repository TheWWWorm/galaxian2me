extends Control
## Flight HUD with the original's artwork: crosshair, target brackets by
## standing, the lock-on scan animation, hull and shield bars, the radar with
## its standing dots, target read-out and messages.

const UI := preload("res://src/presentation/ui.gd")
const Body := preload("res://src/flight/body.gd")

const SCALE := 2.0

var app
var space
var view
var messages: Array = []
var paused := false
var pause_panel: Control
var font: Font

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	font = get_theme_default_font()
	space.event.connect(_on_event)

func _process(delta: float) -> void:
	for m in messages: m.time -= delta
	messages = messages.filter(func(m): return m.time > 0.0)
	queue_redraw()

func message(text: String, time := 3.0) -> void:
	messages.append({"text": text, "time": time})
	while messages.size() > 4: messages.pop_front()

func _on_event(kind: String, data: Dictionary) -> void:
	match kind:
		"docking": message(app.library.text(40) + " " + space.station.name, 3.0)
		"gate_menu": message(app.library.text(241), 3.0)
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
	if b.kind == Body.Kind.STATION or b.kind == Body.Kind.GATE or b.kind == Body.Kind.STAR: return "waypoint"
	if b.kind == Body.Kind.ASTEROID or b.kind == Body.Kind.LOOT: return "neutral"
	if b.hostile: return "enemy"
	if b.friendly: return "friend"
	return "neutral"

func _screen(p: Vector3) -> Variant:
	var cam: Camera3D = view.camera
	var world: Vector3 = p * view.UNIT
	if cam.is_position_behind(world): return null
	return cam.unproject_position(world)

func _draw() -> void:
	if space == null or space.player == null: return
	var size := get_viewport_rect().size
	var centre := size / 2.0
	var p: Body = space.player
	var story = space.story
	if story != null:
		if story.flash > 0.0:
			draw_rect(Rect2(Vector2.ZERO, size), Color(1, 1, 1, clampf(story.flash, 0.0, 1.0)))
		_draw_radio(size, story.message())
		if story.hud_hidden: return
	# Crosshair.
	_draw_tex("hud_crosshair_png24", centre)
	# Target brackets and read-out.
	var t: Body = space.target
	if t != null and t.alive:
		var at = null
		if t.kind == Body.Kind.STAR:
			at = _screen(p.pos + space._star_direction(t) * 200000.0)
		else:
			at = _screen(t.pos)
		var kind := _standing(t)
		if at != null:
			_draw_tex("hud_lockon_" + kind, at)
			if not space.locked:
				var frames := 32
				var f := int(clampf(space.lock_time / space.lock_needed, 0.0, 0.999) * frames)
				_draw_region("hud_scanprocess_anim_png24", Rect2(f * 25, 0, 25, 25), at)
		var dist := p.pos.distance_to(t.pos) if t.kind != Body.Kind.STAR else 0.0
		var label: String = t.name if not t.name.is_empty() else app.library.text(270)
		if dist > 0.0: label += "  %d m" % int(dist / 10.0)
		draw_string(font, Vector2(centre.x - 150, size.y - 64), label, HORIZONTAL_ALIGNMENT_CENTER, 300, 15, UI.TEXT)
		if t.is_ship():
			var frac := float(t.hull) / maxf(1.0, float(t.hull_max))
			draw_rect(Rect2(centre.x - 50, size.y - 56, 100, 5), Color(0, 0, 0, 0.6))
			draw_rect(Rect2(centre.x - 50, size.y - 56, 100 * frac, 5), UI.TEXT_WARN if t.hostile else UI.GREEN)
			if t.disabled:
				draw_string(font, Vector2(centre.x - 150, size.y - 40), "EMP", HORIZONTAL_ALIGNMENT_CENTER, 300, 13, Color(0.5, 0.7, 1.0))
	# Other ships nearby get small far-brackets.
	for b in space.bodies:
		if b == p or b == t or not b.alive or not b.is_ship(): continue
		var s = _screen(b.pos)
		if s == null or p.pos.distance_to(b.pos) > 60000.0: continue
		var k := _standing(b)
		var tex := "bracket_%s_far" % ("enemy" if k == "enemy" else ("friend" if k == "friend" else "waypoint"))
		_draw_tex(tex, s)
	_draw_status(size)
	_draw_radar(size)
	# Messages.
	var y := 70.0
	for m in messages:
		draw_string(font, Vector2(size.x / 2 - 300, y), str(m.text), HORIZONTAL_ALIGNMENT_CENTER, 600, 16, UI.TEXT)
		y += 22.0
	if space.autopilot:
		draw_string(font, Vector2(size.x / 2 - 150, size.y - 90), app.library.text(292), HORIZONTAL_ALIGNMENT_CENTER, 300, 15, UI.GREEN)

## The original's frame: the upper and lower corner panels, mirrored on the
## right; hull and armour bottom left, shield bottom right, each bar filling
## from its outer end; the secondary weapon's icon and count bottom left.
func _draw_status(size: Vector2) -> void:
	var p: Body = space.player
	var upper := _tex("hud_panel_upper_left_png24")
	var lower := _tex("hud_panel_lower_left_png24")
	if upper != null:
		var us := upper.get_size() * SCALE
		draw_texture_rect(upper, Rect2(Vector2.ZERO, us), false)
		_mirrored(func(): draw_texture_rect(upper, Rect2(Vector2.ZERO, us), false), size.x)
	var ls := lower.get_size() * SCALE if lower != null else Vector2(134, 52)
	if lower != null:
		draw_texture_rect(lower, Rect2(Vector2(0, size.y - ls.y), ls), false)
		_mirrored(func(): draw_texture_rect(lower, Rect2(Vector2(0, size.y - ls.y), ls), false), size.x)
	var hull_frac := float(p.hull + p.armor) / maxf(1.0, float(p.hull_max + p.armor_max))
	var shield_frac := p.shield / maxf(1.0, float(p.shield_max)) if p.shield_max > 0 else 0.0
	_draw_tex("hud_symbol_hull_png24", Vector2(8, size.y - ls.y - 6 - 17 * SCALE), false)
	_bar(Vector2(ls.x, size.y - 13 * SCALE), hull_frac, false)
	if p.shield_max > 0:
		var shield := _tex("hud_symbol_shield_png24")
		if shield != null:
			var ss := shield.get_size() * SCALE
			draw_texture_rect(shield, Rect2(Vector2(size.x - 8 - ss.x, size.y - ls.y - 6 - ss.y), ss), false)
		_mirrored(func(): _bar(Vector2(ls.x, size.y - 13 * SCALE), shield_frac, false), size.x)
	# Status line: booster, secondary weapon, hold.
	var s = app.game.session
	var st: Dictionary = s.ship_stats()
	var y := 38.0 * SCALE + 14.0
	if int(st.boost_length) > 0:
		var txt: String = app.library.text(155) if space.boost_ready else app.library.text(154)
		draw_string(font, Vector2(10, y), txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 13, UI.GREEN if space.boost_ready else UI.TEXT_DIM)
		y += 18
	draw_string(font, Vector2(10, y), "%d/%d t" % [s.cargo_used(), int(st.cargo_capacity)], HORIZONTAL_ALIGNMENT_LEFT, -1, 13, UI.TEXT_DIM)
	for w in p.weapons:
		if w.kind == "gun" or w.kind == "turret": continue
		var sheet := _tex("items")
		if sheet != null:
			var cell := sheet.get_width() / float(maxi(1, app.library.data.items.size()))
			var region := Rect2(int(w.id) * cell, 0, cell, sheet.get_height())
			var at := Vector2(ls.x + 8, size.y - 40 - sheet.get_height() * SCALE)
			draw_texture_rect_region(sheet, Rect2(at, region.size * SCALE), region)
			draw_string(font, at + Vector2(region.size.x * SCALE + 4, sheet.get_height() * SCALE - 4), "x%d" % int(w.count), HORIZONTAL_ALIGNMENT_LEFT, -1, 14, UI.TEXT)
		break

## A radio line in the original's box: the speaker's portrait on the left,
## the name in the header, the text beside the portrait.
var radio_face := {}

func _draw_radio(size: Vector2, line: Dictionary) -> void:
	for n in radio_face.values(): n.visible = false
	if line.is_empty(): return
	var w := minf(size.x - 40.0, 760.0)
	var rect := Rect2(Vector2((size.x - w) / 2.0, 12), Vector2(w, 126))
	var bg := _tex("menu_background")
	if bg != null: draw_texture_rect(bg, rect, true)
	draw_rect(rect, Color.BLACK, false, 2.0)
	draw_rect(rect.grow(-2), UI.BORDER, false, 2.0)
	var header := Rect2(rect.position + Vector2(3, 3), Vector2(rect.size.x - 6, 22))
	var pattern := _tex("menu_header_pattern")
	if pattern != null: draw_texture_rect(pattern, header, true)
	draw_string(font, header.position + Vector2(8, 17), str(line.name), HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Color.WHITE)
	var key := int(line.speaker)
	if not radio_face.has(key):
		var face := preload("res://src/presentation/portrait.gd").make(app.library, key, [], 1.7)
		add_child(face)
		radio_face[key] = face
	var node: Control = radio_face[key]
	node.visible = true
	node.position = rect.position + Vector2(8, 30)
	var text_x := rect.position.x + 8 + node.custom_minimum_size.x + 10
	var width := rect.end.x - text_x - 10
	var lines := _wrap(str(line.text), width, 14)
	var y := rect.position.y + 46
	for l in lines.slice(0, 5):
		draw_string(font, Vector2(text_x, y), l, HORIZONTAL_ALIGNMENT_LEFT, width, 14, UI.TEXT)
		y += 18

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

## Draws with the canvas mirrored about the vertical line x = width / 2.
func _mirrored(draw: Callable, width: float) -> void:
	draw_set_transform(Vector2(width, 0), 0.0, Vector2(-1, 1))
	draw.call()
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

## A bar whose inner end sits at `at` (bottom edge), filling from that end.
func _bar(at: Vector2, frac: float, mirrored: bool) -> void:
	var empty := _tex("hud_hull_bar_empty_png24")
	var full := _tex("hud_hull_bar_full_png24")
	if empty == null or full == null: return
	var s := empty.get_size() * SCALE
	var dir := 1.0 if mirrored else -1.0
	var x0 := at.x if mirrored else at.x - s.x
	var rect := Rect2(Vector2(x0, at.y - s.y), s)
	draw_texture_rect(empty, Rect2(rect.position + (Vector2(s.x, 0) if mirrored else Vector2.ZERO), Vector2(-s.x if mirrored else s.x, s.y)), false)
	var w := full.get_width() * clampf(frac, 0.0, 1.0)
	if w <= 0.0: return
	var src := Rect2(full.get_width() - w, 0, w, full.get_height())
	# Both bars fill from their inner end, the right one drawn mirrored.
	if mirrored:
		draw_texture_rect_region(full, Rect2(Vector2(at.x + w * SCALE, at.y - s.y), Vector2(-w * SCALE, s.y)), src)
	else:
		draw_texture_rect_region(full, Rect2(Vector2(at.x - w * SCALE, at.y - s.y), Vector2(w * SCALE, s.y)), src)
	var _unused := dir

## Radar: ships and objects within range as the original's coloured dots on
## a disc, oriented with the ship.
func _draw_radar(size: Vector2) -> void:
	var r := 70.0
	var c := Vector2(size.x - r - 16, size.y - r - 16)
	draw_circle(c, r, Color(0.0, 0.08, 0.14, 0.55))
	draw_arc(c, r, 0, TAU, 48, UI.BORDER, 2.0)
	draw_arc(c, r * 0.5, 0, TAU, 32, Color(UI.BORDER, 0.5), 1.0)
	var p: Body = space.player
	var inv := p.basis.inverse()
	var reach := 60000.0
	for b in space.bodies:
		if b == p or not b.alive or b.kind == Body.Kind.STAR or b.kind == Body.Kind.ARRIVAL: continue
		var local: Vector3 = inv * (b.pos - p.pos)
		# Ahead (+z) is up on the radar, the ship's left (+x) is left.
		var flat := Vector2(-local.x, -local.z) / reach * r
		if flat.length() > r:
			if not (b.kind == Body.Kind.STATION or b.kind == Body.Kind.GATE or b.hostile): continue
			flat = flat.normalized() * r
		var kind := _standing(b)
		var icon := "hud_radaricon_" + kind
		if b.kind == Body.Kind.STATION or b.kind == Body.Kind.GATE: icon = "hud_radaricon_friend"
		if b == space.target: icon += "_lock"
		if b.kind == Body.Kind.ASTEROID:
			draw_rect(Rect2(c + flat - Vector2(1, 1), Vector2(2, 2)), Color(0.6, 0.55, 0.45, 0.8))
			continue
		var t := _tex(icon)
		if t != null:
			var s := t.get_size() * SCALE
			var shade := 1.0 if local.y > -2000.0 else 0.6
			draw_texture_rect(t, Rect2(c + flat - s / 2.0, s), false, Color(1, 1, 1, shade))

func set_paused(on: bool) -> void:
	paused = on
	if pause_panel != null:
		pause_panel.queue_free()
		pause_panel = null
	if not on: return
	var f := UI.Frame.new(app.library.text(17))
	f.set_anchors_preset(Control.PRESET_CENTER)
	f.custom_minimum_size = Vector2(360, 0)
	f.position = get_viewport_rect().size / 2.0 - Vector2(180, 120)
	var box := VBoxContainer.new()
	f.add_child(box)
	box.add_child(UI.button(app.library.text(18), func(): get_parent().paused = false; set_paused(false)))
	box.add_child(UI.button(app.library.text(67), func(): app.show_title()))
	add_child(f)
	pause_panel = f
	(box.get_child(0) as Control).grab_focus.call_deferred()
