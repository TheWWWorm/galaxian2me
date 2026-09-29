extends SceneTree
## The original's first-time help windows in the station: each opens once,
## at the moment the phone game shows it, and never when turned off.
const Host := preload("res://tests/support/isolated_app.gd")
const Tips := preload("res://src/presentation/tips.gd")
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

## The open help window's text, or "" (and closes it).
func take_help(st) -> String:
	if st.conversation == null: return ""
	var text := str(st.conversation.lines[0].text)
	st.conversation.finished.emit()
	await frames(2)
	return text

func body(app, id: int) -> String:
	return str(Tips.split(app.library.text(id))[1])

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await frames(2)
	if app.library == null:
		check(false, "supplied content installed")
	else:
		app.settings.set_value("interface", "help_popups", true)
		var g = app._make_game()
		g.new_game()
		g.session.story_step = maxi(g.session.story_step, 20)
		g.session.credits = 10000000
		app.game = g
		app.show_station()
		await frames(3)
		var st = app.screen
		st._open_section(0)
		await frames(2)
		check(await take_help(st) == body(app, 309), "the hangar opens with the shop's help")
		var tabs: TabContainer = st.current_panel
		var shop = tabs.get_child(0)
		var equipment := -1
		for e in g.shelf():
			if app.catalogue.category(int(e.id)) != app.catalogue.Category.COMMODITY and int(e.count) > 0 and g.session.cargo_free() > 0:
				equipment = int(e.id)
				break
		if equipment >= 0:
			shop._select(equipment, 0)
			shop._trade()
			await frames(2)
			check(await take_help(st) == body(app, 303), "the first equipment bought brings the note to mount it")
			shop._select(equipment, 0)
			shop._trade()
			await frames(2)
			check(st.conversation == null, "and only the first")
		var ship = tabs.get_child(1)
		tabs.current_tab = 1
		await frames(2)
		check(await take_help(st) == body(app, 310), "the ship tab opens with its help")
		var mounted := Vector2i(-1, -1)
		for c in g.session.equipment.size():
			for i in g.session.equipment[c].size():
				if g.session.equipment[c][i] != null and mounted.x < 0: mounted = Vector2i(c, i)
		if mounted.x >= 0:
			ship._select(mounted.x, mounted.y)
			await frames(2)
			check(await take_help(st) == body(app, 311), "picking a mounted item explains its actions")
		var prints = tabs.get_child(tabs.get_child_count() - 1)
		tabs.current_tab = tabs.get_child_count() - 1
		await frames(2)
		check(await take_help(st) == body(app, 312), "the blueprints tab opens with its help")
		prints._select(0)
		await frames(2)
		check(await take_help(st) == body(app, 313), "a blueprint's ingredients are explained once")
		st.close_panel()
		await frames(2)
		app.settings.set_value("interface", "help_popups", false)
		st._open_section(4)
		await frames(2)
		check(st.conversation == null, "turned off, no help window opens")
		Tips.reset(app)
		check(bool(app.setting("interface", "help_popups", false)) and not app.settings.has_section("help_shown"),
			"Show help again turns them back on and forgets what was seen")
	print("HELP TIPS: %d checks, %d failures" % [checks, failures])
	app.queue_free()
	quit(1 if failures else 0)
