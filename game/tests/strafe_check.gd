extends SceneTree
## Deep's strafe: with the mouse turning the ship, left and right slide it
## sideways without turning it; the setting can make keys always strafe or
## always turn.
const Host := preload("res://tests/support/isolated_app.gd")
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
	app.settings.set_value("controls", "touch", "off")
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
	var c = fs.controls
	c.mouse_steer = true
	c.captured = true
	app.settings.set_value("controls", "strafe", "auto")
	check(c.strafing(), "auto: keys strafe while the captured mouse steers")
	c.captured = false
	check(not c.strafing(), "auto: without the mouse the keys turn")
	app.settings.set_value("controls", "strafe", "always")
	check(c.strafing(), "always strafe")
	app.settings.set_value("controls", "strafe", "never")
	c.captured = true
	check(not c.strafing(), "never strafe")
	# Captured mouse motion turns the ship at once, eased over Deep's 80 ms
	# response, and stops soon after the motion is spent.
	c.captured = true
	c.mouse_owns = true
	c.mouse_turn = Vector2.ZERO
	var motion := InputEventMouseMotion.new()
	motion.relative = Vector2(12, 0)
	c._input(motion)
	var first: Dictionary = c.state(null)
	check(float(first.yaw) > 0.3, "a flick right turns the ship right at once (%.2f)" % float(first.yaw))
	var ticks := 1
	while absf(float(c.state(null).yaw)) > 0.02 and ticks < 60: ticks += 1
	check(ticks <= 20, "and it stops once the motion is spent (%d ticks)" % ticks)
	motion.relative = Vector2(5000, 0)
	c._input(motion)
	var peak := 0.0
	var spent := 0
	while spent < 200:
		var yaw := absf(float(c.state(null).yaw))
		if yaw <= 0.02: break
		peak = maxf(peak, yaw)
		spent += 1
	check(peak <= float(c.MOUSE_RATE) + 0.001, "a huge swipe turns no faster than the mouse ceiling (%.2f)" % peak)
	check(spent < 120, "and its backlog is capped, not queued for seconds (%d ticks)" % spent)
	var space = fs.space
	var p = space.player
	var heading: Vector3 = p.forward()
	var right: Vector3 = -p.basis.x
	var from: Vector3 = p.pos
	for i in 30: space.step(1.0 / 60.0, {"yaw": 0.0, "pitch": 0.0, "strafe": 1.0})
	var moved: Vector3 = p.pos - from
	check(moved.dot(right) > 0.0, "strafing right slides the ship to its right (%.0f)" % moved.dot(right))
	check(p.forward().dot(heading) > 0.9999, "without turning it")
	check(float(p.ai.get("bank", 0.0)) < 0.0, "and it leans into the slide")
	app.queue_free()
	await process_frame
	print("STRAFE: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
