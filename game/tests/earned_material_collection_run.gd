extends "res://tests/earned_material_supply_run.gd"
## Continue the genuine pre-collection stop, never replay purchases or reroll
## a successful sourcing route after an unrelated final-docking regression.
const PENDING_SHA := "91763dd8a5ecfff648a5f90c64a2faa4488fa0e0114f21a2dba5a1e2e36d2a25"
func _run() -> void:
	if started: return
	started = true
	run_kind = "collection"
	node_added.connect(watch_flight_entry)
	node_added.connect(trace_flight_node)
	if not await start_host(PENDING_SHA): return
	last_native_kills = int(header.stats.kills)
	seen_screen = app.screen.get_instance_id()
	check(int(header.station) == 95 and int(header.system) == 19 and int(header.credits) == 27699
		and header.blueprints["85"].pending == {"96": 1.0} and int(header.blueprints["85"].produced) == 1
		and app.game.session.cargo_count(85) == 0 and app.game.session.cargo_used() == 25,
		"collection starts only from the exact genuinely produced, uncollected drive checkpoint")
	if failures == 0: await visit(96, false)
	if failures == 0:
		check(transactions.is_empty() and confirmations.is_empty() and collected_products == 1
			and app.game.session.cargo_count(85) == 1 and app.game.session.stat("goods_produced") == 1
			and app.game.workshop.details(85).pending.is_empty(),
			"real origin docking collects the existing drive once without new purchases, fees or production")
		check(app.game.session.cargo_used() == 26 and saved_state(app.AUTOSAVE_SLOT) == snapshot(),
			"retired flight causes no after-autosave salvage, damage or inventory mismatch")
		await open_blueprints()
		await shot("actual_material_collected_recipe")
		press(app.screen.menu.get_child(0), "Hangar actual collected product")
		await frames(3)
		var tabs: TabContainer = app.screen.current_panel
		tabs.current_tab = 0
		await frames(2)
		var shop = tabs.get_child(0)
		press(item_row(shop.hold_list, app.catalogue.item_name(85)), "inspect actual collected Khador Drive in cargo")
		await frames(2)
		await shot("actual_material_collected_drive_in_hold")
		await save_checkpoint()
		if failures == 0:
			var path := out.path_join("earned-material-supply45.json")
			check(DirAccess.copy_absolute(app.save_path(0), path) == OK, "retain actual collected-product native manual save")
			accepted = {"path": path, "sha256": FileAccess.get_sha256(path), "state": snapshot()}
	await finish()
