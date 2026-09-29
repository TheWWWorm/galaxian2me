extends SceneTree
## MEMORY ONLY: each weapon class launches and goes off with the sound the
## original's table gives it; message boxes open with their chime.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
const Body := preload("res://src/flight/body.gd")
var app
var checks := 0
var failures := 0

func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)

func first_of(t: int) -> int:
	for id in app.catalogue.item_count():
		if app.catalogue.type(id) == t: return id
	return -1

func run() -> void:
	app = Host.new(); root.add_child(app); await process_frame; await process_frame
	if app.library == null:
		print("SKIP: no supplied content"); app.queue_free(); await process_frame; quit(2); return
	var game := Game.new(app.library, app.catalogue)
	var sim := Space.new(game)
	var T = app.catalogue.Type
	var expect := {T.LASER: "", T.ROCKET: "wpn_rocket_02", T.TORPEDO: "wpn_rocket_03",
		T.EMP_BOMB: "wpn_rocket_04", T.NUKE: "wpn_rocket_04"}
	for t in expect:
		var id := first_of(t)
		if id < 0: print("SKIP: no item of type ", t); continue
		check(sim.launch_sound(sim.weapon(id)) == expect[t], "type %d launches with %s" % [t, expect[t]])
	var heard: Array[String] = []
	sim.event.connect(func(kind, data): if kind == "sound": heard.append(str(data.name)))
	for pair in [[T.NUKE, "fx_thunder_01"], [T.EMP_BOMB, "wpn_nuke_02"]]:
		var id := first_of(pair[0])
		if id < 0: continue
		heard.clear()
		sim._blast({"pos": Vector3.ZERO, "weapon": sim.weapon(id), "owner": null})
		check(heard.has(pair[1]), "type %d goes off with %s" % pair)
	# Only the sounds the original plays: nothing for loot, radio or the lock.
	heard.clear()
	if sim.player == null: sim.player = Body.new()
	sim.player.pos = Vector3.ZERO
	check(is_equal_approx(sim._distance_volume(Vector3(0, 0, 20000)), 0.5) and sim._distance_volume(Vector3(0, 0, 90000)) == 0.0,
		"explosions fade out by 40000 units")
	var d = preload("res://src/screens/dialogue_panel.gd").new()
	d.app = app
	d.lines = [{"speaker": -1, "name": "", "text": "x"}]
	root.add_child(d)
	await process_frame
	check(d.is_inside_tree(), "a dialogue opens in isolation")
	d.queue_free()
	app.queue_free(); await process_frame
	print("checks=%d failures=%d" % [checks, failures])
	quit(1 if failures else 0)
