extends SceneTree
## Medals follow the original's table: the first medal is held from the
## start, a record earns the best tier whose threshold it passes, a better
## tier replaces a lesser one and never the reverse, docking announces them,
## and holding every other medal awards the last.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Medals := preload("res://src/simulation/medals.gd")
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
	var lib = app.library
	var t: Array = Medals.table(lib)
	if t.size() < 37:
		print("SKIP: no medal table in this build"); app.queue_free(); await process_frame; quit(2); return
	var game := Game.new(app.library, app.catalogue)
	game.new_game()
	var s = game.session
	check(Medals.tier(s, 0) == 1 and Medals.held_count(s, lib) == 1, "a new pilot holds only the first medal, in gold")
	check(Medals.check(s, app.catalogue, lib, 100).is_empty(), "nothing else is earned at the start")
	# Weapon Fanatic (medal 23) counts fitted guns only past the tutorial.
	var guns := 0
	for e in s.equipment[0]: if e != null: guns += 1
	var fanatic: Array = t[23]
	if guns >= int(fanatic[fanatic.size() - 1]):
		s.story_step = 8
		check(Medals.check(s, app.catalogue, lib, 100).has(23), "past the tutorial the fitted guns count for Weapon Fanatic")
		s.story_step = 0
	# Kills (medal 4): thresholds run gold, silver, bronze, largest first.
	var kills: Array = t[4]
	s.stats["kills"] = int(kills[kills.size() - 1])
	var found := Medals.check(s, app.catalogue, lib, 100)
	check(found.get(4, 0) == kills.size(), "the lowest kill count earns the lowest tier")
	Medals.award(s, lib, found)
	s.stats["kills"] = int(kills[0])
	found = Medals.check(s, app.catalogue, lib, 100)
	check(found.get(4, 0) == 1, "reaching the top count upgrades it to gold")
	Medals.award(s, lib, found)
	s.stats["kills"] = 0
	check(not Medals.check(s, app.catalogue, lib, 100).has(4) and Medals.tier(s, 4) == 1, "a medal is never taken back")
	check(Medals.description(lib, 4, 1).contains(str(int(kills[0]))), "its description names the reached threshold")
	# Hull (medal 1): docking with little hull left.
	var hull: Array = t[1]
	found = Medals.check(s, app.catalogue, lib, int(hull[hull.size() - 1]))
	check(found.has(1), "docking with the hull at %d%% earns the survivor medal" % int(hull[hull.size() - 1]))
	check(not Medals.check(s, app.catalogue, lib, 100).has(1), "an undamaged dock does not")
	# The last medal: every other one held.
	for i in t.size() - 1:
		if Medals.tier(s, i) == 0: s.medals[str(i)] = 3
	var out := Medals.award(s, lib, {})
	check(out.size() == 1 and int(out[0][0]) == t.size() - 1 and bool(s.flags.get("all_medals", false)),
		"holding every other medal awards the last, and the hangar's all-medals offer")
	# Docking announces new medals.
	var g2 := Game.new(app.library, app.catalogue)
	g2.new_game()
	g2.session.stats["kills"] = int(kills[kills.size() - 1])
	g2.dock(g2.session.station_id)
	var announced := false
	for e in g2.new_medals: if int(e[0]) == 4: announced = true
	check(announced, "a medal earned in flight is announced on docking")
	app.queue_free()
	await process_frame
	print("MEDALS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
