extends SceneTree
## The original's friendly-fire rules: a ship of the system's own race puts
## up with a third of its hull in hits before it fights back (with a radio
## warning), two thirds and all its kind come for you (with the alarm);
## other races' ships do not turn on you; kills, disabling and theft cost
## standing the original's amounts.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
var checks := 0
var failures := 0

func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		print("SKIP: no supplied content"); app.queue_free(); await process_frame; quit(2); return
	var game := Game.new(app.library, app.catalogue)
	game.new_game()
	game.session.story_step = 20
	game.session.story_mission = {}
	# A Terran system's station.
	var station := -1
	for i in app.catalogue.system_count():
		if int(app.catalogue.system(i).faction) == 0:
			var stations: Array = app.catalogue.system(i).get("stations", [])
			if not stations.is_empty():
				station = int(stations[0])
				break
	if station < 0:
		print("SKIP: no Terran station"); app.queue_free(); await process_frame; quit(2); return
	game.session.station_id = station
	game.session.system_index = app.catalogue.system_of_station(station)
	var sim := Space.new(game)
	sim.build()
	check(sim.local_race() == 0, "the system's own race is the Terrans")
	var sounds: Array = []
	sim.event.connect(func(kind, data): if kind == "sound": sounds.append(data.name))
	var a := sim._spawn_ship(0, Vector3(0, 0, 5000), false)
	var b := sim._spawn_ship(0, Vector3(0, 0, 9000), false)
	var alien := sim._spawn_ship(1, Vector3(0, 0, 7000), false)
	for s in [a, b, alien]:
		s.hull = 300; s.hull_max = 300; s.shield = 0.0; s.armor = 0
		s.hostile = false; s.ai.erase("target")
	game.session.reputation = [0, 0]
	sim._harm(a, 90.0, 0.0, sim.player)
	check(not a.hostile, "a stray hit under a third of the hull is forgiven")
	check(game.session.reputation == [0, 0], "and costs no standing")
	sim._harm(a, 20.0, 0.0, sim.player)
	check(a.hostile and a.ai.get("target") == sim.player, "past a third it fights back")
	check(not b.hostile, "the others still hold their fire")
	check(not sim.radio.is_empty() and [247, 248, 249].any(func(id): return sim.radio.text == app.library.text(id)),
		"over the radio a Terran warns you off")
	check(sim.radio.name == app.library.text(819 + 23) and not sounds.has("fx_message_02"), "with the race's name, and silently as in the original")
	var first: Dictionary = sim.radio
	sim._harm(a, 100.0, 0.0, sim.player)
	check(b.hostile and b.ai.get("target") == sim.player, "past two thirds every Terran comes for you")
	check(sim.radio != first and [250, 251, 252].any(func(id): return sim.radio.text == app.library.text(id)),
		"and they call for back-up")
	sim._harm(a, 100.0, 0.0, sim.player)
	check(game.session.reputation[0] == -5, "a Terran kill costs 5 standing with the Terrans")
	sim._harm(alien, 250.0, 0.0, sim.player)
	check(not alien.hostile, "a Vossk ship in Terran space does not turn on you")
	alien.emp_max = 100; alien.emp = 100
	sim._harm(alien, 0.0, 200.0, sim.player)
	check(alien.disabled and game.session.reputation[0] == -3, "draining a Vossk ship's energy is a wrong against the Vossk (2)")
	var pirate := sim._spawn_ship(8, Vector3(0, 0, 3000), false)
	pirate.hull = 1; pirate.shield = 0.0; pirate.armor = 0
	sim._harm(pirate, 10.0, 0.0, sim.player)
	check(game.session.reputation[0] == -2, "a pirate kill in Terran space earns a point of Vossk distrust")
	# During a job the channel stays quiet.
	var sim2 := Space.new(game)
	sim2.build()
	game.session.job = {"kind": 0}
	var c := sim2._spawn_ship(0, Vector3(0, 0, 5000), false)
	c.hull = 300; c.hull_max = 300; c.shield = 0.0; c.armor = 0; c.hostile = false
	sim2._harm(c, 150.0, 0.0, sim2.player)
	check(c.hostile and sim2.radio.is_empty(), "during a job the ship fights back without a radio call")
	game.session.job = {}
	app.queue_free()
	await process_frame
	print("FRIENDLY FIRE: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
