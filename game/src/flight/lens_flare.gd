extends Control
## The original's lens flare: while the system's sun is in front of the
## camera, its four flare images and the small main flare are laid along the
## line from the sun through the centre of the screen, added over the view.

const Prefs := preload("res://src/presentation/preferences.gd")

var app
var view
var flares: Array[Texture2D] = []

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var add := CanvasItemMaterial.new()
	add.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	material = add
	for i in 4: flares.append(app.library.texture("lens%d" % i))

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if view == null or view.backdrop == null or flares.has(null): return
	if not bool(app.setting("graphics", "lens_flare", true)): return
	var cam: Camera3D = view.camera
	var sun: Vector3 = cam.global_position + view.backdrop.sun_direction * 1000.0
	if cam.is_position_behind(sun): return
	var size := get_viewport_rect().size
	var s := cam.unproject_position(sun)
	# The original stops drawing once the sun is more than a screen away.
	if s.x < -size.x or s.x > size.x * 2.0 or s.y < -size.y or s.y > size.y * 2.0: return
	var c := size / 2.0
	var along := s - c
	# Phone pixels to this screen, and fading as the sun leaves the view.
	var k := size.y / 320.0
	var inside := clampf(1.5 - maxf(absf(along.x) / c.x, absf(along.y) / c.y), 0.0, 1.0)
	if inside <= 0.0: return
	var tint := Color(1, 1, 1, inside * (0.55 if Prefs.reduce_flashing(app) else 0.9))
	var main: Texture2D = flares[1]
	var pairs := [[0, 0.5, 1.0 / 3.0], [1, 1.0 / 8.0, -0.5], [2, -0.25, -1.0 / 6.0], [3, -1.0 / 7.0, -0.1]]
	for p in pairs:
		_put(flares[p[0]], c + along * float(p[1]), k, tint)
		_put(main, c + along * float(p[2]), k * 0.25, tint)

func _put(tex: Texture2D, at: Vector2, k: float, tint: Color) -> void:
	var extent := tex.get_size() * k
	draw_texture_rect(tex, Rect2(at - extent / 2.0, extent), false, tint)
