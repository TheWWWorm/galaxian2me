extends "res://tests/transit_pilot_check.gd"
## Synthetic no-save fixtures. Only the explicitly reachable patrol case
## proves a firing opportunity; an obstructed or overlapping duel does not.
const Combat := preload("res://tests/support/combat_pilot.gd")
const Snapshot := preload("res://tests/support/simulation_snapshot.gd")

class TracedSpace:
	extends "res://src/flight/space.gd"
	var hits: Array = []
	func _impact(projectile: Dictionary, body: Body) -> void:
		var row := {"clock": clock, "source": bodies.find(projectile.owner),
			"body": bodies.find(body), "kind": projectile.weapon.kind, "before": body.hull}
		super._impact(projectile, body)
		row.after = body.hull
		hits.append(row)

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	check(app.library != null, "supplied content available for native guarded-flight fixtures")
	if app.library != null:
		for scenario in ["window", "station", "overlap"]:
			var game := Game.new(app.library, app.catalogue)
			game.new_game()
			var session = game.session
			session.ship = {"index": 5, "faction": 0, "hull": 0}
			session.equipment = [[], [], [], []]
			session.fit_slots()
			for index in 2: session.equipment[0][index] = {"id": [8, 2][index], "count": 1}
			session.equipment[1][0] = {"id": 35, "count": 7}
			for index in 4: session.equipment[3][index] = {"id": [52, 71, 56, 77][index], "count": 1}
			var stats: Dictionary = session.ship_stats()
			session.ship.hull = stats.max_hull
			session.ship.armor = stats.armor_plate
			session.ship.shield = 80.0
			var space := TracedSpace.new(game)
			space._player()
			space.rng.seed = 92837 # Fixture repeatability, never an earned replay.
			var enemy := Body.new()
			enemy.hostile = true
			enemy.hull = 164
			enemy.hull_max = 164
			enemy.emp = 40
			enemy.emp_max = 40
			enemy.pos = Vector3(0, 0, 20000)
			enemy.weapons = [space._npc_gun(8, 9)]
			var friend := Body.new()
			friend.faction = 1
			friend.friendly = true
			friend.hull = 9999999
			friend.hull_max = friend.hull
			friend.pos = enemy.pos + Vector3(0, 0, 6000)
			friend.basis = Body.facing(Vector3.RIGHT)
			friend.weapons = [space._npc_gun(1, 9)]
			friend.ai = {"mode": "patrol", "route": [friend.pos + Vector3(100000, 0, 0)], "timer": 0, "evade": 0}
			enemy.ai = {"mode": "patrol", "route": [enemy.pos + Vector3(0, 0, 100000)], "timer": 0, "evade": 0}
			if scenario == "overlap":
				friend.pos = enemy.pos
				friend.basis = enemy.basis
				friend.ai.route = enemy.ai.route.duplicate()
			space.bodies.append(enemy)
			space.bodies.append(friend)
			if scenario == "station":
				space.station = Body.new()
				space.station.kind = Body.Kind.STATION
				space.station.pos = Vector3(0, 0, 5000)
				space.bodies.append(space.station)
				space.station_boxes = [{"basis": Basis.IDENTITY, "origin": Vector3(0, 0, 14000),
					"centre": Vector3.ZERO, "half": Vector3(1500, 2000, 1500)}]
			var pilot := Combat.new()
			var before := Snapshot.capture(space)
			var initial := pilot.find_flank_offset(space, enemy)
			check(before == Snapshot.capture(space), "flank search leaves complete native state unchanged")
			if scenario == "window":
				check(initial.length() < 18000 and initial.length() >= 8000,
					"a closer safe standoff is found when the entire outer sphere is blocked")
				check(pilot.friendly_corridor_clear_at(space, enemy.pos + initial, Body.facing(-initial)),
					"closer standoff passes the unchanged full projectile-lifetime friendly envelope")
			var unchanged := true
			var ordinary := true
			var safe := true
			var avoided := false
			var outside := true
			var moving := false
			var first_hit := -1
			var initial_friend := friend.pos
			var feasible_seen := false
			for tick in (300 if scenario == "overlap" else 2500):
				if not enemy.alive or not space.player.alive: break
				before = Snapshot.capture(space)
				var controls := pilot.input(space, [enemy])
				unchanged = unchanged and before == Snapshot.capture(space)
				for key in controls:
					ordinary = ordinary and key in ["yaw", "pitch", "boost", "autopilot", "fire", "secondary", "next_target"]
				ordinary = ordinary and absf(controls.get("yaw", 0.0)) <= 1 and absf(controls.get("pitch", 0.0)) <= 1
				if controls.get("fire", false) or controls.get("secondary", false): safe = safe and pilot.friendly_corridor_clear(space)
				avoided = avoided or pilot.navigation.avoided
				feasible_seen = feasible_seen or pilot.flank_feasible
				space.step(0.016, controls)
				moving = moving or friend.pos.distance_to(initial_friend) > 1000
				outside = outside and not space._inside_station(space.player.pos)
				for hit in space.hits:
					if first_hit < 0 and hit.source == 0 and hit.body == 1: first_hit = hit.clock
			print("GUARDED ", JSON.stringify({"scenario": scenario, "clock": space.clock,
				"first_hit": first_hit, "shots": space.shots_fired, "avoided": avoided,
				"enemy_alive": enemy.alive, "hull": space.player.hull, "armor": space.player.armor}))
			check(unchanged and ordinary, "all moving guarded-flight decisions are bounded inputs and nonmutating queries")
			check(moving, "friendly motion comes from real native AI stepping")
			check(safe and space.hits.all(func(hit): return not (hit.source == 0 and hit.body == 2)),
				"actual projectiles never hit the friendly and every trigger uses the lifetime safety gate")
			check(space.player.alive, "native guarded approach preserves survival")
			if scenario == "window":
				check(first_hit >= 0 and first_hit <= 12000 and space.shots_fired > 0,
					"native moving guarded patrol yields a real projectile impact within the bounded firing window")
			elif scenario == "station":
				check(avoided and outside, "station-obstructed guarded approach actually detours and never enters a module")
			else:
				check(not feasible_seen and space.shots_fired == 0,
					"overlapping moving ships never become a fabricated firing opportunity")
			space.dispose()
		check(app.save_attempts.is_empty(), "guarded-flight fixtures never save campaign progress")
	app.queue_free()
	await process_frame
	print("%d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
