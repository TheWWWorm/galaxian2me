extends SceneTree
## Engine flames burn as the original's do: always on a flying ship, drawn out
## while boosting, out while the drill is in a rock and wherever a scripted
## scene puts them out. The opening shows all three pirates with their engines
## off, and its fight keeps the HUD to the crosshair and ship markers.
const Host := preload("res://tests/support/isolated_app.gd")
const Body := preload("res://src/flight/body.gd")
var checks := 0
var failures := 0

func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)

func flames(fs, b) -> Node3D:
	fs.view.sync(0.016)
	var n: Node3D = fs.view.nodes.get(b)
	return n.get_node_or_null("Boosters") if n != null else null

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		print("SKIP: no supplied content"); app.queue_free(); await process_frame; quit(2); return
	app.settings.set_value("controls", "touch", "off")
	var g = app._make_game()
	g.new_game()
	app.game = g
	app.show_flight()
	for i in 4: await process_frame
	var fs = app.screen
	var st = fs.space.story
	check(st != null and st.cast.size() == 3, "the opening has its three pirates")
	check(st.cast.all(func(b): return b.visible and not b.exhaust), "all three are in sight with their engines out")
	check(fs.conversation == null, "the opening's briefing waits for the original's five-second check")
	var held: Vector3 = fs.space.player.pos
	for i in 30: fs.space.step(1.0 / 60.0, {})
	check(fs.space.player.pos.is_equal_approx(held), "the ship is held still through the silent start, as the original freezes it")
	# Nothing but the pirates can be locked, and no autopilot or map: the
	# opening cannot be left for a station.
	check(fs.space.in_opening(), "a new game starts in the opening")
	var stars: Array = fs.space.bodies.filter(func(b): return b.kind == Body.Kind.STAR)
	if not stars.is_empty():
		var dir: Vector3 = fs.space._star_direction(stars[0])
		fs.space.player.basis = Basis.looking_at(-dir)
		check(fs.space.player.forward().dot(dir) > 0.99 and fs.space._aimed_body() == null, "aiming straight at the planet %s locks nothing" % stars[0].name)
	st.controls_locked = false
	fs.space.step(1.0 / 60.0, {"autopilot": true, "map": true})
	check(not fs.space.autopilot, "the autopilot stays off in the opening")
	st.controls_locked = true
	var boosters := flames(fs, st.cast[0])
	check(boosters != null and not boosters.visible, "a pirate's flames are not drawn while its engine is out")
	st.stage = 5
	for i in 9: st.finished[i] = true; st.fired[i] = true
	st._run_opening(16)
	check(st.radar_only and not st.hud_hidden, "the opening fight shows only the crosshair and markers")
	st._run_opening(16)
	check(st.cast.all(func(b): return b.exhaust), "the pirates' engines light when they wake")
	app.queue_free()
	await process_frame
	# An ordinary flight: the player's flames burn without boosting.
	app = Host.new()
	root.add_child(app)
	await process_frame
	app.settings.set_value("controls", "touch", "off")
	g = app._make_game()
	g.new_game()
	g.session.story_step = 20
	g.session.story_mission = {}
	app.game = g
	app.show_flight()
	for i in 4: await process_frame
	fs = app.screen
	if fs.conversation != null: fs.conversation.queue_free(); fs.conversation = null
	fs.set_paused(false)
	var p: Body = fs.space.player
	boosters = flames(fs, p)
	check(boosters != null and boosters.get_child_count() > 0, "the ship carries its engine flames")
	check(boosters.visible, "the flames burn without boosting")
	var rest: Vector3 = (boosters.get_child(0) as Node3D).basis.get_scale()
	p.boosting = true
	fs.space.boost_length = 6000
	fs.space.boost_time = 3000
	flames(fs, p)
	var long: Vector3 = (boosters.get_child(0) as Node3D).basis.get_scale()
	check(long.length() > rest.length() + 0.5, "boosting draws them out (%.2f > %.2f)" % [long.length(), rest.length()])
	p.boosting = false
	flames(fs, p)
	check(is_equal_approx((boosters.get_child(0) as Node3D).basis.get_scale().length(), rest.length()), "and they settle back afterwards")
	p.exhaust = false
	check(not flames(fs, p).visible, "a scene can put them out")
	app.queue_free()
	await process_frame
	print("EXHAUST OPENING: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
