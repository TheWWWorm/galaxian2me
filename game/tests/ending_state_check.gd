extends SceneTree
## Explicit memory-only terminal fixtures; never evidence of earned progress.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Map := preload("res://src/screens/station/map_panel.gd")
const RETURN_SHA := "1d2c41c321a70cfd6f0019624aea3319beaf0cc4503039c19b275f40868859f3"
var app
var checks := 0
var failures := 0
func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)
func frames(n: int) -> void:
	for i in n:
		await physics_frame
		await process_frame
func run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 1 or FileAccess.get_sha256(args[0]) != RETURN_SHA:
		push_error("Provide the unmodified accepted C43 to initialize declared memory fixtures.")
		quit(2)
		return
	var header: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(args[0]))
	app = Host.new()
	root.add_child(app)
	await frames(2)
	check(app.activate(str(header.content)), "fixture supplied content is installed")
	var game := Game.new(app.library, app.catalogue)
	check(game.session.from_dict(header).is_empty(), "fixture begins from schema-valid unchanged C43 data in memory")
	for step in [43, 44]:
		var record: Dictionary = game.campaign.step_record(step)
		var missions: Array = record.get("missions", [])
		check(missions.size() == 1 and missions[0].size() == 3 and int(missions[0][0]) == 11
			and int(missions[0][1]) == 0 and int(missions[0][2]) == 98, "supplied epilogue%d is a zero-reward Alioth docking" % step)
		print("SOURCE RECORD ", step, " ", JSON.stringify(record))
	print("SOURCE RECORD 45 ", JSON.stringify(game.campaign.step_record(45)))
	check(not game.campaign.check(false, 98, 999999), "elapsed flight over Alioth cannot settle a docking epilogue")
	check(not game.campaign.check(true, 91), "Dima is not Alioth even after the successful finale")
	var before: Dictionary = game.session.to_dict().duplicate(true)
	game.campaign.on_dock(91)
	check(game.session.to_dict() == before and game.pending_dialogue.is_empty(), "wrong-station docking cannot grant ending or money")
	game.dock(98) # Declared docking fixture only, NOT native flight acceptance.
	check(game.session.story_step == 45 and game.session.story_mission.is_empty(), "Alioth fixture settles both epilogues into empty terminal45")
	check(game.session.credits == int(header.credits) + 40000, "terminal data pays forty thousand exactly once")
	check(not bool(game.session.flags.get("story_halted", false)), "completed story is not missing-content halted")
	check(game.session.cargo == header.cargo and game.session.equipment == header.equipment
		and game.session.blueprints == header.blueprints, "final payment does not grant cargo, ammunition or a drive")
	var expected: Array = game.campaign.dialogue(43, 1) + game.campaign.dialogue(44, 1)
	check(not expected.is_empty() and game.pending_dialogue == expected, "both original conversations are retained in source order")
	var terminal: Dictionary = game.session.to_dict().duplicate(true)
	for i in 3:
		game.campaign.on_dock(98)
		game.campaign.advance()
		game.campaign.conclude()
	check(game.session.to_dict() == terminal and game.pending_dialogue == expected, "duplicate terminal callbacks neither pay nor duplicate dialogue")
	app.game = game
	app.show_station()
	await frames(3)
	var actual: Array = []
	for i in 100:
		var talk = app.screen.conversation
		if talk == null: break
		actual.append(talk.lines[talk.index].duplicate(true))
		talk.next_button.pressed.emit()
		await frames(1)
	check(actual == expected and app.screen.conversation == null, "native station UI presents and acknowledges every source epilogue line")
	check(game.session.to_dict() == terminal and game.pending_dialogue.is_empty(), "dialogue acknowledgement preserves the once-paid terminal transaction")
	app.screen.menu.get_child(2).pressed.emit()
	await frames(3)
	var map = app.screen.current_panel
	check(map is Map and map.story_address().is_empty() and map.wormhole_address().is_empty(), "terminal Map has no ghost story or portal destination")
	check(map.portal_view == null, "terminal Map does not instantiate a closed-portal visual")
	var restored := Game.new(app.library, app.catalogue)
	check(restored.session.from_dict(JSON.parse_string(JSON.stringify(terminal))).is_empty(), "terminal fixture survives JSON numeric conversion")
	restored.resume()
	var expected_json: Dictionary = JSON.parse_string(JSON.stringify(terminal))
	var actual_json: Dictionary = JSON.parse_string(JSON.stringify(restored.session.to_dict()))
	for key in expected_json:
		if expected_json[key] != actual_json.get(key): print("RELOAD DIFFERENCE ", key, " ", JSON.stringify(expected_json[key]), " -> ", JSON.stringify(actual_json.get(key)))
	check(actual_json == expected_json and restored.pending_dialogue.is_empty(), "memory reload preserves terminal state without replay")
	check(restored.departure_error().is_empty(), "completed story still permits normal free-play departure")
	check(app.save_attempts.is_empty(), "all declared fixtures make zero save attempts")
	check(FileAccess.get_sha256(args[0]) == RETURN_SHA, "accepted C43 remains byte-identical")
	app.process_mode = Node.PROCESS_MODE_DISABLED
	app.queue_free()
	await frames(3)
	print("ENDING STATE: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
