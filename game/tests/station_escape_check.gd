extends "res://tests/transit_pilot_check.gd"
## Synthetic geometry/input regression, never an earned campaign save.
## This checks the outward-margin mechanism, not universal combat survival.
func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	check(app.library != null, "supplied content is available for station escape geometry")
	if app.library != null:
		var game := Game.new(app.library, app.catalogue)
		game.new_game()
		var space := Space.new(game)
		space.player = Body.new()
		space.player.kind = Body.Kind.PLAYER
		space.player.pos = Vector3(0, 0, 25000)
		space.player.basis = Body.facing(Vector3(1, 0, 1))
		space.player.shield_max = 120
		space.player.shield = 24
		space.player.weapons = [{"kind": "gun", "speed": 16.0, "life": 3000}]
		space.station = Body.new()
		space.station.kind = Body.Kind.STATION
		space.station_boxes = [{"basis": Basis.IDENTITY, "origin": Vector3.ZERO,
			"centre": Vector3.ZERO, "half": Vector3(20000, 12000, 20000)}]
		space.gate = Body.new()
		space.gate.kind = Body.Kind.GATE
		space.gate.pos = Vector3(0, 0, 90000)
		var enemy := Body.new()
		enemy.hostile = true
		enemy.pos = Vector3(0, 0, 40000)
		enemy.weapons = [{"kind": "gun"}]
		space.bodies = [space.player, space.station, space.gate, enemy]
		space.clock = 12000
		var pilot := Pilot.new()
		var before := world_state(space)
		check(space._inside_station(space.player.pos, 8000.0) and not space._inside_station(space.player.pos, space.PLAYER_RADIUS),
			"fixture starts inside the safety margin but outside the physical hull plus player radius")
		check(pilot.escape_leg_clear(space, Vector3(1, 0, 1).normalized()), "outward margin exit clears the physical station")
		check(not pilot.escape_leg_clear(space, Vector3(0, 0, -1)), "recovery cannot tunnel through a physical module")
		check(not pilot.escape_leg_clear(space, Vector3(1, 0, -0.05).normalized()), "recovery cannot initially deepen an entered safety margin")
		pilot.mode = "recover"
		var desired := space.player.pos + Vector3(1, 0, 1).normalized() * 30000.0
		check(pilot.safe_point(space, desired, false).is_equal_approx(desired), "an outward escape is not replaced by a vertical station bypass")
		var controls := pilot.steer(space, desired, true, false)
		check(not pilot.avoided and controls.boost, "a clear outward leg permits the ordinary boost control")
		var rock := Body.new()
		rock.kind = Body.Kind.ASTEROID
		rock.size = 60
		rock.pos = space.player.pos + Vector3(1, 0, 1).normalized() * 12000.0
		space.bodies.append(rock)
		check(not pilot.escape_leg_clear(space, Vector3(1, 0, 1).normalized()), "outward escape still rejects large asteroids")
		controls = pilot.steer(space, desired, true, false)
		check(pilot.avoided and not controls.boost, "an asteroid detour does not start an unsafe boost")
		space.bodies.erase(rock)
		check(world_state(space) == before, "geometric escape queries never mutate bodies, session, target or RNG")
		space.player.pos = Vector3(0, 0, 40000)
		enemy.pos = Vector3(0, 0, 48000)
		before = world_state(space)
		controls = pilot.input(space, space.gate)
		check(pilot.mode == "recover" and not controls.has("secondary") and not controls.has("next_target"),
			"low-shield departure withdraws without spending rescue ammunition or targeting the home station")
		check(world_state(space) == before, "recovery selection remains an ordinary-input-only observer")
		var course := pilot.escape_direction
		space.clock += 1000
		controls = pilot.input(space, space.gate)
		check(course.is_equal_approx(pilot.escape_direction), "clear escape commitment does not orbit a changing closest pursuer every frame")
		space.player.shield = 119
		space.clock += 4000
		pilot.input(space, space.gate)
		check(pilot.recovery_started < 0, "native shield recovery releases withdrawal hysteresis")
		space.player.shield = 24
		space.clock = 20000
		pilot = Pilot.new()
		pilot.input(space, space.gate)
		space.clock += 5000
		before = world_state(space)
		controls = pilot.input(space, space.gate)
		check(pilot.mode == "counterattack" and not controls.has("secondary") and not controls.has("next_target")
			and world_state(space) == before,
			"failed withdrawal from one close armed pursuer allows an ordinary primary-only reversal")
		var second := Body.new()
		second.hostile = true
		second.pos = space.player.pos + Vector3(10000, 0, 0)
		second.weapons = [{"kind": "gun"}]
		space.bodies.append(second)
		pilot.input(space, space.gate)
		check(pilot.mode == "recover" and pilot.counterattack_target == null,
			"another nearby gun immediately rejects the single-pursuer counterattack")
		check(app.save_attempts.is_empty(), "station escape regression never saves fixture progress")
		space.dispose()
	app.queue_free()
	await process_frame
	print("%d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
