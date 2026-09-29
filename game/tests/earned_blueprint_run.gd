extends "res://tests/earned_travel_run.gd"
## COPY genuine cleanup45, then purchase and contribute only actual cargo through
## visible native controls. Expected dictionaries below are observations/assertions,
## never replacements for live resources, recipe progress, stock or RNG state.
const CLEANUP_SHA := "83539530b0bd544ef2993020142b79330594a972c9466cf18917b576af2a0a52"
var header := {}
var frozen_sources := {}
var transactions: Array = []
var accepted := {}

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 2: source = args[0]; out = args[1]
	_run.call_deferred()

func collect_sources(folder: String, result: Dictionary) -> void:
	for file in DirAccess.get_files_at(folder):
		if file.ends_with(".gd"): result[folder.path_join(file)] = FileAccess.get_sha256(folder.path_join(file))
	for child in DirAccess.get_directories_at(folder): collect_sources(folder.path_join(child), result)

func source_hashes() -> Dictionary:
	var result := {}
	collect_sources("res://src", result)
	collect_sources("res://tests", result)
	return result

func start_host(expected_sha: String) -> bool:
	if FileAccess.get_sha256(source) != expected_sha or out.is_empty() or DirAccess.dir_exists_absolute(out):
		push_error("Provide the accepted native input and a NEW isolated output directory.")
		quit(2)
		return false
	root.size = Vector2i(1280, 800)
	DirAccess.make_dir_recursive_absolute(out)
	frozen_sources = source_hashes()
	source_bytes = FileAccess.get_file_as_bytes(source)
	header = JSON.parse_string(source_bytes.get_string_from_utf8())
	input_step = int(header.story_step)
	app = TestApp.new()
	save_root = out.path_join("test-saves-%d" % Time.get_ticks_usec())
	app.disk_saves = save_root
	root.add_child(app)
	await frames(3)
	check(app.activate(str(header.content)), "actual earned content is installed")
	if failures > 0: await finish(); return false
	DirAccess.make_dir_recursive_absolute(app.save_path(app.AUTOSAVE_SLOT).get_base_dir())
	check(DirAccess.copy_absolute(source, app.save_path(app.AUTOSAVE_SLOT)) == OK,
		"COPY the immutable earned input into fresh native storage")
	app.show_title()
	await frames(3)
	app.screen._load()
	await frames(2)
	press(app.screen.panel_holder.get_child(0).get_child(0).get_child(0), "title Load earned input")
	await frames(4)
	var expected := header.duplicate(true)
	expected.erase("saved_at")
	check(app.screen is Station and snapshot() == expected and app.save_attempts.is_empty(),
		"native title load preserves every input field without saving or producing anything")
	await shot("actual_blueprint_input")
	return true

func _run() -> void:
	if started: return
	started = true
	if not await start_host(CLEANUP_SHA): return
	check(input_step == 45 and app.game.session.station_id == 96 and app.game.session.credits == 45687
		and app.game.session.cargo_used() == 28 and app.game.session.job.is_empty(),
		"production begins only from the actual paid cleanup checkpoint")
	if failures == 0: await contribute_carried(127, true)
	for purchase in [[127, 72], [129, 40], [125, 9]]:
		if failures > 0: break
		await buy_and_contribute(int(purchase[0]), int(purchase[1]))
	if failures == 0:
		var session = app.game.session
		var state: Dictionary = session.blueprints["85"]
		check(session.credits == 39806 and session.cargo_used() == 25,
			"actual purchases spend 5881 credits; only the three previously carried microchips reduce the original hold")
		var actual_progress: Dictionary = JSON.parse_string(JSON.stringify(state.progress))
		var expected_progress: Dictionary = JSON.parse_string('{"164":50,"127":75,"129":40,"125":9}')
		check(actual_progress == expected_progress
			and int(state.cost) == 5947 and int(state.station) == 96,
			"real deposits preserve the fifty earned crystals and account for every paid material at Kalun Amir")
		check(session.cargo_count(85) == 0 and int(state.get("produced", 0)) == 0
			and state.get("pending", {}).is_empty() and session.stat("goods_produced") == 0,
			"unfinished production never fabricates a completed drive or production credit")
		check(snapshot().stats == header.stats and snapshot().equipment == header.equipment
			and snapshot().ship == header.ship and snapshot().flags == header.flags
			and session.story_step == 45 and session.story_mission.is_empty() and session.job.is_empty(),
			"construction leaves the ending, finite loadout, defenses, closed portals and job/kill/gate counts intact")
		check(app.save_attempts.is_empty(), "trades and deposits do not overwrite the earned docking autosave")
		if failures > 0: await finish(); return
		await open_blueprints()
		await shot("actual_blueprint_partial_final")
		await save_checkpoint()
		var path := out.path_join("earned-blueprint45.json")
		check(DirAccess.copy_absolute(app.save_path(0), path) == OK, "retain the actual UI-saved partial-production checkpoint")
		accepted = {"path": path, "sha256": FileAccess.get_sha256(path), "state": snapshot()}
		await open_blueprints()
		await shot("actual_blueprint_partial_reloaded")
	await finish()

func open_blueprints():
	press(app.screen.menu.get_child(0), "Hangar")
	await frames(3)
	var tabs: TabContainer = app.screen.current_panel
	var index := -1
	for i in tabs.get_tab_count():
		if tabs.get_tab_title(i) == app.library.text(130): index = i
	check(index >= 0, "native hangar has the supplied Blueprints tab")
	if index < 0: return null
	# Select the actual TabContainer control, not any game/session field.
	tabs.current_tab = index
	await frames(3)
	var panel = tabs.get_child(index)
	check(panel.is_visible_in_tree(), "blueprint panel is actually visible")
	press(item_row(panel.list, app.catalogue.item_name(85)), "owned Khador Drive recipe")
	await frames(2)
	return panel

func contribute_carried(id: int, exercise_cancel := false) -> void:
	var panel = await open_blueprints()
	if panel == null or failures > 0: return
	press(item_row(panel.ingredients, app.catalogue.item_name(id)), "select carried recipe material")
	await frames(2)
	press(named_button(panel.actions, "Max"), "maximum actually needed carried material")
	await frames(2)
	var before := snapshot()
	var order: Dictionary = app.game.blueprint_offer(85, id, panel.amount)
	check(str(order.error).is_empty() and int(order.count) > 0, "native contribution is backed by actual carried goods")
	if failures > 0: return
	press(named_button(panel.actions, "Contribute"), "contribute carried materials")
	await frames(2)
	if bool(order.first) or bool(order.remote):
		check(panel.confirmation.visible and snapshot() == before,
			"source production confirmation appears before any material or credit is spent")
		await shot("actual_blueprint_confirmation_%d" % transactions.size())
		if exercise_cancel:
			press(panel.confirmation.get_cancel_button(), "cancel first production order")
			await frames(2)
			check(not panel.confirmation.visible and snapshot() == before,
				"canceling the native confirmation leaves the entire earned state unchanged")
			press(named_button(panel.actions, "Contribute"), "review first production order again")
			await frames(2)
		press(panel.confirmation.get_ok_button(), "confirm original production terms")
	await frames(3)
	var after := snapshot()
	var expected: Dictionary = before.duplicate(true)
	var key := str(id)
	var count := int(order.count)
	expected.cargo[key] = int(expected.cargo[key]) - count
	if int(expected.cargo[key]) == 0: expected.cargo.erase(key)
	expected.credits = int(expected.credits) - int(order.fee)
	var state: Dictionary = expected.blueprints["85"]
	state.progress[key] = int(state.progress.get(key, 0)) + count
	state.cost = int(state.get("cost", 0)) + int(order.unit_value) * count
	if int(state.get("station", -1)) < 0: state.station = int(before.station)
	expected = JSON.parse_string(JSON.stringify(expected))
	check(after == expected, "visible contribution changes only its exact cargo, fee and recipe accounting")
	transactions.append({"kind": "contribute", "order": order, "before": before, "after": after})
	await shot("actual_blueprint_deposit_%02d" % transactions.size())

func buy_and_contribute(id: int, total: int) -> void:
	var remaining := total
	for leg in 8:
		if remaining == 0 or failures > 0: break
		var entry: Dictionary = {}
		for item in app.game.shelf():
			if int(item.id) == id: entry = item
		check(not entry.is_empty() and int(entry.count) > 0, "requested material exists on the actual retained station shelf")
		if failures > 0: return
		var count := mini(remaining, mini(int(entry.count), app.game.session.cargo_free()))
		var price := int(entry.price)
		if price > 0: count = mini(count, int(app.game.session.credits / price))
		check(count > 0, "a real purchase fits the current hold and finite budget")
		if failures > 0: return
		press(app.screen.menu.get_child(0), "Hangar shop")
		await frames(3)
		var tabs: TabContainer = app.screen.current_panel
		tabs.current_tab = 0
		await frames(2)
		var shop = tabs.get_child(0)
		press(item_row(shop.shelf_list, app.catalogue.item_name(id)), "actual priced material stock")
		await frames(2)
		if count == shop._available():
			press(named_button(shop.detail, "Max"), "buy available cargo-limited quantity")
			await frames(2)
		else:
			for unit in count - 1:
				press(named_button(shop.detail, "+"), "increase actual shop quantity")
				await frames(1)
		check(shop.amount == count, "visible shop quantity equals the bounded purchase")
		var before := snapshot()
		await shot("actual_blueprint_purchase_%02d" % transactions.size())
		press(named_button(shop.detail, "Buy"), "pay actual shelf price")
		await frames(3)
		var after := snapshot()
		var expected: Dictionary = before.duplicate(true)
		expected.credits = int(expected.credits) - price * count
		expected.cargo[str(id)] = int(expected.cargo.get(str(id), 0)) + count
		for market in expected.markets:
			if int(market.station) != int(before.station): continue
			for item in market.items:
				if int(item.id) == id: item.count = int(item.count) - count
		expected = JSON.parse_string(JSON.stringify(expected))
		check(after == expected and app.game.session.cargo_used() <= int(app.game.session.ship_stats().cargo_capacity),
			"actual shop purchase debits exact credits/stock, adds exact cargo, and respects capacity")
		transactions.append({"kind": "buy", "item": id, "count": count, "unit_price": price, "before": before, "after": after})
		remaining -= count
		if failures == 0: await contribute_carried(id)
	check(remaining == 0, "all planned material was purchased through finite native transactions")

func finish() -> void:
	check(FileAccess.get_file_as_bytes(source) == source_bytes, "immutable earned input remains byte-identical")
	check(source_hashes() == frozen_sources, "candidate scripts remain unchanged throughout native production")
	var file := FileAccess.open(out.path_join("blueprint-ledger.json"), FileAccess.WRITE)
	if file != null: file.store_string(JSON.stringify({"source_before": frozen_sources, "source_after": source_hashes(),
		"transactions": transactions, "accepted": accepted, "full_drive_earned": false}, "\t"))
	await super.finish()
