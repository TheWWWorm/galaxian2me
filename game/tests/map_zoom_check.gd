extends SceneTree
## The station chart zooms about the pointer, pans by dragging within its
## bounds, and picks a system only on a click that did not move. Memory-only.
const Host := preload("res://tests/support/isolated_app.gd")
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

func click(c: Control, at: Vector2, down: bool, button := MOUSE_BUTTON_LEFT) -> void:
	var e := InputEventMouseButton.new()
	e.button_index = button; e.pressed = down; e.position = at
	c._gui_input(e)

func run() -> void:
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
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
		await frames(3)
		app.screen._open_section(2)
		await frames(3)
		var map = app.screen.current_panel
		var c: Control = map.canvas
		var known: Array = []
		for i in app.catalogue.system_count():
			if map._known(i): known.append(i)
		check(known.size() >= 2, "the chart shows systems")
		check(map.showroom != null and map.showroom.station_id == g.session.station_id, "the card's showroom starts on this station")
		var other_sid := -1
		for sid in app.catalogue.system(g.session.system_index).stations:
			if int(sid) != g.session.station_id: other_sid = int(sid)
		if other_sid >= 0:
			map._show_station(other_sid)
			check(map.showroom.station_id == other_sid, "pointing at another station shows it instead")
		var sys: int = known[known.size() - 1]
		var before: Vector2 = map._to_screen(c, app.catalogue.system(sys))
		map.zoom_at(c, before, 2.0)
		var after: Vector2 = map._to_screen(c, app.catalogue.system(sys))
		check(is_equal_approx(map.zoom, 2.0), "zooming in doubles the scale")
		check(after.distance_to(before) < 1.0 or map.pan.abs().is_equal_approx(map._map_rect(c).size / 2.0),
			"the point under the pointer stays put (or the chart meets its edge)")
		map.zoom_at(c, before, 100.0)
		check(is_equal_approx(map.zoom, map.MAX_ZOOM), "zoom stops at its limit")
		map.zoom_at(c, before, 0.001)
		check(is_equal_approx(map.zoom, 1.0) and map.pan == Vector2.ZERO, "zoomed out, the chart is whole and centred")

		# A drag pans and does not pick; a still click picks.
		map.zoom_at(c, c.size / 2.0, 2.0)
		var chosen: int = map.selected_system
		var other: int = known[0] if known[0] != chosen else known[1]
		var spot: Vector2 = map._to_screen(c, app.catalogue.system(other))
		var pan_before: Vector2 = map.pan
		click(c, spot, true)
		var m := InputEventMouseMotion.new()
		m.position = spot + Vector2(40, 0); m.relative = Vector2(40, 0)
		c._gui_input(m)
		click(c, spot + Vector2(40, 0), false)
		check(map.pan != pan_before and map.selected_system == chosen, "a drag pans the chart without choosing")
		spot = map._to_screen(c, app.catalogue.system(other))
		click(c, spot, true)
		click(c, spot, false)
		check(map.selected_system == other, "a still click chooses the system under it")
		var zoom_before: float = map.zoom
		click(c, c.size / 2.0, true, MOUSE_BUTTON_WHEEL_UP)
		check(map.zoom > zoom_before, "the wheel zooms")
		# Recent trips: the last six systems reached, saved with the game.
		var g2 = app._make_game()
		g2.new_game()
		var systems: Array = []
		for sid in 200:
			var home: int = app.catalogue.system_of_station(sid)
			if home >= 0 and not systems.has(home): systems.append(home)
		for each in systems.slice(0, 8):
			g2.jump_arrive(each, int(app.catalogue.system(each).stations[0]))
		g2.jump_arrive(int(systems[7]), int(app.catalogue.system(systems[7]).stations[0]))
		var trail: Array = g2.session.flags.get("recent_systems", [])
		check(trail.size() == 6 and int(trail.back()) == int(systems[7]) and int(trail[0]) == int(systems[2]), "the trail keeps the last six systems, once each in a row")
		var saved: Dictionary = JSON.parse_string(JSON.stringify(g2.session.to_dict()))
		var g3 = app._make_game()
		check(g3.session.from_dict(saved).is_empty() and g3.session.flags.recent_systems.size() == 6, "the trail survives saving and loading")
		saved.flags.recent_systems = [0, 1, 2, 3, 4, 5, 6]
		check(not app._make_game().session.from_dict(saved).is_empty(), "an overlong trail is rejected")
		saved.flags.recent_systems = [99999]
		check(not app._make_game().session.from_dict(saved).is_empty(), "a trail through an unknown system is rejected")
	print("MAP ZOOM: %d checks, %d failures" % [checks, failures])
	app.queue_free()
	quit(1 if failures else 0)
