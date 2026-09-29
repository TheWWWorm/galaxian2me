extends "res://tests/transit_pilot_check.gd"
## No-save multi-frame regression. Fixture setup is deliberately synthetic;
## only native stepping may change a ship after the initial arrangement.
const Combat := preload("res://tests/support/combat_pilot.gd")

class TracedSpace:
	extends "res://src/flight/space.gd"
	var phase := "other"
	var damage_rows: Array = []
	func _projectiles_step(delta: float, ms: int) -> void:
		phase = "projectile"
		super._projectiles_step(delta, ms)
		phase = "other"
	func _collisions() -> void:
		phase = "contact"
		super._collisions()
		phase = "other"
	func _harm(b: Body, amount: float, emp_amount: float, source: Body) -> void:
		super._harm(b, amount, emp_amount, source)
		if b == player:
			damage_rows.append({"phase": phase, "damage": amount, "source": bodies.find(source)})

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	check(app.library != null, "supplied content available for native pursuit fixtures")
	if app.library != null:
		var rotations := [Basis.IDENTITY, Basis(Vector3.RIGHT, PI * 0.49),
			Basis(Vector3(1, 2, 3).normalized(), 1.2)]
		var first_course := Vector3.ZERO
		for rotation in rotations:
			var game := Game.new(app.library, app.catalogue)
			game.new_game()
			var s = game.session
			s.ship = {"index": 5, "faction": 0, "hull": 0}
			s.equipment = [[], [], [], []]
			s.fit_slots()
			for index in 2: s.equipment[0][index] = {"id": [8, 2][index], "count": 1}
			s.equipment[1][0] = {"id": 35, "count": 7}
			for index in 4: s.equipment[3][index] = {"id": [52, 71, 56, 77][index], "count": 1}
			var st: Dictionary = s.ship_stats()
			s.ship.hull = st.max_hull
			s.ship.armor = st.armor_plate
			s.ship.shield = 60.0
			var space := TracedSpace.new(game)
			space._player()
			space.rng.seed = 92836 # Repeatability for this fixture, never an earned replay.
			space.player.basis = rotation * Body.facing(Vector3(1, 0, -0.35))
			var pirate := Body.new()
			pirate.hostile = true
			pirate.hull = 164
			pirate.hull_max = 164
			pirate.emp = 40
			pirate.emp_max = 40
			pirate.pos = rotation * Vector3(0, 0, 8000)
			pirate.basis = rotation * Body.facing(Vector3(0, 0, -1))
			pirate.weapons = [space._npc_gun(8, 9)]
			pirate.ai = {"mode": "patrol", "target": space.player, "timer": 0, "evade": 0}
			space.bodies.append(pirate)
			var query := Combat.new()
			var before := world_state(space)
			var course := query.withdrawal_course(space, pirate)
			if first_course.is_zero_approx(): first_course = course
			check(course.distance_to(rotation * first_course) < 0.001 and before == world_state(space),
				"rotating the fixture rotates its escape course without changing native state")
			var pilot := Combat.new()
			var unchanged := true
			var ordinary := true
			var previous := Vector3.ZERO
			var max_flip := 0.0
			var original_session := var_to_str(s.to_dict())
			var native_boost_seen := false
			var native_reload_seen := false
			for tick in 2400:
				if not space.player.alive or not pirate.alive: break
				before = world_state(space)
				var controls := pilot.input(space, [pirate])
				unchanged = unchanged and before == world_state(space)
				for key in controls:
					ordinary = ordinary and key in ["yaw", "pitch", "boost", "autopilot", "fire", "secondary", "next_target"]
				ordinary = ordinary and absf(controls.get("yaw", 0.0)) <= 1.0 and absf(controls.get("pitch", 0.0)) <= 1.0
				var desired := space.player.pos.direction_to(pilot.desired)
				if not previous.is_zero_approx(): max_flip = maxf(max_flip, previous.angle_to(desired))
				previous = desired
				space.step(0.016, controls)
				native_boost_seen = native_boost_seen or space.player.boosting
				native_reload_seen = native_reload_seen or space.boost_time < 0
			var reachable_turn := (float(st.handling) + float(st.steering) / 100.0) * 1000.0 / 3.0 / 4096.0 * TAU * 0.016 * 2.0
			print("PURSUIT ", JSON.stringify({"clock": space.clock, "hull": space.player.hull,
				"armor": space.player.armor, "shield": space.player.shield,
				"gap": pirate.pos.distance_to(space.player.pos), "damage_events": space.damage_rows.size(),
				"max_course_jump_radians": max_flip, "native_turn_budget": reachable_turn}))
			check(unchanged and ordinary, "all pursuit decisions are bounded ordinary input and leave world/session/RNG untouched")
			check(native_boost_seen and native_reload_seen, "multi-frame pursuit exercises the actual fitted booster and its cooldown")
			check(space.damage_rows.all(func(r): return r.phase == "projectile" and r.source == 1),
				"native pursuit damage is observed in the projectile path, not invented contact damage")
			check(space.player.alive and space.player.hull == space.player.hull_max,
				"native multi-frame pursuit preserves hull in each tested orientation")
			# Winning the fight legitimately records the kill and standing.
			var settled: Dictionary = s.to_dict()
			var expected: Dictionary = str_to_var(original_session)
			for key in ["stats", "reputation"]:
				settled.erase(key)
				expected.erase(key)
			check(var_to_str(settled) == var_to_str(expected), "no fixture outcome beyond combat results is written into the session")
			space.dispose()
		check(app.save_attempts.is_empty(), "multi-frame pursuit creates no saved progress")
	app.queue_free()
	await process_frame
	print("%d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
