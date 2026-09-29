extends "res://tests/recovery_check.gd"
## MEMORY-ONLY charge/pull boundaries. Geometry, gear and disabled actors are
## synthetic fixtures and are NEVER saved or accepted as earned gameplay.

func prepared(id := 68):
	var sim = world()
	sim.game.session.equipment[3][1] = {"id": id, "count": 1}
	sim.player.pos = Vector3(200000, 0, 0)
	sim.player.basis = Basis.IDENTITY
	var carrier = sim.story.cast.back()
	for body in sim.bodies:
		if body != carrier and body != sim.player: body.visible = false
	carrier.disabled = true
	carrier.pos = sim.player.pos + Vector3(0, 0, 8000)
	sim.target = carrier
	sim.locked = true
	return sim

func run() -> void:
	check(FileAccess.get_sha256(INPUT) == SHA, "tractor fixtures preserve accepted native input")
	if failures: quit(2); return
	header = JSON.parse_string(FileAccess.get_file_as_string(INPUT))
	app = Host.new(); root.add_child(app)
	await process_frame; await process_frame
	check(app.activate(str(header.content)), "tractor boundaries read only supplied content")
	var sim = prepared()
	var carrier = sim.story.cast.back()
	var before := state(sim.game)
	sim._collisions()
	check(state(sim.game) == before and carrier.cargo == [117, 1],
		"mere proximity and scanner lock cannot instantly transfer the mission container")
	check(sim.has_method("tractor_status") and sim.has_method("_tractor_step"),
		"native tractor exposes a timed charge and physical-pull state")
	var supported: bool = sim.has_method("tractor_status") and sim.has_method("_tractor_step")
	sim.dispose()
	if supported:
		for id in [68, 69, 70]: check_duration(id)
		check_interruptions()
		check_pull_boundaries()
		check_pickup_observer()
	check(app.save_attempts.is_empty() and app.disk_saves.is_empty(), "tractor fixtures never write a synthetic save")
	check(FileAccess.get_sha256(INPUT) == SHA, "tractor boundaries leave earned input byte-identical")
	app.queue_free(); await process_frame; await process_frame
	print("TRACTOR: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)

func check_duration(id: int) -> void:
	var sim = prepared(id)
	var carrier = sim.story.cast.back()
	var before := state(sim.game)
	var duration: int = app.catalogue.attr(id, app.catalogue.A_TRACTOR_SPEED)
	check(duration == {68: 4000, 69: 3000, 70: 2000}[id], "actual supplied tractor duration: %d" % id)
	sim._tractor_step(500)
	var status: Dictionary = sim.tractor_status()
	check(status.get("phase") == "charging" and int(status.get("elapsed_ms", -1)) == 500
		and float(status.get("progress", -1)) == 0.0, "tractor ring waits through the source's first 500 ms")
	sim._tractor_step(duration - 500)
	status = sim.tractor_status()
	check(status.get("phase") == "charging" and is_equal_approx(float(status.get("progress", 0)), 1.0)
		and state(sim.game) == before, "strict source threshold cannot transfer at exactly the charge duration")
	sim._tractor_step(1)
	check(sim.tractor_status().get("phase") == "pulling" and state(sim.game) == before,
		"completed tractor charge starts a physical pull, not an inventory grant")
	sim._loot(carrier)
	check(state(sim.game) == before, "direct settlement cannot bypass a container still in flight")
	sim._tractor_step(700)
	check(state(sim.game) == before and is_equal_approx(sim.tractor.position.distance_to(sim.player.pos), 1000.0),
		"container moves at source ten units per millisecond without moving the ship")
	sim._tractor_step(60)
	check(state(sim.game) == before and is_equal_approx(sim.tractor.position.distance_to(sim.player.pos), 400.0),
		"capture waits until the source 400-unit collection boundary")
	sim._tractor_step(1)
	sim.story._check_objectives()
	check(sim.game.session.cargo_count(117) == 1 and carrier.cargo.is_empty()
		and bool(sim.game.session.job.get("recovered", false)), "physical arrival transfers exactly the actual recovery container")
	check(sim.game.session.credits == int(before.credits) and sim.game.session.stat("jobs") == int(before.stats.jobs),
		"tractor capture neither pays the reward nor counts the pending return as finished")
	before = state(sim.game)
	sim._tractor_step(9000); sim._loot(carrier)
	check(state(sim.game) == before and sim.tractor_status().is_empty(), "completed pull clears transient state and cannot duplicate capture")
	sim.dispose()

func check_interruptions() -> void:
	for reason in ["target", "aim", "active", "hidden", "removed", "range", "gear", "autopilot", "dead_player", "retired"]:
		var sim = prepared()
		var carrier = sim.story.cast.back()
		sim._tractor_step(1500)
		check(sim.tractor_status().get("phase") == "charging", "fixture has a partial native charge before " + reason)
		match reason:
			"target": sim.target = sim.station
			"aim": sim.player.basis = Basis(Vector3.UP, PI)
			"active": carrier.disabled = false
			"hidden": carrier.visible = false
			"removed": sim.bodies.erase(carrier)
			"range": carrier.pos = sim.player.pos + Vector3(0, 0, 9000)
			"gear": sim.game.session.equipment[3][1] = null
			"autopilot": sim.autopilot = true
			"dead_player": sim.player.alive = false
			"retired": sim.completed_flight = true
		var before := state(sim.game)
		sim._tractor_step(5000)
		check(sim.tractor_status().is_empty() and state(sim.game) == before and carrier.cargo == [117, 1],
			"interrupted charge cannot accumulate or award cargo: " + reason)
		sim.dispose()
	var sim = prepared()
	sim._tractor_step(1500)
	sim.player.basis = Basis(Vector3.UP, PI); sim._tractor_step(1)
	sim.player.basis = Basis.IDENTITY; sim._tractor_step(500)
	check(int(sim.tractor_status().get("elapsed_ms", -1)) == 500, "reacquisition begins a new charge rather than resuming interrupted time")
	var detached: Dictionary = sim.tractor_status()
	detached.elapsed_ms = 999999
	check(int(sim.tractor_status().get("elapsed_ms", -1)) == 500, "HUD progress is a detached read-only observation")
	sim.dispose()

func check_pull_boundaries() -> void:
	var sim = prepared()
	var carrier = sim.story.cast.back()
	sim._tractor_step(4001)
	carrier.disabled = false
	sim.target = sim.station
	sim.player.basis = Basis(Vector3.UP, PI)
	sim._tractor_step(760); sim._tractor_step(1)
	check(sim.game.session.cargo_count(117) == 1, "once detached, the physical container keeps coming after aim changes or EMP wears off")
	sim.dispose()
	for reason in ["full", "dead_carrier", "canceled"]:
		sim = prepared()
		carrier = sim.story.cast.back()
		sim._tractor_step(4001)
		match reason:
			"full": sim.game.session.add_cargo(99, sim.game.session.cargo_free())
			"dead_carrier": carrier.alive = false
			"canceled": sim.game.cancel_job()
		var before := state(sim.game)
		sim._tractor_step(760); sim._tractor_step(1); sim.story._check_objectives()
		check(sim.game.session.cargo_count(117) == 0 and sim.game.session.credits == int(before.credits),
			"unsuccessful pull cannot grant mission goods or money: " + reason)
		if reason == "full":
			check(sim.story.failed and sim.game.session.job.is_empty() and carrier.cargo.is_empty(),
				"actual full-hold capture loses the entrusted crate, rather than retrying for a reward")
		sim.dispose()

func check_pickup_observer() -> void:
	var sim = prepared()
	var observer = preload("res://tests/support/cargo_pickup_observer.gd").new()
	observer.begin_world(sim)
	var observe := func(_kind, _data): observer.observe(sim)
	sim.event.connect(observe)
	sim._tractor_step(4001)
	var carrier = sim.story.cast.back()
	carrier.disabled = false
	# The detached crate survives EMP recovery, and the player may turn away.
	sim.player.pos -= Vector3(0, 0, 2000)
	observer.observe(sim)
	sim._tractor_step(960); observer.observe(sim)
	sim._tractor_step(1); observer.observe(sim)
	check(observer.errors.is_empty() and observer.totals == {"117": 1}
		and carrier.pos.distance_to(sim.player.pos) > 9000.0,
		"independent observer reconciles the physical crate, not the recovered carrier's distant position")
	sim.event.disconnect(observe)
	sim.dispose()
