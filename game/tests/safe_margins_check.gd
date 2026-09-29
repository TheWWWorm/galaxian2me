extends SceneTree
## A phone's notch: menus and the touch controls move clear of it on both
## sides, while nothing moves on a screen without one. Memory-only.
const Host := preload("res://tests/support/isolated_app.gd")
const Safe := preload("res://src/presentation/safe_margins.gd")
var checks := 0
var failures := 0

func _init() -> void:
	run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	print("PASS: " if ok else "FAIL: ", label)
	if not ok: failures += 1
func frames(n: int) -> void:
	for i in n: await process_frame

func run() -> void:
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
	root.size = Vector2i(2000, 900)
	var none := Safe.margins(Vector2(1280, 800), true)
	check(none.side == 0.0 and none.top == 0.0 and none.bottom == 0.0, "a tablet-shaped screen without a cutout keeps the full width")
	check(Safe.margins(Vector2(2000, 900), true).side > 0.0 and Safe.margins(Vector2(2000, 900), false).side == 0.0,
		"a wide phone's touch layout keeps a margin even when none is reported")
	Safe.forced = {"left": 0.05, "right": 0.0, "top": 0.0, "bottom": 0.02}
	var m := Safe.margins(Vector2(2000, 900), false)
	check(m.side == 100.0 and m.bottom == 18.0, "the larger side inset applies to both sides")
	var app := Host.new()
	root.add_child(app)
	await frames(2)
	if app.library == null:
		check(false, "supplied content installed")
	else:
		var g = app._make_game()
		g.new_game()
		g.session.story_step = maxi(g.session.story_step, 20)
		app.game = g
		app.show_station()
		await frames(2)
		var st: Control = app.screen
		check(st.offset_left == 100.0 and st.offset_right == -100.0 and st.offset_bottom == -18.0, "the station menus keep clear of the cutout")
		app.show_flight()
		await frames(3)
		var fs = app.screen
		check((fs as Control).offset_left == 0.0, "the flight view itself still fills the screen")
		check(fs.touch != null and fs.touch.offset_left >= 100.0 and fs.touch.offset_right <= -100.0, "the touch controls keep clear of it")
		check(fs.hud.area.x > 0.0 and fs.hud.area.x <= 2000.0 - 200.0, "the instrument panels are laid out inside the margins")
	Safe.forced = {}
	print("SAFE MARGINS: %d checks, %d failures" % [checks, failures])
	app.queue_free()
	quit(1 if failures else 0)
