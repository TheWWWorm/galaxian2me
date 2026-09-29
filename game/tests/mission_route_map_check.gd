extends SceneTree
## The map's way to a mission: fewest gate jumps through known systems, each
## step a supplied link; the Missions page counts the same jumps and its
## Map button opens the map on the destination.
const Host := preload("res://tests/support/isolated_app.gd")
const Navigation := preload("res://src/simulation/navigation.gd")
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
	app.settings.set_value("interface", "help_popups", false)
	var g = app._make_game()
	g.new_game()
	for i in 38: g.campaign.advance()
	app.game = g
	var cat = app.catalogue
	var goal: int = cat.system_of_station(int(g.session.story_mission.station))
	g.session.station_id = int(cat.system(0).stations[0]) if goal != 0 else int(cat.system(1).stations[0])
	g.session.system_index = cat.system_of_station(g.session.station_id)
	app.show_station()
	for i in 4: await process_frame
	var st = app.screen
	st._open_section(2)
	await process_frame
	var map = st.current_panel
	var path: Array = map.route(g.session.system_index, goal)
	var linked := true
	for n in range(1, path.size()):
		linked = linked and (cat.system(path[n - 1]).links as Array).any(func(l): return int(l) == int(path[n]))
		linked = linked and Navigation.known(g.session, cat, int(path[n]))
	check(path.size() >= 2 and path[0] == g.session.system_index and path.back() == goal and linked,
		"the route runs from here to the goal along known links")
	check(map.route(goal, goal).is_empty(), "no route to where you already are")
	st.close_panel()
	await process_frame
	st._open_section(3)
	await process_frame
	var missions = st.current_panel
	check(missions.jumps_to(goal) == path.size() - 1, "the Missions page counts the same jumps")
	var button: Button = null
	for b in missions.find_children("*", "Button", true, false):
		if b.text == app.library.text(72): button = b
	check(button != null, "the destination card has a Map button")
	if button != null:
		button.pressed.emit()
		await process_frame
		check(st.current_panel.get("selected_system") == goal, "which opens the map on the destination")
	app.queue_free()
	await process_frame
	print("MISSION ROUTE MAP: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
