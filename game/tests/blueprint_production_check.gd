extends SceneTree
## Memory-only production boundaries. No fixture ever becomes an earned save.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Station := preload("res://src/screens/station_screen.gd")
const SHA := "83539530b0bd544ef2993020142b79330594a972c9466cf18917b576af2a0a52"
var app
var header := {}
var checks := 0
var failures := 0
func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)
func fixture():
	var game := Game.new(app.library, app.catalogue)
	check(game.session.from_dict(header).is_empty(), "unchanged native cleanup schema loads in memory")
	return game
func normalized(game) -> Dictionary:
	return JSON.parse_string(JSON.stringify(game.session.to_dict()))
func run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 1 or FileAccess.get_sha256(args[0]) != SHA:
		push_error("Provide the exact native cleanup input for memory-only production checks.")
		quit(2)
		return
	header = JSON.parse_string(FileAccess.get_file_as_string(args[0]))
	app = Host.new()
	root.add_child(app)
	await process_frame
	check(app.activate(str(header.content)), "actual supplied content is installed")
	var game = fixture()
	var station := Station.new()
	station.app = app
	station.game = game
	var tabs := station._hangar_panel()
	var found := false
	for child in tabs.get_children():
		if child.name == app.library.text(130): found = true
	check(found, "the actual hangar exposes owned blueprint production")
	check(game.has_method("blueprint_offer") and game.has_method("contribute_blueprint"),
		"native production transactions exist instead of saved ownership alone")
	tabs.free()
	station.scene.free()
	station.env.free()
	station.free()
	if game.has_method("blueprint_offer"): check_transactions()
	check(app.save_attempts.is_empty(), "all blueprint boundary fixtures make zero save attempts")
	check(FileAccess.get_sha256(args[0]) == SHA, "accepted native cleanup input stays byte-identical")
	app.queue_free()
	await process_frame
	await process_frame
	print("BLUEPRINT PRODUCTION: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
func check_transactions() -> void:
	var game = fixture()
	var before := normalized(game)
	var data: Dictionary = game.workshop.details(85)
	check(data.ingredients.size() == 8 and is_equal_approx(float(data.fraction), 0.125)
		and int(data.station) == -1 and int(data.batch) == 1,
		"source Khador recipe retains fifty credited crystals, no origin and ingredient-weighted progress")
	var order: Dictionary = game.blueprint_offer(85, 127, 3)
	check(str(order.error).is_empty() and bool(order.first) and not bool(order.remote) and int(order.fee) == 0,
		"first real carried-material contribution quotes a local start without an assembly fee")
	check(normalized(game) == before, "reading recipes and quoting production cannot consume or grant anything")
	check(game.contribute_blueprint(order).is_empty(), "native transaction accepts three actually carried microchips")
	check(game.session.cargo_count(127) == 0 and game.session.cargo_used() == 25
		and game.session.credits == 45687 and int(game.session.blueprints["85"].progress["127"]) == 3
		and int(game.session.blueprints["85"].progress["164"]) == 50
		and int(game.session.blueprints["85"].cost) == 66 and int(game.session.blueprints["85"].station) == 96,
		"deposit consumes only its cargo, records origin and inventory value, and never buys it twice")
	check(is_equal_approx(float(game.workshop.details(85).fraction), 0.13),
		"progress averages each ingredient fraction rather than total tonnes")
	before = normalized(game)
	check(not game.contribute_blueprint(order).is_empty() and normalized(game) == before,
		"a reused confirmation cannot deposit material twice")
	for invalid in [[85, 127, 0], [85, 127, -1], [85, 127, 1], [85, 164, 1], [85, 100, 1], [84, 127, 1]]:
		check(not str(game.blueprint_offer(invalid[0], invalid[1], invalid[2]).error).is_empty()
			and normalized(game) == before, "invalid/unowned/exhausted material order is atomic: %s" % str(invalid))
	var reloaded = Game.new(app.library, app.catalogue)
	check(reloaded.session.from_dict(before).is_empty() and normalized(reloaded) == before,
		"modern partial production round-trips through JSON numeric values without completing anything")
	check_remote_shipping()
	check_completion()
	check_validation()

func check_remote_shipping() -> void:
	var game = fixture()
	check(game.contribute_blueprint(game.blueprint_offer(85, 127, 3)).is_empty(), "shipping fixture establishes a native local production origin")
	# Declared unit fixture: two supplied material units and another real station.
	game.session.add_cargo(127, 2)
	game.session.station_id = 95
	game.session.system_index = app.catalogue.system_of_station(95)
	game.session.credits = 19
	var before := normalized(game)
	check(not str(game.blueprint_offer(85, 127, 2).error).is_empty() and normalized(game) == before,
		"remote shipment rejects insufficient credits without losing either unit")
	game.session.credits = 20
	var order: Dictionary = game.blueprint_offer(85, 127, 2)
	check(str(order.error).is_empty() and bool(order.remote) and not bool(order.first)
		and int(order.fee) == 20 and int(order.origin) == 96,
		"source remote shipment quotes exactly ten credits per tonne to the original station")
	check(game.contribute_blueprint(order).is_empty(), "confirmed remote materials can be shipped rather than blocked by station")
	check(game.session.credits == 0 and game.session.cargo_count(127) == 0
		and int(game.session.blueprints["85"].station) == 96 and int(game.session.blueprints["85"].progress["127"]) == 5,
		"remote deposit charges exactly its fee and keeps the first origin")
	game = fixture()
	order = game.blueprint_offer(85, 127, 1)
	game.session.credits -= 1 # Explicit stale-quote boundary, not an earned purchase.
	before = normalized(game)
	check(not game.contribute_blueprint(order).is_empty() and normalized(game) == before,
		"a changed balance invalidates a pending production confirmation atomically")
	game.session.flags.unsaleable_cargo = {"127": true}
	before = normalized(game)
	check(not str(game.blueprint_offer(85, 127, 1).error).is_empty() and normalized(game) == before,
		"protected mission goods cannot be laundered into production")

func completion_fixture(product: int, origin: int, current: int):
	var game = fixture()
	var required: Dictionary = game.workshop.recipe(app.catalogue, product)
	var progress: Dictionary = required.duplicate(true)
	var last: String = required.keys().back()
	progress[last] = int(progress[last]) - 1
	game.session.blueprints[str(product)] = {"progress": progress, "cost": 100, "station": origin}
	game.session.cargo = {last: 1}
	game.session.station_id = current
	game.session.system_index = app.catalogue.system_of_station(current)
	return game

func complete_fixture(game, product: int) -> bool:
	var required: Dictionary = game.workshop.recipe(app.catalogue, product)
	var last := int(required.keys().back())
	return game.contribute_blueprint(game.blueprint_offer(product, last, 1)).is_empty()

func check_completion() -> void:
	var game = completion_fixture(85, 96, 96)
	check(complete_fixture(game, 85), "last local ingredient completes the source recipe in a declared memory fixture")
	check(game.session.cargo_count(85) == 1 and game.session.stat("goods_produced") == 1
		and int(game.session.blueprints["85"].produced) == 1,
		"equipment production grants one whole product and counts one completed batch")
	check(game.session.blueprints["85"].progress.is_empty() and int(game.session.blueprints["85"].cost) == 0
		and int(game.session.blueprints["85"].station) == -1 and game.session.equipment == header.equipment,
		"completion resets ingredients, valuation and origin without auto-fitting the product")
	check(game.session.story_step == 45 and game.session.story_mission.is_empty() and game.session.job.is_empty()
		and game.session.credits == 45687, "local production does not restart the ending or add a second material price")
	var saved := normalized(game)
	var reloaded = Game.new(app.library, app.catalogue)
	check(reloaded.session.from_dict(saved).is_empty() and normalized(reloaded) == saved,
		"completed local production persists without regranting the product")
	game = completion_fixture(85, 96, 95)
	# An earlier completed batch already waits at96; this is an explicit fixture.
	game.session.blueprints["85"].pending = {"96": 1}
	check(complete_fixture(game, 85), "remote final ingredient completes without pretending to dock at the origin")
	check(game.session.cargo_count(85) == 0 and int(game.session.blueprints["85"].pending["96"]) == 2
		and game.session.stat("goods_produced") == 1 and game.session.credits == 45677,
		"remote completion coalesces pending goods at origin and charges only one shipment tonne")
	var observations: Array = []
	game.docked.connect(func(_station): observations.append(normalized(game)))
	game.dock(95)
	check(game.session.cargo_count(85) == 0 and int(game.session.blueprints["85"].pending["96"]) == 2,
		"docking at a different station cannot collect pending products")
	game.dock(96)
	check(game.session.cargo_count(85) == 2 and not game.session.blueprints["85"].has("pending")
		and game.session.stat("goods_produced") == 1 and observations.back() == normalized(game),
		"physical origin docking collects every pending unit before the autosave signal, without recounting production")
	var received: Array = game.workshop.collect_at(96)
	check(received.is_empty() and game.session.cargo_count(85) == 2,
		"repeated collection cannot duplicate completed goods")
	var secondary := -1
	for id in app.catalogue.item_count():
		if app.catalogue.category(id) == app.catalogue.Category.SECONDARY and app.catalogue.is_blueprint_product(id):
			secondary = id
			break
	check(secondary >= 0, "supplied catalogue contains a real secondary-weapon production recipe")
	if secondary >= 0:
		game = completion_fixture(secondary, 96, 96)
		var last := int(game.session.cargo.keys()[0])
		game.session.add_cargo(99 if last != 99 else 106, 59)
		check(game.session.cargo_used() == 60 and complete_fixture(game, secondary),
			"full-hold fixture can contribute its final material through the same native transaction")
		check(game.session.cargo_count(secondary) == 10 and game.session.cargo_used() == 69
			and game.session.stat("goods_produced") == 1 and not game.departure_error().is_empty(),
			"secondary production preserves the full ten-unit batch; overfilled cargo blocks departure rather than deleting goods")

func check_validation() -> void:
	var game = fixture()
	var before := normalized(game)
	var cases: Array = [
		{"progress": []}, {"progress": {"164": 50.5}}, {"progress": {"164": 51}},
		{"progress": {"999": 1}}, {"progress": {"127": -1}}, {"progress": {"127": true}},
		{"cost": -1}, {"cost": 1}, {"station": 96.5}, {"station": 999}, {"produced": 0.5},
		{"pending": []}, {"pending": {"96": 0}}, {"pending": {"96": -1}},
		{"pending": {"96": true}}, {"pending": {"999": 1}}]
	for bad in cases:
		var input: Dictionary = before.duplicate(true)
		input.blueprints["85"] = bad
		check(not game.session.from_dict(input).is_empty() and normalized(game) == before,
			"malformed production save is rejected before live state changes: %s" % JSON.stringify(bad))
	var wrong: Dictionary = before.duplicate(true)
	wrong.blueprints["100"] = {"progress": {}}
	check(not game.session.from_dict(wrong).is_empty() and normalized(game) == before,
		"a commodity without a supplied recipe cannot become an owned blueprint")
