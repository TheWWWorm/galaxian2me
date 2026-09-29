extends SceneTree
## Held upright, the game follows Deep's portrait mode: the logical canvas
## turns to 800x1280, the station drops its section rail for a Back button and
## each page stacks its columns; turned back, everything returns as it was.
const Host := preload("res://tests/support/isolated_app.gd")
const Prefs := preload("res://src/presentation/preferences.gd")
var checks := 0
var failures := 0

func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		print("SKIP: no supplied content"); app.queue_free(); await process_frame; quit(2); return
	var win := root
	win.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_EXPAND
	win.size = Vector2i(720, 1560)
	Prefs.fit_orientation(win)
	check(win.content_scale_size == Vector2i(800, 1280), "an upright window gets the upright canvas (%s)" % win.content_scale_size)
	win.size = Vector2i(1560, 720)
	Prefs.fit_orientation(win)
	check(win.content_scale_size == Vector2i(1280, 800), "a wide window gets the wide canvas")
	var g = app._make_game()
	g.new_game()
	g.session.story_step = 20
	g.session.story_mission = {}
	app.game = g
	app.show_station()
	for i in 4: await process_frame
	var st = app.screen
	if st.conversation != null: st.conversation.queue_free(); st.conversation = null
	st._open_section(0)
	await process_frame
	var shop = (st.current_panel as TabContainer).get_child(0)
	var widths: Array = shop.get_children().map(func(c): return c.custom_minimum_size.x)
	st.size = Vector2(800, 1280)
	await process_frame
	check(not st.rail.visible and st.back_button.visible, "upright: no rail, a Back button instead")
	check(shop.vertical and shop.get_children().all(func(c): return c.custom_minimum_size.x == 0.0), "upright: the shop's columns stack")
	check(st.content.offset_left < 20, "upright: the page takes the full width")
	st.size = Vector2(1280, 800)
	await process_frame
	check(st.rail.visible and st.back_button.visible and st.back_button.text == "✕", "wide again: the rail returns, with a close box for the page")
	check(not shop.vertical and shop.get_children().map(func(c): return c.custom_minimum_size.x) == widths, "wide again: the columns and their widths come back")
	st.size = Vector2(800, 1280)
	await process_frame
	st.back_button.pressed.emit()
	await process_frame
	check(st.current_panel == null and st.home.visible and not st.back_button.visible, "Back returns to the home tiles")
	app.queue_free()
	await process_frame
	print("PORTRAIT LAYOUT: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
