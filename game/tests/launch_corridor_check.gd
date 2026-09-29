extends "res://tests/transit_pilot_check.gd"
## No-save fixture: native launch placement and collision/booster steps,
## followed by input-only commitment checks. Not campaign progression.
func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	check(app.library != null, "supplied content is available for the native launch corridor")
	if app.library != null:
		var game := Game.new(app.library, app.catalogue)
		game.new_game()
		game.session.ship = {"index": 5, "faction": 0, "hull": 250, "armor": 80, "shield": 120}
		game.session.equipment = [[{"id": 8, "count": 1}, {"id": 2, "count": 1}],
			[{"id": 35, "count": 4}], [], [{"id": 52, "count": 1}, {"id": 71, "count": 1},
			{"id": 56, "count": 1}, {"id": 77, "count": 1}]]
		var space := Space.new(game)
		space._player()
		space.station = Body.new()
		space.station.kind = Body.Kind.STATION
		space.station.station_id = 85
		space.bodies.append(space.station)
		space._station_boxes(85, int(app.catalogue.system(17).faction))
		space.gate = Body.new()
		space.gate.kind = Body.Kind.GATE
		space.gate.pos = Vector3(60000, 0, 70000)
		space.bodies.append(space.gate)
		space._place_player()
		check(space.player.pos == Vector3(10, 10, 10000) and space.player.forward() == Vector3.BACK,
			"native placement supplies the outward +Z launch pose, not an assigned pilot pose")
		var pilot := Pilot.new()
		var unchanged := true
		var safe_buttons := true
		for tick in 500:
			var before := world_state(space)
			var controls := pilot.input(space, space.gate)
			unchanged = unchanged and world_state(space) == before
			safe_buttons = safe_buttons and not controls.get("next_target", false) and not controls.get("secondary", false)
			space.step(0.016, controls)
		check(unchanged and safe_buttons, "all 500 launch inputs leave simulation untouched and never retarget the station or spend EMP")
		check(space.player.pos.z > 25000.0 and absf(space.player.pos.x) < 500.0 and absf(space.player.pos.y) < 500.0,
			"native flight exits the intended front corridor instead of taking a vertical station detour")
		check(space.player.alive and space.player.hull == 170 and space.player.armor == 80
			and space.player.weapons.filter(func(w): return w.kind == "missile")[0].count == 4,
			"native launch keeps real durability and all finite ammunition")
		for side in [-1, 1]:
			var b := Body.new()
			b.hostile = true
			b.pos = space.player.pos + Vector3(side * 4000, 0, -10000)
			b.weapons = [{"kind": "gun"}]
			space.bodies.append(b)
		var before := world_state(space)
		var controls := pilot.input(space, space.gate)
		check(pilot.mode == "depart" and world_state(space) == before and not controls.get("secondary", false),
			"a healthy launched ship keeps its actual gate destination rather than hunting two pursuing guns")
		space.player.shield = 23
		pilot.input(space, space.gate)
		check(pilot.mode == "recover", "critical native shield loss releases departure commitment")
		space.bodies.resize(3)
		space.clock = 0
		# Derive an inbound collision course from the supplied module's
		# actual face; z=40000 only intersected the former doubled box.
		var box: Dictionary = space.station_boxes[0]
		var centre: Vector3 = box.origin + box.basis * box.centre
		space.player.pos = centre + box.basis.z * (box.half.z + 9000.0)
		space.player.basis = Body.facing(centre - space.player.pos)
		pilot = Pilot.new()
		controls = pilot.input(space, space.gate)
		check(pilot.launch_axis.is_zero_approx() and pilot.avoided and not controls.boost,
			"an arriving pose never receives the launch-corridor station exception")
		space._place_player()
		space.player.shield = 120
		var rock := Body.new()
		rock.kind = Body.Kind.ASTEROID
		rock.size = 60
		rock.pos = space.player.pos + Vector3(0, 0, 8000)
		space.bodies.append(rock)
		pilot = Pilot.new()
		controls = pilot.input(space, space.gate)
		check(pilot.avoided and not controls.boost, "launch corridor still avoids a real large asteroid without unsafe boost")
		check(app.save_attempts.is_empty(), "launch fixture never emits an earned or player save")
		print("LAUNCH POSITION ", space.player.pos)
		space.dispose()
	app.queue_free()
	await process_frame
	print("%d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
