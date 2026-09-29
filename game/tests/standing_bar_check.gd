extends SceneTree
## Status → Reputation: each axis shows which race counts you as an enemy
## or a friend (the original's +-60 lines) and leans the cursor towards the
## race that likes you.
const Host := preload("res://tests/support/isolated_app.gd")
const StandingBar := preload("res://src/screens/station/standing_bar.gd")
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
	var bar := StandingBar.new()
	bar.setup(app, 0, 75)
	check(bar.mood(0) == 1 and bar.mood(1) == 0, "+75: the Terrans are friends, the Vossk enemies")
	bar.setup(app, 0, -61)
	check(bar.mood(0) == 0 and bar.mood(1) == 1, "-61: the other way round")
	bar.setup(app, 1, 60)
	check(bar.mood(0) == 2 and bar.mood(1) == 2, "60 exactly is still neither")
	check(bar.tooltip_text.begins_with(app.library.text(231)), "axis 1 starts with the Nivelians, as the original lays it out")
	bar.setup(app, 0, 500)
	check(bar.standing == 100, "out-of-range standings are held to the bar")
	bar.free()
	var g = app._make_game()
	g.new_game()
	g.session.reputation = [40, 70]
	var saved: Dictionary = g.session.to_dict()
	check(g.session.from_dict(saved).is_empty() and g.session.reputation == [40, 70], "a save keeps its standings")
	saved.erase("reputation_axes")
	check(g.session.from_dict(saved).is_empty() and g.session.reputation == [40, -70] and saved.reputation == [40, 70],
		"an older save's second axis is turned round to the original's sign, once, without touching the file's data")
	g.session.story_step = 20
	app.game = g
	app.show_station()
	for f in 3: await process_frame
	app.screen._open_section(4)
	for f in 3: await process_frame
	check(app.screen.current_panel.find_children("*", "Control", true, false).filter(func(n): return n.get_script() == StandingBar).size() == 2,
		"the Status page draws both axes")
	app.queue_free()
	await process_frame
	print("checks=%d failures=%d" % [checks, failures])
	quit(1 if failures else 0)
