extends SceneTree
## Explicit in-memory EMP mission fixtures, never earned continuation saves.
## No original data, player files, settings or save files are written.
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
		# Synthetic equipment-step fixture; no save is loaded or produced.
		game.session.story_step = 19
		game.campaign.advance()
		var station_id := int(game.session.story_mission.station)
		game.arrive(station_id)
		game.campaign.on_dock(station_id)
		var entry: Dictionary = game._shelf_entry(41)
		check(not entry.is_empty() and int(entry.count) == 10 and int(entry.price) == 0,
			"equipment station supplies the original ten free EMP bombs")
		check(game.session.story_step == 20 and not game.campaign.check(true, station_id),
			"equipment mission cannot conclude without fitted EMP equipment")
		var guard: bool = game.has_method("departure_error")
		check(guard, "native departure guard exists for the supplied EMP mission")
		if guard: check(game.departure_error() == app.library.text(260), "step twenty departure explains the missing mission equipment")
		check(game.buy(41, 10).is_empty() and game.session.cargo_count(41) == 10,
			"free bomb stack transfers through ordinary trading")
		check(not game.campaign.check(true, station_id), "carried bombs alone do not satisfy the equipment goal")
		var shelf_after: Array = game.shelf().duplicate(true)
		game.resume()
		check(game.shelf() == shelf_after and game.session.cargo_count(41) == 10,
			"resuming equipment step does not replenish the acquired free stack")
		check(game.mount(41, 0).is_empty(), "ordinary fitting mounts the secondary stack")
		check(game.campaign.check(true, station_id) and not game.campaign.check(false, station_id, 20000),
			"required equipment type completes only while docked")
		game.campaign.conclude()
		check(game.session.story_step == 21, "fitted mission transitions to the supplied encounter")
		if guard:
			check(game.departure_error().is_empty(), "fitted required bombs allow the encounter departure")
			game.demount(1, 0)
			check(game.departure_error() == app.library.text(260), "demounting the required bombs blocks a stranded encounter")
			game.mount(41, 0)
		for i in [260, 1018, 1019, 1020]: print("SUPPLIED TEXT ", i, " ", app.library.text(i))
		var space := Space.new(game)
		space.build()
		var story = space.story
		check(story != null and story.cast.size() == 3, "EMP encounter creates the original named target and two companions")
		var lead = story.cast[0]
		check(lead.name == app.library.text(833), "encounter target uses the supplied character name")
		check(not story._triggered(0), "contact radio does not start while the target is still waiting far away")
		var start: Vector3 = lead.pos
		AI.step(space, lead, 1.0 / 60.0, 16)
		check(lead.pos == start, "original waiting encounter does not drift away before contact")
		# Controlled contact geometry is a unit fixture, not a campaign input.
		space.player.pos = lead.pos + Vector3(0, 0, -40000)
		AI.step(space, lead, 1.0 / 60.0, 16)
		check(story._triggered(0), "approaching the waiting target enables the imported contact trigger")
		check(not story._triggered(2), "completion radio cannot start before the named target is EMP-disabled")
		var hull: int = lead.hull
		space._harm(lead, 0, lead.emp_max, space.player)
		check(lead.alive and lead.hull == hull and lead.disabled, "native EMP damage disables rather than destroys the target")
		check(story._triggered(2), "native EMP-disabled state satisfies imported radio trigger twenty-one")
		# A separate losing condition: killing the named target is not success.
		space._harm(lead, lead.hull + lead.armor + lead.shield, 0, space.player)
		story._check_objectives()
		check(story.failed and not story.complete and not bool(game.session.story_mission.get("done", false)),
			"destroying the required live target fails the encounter instead of advancing")
		space.dispose()
		check(app.save_attempts.is_empty(), "EMP regression fixtures never produce campaign saves")
	app.queue_free()
	await process_frame
	await process_frame
	print("EMP STORY: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
