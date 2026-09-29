extends "res://tests/earned_capacity_run.gd"
## An earned preparation boundary, NOT a combat success fixture. COPY E36,
## use actual Hangar demount/sell/buy/mount controls and save their result.
## Every change is paid for from already owned equipment; no world edits.
const E36_SHA := "02568ed3e6000b9bfd0c92e1d10789a9cbc2d5deffae9b2139d18fed2912bb69"

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 2:
		source = args[0]
		out = args[1]
	_run.call_deferred()

func _run() -> void:
	if started: return
	started = true
	if source.is_empty() or out.is_empty() or not FileAccess.file_exists(source) or DirAccess.dir_exists_absolute(out):
		push_error("Provide earned E36 and a NEW isolated output directory.")
		quit(2)
		return
	root.size = Vector2i(1280, 800)
	DirAccess.make_dir_recursive_absolute(out)
	source_bytes = FileAccess.get_file_as_bytes(source)
	input_header = JSON.parse_string(source_bytes.get_string_from_utf8())
	input_step = int(input_header.story_step)
	app = TestApp.new()
	save_root = out.path_join("test-saves-%d" % Time.get_ticks_usec())
	app.disk_saves = save_root
	root.add_child(app)
	await frames(3)
	check(FileAccess.get_sha256(source) == E36_SHA, "exact earned E36 before any ordinary equipment trade")
	if failures > 0 or not app.activate(str(input_header.get("content", ""))):
		check(false, "valid earned supplied content is installed")
		await finish()
		return
	DirAccess.make_dir_recursive_absolute(app.save_path(0).get_base_dir())
	check(DirAccess.copy_absolute(source, app.save_path(0)) == OK, "COPY E36 into isolated native storage")
	check(DirAccess.copy_absolute(source, app.save_path(app.AUTOSAVE_SLOT)) == OK,
		"COPY original E36 into the isolated autosave slot so manual refitting cannot overwrite its predecessor")
	app.show_title()
	await frames(3)
	app.screen._load()
	await frames(2)
	press(app.screen.panel_holder.get_child(0).get_child(0).get_child(1), "title Load exact earned E36")
	await frames(3)
	var expected := input_header.duplicate(true)
	expected.erase("saved_at")
	check(app.screen is Station and snapshot() == expected and app.save_attempts.is_empty(),
		"native Load preserves all earned fields, with no repair, stock reroll or mission settlement")
	if failures > 0:
		await finish()
		return
	seen_screen = app.screen.get_instance_id()
	await shot("earned_refit_input")
	visited_offers.append({"station": app.game.session.station_id, "items": app.game.shelf().duplicate(true)})
	# Source Item.RACE is a station-stock restriction (Status.java:215),
	# not a ship-fitting restriction. This is the existing Vossk shelf.
	var purchases := [{"id": 2, "category": 0, "slot": 1},
		{"id": 52, "category": 3, "slot": 0}, {"id": 77, "category": 3, "slot": 3}]
	var cost := 0
	for purchase in purchases:
		var present := false
		for offer in app.game.shelf():
			if int(offer.id) == purchase.id and int(offer.count) > 0:
				present = true
				cost += int(offer.price)
		check(present, "desired item%d is already in the earned station's actual stock" % purchase.id)
	var available: int = app.game.session.credits
	for id in [87, 0, 51]: available += app.game.price_here(id)
	check(available >= cost, "three real equipment sales can fund all three already-stocked upgrades")
	for id in [87, 0, 51]:
		if failures > 0: break
		await demount_and_sell(id)
	for purchase in purchases:
		if failures > 0: break
		var before := snapshot()
		var price: int = app.game.price_here(purchase.id)
		await buy_and_mount(purchase.id, purchase.category, purchase.slot)
		if failures == 0:
			ledger.append({"kind": "buy_equipment", "station": app.game.session.station_id,
				"id": purchase.id, "count": 1, "price": price, "credit_delta": -price,
				"category": purchase.category, "slot": purchase.slot, "before": before, "after": snapshot()})
	if failures == 0:
		check_inventory_ledger()
		var after := snapshot()
		var frozen_before := expected.duplicate(true)
		var frozen_after := after.duplicate(true)
		for key in ["equipment", "credits", "markets"]:
			frozen_before.erase(key)
			frozen_after.erase(key)
		check(frozen_before == frozen_after,
			"refitting preserves EVERY other field: cargo, crystals, actual shield charge/hull/armor, campaign, reputation, blueprint and statistics")
		check(after.story_step == 36 and after.story_mission == expected.story_mission and not bool(after.story_mission.get("complete", false)),
			"combat preparation does not grant victory37 or docking38")
		# snapshot() uses JSON-number representation. Canonicalise the
		# expected value too; nested Dictionary equality distinguishes int
		# and float Variants even for the same equipment IDs/counts.
		var wanted = JSON.parse_string(JSON.stringify([
			[{"id": 8, "count": 1}, {"id": 2, "count": 1}], [{"id": 35, "count": 7}], [],
			[{"id": 52, "count": 1}, {"id": 71, "count": 1}, {"id": 56, "count": 1}, {"id": 77, "count": 1}]]))
		check(after.equipment == wanted,
			"actual fitting contains exactly the paid upgrades while preserving all seven finite EMP rockets")
		var stats := app.game.session.ship_stats()
		check(stats.shield == app.catalogue.attr(52, app.catalogue.A_SHIELD)
			and stats.steering == app.catalogue.attr(77, app.catalogue.A_HANDLING)
			and stats.max_hull == 250 and stats.cargo_capacity == 60,
			"native loadout derives shield and steering effects from supplied item attributes, not test bonuses")
		await shot("earned_combat_refit_fitted")
		if failures == 0:
			await save_checkpoint()
			check(saved_state(0) == snapshot(), "native manual save preserves all actual paid-for equipment and remaining funds")
			if failures == 0:
				check(DirAccess.copy_absolute(app.save_path(0), out.path_join("earned-combat-refit.json")) == OK,
					"retain the earned preparation save, not a manufactured combat result")
	check(FileAccess.get_file_as_bytes(source) == source_bytes, "original E36 remains byte-identical after every real trade")
	await finish()

func demount_and_sell(id: int) -> void:
	var category := -1
	var slot := -1
	for c in app.game.session.equipment.size():
		for i in app.game.session.equipment[c].size():
			var item = app.game.session.equipment[c][i]
			if item != null and int(item.id) == id:
				category = c
				slot = i
	check(category >= 0 and app.game.session.cargo_count(id) == 0, "sale item%d is genuinely owned once in a fitting slot" % id)
	if failures > 0: return
	var before := snapshot()
	var price: int = app.game.price_here(id)
	press(app.screen.menu.get_child(0), "Hangar to demount owned equipment")
	await frames(3)
	var tabs = app.screen.current_panel
	tabs.current_tab = 1
	await frames(3)
	var fitting = tabs.get_child(1)
	var index := slot
	for c in category: index += app.game.session.equipment[c].size()
	var rows: Array = fitting.slots_list.get_children().filter(func(n): return n is Button and not n.is_queued_for_deletion())
	if not press(rows[index], "select genuinely owned fitted item"): return
	await frames(2)
	if not press(named_button(fitting.detail, app.library.text(138)), "ordinary Demount to hold"): return
	await frames(3)
	check(totals(snapshot()) == totals(before) and app.game.session.cargo_count(id) == 1,
		"demount conserves the exact owned item before any sale")
	press(app.screen.menu.get_child(0), "Hangar trade for genuine demounted item")
	await frames(3)
	var shop = app.screen.current_panel.get_child(0)
	if not press(item_row(shop.hold_list, app.catalogue.item_name(id)), "select owned item in Hold"): return
	await frames(2)
	if not press(named_button(shop.detail, app.library.text(137)), "confirm normal equipment sale"): return
	await frames(3)
	check(app.game.session.cargo_count(id) == 0 and app.game.session.credits == int(before.credits) + price,
		"sale removes exactly one owned item and pays the real station quote")
	var transferred := false
	for offer in app.game.shelf():
		if int(offer.id) == id and int(offer.count) > 0 and int(offer.price) == price: transferred = true
	check(transferred, "sold equipment enters actual shop stock instead of disappearing or duplicating")
	if failures == 0:
		ledger.append({"kind": "sell_cargo", "station": app.game.session.station_id,
			"id": id, "count": 1, "price": price, "credit_delta": price,
			"category": category, "slot": slot, "before": before, "after": snapshot()})
	await shot("earned_refit_sale_%d" % id)
