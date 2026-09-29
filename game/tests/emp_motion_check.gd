extends "res://tests/tractor_check.gd"
## MEMORY ONLY. These synthetic poses expose disabled propulsion and a
## moving-player tractor approach. No fixture is saved as earned progress.
const NativeAI := preload("res://src/flight/ai.gd")
const Actor := preload("res://src/flight/body.gd")
const RecoveryPilot := preload("res://tests/support/recovery_pilot.gd")
const Observation := preload("res://tests/support/simulation_snapshot.gd")

func run() -> void:
	check(FileAccess.get_sha256(INPUT) == SHA, "EMP motion fixtures preserve immutable input")
	if failures: quit(2); return
	header = JSON.parse_string(FileAccess.get_file_as_string(INPUT))
	app = Host.new(); root.add_child(app)
	await process_frame; await process_frame
	check(app.activate(str(header.content)), "EMP motion tests read supplied content")
	for direction in [Vector3.FORWARD, Vector3.BACK, Vector3(1, 2, 3).normalized()]:
		check_stationary(direction)
	check_recovery_boundary()
	check_moving_approach()
	check(app.save_attempts.is_empty() and app.disk_saves.is_empty(), "EMP fixtures never write a synthetic save")
	check(FileAccess.get_sha256(INPUT) == SHA, "EMP motion leaves earned input byte-identical")
	app.queue_free(); await process_frame; await process_frame
	print("EMP MOTION: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)

func check_stationary(direction: Vector3) -> void:
	var sim = prepared()
	var carrier = sim.story.cast.back()
	carrier.basis = Actor.facing(direction)
	carrier.speed = 3.0
	carrier.weapons = [sim.weapon(18)]
	carrier.weapons[0].cooldown = 400
	var origin: Vector3 = carrier.pos
	var before := state(sim.game)
	var projectile_count: int = sim.projectiles.size()
	for ms in [16, 48, 200, 400]: NativeAI.step(sim, carrier, float(ms) / 1000.0, ms)
	check(carrier.pos == origin, "EMP disables forward propulsion for heading " + str(direction))
	check(int(carrier.weapons[0].cooldown) == 0, "disabled weapon cooldown still elapses normally")
	check(sim.projectiles.size() == projectile_count and state(sim.game) == before,
		"disabled movement neither fires nor changes mission inventory")
	sim.dispose()

func check_recovery_boundary() -> void:
	var sim = prepared()
	var carrier = sim.story.cast.back()
	carrier.emp = 0; carrier.emp_timer = 0
	carrier.basis = Basis.IDENTITY
	carrier.ai = {"mode": "patrol", "timer": 0, "evade": 0,
		"target": null, "home": carrier.pos, "waypoint": carrier.pos + Vector3(0, 0, 50000)}
	var origin: Vector3 = carrier.pos
	carrier.recover(carrier.emp_regen - 1)
	NativeAI.step(sim, carrier, 0.016, 16)
	check(carrier.disabled and carrier.pos == origin, "last disabled millisecond cannot propel a ship")
	carrier.recover(1)
	NativeAI.step(sim, carrier, 0.016, 16)
	check(not carrier.disabled and carrier.emp == carrier.emp_max and carrier.pos != origin,
		"ordinary propulsion resumes at actual EMP recovery without a permanent freeze")
	sim.dispose()

func check_moving_approach() -> void:
	var sim = prepared(68)
	var carrier = sim.story.cast.back()
	carrier.pos = sim.player.pos + Vector3(0, 0, 9050)
	carrier.basis = Actor.facing(Vector3.FORWARD)
	carrier.emp = 0; carrier.emp_timer = 0
	# This is an explicitly synthetic isolated flight, not a mission replay.
	for b in sim.bodies:
		if b != carrier and b != sim.player: b.ai.mode = "hold"
	var pilot := RecoveryPilot.new()
	var origin: Vector3 = sim.player.pos
	var carrier_origin: Vector3 = carrier.pos
	var readonly := true
	var seen_charge := false
	var seen_pull := false
	var max_charge := 0
	for tick in 380:
		var before := Observation.capture(sim)
		var controls := pilot.input(sim)
		readonly = readonly and before == Observation.capture(sim)
		sim.step(0.016, controls)
		var status: Dictionary = sim.tractor_status()
		seen_charge = seen_charge or status.get("phase") == "charging"
		seen_pull = seen_pull or status.get("phase") == "pulling"
		max_charge = maxi(max_charge, int(status.get("elapsed_ms", 0)))
		if bool(sim.game.session.job.get("recovered", false)): break
	print("EMP APPROACH ", JSON.stringify({"charge_ms": max_charge, "pulled": seen_pull,
		"cargo": sim.game.session.cargo_count(117), "clock": sim.clock,
		"player_travel": sim.player.pos.distance_to(origin), "carrier_travel": carrier.pos.distance_to(carrier_origin)}))
	check(readonly and sim.player.pos.distance_to(origin) > 8000.0,
		"recovery controller uses read-only steering while native player flight advances")
	check(seen_charge and seen_pull and max_charge > 4000,
		"moving player can finish the supplied strict four-second tractor charge")
	check(sim.game.session.cargo_count(117) == 1 and bool(sim.game.session.job.get("recovered", false)),
		"native moving-player approach physically captures one entrusted container")
	check(sim.game.session.credits == int(header.credits) and sim.game.session.stat("jobs") == int(header.stats.jobs),
		"physical fixture capture never pays the client return early")
	sim.dispose()
