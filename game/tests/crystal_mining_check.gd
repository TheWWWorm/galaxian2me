extends SceneTree
## Synthetic no-save unit fixtures. Never an earned campaign input.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
const Body := preload("res://src/flight/body.gd")
const Mining := preload("res://src/flight/mining.gd")
var checks := 0
var failures := 0
func _init() -> void:
	run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)
func drill_to_end(mining) -> void:
	for tick in 6000:
		var yaw := -1.0 if mining.drill > 1.0 else (1.0 if mining.drill < -1.0 else 0.0)
		if not mining.step(16, yaw < -0.3, yaw > 0.3): return
	check(false, "native drill finishes within bounded ordinary steering inputs")
func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		check(false, "supplied content installed")
	else:
		for sign_value in [-1.0, 1.0]:
			var edge := Mining.new(7, 164, 87, app.catalogue)
			edge.drill = 22.75 * sign_value
			edge.step(16, false, false)
			check(edge.red == 0 and edge.layer_time == 16, "original integer green-zone edge includes fractional drill at %s" % (22.75 * sign_value))
			var outside := Mining.new(7, 164, 87, app.catalogue)
			outside.drill = 23.0 * sign_value
			outside.step(16, false, false)
			check(outside.red == 16 and outside.layer_time == 0, "next integer beyond green zone accumulates red time")
		var odd := Mining.new(7, 164, 87, app.catalogue)
		odd.layer = 1
		check(odd.half_width() == 60.0, "original odd layer outer clamp uses integer division")
		for free_space in [0, 1, 2, 54]:
			var game := Game.new(app.library, app.catalogue)
			game.new_game()
			game.session.ship.index = 5
			game.session.fit_slots()
			game.session.cargo = {"133": 60 - free_space} if free_space < 60 else {}
			var space := Space.new(game)
			var rock := Body.new()
			rock.kind = Body.Kind.ASTEROID
			rock.ore = 164
			rock.ore_class = 7
			space.bodies.append(rock)
			space.mining_target = rock
			space.mining = Mining.new(7, 164, 87, app.catalogue)
			drill_to_end(space.mining)
			check(space.mining.success and space.mining.core_found(), "real seven-layer drill earns core using fitted-catalogue drill attributes")
			var tons := int(space.mining.tons)
			var core := 1 if free_space > 0 else 0
			var amount := mini(tons, maxi(0, free_space - core))
			var prior_ore: int = game.session.stat("ore_mined")
			var prior_core: int = game.session.stat("cores_mined")
			space._finish_mining()
			check(game.session.cargo_count(164) == amount and game.session.cargo_count(175) == core,
				"core-first crystal settlement respects %d actual free tonnes" % free_space)
			check(game.session.stat("ore_mined") == prior_ore + amount and game.session.stat("cores_mined") == prior_core + core,
				"mining statistics count accepted ore and core, not unclipped yield")
			check(game.session.cargo_free() >= 0 and game.session.cargo_count(133) == 60 - free_space,
				"settlement preserves unrelated hold and never overloads hull")
			check(not rock.alive and rock.ore == -1 and space.mining == null and space.mining_target == null,
				"mined rock is spent and drill lifecycle ends")
			check(space.bodies.all(func(b): return b.kind != Body.Kind.LOOT), "mined crystal cannot duplicate ore/core as a salvage drop")
			space.dispose()
		var burst_game := Game.new(app.library, app.catalogue)
		burst_game.new_game()
		var burst := Space.new(burst_game)
		for i in 100:
			var crystal := Body.new()
			crystal.kind = Body.Kind.ASTEROID
			crystal.ore = 164
			crystal.ore_class = 7
			burst._break_asteroid(crystal)
		check(burst.bodies.is_empty() and burst_game.session.cargo_count(164) == 0, "shooting crystal rocks never replaces drilling with dropped crystal cargo")
		burst.dispose()
		check(app.save_attempts.is_empty(), "mining fixtures never create player or campaign saves")
	app.queue_free()
	await process_frame
	await process_frame
	print("CRYSTAL MINING: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
