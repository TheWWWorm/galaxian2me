extends SceneTree
## Synthetic in-memory boundary fixtures only. These are NOT earned saves,
## and never substitute for the real capacity upgrade / Void mining mission.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
var checks := 0
var failures := 0
func _init() -> void:
	run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	print("PASS: " if ok else "FAIL: ", label)
	if not ok: failures += 1
func fixture(app, crystals: int):
	var game := Game.new(app.library, app.catalogue)
	game.new_game()
	# An actual supplied large hull keeps the test payload valid on reload.
	for i in app.catalogue.ship_count():
		if int(app.catalogue.ship(i).get("cargo", 0)) >= 75:
			game.session.ship.index = i
			game.session.fit_slots()
			game.session.ship.hull = int(game.session.ship_stats().max_hull)
			break
	game.session.story_step = 32
	game.session.station_id = 10
	game.session.system_index = 6
	game.session.cargo = {"164": crystals, "131": 3, "55": 1}
	game.session.flags.wormhole_station = 91
	game.session.flags.wormhole_system = 18
	game.campaign.advance()
	return game
func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		check(false, "supplied content is installed")
	else:
		var missing = fixture(app, 49)
		check(missing.session.story_step == 33 and int(missing.session.story_mission.item) == 164
			and int(missing.session.story_mission.amount) == 50, "fixture uses the supplied crystal mission, not an invented threshold")
		missing.campaign.on_dock(10)
		check(missing.session.story_step == 33 and missing.session.cargo_count(164) == 49
			and missing.session.blueprints.is_empty(), "forty-nine crystals neither settle the mission nor grant a blueprint")
		for count in [50, 57]:
			var game = fixture(app, count)
			check(game.session.cargo_free() >= 0, "synthetic payload fits its supplied hull")
			check(not game.campaign.check(false, 10) and not game.campaign.check(true, 98),
				"fifty crystals require actual Thynome docking, not flight or a different station")
			game.campaign.on_dock(98)
			check(game.session.story_step == 33 and game.session.cargo_count(164) == count,
				"wrong-station docking leaves all crystal cargo untouched")
			var credits: int = game.session.credits
			var equipment: Array = game.session.equipment.duplicate(true)
			var markets: Array = game.session.markets.duplicate(true)
			var stats: Dictionary = game.session.stats.duplicate(true)
			game.campaign.on_dock(10)
			check(game.session.story_step == 34 and int(game.session.story_mission.kind) == 11
				and int(game.session.story_mission.station) == 30, "delivery opens the supplied Néhma continuation exactly once")
			check(game.session.cargo_count(164) == count - 50 and game.session.cargo_count(131) == 3
				and game.session.cargo_count(55) == 1, "handover consumes exactly fifty crystals and preserves excess/unrelated cargo")
			var blueprint: Dictionary = game.session.blueprints.get("85", {})
			check(blueprint.get("progress", {}) == {"164": 50} and int(blueprint.get("cost", -1)) == 0,
				"Khador grants recipe85 with fifty crystals pre-contributed at zero cost")
			check(not blueprint.has("station") and game.session.cargo_count(85) == 0
				and not bool(game.session.ship_stats().jump_drive), "blank blueprint sets no production station and grants no completed/equipped drive")
			var recipe: Dictionary = app.catalogue.item(85)
			check(recipe.ingredients.size() == 8 and recipe.amounts == [50.0, 10.0, 10.0, 10.0, 40.0, 70.0, 75.0, 40.0],
				"the seven other original recipe materials remain outstanding")
			check(game.session.credits == credits and game.session.equipment == equipment
				and game.session.markets == markets and game.session.stats == stats,
				"handover invents no money, equipment, station85 market, production or freelance statistics")
			check(game.pending_dialogue == game.campaign.dialogue(33, 1), "delivery queues only the source Khador/Carla result")
			var settled: String = JSON.stringify(game.session.to_dict())
			game.campaign.on_dock(10)
			check(JSON.stringify(game.session.to_dict()) == settled, "rechecking the settled station cannot consume or contribute crystals twice")
			var restored := Game.new(app.library, app.catalogue)
			var expected: Dictionary = JSON.parse_string(settled)
			var error := restored.session.from_dict(expected)
			check(error.is_empty(), "source-compatible handover survives save validation: " + error)
			restored.resume()
			# Compare both sides in the JSON domain: Dictionary equality treats
			# fixture ints and JSON floats differently even when values match.
			print("RELOAD PAYLOAD ", JSON.stringify({"expected_blueprints": expected.blueprints,
				"actual_blueprints": restored.session.blueprints, "expected_cargo": expected.cargo,
				"actual_cargo": restored.session.cargo, "step": restored.session.story_step}))
			check(restored.session.blueprints == expected.blueprints and restored.session.cargo == expected.cargo
				and restored.session.story_step == 34, "JSON reload retains partial blueprint and excess cargo without rerunning the reward")
		check(app.save_attempts.is_empty(), "handover fixtures never read or write player/checkpoint saves")
	app.queue_free()
	await process_frame
	await process_frame
	print("KHADOR HANDOVER: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
