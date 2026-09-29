extends SceneTree
## A station section opened from the keyboard or pad puts the highlight on
## its first entry; in the Space Lounge that shows who is there without
## starting a conversation. Opened by pointer, focus is left alone.
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

func run() -> void:
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
		var st = app.screen
		var people: Array = g.lounge()
		Input.action_press("ui_accept")
		st._open_section(1)
		Input.action_release("ui_accept")
		await frames(3)
		var lounge = st.current_panel
		var owner := root.gui_get_focus_owner()
		check(owner != null and lounge.list.is_ancestor_of(owner), "the first person in the lounge is highlighted")
		if not people.is_empty():
			var shown := false
			for l in lounge.detail.find_children("*", "Label", true, false):
				if (l as Label).text == str(people[0].name): shown = true
			check(shown and lounge.selected == -1 and not bool(people[0].get("talked", false)),
				"their portrait and name show without starting a conversation")
		st.close_panel()
		await frames(2)
		st._open_section(3)
		await frames(3)
		var now := root.gui_get_focus_owner()
		check(now == null or not st.current_panel.is_ancestor_of(now), "a section opened by pointer does not take the focus into the page")
	print("SECTION FOCUS: %d checks, %d failures" % [checks, failures])
	app.queue_free()
	quit(1 if failures else 0)
