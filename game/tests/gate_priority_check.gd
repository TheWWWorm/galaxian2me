extends "res://tests/transit_pilot_check.gd"
## No-save mechanism fixture from the observed final Genoh approach.
## Pose geometry is observed; roll, NPC timing and RNG are synthetic.
## Native target cycling and collisions, not the pilot, must start the gate.
const Trace := preload("res://tests/pursuit_pilot_check.gd")

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	check(app.library != null, "supplied content is available for native gate activation")
	if app.library != null:
		var game := Game.new(app.library, app.catalogue)
		game.new_game()
		# This mechanism fixture's physical assembly is Genoh, not the new
		# game's Var Hastra. Gate graph validation must use the same origin.
		game.session.station_id = 85
		game.session.system_index = 17
		game.session.visited_systems["17"] = true
		game.session.visited_systems[str(app.catalogue.system_of_station(22))] = true
		check(preload("res://src/simulation/navigation.gd").gate_destination(game.session, app.catalogue, 22),
			"observed Genoh fixture's address and supplied gate link match its physical assembly")
		game.session.ship = {"index": 5, "faction": 0, "hull": 242, "armor": 72, "shield": 0.0993103448275862}
		game.session.equipment = [[{"id": 8, "count": 1}, {"id": 2, "count": 1}],
			[{"id": 35, "count": 4}], [], [{"id": 52, "count": 1}, {"id": 71, "count": 1},
			{"id": 56, "count": 1}, {"id": 77, "count": 1}]]
		game.depart({"station": 22})
		var space := Trace.TracedSpace.new(game)
		space._player()
		space.clock = 30240
		space.player.pos = Vector3(35593.68, 598.6989, 69581.87)
		space.player.basis = Body.facing(Vector3(0.793125, 0.607064, -0.049246))
		space.boost_time = -2784
		space.boost_ready = false
		space.station = Body.new()
		space.station.kind = Body.Kind.STATION
		space.station.station_id = 85
		space.bodies.append(space.station)
		space._station_boxes(85, int(app.catalogue.system(17).faction))
		space.gate = Body.new()
		space.gate.kind = Body.Kind.GATE
		space.gate.pos = Vector3(44365.11, 0, 79448.15)
		space.bodies.append(space.gate)
		var star := Body.new()
		star.kind = Body.Kind.STAR
		star.pos = space.gate.pos + Vector3(40000, 0, 40000)
		space.bodies.append(star)
		space.target = star
		space.rng.seed = 92885
		for at in [Vector3(53884.1, -4149.555, 75854.07), Vector3(33985.59, 160.1392, 77311.07)]:
			var b := Body.new()
			b.hostile = true
			b.faction = 8
			b.hull = 172
			b.hull_max = 172
			b.pos = at
			b.basis = Body.facing(space.player.pos - at)
			b.weapons = [space._npc_gun(8, 9)]
			b.ai = {"mode": "patrol", "target": space.player, "timer": 0, "evade": 0}
			space.bodies.append(b)
		check(space.player.pos.distance_to(space.gate.pos) < 18000.0 and not space._inside_station(space.player.pos, 8000.0),
			"observed approach is already near the gate and safely outside every station margin")
		var pilot := Pilot.new()
		var before := world_state(space)
		var first := pilot.input(space, space.gate)
		check(pilot.mode == "gate_approach" and first.get("next_target", false),
			"critical shields do not replace final ordinary gate targeting with an endless retreat")
		check(world_state(space) == before and space.target == star and space.jumping < 0,
			"choosing the gate controls does not directly assign a target or trigger travel")
		var unchanged := true
		var ordinary := true
		var started: int = space.clock
		for tick in 1500:
			if not space.player.alive or space.jumping >= 0: break
			before = world_state(space)
			var controls := pilot.input(space, space.gate)
			unchanged = unchanged and world_state(space) == before
			for key in controls:
				ordinary = ordinary and key in ["yaw", "pitch", "boost", "autopilot", "fire", "next_target", "fire_pressed"]
			space.step(0.016, controls)
		check(unchanged and ordinary, "all approach actions remain ordinary input without state mutation")
		check(space.player.alive and space.jumping >= 0 and int(space.jump_destination.get("station", -1)) == 22,
			"native steering, target cycling and physical gate collision start the selected journey before defeat")
		check(not space.damage_rows.is_empty() and space.damage_rows.all(func(row): return row.phase == "projectile"),
			"real native enemy damage stays active during the final gate approach")
		check(space.player.weapons.filter(func(w): return w.kind == "missile")[0].count == 4,
			"final gate approach preserves all finite rescue EMP ammunition")
		check(app.save_attempts.is_empty(), "gate fixture does not emit or promote an earned save")
		print("GATE RESULT ", JSON.stringify({"elapsed": space.clock - started, "jumping": space.jumping,
			"alive": space.player.alive, "hull": space.player.hull, "armor": space.player.armor,
			"shield": space.player.shield, "distance": space.player.pos.distance_to(space.gate.pos), "target": space.target.kind}))
		space.dispose()
	app.queue_free()
	await process_frame
	print("%d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
