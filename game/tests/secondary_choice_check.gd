extends SceneTree
## Actions → Secondary weapons: the chosen launcher is the one the secondary
## button fires; with nothing chosen the first loaded one fires, and an
## emptied choice is dropped. Memory-only.
const Host := preload("res://tests/support/isolated_app.gd")
const Space := preload("res://src/flight/space.gd")
var checks := 0
var failures := 0

func _init() -> void:
	run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	print("PASS: " if ok else "FAIL: ", label)
	if not ok: failures += 1

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		check(false, "supplied content installed")
	else:
		var rocket := -1
		var torpedo := -1
		for id in app.catalogue.item_count():
			var t: int = app.catalogue.type(id)
			if t == app.catalogue.Type.ROCKET and rocket < 0: rocket = id
			if t == app.catalogue.Type.TORPEDO and torpedo < 0: torpedo = id
		var g = app._make_game()
		g.new_game()
		g.session.story_step = maxi(g.session.story_step, 20)
		g.session.equipment[1] = [{"id": rocket, "count": 3}, {"id": torpedo, "count": 1}]
		var sim := Space.new(g)
		sim.build()
		sim.story = null
		check(sim.secondary_launchers().size() == 2, "both fitted launchers are offered")
		check(g.secondary_choice == -1 and int(sim.current_secondary().id) == rocket, "with nothing chosen the first loaded launcher fires")
		sim.choose_secondary(torpedo)
		check(int(sim.current_secondary().id) == torpedo, "choosing the torpedo makes it the secondary")
		sim._player_weapons_step(16, {"secondary": true})
		var counts := {}
		for w in sim.secondary_launchers(): counts[int(w.id)] = int(w.count)
		check(counts[torpedo] == 0 and counts[rocket] == 3, "the secondary button fires only the chosen launcher")
		check(g.secondary_choice == -1, "an emptied choice is dropped")
		check(int(sim.current_secondary().id) == rocket, "then the remaining loaded launcher stands in")
		sim.choose_secondary(rocket)
		var again := Space.new(g)
		again.build()
		check(int(again.current_secondary().id) == rocket, "the choice lasts into the next flight")
		sim.dispose()
		again.dispose()
	print("SECONDARY CHOICE: %d checks, %d failures" % [checks, failures])
	app.queue_free()
	quit(1 if failures else 0)
