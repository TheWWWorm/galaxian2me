extends SceneTree
## Explicit isolated unit fixtures, never earned campaign inputs.
const TestApp := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
const Body := preload("res://src/flight/body.gd")
const Session := preload("res://src/simulation/session.gd")
const Flight := preload("res://src/screens/flight_screen.gd")
var checks := 0
var failures := 0

func _init() -> void:
	run.call_deferred()

func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)

func run() -> void:
	var app := TestApp.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		check(false, "supplied content installed")
		quit(1)
		return
	var game := Game.new(app.library, app.catalogue)
	game.new_game()
	game.session.story_step = 23
	game.campaign.advance()
	game.arrive(48)
	var space := Space.new(game)
	space.build()
	var portal = space.wormhole
	check(portal != null and not portal.model.is_empty() and portal.model == app.library.model_name(6805), "portal uses the supplied vortex model")
	check(not portal.visible and not portal.usable(), "station forty-eight salvage starts with a hidden unusable portal")
	portal.tick(50000, true, 24, space.player.pos, space.rng)
	check(portal.elapsed == 0, "a hidden portal does not consume its first open interval")
	var selectable := false
	for i in space.bodies.size() + 2:
		space._cycle_target()
		selectable = selectable or space.target == portal
	check(not selectable, "target cycling cannot disclose the hidden portal")
	var story = space.story
	space.player.hull -= 7
	var hull: int = space.player.hull
	var armor: int = space.player.armor
	story.fired[0] = true
	story._run_void_reveal()
	check(story.stage == 1 and story.controls_locked and story.hud_hidden and story.camera_target == space.player
		and story.camera_mode == "look" and story.camera_position == space.player.pos + Vector3(30500, 700, 1000),
		"first salvage radio starts the original locked camera shot")
	check(is_equal_approx(portal.pos.distance_to(space.player.pos), 40960.0) and not portal.visible,
		"cinematic places the still-hidden portal 40960 units ahead")
	space._harm(space.player, 10000000, 10000000, story.cast[0])
	check(space.player.hull == hull and space.player.armor == armor and space.player.alive,
		"cinematic protects the real durability instead of substituting enormous saved health")
	story.finished[0] = true
	story._run_void_reveal()
	check(story.stage == 2 and portal.visible and portal.elapsed == 0, "first radio acknowledgement reveals and resets the portal")
	check(not game.session.in_void and game.session.location_id() == 48, "revealing a portal does not change the world or campaign")
	portal.tick(40000, true, 24, space.player.pos, space.rng)
	check(portal.usable() and portal.opening_scale == 1.0, "portal remains usable through forty seconds")
	portal.tick(1, true, 24, space.player.pos, space.rng)
	check(not portal.usable() and portal.opening_scale < 1.0, "closing fade immediately disables crossing")
	portal.tick(3000, true, 24, space.player.pos, space.rng)
	check(portal.elapsed == -3000 and portal.opening_scale == 0.0 and portal.visible, "recurring portal relocates into its three-second opening fade")
	var bounded := true
	for axis in 3: bounded = bounded and absf(portal.pos[axis]) >= 20000.0 and absf(portal.pos[axis]) < 60000.0
	check(bounded, "relocation uses the supplied signed coordinate bounds")
	portal.tick(3000, true, 24, space.player.pos, space.rng)
	check(portal.elapsed == 0 and portal.opening_scale == 1.0, "opening fade returns to full size without shortening the next open interval")
	portal.elapsed = 43000
	space.target = portal
	space.autopilot = true
	space._step_wormhole(1)
	check(space.target == null and not space.autopilot, "relocation releases the obsolete autopilot course")
	portal.reveal()
	portal.tick(43001, false, 24, space.player.pos, space.rng)
	check(not portal.visible, "a non-recurring portal expires rather than inventing another")
	portal.reveal()
	portal.tick(50000, true, 40, space.player.pos, space.rng)
	check(portal.elapsed == 40000 and portal.usable(), "source step forty pins its portal open")
	portal.reveal()
	var fallen: Body = story.cast[0]
	space._harm(fallen, fallen.hull + fallen.armor + fallen.shield, 0, space.player)
	space._cleanup(2000)
	check(not fallen.alive and not space.bodies.has(fallen) and space.fallen_voids.has(fallen), "removed dead Void remains eligible for periodic regeneration")
	space._regenerate_voids(40000)
	check(not fallen.alive, "dead Void does not regenerate before the world's forty-second boundary")
	space._regenerate_voids(1)
	check(fallen.alive and fallen.hull == fallen.hull_max and space.bodies.has(fallen), "periodic sweep restores the dead Void to the active world")
	var offset: Vector3 = (fallen.pos - portal.pos).abs()
	check(offset.x <= 10000 and offset.y <= 10000 and offset.z <= 10000, "station-side Void regeneration occurs around the portal")
	fallen.hull -= 3
	space._regenerate_voids(40001)
	check(fallen.hull == fallen.hull_max - 3, "periodic regeneration never heals an already living opponent")
	fallen.disabled = true
	fallen.emp = 0
	space._regenerate_voids(40001)
	check(fallen.alive and fallen.disabled and fallen.emp == 0, "living EMP-disabled ships are not mistaken for dead regeneration candidates")
	space._harm(fallen, fallen.hull + fallen.armor + fallen.shield, 0, space.player)
	space._cleanup(2000)
	space._regenerate_voids(40001)
	check(fallen.alive and not fallen.disabled and fallen.emp == fallen.emp_max,
		"a ship killed while EMP-disabled receives fresh EMP state when its dead hull regenerates")
	space._harm(fallen, fallen.hull + fallen.armor + fallen.shield, 0, space.player)
	space._regenerate_voids(40001)
	check(not fallen.alive and fallen.dead_timer > 0.0, "periodic sweep does not revive a still-playing death animation")
	space._cleanup(2000)
	space._regenerate_voids(40001)
	check(fallen.alive, "fully removed death can regenerate at the following world sweep")
	var crossing: Array = []
	space.event.connect(func(kind, data):
		if kind == "wormhole_crossed": crossing.append(data))
	space.player.pos = portal.pos + Vector3(0, 0, 4000)
	portal.elapsed = 40001
	space._collisions()
	check(crossing.is_empty(), "closed portal rejects an otherwise close collision")
	portal.reveal()
	space._collisions()
	space._collisions()
	check(crossing.size() == 1 and float(crossing[0].distance) < 4096, "one physical threshold crossing emits exactly one transition")
	check(game.session.ship.hull == hull + armor, "crossing stores real hull and armor, not cinematic protection")
	story.finished.fill(true)
	story._check_objectives()
	game.campaign.conclude()
	check(game.session.story_step == 25 and int(game.session.story_mission.station) == -1, "source result requests mission twenty-five at Void world minus one")
	check(not game.campaign.check(false, -1, 20000) and not game.campaign.check(false, 48, 20000), "neither sentinel argument nor ordinary flight can spoof Void arrival")
	var normal_space := Space.new(game)
	normal_space.build()
	check(normal_space.story == null, "normal station does not spawn mission twenty-five hunters from a minus-one wildcard")
	normal_space.dispose()
	var visited := game.session.visited_stations.duplicate(true)
	var markets := game.session.markets.duplicate(true)
	game.cross_wormhole()
	check(game.session.location_id() == -1 and game.session.station_id == 48 and game.session.system_index == 9,
		"Void identity retains a valid separate normal-space return address")
	check(game.session.visited_stations == visited and game.session.markets == markets, "crossing is not a visit, market roll or docking transaction")
	var void_space := Space.new(game)
	void_space.build()
	check(void_space.in_void and not void_space.station.visible and void_space.station.station_id == -1
		and void_space.station_boxes.is_empty() and void_space.gate == null, "Void world has no dockable station or normal jump gate")
	var rocks: Array = void_space.bodies.filter(func(b): return b.kind == Body.Kind.ASTEROID)
	check(rocks.size() == 50 and rocks.all(func(b): return b.ore == 164 and b.model == app.library.model_name(6804)), "Void fields use the supplied alien asteroid model and ore")
	check(void_space.bodies.all(func(b): return b.kind != Body.Kind.STAR), "Void space has no normal-system travel destinations")
	check(void_space.story != null and void_space.story.cast.size() == 3 and void_space.story.objective.is_empty(), "Void arrival creates three hunters without a fabricated kill-all objective")
	check(not game.campaign.check(false, -1, 10000) and game.campaign.check(false, -1, 10001), "mission twenty-five requires more than ten seconds in the real Void world")
	check(not game.campaign.check(true, -1, 20000), "Void arrival can never be fulfilled by docking")
	var state: Dictionary = JSON.parse_string(JSON.stringify(game.session.to_dict()))
	var restored := Session.new(app.catalogue)
	restored.content_id = game.session.content_id
	check(restored.from_dict(state).is_empty() and restored.in_void and restored.location_id() == -1, "Void context passes a real JSON session round trip")
	var malformed: Dictionary = state.duplicate(true)
	malformed.in_void = 1
	check(not restored.from_dict(malformed).is_empty(), "malformed non-boolean world context is rejected")
	app.game = game
	app.save_game(0)
	var saved_hull: int = game.session.ship.hull
	check(app.load_game(0).is_empty() and app.game.session.in_void and app.screen is Flight, "native reload resumes Void flight instead of opening a false station")
	check(app.game.session.ship.hull == saved_hull, "Void reload grants no station repair")
	app.show_station()
	check(app.screen is Flight and app.game.session.in_void, "generic Continue cannot expose a station while in Void space")
	check(JSON.parse_string(JSON.stringify(app.game.session.markets)) == JSON.parse_string(JSON.stringify(markets)),
		"Void reload preserves station inventory across JSON numeric normalization")
	print("NEXT VOID MISSION: ", JSON.stringify(game.session.story_mission))
	game.campaign.conclude()
	print("AFTER ARRIVAL: ", JSON.stringify(game.session.story_mission))
	check(game.session.story_step == 26 and game.session.in_void, "arrival result retains Void context while preparing the normal-space ambush")
	var waiting := Space.new(game)
	waiting.build()
	check(waiting.story == null, "mission twenty-six cannot activate in Void world minus one")
	waiting.dispose()
	var before_return := game.session.to_dict()
	game.cross_wormhole()
	check(game.session.story_step == 26 and game.session.location_id() == 48, "physical return preserves the uncompleted station-side ambush cursor")
	check(game.session.ship == before_return.ship and game.session.cargo == before_return.cargo
		and game.session.markets == before_return.markets, "return transition is not a repair, cargo handover or market transaction")
	var returned := Space.new(game)
	returned.build()
	check(returned.story != null and returned.story.cast.size() == 2, "normal-space return activates exactly two supplied ambush fighters")
	var matching := returned.story != null
	if returned.story != null:
		for actor in returned.story.cast:
			var ambush_offset: Vector3 = actor.pos - returned.player.pos
			matching = matching and actor.faction == 9 and actor.ship_index == 8
			matching = matching and absf(ambush_offset.x) <= 700 and absf(ambush_offset.y) <= 700 and is_equal_approx(ambush_offset.z, 2000)
			matching = matching and actor.basis.is_equal_approx(returned.player.basis)
	check(matching, "return ambush uses source hulls, offsets and copied player orientation")
	check(not game.campaign.check(false, 48, 20000), "merely returning never completes the two-fighter combat objective")
	# Explicit memory-only death-state fixture, never an earned save.
	for actor in returned.story.cast:
		actor.alive = false
		actor.dead_timer = 1.0
	returned.story._check_objectives()
	check(not returned.story.complete, "zero hull does not cut directly from ongoing deaths to the ambush result")
	returned.story.cast[0].dead_timer = 0.0
	returned.story._check_objectives()
	check(not returned.story.complete, "the result waits for the second death sequence too")
	returned.story.cast[1].dead_timer = 0.0
	returned.story._check_objectives()
	check(returned.story.complete and game.campaign.check(false, 48, 20000), "both fully completed deaths satisfy the original ambush result condition")
	returned.dispose()
	void_space.dispose()
	space.dispose()
	app.queue_free()
	await process_frame
	await process_frame
	print("WORMHOLE: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
