extends "res://tests/recovery_scene_check.gd"
## MEMORY-ONLY payload/presentation and old-save compatibility boundaries.
## Synthetic cargo, equipment and poses below NEVER become earned saves.

func offered(kind: int) -> int: return 116 if kind == 3 else 117
func payload(kind: int) -> int: return 117 if kind == 3 else 116

func prepare_pull(sim) -> void:
	# Deliberately isolated geometry and fittings; exercise the real timed pull.
	sim.game.session.equipment[3][1] = {"id": 68, "count": 1}
	sim.game.session.equipment[3][2] = {"id": 82, "count": 1}
	sim.player.pos = Vector3(200000, 0, 0)
	sim.player.basis = Basis.IDENTITY
	var carrier = sim.story.cast.back()
	for body in sim.bodies:
		if body != carrier and body != sim.player: body.visible = false
	carrier.disabled = true
	carrier.pos = sim.player.pos + Vector3(0, 0, 1000)
	sim.target = carrier; sim.locked = true

func pull(sim) -> void:
	sim._tractor_step(4001)
	sim._tractor_step(60)
	sim._tractor_step(1)
	sim.story._check_objectives()

func check_payload(kind: int) -> void:
	var sim = world(kind, 73)
	var game = sim.game
	var carrier = sim.story.cast.back()
	check(int(game.session.job.item) == offered(kind)
		and int(game.session.job.get("recovery_item", -1)) == payload(kind),
		"new acceptance separates source briefing item from source carrier payload")
	check(carrier.cargo == [payload(kind), 1], "designated carrier contains the opposite source payload, exactly one unit")
	prepare_pull(sim)
	var before := state(game)
	var scanned: Dictionary = sim.scanned_cargo()
	check(int(scanned.get("item", -1)) == payload(kind) and int(scanned.get("count", 0)) == 1 and state(game) == before,
		"cargo scanner observes physical payload without renaming it to the briefing item")
	var messages: Array = []
	var observer := func(event, data):
		if event == "message": messages.append(str(data.get("text", "")))
	sim.event.connect(observer)
	# Both IDs coexist: collection and return must not consume the other goods.
	game.session.add_cargo(offered(kind), 2)
	game.session.add_cargo(payload(kind), 2)
	before = state(game)
	pull(sim)
	check(sim.story.complete and not sim.story.failed and bool(game.session.job.get("recovered", false)),
		"real physical carrier pull enters the return leg for both source variants")
	check(game.session.cargo_count(payload(kind)) == 3 and game.session.cargo_count(offered(kind)) == 2,
		"capture transfers the actual ID without transmuting or consuming unrelated goods")
	check(messages.has(app.library.format(261, {"#Q": "1", "#N": app.catalogue.item_name(offered(kind))})),
		"source mission pickup message intentionally uses briefing identity, not inventory identity")
	check(game.session.credits == int(before.credits) and game.session.stat("jobs") == int(before.stats.jobs)
		and game.session.stat("cargo_salvaged") == int(before.stats.cargo_salvaged) + 1,
		"transfer counts one salvaged unit but cannot pay or finish the client return")
	check(not game.can_sell_cargo(payload(kind)) and game.can_sell_cargo(offered(kind)),
		"sale protection follows actual entrusted cargo rather than unrelated briefing-named goods")
	var pending := state(game)
	var cold := Game.new(app.library, app.catalogue)
	check(cold.session.from_dict(pending).is_empty() and state(cold) == pending,
		"new return round-trips every JSON field without rewriting either cargo identity")
	var reward := int(game.session.job.reward)
	game.settle_job(96)
	check(state(game) == pending, "docking at the retrieval orbit cannot consume cargo or award a return")
	game.settle_job(99)
	check(game.session.job.is_empty() and game.session.cargo_count(payload(kind)) == 2
		and game.session.cargo_count(offered(kind)) == 2,
		"client delivery consumes exactly one physical payload with both IDs in the hold")
	check(game.session.credits == int(before.credits) + reward and game.session.stat("jobs") == int(before.stats.jobs) + 1,
		"source return pays the accepted reward and job credit exactly once")
	var settled := state(game); game.settle_job(99)
	check(state(game) == settled, "closed payload return cannot be paid twice")
	check(cold.session.from_dict(pending).is_empty(), "separate cancellation branch starts from the same memory-only pending return")
	cold.cancel_job()
	check(cold.session.job.is_empty() and cold.session.cargo_count(payload(kind)) == 2
		and cold.session.cargo_count(offered(kind)) == 2 and cold.session.credits == int(before.credits),
		"cancellation removes only the entrusted physical unit and grants no money")
	sim.event.disconnect(observer); sim.dispose()

func check_wrong_payload(kind: int) -> void:
	var sim = world(kind, 74)
	prepare_pull(sim)
	var carrier = sim.story.cast.back()
	carrier.cargo = [offered(kind), 1] # Explicit corrupt in-memory actor, not saved state.
	var before := state(sim.game)
	pull(sim)
	check(state(sim.game) == before and carrier.cargo == [offered(kind), 1]
		and not sim.story.complete and not sim.story.failed,
		"wrong carrier ID cannot impersonate the contract's entrusted payload")
	sim.dispose()

func check_legacy(kind: int) -> void:
	var game = fixture(kind)
	game.session.job.erase("recovery_item") # Explicit historical schema fixture.
	var old := state(game)
	var cold := Game.new(app.library, app.catalogue)
	check(cold.session.from_dict(old).is_empty() and state(cold) == old,
		"legacy accepted recovery loads byte-equivalent fields without adding payload metadata")
	cold.jump_arrive(app.catalogue.system_of_station(96), 96)
	var sim := Space.new(cold); sim.build()
	check(sim.story.cast.back().cargo == [offered(kind), 1],
		"legacy uncollected contract retains its historical payload instead of changing mid-job")
	prepare_pull(sim); pull(sim)
	check(bool(cold.session.job.get("recovered", false)) and not cold.session.job.has("recovery_item")
		and cold.session.cargo_count(offered(kind)) == 1,
		"legacy physical collection keeps its original ID and does not invent new-schema metadata")
	var pending := state(cold)
	check(game.session.from_dict(pending).is_empty() and state(game) == pending,
		"legacy recovered return reloads without inventory migration or extra resources")
	game.settle_job(99)
	check(game.session.job.is_empty() and game.session.cargo_count(offered(kind)) == 0
		and game.session.credits == int(header.credits) + int(old.job.reward),
		"legacy return consumes its real historical cargo and pays once")
	sim.dispose()

func check_validation(kind: int) -> void:
	var game = fixture(kind)
	# Explicit new-schema shape independent of the live acceptance implementation.
	game.session.job.recovery_item = payload(kind)
	game.session.job.recovered = true
	game.session.job.station = 99
	game.session.add_cargo(payload(kind), 1)
	var pending := state(game)
	var cold := Game.new(app.library, app.catalogue)
	check(cold.session.from_dict(pending).is_empty() and state(cold) == pending,
		"source-mapped return schema is accepted with actual cargo and no briefing-named cargo")
	for reason in ["wrong_payload", "fractional_payload", "string_payload", "missing_payload_cargo", "wrong_briefing", "wrong_kind", "missing_origin"]:
		var invalid := pending.duplicate(true)
		match reason:
			"wrong_payload": invalid.job.recovery_item = offered(kind)
			"fractional_payload": invalid.job.recovery_item = float(payload(kind)) + 0.5
			"string_payload": invalid.job.recovery_item = str(payload(kind))
			"missing_payload_cargo": invalid.cargo.erase(str(payload(kind))); invalid.cargo[str(offered(kind))] = 1
			"wrong_briefing": invalid.job.item = payload(kind)
			"wrong_kind": invalid.job.kind = 8
			"missing_origin": invalid.job.erase("return_station")
		var before := state(cold)
		check(not cold.session.from_dict(invalid).is_empty() and state(cold) == before,
			"malformed return rejected atomically without fixing inventory: " + reason)
	var accepted := pending.duplicate(true)
	accepted.job.erase("recovered"); accepted.job.station = 96
	accepted.cargo.erase(str(payload(kind)))
	accepted = normalized(accepted) # Compare JSON values, not mixed native int/JSON float types.
	check(cold.session.from_dict(accepted).is_empty() and state(cold) == accepted,
		"valid uncollected source contract requires no pre-awarded cargo")
	for value in [offered(kind), -1, "116", 116.5]:
		var invalid := accepted.duplicate(true); invalid.job.recovery_item = value
		var before := state(cold)
		check(not cold.session.from_dict(invalid).is_empty() and state(cold) == before,
			"payload identity is validated before collection as well as on return")

func check_payload_visual() -> void:
	if render_out.is_empty(): return
	var sim = world(5, 76); prepare_pull(sim)
	sim.story.cast.back().pos = sim.player.pos + Vector3(0, 0, 8000)
	app.game = sim.game
	app.screen.queue_free(); app.screen = null; await frames(2)
	var view = preload("res://src/flight/space_view.gd").new()
	app.world_root.add_child(view); view.setup(app, sim)
	var hud = preload("res://src/flight/hud.gd").new()
	hud.app = app; hud.space = sim; hud.view = view; app.ui_layer.add_child(hud)
	var marker := Label.new()
	marker.text = "MEMORY-ONLY payload boundary — NOT earned gameplay"
	marker.position = Vector2(320, 150); app.ui_layer.add_child(marker)
	# Relay actual simulation messages to the actual HUD, as the flight screen does.
	var relay := func(kind, data):
		if kind == "message": hud.message(str(data.get("text", "")))
	sim.event.connect(relay)
	var before := state(sim.game)
	sim._tractor_step(2000); view.sync(0.016); await frames(3)
	check(sim.scanned_cargo() == {"item": 116, "count": 1} and state(sim.game) == before,
		"rendered hostage carrier scanner shows physical Secure Container before collection")
	await capture("hostage_payload_scanner_memory_only")
	sim._tractor_step(2001); sim._tractor_step(600); view.sync(0.016); await frames(3)
	check(view.tractor_crate.visible and view.tractor_beam.visible and state(sim.game) == before,
		"rendered imported crate and beam remain in flight before physical payload settlement")
	await capture("hostage_payload_pulling_memory_only")
	sim._tractor_step(160); sim._tractor_step(1); sim.story._check_objectives()
	view.sync(0.016); await frames(3)
	var expected: String = app.library.format(261, {"#Q": "1", "#N": app.catalogue.item_name(117)})
	check(sim.game.session.cargo_count(116) == 1 and hud.messages.any(func(m): return m.text == expected)
		and not view.tractor_crate.visible and not view.tractor_beam.visible,
		"rendered source toast names Secure Cabin while actual hold receives one Secure Container")
	await capture("hostage_payload_captured_memory_only")
	sim.event.disconnect(relay)
	hud.queue_free(); view.queue_free(); marker.queue_free(); await frames(3); sim.dispose()

func check_payload_journal() -> void:
	var sim = world(5, 75); prepare_pull(sim); pull(sim)
	app.game = sim.game; app.show_station(); await frames(3)
	app.screen.menu.get_child(3).pressed.emit(); await frames(3)
	var before := state(app.game)
	check(labels(app.screen.current_panel).contains("1 × " + app.catalogue.item_name(117))
		and app.game.session.cargo_count(116) == 1,
		"returned hostage journal keeps Secure Cabin briefing while hold contains actual Secure Container")
	var marker := Label.new()
	marker.text = "MEMORY-ONLY payload boundary — NOT earned gameplay"
	marker.position = Vector2(320, 130); app.ui_layer.add_child(marker)
	await capture("hostage_payload_return_journal_memory_only")
	check(state(app.game) == before, "viewing returned payload journal cannot settle or rename inventory")
	marker.queue_free(); await frames(2); sim.dispose()

func run() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		if args.size() != 1 or DisplayServer.get_name() == "headless" or DirAccess.dir_exists_absolute(args[0]): quit(2); return
		render_out = args[0]; DirAccess.make_dir_recursive_absolute(render_out)
	root.size = Vector2i(1280, 800)
	check(FileAccess.get_sha256(INPUT) == SHA, "accepted native input is byte-identical before payload fixtures")
	if failures: quit(2); return
	header = JSON.parse_string(FileAccess.get_file_as_string(INPUT))
	app = Host.new(); root.add_child(app); await frames(2)
	check(app.activate(str(header.content)), "payload fixtures read the supplied catalogue without new imports")
	if failures: app.queue_free(); await frames(2); quit(2); return
	for kind in [3, 5]:
		check_payload(kind)
		check_wrong_payload(kind)
		check_legacy(kind)
		check_validation(kind)
	await check_payload_visual()
	await check_payload_journal()
	check(app.save_attempts.is_empty() and app.disk_saves.is_empty(), "payload fixtures make zero save attempts")
	check(FileAccess.get_sha256(INPUT) == SHA, "payload fixtures leave sole accepted native input unchanged")
	var attempts: int = app.save_attempts.size()
	app.queue_free(); await frames(3)
	if not render_out.is_empty():
		var file := FileAccess.open(render_out.path_join("report.json"), FileAccess.WRITE)
		file.store_string(JSON.stringify({"kind": "memory-only", "checks": observations, "failures": failures,
			"input_sha256": SHA, "save_attempts": attempts}, "\t"))
	print("RECOVERY PAYLOAD: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
