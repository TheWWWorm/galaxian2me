extends "res://tests/guarded_flank_check.gd"
## NO-SAVE mechanisms using recorded G2 positions, headings and health.
## Roll, gun/AI timers and AI targets were not recorded: explicitly synthetic.
## These controlled fixtures are not a reconstruction/replay of an earned save.

func fixture(app) -> TracedSpace:
	var game := Game.new(app.library, app.catalogue)
	game.new_game()
	var session = game.session
	session.ship = {"index": 5, "faction": 0, "hull": 0}
	session.equipment = [[], [], [], []]
	session.fit_slots()
	for index in 2: session.equipment[0][index] = {"id": [8, 2][index], "count": 1}
	session.equipment[1][0] = {"id": 35, "count": 3}
	for index in 4: session.equipment[3][index] = {"id": [52, 71, 56, 77][index], "count": 1}
	var stats: Dictionary = session.ship_stats()
	session.ship.hull = stats.max_hull
	session.ship.armor = stats.armor_plate
	session.ship.shield = stats.shield
	var space := TracedSpace.new(game)
	space._player()
	space.rng.seed = 928641 # Synthetic repeatability only.
	return space

func friend_at(space, position: Vector3, health: int) -> Body:
	var body := Body.new()
	body.kind = Body.Kind.FREIGHTER
	body.faction = 2
	body.friendly = true
	body.pos = position
	body.hull = health
	body.hull_max = 688
	body.speed = 0
	body.ai = {"mode": "hold", "fixed_friendly": true}
	space.bodies.append(body)
	return body

func enemy_at(space, position: Vector3, forward: Vector3, health: int) -> Body:
	var body := Body.new()
	body.faction = 3
	body.hostile = true
	body.pos = position
	body.basis = Body.facing(forward)
	body.hull = health
	body.hull_max = 172
	body.emp = 40
	body.emp_max = 40
	body.weapons = [space._npc_gun(3, 9)]
	body.ai = {"mode": "patrol", "timer": 0, "evade": 0, "home": position}
	space.bodies.append(body)
	return body

func interception(app) -> Array:
	var space := fixture(app)
	space.clock = 103824
	space.player.pos = Vector3(13584.56, 34430.66, 61135.23)
	space.player.basis = Body.facing(Vector3(-0.7121, -0.559553, -0.424045))
	space.player.shield = 87.9393103448281
	var enemy := enemy_at(space, Vector3(6927.914, 28686.72, 57453.32), Vector3(-0.721022, 0.494548, -0.485334), 172)
	var interceptor := enemy_at(space, Vector3(10279.29, 30425.96, 58335.83), Vector3(0.49477, 0.503175, 0.708532), 60)
	interceptor.disabled = true
	interceptor.emp = 3
	interceptor.emp_timer = 1125 # Synthetic phase consistent with sampled energy.
	var friend := friend_at(space, Vector3(8601, 18939, 56542), 112)
	enemy.ai.target = friend # Explicit synthetic target; not claimed as G2's AI state.
	space.target = enemy # Explicit targeting fixture, not an earned action.
	return [space, enemy, interceptor, friend]

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	check(app.library != null, "supplied content is available for no-save rescue mechanisms")
	if app.library != null:
		var setup := interception(app)
		var space: TracedSpace = setup[0]
		var enemy: Body = setup[1]
		var interceptor: Body = setup[2]
		var friend: Body = setup[3]
		var pilot := Combat.new()
		var controls := {}
		var before := Snapshot.capture(space)
		pilot.arm_secondary(space, controls, [enemy, interceptor])
		check(pilot.friendly_corridor_clear(space), "recorded interception pose clears the existing full-lifetime friendly guard")
		check(not controls.get("secondary", false), "an already disabled intervening captor blocks another finite EMP request")
		check(before == Snapshot.capture(space), "interception rejection leaves native bodies, ammunition, targeting and RNG untouched")
		# Counterfactual uses actual native flight/projectiles to establish why
		# the guard matters. It is deliberately not the guarded pilot's input.
		space.step(0.016, {"secondary": true})
		for tick in 60: space.step(0.016, {})
		check(space.hits.any(func(hit): return hit.source == 0 and hit.body == 2 and hit.kind == "missile"),
			"one counterfactual native rocket physically hits the disabled interceptor, not its locked target")
		check(int(space.player.weapons[2].count) == 2 and enemy.emp == 40 and interceptor.hull == 30,
			"counterfactual interception spends one real rocket without suppressing the active target")
		check(friend.hull == 112, "counterfactual native missile does not hit the held friendly")
		space.dispose()
		setup = interception(app)
		space = setup[0]
		enemy = setup[1]
		interceptor = setup[2]
		friend = setup[3]
		pilot = Combat.new()
		controls = {}
		pilot.arm_secondary(space, controls, [enemy, interceptor])
		space.step(0.016, controls)
		check(int(space.player.weapons[2].count) == 3 and space.projectiles.is_empty(),
			"guarded native input keeps the finite rocket instead of repeating the interception")
		# Named fixture mutations test boundaries; no earned state is touched.
		interceptor.pos += Vector3(20000, 0, 0)
		controls = {}
		pilot.arm_secondary(space, controls, [enemy, interceptor])
		check(controls.get("secondary", false), "a genuinely clear active target still permits a finite EMP launch")
		interceptor.pos -= Vector3(20000, 0, 0)
		interceptor.disabled = false
		interceptor.emp = 40
		controls = {}
		pilot.arm_secondary(space, controls, [enemy, interceptor])
		check(controls.get("secondary", false), "an active hostile interceptor may still receive useful suppression")
		interceptor.friendly = true
		interceptor.hostile = false
		controls = {}
		pilot.arm_secondary(space, controls, [enemy])
		check(not controls.get("secondary", false), "friendly obstruction never becomes an acceptable suppression target")
		space.dispose()
		# G2's first post-kill recovery pose, with a deliberately isolated
		# attacker/captive pair. Targets/timers are synthetic, not a G2 replay.
		space = fixture(app)
		space.clock = 61488
		space.player.pos = Vector3(22439.75, 30503.35, 27621.34)
		space.player.basis = Body.facing(Vector3(-0.384093, 0.917893, -0.099726))
		space.player.shield = 63.4882758620695
		friend = friend_at(space, Vector3(8601, 18939, 56542), 436)
		enemy = enemy_at(space, Vector3(-606.9642, 15187.09, 46729.23), Vector3(0.659224, 0.268375, 0.702424), 172)
		enemy.ai.target = friend
		pilot = Combat.new()
		pilot.protected_allies = [friend]
		before = Snapshot.capture(space)
		controls = pilot.input(space, [enemy])
		check(pilot.mode != "recover", "healthy hull with half shields does not abandon a captive under active fire")
		check(pilot.opponent.get_ref() == enemy, "rescue commitment pursues the actual armed captive attacker")
		check(before == Snapshot.capture(space), "protection priority is a read-only decision, not protection applied to bodies")
		var ordinary := true
		var unchanged := true
		var first_hit := -1
		for tick in 750:
			if not space.player.alive or not friend.alive: break
			before = Snapshot.capture(space)
			controls = pilot.input(space, [enemy])
			unchanged = unchanged and before == Snapshot.capture(space)
			for key in controls:
				ordinary = ordinary and key in ["yaw", "pitch", "boost", "autopilot", "fire", "secondary", "next_target"]
			space.step(0.016, controls)
			for hit in space.hits:
				if hit.source == 0 and hit.body == 2 and first_hit < 0: first_hit = hit.clock
		check(first_hit >= 61488 and first_hit <= 73488, "ordinary rescue controls land a native hit before a twelve-second captive deadline")
		check(ordinary and unchanged, "all rescue decisions use ordinary controls without changing native state")
		check(space.player.alive and friend.alive and space.hits.all(func(hit): return not (hit.source == 0 and hit.body == 1)),
			"native rescue mechanism preserves player/captive survival and friendly-fire safety")
		print("RESCUE MECHANISM ", JSON.stringify({"clock": space.clock, "first_hit": first_hit,
			"player_hull": space.player.hull, "captive_hull": friend.hull, "enemy_hull": enemy.hull,
			"shots": space.shots_fired, "ammo": space.player.weapons[2].count}))
		# Explicit policy-boundary fixtures after the native run.
		enemy.alive = true
		enemy.disabled = false
		enemy.pos = space.player.pos + space.player.forward() * 20000
		enemy.ai.target = friend
		space.player.shield = 5
		pilot = Combat.new()
		pilot.protected_allies = [friend]
		pilot.input(space, [enemy])
		check(pilot.mode == "recover", "rescue pressure does not cancel genuinely critical player recovery")
		space.clock += 5000
		space.player.shield = 70
		pilot.input(space, [enemy])
		check(pilot.mode != "recover", "a safe shield reserve resumes captive protection without waiting for ninety-seven percent")
		space.player.shield = 50
		pilot = Combat.new()
		pilot.input(space, [enemy])
		check(pilot.mode == "recover", "ordinary combat without protected mission allies keeps its original recovery policy")
		pilot = Combat.new()
		pilot.protected_allies = [friend]
		enemy.ai.target = space.player
		pilot.input(space, [enemy])
		check(pilot.mode == "recover", "nearby allies alone cannot override recovery when the hostile attacks the player")
		enemy.ai.target = friend
		friend.alive = false
		check(pilot.protection_priority(space, [enemy]) == null, "a dead protected ally cannot demand a rescue commitment")
		friend.alive = true
		enemy.disabled = true
		check(pilot.protection_priority(space, [enemy]) == null, "an EMP-disabled attacker does not create false captive pressure")
		enemy.disabled = false
		enemy.weapons = []
		check(pilot.protection_priority(space, [enemy]) == null, "an unarmed hostile cannot create a false captive deadline")
		space.dispose()
		check(app.save_attempts.is_empty(), "all rescue mechanisms write no player or earned saves")
	app.queue_free()
	await process_frame
	print("RESCUE PRIORITY: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
