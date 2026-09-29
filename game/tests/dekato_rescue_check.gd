extends SceneTree
## Synthetic, memory-only source-contract fixtures. Never earned saves.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
const AI := preload("res://src/flight/ai.gd")
var checks := 0
var failures := 0

func _init() -> void:
	run.call_deferred()

func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		check(false, "supplied content is installed")
	else:
		var game := Game.new(app.library, app.catalogue)
		game.new_game()
		game.session.story_step = 38
		game.session.story_mission = game.campaign.mission_from(game.campaign.step_record(38).missions[0])
		game.session.station_id = int(game.session.story_mission.station)
		game.session.system_index = app.catalogue.system_of_station(game.session.station_id)
		# Reproduce the earned player's Voskk/Midor reputation, only in this fixture.
		game.session.reputation = [-34, -97]
		var space := Space.new(game)
		space.build()
		var story = space.story
		check(story != null and story.cast.size() == 7, "Dekato has two captives and five captors")
		if story != null and story.cast.size() == 7:
			var at := Vector3(0, 10000, 50000)
			var captives: Array = story.cast.slice(0, 2)
			var captors: Array = story.cast.slice(2)
			check(captives.all(func(b): return b.faction == 2 and b.ship_index == 15 and b.friendly and not b.hostile),
				"source fixed-friendly captives override otherwise hostile reputation")
			check(captives.all(func(b): return b.ai.mode == "hold"), "source non-moving freighters are held, not patrolling")
			var captive_ranges := true
			for b in captives:
				var offset: Vector3 = b.pos - at
				captive_ranges = captive_ranges and offset.x >= -10000 and offset.x < 10000 and offset.y >= -10000 and offset.y < 10000 and offset.z >= -10000 and offset.z < 10000
			check(captive_ranges, "captives occupy the supplied half-open ten-thousand-unit scatter")
			var distinct := {}
			var captor_ranges := true
			for b in captors:
				var offset: Vector3 = b.pos - at
				captor_ranges = captor_ranges and offset.x >= -20000 and offset.x < 20000 and offset.y >= -20000 and offset.y < 20000 and offset.z >= -20000 and offset.z < 20000
				distinct[b.pos] = true
			check(captor_ranges and distinct.size() == 5, "captors retain source spawn scatter instead of occupying one point")
			check(captors.all(func(b): return b.faction == 3 and b.hostile and not b.friendly and not b.combat_active and b.ai.mode == "encounter_wait"),
				"captors begin in the original dormant encounter state")
			check(story.records.size() == 1 and story.records[0].size() == 4
				and int(story.records[0][0]) == 1146 and int(story.records[0][1]) == 21
				and int(story.records[0][2]) == 5 and int(story.records[0][3]) == 5000,
				"radio timing and speaker are supplied, not invented")
			var origin: Vector3 = captives[0].pos
			space.player.pos = at + Vector3(0, 0, 200000)
			for tick in 600:
				AI.step(space, captives[0], 0.016, 16)
				AI.step(space, captors[0], 0.016, 16)
			check(captives[0].pos == origin, "native freighter stepping leaves the captive stationary")
			space._harm(captives[0], 0, captives[0].emp_max, space.player)
			AI.step(space, captives[0], 0.016, 16)
			check(captives[0].disabled and captives[0].pos == origin, "EMP-disabled captive remains stationary rather than drifting")
			check(not captors[0].combat_active and captors[0].ai.mode == "encounter_wait", "distant player does not activate the captors")
			space.player.pos = captors[0].pos + Vector3(49999, 0, 0)
			AI.step(space, captors[0], 0.016, 16)
			check(captors[0].combat_active and captors[0].ai.mode == "patrol", "entering the native sight box activates ordinary combat")
			var before: int = captives[0].hull
			space._harm(captives[0], 1, 0, space.player)
			check(captives[0].hull == before - 1 and captives[0].friendly and not captives[0].hostile,
				"captives remain damageable without losing fixed allegiance")
			check(not story._met(story.objective) and not story._met(story.failure), "live scene cannot complete or fail")
			# Only these named synthetic fixtures assign death state; no save is written.
			for b in captors:
				b.alive = false
				b.dead_timer = 1.0
			check(not story._met(story.objective), "success waits for all five actual death animations")
			for b in captors: b.dead_timer = 0.0
			check(story._met(story.objective), "five settled captor deaths satisfy the source objective")
			captives[0].alive = false
			captives[0].dead_timer = 0.0
			check(not story._met(story.failure), "one lost captive alone does not meet the source two-loss failure")
			captives[1].alive = false
			captives[1].dead_timer = 1.0
			check(not story._met(story.failure), "failure waits for both captive death animations")
			captives[1].dead_timer = 0.0
			check(story._met(story.failure), "both settled captive deaths meet the source failure")
			story._check_objectives()
			check(story.failed and not story.complete and not bool(game.session.story_mission.get("done", false)),
				"simultaneous objective and captive loss cannot award success")
		check(app.save_attempts.is_empty(), "synthetic source-contract fixtures never write player saves")
		space.dispose()
	app.queue_free()
	await process_frame
	await process_frame
	print("DEKATO RESCUE: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
