extends SceneTree
## Synthetic, no-save input-policy checks. These are NOT earned flight proof.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
const Body := preload("res://src/flight/body.gd")
const Pilot := preload("res://tests/support/transit_pilot.gd")
var checks := 0
var failures := 0
func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)
func world_state(space) -> String:
	var rows: Array = []
	for b in space.bodies:
		rows.append([b.pos, b.basis, b.hull, b.armor, b.shield, b.alive, b.hostile,
			b.friendly, b.disabled, b.ai.duplicate(), b.weapons.duplicate(true)])
	return var_to_str([rows, space.game.session.to_dict(), space.rng.state,
		space.target, space.locked, space.clock, space.projectiles, space.effects, space.stats])
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
		space.player.pos = Vector3(0, 0, 10000)
		space.player.weapons = [{"kind": "gun", "speed": 16.0, "life": 3000, "cooldown": 0}]
		space.station = Body.new()
		space.station.kind = Body.Kind.STATION
		space.station_boxes = [{"basis": Basis.IDENTITY, "origin": Vector3.ZERO,
			"centre": Vector3.ZERO, "half": Vector3(20000, 12000, 20000)}]
		space.gate = Body.new()
		space.gate.kind = Body.Kind.GATE
		space.gate.pos = Vector3(0, 0, 90000)
		space.bodies = [space.player, space.station, space.gate]
		var p := Pilot.new()
		var before := world_state(space)
		var controls := p.input(space, space.gate)
		check(p.mode == "clear_hangar" and not controls.get("next_target", false), "departure never cycles home station inside dock volume")
		check(not controls.get("fire_pressed", false) and not controls.get("secondary", false), "departure issues neither navigation activation nor finite ammunition")
		check(world_state(space) == before, "departure policy leaves all world, session and RNG state untouched")
		space.clock = 9000
		space.player.pos = Vector3(0, 0, 40000)
		var direct := p.steer(space, Vector3(0, 0, -60000), false, true)
		check(absf(direct.yaw) == 1.0 and is_zero_approx(direct.pitch), "level target behind turns in yaw without a spurious full pitch")
		var bypass := p.safe_point(space, Vector3.ZERO, false)
		check(bypass != Vector3.ZERO and absf(bypass.y) >= 32000.0, "defense path avoids expanded station module boxes")
		check(p.safe_point(space, Vector3.ZERO, true) == Vector3.ZERO, "intended docking may approach its real station")
		var rock := Body.new()
		rock.kind = Body.Kind.ASTEROID
		rock.pos = Vector3(0, 0, 50000)
		rock.size = 60
		space.bodies.append(rock)
		rock.pos = Vector3(0, 12000, 40000)
		var combined := p.safe_point(space, Vector3.ZERO, false)
		check(combined != bypass, "station detour also avoids a large rock on its own flight leg")
		var axis := (combined - space.player.pos).normalized()
		var relative := rock.pos - space.player.pos
		check((relative - axis * relative.dot(axis)).length() > 4000.0,
			"vertical detour chooses a perpendicular escape instead of flying through the rock")
		rock.pos = Vector3(0, 0, 50000)
		controls = p.input(space, space.gate)
		check(p.avoided and not controls.boost, "large rock produces steering detour and no new boost")
		rock.alive = false
		controls = p.input(space, space.gate)
		check(not p.avoided and controls.boost, "destroyed rock is no longer a navigation obstacle")
		var hostile := Body.new()
		hostile.hostile = true
		hostile.pos = Vector3(0, 0, 60000)
		hostile.weapons = [{"kind": "gun"}]
		space.bodies.append(hostile)
		controls = p.input(space, space.gate)
		check(p.mode == "defend" and controls.fire and not controls.boost, "nearby armed hostile receives ordinary defensive primary fire")
		check(not controls.has("secondary") and not controls.has("next_target"), "dogfight neither consumes rockets nor cycles to the home station")
		hostile.weapons = []
		p = Pilot.new()
		controls = p.input(space, space.gate)
		check(p.mode == "transit", "transit does not chase an unarmed hostile freighter")
		hostile.weapons = [{"kind": "gun"}]
		hostile.friendly = true
		p = Pilot.new()
		controls = p.input(space, space.gate)
		check(p.mode == "transit" and not controls.fire, "friendly bodies block primary fire and are never pursued")
		hostile.friendly = false
		space.player.pos = Vector3(0, 0, 80000)
		space.target = space.station
		p = Pilot.new()
		controls = p.input(space, space.gate)
		check(p.mode == "gate_approach" and controls.next_target, "final gate approach selects gate using the ordinary Target control")
		space.target = space.gate
		check(not p.input(space, space.gate).next_target, "acquired final gate does not cycle away")
		before = world_state(space)
		for i in 100: p.input(space, space.gate)
		check(world_state(space) == before, "100 policy evaluations cannot move, heal, damage, retarget or reroll the world")
		space.jumping = 0
		check(p.input(space, space.gate).is_empty(), "native jump sequence is left to the game")
		space.jumping = -1
		space.player.alive = false
		check(p.input(space, space.gate).is_empty(), "defeated player is never steered or repaired")
		check(app.save_attempts.is_empty(), "synthetic policy checks create no saves")
		space.dispose()
	app.queue_free()
	await process_frame
	print("%d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
