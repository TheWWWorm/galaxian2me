extends SceneTree
## Wreck crates: only a fitted tractor collects them (automatic models at
## once, manual models after their charge under the crosshair), the crate
## flies in and yields a share of its first cargo, flying into one collects
## nothing, and an uncollected crate blows up after 45 seconds. Memory-only.
const Host := preload("res://tests/support/isolated_app.gd")
const Space := preload("res://src/flight/space.gd")
const Body := preload("res://src/flight/body.gd")
var checks := 0
var failures := 0
var app
func _init() -> void:
	run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	print("PASS: " if ok else "FAIL: ", label)
	if not ok: failures += 1

func world(tractor: int):
	var game = app._make_game()
	game.new_game()
	game.session.story_step = maxi(game.session.story_step, 20)
	var sim := Space.new(game)
	sim.build()
	sim.story = null
	for b in sim.bodies:
		if b != sim.player: b.visible = false
	sim.player.pos = Vector3(300000, 0, 0)
	sim.player.basis = Basis.IDENTITY
	for slot in game.session.equipment[3].size():
		var gear = game.session.equipment[3][slot]
		if gear != null and app.catalogue.type(int(gear.id)) == app.catalogue.Type.TRACTOR_BEAM:
			game.session.equipment[3][slot] = null
	if tractor >= 0:
		if game.session.equipment[3].is_empty(): game.session.equipment[3].append(null)
		game.session.equipment[3][0] = {"id": tractor, "count": 1}
	return sim

func crate_ahead(sim, distance: float, item := 131, count := 3):
	sim._drop(sim.player.pos + sim.player.forward() * distance, item, count, "box")
	return sim.bodies.back()

func run() -> void:
	app = Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		check(false, "supplied content installed")
	else:
		var manual := -1
		var automatic := -1
		for id in app.catalogue.item_count():
			if app.catalogue.type(id) != app.catalogue.Type.TRACTOR_BEAM: continue
			if app.catalogue.attr(id, app.catalogue.A_TRACTOR_AUTO) == 1: automatic = id
			elif manual < 0: manual = id
		check(manual >= 0 and automatic >= 0, "the supplied catalogue has manual and automatic tractor beams")
		# No beam: flying straight through a crate collects nothing.
		var sim = world(-1)
		var messages: Array = []
		sim.event.connect(func(kind, data): if kind == "message": messages.append(str(data.text)))
		var box = crate_ahead(sim, 3000.0)
		for i in 60:
			sim.player.pos = box.pos + Vector3(0, 0, -200 + i * 10)
			sim._tractor_step(16)
			sim._collisions()
		check(box.alive and sim.game.session.cargo_count(131) == 0, "without a tractor beam a crate cannot be collected by flying into it")
		check(messages.count(app.library.text(264)) == 1, "aiming at a crate without a beam says so once")
		# Manual beam: needs its charge under the crosshair, then pulls.
		sim = world(manual)
		box = crate_ahead(sim, 6000.0)
		var charge: int = app.catalogue.attr(manual, app.catalogue.A_TRACTOR_SPEED)
		sim._tractor_step(maxi(1, charge / 2))
		check(not sim.tractor.crate_pulling and sim.tractor.status().phase == "charging", "a manual beam charges on the aimed crate first")
		sim.player.basis = Basis(Vector3.UP, PI * 0.5)
		sim._tractor_step(16)
		check(sim.tractor.crate == null, "looking away cancels the charge")
		sim.player.basis = Basis.IDENTITY
		sim._tractor_step(charge + 1)
		check(sim.tractor.crate_pulling, "the charged crate is taken by the beam")
		var start: float = box.pos.distance_to(sim.player.pos)
		sim._tractor_step(100)
		check(is_equal_approx(start - box.pos.distance_to(sim.player.pos), 1000.0), "the crate flies in at ten units per millisecond")
		sim.player.basis = Basis(Vector3.UP, PI)
		for i in 20: sim._tractor_step(100)
		var got: int = sim.game.session.cargo_count(131)
		check(not box.alive and got >= 1 and got <= 2, "a captured crate gives part of its first cargo (%d of 3)" % got)
		# Automatic beam: takes a crate in view at once.
		sim = world(automatic)
		box = crate_ahead(sim, 8000.0)
		box.pos += Vector3(3000, 0, 0)
		sim._tractor_step(16)
		check(sim.tractor.crate_pulling, "an automatic beam takes a crate in view without aiming")
		# Crate life.
		sim = world(-1)
		box = crate_ahead(sim, 20000.0)
		for i in 46: sim._age_crate(box, 1000)
		check(not box.alive, "an uncollected crate blows up after 45 seconds")
		var ore = crate_ahead(sim, 20000.0)
		ore.model = "asteroid"
		for i in 60: sim._age_crate(ore, 1000)
		check(ore.alive, "ore chunks from asteroids do not expire")
	app.queue_free()
	await process_frame
	print("CRATE TRACTOR: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
