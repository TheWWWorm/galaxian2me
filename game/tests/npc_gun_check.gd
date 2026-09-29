extends SceneTree
## NPC guns follow the original's assignGuns: damage grows with rank and
## story, reload shortens with the story, and campaign mission 4 disarms
## every gun to a single point.
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
	var sim := Space.new(game)
	game.session.story_step = 4
	check(int(sim._npc_gun(8, 9).damage) == 1, "mission 4: every gun does a single point")
	game.session.story_step = 20
	var w: Dictionary = sim._npc_gun(8, 9)
	check(int(w.damage) == 9, "otherwise the damage asked for")
	check(int(w.reload) == 600 - 40 and int(w.life) == 3000 and is_equal_approx(float(w.speed), 16.0),
		"reload 600 less twice the mission, 3000 ms at 16 units/ms")
	app.queue_free()
	await process_frame
	print("checks=%d failures=%d" % [checks, failures])
	quit(1 if failures else 0)
