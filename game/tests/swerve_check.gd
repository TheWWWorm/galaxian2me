extends SceneTree
## Obstacle avoidance: a ship heading towards an asteroid swerves past it;
## one already flying away from it holds its heading instead of flicking
## its nose from side to side every frame.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
const AI := preload("res://src/flight/ai.gd")
const Body := preload("res://src/flight/body.gd")
var checks := 0
var failures := 0

func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)

func flips(sim, ship, frames: int) -> int:
	var n := 0
	var last := 0.0
	var fwd: Vector3 = ship.forward()
	for f in frames:
		AI.step(sim, ship, 1.0 / 60.0, 16)
		var now: Vector3 = ship.forward()
		var yaw := fwd.cross(now).y
		if absf(yaw) > 0.0003 and absf(last) > 0.0003 and signf(yaw) != signf(last): n += 1
		if absf(yaw) > 0.0003: last = yaw
		fwd = now
	return n

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		print("SKIP: no supplied content"); app.queue_free(); await process_frame; quit(2); return
	var game := Game.new(app.library, app.catalogue)
	game.new_game()
	game.session.story_step = 20
	game.session.story_mission = {}
	var sim := Space.new(game)
	sim.build()
	# One asteroid far from everything else, the ship patrolling past it.
	sim.bodies = sim.bodies.filter(func(b): return b.kind != Body.Kind.ASTEROID and not (b.is_ship() and b != sim.player))
	var rock := Body.new()
	rock.kind = Body.Kind.ASTEROID
	rock.pos = Vector3(0, 0, 200000)
	rock.scale = Vector3.ONE * 2.0
	sim.bodies.append(rock)
	sim.player.pos = Vector3(0, 0, -300000)
	# Straight out from the rock's centre, a few units off the line.
	var out := Vector3(0.2, 0.0, 1.0).normalized()
	var away := sim._spawn_ship(1, rock.pos, false)
	away.pos = rock.pos + out * 1500.0 + Vector3(-out.z, 0, out.x) * 3.0
	away.basis = AI.upright(out, Basis.IDENTITY)
	away.hostile = false
	away.ai = {"mode": "patrol", "route": [Vector3(0, 0, 150000), Vector3(0, 0, 150000)], "can_boost": false}
	check(flips(sim, away, 90) <= 1, "leaving an asteroid, the nose does not flick from side to side")
	var towards := sim._spawn_ship(1, rock.pos, false)
	towards.pos = rock.pos - Vector3(200, 0, 5500)
	towards.basis = AI.upright(Vector3(0.03, 0.0, 1.0), Basis.IDENTITY)
	towards.ai = {"mode": "patrol", "route": [rock.pos + Vector3(0, 0, 60000)], "can_boost": false}
	var before: Vector3 = towards.forward()
	for f in 20: AI.step(sim, towards, 1.0 / 60.0, 16)
	check(towards.forward().angle_to(before) > 0.05, "heading for one, it swerves")
	app.queue_free()
	await process_frame
	print("SWERVE: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
