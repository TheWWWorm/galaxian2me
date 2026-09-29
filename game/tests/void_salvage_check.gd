extends SceneTree
## Explicit in-memory source-behaviour fixtures. Never campaign input saves.
## No original content, player storage or settings are modified.
const TestApp := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
const Body := preload("res://src/flight/body.gd")
const Session := preload("res://src/simulation/session.gd")
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
	else:
		var game := Game.new(app.library, app.catalogue)
		game.new_game()
		# Synthetic stage and geometry only in this no-save unit test.
		game.session.story_step = 23
		game.campaign.advance()
		check(game.session.flags.get("wormhole_station", -1) == 48
			and game.session.flags.get("wormhole_system", -1) == 9,
			"supplied progression stores the wormhole station/system, not ship or cargo values")
		game.arrive(48)
		var space := Space.new(game)
		space.build()
		var story = space.story
		check(story != null and story.cast.size() == 3, "station forty-eight creates three supplied Void fighters")
		var route := [Vector3(100000, 0, 0), Vector3(100000, 0, -30000)]
		var routed := true
		for actor in story.cast:
			routed = routed and actor.ai.get("route", []) == route and actor.ship_index == 8 and actor.faction == 9
		check(routed, "three Void hulls follow the original two-point route")
		check(story.cast[0].pos != story.cast[1].pos and story.cast[1].pos != story.cast[2].pos,
			"scene spawns individual ships instead of stacking their collision boxes")
		check(story.objective.get("kind", "") == "radio_end", "salvage mission finishes on its last radio, not the final kill")
		check(story.records == [[1047.0, 6.0, 22.0, 3.0], [1048.0, 6.0, 6.0, 0.0]],
			"mission uses supplied three-unit salvage and following radio triggers")
		for actor in story.cast:
			space._harm(actor, actor.hull + actor.armor + actor.shield, 0, space.player)
		var drops: Array = space.bodies.filter(func(b): return b.kind == Body.Kind.LOOT)
		check(drops.size() == 3 and drops.all(func(b): return int(b.cargo[0]) == 131 and int(b.cargo[1]) >= 1 and int(b.cargo[1]) <= 3),
			"each destroyed Void creates one to three units of alien remains")
		story._check_objectives()
		check(not story.complete and not bool(game.session.story_mission.get("done", false)),
			"destroying all fighters without salvage cannot advance the mission")
		check(not story._triggered(0), "kills alone cannot trigger the salvage conversation")
		# Controlled cargo box checks accepted amounts and repeated collection.
		space._drop(Vector3.ZERO, 131, 3, "box")
		var box: Body = space.bodies.back()
		game.session.add_cargo(122, game.session.cargo_free())
		var before: int = game.session.stat("cargo_salvaged")
		space._collect(box)
		check(box.alive and int(space.stats.get("collected", 0)) == 0 and game.session.stat("cargo_salvaged") == before,
			"a full hold neither destroys the uncollected box nor advances the counter")
		game.session.add_cargo(122, -game.session.cargo_count(122))
		space._collect(box)
		check(not box.alive and game.session.cargo_count(131) == 3 and int(space.stats.get("collected", 0)) == 3,
			"accepted cargo units enter both the hold and this flight's salvage counter")
		space._collect(box)
		check(game.session.cargo_count(131) == 3 and game.session.stat("cargo_salvaged") == before + 3,
			"a consumed cargo box cannot duplicate inventory or salvage statistics")
		check(story._triggered(0) and not story._triggered(1), "three salvaged units unlock only the first supplied radio")
		story._check_objectives()
		check(not story.complete, "salvage still waits for both radio acknowledgements")
		story.finished[0] = true
		check(story._triggered(1), "first radio acknowledgement enables the supplied second line")
		story.finished[1] = true
		story._check_objectives()
		check(story.complete and game.campaign.check(false, 48), "final radio acknowledgement completes the actual mission condition")
		game.campaign.conclude()
		check(game.session.story_step == 25 and int(game.session.story_mission.station) == -1,
			"mission completion requests the supplied Void-space arrival without changing stations")
		var credits: int = game.session.credits
		var cargo: int = game.session.cargo_count(131)
		check(not game.sell(131, cargo).is_empty() and game.session.cargo_count(131) == cargo and game.session.credits == credits,
			"the supplied step twenty-five cargo flag prevents selling mission remains")
		game.session.add_cargo(122, 1)
		check(game.sell(122, 1).is_empty(), "mission cargo protection does not lock unrelated commodities")
		var restored := Session.new(app.catalogue)
		restored.content_id = game.session.content_id
		var serialized: Dictionary = JSON.parse_string(JSON.stringify(game.session.to_dict()))
		var error := restored.from_dict(serialized)
		check(error.is_empty(), "serialized mission state passes the complete native save validator: " + error)
		check(JSON.parse_string(JSON.stringify(restored.flags)) == serialized.flags,
			"wormhole and cargo flags survive a validated in-memory JSON round trip")
		var malformed: Dictionary = serialized.duplicate(true)
		malformed.flags.unsaleable_cargo = {"131": 1}
		check(not restored.from_dict(malformed).is_empty(), "non-boolean cargo protection is rejected before modifying a session")
		game.campaign.advance()
		check(game.session.flags.get("wormhole_station", 0) == -1 and game.session.flags.get("wormhole_system", 0) == -1,
			"the next supplied progression clears both wormhole coordinates")
		game.campaign.advance()
		game.campaign._station_events(10)
		check(game.session.cargo_count(131) == 0, "original delivery station removes the alien remains")
		check(game.can_sell_cargo(131), "delivered remains do not leave a stale inventory lock")
		# Partial capacity keeps the untransferred units available for later.
		game.session.cargo.clear()
		game.session.add_cargo(122, game.session.cargo_free() - 1)
		space._drop(Vector3.ZERO, 131, 3, "box")
		var partial: Body = space.bodies.back()
		var collected: int = int(space.stats.get("collected", 0))
		space._collect(partial)
		check(partial.alive and int(partial.cargo[1]) == 2 and game.session.cargo_count(131) == 1
			and int(space.stats.get("collected", 0)) == collected + 1, "partial salvage preserves the remaining two units and counts only the accepted one")
		space.dispose()
		check(app.save_attempts.is_empty(), "salvage fixtures never produce campaign saves")
	app.queue_free()
	await process_frame
	await process_frame
	print("VOID SALVAGE: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
