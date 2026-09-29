extends SceneTree
## Explicit memory-only fixtures, never earned saves or playthrough evidence.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
const Body := preload("res://src/flight/body.gd")
var checks := 0
var failures := 0

func _init() -> void:
	run.call_deferred()

func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)

func fixture(app, step: int, in_void: bool):
	var game := Game.new(app.library, app.catalogue)
	game.new_game()
	game.session.story_step = step - 1
	game.campaign.advance()
	game.session.station_id = 91
	game.session.system_index = 18
	game.session.in_void = in_void
	# These flags are inherited from actual mission twenty-eight. The unit
	# jumps to its explicit fixture cursor, so must supply that precondition.
	game.session.flags.wormhole_station = 91
	game.session.flags.wormhole_system = 18
	return game

func run() -> void:
	root.size = Vector2i(1280, 800)
	var app := Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		check(false, "supplied content is installed")
		quit(1)
		return
	var game = fixture(app, 30, true)
	var s = game.session
	var credits: int = s.credits
	var inventory := JSON.stringify(s.equipment)
	var markets := JSON.stringify(s.markets)
	check(not game.campaign.check(false, -1, 999999), "Void scan checkpoint cannot complete normal-space arrival mission")
	game.cross_wormhole()
	check(not s.in_void and s.story_step == 30 and s.station_id == 91 and s.system_index == 18,
		"physical return changes world but never skips the Dima arrival objective")
	app.game = game
	app.show_flight()
	var flight = app.screen
	flight.set_physics_process(false)
	var space = flight.space
	var start: Vector3 = space.player.pos
	var basis: Basis = space.player.basis
	var hull: int = space.player.hull
	var armor: int = space.player.armor
	var portal = space.wormhole
	var old_portal: Vector3 = portal.pos
	check(space.story == null and space.portal_arriving(), "arrival shot exists without an active scripted Story scene")
	check(portal.visible and portal.elapsed == 39000 and portal.opening_scale == 1.0,
		"just-used portal starts at the source late lifetime phase")
	check(portal.pos.is_equal_approx(start - basis.z * 8192.0), "arrival portal is exactly 8192 source units behind the ship")
	var yaw := atan2(basis.z.x, basis.z.z)
	var offset: Vector3 = Basis(Vector3.UP, yaw).inverse() * (space.portal_arrival_camera - start)
	check(is_equal_approx(offset.z, 10000.0) and absf(offset.x) >= 499.9 and absf(offset.x) <= 999.1
		and absf(offset.y) >= 499.9 and absf(offset.y) <= 999.1, "source arrival camera uses signed local offsets and ship yaw")
	flight.view.sync(0)
	check(flight.view.camera.global_position.is_equal_approx(space.portal_arrival_camera * flight.view.UNIT),
		"native view uses the actual arrival camera position")
	check(app.save_attempts.is_empty() and s.credits == credits and JSON.stringify(s.markets) == markets,
		"physical return starts no docking, reward, shelf or save transaction")
	# Keep this clock/input fixture independent of randomized NPC attacks.
	space.bodies = space.bodies.filter(func(b): return not b.is_ship() or b == space.player)
	space.step(0.016, {"yaw": 1.0, "pitch": 1.0, "fire": true, "secondary": true, "next_target": true, "boost": true})
	check(space.player.basis.is_equal_approx(basis) and space.shots_fired == 0 and space.target == null,
		"arrival prevents steering, firing and target-lock input")
	check(space.player.pos.is_equal_approx(start + basis.z * 32.0), "arrival coasts at normal speed without portal attraction")
	check(space.player.hull == hull and space.player.armor == armor and JSON.stringify(s.equipment) == inventory,
		"arrival never replaces durability or adds equipment")
	space.player.pos = portal.pos
	space._collisions()
	check(not space.portal_crossed and app.screen == flight and not s.in_void,
		"disabled source collision loop cannot immediately cross the just-used portal")
	space.player.pos = start + basis.z * 32.0
	space._step_wormhole(984)
	check(portal.elapsed == 40000 and portal.usable(), "closing portal remains usable at exactly forty seconds")
	space._step_wormhole(1)
	check(not portal.usable() and portal.opening_scale < 1.0, "closing begins strictly beyond forty seconds")
	space._step_wormhole(3000)
	check(portal.elapsed == -3000 and portal.pos != old_portal and not space.portal_crossed,
		"return portal relocates while the arrival collision guard remains active")
	var ended: Array = []
	space.event.connect(func(kind, data):
		if kind == "portal_arrival_finished": ended.append(data))
	space._step_portal_arrival(6984)
	check(space.portal_arrival_ms == 7000 and space.portal_arriving() and ended.is_empty(),
		"exactly seven seconds does not release the strict source arrival boundary")
	space._step_portal_arrival(1)
	check(not space.portal_arriving() and ended.size() == 1 and int(ended[0].elapsed) == 7001,
		"arrival releases controls and collisions strictly after seven seconds")
	space._step_portal_arrival(500)
	check(ended.size() == 1, "arrival completion is emitted only once")
	space.step(0.016, {"yaw": 1.0})
	check(not space.player.basis.is_equal_approx(basis), "ordinary steering works after arrival release")
	check(not game.campaign.check(false, 91, 10000) and game.campaign.check(false, 91, 10001),
		"Dima arrival goal retains the source strict ten-second flight boundary")
	check(not game.campaign.check(true, 91, 10001) and not game.campaign.check(false, 90, 10001),
		"docking or a different station cannot substitute for Dima flight arrival")
	game.campaign.conclude()
	check(s.story_step == 31 and int(s.story_mission.station) == 98 and int(s.story_mission.kind) == 11
		and int(s.story_mission.reward) == 30000, "supplied continuation is the Alioth dock/report with thirty-thousand-credit reward")
	check(s.credits == credits and not game.campaign.check(false, 98, 999999)
		and not game.campaign.check(true, 91), "arrival awards no money and the report requires docking at Alioth")
	game.dock(98)
	check(s.story_step == 32 and s.credits == credits + 30000, "real docking transaction settles the original report reward once")
	game.dock(98)
	check(s.story_step == 32 and s.credits == credits + 30000, "repeat docking cannot duplicate the settled report reward")
	# In-flight reload is deliberately distinct from another physical return.
	var resumed = fixture(app, 30, true)
	resumed.resume()
	check(resumed.arrival_mode == "void_resume" and resumed.session.in_void, "Void reload is not relabeled as a new portal crossing")
	var reopened := Space.new(resumed)
	reopened.build()
	check(not reopened.portal_arriving() and reopened.wormhole.elapsed == 0
		and reopened.player.pos == reopened.arrival.pos, "reload opens ordinary Void flight at its native arrival point")
	reopened.dispose()
	# The same native boundary protects the preceding physical entry to scan.
	var entry = fixture(app, 29, false)
	entry.cross_wormhole()
	var entered := Space.new(entry)
	entered.build()
	check(entered.portal_arriving() and entered.in_void and entered.story != null and entered.story.step == 29,
		"physical entry to mission twenty-nine uses the coherent arrival shot")
	entered.player.pos = entered.wormhole.pos
	entered._collisions()
	check(entered.player.alive and not entered.portal_crossed, "entry camera cannot trigger the active scan early-escape failure")
	entered._step_portal_arrival(7001)
	entered._collisions()
	check(not entered.player.alive and not entered.portal_crossed, "outside arrival protection early scan escape still fails normally")
	entered.dispose()
	app.queue_free()
	await process_frame
	await process_frame
	print("PORTAL ARRIVAL: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
