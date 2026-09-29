extends SceneTree
## Declared memory-only cargo fixtures; no earned saves or live mutation.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
const Body := preload("res://src/flight/body.gd")
const Observer := preload("res://tests/support/cargo_pickup_observer.gd")
const Snapshot := preload("res://tests/support/simulation_snapshot.gd")
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
	var game := Game.new(app.library, app.catalogue)
	game.new_game()
	var space := Space.new(game)
	space.player = Body.new()
	space.player.kind = Body.Kind.PLAYER
	space.bodies.append(space.player)
	game.session.cargo = {"133": 1} # fixture inventory only
	var initial: Dictionary = game.session.to_dict().duplicate(true)
	var observer := Observer.new()
	space._drop(Vector3.ZERO, 131, 3, "box")
	observer.begin_world(space)
	var before := Snapshot.capture(space)
	observer.observe(space)
	check(before == Snapshot.capture(space), "pickup observation changes no native field or RNG")
	space._collect(space.bodies.back())
	observer.observe(space)
	check(observer.errors.is_empty() and observer.totals == {"131": 3}, "real collection matches consumed payload, cargo and salvage count")
	check(observer.reconciles(initial, game.session.to_dict(), int(game.session.ship_stats().cargo_capacity)), "legitimate pickup is accepted instead of strict input cargo equality")
	var bad: Dictionary = game.session.to_dict().duplicate(true)
	bad.cargo["164"] = 1
	check(not observer.reconciles(initial, bad, 999), "unobserved free crystal is rejected")
	bad = game.session.to_dict().duplicate(true)
	bad.cargo.erase("133")
	check(not observer.reconciles(initial, bad, 999), "loss of original cargo is rejected")
	bad = game.session.to_dict().duplicate(true)
	bad.stats.cargo_salvaged += 1
	check(not observer.reconciles(initial, bad, 999), "unearned salvage statistic is rejected")
	check(not observer.reconciles(initial, game.session.to_dict(), 3), "capacity overflow is rejected")
	space._drop(Vector3.ZERO, 131, 2, "box")
	var destroyed: Body = space.bodies.back()
	observer.observe(space)
	destroyed.alive = false # declared destroyed-box fixture, payload not collected
	observer.observe(space)
	check(observer.errors.is_empty() and observer.totals == {"131": 3}, "destroyed uncollected box is not credited as pickup")
	var phantom := Observer.new()
	phantom.begin_world(space)
	game.session.add_cargo(131, 1) # negative fixture, no physical payload
	game.session.add_stat("cargo_salvaged", 1)
	phantom.observe(space)
	check(not phantom.errors.is_empty(), "matching forged cargo and statistic still fails physical payload observation")
	var full := Observer.new()
	game.session.cargo = {"133": int(game.session.ship_stats().cargo_capacity) - 1}
	space._drop(Vector3.ZERO, 131, 3, "box")
	var partial: Body = space.bodies.back()
	full.begin_world(space)
	space._collect(partial)
	full.observe(space)
	check(full.errors.is_empty() and full.totals == {"131": 1} and partial.alive and partial.cargo[1] == 2, "partial full-hold pickup credits one unit and preserves physical remainder")
	space._collect(partial)
	full.observe(space)
	check(full.errors.is_empty() and full.totals == {"131": 1}, "full-hold retry cannot credit the remainder again")
	check(app.save_attempts.is_empty(), "all pickup fixtures make zero save attempts")
	space.dispose()
	app.queue_free()
	await process_frame
	await process_frame
	print("FINALE PICKUP: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
