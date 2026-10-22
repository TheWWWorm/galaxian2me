extends SceneTree
## Interface size: Automatic enlarges a phone's canvas to 1280 on the long
## side, desktops stay as they are, and no choice shrinks the canvas below
## what the screens need. No JAR, saves or rendering needed.
## godot --headless --path game -s res://tests/interface_size_check.gd

const Prefs := preload("res://src/presentation/preferences.gd")

var failures := 0
var checks := 0

func _init() -> void:
	_run.call_deferred()

func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("FAIL: " + label)

## The canvas the interface lays out on for a window of `pixels`.
func canvas(pixels: Vector2i, choice: float, touch: bool) -> Vector2:
	root.size = pixels
	root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_EXPAND
	Prefs._touch = touch
	root.set_meta("ui_size", choice)
	Prefs.fit_orientation(root)
	var base := Vector2(root.content_scale_size)
	var fitted := minf(pixels.x / base.x, pixels.y / base.y)
	return Vector2(pixels) / (fitted * root.content_scale_factor)

func _run() -> void:
	await process_frame
	var phone := canvas(Vector2i(2532, 1170), 0.0, true)
	check(absf(phone.x - 1280.0) < 1.0 and phone.y < 600.0, "Automatic: a landscape phone lays out on 1280 across (%s)" % phone)
	var upright := canvas(Vector2i(1170, 2532), 0.0, true)
	check(absf(upright.y - 1280.0) < 1.0 and upright.x < 600.0, "Automatic: an upright phone keeps the same size (%s)" % upright)
	var tablet := canvas(Vector2i(2048, 1536), 0.0, true)
	check(is_equal_approx(root.content_scale_factor, 1.0), "Automatic: a 4:3 tablet is unchanged (%s)" % tablet)
	var desk := canvas(Vector2i(1920, 1200), 0.0, false)
	check(is_equal_approx(root.content_scale_factor, 1.0) and desk.is_equal_approx(Vector2(1280, 800)), "Automatic: a desktop is unchanged")
	desk = canvas(Vector2i(1920, 1200), 1.15, false)
	check(absf(root.content_scale_factor - 1.15) < 0.001, "115% enlarges a desktop")
	for choice in [1.3, 1.5]:
		for pixels in [Vector2i(1920, 1200), Vector2i(2532, 1170), Vector2i(1170, 2532), Vector2i(1280, 720)]:
			var c := canvas(pixels, choice, true)
			check(minf(c.x, c.y) >= Prefs.MIN_SHORT_SIDE - 0.5 and maxf(c.x, c.y) >= Prefs.MIN_LONG_SIDE - 0.5,
				"%d%% at %s keeps room for every screen (%s)" % [int(choice * 100), pixels, c])
	print("INTERFACE SIZE: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
