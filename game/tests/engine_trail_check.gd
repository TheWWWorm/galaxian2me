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
		if sim.story != null: sim.story.space = null
		sim.story = null
		sim.player.exhaust = true
		var view := View.new()
		app.world_root.add_child(view)
		view.setup(app, sim)
		var pirate = sim._spawn_ship(8, sim.player.pos + Vector3(0, 0, 6000), false)
		var trader = sim._spawn_ship(0, sim.player.pos + Vector3(0, 3000, 6000), false)
		for i in 40:
			sim.player.pos += Vector3(0, 0, 300)
			pirate.pos += Vector3(0, 0, 300)
			trader.pos += Vector3(0, 0, 300)
			sim.clock += 100
			view.sync(0.1)
		check(view.trails.has(pirate) and view.trails.has(trader), "fighters leave trails")
		check(view.trails.has(sim.player), "the player's engine trail is on by default")
		check((view.trails[pirate].points as Array).size() == 13, "a pirate's trail is thirteen points long")
		check((view.trails[trader].points as Array).size() == 16, "other ships' trails are sixteen points long")
		check((view.trail_mesh.mesh as ImmediateMesh).get_surface_count() == 2, "both kinds are drawn")
		pirate.pos += Vector3(50000, 0, 0)
		view.sync(0.1)
		check((view.trails[pirate].points as Array).size() == 1, "a jump starts the trail over")
		pirate.alive = false
		view.sync(0.1)
		check(not view.trails.has(pirate), "a destroyed ship's trail goes")
		var emitter: Node3D = view.player_trail_emitter
		check(is_instance_valid(emitter) and view.trails[sim.player].head.is_equal_approx(emitter.global_position / View.UNIT),
			"player trail starts at an imported engine attachment")
		sim.player.basis = Basis(Vector3.UP, 0.7)
		sim.player.ai.bank = 0.4
		view.sync(0.016)
		check(view.trails[sim.player].head.is_equal_approx(emitter.global_position / View.UNIT)
			and not view.trails[sim.player].head.is_equal_approx(sim.player.pos), "the nozzle follows turn and bank without moving to the hull centre")
		for i in 100:
			sim.player.pos += Vector3(50, 0, 100)
			sim.clock += 50
			view.sync(0.05)
		check(view.trails[sim.player].points.size() == View.PLAYER_TRAIL_POINTS, "player history stays bounded through a long turn")
		var count: int = view.trails[sim.player].points.size()
		view.photo = true
		view.photo_yaw = 2.0
		view.sync(0.1)
		check(view.trails[sim.player].points.size() == count, "photo camera motion does not extend a paused trail")
		view.photo = false
		sim.player.pos += Vector3(50000, 0, 0)
		view.sync(0.01)
		check(view.trails[sim.player].points.size() == 1, "player teleport starts a new trail without a connecting beam")
		app.set_setting("graphics", "player_trail", false)
		view.sync(0.01)
		check(not view.trails.has(sim.player) and view.trails.has(trader), "turning off the player trail leaves NPC trails alone")
		app.set_setting("graphics", "player_trail", true)
		view.sync(0.01)
		check(view.trails[sim.player].points.size() == 1, "turning it back on never revives stale history")
		sim.cloak_coef = 0.5
		view.sync(0.01)
		check(not view.trails.has(sim.player), "cloaking removes the whole visible wake")
		sim.cloak_coef = 0.0
		sim.mining = preload("res://src/flight/mining.gd").new(1, 154, 22, app.catalogue)
		view.sync(0.01)
		check(not view.trails.has(sim.player), "mining suppresses the player trail with the engine flames")
		sim.mining = null
		sim.player.exhaust = false
		view.sync(0.01)
		check(not view.trails.has(sim.player), "scripted engines-off scenes have no player trail")
		sim.player.exhaust = true
		view.sync(0.01)
		sim.player.alive = false
		view.sync(0.01)
		check(not view.trails.has(sim.player), "a destroyed player leaves no lingering beam")
		sim.player.alive = true
		sim.player.visible = false
		view.sync(0.01)
		await process_frame
		check(not view.trails.has(sim.player), "hiding the player discards the wake and its retired emitter")
		sim.player.visible = true
		view.sync(0.01)
		check(view.trails.has(sim.player) and view.trails[sim.player].points.size() == 1,
			"a reappearing player reattaches to the new displayed ship")
		# A supplied assembly with no booster must not get a centre-of-hull
		# substitute. Locate it by its parts, independently of hull numbering.
		var without_engine := -1
		for key in app.library.data.ship_parts:
			var parts: Array = app.library.data.ship_parts[key]
			if not parts.is_empty() and parts.all(func(p): return not View.Assembly.is_booster(int(p.model))):
				without_engine = int(key)
				break
		if without_engine >= 0:
			sim.player.visible = false
			view.sync(0.01)
			await process_frame
			sim.player.ship_index = without_engine
			sim.player.visible = true
			var notices: Array = []
			sim.event.connect(func(kind, data):
				if kind == "message": notices.append(data.text))
			for i in 3: view.sync(0.01)
			check(not view.trails.has(sim.player) and notices == ["Player engine trail is unavailable for this ship."],
				"an assembly without an engine is reported once and gets no invented trail")
		check(app.save_attempts.is_empty(), "trail presentation never saves the game")
		view.queue_free()
		await process_frame
		sim.dispose()
	print("ENGINE TRAIL: %d checks, %d failures" % [checks, failures])
	app.queue_free()
	await process_frame
	quit(1 if failures else 0)
