extends SceneTree
## Engine trails: fighters leave a ribbon sampled every 200 ms, sixteen
## points long (thirteen for pirates), which starts over after a jump and
## goes with the ship. Memory-only.
const Host := preload("res://tests/support/isolated_app.gd")
const Space := preload("res://src/flight/space.gd")
const View := preload("res://src/flight/space_view.gd")
var checks := 0
var failures := 0

func _init() -> void:
	run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	print("PASS: " if ok else "FAIL: ", label)
	if not ok: failures += 1

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		check(false, "supplied content installed")
	else:
		var g = app._make_game()
		g.new_game()
		g.session.story_step = maxi(g.session.story_step, 20)
		var sim := Space.new(g)
		sim.build()
		sim.story = null
		var view := View.new()
		app.world_root.add_child(view)
		view.setup(app, sim)
		var pirate = sim._spawn_ship(8, sim.player.pos + Vector3(0, 0, 6000), false)
		var trader = sim._spawn_ship(0, sim.player.pos + Vector3(0, 3000, 6000), false)
		for i in 40:
			pirate.pos += Vector3(0, 0, 300)
			trader.pos += Vector3(0, 0, 300)
			sim.clock += 100
			view.sync(0.1)
		check(view.trails.has(pirate) and view.trails.has(trader), "fighters leave trails")
		check(not view.trails.has(sim.player), "the player's own ship leaves none")
		check((view.trails[pirate].points as Array).size() == 13, "a pirate's trail is thirteen points long")
		check((view.trails[trader].points as Array).size() == 16, "other ships' trails are sixteen points long")
		check((view.trail_mesh.mesh as ImmediateMesh).get_surface_count() == 2, "both kinds are drawn")
		pirate.pos += Vector3(50000, 0, 0)
		view.sync(0.1)
		check((view.trails[pirate].points as Array).size() == 1, "a jump starts the trail over")
		pirate.alive = false
		view.sync(0.1)
		check(not view.trails.has(pirate), "a destroyed ship's trail goes")
		view.queue_free()
		sim.dispose()
	print("ENGINE TRAIL: %d checks, %d failures" % [checks, failures])
	app.queue_free()
	quit(1 if failures else 0)
