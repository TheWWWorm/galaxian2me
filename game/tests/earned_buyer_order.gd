extends "res://tests/earned_drive_branches.gd"
## A copied earned save, real viewport clicks, finite shop purchases and
## ordinary flight inputs only. No fixture, seed or live resource assignments.
const STATION_INPUT_SHA := "5362f90336eddadf19ba0896d55458ae17e3d91ce7775ece515f82ff4e54ea0c"
var milestones := []
var market_visits := []
var dock_states := []
var source_route := []
var spent := 0
var delivered := 0
var order := {}

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 3: source = args[0]; out = args[1]; recorded_sha = args[2]
	branch = "buyer"
	_run.call_deferred()

func text_in(node: Node) -> String:
	var result: String = node.text + "\n" if node is Label else ""
	for child in node.get_children():
		if not child.is_queued_for_deletion(): result += text_in(child)
	return result

func _run() -> void:
	if started: return
	started = true
	if recorded_sha.length() != 64: quit(2); return
	node_added.connect(watch_flight_entry)
	if not await start_host(recorded_sha): return
	branch_start = snapshot(); fitted = snapshot()
	fitted_checkpoint = {"path": source, "sha256": recorded_sha, "state": fitted}
	check(input_step == 45 and not app.game.session.in_void and app.game.session.ship_stats().jump_drive,
		"buyer continuation starts from a genuine fitted-drive post-ending checkpoint")
	if app.game.session.job.is_empty():
		check(recorded_sha == STATION_INPUT_SHA, "fresh acceptance uses only the audited retained station offer")
		if failures == 0: await accept_buyer()
	else:
		order = snapshot().job.duplicate(true)
		check(int(order.kind) == 8 and int(order.item) == 149 and int(order.count) == 6
			and int(order.station) == 96 and int(order.reward) == 6350 and str(order.client) == "Nguyen Koenig",
			"resume preserves the actual native buyer order rather than replacing its terms")
	chosen_contract = order.duplicate(true)
	if failures > 0: await finish(); return
	if milestones.is_empty(): await save_native("accepted")
	var home := int(order.item) - 132
	var navigation = preload("res://src/simulation/navigation.gd")
	check(home == app.catalogue.attr(int(order.item), app.catalogue.A_ORIGIN)
		and navigation.known(app.game.session, app.catalogue, home),
		"the supplied regional-spirit rule selects its known home system without a market preview")
	for id in app.catalogue.system(home).stations:
		if app.catalogue.tech(int(order.item)) <= int(app.catalogue.station(int(id)).tech): source_route.append(int(id))
	print("BUYER SOURCE ROUTE ", JSON.stringify({"home": home, "system": app.catalogue.system_name(home), "stations": source_route}))
	# Already-earned shops are safe to inspect; never roll a hypothetical shelf.
	if app.game.session.system_index == home and app.game.session.cargo_count(int(order.item)) < int(order.count):
		await inspect_and_buy()
	for station_id in source_route:
		if failures > 0 or app.game.session.cargo_count(int(order.item)) >= int(order.count): break
		if station_id == app.game.session.station_id: continue
		await travel_to(station_id)
		if failures == 0: await inspect_and_buy()
		if failures == 0: await save_native("source_%d" % station_id)
	if failures == 0 and app.game.session.cargo_count(int(order.item)) >= int(order.count):
		await save_native("procured")
		await travel_to(int(order.station))
		if failures == 0:
			check(app.game.session.job.is_empty() and delivered == int(order.count),
				"actual physical client docking completes the purchased order")
			var talk := dialogue(app.screen)
			check(talk != null and str(talk.lines[0].name) == str(order.client),
				"real client debrief identifies the retained buyer")
			await shot("buyer_paid_debrief")
			if talk != null: await click_button(talk.next_button, "acknowledge actual buyer payment")
			if failures == 0: await save_native("completed")
			completed_contract = failures == 0
	elif failures == 0:
		print("BUYER PENDING: all bounded actual home-system visits exhausted; no stock was fabricated")
	if failures == 0:
		await click_button(app.screen.menu.get_child(3), "final native Missions")
		check(text_in(app.screen.current_panel).contains(app.library.text(141)) if completed_contract else
			text_in(app.screen.current_panel).contains("6 × " + app.catalogue.item_name(149)),
			"final Missions reflects the actual paid or still-pending order")
		await shot("buyer_final_missions")
	await finish()

func accept_buyer() -> void:
	await click_button(app.screen.menu.get_child(1), "open actual retained Space Lounge")
	var lounge = app.screen.current_panel
	order = normalized(app.game.lounge()[0].job)
	check(int(order.kind) == 8 and int(order.item) == 149 and int(order.count) == 6
		and int(order.reward) == 6350 and int(order.station) == 96,
		"the visible retained Nguyen offer is the recorded six-unit purchase")
	await click_button(lounge.list.get_child(0), "talk to retained Nguyen Koenig")
	check(text_in(lounge.detail).contains(app.catalogue.item_name(149)), "lounge displays the actual requested commodity")
	await shot("buyer_retained_offer")
	var before := snapshot()
	await click_button(named_button(lounge.detail, app.library.text(38)), "accept original buyer terms")
	var expected := before.duplicate(true)
	expected.job = order.duplicate(true)
	for market in expected.markets:
		if int(market.station) != int(order.station): continue
		market.lounge[0].erase("job")
		market.lounge[0].kind = 1
		market.lounge[0].speech = app.library.text(498)
	check(snapshot() == normalized(expected) and app.save_attempts.is_empty(),
		"native acceptance grants no goods, credits or completion and changes only the saved offer and job")
	transactions.append({"kind": "accept", "before": before, "after": snapshot(), "order": order})
	await click_button(app.screen.menu.get_child(3), "review accepted purchase in Missions")
	check(text_in(app.screen.current_panel).contains("6 × " + app.catalogue.item_name(149)),
		"Missions keeps the actual quantity and goods visible after the offer is consumed")
	await shot("buyer_accepted_missions")
	if failures == 0: await save_native("accepted")

func save_native(label: String) -> void:
	await save_checkpoint()
	if failures > 0: return
	var path := out.path_join("earned-buyer-" + label + "45.json")
	check(not FileAccess.file_exists(path) and DirAccess.copy_absolute(app.save_path(0), path) == OK,
		"preserve the genuine native buyer checkpoint: " + label)
	var record := {"stage": label, "path": path, "sha256": FileAccess.get_sha256(path), "state": snapshot()}
	milestones.append(record)
	accepted = record.duplicate(true)
	print("BUYER NATIVE CHECKPOINT ", JSON.stringify({"stage": label, "path": path, "sha256": record.sha256,
		"station": app.game.session.station_id, "credits": app.game.session.credits, "cargo": app.game.session.cargo_count(149)}))

func travel_to(station_id: int) -> void:
	check(app.screen is Station and app.game.session.station_id != station_id,
		"buyer leg begins at its genuine prior dock, not an assigned orbit")
	if failures > 0: return
	pilot_mode = "hold"
	chosen_station = station_id
	chosen_system = app.catalogue.system_of_station(station_id)
	preflight_saves = app.save_attempts.size()
	await click_button(app.screen.menu.get_child(2), "buyer procurement Map")
	var station = app.screen
	var map = station.current_panel
	var before := snapshot()
	await pointer_at(map.canvas.get_global_transform_with_canvas() * map._to_screen(map.canvas, app.catalogue.system(chosen_system)))
	check(map.selected_system == chosen_system, "pointer selects the supplied buyer-route system")
	await click_button(named_button(map.side, app.catalogue.station_name(station_id)), "choose buyer-route station")
	check(snapshot() == before and app.screen == station, "buyer route asks for confirmation before any travel")
	await click_button(named_button(map.side, app.library.text(38)), "confirm real buyer-route departure")
	check(app.screen is Flight and app.screen.space.using_jump_drive, "buyer route launches the fitted drive through the real station control")
	if failures > 0: return
	var origin = app.screen
	await await_drive(origin, false, "buyer_leg_%d_%d" % [dock_states.size(), station_id])
	if failures > 0: return
	check(snapshot().job == before.job and app.game.session.credits == int(before.credits),
		"drive arrival is not buyer settlement and cannot pay a reward")
	await physical_dock(station_id)

func physical_dock(station_id: int) -> void:
	pilot_mode = "dock"
	app.screen.controls.scripted = drive_input.bind(weakref(app.screen), observers.back())
	for tick in 16000:
		resume_focus()
		if app.screen is Station: break
		if app.screen is Flight and app.screen.defeated: break
		await frames(1)
	check(app.screen is Station and app.game.session.station_id == station_id,
		"ordinary read-only controls physically dock the buyer leg")
	if failures > 0: await shot("buyer_failed_dock_%d" % station_id); return
	check(saved_state(app.AUTOSAVE_SLOT) == snapshot(), "native docking autosave includes the completed transaction")
	if station_id == int(order.station) and app.game.session.job.is_empty(): delivered = int(order.count)
	dock_states.append({"station": station_id, "state": snapshot(), "autosave": saved_state(app.AUTOSAVE_SLOT)})
	check(events.back().kind == "docked" and events.filter(func(e): return e.kind == "docked").size() == dock_states.size(),
		"each retained visit follows exactly one genuine native docking event")
	var cargo: Dictionary = header.cargo.duplicate(true)
	var salvage := 0
	for observer in observers:
		check(observer.errors.is_empty(), "buyer flight pickup observer agrees with all native cargo transfers")
		for key in observer.totals:
			cargo[key] = int(cargo.get(key, 0)) + int(observer.totals[key])
			salvage += int(observer.totals[key])
	for transaction in transactions:
		if transaction.kind == "buy":
			var key := str(int(transaction.item))
			cargo[key] = int(cargo.get(key, 0)) + int(transaction.count)
	if delivered > 0:
		cargo[str(int(order.item))] = int(cargo.get(str(int(order.item)), 0)) - delivered
		if int(cargo[str(int(order.item))]) == 0: cargo.erase(str(int(order.item)))
	check(snapshot().cargo == normalized(cargo) and app.game.session.stat("cargo_salvaged") == int(header.stats.cargo_salvaged) + salvage,
		"every buyer-run cargo unit is inherited, actually bought, physically salvaged or exactly delivered")
	check(app.game.session.credits == int(header.credits) - spent + (int(order.reward) if delivered > 0 else 0)
		and app.game.session.stat("jobs") == int(header.stats.jobs) + (1 if delivered > 0 else 0),
		"only real shop debits and the one completed buyer reward alter credits and completed jobs")
	check(snapshot().flags == header.flags and snapshot().blueprints == header.blueprints and snapshot().equipment == header.equipment
		and app.game.session.story_step == 45 and app.game.session.story_mission.is_empty()
		and app.game.session.stat("jumpgates") == int(header.stats.jumpgates),
		"buyer travel preserves the closed ending, exact one-off production, fitted drive and gate count")
	check(decisions > 0 and decisions_readonly, "buyer pilot observes the world without mutating it")
	await shot("buyer_docked_%d" % station_id)

func inspect_and_buy() -> void:
	var entry := {}
	var shelf: Array = normalized(app.game.shelf())
	market_visits.append({"station": app.game.session.station_id, "shelf": shelf, "state": snapshot()})
	for item in shelf:
		if int(item.id) == int(order.item): entry = item
	print("BUYER ACTUAL SHELF ", JSON.stringify({"station": app.game.session.station_id, "entry": entry}))
	await click_button(app.screen.menu.get_child(0), "inspect genuinely visited Hangar shop")
	var tabs: TabContainer = app.screen.current_panel
	tabs.current_tab = 0
	await frames(3)
	var shop = tabs.get_child(0)
	if entry.is_empty() or int(entry.count) <= 0:
		await shot("buyer_no_stock_%d" % app.game.session.station_id)
		return
	var count := mini(int(order.count) - app.game.session.cargo_count(int(order.item)), int(entry.count))
	count = mini(count, mini(app.game.session.cargo_free(), int(app.game.session.credits / int(entry.price))))
	check(count > 0, "actual buyer goods fit the finite hold and budget")
	if failures > 0: return
	var row := item_row(shop.shelf_list, app.catalogue.item_name(int(order.item)))
	check(row != null, "the actual stocked commodity has a native shop row")
	if row == null: return
	# Scroll only the real Control; no gameplay data or market state is touched.
	var parent: Node = row.get_parent()
	while parent != null and not parent is ScrollContainer: parent = parent.get_parent()
	if parent is ScrollContainer: parent.ensure_control_visible(row)
	await frames(3)
	await click_button(row, "select actual Nesla Brandy stock")
	for unit in count - 1: await click_button(named_button(shop.detail, "+"), "increase finite buyer quantity")
	check(shop.amount == count, "shop control selects only the actual required affordable quantity")
	await shot("buyer_purchase_%d" % app.game.session.station_id)
	var before := snapshot()
	await click_button(named_button(shop.detail, "Buy"), "pay actual shelf price for buyer goods")
	var expected := before.duplicate(true)
	expected.credits = int(expected.credits) - count * int(entry.price)
	var key := str(int(order.item))
	expected.cargo[key] = int(expected.cargo.get(key, 0)) + count
	for market in expected.markets:
		if int(market.station) != int(before.station): continue
		for item in market.items:
			if int(item.id) == int(order.item): item.count = int(item.count) - count
	check(snapshot() == normalized(expected), "native purchase debits exact price and stock, adding exact cargo without early settlement")
	spent += count * int(entry.price)
	transactions.append({"kind": "buy", "item": int(order.item), "count": count, "unit_price": int(entry.price), "before": before, "after": snapshot()})
	await shot("buyer_bought_%d" % app.game.session.station_id)

func finish() -> void:
	var file := FileAccess.open(out.path_join("buyer-ledger.json"), FileAccess.WRITE)
	if file != null: file.store_string(JSON.stringify({"input_sha256": recorded_sha, "order": order,
		"route": source_route, "visits": market_visits, "milestones": milestones, "docks": dock_states,
		"spent": spent, "delivered": delivered, "completed": completed_contract, "transactions": transactions}, "\t"))
	await super.finish()
