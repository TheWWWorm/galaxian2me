extends SceneTree
## Synthetic, memory-only transaction boundaries. Not an earned progression
## source. Values and warning strings are read from the player's supplied JAR.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
var checks := 0
var failures := 0
var cabin := -1
var replacement := -1

func _init() -> void: run.call_deferred()

func check(ok: bool, label: String) -> void:
	checks += 1
	print("PASS: " if ok else "FAIL: ", label)
	if not ok: failures += 1

func state(game) -> Dictionary:
	return JSON.parse_string(JSON.stringify(game.session.to_dict()))

func fixture(app):
	var game := Game.new(app.library, app.catalogue)
	game.new_game()
	var s = game.session
	s.story_step = 45; s.story_mission = {}; s.job = {}
	s.ship = {"index": 5, "faction": 0, "hull": 170, "armor": 0, "shield": 0}
	s.equipment = [[], [], [], []]; s.fit_slots(); s.cargo = {}
	s.equipment[3][0] = {"id": cabin, "count": 1}
	s.equipment[3][1] = {"id": cabin, "count": 1}
	s.cargo[str(cabin)] = 2; s.cargo[str(replacement)] = 1
	s.credits = 40000
	return game

func offer(count: int, station: int) -> Dictionary:
	return {"kind": 0, "name": "Synthetic passenger client", "speech": "fixture",
		"job": {"kind": 11, "count": count, "station": station, "reward": 14650, "client": "Synthetic passenger client", "face": []}}

func run() -> void:
	var app := Host.new(); root.add_child(app); await process_frame
	if app.library == null:
		check(false, "supplied content is available")
	else:
		for id in app.catalogue.item_count():
			if app.catalogue.type(id) == app.catalogue.Type.CABIN and app.catalogue.attr(id, app.catalogue.A_CABIN) > 0 and cabin < 0: cabin = id
			if app.catalogue.type(id) == app.catalogue.Type.STEERING and replacement < 0: replacement = id
		check(cabin >= 0 and replacement >= 0, "supplied catalogue defines real cabins and replacement equipment")
		if cabin >= 0 and replacement >= 0: exercise(app)
		check(app.save_attempts.is_empty(), "synthetic passenger fixtures never write or supply earned saves")
	app.queue_free(); await process_frame; await process_frame
	print("PASSENGER CONTRACT: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)

func exercise(app) -> void:
	var game = fixture(app)
	var s = game.session
	var places: int = app.catalogue.attr(cabin, app.catalogue.A_CABIN)
	check(s.ship_stats().cabins == places * 2, "two physical cabin slots add their supplied capacity")
	var too_large := offer(places * 2 + 1, s.station_id)
	var unchanged_offer := too_large.duplicate(true)
	var before := state(game)
	check(game.bar.accept(too_large) == app.library.text(163).replace("#Q", str(places * 2 + 1)), "one passenger over fitted capacity uses the original capacity warning")
	check(state(game) == before and too_large == unchanged_offer, "rejected capacity preserves the complete session and offer")
	var decoded_offer: Dictionary = JSON.parse_string(JSON.stringify(too_large))
	check(game.bar.accept(decoded_offer) == app.library.text(163).replace("#Q", str(places * 2 + 1)),
		"JSON-loaded offer formats passenger capacity as an integer, not 7.0 people")
	check(state(game) == before, "decoded capacity rejection is also atomic")
	var exact := offer(places * 2, s.station_id)
	check(game.bar.accept(exact).is_empty(), "exact fitted capacity accepts the real passenger rule")
	check(int(s.flags.passengers) == places * 2 and int(s.job.kind) == 11 and not exact.has("job"), "acceptance records passengers and consumes the offer once")
	check(state(game).cargo == before.cargo and s.credits == int(before.credits) and state(game).stats == before.stats, "passengers do not become hold cargo or an immediate reward")
	var second := offer(1, s.station_id)
	before = state(game)
	check(game.bar.accept(second) == app.library.text(254) and state(game) == before, "an active passenger job cannot be replaced by another acceptance")
	var saved := state(game)
	check(s.from_dict(saved).is_empty() and state(game) == saved, "JSON roundtrip preserves occupied cabins and pending passenger job")
	for action in ["demount", "sell", "replace", "same_cabin"]:
		for passengers in [1, places * 2]:
			game = fixture(app); s = game.session
			s.flags.passengers = passengers
			before = state(game)
			var message := ""
			match action:
				"demount": message = game.demount(3, 0)
				"sell": message = game.sell_mounted(3, 0)
				"replace": message = game.mount(replacement, 0)
				"same_cabin": message = game.mount(cabin, 0)
			check(message == app.library.text(160), "occupied cabin rejects %s even with spare places (%d passengers)" % [action, passengers])
			check(state(game) == before, "occupied %s rejection is atomic, including credits, cargo, fitting and damage" % action)
	game = fixture(app); s = game.session
	s.flags.passengers = 1
	check(game.mount(cabin, 2).is_empty() and s.ship_stats().cabins == places * 3 and s.cargo_count(cabin) == 1, "occupied ship may add a genuinely owned cabin to an empty slot")
	check(game.mount(replacement, 3).is_empty(), "passengers do not block fitting an unrelated empty slot")
	check(game.demount(3, 3).is_empty(), "passengers do not block demounting unrelated equipment")
	game = fixture(app); s = game.session
	var ordinary := offer(1, s.station_id)
	check(game.bar.accept(ordinary).is_empty(), "cancellation fixture accepts through the native rule")
	before = state(game)
	game.cancel_job()
	check(s.job.is_empty() and not s.flags.has("passengers") and s.credits == int(before.credits)
		and state(game).cargo == before.cargo and state(game).stats == before.stats, "cancellation removes occupancy and job without reward or cargo loss")
	check(game.demount(3, 0).is_empty(), "cancelled passengers release the actual cabin equipment")
	game = fixture(app); s = game.session
	ordinary = offer(places * 2, s.station_id)
	check(game.bar.accept(ordinary).is_empty(), "delivery fixture accepts through the native rule")
	before = state(game)
	game.settle_job(s.station_id + 1)
	check(state(game) == before and game.pending_dialogue.is_empty(), "a wrong station cannot deliver or pay the passenger job")
	game.settle_job(s.station_id)
	check(s.job.is_empty() and not s.flags.has("passengers") and s.credits == int(before.credits) + 14650,
		"correct destination clears occupancy and pays exactly the offered reward")
	check(s.stat("jobs") == int(before.stats.get("jobs", 0)) + 1 and s.stat("passengers") == int(before.stats.get("passengers", 0)) + places * 2,
		"delivery increments one job and the actual passenger count")
	check(state(game).cargo == before.cargo and state(game).equipment == before.equipment and game.pending_dialogue.size() == 1,
		"delivery retains owned cabins and cargo and emits one completion dialogue")
	before = state(game); game.settle_job(s.station_id)
	check(state(game) == before and game.pending_dialogue.size() == 1, "repeated settlement cannot duplicate reward or passenger statistics")
	check(game.sell_mounted(3, 0).is_empty(), "delivered passengers release cabin sale")
	game = fixture(app); s = game.session
	s.equipment[3] = [null, null, null, null]
	before = state(game)
	check(s.ship_stats().cabins == 0 and not game.bar.accept(offer(1, s.station_id)).is_empty() and state(game) == before,
		"unfitted cabins in cargo supply no passenger capacity")
