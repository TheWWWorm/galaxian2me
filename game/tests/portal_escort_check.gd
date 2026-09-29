extends SceneTree
## Explicit synthetic, memory-only source contracts, never earned checkpoints.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
const Story := preload("res://src/flight/story.gd")
const AI := preload("res://src/flight/ai.gd")
var checks := 0
var failures := 0
var fixtures: Array = []

func _init() -> void:
	run.call_deferred()

func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)

func fixture(app, step: int, station: int, in_void := false):
	var game := Game.new(app.library, app.catalogue)
	game.new_game()
	game.session.story_step = step
	game.session.stats["rank"] = 3
	game.session.story_mission = game.campaign.mission_from(game.campaign.step_record(step).missions[0])
	game.session.station_id = station
	game.session.system_index = app.catalogue.system_of_station(station)
	game.session.in_void = in_void
	game.session.flags["wormhole_station"] = 91
	game.session.flags["wormhole_system"] = 18
	if step == 41: game.session.flags["final_escort_hull"] = 317
	var space := Space.new(game)
	space.build()
	fixtures.append(space)
	return space

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		check(false, "supplied content is installed")
	else:
		var away = fixture(app, 40, 30)
		check(away.story == null, "kind25 is not a wildcard at Nehma")
		var wrong_world = fixture(app, 40, 91, true)
		check(wrong_world.story == null, "the portal escort belongs outside Void space")
		var space = fixture(app, 40, 91)
		check(space.story != null and space.story.active(), "supplied kind25 activates at retained portal station despite mission address -1")
		# Inspect the old scene too when activation itself is the first RED gap.
		# This explicit fixture call is not a playable run and writes no save.
		if space.story == null:
			space.story = Story.new(space)
			space.story._scene_final()
		var story = space.story
		check(story.cast.size() == 9, "outside scene has one freighter, four wingmen and four Voids")
		if story.cast.size() == 9:
			var escort = story.cast[0]
			check(escort.ship_index == 13 and escort.hull == 1215 and escort.hull_max == 1215,
				"supplied hull13 uses 1200+5*rank, not multiplied generic freighter health")
			check(escort.friendly and not escort.hostile and bool(escort.ai.get("fixed_friendly", false))
				and escort.cargo.is_empty(), "fixed-friendly final freighter carries no generated loot")
			check(escort.name == app.library.text(826) and story.cast[2].name == app.library.text(827),
				"freighter and named wingman use their supplied strings")
			check(escort.pos == Vector3(-20000, -3000, 65000)
				and space.wormhole.pos == Vector3(-20000, -3000, 200000), "escort and portal occupy the original route endpoints")
			var route: Array = [Vector3(-20000, -3000, 65000), Vector3(-20000, -3000, 200000)]
			var routed_wingmen := true
			for b in story.cast.slice(1, 5):
				routed_wingmen = routed_wingmen and b.friendly and not b.hostile and b.ai.get("route", []) == route and b.ai.mode != "escort"
			check(routed_wingmen,
				"wingmen patrol the supplied route, not a formation around the player")
			check(story.objective.is_empty(), "warning and departure radio never complete the outside escort")
			var start: Vector3 = escort.pos
			AI.step(space, escort, 0.016, 16)
			check(escort.pos == start + Vector3(0, 0, 16), "moving story freighter advances one source unit per millisecond along +z")
			escort.disabled = true
			start = escort.pos
			AI.step(space, escort, 0.016, 16)
			check(escort.pos == start, "EMP pauses the final freighter rather than applying ordinary drift")
			escort.disabled = false
			space.player.pos = space.wormhole.pos
			space._collisions()
			check(not space.player.alive and not space.portal_crossed and space.game.session.story_step == 40,
				"physical portal entry before the freighter departs is fatal, not a campaign shortcut")
		var safe = fixture(app, 40, 91)
		if safe.story != null and safe.story.cast.size() == 9:
			var guide = safe.story.cast[0]
			safe._harm(guide, 17, 0, safe.player)
			var remaining: int = guide.hull
			check(remaining == 1198 and guide.friendly and not guide.hostile, "ordinary damage applies without breaking fixed allegiance")
			# This boundary pose is only a no-save fixture, not earned travel.
			guide.pos.z = 500001
			safe.story.stage = 2
			safe.story.step_scene(16)
			check(guide.alive and not guide.visible and guide.pos == Vector3(0, 0, -200000),
				"portal choreography hides the living freighter after its source departure threshold")
			check(not bool(safe.game.session.story_mission.get("done", false)), "freighter departure alone does not advance the player")
			check(safe.story.has_method("finish_portal_escort"), "native crossing transaction is available")
			if safe.story.has_method("finish_portal_escort"):
				check(not safe.story.finish_portal_escort(), "transaction refuses a non-physical crossing")
				safe.player.pos = safe.wormhole.pos
				safe._collisions()
				check(safe.portal_crossed and safe.player.alive, "following the departed freighter crosses the actual portal safely")
				check(safe.story.finish_portal_escort() and safe.game.session.story_step == 41
					and int(safe.game.session.flags.get("final_escort_hull", -1)) == remaining,
					"physical crossing advances once and retains actual damaged escort health")
				check(not safe.story.finish_portal_escort(), "repeated crossing settlement cannot advance twice")
			guide.alive = false
			guide.dead_timer = 1.0
			check(not safe.story._met(safe.story.failure), "escort failure waits for the supplied settled death")
			guide.dead_timer = 0.0
			check(safe.story._met(safe.story.failure), "settled escort loss satisfies failure")
		var finale = fixture(app, 41, 91, true)
		check(finale.story != null and finale.story.cast.size() == 5, "Void finale has one carried freighter and four enemies, no extra wingmen")
		if finale.story != null and not finale.story.cast.is_empty():
			var guide = finale.story.cast[0]
			check(guide.ship_index == 13 and guide.hull == 317 and guide.pos == Vector3(0, 0, -200000),
				"finale restores only the actually carried NPC health at the original start")
			check(finale.player.pos == Vector3(3000, 2000, -220000), "finale starts the player behind the freighter")
			check(not finale.story._met(finale.story.objective), "health warning cannot win the finale")
			guide.pos.z = -10000
			finale.story.step_scene(16)
			check(not finale.story.complete, "delivery threshold is strict, not inclusive")
			guide.pos.z = -9999
			finale.story.step_scene(16)
			check(finale.story.complete and guide.speed == 0 and guide.alive
				and finale.wormhole.pos == Vector3(5000, -40000, 10000), "actual mothership arrival stops the freighter and opens the supplied exit position")
		var premature = fixture(app, 41, 91, true)
		premature.player.pos = premature.wormhole.pos
		premature._collisions()
		check(not premature.player.alive and not premature.portal_crossed, "escaping the unfinished Void finale is fatal")
		check(app.save_attempts.is_empty(), "all source-contract fixtures remain memory-only with zero save attempts")
	for space in fixtures: space.dispose()
	fixtures.clear()
	app.queue_free()
	await process_frame
	await process_frame
	print("PORTAL ESCORT: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
