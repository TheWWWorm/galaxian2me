extends "res://tests/transit_pilot_check.gd"
## Memory-only policy fixture for the observed Néhma transit orbit.
## Full shield and no damage for 500 seconds must not require hunting traffic.
func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		check(false, "supplied content available")
	else:
		var game := Game.new(app.library, app.catalogue)
		game.new_game()
		var space := Space.new(game)
		space.player = Body.new()
		space.player.kind = Body.Kind.PLAYER
		space.player.pos = Vector3(23514.23, -16672.73, -14575.27)
		space.player.basis = Body.facing(-space.player.pos)
		space.player.shield_max = 120
		space.player.shield = 120
		space.player.weapons = [{"kind": "gun", "speed": 16.0, "life": 3000, "cooldown": 0}]
		space.station = Body.new()
		space.station.kind = Body.Kind.STATION
		space._station_boxes(30, int(app.catalogue.system(2).faction))
		space.gate = Body.new()
		space.gate.kind = Body.Kind.GATE
		space.gate.pos = Vector3(70000, 0, 40000)
		var enemy := Body.new()
		enemy.hostile = true
		enemy.pos = Vector3(-5000, 10000, 0)
		enemy.weapons = [{"kind": "gun"}]
		space.bodies = [space.player, space.station, space.gate, enemy]
		space.clock = 9000
		var pilot := Pilot.new()
		var before := world_state(space)
		var controls := pilot.input(space, space.station)
		check(pilot.mode == "approach", "healthy arrival commits to docking instead of chasing unrelated nearby traffic")
		check(not pilot.avoided and pilot.steering_point == space.station.pos,
			"Nehma station approach does not trigger the defense-only station bypass")
		check(absf(controls.yaw) < 0.001 and absf(controls.pitch) < 0.001,
			"native stick input keeps the clear docking course")
		check(not controls.get("next_target", false) and not controls.get("secondary", false),
			"approach neither cycles into docking nor spends finite rockets")
		check(world_state(space) == before, "approach decision cannot alter bodies, targets, mission, resources or RNG")
		space.player.pos = Vector3(0, -70000, 0)
		space.player.shield = 60
		enemy.pos = space.player.pos + Vector3(20000, 0, 0)
		controls = pilot.input(space, space.station)
		check(pilot.mode == "approach", "ordinary course detour and moderate shield loss do not oscillate back into pursuit")
		space.player.shield = 23
		before = world_state(space)
		controls = pilot.input(space, space.station)
		check(pilot.mode == "recover" and pilot.docking_goal == null and pilot.recovery_started == space.clock
			and not controls.get("secondary", false) and not controls.get("next_target", false)
			and world_state(space) == before,
			"critical shield loss releases docking commitment into nonmutating ordinary recovery controls")
		space.player.pos = Vector3(0, 0, 40000)
		space.player.shield = 120
		enemy.pos = Vector3(0, 0, 60000)
		pilot.input(space, space.station)
		controls = pilot.input(space, space.gate)
		check(pilot.mode == "defend", "changing destination to a gate releases station commitment")
		space.player.shield_max = 0
		space.player.shield = 0
		pilot = Pilot.new()
		pilot.input(space, space.station)
		check(pilot.mode == "defend", "unshielded craft do not acquire a healthy docking commitment")
		space.player.shield_max = 120
		space.player.shield = 120
		var rock := Body.new()
		rock.kind = Body.Kind.ASTEROID
		rock.size = 60
		rock.pos = Vector3(0, 0, 30000)
		space.bodies.append(rock)
		pilot = Pilot.new()
		controls = pilot.input(space, space.station)
		check(pilot.mode == "approach" and pilot.avoided and not controls.boost,
			"committed docking still avoids real asteroids using ordinary unboosted steering")
		before = world_state(space)
		for i in 100: pilot.input(space, space.station)
		check(world_state(space) == before, "100 committed control evaluations leave every native world field unchanged")
		check(app.save_attempts.is_empty(), "station approach fixtures create no earned or player saves")
		space.dispose()
	app.queue_free()
	await process_frame
	print("STATION APPROACH: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
