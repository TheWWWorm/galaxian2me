extends SceneTree
## Synthetic transaction boundaries only; never used as earned save inputs.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Fitting := preload("res://src/screens/station/ship_panel.gd")
class StationContext extends RefCounted:
	var app
	var game
	func notify(_message: String) -> void: pass
var checks := 0
var failures := 0
func _init() -> void:
	run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	print("PASS: " if ok else "FAIL: ", label)
	if not ok: failures += 1
func payload(game) -> Dictionary:
	return JSON.parse_string(JSON.stringify(game.session.to_dict()))
func fixture(app):
	var game := Game.new(app.library, app.catalogue)
	game.new_game()
	game.session.story_step = 33
	game.session.ship = {"index": 0, "faction": 0, "hull": 95}
	game.session.equipment = [[], [], [], []]
	game.session.fit_slots()
	game.session.cargo = {}
	game.session.story_mission = {"station": 10, "kind": 8, "reward": 0, "item": 164, "amount": 50}
	return game
func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		check(false, "supplied content installed")
	else:
		var game = fixture(app)
		var s = game.session
		check(s.ship_stats().cargo_capacity == 25, "starter capacity uses supplied hull data")
		s.cargo = {"122": 25}
		check(game.departure_error().is_empty(), "exact capacity permits departure at a non-mission station")
		s.add_cargo(122, 1)
		var before := payload(game)
		check(game.departure_error() == app.library.text(84), "over-capacity departure returns original warning before station-specific rules")
		check(payload(game) == before, "overload guard never deletes cargo or mutates progress")
		s.cargo = {"64": 2, "122": 20}
		check(game.mount(64, 0).is_empty() and s.cargo_count(64) == 1 and s.ship_stats().cargo_capacity == 31,
			"one real 25-percent module enlarges 25t hold with original integer rounding")
		before = payload(game)
		check(game.mount(64, 0).is_empty(), "replacing an identical non-ammunition module is permitted")
		check(payload(game) == before and int(s.equipment[3][0].count) == 1,
			"same-slot compressor replacement returns the old unit and creates no hidden stack")
		check(game.mount(64, 1).is_empty() and s.cargo_count(64) == 0 and s.ship_stats().cargo_capacity == 37,
			"a second physical slot adds a second compressor percentage")
		s.add_cargo(122, 15)
		check(game.departure_error().is_empty(), "two compressors legitimately hold 35 units")
		check(game.demount(3, 0).is_empty() and s.cargo_used() == 36 and s.ship_stats().cargo_capacity == 31,
			"removing compression keeps every real item even when docked hold becomes overloaded")
		check(game.departure_error() == app.library.text(84), "removing compression cannot bypass departure capacity")
		check(game.mount(64, 0).is_empty() and s.cargo_used() == 35 and game.departure_error().is_empty(),
			"refitting the owned module resolves overload without deletion or free capacity")
		s.cargo = {"35": 7}
		check(game.mount(35, 0).is_empty() and int(s.equipment[1][0].count) == 7 and s.cargo_count(35) == 0,
			"secondary ammunition still fits as a complete finite stack")
		s.add_cargo(35, 2)
		check(game.mount(35, 0).is_empty() and int(s.equipment[1][0].count) == 9, "secondary top-up conserves ammunition")
		s.cargo = {"0": 2}
		check(game.mount(0, 0).is_empty(), "primary fitting consumes one physical item")
		before = payload(game)
		check(game.mount(0, 0).is_empty() and payload(game) == before, "identical primary replacement cannot hide multiple weapons in one slot")
		game = fixture(app)
		s = game.session
		s.credits = 40000
		s.cargo = {"122": 19}
		s.equipment[0][0] = {"id": 8, "count": 1}
		s.equipment[1][0] = {"id": 35, "count": 7}
		s.equipment[3] = [{"id": 51, "count": 1}, {"id": 71, "count": 1}, {"id": 56, "count": 1}]
		var offer := {"index": 3, "faction": 0, "price": game.market.ship_price(3, s.station_id)}
		before = payload(game)
		check(not game.buy_ship(offer).is_empty() and payload(game) == before, "absent dealer offer cannot fabricate stock or spend credits")
		s.market_for(s.station_id).ships = [offer]
		var forged := offer.duplicate(true)
		forged.price = 1
		before = payload(game)
		check(not game.buy_ship(forged).is_empty() and payload(game) == before, "modified asking price is rejected atomically")
		s.flags.passengers = 1
		before = payload(game)
		check(game.buy_ship(offer) == app.library.text(161) and payload(game) == before, "original passenger guard prevents exchanging an occupied ship")
		s.flags.erase("passengers")
		s.credits = 0
		before = payload(game)
		check(not game.buy_ship(offer).is_empty() and payload(game) == before, "unaffordable real offer leaves ship, shelves and inventory unchanged")
		s.credits = 40000
		var expected_money: int = s.credits + game.ship_value() - int(offer.price)
		var context := StationContext.new()
		context.app = app
		context.game = game
		var panel := Fitting.new()
		panel.station = context
		root.add_child(panel)
		check(panel.ship_frame.title == app.catalogue.ship_name(0), "open fitting panel initially labels the actual old hull")
		check(game.buy_ship(offer).is_empty(), "current affordable offer permits a real trade-in")
		check(panel.ship_frame.title == app.catalogue.ship_name(3), "dealer transaction refreshes the already-open fitting heading")
		check(s.credits == expected_money and int(s.ship.index) == 3 and s.ship_stats().cargo_capacity == 55,
			"dealer charges exact asking price less original hull trade-in")
		check(s.cargo_count(122) == 19 and s.cargo_count(8) == 1 and s.cargo_count(35) == 7
			and s.cargo_count(51) == 1 and s.cargo_count(71) == 1 and s.cargo_count(56) == 1
			and s.equipped_items().is_empty(), "ship exchange moves all actual equipment and ammunition into cargo")
		check(game.dealer().size() == 1 and int(game.dealer()[0].index) == 0, "old hull replaces purchased hull on the actual dealer shelf")
		before = payload(game)
		check(not game.buy_ship(offer).is_empty() and payload(game) == before, "stale buy button cannot repeat completed exchange")
		var decoded := payload(game)
		check(s.from_dict(decoded).is_empty() and payload(game) == decoded, "JSON reload preserves traded hull, capacity, exact credits and cargo")
		panel.queue_free()
		await process_frame
		check(app.save_attempts.is_empty(), "synthetic capacity fixtures write no saves")
	app.queue_free()
	await process_frame
	await process_frame
	print("CARGO CAPACITY: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
