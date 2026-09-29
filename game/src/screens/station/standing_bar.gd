extends Control
## One reputation axis drawn with the original's standing art: each race's
## logo and half of the bar, coloured by whether that race counts you as an
## enemy, a friend or neither, and the cursor that leans towards the race
## that likes you. Axis 0 is Terran (left) against Vossk, axis 1 Nivelian
## (left) against Midorian; a positive standing favours the left.

var app
var axis := 0
var standing := 0
## Frames of logos_small and the names (texts 229-232), left then right.
const LOGOS := [[0, 1], [2, 3]]
const NAMES := [[229, 230], [231, 232]]
const MAX_SCALE := 3.0
## Name colours: enemy, friend, neither.
const MOOD_COLORS := [Color(1, 0.45, 0.4), Color(0.55, 0.9, 0.55), Color(0.85, 0.88, 0.95)]

func _init() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	custom_minimum_size = Vector2(320, 76)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mouse_filter = Control.MOUSE_FILTER_PASS

func setup(p_app, p_axis: int, p_standing: int) -> void:
	app = p_app
	axis = p_axis
	standing = clampi(p_standing, -100, 100)
	var names: Array = NAMES[axis]
	tooltip_text = "%s %+d  ·  %s %+d" % [app.library.text(names[0]), standing, app.library.text(names[1]), -standing]
	queue_redraw()

## 0 enemy, 1 friend, 2 neither, for the race on `side` (0 left, 1 right).
func mood(side: int) -> int:
	var lean := standing if side == 0 else -standing
	if lean < -60: return 0
	if lean > 60: return 1
	return 2

func _draw() -> void:
	if app == null: return
	var lib = app.library
	var outer: Texture2D = lib.texture("standing_0")
	var inner: Texture2D = lib.texture("standing_1")
	var cursor: Texture2D = lib.texture("standing_2")
	var logos: Texture2D = lib.texture("logos_small")
	if outer == null or inner == null or cursor == null or logos == null: return
	var ow := outer.get_width() / 3.0
	var oh := float(outer.get_height())
	var logo := float(logos.get_height())
	var span := ow + 1.0 + inner.get_width()
	# As large as the row allows, up to three phone pixels to one.
	var k := clampf((size.x / 2.0 - 4.0) / (span + 4.0 + logo), 1.0, MAX_SCALE)
	var half := span * k
	var c := size.x / 2.0
	var base := maxf(oh, logo) * k
	var font := get_theme_default_font()
	for side in 2:
		# The left half is drawn as painted, the right half mirrored, as the
		# original does: outer piece at the far end, inner piece meeting the
		# centre.
		var region := Rect2(mood(side) * ow, 0, ow, oh)
		if side == 0: draw_set_transform(Vector2(c - half, 0), 0.0, Vector2(k, k))
		else: draw_set_transform(Vector2(c + half, 0), 0.0, Vector2(-k, k))
		draw_texture_rect_region(outer, Rect2(Vector2(0, base / k - oh), Vector2(ow, oh)), region)
		draw_texture_rect(inner, Rect2(Vector2(ow + 1.0, base / k - inner.get_height()), inner.get_size()), false)
		draw_set_transform(Vector2.ZERO)
		var at := Vector2(c - half - 4.0 * k - logo * k if side == 0 else c + half + 4.0 * k, base - logo * k)
		var frame := int(LOGOS[axis][side])
		draw_texture_rect_region(logos, Rect2(at, Vector2(logo, logo) * k), Rect2(frame * logo, 0, logo, logo))
		var name: String = lib.text(int(NAMES[axis][side]))
		var width := font.get_string_size(name, HORIZONTAL_ALIGNMENT_LEFT, -1, 14).x
		var tx := c - half if side == 0 else c + half - width
		draw_string(font, Vector2(tx, base + cursor.get_height() * k + 16.0), name, HORIZONTAL_ALIGNMENT_LEFT, -1, 14, MOOD_COLORS[mood(side)])
	# The cursor hangs under the bar, leaning towards the race that likes you.
	var x := c - standing / 100.0 * half
	var cs := cursor.get_size() * k
	draw_texture_rect(cursor, Rect2(Vector2(x - cs.x / 2.0, base), cs), false)
