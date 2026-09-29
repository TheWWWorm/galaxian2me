extends SceneTree
## The named lounge agents sell what agents.bin says: a blueprint (unlocked,
## not put in the hold) or a hidden system's coordinates (revealed on the
## map). Saves from builds that mixed the two fields up are repaired on load.
## Also: the tutorial's departure hints and the lounge's reply to a job.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Catalogue := preload("res://src/content/catalogue.gd")
const Lounge := preload("res://src/simulation/lounge.gd")
const Blueprints := preload("res://src/simulation/blueprints.gd")
const Navigation := preload("res://src/simulation/navigation.gd")
var checks := 0
var failures := 0

func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)

func _agent_person(game, a: Dictionary) -> Dictionary:
	for p in game.bar.generate(int(a.station)):
		if int(p.get("agent", -1)) == int(a.id): return p
	return {}

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		print("SKIP: no supplied content"); app.queue_free(); await process_frame; quit(2); return
	var lib = app.library
	var cat = app.catalogue
	var agents: Array = lib.data.get("agents", [])
	if agents.is_empty():
		print("SKIP: no agents in this build"); app.queue_free(); await process_frame; quit(2); return
	var sellers := []
	var scouts := []
	var single := true
	for a in agents:
		var offer: Dictionary = Catalogue.agent_offer(a)
		if int(offer.blueprint) >= 0: sellers.append(a)
		if int(offer.system) >= 0: scouts.append(a)
		if int(offer.blueprint) >= 0 and int(offer.system) >= 0: single = false
	check(single and not sellers.is_empty() and not scouts.is_empty(), "agents sell either a blueprint (%d) or coordinates (%d)" % [sellers.size(), scouts.size()])
	var recipes := true
	for a in sellers:
		if Blueprints.recipe(cat, int(Catalogue.agent_offer(a).blueprint)).is_empty(): recipes = false
	check(recipes, "every sold blueprint is a recipe of this build")
	var hidden := true
	for a in scouts:
		if bool(cat.system(int(Catalogue.agent_offer(a).system)).get("visible", true)): hidden = false
	check(hidden, "every sold system starts hidden")

	var game := Game.new(lib, cat)
	game.new_game()
	var s = game.session
	s.story_step = 17
	s.credits = 1000000
	# A blueprint seller.
	var seller: Dictionary = sellers[0]
	var product := int(Catalogue.agent_offer(seller).blueprint)
	var p := _agent_person(game, seller)
	check(int(p.get("kind", -1)) == Lounge.Kind.BLUEPRINT_AGENT and str(p.speech).contains(cat.item_name(product)), "the seller offers the blueprint by name")
	var cargo_before: Dictionary = s.cargo.duplicate()
	var credits_before: int = s.credits
	check(game.bar.accept(p).is_empty(), "buying the blueprint succeeds")
	check(s.blueprints.has(str(product)) and s.cargo == cargo_before, "the blueprint is unlocked and nothing lands in the hold")
	check(s.credits == credits_before - int(seller.price), "the agent's price is paid")
	check(_agent_person(game, seller).is_empty(), "the agent leaves the bar after the deal")
	# A coordinates seller.
	var scout: Dictionary = scouts[0]
	var system := int(Catalogue.agent_offer(scout).system)
	check(not Navigation.known(s, cat, system), "the system is not on the map before the deal")
	p = _agent_person(game, scout)
	check(int(p.get("kind", -1)) == Lounge.Kind.COORDINATES_AGENT and str(p.speech).contains(cat.system_name(system)), "the scout names the hidden system")
	var owned: int = s.blueprints.size()
	check(game.bar.accept(p).is_empty(), "buying the coordinates succeeds")
	check(Navigation.known(s, cat, system) and s.blueprints.size() == owned, "the system is revealed and no blueprint appears")
	check(int(s.flags.get("discover_system", -1)) == system, "the map's discovery scene is queued")

	# Repair of a save written with the fields swapped.
	var old := Game.new(lib, cat)
	old.new_game()
	old.session.story_step = 17
	old.session.flags["agent_done_%d" % int(seller.id)] = true
	old.session.flags["agent_done_%d" % int(scout.id)] = true
	old.session.add_cargo(product, 1)
	var saved: Dictionary = old.session.to_dict()
	saved.blueprints = {str(system): {"progress": {}}}
	var fresh := Game.new(lib, cat)
	var err: String = fresh.session.from_dict(JSON.parse_string(JSON.stringify(saved)))
	check(err.is_empty(), "an affected save loads (%s)" % err)
	check(fresh.session.blueprints.has(str(product)) and not fresh.session.blueprints.has(str(system)), "the paid blueprint is granted and the misplaced entry dropped")
	check(fresh.session.unlocked_systems.has(str(system)), "the paid coordinates reveal the system")
	check(fresh.session.cargo_count(product) == 1, "the item already received is kept")

	# ModStation.leaveStation's tutorial hints.
	var t := Game.new(lib, cat)
	t.new_game()
	t.session.story_step = 6
	t.session.cargo = {}
	check(t.departure_error() == lib.text(258), "step 6 with no gun in the hold: fit a weapon and armour")
	var gun := -1
	for id in cat.item_count():
		if cat.category(id) == 0 and gun < 0: gun = id
	t.session.add_cargo(gun, 1)
	check(t.departure_error() == lib.text(259), "step 6 with a gun in the hold: fit what you carry")
	t.session.story_step = 7
	for c in 4:
		for i in t.session.equipment[c].size(): t.session.equipment[c][i] = null
	check(t.departure_error() == lib.text(259), "step 7 unarmed: still the hint")
	t.session.equipment[0][0] = {"id": gun, "count": 1}
	check(t.departure_error() != lib.text(258) and t.departure_error() != lib.text(259), "step 7 with a gun fitted: no hint")

	# SpaceLounge's reply to an accepted challenge.
	var j := Game.new(lib, cat)
	j.new_game()
	var client := {"name": "x", "race": 0, "male": true, "kind": Lounge.Kind.JOB, "face": [],
		"job": {"kind": 12, "station": j.session.station_id, "reward": 100, "client": "x", "race": 0}}
	check(j.bar.accept(client).is_empty() and str(client.speech) == lib.text(490), "accepting a challenge: the rival's see-you-outside line")

	app.queue_free()
	await process_frame
	print("AGENT OFFERS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
