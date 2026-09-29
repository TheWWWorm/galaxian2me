extends SceneTree
## Synthetic Map-state fixtures against the read-only supplied graph. This
## does not manufacture campaign progression, flights, offers or checkpoints.
const TestApp := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Map := preload("res://src/screens/station/map_panel.gd")
var failures := 0
var checks := 0

func _init() -> void:
	run.call_deferred()

func check(ok: bool, text: String) -> void:
	checks += 1
	print("PASS: " if ok else "FAIL: ", text)
	if not ok: failures += 1

func run() -> void:
	var app := TestApp.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		check(false, "supplied content installed")
	else:
		var game := Game.new(app.library, app.catalogue)
		game.new_game()
		var panel := Map.new()
		panel.app = app
		panel.game = game
		var linked_systems := 0
		for here in app.catalogue.system_count():
			game.session.system_index = here # Map-only fixture, not a flight.
			var links: Array = app.catalogue.system(here).get("links", [])
			if not links.is_empty(): linked_systems += 1
			var mismatches := []
			for i in app.catalogue.system_count():
				var adjacent := i == here
				for link in links:
					if int(link) == i: adjacent = true
				if panel._reachable(i) != adjacent: mismatches.append(i)
			check(mismatches.is_empty(), "system %d follows supplied links %s; mismatches %s" % [here, str(links), str(mismatches)])
		check(linked_systems > 0, "graph check includes non-empty original connections")
		check(app.save_attempts.is_empty(), "Map graph assertions never write saves")
		panel.free()
	app.queue_free()
	await process_frame
	await process_frame
	print("MAP ROUTES: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
