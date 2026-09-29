extends SceneTree
## Explicit in-memory Alioth/escort fixtures, NOT earned campaign evidence.
## No player saves, settings, original data or continuation outputs are written.
const TestApp := preload("res://tests/support/isolated_app.gd")
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
	var app := TestApp.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		check(false, "supplied content installed")
	else:
		var game := Game.new(app.library, app.catalogue)
		game.new_game()
		# These are synthetic scene setup values, never exported as a save.
		game.session.story_step = 16
		var missions: Array = game.campaign.step_record(16).get("missions", [])
		game.session.story_mission = game.campaign.mission_from(missions[0])
		game.session.station_id = int(game.session.story_mission.station)
		game.session.system_index = app.catalogue.system_of_station(game.session.station_id)
		var space := Space.new(game)
		space.build()
		var cast: Array = space.story.cast
		check(cast.size() == 7, "Alioth builds the original four enemies and three allies")
		var hulls := true
		var offsets := true
		for i in range(4, 7):
			var ally = cast[i]
			hulls = hulls and ally.hull == 600 and ally.hull_max == 600
			var offset: Vector3 = ally.pos - space.player.pos
			offsets = offsets and offset.x >= -2000 and offset.x < 2000 and offset.y >= -1700 and offset.y < 1700 and offset.z >= 0 and offset.z < 4000
		check(hulls, "all three Alioth allies retain the original scripted 600 hull")
		check(offsets, "Alioth allies start inside the original formation ranges")
		var ally = cast[4]
		var enemy = cast[0]
		# A controlled combat geometry with one eligible target exercises normal
		# AI stepping, not a direct damage/completion operation.
		for i in range(1, 4): cast[i].alive = false
		ally.pos = Vector3(0, 0, 60000)
		ally.basis = Basis.IDENTITY
		enemy.pos = Vector3(0, 0, 70000)
		space.player.pos = Vector3(0, 0, 59000)
		ally.ai.timer = AI.RETARGET_MS
		var selected := false
		var fired := false
		for tick in 600:
			AI.step(space, ally, 1.0 / 60.0, 16)
			selected = selected or ally.ai.get("target") == enemy
			for projectile in space.projectiles:
				if projectile.owner == ally: fired = true
			if fired: break
		check(selected, "escort acquires an actual nearby hostile through AI stepping")
		check(fired, "escort fires native projectiles instead of only following the player")
		# Explicit failure fixtures: real combat damage still applies, but the
		# original b(true) allegiance override outlives accidental player fire.
		var health: int = ally.hull
		space._harm(ally, 1, 0, space.player)
		check(ally.hull == health - 1, "scripted allegiance does not make Alioth escorts invulnerable")
		check(ally.friendly and not ally.hostile and ally.ai.get("target") != space.player,
			"Alioth's fixed ally does not retaliate against the player")
		space._harm(enemy, 1, 0, space.player)
		check(enemy.hostile and enemy.ai.get("target") == space.player,
			"ordinary enemy retaliation remains active")
		# The original step-18 ship setter changes its faction/livery to Terran.
		# An explicit pre-transition fixture checks that only that field changes.
		game.session.story_step = 17
		game.session.ship.faction = 8
		var ship: Dictionary = game.session.ship.duplicate(true)
		var equipment: Array = game.session.equipment.duplicate(true)
		var cargo: Dictionary = game.session.cargo.duplicate(true)
		var credits: int = game.session.credits
		game.campaign.advance()
		check(game.session.ship.faction == 0, "post-Alioth transition applies the original Terran ship livery")
		ship.faction = 0
		check(game.session.ship == ship and game.session.equipment == equipment and game.session.cargo == cargo and game.session.credits == credits,
			"livery transition does not replace the ship, equipment, cargo or credits")
		game.resume()
		check(game.session.ship == ship, "resuming the arrival step retains the changed livery")
		check(app.save_attempts.is_empty(), "isolated scene and AI fixtures never write saves")
		space.dispose()
	app.queue_free()
	await process_frame
	await process_frame
	print("ALIOTH SCENE: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
