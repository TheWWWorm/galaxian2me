extends SceneTree
## Touch buttons follow the ship, as Deep's do: Boost and Secondary appear
## only when a booster or a secondary launcher is fitted. Fire tapped twice
## quickly turns automatic fire on; one tap while it runs turns it off.
const Host := preload("res://tests/support/isolated_app.gd")
var checks := 0
var failures := 0

func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)

func tap(t, action: String, index: int) -> void:
	var at: Vector2 = t.get_global_transform_with_canvas() * t.buttons[action].get_center()
	var down := InputEventScreenTouch.new(); down.pressed = true; down.index = index; down.position = at
	t._input(down)
	var up := InputEventScreenTouch.new(); up.pressed = false; up.index = index; up.position = at
	t._input(up)

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		print("SKIP: no supplied content"); app.queue_free(); await process_frame; quit(2); return
	app.settings.set_value("controls", "touch", "on")
	app.settings.set_value("controls", "auto_fire", false)
	var g = app._make_game()
	g.new_game()
	g.session.story_step = 20
	g.session.story_mission = {}
	app.game = g
	app.show_flight()
	for i in 4: await process_frame
	var fs = app.screen
	if fs.conversation != null: fs.conversation.queue_free(); fs.conversation = null
	fs.set_paused(false)
	for i in 2: await process_frame
	var t = fs.touch
	var booster := int(g.session.ship_stats().get("boost_length", 0)) > 0
	var launchers: bool = not fs.space.secondary_launchers().is_empty()
	check(t._available("boost") == booster, "Boost is shown exactly when a booster is fitted (%s)" % booster)
	check(t._available("secondary") == launchers, "Secondary exactly when a launcher is fitted (%s)" % launchers)
	if not booster:
		var slots: Array = g.session.equipment[3]
		var free := slots.find(null)
		for id in app.catalogue.data.items.size():
			if app.catalogue.type(id) == 14 and free >= 0:
				slots[free] = {"id": id, "count": 1}
				break
		fs._update_touch_context()
		check(t._available("boost"), "fitting a booster brings the Boost button")
	t.editing = true
	check(t._available("boost") and t._available("secondary"), "the placement editor still shows every button")
	t.editing = false
	tap(t, "fire", 1)
	var first: Dictionary = t.sample()
	check(bool(first.get("fire_pressed", false)) and not first.has("auto_fire"), "one tap fires")
	tap(t, "fire", 2)
	var second: Dictionary = t.sample()
	check(bool(second.get("auto_fire", false)) and not bool(second.get("fire_pressed", false)), "a quick second tap turns automatic fire on")
	app.settings.set_value("controls", "auto_fire", true)
	tap(t, "fire", 3)
	check(bool(t.sample().get("auto_fire", false)), "while it runs, a tap turns it off")
	app.settings.set_value("controls", "auto_fire", false)
	await create_timer(0.4).timeout
	tap(t, "fire", 4)
	var slow_a: Dictionary = t.sample()
	await create_timer(0.4).timeout
	tap(t, "fire", 5)
	check(not t.sample().has("auto_fire") and not slow_a.has("auto_fire"), "two slow taps are just two shots")
	app.queue_free()
	await process_frame
	print("TOUCH FITTED: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
