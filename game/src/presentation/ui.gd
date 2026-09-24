extends RefCounted
## Interface kit in the original's look: dark tiled panels with the black and
## blue double border, the patterned header strip and its corner piece, and
## the original's greens and blues for selection. Text is drawn with a crisp
## native font; artwork (icons, portraits, logos) comes from the import.

const BORDER := Color8(0x25, 0x5d, 0x8d)
const BORDER_DARK := Color8(0x24, 0x4d, 0x70)
const DEEP := Color8(0x0d, 0x29, 0x41)
const GREEN := Color8(0x6a, 0xb7, 0x64)
const GREEN_DARK := Color8(0x29, 0x4a, 0x2c)
const GREY := Color8(0x1c, 0x1c, 0x1c)
const TEXT := Color8(0xe6, 0xee, 0xf4)
const TEXT_DIM := Color8(0x8f, 0xa7, 0xbb)
const TEXT_GOOD := Color8(0x9b, 0xe0, 0x8f)
const TEXT_WARN := Color8(0xff, 0x8a, 0x5c)
const HIGHLIGHT := Color8(0x3f, 0x86, 0xc2)

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

static func make_theme() -> Theme:
	var t := Theme.new()
	var font := SystemFont.new()
	font.font_names = PackedStringArray(["DejaVu Sans", "Noto Sans", "Liberation Sans", "Arial", "sans-serif"])
	font.antialiasing = TextServer.FONT_ANTIALIASING_GRAY
	font.hinting = TextServer.HINTING_LIGHT
	t.default_font = font
	t.default_font_size = 16
	for type in ["Label", "Button", "LineEdit", "RichTextLabel", "CheckBox", "OptionButton", "ItemList"]:
		t.set_color("font_color", type, TEXT)
	t.set_color("default_color", "RichTextLabel", TEXT)
	t.set_color("font_hover_color", "Button", Color.WHITE)
	t.set_color("font_pressed_color", "Button", Color.WHITE)
	t.set_color("font_focus_color", "Button", Color.WHITE)
	t.set_color("font_disabled_color", "Button", Color(0.5, 0.56, 0.62))
	t.set_stylebox("normal", "Button", _box(DEEP.darkened(0.2), BORDER_DARK))
	t.set_stylebox("hover", "Button", _box(DEEP.lightened(0.08), BORDER))
	t.set_stylebox("pressed", "Button", _box(HIGHLIGHT.darkened(0.3), BORDER))
	t.set_stylebox("focus", "Button", _box(Color(0, 0, 0, 0), GREEN, 2))
	t.set_stylebox("disabled", "Button", _box(GREY, Color(0.25, 0.28, 0.3)))
	t.set_stylebox("panel", "PanelContainer", _box(Color(0.02, 0.06, 0.1, 0.92), BORDER))
	t.set_stylebox("panel", "Panel", _box(Color(0.02, 0.06, 0.1, 0.92), BORDER))
	t.set_stylebox("normal", "LineEdit", _box(Color(0, 0, 0, 0.6), BORDER_DARK))
	t.set_stylebox("focus", "LineEdit", _box(Color(0, 0, 0, 0.6), GREEN, 2))
	var grab := StyleBoxFlat.new(); grab.bg_color = BORDER; grab.set_corner_radius_all(2)
	t.set_stylebox("grabber", "VScrollBar", grab)
	t.set_stylebox("grabber_highlight", "VScrollBar", grab)
	t.set_stylebox("grabber_pressed", "VScrollBar", grab)
	var track := StyleBoxFlat.new(); track.bg_color = Color(0, 0, 0, 0.35)
	t.set_stylebox("scroll", "VScrollBar", track)
	var bar_bg := _box(Color(0, 0, 0, 0.5), BORDER_DARK)
	var bar_fill := StyleBoxFlat.new(); bar_fill.bg_color = GREEN
	t.set_stylebox("background", "ProgressBar", bar_bg)
	t.set_stylebox("fill", "ProgressBar", bar_fill)
	return t

static func _box(bg: Color, border: Color, width := 1) -> StyleBoxFlat:
	var b := StyleBoxFlat.new()
	b.bg_color = bg
	b.border_color = border
	b.set_border_width_all(width)
	b.set_content_margin_all(8)
	b.content_margin_top = 5
	b.content_margin_bottom = 5
	b.set_corner_radius_all(2)
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


## A framed panel drawn like the original's menu windows.
class Frame extends PanelContainer:
	var title := ""
	var header := true
	func _init(caption := "", with_header := true) -> void:
		title = caption
		header = with_header
		texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
		texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		var s := StyleBoxEmpty.new()
		s.content_margin_left = 10; s.content_margin_right = 10
		s.content_margin_top = (40 if header else 10); s.content_margin_bottom = 10
		add_theme_stylebox_override("panel", s)
	func _draw() -> void:
		var r := Rect2(Vector2.ZERO, size)
		var bg = load("res://src/presentation/ui.gd").art("menu_background")
		if bg != null:
			draw_texture_rect(bg, r, true, Color(1, 1, 1, 1))
		else:
			draw_rect(r, Color(0.03, 0.08, 0.13))
		draw_rect(r.grow(-1), Color.BLACK, false, 2.0)
		draw_rect(r.grow(-3), load("res://src/presentation/ui.gd").BORDER, false, 2.0)
		if header:
			var strip := Rect2(4, 4, size.x - 8, 26)
			var pattern = load("res://src/presentation/ui.gd").art("menu_header_pattern")
			if pattern != null:
				draw_texture_rect(pattern, strip, true)
			draw_line(Vector2(4, 31), Vector2(size.x - 4, 31), load("res://src/presentation/ui.gd").BORDER, 2.0)
			draw_line(Vector2(3, 29), Vector2(size.x - 3, 29), Color.BLACK, 1.0)
			var corner = load("res://src/presentation/ui.gd").art("menu_main_corner")
			if corner != null: draw_texture_rect(corner, Rect2(0, 0, 16, 16), false)
			if not title.is_empty():
				var font := get_theme_default_font()
				draw_string(font, Vector2(14, 23), title, HORIZONTAL_ALIGNMENT_LEFT, size.x - 20, 17, Color.WHITE)
	func _notification(what: int) -> void:
		if what == NOTIFICATION_RESIZED: queue_redraw()
