extends SceneTree
## Explicit MEMORY-ONLY purchase-contract boundaries. Added goods/shelf entries
## below are labelled fixtures, never live gameplay or accepted disk saves.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
const Body := preload("res://src/flight/body.gd")
const Pickup := preload("res://tests/support/cargo_pickup_observer.gd")
const Observation := preload("res://tests/support/simulation_snapshot.gd")
class BoundarySpace extends Space:
	func _store_ship_state() -> void: pass
const INPUT := "res://../../local/checks/earned-drive-station-rendered-a-20260928/earned-drive-station45.json"
const INPUT_SHA := "5362f90336eddadf19ba0896d55458ae17e3d91ce7775ece515f82ff4e54ea0c"
var app
var header := {}
var checks := 0
var failures := 0

func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)
func frames(count: int) -> void:
	for i in count: await process_frame
func normalized(value): return JSON.parse_string(JSON.stringify(value))
func labels(node: Node) -> String:
	var result: String = node.text + "\n" if node is Label else ""
	for child in node.get_children(): result += labels(child)
	return result
func state(game) -> Dictionary: return normalized(game.session.to_dict())
func fixture():
	var game := Game.new(app.library, app.catalogue)
	check(game.session.from_dict(header).is_empty(), "memory fixture reads the unchanged earned native schema")
	return game
func paid_state(before: Dictionary) -> Dictionary:
	var expected := before.duplicate(true)
	var order: Dictionary = expected.job
	var key := str(int(order.item))
	expected.cargo[key] = int(expected.cargo[key]) - int(order.count)
	if int(expected.cargo[key]) == 0: expected.cargo.erase(key)
	expected.credits = int(expected.credits) + int(order.reward)
	expected.stats.jobs = int(expected.stats.jobs) + 1
	expected.job = {}
	return normalized(expected)

func run() -> void:
	check(FileAccess.get_sha256(INPUT) == INPUT_SHA, "boundary input is the immutable earned station checkpoint")
	if failures > 0: quit(2); return
	header = JSON.parse_string(FileAccess.get_file_as_string(INPUT))
	app = Host.new()
	root.add_child(app)
	await frames(2)
	check(app.activate(str(header.content)), "the fixture uses the actual supplied content catalogue")
	if failures > 0: app.queue_free(); await frames(2); quit(2); return
	var game = fixture()
	var before := state(game)
	var offer: Dictionary = game.lounge()[0].job.duplicate(true)
	check(int(offer.kind) == 8 and int(offer.item) == 149 and int(offer.count) == 6
		and int(offer.reward) == 6350 and int(offer.station) == 96, "the real retained buyer has the source purchase terms")
	check(game.accept_job(0).is_empty(), "purchase order can be accepted without owning its goods")
	var accepted := state(game)
	var expected := before.duplicate(true)
	expected.job = offer
	expected.markets[0].lounge[0].erase("job")
	expected.markets[0].lounge[0].kind = 1
	expected.markets[0].lounge[0].speech = app.library.text(498)
	check(accepted == normalized(expected), "acceptance changes only the actual job and its consumed lounge offer")
	game.settle_job(96)
	check(state(game) == accepted and game.pending_dialogue.is_empty(), "zero goods cannot earn a payment or completion")
	game.session.add_cargo(149, 5) # Declared partial-cargo memory fixture.
	before = state(game)
	game.settle_job(96)
	check(state(game) == before, "five of six goods are not partially consumed or paid")
	game.session.add_cargo(149, 2) # Declared surplus boundary: seven goods.
	before = state(game)
	game.settle_job(56)
	check(state(game) == before, "even a complete order is not delivered to the wrong station")
	game.settle_job(96)
	check(state(game) == paid_state(before), "correct station consumes exactly six, pays exactly 6350 and counts one job")
	check(game.session.cargo_count(149) == 1 and game.pending_dialogue.size() == 1,
		"surplus cargo remains and exactly one client debrief is queued")
	var settled := state(game)
	for i in 3: game.settle_job(96)
	check(state(game) == settled and game.pending_dialogue.size() == 1,
		"repeated settlement cannot consume another unit or duplicate the reward")
	# The fixture predates the original's sign on the second standing axis;
	# loading it turns that axis round.
	check(settled.stats.goods_conveyed == header.stats.goods_conveyed
		and settled.reputation == normalized([int(header.reputation[0]), -int(header.reputation[1])]) and settled.blueprints == header.blueprints,
		"purchase delivery does not invent courier statistics, reputation or production")
	game = fixture()
	game.accept_job(0)
	game.session.add_cargo(149, 6) # Declared exact-cargo memory fixture.
	before = state(game)
	game.settle_job(96)
	check(state(game) == paid_state(before) and not state(game).cargo.has("149"),
		"an exact delivery removes the exhausted cargo entry")
	game = fixture()
	game.accept_job(0)
	game.session.add_cargo(149, 6) # Declared cancellation fixture.
	before = state(game)
	game.cancel_job()
	expected = before.duplicate(true); expected.job = {}
	game.settle_job(96)
	check(state(game) == expected, "abandoning a purchase keeps owned goods and pays nothing")
	await check_station_boundaries()
	check_pickup_boundary()
	var cat = app.catalogue
	var stations := []
	for id in cat.system(17).stations: stations.append(cat.station(int(id)))
	print("BUYER STATIC CATALOGUE ", JSON.stringify({"item": cat.item(149), "name": cat.item_name(149),
		"home_system": cat.system(17), "stations": stations}))
	check(app.save_attempts.is_empty() and app.disk_saves.is_empty(), "all boundary fixtures perform zero save attempts")
	check(FileAccess.get_sha256(INPUT) == INPUT_SHA, "boundary fixtures never modify the earned input")
	app.queue_free(); await frames(3)
	print("BUYER ORDER: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)

func show_fixture(game) -> void:
	app.game = game
	app.show_station()
	await frames(3)

func check_station_boundaries() -> void:
	var game = fixture()
	game.session.add_cargo(149, 6) # Declared already-carried UI boundary.
	await show_fixture(game)
	game.accept_job(0) # Same changed signal as the native lounge Yes callback.
	var accepted := state(game)
	await frames(4)
	check(state(game) == paid_state(accepted), "accepting an already-carried purchase settles while still docked")
	check(app.screen.conversation != null, "in-station purchase completion presents the real client debrief")
	var once := state(game)
	game.changed.emit()
	await frames(3)
	check(state(game) == once, "another station refresh cannot repeat the purchase payment")
	app.show_title(); await frames(3)

	game = fixture()
	game.accept_job(0)
	game.session.add_cargo(149, 5) # Declared buy-the-final-unit fixture.
	game.session.market_for(96).items.append({"id": 149, "count": 1, "price": 250})
	await show_fixture(game)
	check(game.session.cargo_count(149) == 5 and not game.session.job.is_empty(),
		"opening a partial purchase at its station does not pay early")
	app.screen.menu.get_child(3).pressed.emit()
	await frames(2)
	check(labels(app.screen.current_panel).contains("6 × " + app.catalogue.item_name(149)),
		"Missions retains the actual requested quantity and commodity after acceptance")
	check(game.buy(149, 1).is_empty(), "the final-unit fixture pays finite credits to its explicit memory shelf")
	var purchased := state(game)
	await frames(4)
	check(state(game) == paid_state(purchased), "buying the final unit at the client station settles without another flight")
	check(app.screen.conversation != null, "final-unit purchase displays a client debrief after shop callbacks finish")
	app.show_title(); await frames(3)

	game = fixture()
	game.accept_job(0)
	game.session.add_cargo(149, 6) # Declared legacy-ready load fixture.
	var idle := state(game)
	await show_fixture(game)
	check(state(game) == idle and app.screen.conversation == null,
		"merely showing a loaded station never replays a reward or rewrites its save")
	app.show_title(); await frames(3)

	game = fixture()
	game.session.add_cargo(149, 6) # Declared retired-screen callback boundary.
	await show_fixture(game)
	game.accept_job(0)
	accepted = state(game)
	app.show_title() # Retire the station before its deferred callback executes.
	await frames(4)
	check(state(game) == accepted, "a retired station callback cannot settle a job in a replacement screen")

func check_pickup_boundary() -> void:
	var game = fixture()
	game.accept_job(0)
	game.session.add_cargo(149, 6) # Declared physical-docking observer fixture.
	var space := BoundarySpace.new(game)
	space.player = Body.new()
	space.station = Body.new()
	space.station.station_id = 96
	var observer := Pickup.new()
	observer.begin_world(space)
	observer.observe(space)
	check(observer.errors.is_empty(), "active observer starts with the actual carried purchase cargo")
	space.docking = Space.DOCKING_TIME
	space._fly_player(0.016, 16, {}) # Native terminal boundary, no save or live run.
	check(space.completed_flight, "native docking marks the world retired before station settlement")
	game.settle_job(96) # FlightScreen's earlier event listener settles first.
	var retired := Observation.capture(space)
	observer.observe(space) # Later listener must not classify delivery as salvage.
	check(observer.errors.is_empty() and observer.totals.is_empty() and observer.events.is_empty(),
		"retired pickup observer excludes source purchase settlement from flight inventory accounting")
	check(Observation.capture(space) == retired, "retired-world observation cannot mutate the game or its terminal flags")
	game = fixture()
	space = BoundarySpace.new(game)
	space.player = Body.new()
	observer = Pickup.new(); observer.begin_world(space)
	game.session.add_cargo(149, 1) # Deliberately unexplained ACTIVE-flight gain.
	observer.observe(space)
	check(not observer.errors.is_empty(), "active-flight cargo grants still fail the physical-payload observer")
	observer = Pickup.new(); observer.begin_world(space)
	game.session.add_cargo(149, -1) # Deliberately unexplained ACTIVE-flight debit.
	observer.observe(space)
	check(observer.errors.has("original cargo decreased: 149"), "active-flight unexplained cargo loss is still rejected")
