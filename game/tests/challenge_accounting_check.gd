extends SceneTree
## Synthetic in-memory boundaries only: never produce earned campaign saves.
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
func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		check(false, "supplied content installed")
	else:
		var game := Game.new(app.library, app.catalogue)
		game.new_game()
		var space := Space.new(game)
		space.player = Body.new()
		space.player.kind = Body.Kind.PLAYER
		space.bodies.append(space.player)
		var rival := Body.new()
		rival.ai.rival = true
		space.bodies.append(rival)
		for shooter in [space.player, rival]:
			space._drop(Vector3(0, 0, 5000), 133, 2, "box")
			var box: Body = space.bodies.back()
			var before: int = game.session.stat("kills")
			var flight_kills: int = space.kills
			var rival_kills: int = int(space.stats.get("rival_kills", 0))
			var living_boxes: int = space.bodies.filter(func(b): return b.kind == Body.Kind.LOOT and b.alive).size()
			space._impact({"weapon": {"kind": "gun", "damage": 20, "emp": 0}, "owner": shooter, "pos": box.pos}, box)
			check(not box.alive, "ordinary projectile can destroy floating cargo")
			check(game.session.stat("kills") == before and space.kills == flight_kills
				and int(space.stats.get("rival_kills", 0)) == rival_kills,
				"floating cargo never awards player or rival a ship kill")
			check(space.bodies.filter(func(b): return b.kind == Body.Kind.LOOT and b.alive).size() == living_boxes - 1,
				"destroyed floating cargo cannot respawn its own payload")
		space.dispose()
		for player_count in [3, 4, 7]:
			var match_game := Game.new(app.library, app.catalogue)
			match_game.new_game()
			match_game.session.station_id = 27
			match_game.session.system_index = 5
			match_game.session.story_step = 35
			match_game.campaign.advance()
			var match_space := Space.new(match_game)
			match_space.build()
			var story = match_space.story
			check(story != null and story.cast.size() == 8 and story.step == 36,
				"supplied B'akka contest builds exactly one rival and seven pirates")
			if story == null:
				match_space.dispose()
				continue
			var opponent: Body = story.cast[0]
			check(opponent.friendly and not opponent.hostile and opponent.faction == 1
				and opponent.hull == 9999999 and opponent.ai.route == story.CHALLENGE_ROUTE,
				"source rival has friendly allegiance, Vossk hull and the original four-point route")
			check(story.cast.slice(1).all(func(b): return b.faction == 8 and b.alive and b.hostile),
				"all seven genuine contest targets are live hostile pirates")
			for i in range(1, 8):
				var shooter: Body = match_space.player if i <= player_count else opponent
				match_space._harm(story.cast[i], 10000.0, 0.0, shooter)
			check(match_space.kills == player_count and int(match_space.stats.get("rival_kills", 0)) == 7 - player_count,
				"native damage credits each pirate to its actual shooter")
			story._check_objectives()
			check(not story.complete and not story.failed and not bool(match_game.session.story_mission.get("done", false)),
				"contest result waits for the original completed-death boundary")
			for b in story.cast.slice(1): b.dead_timer = 0.0
			story._check_objectives()
			check(story.complete and story.failed == (player_count <= 3)
				and bool(match_game.session.story_mission.get("done", false)) == (player_count >= 4),
				"settled %d-%d contest resolves the original strict majority" % [player_count, 7 - player_count])
			match_space.dispose()
		check(app.save_attempts.is_empty(), "accounting and contest fixtures never write player or earned saves")
	app.queue_free()
	await process_frame
	await process_frame
	print("CHALLENGE ACCOUNTING: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
