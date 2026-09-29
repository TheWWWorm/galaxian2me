extends "res://tests/transit_pilot_check.gd"
## Explicit no-save policy fixtures. These are not earned travel or kills.
## A short centre-line hit is insufficient for the actual two-gun volley.
const Snapshot := preload("res://tests/support/simulation_snapshot.gd")

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	check(app.library != null, "supplied content available for transit lane fixtures")
	if app.library != null:
		var game := Game.new(app.library, app.catalogue)
		game.new_game()
		var space := Space.new(game)
		space.player = Body.new()
		space.player.kind = Body.Kind.PLAYER
		space.player.pos = Vector3.ZERO
		space.player.basis = Basis.IDENTITY
		space.player.speed = 0
		space.player.weapons = [
			{"kind": "gun", "speed": 16.0, "life": 3000, "cooldown": 0, "offset": Vector3(-900, 0, 0)},
			{"kind": "gun", "speed": 20.0, "life": 4000, "cooldown": 0, "offset": Vector3(900, 0, 0)}]
		var enemy := Body.new()
		enemy.pos = Vector3(0, 0, 20000)
		enemy.hostile = true
		enemy.radius = 2000
		enemy.speed = 0
		var friend := Body.new()
		friend.friendly = true
		friend.radius = 400
		friend.speed = 0
		friend.ai = {"mode": "hold"}
		space.bodies = [space.player, enemy, friend]
		var pilot := Pilot.new()
		friend.pos = Vector3(0, 0, 34000)
		var before := Snapshot.capture(space)
		check(not pilot.clear_primary(space, 20000), "friendly beyond a hostile blocks the whole remaining projectile lifetime")
		check(Snapshot.capture(space) == before, "full-lifetime query never steps, retargets or mutates the native world")
		friend.pos = Vector3(900, 0, 10000)
		check(not pilot.clear_primary(space, 20000), "right muzzle lane rejects a friendly missed by the centre-line sweep")
		friend.pos = Vector3(-900, 0, 10000)
		check(not pilot.clear_primary(space, 20000), "left muzzle lane rejects a friendly missed by the centre-line sweep")
		friend.pos = Vector3(0, 0, 65000)
		check(not pilot.clear_primary(space, 20000), "longer second gun retains protection beyond the first gun range")
		friend.pos = Vector3(6000, 0, 24000)
		friend.speed = 3
		friend.ai.mode = "patrol"
		check(not pilot.clear_primary(space, 20000), "moving friendly can turn into either whole-lifetime shot corridor")
		friend.speed = 0
		friend.ai.mode = "hold"
		friend.pos = Vector3(900, 0, 10000)
		friend.friendly = false
		friend.hostile = false
		check(not pilot.clear_primary(space, 20000), "neutral traffic is protected before an accidental hit provokes retaliation")
		friend.pos = Vector3(0, 0, 34000)
		check(not pilot.clear_primary(space, 20000), "neutral traffic behind the target also blocks the continuing volley")
		friend.pos = Vector3(0, 6000, 34000)
		check(pilot.clear_primary(space, 20000), "stationary box-clear traffic does not suppress a genuine hostile firing lane")
		friend.pos = Vector3(100000, 0, 34000)
		check(pilot.clear_primary(space, 20000), "distant traffic leaves legitimate defensive primary fire available")
		friend.pos = Vector3(0, 0, 34000)
		friend.alive = false
		check(pilot.clear_primary(space, 20000), "dead traffic no longer obstructs a live hostile lane")
		friend.alive = true
		friend.hostile = true
		check(pilot.clear_primary(space, 20000), "another genuine hostile behind the target is not protected as neutral traffic")
		friend.friendly = true
		check(not pilot.clear_primary(space, 20000), "friendly identity takes precedence over a stale hostile flag")
		before = Snapshot.capture(space)
		for tick in 100: pilot.clear_primary(space, 20000)
		check(Snapshot.capture(space) == before, "one hundred full-lifetime decisions preserve every body, session and RNG field")
		space.player.weapons.clear()
		check(not pilot.clear_primary(space, 20000), "empty weapon fitting never invents a firing opportunity")
		check(app.save_attempts.is_empty(), "transit firing fixtures write no gameplay or earned saves")
		space.dispose()
	app.queue_free()
	await process_frame
	print("TRANSIT FRIENDLY LANE: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
