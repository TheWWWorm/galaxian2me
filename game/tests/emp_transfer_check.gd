extends "res://tests/convoy_transfer_check.gd"
## Explicit in-memory result/ammunition fixture, NOT earned gameplay evidence.
## The earned-travel harness separately fires real secondary projectiles.

func run() -> void:
	app = TestApp.new()
	root.add_child(app)
	await frames(2)
	if app.library == null:
		check(false, "supplied content installed")
	else:
		app.game = app._make_game()
		app.game.new_game()
		app.game.session.story_step = 20
		app.game.campaign.advance()
		app.game.arrive(int(app.game.session.story_mission.station))
		app.game.session.add_cargo(41, 10)
		app.game.mount(41, 0)
		# Earlier independently discovered systems must survive a later reveal.
		app.game.session.unlocked_systems["9"] = true
		var origin: int = app.game.session.station_id
		var credits: int = app.game.session.credits
		var jumps: int = app.game.session.stat("jumpgates")
		app.show_flight()
		await frames(2)
		await dismiss_flight_lines()
		app.screen._finish_story_station_transfer(21)
		check(app.screen is Flight and app.save_attempts.is_empty() and app.game.session.story_step == 21,
			"unsatisfied EMP objective cannot invoke the station transfer")
		# Isolate the transaction boundary with a synthetic successful result
		# and three spent bombs. These values are never written to real files.
		for weapon in app.screen.space.player.weapons:
			if weapon.kind == "emp": weapon.count = 7
		app.game.session.story_mission.done = true
		for i in 90:
			await frames(1)
			if app.screen is Flight and app.screen.conversation != null: break
		check(app.game.session.story_step == 21 and app.screen is Flight and app.screen.conversation != null,
			"EMP success waits for the imported result dialogue before advancing")
		check(app.game.session.station_id == origin and app.save_attempts.is_empty(),
			"EMP result neither transfers nor autosaves before the player dismisses it")
		await dismiss_flight_lines()
		check(app.screen is Station and app.game.session.station_id == origin,
			"finished EMP result enters the same station as the supplied game")
		check(app.game.session.story_step == 23, "normal station arrival settles step twenty-two into twenty-three")
		check(app.game.session.unlocked_systems.get("6", false) and app.game.session.unlocked_systems.get("9", false),
			"supplied step-twenty-three map reveal preserves earlier discoveries")
		app.screen.menu.get_child(2).pressed.emit()
		await frames(2)
		check(app.screen.current_panel._known(6), "revealed story system is visible through the actual Map panel")
		check(int(app.game.session.equipment[1][0].count) == 7,
			"scripted return stores actual remaining flight ammunition before docking")
		check(app.save_attempts == [app.AUTOSAVE_SLOT], "EMP return creates exactly one settled docking autosave")
		check(app.game.session.stat("jumpgates") == jumps and app.game.session.credits == credits,
			"EMP return invents no gate trip or next-mission reward")
		var saved: Dictionary = app.save_summary(app.AUTOSAVE_SLOT)
		check(int(saved.story_step) == 23 and int(saved.equipment[1][0].count) == 7,
			"return autosave includes the settled story and remaining bombs")
		check(saved.unlocked_systems.get("6", false) and saved.unlocked_systems.get("9", false),
			"story system reveal is part of the same settled docking autosave")
		var state = JSON.parse_string(JSON.stringify(app.game.session.to_dict()))
		app.save_game(0)
		var attempts := app.save_attempts.size()
		check(app.load_game(0).is_empty(), "earned-shape EMP result fixture reloads")
		check(JSON.parse_string(JSON.stringify(app.game.session.to_dict())) == state and app.save_attempts.size() == attempts,
			"reload cannot repeat EMP progression, ammunition or autosave")
	app.queue_free()
	await frames(3)
	print("EMP TRANSFER: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
