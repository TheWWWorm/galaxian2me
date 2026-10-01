extends RefCounted
## Interface kit: rounded navy panels with a soft blue rim, a filled blue
## highlight for the chosen row, blue switches and sliders, and small drawn
## icons. Text is drawn with a crisp native font; artwork (item icons,
## portraits, logos) comes from the import.

const BORDER := Color8(0x2a, 0x5d, 0x96)
const BORDER_DARK := Color8(0x1c, 0x3d, 0x63)
const DEEP := Color8(0x0d, 0x23, 0x40)
const PANEL := Color8(0x09, 0x18, 0x2e)
const PANEL_TOP := Color8(0x10, 0x2a, 0x4c)
const ACCENT := Color8(0x4a, 0xa3, 0xff)
const SELECT := Color8(0x1f, 0x52, 0x8e)
const SELECT_EDGE := Color8(0x6c, 0xb4, 0xff)
const GREEN := Color8(0x6a, 0xb7, 0x64)
const GREEN_DARK := Color8(0x29, 0x4a, 0x2c)
const GREY := Color8(0x16, 0x1d, 0x26)
const TEXT := Color8(0xe8, 0xf0, 0xf8)
const TEXT_DIM := Color8(0x8f, 0xa7, 0xbb)
const TEXT_GOOD := Color8(0x7f, 0xd6, 0x7a)
const TEXT_WARN := Color8(0xff, 0x6a, 0x55)
const HIGHLIGHT := Color8(0x3f, 0x86, 0xc2)
const EngineLanguage := preload("res://src/presentation/engine_language.gd")

static var library = null
static var scale := 2.0

static func art(name: String) -> Texture2D:
	return library.texture(name) if library != null else null

## Money the way the original writes it: 12.345$
static func money(value: int) -> String:
	var s := str(absi(value))
	var out := ""
	var n := 0
	for i in range(s.length() - 1, -1, -1):
		out = s[i] + out
		n += 1
		if n == 3 and i > 0:
			out = "." + out
			n = 0
	return ("-" if value < 0 else "") + out + "$"

static func make_theme(text_size := 16) -> Theme:
	var t := Theme.new()
	var font := SystemFont.new()
	font.font_names = PackedStringArray(["Noto Sans", "DejaVu Sans", "Liberation Sans", "Arial", "sans-serif"])
	font.antialiasing = TextServer.FONT_ANTIALIASING_GRAY
	font.hinting = TextServer.HINTING_LIGHT
	# Chinese, Japanese and Korean engine text where the system has no such
	# font, as in a browser.
	font.fallbacks = EngineLanguage.fallback_fonts()
	t.default_font = font
	t.default_font_size = text_size
	for type in ["Label", "Button", "LineEdit", "RichTextLabel", "CheckBox", "OptionButton", "ItemList", "TabBar", "TabContainer"]:
		t.set_color("font_color", type, TEXT)
	t.set_color("default_color", "RichTextLabel", TEXT)
	for type in ["Button", "OptionButton"]:
		t.set_color("font_hover_color", type, Color.WHITE)
		t.set_color("font_pressed_color", type, Color.WHITE)
		t.set_color("font_focus_color", type, Color.WHITE)
		t.set_color("font_hover_pressed_color", type, Color.WHITE)
		t.set_color("font_disabled_color", type, Color(0.45, 0.52, 0.6))
		t.set_stylebox("normal", type, _box(Color(DEEP, 0.85), BORDER_DARK))
		t.set_stylebox("hover", type, _box(DEEP.lightened(0.1), BORDER))
		t.set_stylebox("pressed", type, _box(SELECT, SELECT_EDGE))
		t.set_stylebox("hover_pressed", type, _box(SELECT, SELECT_EDGE))
		t.set_stylebox("disabled", type, _box(Color(GREY, 0.8), Color(0.18, 0.22, 0.28)))
		# Focus is the chosen row: a filled blue bar with a bright rim, drawn
		# over the normal look.
		var f := _box(Color(SELECT, 0.75), SELECT_EDGE, 1)
		f.shadow_color = Color(ACCENT, 0.25); f.shadow_size = 4
		t.set_stylebox("focus", type, f)
	t.set_constant("h_separation", "Button", 10)
	t.set_stylebox("panel", "PanelContainer", panel_box())
	t.set_stylebox("panel", "Panel", panel_box())
	t.set_stylebox("normal", "LineEdit", _box(Color(0.02, 0.06, 0.12, 0.8), BORDER_DARK))
	t.set_stylebox("focus", "LineEdit", _box(Color(0, 0, 0, 0), SELECT_EDGE, 1))
	t.set_color("font_placeholder_color", "LineEdit", TEXT_DIM)
	# Tabs: rounded tops, the chosen one lit blue.
	var tab_off := _box(Color(DEEP, 0.85), BORDER_DARK); _top_only(tab_off)
	var tab_on := _box(SELECT, SELECT_EDGE); _top_only(tab_on)
	var tab_hover := _box(DEEP.lightened(0.1), BORDER); _top_only(tab_hover)
	for type in ["TabContainer", "TabBar"]:
		t.set_stylebox("tab_unselected", type, tab_off)
		t.set_stylebox("tab_selected", type, tab_on)
		t.set_stylebox("tab_hovered", type, tab_hover)
		t.set_stylebox("tab_focus", type, _box(Color(0, 0, 0, 0), SELECT_EDGE, 1))
		t.set_color("font_selected_color", type, Color.WHITE)
		t.set_color("font_unselected_color", type, TEXT_DIM)
		t.set_color("font_hovered_color", type, Color.WHITE)
		t.set_font_size("font_size", type, text_size + 1)
	t.set_constant("side_margin", "TabContainer", 0)
	t.set_stylebox("panel", "TabContainer", panel_box(false))
	var grab := StyleBoxFlat.new(); grab.bg_color = BORDER; grab.set_corner_radius_all(4)
	var grab_hi := StyleBoxFlat.new(); grab_hi.bg_color = ACCENT; grab_hi.set_corner_radius_all(4)
	t.set_stylebox("grabber", "VScrollBar", grab)
	t.set_stylebox("grabber_highlight", "VScrollBar", grab_hi)
	t.set_stylebox("grabber_pressed", "VScrollBar", grab_hi)
	var track := StyleBoxFlat.new(); track.bg_color = Color(0, 0, 0, 0.3); track.set_corner_radius_all(4)
	track.content_margin_left = 3; track.content_margin_right = 3
	t.set_stylebox("scroll", "VScrollBar", track)
	# Switches: a blue pill when on, grey when off.
	for state in ["checked", "unchecked", "checked_disabled", "unchecked_disabled"]:
		t.set_icon(state, "CheckButton", _switch(state.begins_with("checked"), state.ends_with("disabled")))
	var flat := StyleBoxEmpty.new(); flat.content_margin_left = 0; flat.content_margin_top = 4; flat.content_margin_bottom = 4
	for style in ["normal", "hover", "pressed", "hover_pressed", "disabled"]:
		t.set_stylebox(style, "CheckButton", flat)
	var ring := _box(Color(0, 0, 0, 0), SELECT_EDGE, 1); ring.set_content_margin_all(0)
	t.set_stylebox("focus", "CheckButton", ring)
	t.set_font_size("font_size", "CheckButton", text_size)
	t.set_color("font_color", "CheckButton", TEXT)
	t.set_color("font_hover_color", "CheckButton", Color.WHITE)
	t.set_color("font_pressed_color", "CheckButton", TEXT)
	t.set_color("font_hover_pressed_color", "CheckButton", Color.WHITE)
	t.set_color("font_focus_color", "CheckButton", Color.WHITE)
	t.set_font_size("font_size", "OptionButton", text_size - 1)
	t.set_icon("arrow", "OptionButton", _chevron())
	t.set_constant("arrow_margin", "OptionButton", 10)
	# Popup lists of the choice buttons.
	var pop := panel_box(false); pop.set_content_margin_all(6)
	t.set_stylebox("panel", "PopupMenu", pop)
	t.set_stylebox("hover", "PopupMenu", _box(SELECT, SELECT_EDGE))
	t.set_color("font_color", "PopupMenu", TEXT)
	t.set_color("font_hover_color", "PopupMenu", Color.WHITE)
	# Sliders: a thin dark track, filled blue up to a round knob.
	var rail := StyleBoxFlat.new(); rail.bg_color = Color(0.1, 0.16, 0.24); rail.set_corner_radius_all(3)
	rail.content_margin_top = 3; rail.content_margin_bottom = 3
	var filled := StyleBoxFlat.new(); filled.bg_color = ACCENT.darkened(0.15); filled.set_corner_radius_all(3)
	filled.content_margin_top = 3; filled.content_margin_bottom = 3
	t.set_stylebox("slider", "HSlider", rail)
	t.set_stylebox("grabber_area", "HSlider", filled)
	t.set_stylebox("grabber_area_highlight", "HSlider", filled)
	t.set_icon("grabber", "HSlider", _knob(false))
	t.set_icon("grabber_highlight", "HSlider", _knob(true))
	var bar_bg := _box(Color(0, 0, 0, 0.5), BORDER_DARK)
	var bar_fill := StyleBoxFlat.new(); bar_fill.bg_color = GREEN; bar_fill.set_corner_radius_all(3)
	t.set_stylebox("background", "ProgressBar", bar_bg)
	t.set_stylebox("fill", "ProgressBar", bar_fill)
	var sep := StyleBoxLine.new(); sep.color = Color(BORDER, 0.6); sep.thickness = 1
	t.set_stylebox("separator", "HSeparator", sep)
	return t

## The panel look: a navy body with a rounded blue rim and a faint glow.
static func panel_box(glow := true) -> StyleBoxFlat:
	var b := StyleBoxFlat.new()
	b.bg_color = Color(PANEL, 0.97)
	b.border_color = Color(BORDER, 0.9)
	b.set_border_width_all(1)
	b.set_corner_radius_all(10)
	b.set_content_margin_all(12)
	b.anti_aliasing = true
	if glow:
		b.shadow_color = Color(ACCENT, 0.18)
		b.shadow_size = 8
	return b

static func _top_only(b: StyleBoxFlat) -> void:
	b.corner_radius_bottom_left = 0
	b.corner_radius_bottom_right = 0
	b.set_corner_radius(CORNER_TOP_LEFT, 8)
	b.set_corner_radius(CORNER_TOP_RIGHT, 8)
	b.content_margin_left = 16; b.content_margin_right = 16
	b.content_margin_top = 8; b.content_margin_bottom = 8

## A drawn image of `w` x `h` pixels, 4x supersampled for smooth edges.
static func _paint(w: int, h: int, shade: Callable) -> ImageTexture:
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	for y in h:
		for x in w:
			var acc := Color(0, 0, 0, 0)
			for sy in 2:
				for sx in 2:
					var c: Color = shade.call(Vector2(x + 0.25 + sx * 0.5, y + 0.25 + sy * 0.5))
					acc += Color(c.r * c.a, c.g * c.a, c.b * c.a, c.a)
			acc /= 4.0
			if acc.a > 0.0: acc = Color(acc.r / acc.a, acc.g / acc.a, acc.b / acc.a, acc.a)
			img.set_pixel(x, y, acc)
	return ImageTexture.create_from_image(img)

## A 44x24 switch: blue with the knob right when on, grey with it left when off.
static func _switch(on: bool, disabled: bool) -> ImageTexture:
	var w := 44; var h := 24
	var track := (ACCENT.darkened(0.1) if on else Color(0.2, 0.25, 0.32))
	var knob := (Color.WHITE if on else Color(0.7, 0.75, 0.82))
	if disabled: track = track.darkened(0.5); knob = knob.darkened(0.45)
	var r := h / 2.0
	var kx := w - r if on else r
	return _paint(w, h, func(px: Vector2) -> Color:
		var c := Vector2(clampf(px.x, r, w - r), r)
		var col := Color(0, 0, 0, 0)
		if px.distance_to(c) <= r: col = track
		if px.distance_to(Vector2(kx, r)) <= r - 3.0: col = knob
		return col)

static func _knob(lit: bool) -> ImageTexture:
	var s := 20
	return _paint(s, s, func(px: Vector2) -> Color:
		var d := px.distance_to(Vector2(s / 2.0, s / 2.0))
		if d <= s / 2.0 - 4.0: return Color.WHITE if lit else Color(0.9, 0.95, 1.0)
		if d <= s / 2.0 - 1.0: return ACCENT
		return Color(0, 0, 0, 0))

static func _chevron() -> ImageTexture:
	return _paint(14, 10, func(px: Vector2) -> Color:
		# Two strokes meeting at the bottom centre.
		var d := minf(Geometry2D.get_closest_point_to_segment(px, Vector2(2, 3), Vector2(7, 8)).distance_to(px),
			Geometry2D.get_closest_point_to_segment(px, Vector2(7, 8), Vector2(12, 3)).distance_to(px))
		return Color(TEXT, clampf(1.6 - d, 0.0, 1.0)))

static func _box(bg: Color, border: Color, width := 1) -> StyleBoxFlat:
	var b := StyleBoxFlat.new()
	b.bg_color = bg
	b.border_color = border
	b.set_border_width_all(width)
	b.set_content_margin_all(10)
	b.content_margin_top = 7
	b.content_margin_bottom = 7
	b.set_corner_radius_all(6)
	b.anti_aliasing = true
	return b

static func label(text: String, size := 16, color := TEXT) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	return l

static func paragraph(text: String, size := 15, color := TEXT) -> Label:
	var l := label(text, size, color)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.custom_minimum_size.x = 120
	return l

static func button(text: String, callback: Callable, enabled := true) -> Button:
	var b := Button.new()
	b.text = text
	b.disabled = not enabled
	b.focus_mode = Control.FOCUS_ALL
	b.alignment = HORIZONTAL_ALIGNMENT_LEFT
	b.pressed.connect(callback)
	return b

## A pixel-art image from the import, scaled crisply.
static func picture(tex: Texture2D, factor := -1.0, region := Rect2()) -> TextureRect:
	var r := TextureRect.new()
	if tex == null: return r
	var t := tex
	if region.size != Vector2.ZERO:
		var a := AtlasTexture.new(); a.atlas = tex; a.region = region; t = a
	r.texture = t
	r.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var f := scale if factor < 0 else factor
	r.custom_minimum_size = t.get_size() * f
	return r


## A panel with an optional title band: the rounded navy body, and for a
## titled frame a lighter band across the top with the caption (and an
## optional drawn icon) and a rule beneath it. `chrome = false` leaves only
## the layout, for a page made of several frames side by side.
class Frame extends PanelContainer:
	var title := ""
	var header := true
	var chrome := true
	var icon := ""
	var art: Control
	const BAND := 46
	func _init(caption := "", with_header := true) -> void:
		title = caption
		# An untitled frame has no title band.
		header = with_header and not caption.is_empty()
		art = FrameArt.new()
		art.frame = self
		art.show_behind_parent = true
		art.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(art, false, Node.INTERNAL_MODE_FRONT)
		_margins()
	func _margins() -> void:
		var s := StyleBoxEmpty.new()
		var pad := 12 if chrome else 0
		s.content_margin_left = pad; s.content_margin_right = pad
		s.content_margin_top = (BAND + 8 if header and chrome else pad); s.content_margin_bottom = pad
		add_theme_stylebox_override("panel", s)
	func set_chrome(on: bool) -> void:
		chrome = on
		_margins()
		queue_redraw()
		art.queue_redraw()
	func _draw() -> void:
		if not chrome or not header or title.is_empty(): return
		var font := get_theme_default_font()
		var x := 18.0
		if not icon.is_empty():
			load("res://src/presentation/ui.gd").draw_icon(self, icon, Rect2(16, 11, 24, 24), Color.WHITE)
			x = 50.0
		draw_string(font, Vector2(x, 31), title, HORIZONTAL_ALIGNMENT_LEFT, size.x - x - 10, 20, Color.WHITE)
	func _notification(what: int) -> void:
		if what == NOTIFICATION_RESIZED: queue_redraw()
		# The container lays its art out like content; it covers the whole
		# frame instead.
		if what == NOTIFICATION_SORT_CHILDREN and art != null:
			art.position = Vector2.ZERO
			art.size = size

## The frame's body: rounded navy panel, glow, title band and rule.
class FrameArt extends Control:
	var frame
	func _notification(what: int) -> void:
		if what == NOTIFICATION_RESIZED: queue_redraw()
	func _draw() -> void:
		if not frame.chrome: return
		var kit = load("res://src/presentation/ui.gd")
		var r := Rect2(Vector2.ZERO, size)
		draw_style_box(kit.panel_box(), r)
		# A faint sheen down the top of the body.
		var sheen := StyleBoxFlat.new()
		sheen.bg_color = Color(kit.PANEL_TOP, 0.55)
		sheen.set_corner_radius_all(10)
		sheen.corner_radius_bottom_left = 0; sheen.corner_radius_bottom_right = 0
		sheen.anti_aliasing = true
		# Only a title band gets the sheen: over a plain list or text it
		# would light the first rows alone.
		if frame.header: draw_style_box(sheen, Rect2(1, 1, size.x - 2, frame.BAND))
		var band: float = frame.BAND
		if frame.header:
			draw_line(Vector2(12, band), Vector2(size.x - 12, band), Color(kit.BORDER, 0.7), 1.0)

## Small line icons drawn with primitives, so they stay sharp at any size:
## audio, display, controls, interface, game, back, cart, chat, hangar,
## map, missions, status, lock, sell, info.
static func draw_icon(ci: CanvasItem, name: String, r: Rect2, col: Color) -> void:
	var s := r.size.x / 24.0
	var o := r.position
	var p := func(x: float, y: float) -> Vector2: return o + Vector2(x, y) * s
	var w := maxf(1.5, 1.8 * s)
	match name:
		"audio":
			ci.draw_colored_polygon(PackedVector2Array([p.call(3, 9), p.call(8, 9), p.call(13, 4), p.call(13, 20), p.call(8, 15), p.call(3, 15)]), col)
			ci.draw_arc(p.call(13, 12), 5 * s, -0.9, 0.9, 12, col, w, true)
			ci.draw_arc(p.call(13, 12), 9 * s, -0.9, 0.9, 16, col, w, true)
		"display":
			ci.draw_rect(Rect2(p.call(2, 4), Vector2(20, 13) * s), col, false, w)
			ci.draw_line(p.call(12, 17), p.call(12, 21), col, w)
			ci.draw_line(p.call(7, 21), p.call(17, 21), col, w)
		"controls":
			ci.draw_arc(p.call(7, 12), 5 * s, PI * 0.5, PI * 1.5, 12, col, w, true)
			ci.draw_arc(p.call(17, 12), 5 * s, -PI * 0.5, PI * 0.5, 12, col, w, true)
			ci.draw_line(p.call(7, 7), p.call(17, 7), col, w)
			ci.draw_line(p.call(7, 17), p.call(17, 17), col, w)
			ci.draw_line(p.call(5, 12), p.call(9, 12), col, w)
			ci.draw_line(p.call(7, 10), p.call(7, 14), col, w)
			ci.draw_circle(p.call(17, 11), 1.3 * s, col)
			ci.draw_circle(p.call(15, 13.5), 1.3 * s, col)
		"interface":
			ci.draw_arc(p.call(12, 12), 9 * s, 0, TAU, 28, col, w, true)
			ci.draw_arc(p.call(12, 12), 3 * s, 0, TAU, 12, col, w, true)
			ci.draw_line(p.call(12, 3), p.call(12, 7), col, w)
		"game":
			for i in 8:
				var a := i * TAU / 8.0
				ci.draw_line(p.call(12, 12) + Vector2(cos(a), sin(a)) * 7 * s, p.call(12, 12) + Vector2(cos(a), sin(a)) * 10 * s, col, w * 1.4)
			ci.draw_arc(p.call(12, 12), 7 * s, 0, TAU, 24, col, w, true)
			ci.draw_arc(p.call(12, 12), 3 * s, 0, TAU, 12, col, w, true)
		"back":
			ci.draw_polyline(PackedVector2Array([p.call(15, 5), p.call(8, 12), p.call(15, 19)]), col, w * 1.2, true)
		"cart":
			ci.draw_polyline(PackedVector2Array([p.call(2, 4), p.call(5, 4), p.call(8, 16), p.call(19, 16), p.call(21, 8), p.call(6, 8)]), col, w, true)
			ci.draw_circle(p.call(9, 20), 1.6 * s, col)
			ci.draw_circle(p.call(18, 20), 1.6 * s, col)
			for x in [10.0, 14.0, 18.0]: ci.draw_line(p.call(x, 8), p.call(x - 0.5, 16), col, w * 0.7)
		"chat":
			ci.draw_rect(Rect2(p.call(3, 4), Vector2(18, 12) * s), col, false, w)
			ci.draw_colored_polygon(PackedVector2Array([p.call(7, 16), p.call(12, 16), p.call(7, 21)]), col)
		"hangar":
			ci.draw_colored_polygon(PackedVector2Array([p.call(12, 3), p.call(15, 12), p.call(22, 17), p.call(15, 17), p.call(12, 21), p.call(9, 17), p.call(2, 17), p.call(9, 12)]), col)
		"map":
			ci.draw_polyline(PackedVector2Array([p.call(2, 6), p.call(8, 3), p.call(16, 6), p.call(22, 3), p.call(22, 18), p.call(16, 21), p.call(8, 18), p.call(2, 21), p.call(2, 6)]), col, w, true)
			ci.draw_line(p.call(8, 3), p.call(8, 18), col, w * 0.8)
			ci.draw_line(p.call(16, 6), p.call(16, 21), col, w * 0.8)
		"missions":
			ci.draw_line(p.call(5, 2), p.call(5, 22), col, w)
			ci.draw_colored_polygon(PackedVector2Array([p.call(5, 3), p.call(20, 3), p.call(16, 8), p.call(20, 13), p.call(5, 13)]), col)
		"status":
			ci.draw_arc(p.call(12, 8), 4.5 * s, 0, TAU, 16, col, w, true)
			ci.draw_arc(p.call(12, 23), 9 * s, PI * 1.1, PI * 1.9, 16, col, w, true)
		"lock":
			ci.draw_rect(Rect2(p.call(5, 11), Vector2(14, 10) * s), col)
			ci.draw_arc(p.call(12, 11), 5 * s, PI, TAU, 12, col, w * 1.2, true)
		"sell":
			ci.draw_polyline(PackedVector2Array([p.call(3, 12), p.call(12, 3), p.call(21, 3), p.call(21, 12), p.call(12, 21), p.call(3, 12)]), col, w, true)
			ci.draw_circle(p.call(16.5, 7.5), 1.6 * s, col)
		_:
			ci.draw_arc(p.call(12, 12), 9 * s, 0, TAU, 24, col, w, true)
			ci.draw_line(p.call(12, 11), p.call(12, 17), col, w)
			ci.draw_circle(p.call(12, 7.5), 1.3 * s, col)

## A list entry without a box of its own until it is chosen or pointed at,
## as the side menus draw theirs.
static func flat_entry(b: Button) -> void:
	var none := _box(Color(0, 0, 0, 0), Color(0, 0, 0, 0))
	b.add_theme_stylebox_override("normal", none)
	b.add_theme_stylebox_override("hover", _box(Color(DEEP.lightened(0.1), 0.7), Color(BORDER, 0.5)))

## A button with a drawn icon before its text: an empty icon slot keeps
## the text clear, and a child draws the icon into it.
static func icon_button(text: String, icon_name: String, callback: Callable, enabled := true) -> Button:
	var b := button(text, callback, enabled)
	add_icon(b, icon_name)
	return b

static var _blank: ImageTexture
static func add_icon(b: Button, icon_name: String, side := 22) -> void:
	if _blank == null or _blank.get_width() != side:
		_blank = ImageTexture.create_from_image(Image.create(side, side, false, Image.FORMAT_RGBA8))
	b.icon = _blank
	b.expand_icon = false
	var mark := IconMark.new()
	mark.icon = icon_name
	mark.side = side
	mark.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_child(mark)

## Draws an icon over its button's empty icon slot, dimmed when disabled.
class IconMark extends Control:
	var icon := ""
	var side := 22
	func _ready() -> void:
		get_parent().resized.connect(queue_redraw)
		get_parent().draw.connect(queue_redraw)
		for sig in ["focus_entered", "focus_exited", "mouse_entered", "mouse_exited"]:
			get_parent().connect(sig, queue_redraw)
	func _draw() -> void:
		var b := get_parent() as Button
		var box := b.get_theme_stylebox("normal")
		var x := box.content_margin_left if box != null else 10.0
		if b.alignment == HORIZONTAL_ALIGNMENT_CENTER:
			var font := b.get_theme_font("font")
			var fs := b.get_theme_font_size("font_size")
			var tw := font.get_string_size(b.text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
			x = (b.size.x - tw - side - b.get_theme_constant("h_separation")) / 2.0
		# The icon takes the colour its text has now: lit when chosen.
		var col := Color(1, 1, 1, 0.4) if b.disabled else Color.WHITE
		if not b.disabled and (b.has_focus() or b.is_hovered()) and b.has_theme_color_override("font_focus_color"):
			col = b.get_theme_color("font_focus_color")
		elif not b.disabled and b.has_theme_color_override("font_color"):
			col = b.get_theme_color("font_color")
		load("res://src/presentation/ui.gd").draw_icon(self, icon, Rect2(Vector2(x, (b.size.y - side) / 2.0), Vector2(side, side)), col)

## Asks before an action that cannot be undone, over whatever is showing:
## the supplied question with Yes and No. No (and Esc or B) is the default,
## so a stray press never overwrites or throws anything away.
static func ask(parent: Node, question: String, yes: Callable, no := Callable(), title := "") -> Control:
	var q := Question.new()
	q.title = title
	q.yes = yes
	q.no = no
	# Its own layer covers the screen and is left alone by containers.
	var layer := CanvasLayer.new()
	layer.layer = 70
	layer.process_mode = Node.PROCESS_MODE_ALWAYS
	layer.add_child(q)
	# A layer stops theme inheritance: the question carries the interface theme.
	if parent.is_inside_tree(): q.theme = parent.get_tree().root.theme
	parent.add_child(layer)
	q.build(question)
	return q

class Question extends Control:
	var yes: Callable
	var no: Callable
	var no_button: Button
	var title := ""
	func build(question: String) -> void:
		var kit = load("res://src/presentation/ui.gd")
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		mouse_filter = Control.MOUSE_FILTER_STOP
		var shade := ColorRect.new()
		shade.color = Color(0, 0, 0, 0.55)
		shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		add_child(shade)
		var centre := CenterContainer.new()
		centre.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		add_child(centre)
		if title.is_empty() and kit.library != null: title = kit.library.text(240)
		var f = kit.Frame.new(title)
		f.custom_minimum_size = Vector2(440, 0)
		centre.add_child(f)
		var box := VBoxContainer.new()
		box.add_theme_constant_override("separation", 12)
		f.add_child(box)
		box.add_child(kit.paragraph(question))
		var row := HBoxContainer.new()
		row.alignment = BoxContainer.ALIGNMENT_CENTER
		row.add_theme_constant_override("separation", 12)
		box.add_child(row)
		var yes_button: Button = kit.button(kit.library.text(38) if kit.library != null else EngineLanguage.translate("Yes"), _answer.bind(true))
		no_button = kit.button(kit.library.text(39) if kit.library != null else EngineLanguage.translate("No"), _answer.bind(false))
		for b in [yes_button, no_button]:
			b.custom_minimum_size = Vector2(140, 44)
			b.alignment = HORIZONTAL_ALIGNMENT_CENTER
			row.add_child(b)
		no_button.grab_focus.call_deferred()
	func _answer(accepted: bool) -> void:
		if is_queued_for_deletion(): return
		get_parent().queue_free()
		queue_free()
		var action := yes if accepted else no
		if action.is_valid(): action.call()
	func _unhandled_input(event: InputEvent) -> void:
		if event.is_action_pressed("ui_cancel") or event.is_action_pressed("pause"):
			get_viewport().set_input_as_handled()
			_answer(false)
