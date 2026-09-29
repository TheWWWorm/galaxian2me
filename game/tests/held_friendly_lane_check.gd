extends "res://tests/guarded_flank_check.gd"
## Explicit no-save fixture: use the native stationary BODY box, not its
## larger bounding sphere, while retaining whole-lifetime shot protection.
func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	check(app.library != null, "supplied content is available for the held-captive lane fixture")
	if app.library != null:
		var game := Game.new(app.library, app.catalogue)
		game.new_game()
		var session = game.session
		session.ship = {"index": 5, "faction": 0, "hull": 0}
		session.equipment = [[], [], [], []]
		session.fit_slots()
		for index in 2: session.equipment[0][index] = {"id": [8, 2][index], "count": 1}
		session.equipment[1][0] = {"id": 35, "count": 1}
		for index in 4: session.equipment[3][index] = {"id": [52, 71, 56, 77][index], "count": 1}
		var stats: Dictionary = session.ship_stats()
		session.ship.hull = stats.max_hull
		session.ship.armor = stats.armor_plate
		session.ship.shield = stats.shield
		var space := TracedSpace.new(game)
		space._player()
		space.player.pos = Vector3(0, 3600, 0)
		space.player.basis = Basis.IDENTITY
		var enemy := Body.new()
		enemy.faction = 3
		enemy.hostile = true
		enemy.hull = 172
		enemy.hull_max = 172
		enemy.emp = 40
		enemy.emp_max = 40
		enemy.radius = 2000
		enemy.pos = Vector3(0, 3600, 18000)
		enemy.speed = 0
		enemy.ai = {"mode": "hold"}
		var friend := Body.new()
		friend.kind = Body.Kind.FREIGHTER
		friend.faction = 2
		friend.friendly = true
		friend.hull = 688
		friend.hull_max = 688
		friend.radius = 2000
		friend.pos = Vector3(0, 0, 18000)
		friend.speed = 0
		friend.ai = {"mode": "hold", "fixed_friendly": true}
		space.bodies.append(enemy)
		space.bodies.append(friend)
		space.target = enemy # Explicit synthetic targeting fixture, not earned state.
		var pilot := Combat.new()
		var before := Snapshot.capture(space)
		check(pilot.friendly_corridor_clear(space), "box-clear lane beside a held captive is not falsely blocked by its bounding sphere")
		var offset := pilot.find_flank_offset(space, enemy)
		check(not offset.is_zero_approx(), "a nearby stationary captive does not erase every feasible firing pose")
		var controls := pilot.input(space, [enemy])
		check(controls.get("fire", false) and controls.get("secondary", false),
			"aligned box-clear target can receive ordinary primary and finite EMP controls")
		check(before == Snapshot.capture(space), "lane selection and triggers leave every native world field unchanged")
		var unchanged := true
		var ordinary := true
		for tick in 800:
			before = Snapshot.capture(space)
			controls = pilot.input(space, [enemy])
			unchanged = unchanged and before == Snapshot.capture(space)
			for key in controls:
				ordinary = ordinary and key in ["yaw", "pitch", "boost", "autopilot", "fire", "secondary", "next_target"]
			space.step(0.016, controls)
		check(unchanged and ordinary, "all native fixture ticks use bounded nonmutating player controls")
		check(not enemy.alive and space.shots_fired > 0, "real native projectiles defeat the hostile through the box-clear lane")
		check(space.hits.any(func(hit): return hit.source == 0 and hit.body == 1 and hit.kind == "missile")
			and int(space.player.weapons[2].count) == 0, "one real EMP impact consumes the single actual missile")
		check(friend.hull == 688 and friend.pos == Vector3(0, 0, 18000)
			and space.hits.all(func(hit): return not (hit.source == 0 and hit.body == 2)),
			"the held captive receives no native projectile impact, including shots continuing after the hostile dies")
		# Reset only these labelled fixture poses to test the guard's boundaries.
		space.player.pos = Vector3(0, 3600, 0)
		space.player.basis = Basis.IDENTITY
		friend.ai.mode = "patrol"
		friend.speed = 2
		check(not pilot.friendly_corridor_clear(space), "moving allies retain the original turn-reachable spherical safety envelope")
		friend.ai.mode = "hold"
		check(not pilot.friendly_corridor_clear(space), "a held but drifting ally does not acquire the stationary-box exception")
		friend.speed = 0
		friend.pos.y = 500
		check(not pilot.friendly_corridor_clear(space), "the stationary box still includes the full 1200-unit pre-shot movement margin")
		friend.pos = Vector3(0, 3600, 32000)
		check(not pilot.friendly_corridor_clear(space), "a held captive beyond the hostile still blocks the full remaining primary lifetime")
		check(app.save_attempts.is_empty(), "held-captive lane fixtures never write earned or player saves")
		space.dispose()
	app.queue_free()
	await process_frame
	print("HELD FRIENDLY LANE: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
