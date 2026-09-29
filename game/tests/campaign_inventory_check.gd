extends SceneTree
## Explicit synthetic unit fixtures, NOT earned campaign saves. Validate the
## supplied mining-handover semantics without touching a player or check save.
const TestApp := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
var failures := 0
var checks := 0

func _init() -> void:
	run.call_deferred()

func check(ok: bool, label: String) -> void:
	checks += 1
	print("PASS: " if ok else "FAIL: ", label)
	if not ok: failures += 1

func run() -> void:
	var app := TestApp.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		check(false, "supplied content installed")
	else:
		for previous in [3, 5]:
			var game := Game.new(app.library, app.catalogue)
			game.new_game()
			# Synthetic initial conditions stay solely in this unit fixture.
			game.session.story_step = previous
			game.session.cargo = {"154": 23, "116": 2}
			game.session.stats["ore_mined"] = 35
			var equipment := game.session.equipment.duplicate(true)
			var credits: int = game.session.credits
			game.campaign.advance()
			check(game.session.story_step == previous + 1, "fixture enters supplied step %d" % (previous + 1))
			check(game.session.cargo.is_empty(), "step %d hands over all cargo" % (previous + 1))
			check(game.session.equipment == equipment and game.session.credits == credits,
				"cargo handover never removes equipment or invents payment")
			check(game.session.stat("ore_mined") == 35, "cargo handover preserves lifetime mining count")
			if previous == 3:
				check(not game.campaign.check(true, 78), "empty hold cannot skip the second 25-ton mining flight")
			else:
				game.session.cargo = {"154": 1}
				game.resume()
				check(game.session.cargo_count(154) == 1, "loading step six does not replay the cargo handover")
		check(app.save_attempts.is_empty(), "unit fixture writes no checkpoints")
	app.queue_free()
	await process_frame
	await process_frame
	print("CAMPAIGN INVENTORY: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
