extends "res://tests/earned_khador_run.gd"
## COPY C33, visit real dealers, exchange an affordable hull, fit owned gear,
## buy a real drill and trade cargo. No generated offers or resource edits.
const C33_SHA := "cf1b478a661e3c5563b273609fe71110858a83e1f2eaaf3492ad45b1d2c4897f"
const IO_OMBAK_SHA := "8f080e82b8fdd1fc0cc7752f63b8d6c58d822c7253690e6c0f30eee5c7a83a61"
const INFLICT_SHA := "dd3af3bffad5723255c613caf1fea7d77a30dc8472e74c8b03347ce776398192"
var ledger: Array = []
var visited_offers: Array = []
var retained_stops := 0
var purchased_hull := false
var drill_stops := {}
var drill_destination := -1

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
		push_error("Provide earned C33 and a NEW isolated output directory.")
		quit(2)
		return
	root.size = Vector2i(1280, 800)
	DirAccess.make_dir_recursive_absolute(out)
	source_bytes = FileAccess.get_file_as_bytes(source)
	app = TestApp.new()
	save_root = out.path_join("test-saves-%d" % Time.get_ticks_usec())
	app.disk_saves = save_root
	node_added.connect(watch_flight_entry)
	node_added.connect(trace_flight_node)
	root.add_child(app)
	await frames(3)
	input_header = JSON.parse_string(source_bytes.get_string_from_utf8())
	check(FileAccess.get_sha256(source) in [C33_SHA, IO_OMBAK_SHA, INFLICT_SHA], "exact retained earned C33 lineage input hash")
	if failures > 0 or not app.activate(str(input_header.get("content", ""))):
		check(false, "valid earned content is installed")
		await finish()
		return
	input_step = int(input_header.story_step)
	DirAccess.make_dir_recursive_absolute(app.save_path(0).get_base_dir())
	check(DirAccess.copy_absolute(source, app.save_path(0)) == OK, "COPY C33 into fresh isolated storage")
	app.show_title()
	await frames(3)
	app.screen._load()
	await frames(2)
	press(app.screen.panel_holder.get_child(0).get_child(0).get_child(1), "title Load earned C33")
	await frames(3)
	var expected := input_header.duplicate(true)
	expected.erase("saved_at")
	check(app.screen is Station and snapshot() == expected and app.save_attempts.is_empty(),
		"native cold load preserves every original resource without resettlement")
	seen_screen = app.screen.get_instance_id()
	purchased_hull = FileAccess.get_sha256(source) == INFLICT_SHA
	await shot("c33_capacity_input")
	for visit in 24:
		if failures > 0 or purchased_hull: break
		var game = app.game
		visited_offers.append({"station": game.session.station_id, "credits": game.session.credits,
			"offers": game.dealer().duplicate(true), "items": game.shelf().duplicate(true)})
		print("ACTUAL DEALER ", JSON.stringify(visited_offers.back()))
		var choice := {}
		for offer in game.dealer():
			var hull: Dictionary = app.catalogue.ship(int(offer.index))
			if int(hull.cargo) < 55 or int(hull.equipment) < 4 or int(hull.primary) < 1: continue
			if int(offer.price) > game.session.credits + game.ship_value() - 4200: continue
			if choice.is_empty() or int(offer.price) < int(choice.price): choice = offer
		if not choice.is_empty():
			await exchange_ship(choice)
			break
		var stations: Array = app.catalogue.system(game.session.system_index).get("stations", [])
		var index := -1
		for i in stations.size():
			if int(stations[i]) == game.session.station_id: index = i
		check(index >= 0, "actual current station belongs to its supplied system")
		if failures > 0: break
		# Wolf-Reiser really has only Thynome. Aquila's already-known gate
		# is reachable; the drill home system Pan is still hidden in C33.
		var next := next_route_station(35) if stations.size() == 1 else int(stations[(index + 1) % stations.size()])
		if next < 0: break
		if not await choose_destination(next) or not await fly_to_dock(): break
		await retain_dock()
	check(purchased_hull, "affordable cargo hull is obtained from a physically visited real dealer")
	if failures == 0: await make_mining_room()
	if failures == 0:
		# Shop only in known, reachable systems. Home station8 is in hidden
		# Pan, so it is NOT a convenient shortcut or a visibility override.
		for trip in 16:
			if failures > 0: break
			var drill := -1
			var cheapest := 2147483647
			for entry in app.game.shelf():
				if int(entry.id) in [86, 87] and int(entry.count) > 0 and int(entry.price) <= app.game.session.credits and int(entry.price) < cheapest:
					drill = int(entry.id)
					cheapest = int(entry.price)
			if drill >= 0:
				var slot: int = app.game.session.equipment[3].find(null)
				check(slot >= 0, "purchased hull has a real spare slot for the drill")
				if slot >= 0:
					var before := snapshot()
					await buy_and_mount(drill, 3, slot)
					ledger.append({"kind": "buy_drill", "station": app.game.session.station_id, "id": drill,
						"count": 1, "credit_delta": app.game.session.credits - int(before.credits)})
				break
			drill_stops[app.game.session.station_id] = true
			if drill_destination < 0 or drill_destination == app.game.session.station_id:
				drill_destination = next_drill_shop()
			check(drill_destination >= 0, "known gate graph contains an unvisited qualifying drill shop")
			if drill_destination < 0: break
			var next := next_route_station(drill_destination)
			if next < 0 or not await choose_destination(next) or not await fly_to_dock(): break
			await retain_dock()
		check(app.game.session.has_equipped_type(app.catalogue.Type.MINING_LASER), "actual shop purchase and fitting provide a real mining drill")
	if failures == 0: await make_mining_room()
	if failures == 0:
		check(app.game.session.cargo_free() >= 52, "earned hold has room for fifty crystals and mining byproducts")
		check(app.game.session.story_step == 33 and app.game.session.cargo_count(164) == 0 and app.game.session.blueprints.is_empty(),
			"capacity preparation grants no crystals, blueprint or campaign progress")
		check_inventory_ledger()
		await save_checkpoint()
		check(DirAccess.copy_absolute(app.save_path(0), out.path_join("earned-capacity-ready.json")) == OK,
			"retain actual manual capacity checkpoint for next mining flight")
		await shot("earned_capacity_ready")
	check(FileAccess.get_file_as_bytes(source) == source_bytes, "original earned C33 remains byte-identical")
	await finish()

func clear_dialogue() -> void:
	for i in 100:
		var talk := dialogue(app.screen)
		if talk == null: return
		await shot("capacity_dialogue_%d_%d" % [app.game.session.station_id, talk.index])
		press(talk.next_button, "original dialogue Next")
		await frames(1)
	check(false, "dialogue terminates")

func pilot(reference: WeakRef) -> Dictionary:
	var flight = reference.get_ref()
	if flight == null: return {}
	var space = flight.space
	if space.story != null and space.story.controls_locked: return {}
	if space.docking >= 0 or space.jumping >= 0 or space.travelling >= 0: return {}
	# A dealer search is a transit flight, not an order to charge four
	# pirates. Turn to the real destination and use the normal target/warp
	# trigger promptly. Leave enemy strength and the finite rockets intact.
	var controls := navigation_input(space)
	controls.yaw = clampf(float(controls.get("yaw", 0.0)) * 3.0, -1.0, 1.0)
	controls.pitch = clampf(float(controls.get("pitch", 0.0)) * 3.0, -1.0, 1.0)
	controls.boost = true
	return controls

func retain_dock() -> void:
	if not app.screen is Station: return
	retained_stops += 1
	check(saved_state(app.AUTOSAVE_SLOT) == snapshot(), "actual dealer-search docking autosave preserves settled state")
	check(DirAccess.copy_absolute(app.save_path(app.AUTOSAVE_SLOT), out.path_join("earned-stop-%02d.json" % retained_stops)) == OK,
		"retain actual intermediate docking checkpoint")

func totals(state: Dictionary) -> Dictionary:
	var result := {}
	for key in state.cargo: result[key] = int(state.cargo[key])
	for category in state.equipment:
		for item in category:
			if item != null:
				var key := str(int(item.id))
				result[key] = int(result.get(key, 0)) + int(item.count)
	return result

func exchange_ship(offer: Dictionary) -> void:
	var before := snapshot()
	var price := int(offer.price)
	var value: int = app.game.ship_value()
	press(app.screen.menu.get_child(0), "Hangar real dealer")
	await frames(3)
	var tabs = app.screen.current_panel
	check(tabs.get_child_count() == 3, "visited station exposes its actual ship dealer")
	if failures > 0: return
	tabs.current_tab = 2
	await frames(3)
	var dealer = tabs.get_child(2)
	press(item_row(dealer.list, app.catalogue.ship_name(int(offer.index))), "select affordable real hull")
	await frames(3)
	await shot("actual_affordable_ship_offer")
	press(named_button(dealer.detail, "Buy this ship"), "choose actual hull exchange")
	await frames(2)
	# The original's question, "Do you really want to buy this ship?", answered yes.
	var asked: Array = dealer.find_children("*", "Control", true, false).filter(func(c): return c.get_script() == preload("res://src/presentation/ui.gd").Question and not c.is_queued_for_deletion())
	check(asked.size() == 1, "the dealer asks before the exchange")
	if asked.size() == 1: asked[0]._answer(true)
	await frames(4)
	var after := snapshot()
	check(int(after.ship.index) == int(offer.index) and int(after.credits) == int(before.credits) + value - price,
		"real dealer charges exact asking price less original trade-in")
	check(totals(after) == totals(before), "hull exchange preserves all owned cargo, modules and seven rockets")
	if failures > 0: return
	ledger.append({"kind": "ship_exchange", "station": app.game.session.station_id, "from": int(before.ship.index),
		"to": int(offer.index), "price": price, "trade_in": value, "credit_delta": value - price})
	tabs.current_tab = 1
	await frames(3)
	for category in 4:
		for slot in before.equipment[category].size():
			var item = before.equipment[category][slot]
			if item != null: await mount_owned(int(item.id), category, slot)
	# Fit the genuinely retained starter gun in a second primary slot where
	# the purchased hull supports it. Do not buy or duplicate an extra weapon.
	if app.game.session.equipment[0].size() > 1 and app.game.session.cargo_count(0) > 0:
		await mount_owned(0, 0, 1)
	check(totals(snapshot()) == totals(before), "all refitting conserves the combined hold and equipment inventory")
	check(tabs.get_child(1).ship_frame.title == app.catalogue.ship_name(int(offer.index)),
		"already-open fitting panel updates to the purchased hull name")
	check(int(app.game.session.equipment[1][0].id) == 35 and int(app.game.session.equipment[1][0].count) == 7,
		"all seven finite rockets are transferred and refitted normally")
	purchased_hull = failures == 0
	await shot("earned_larger_ship_refitted")
	await save_checkpoint()
	check(DirAccess.copy_absolute(app.save_path(0), out.path_join("earned-larger-ship.json")) == OK,
		"retain purchased and refitted ship before further travel")

func mount_owned(id: int, category: int, slot: int) -> void:
	var before := totals(snapshot())
	var tabs = app.screen.current_panel
	tabs.current_tab = 1
	await frames(2)
	var fitting = tabs.get_child(1)
	var index := slot
	for c in category: index += app.game.session.equipment[c].size()
	var rows: Array = fitting.slots_list.get_children().filter(func(n): return n is Button and not n.is_queued_for_deletion())
	if not press(rows[index], "select actual fitting slot"): return
	await frames(2)
	if not press(item_row(fitting.detail, app.catalogue.item_name(id)), "fit owned equipment"): return
	await frames(3)
	check(totals(snapshot()) == before and int(app.game.session.equipment[category][slot].id) == id,
		"fit owned item%d without creating or losing units" % id)

func make_mining_room() -> void:
	press(app.screen.menu.get_child(0), "Hangar trade for mining room")
	await frames(3)
	var shop = app.screen.current_panel.get_child(0)
	var keys: Array = app.game.session.cargo.keys().duplicate()
	keys.sort_custom(func(a,b): return int(a) < int(b))
	for key in keys:
		if app.game.session.cargo_free() >= 52: break
		var id := int(key)
		# The obsolete held armor55 may also be sold normally if a55t hull
		# needs its final tonne; fitted armor56 is never discarded.
		if (app.catalogue.category(id) != app.catalogue.Category.COMMODITY and id != 55) or not app.game.can_sell_cargo(id): continue
		var count: int = app.game.session.cargo_count(id)
		var price: int = app.game.price_here(id)
		var credits: int = app.game.session.credits
		if not press(item_row(shop.hold_list, app.catalogue.item_name(id)), "select genuine tradable cargo"): return
		await frames(2)
		press(named_button(shop.detail, "Max"), "sell actual cargo quantity")
		await frames(2)
		press(named_button(shop.detail, app.library.text(137)), "confirm ordinary cargo sale")
		await frames(3)
		check(app.game.session.cargo_count(id) == 0 and app.game.session.credits == credits + count * price,
			"normal sale removes actual item%d and pays its real station price" % id)
		ledger.append({"kind": "sell_cargo", "station": app.game.session.station_id, "id": id,
			"count": count, "price": price, "credit_delta": count * price})
	await shot("earned_mining_room_trade")

func next_drill_shop() -> int:
	var here: int = app.game.session.system_index
	var distances := {here: 0}
	var queue: Array = [here]
	while not queue.is_empty():
		var current := int(queue.pop_front())
		for value in app.catalogue.system(current).get("links", []):
			var next := int(value)
			var record: Dictionary = app.catalogue.system(next)
			var known: bool = bool(record.get("visible", false)) or app.game.session.visited_systems.has(str(next)) or app.game.session.unlocked_systems.has(str(next))
			if known and not distances.has(next):
				distances[next] = int(distances[current]) + 1
				queue.append(next)
	var selected := -1
	var score := 1000000
	# Previously visited shelves are real saved stock, not projected offers.
	# Prefer an affordable known drill over travelling blind to a home world.
	for market in app.game.session.markets:
		var id := int(market.station)
		if drill_stops.has(id) or not distances.has(app.catalogue.system_of_station(id)): continue
		for entry in market.items:
			if int(entry.id) in [86, 87] and int(entry.count) > 0 and int(entry.price) <= app.game.session.credits and int(entry.price) < score:
				selected = id
				score = int(entry.price)
	if selected >= 0: return selected
	score = 1000000
	for record in app.catalogue.data.stations:
		var id := int(record.id)
		var system := int(record.system)
		if drill_stops.has(id) or not distances.has(system) or int(record.tech) < 2 or int(record.tech) > 5: continue
		if int(app.catalogue.system(system).faction) == 1: continue
		var cost := int(distances[system]) * 100 + (0 if id == 55 else 1)
		if cost < score:
			selected = id
			score = cost
	return selected

func check_inventory_ledger() -> void:
	var expected := totals(input_header)
	var money := int(input_header.credits)
	for entry in ledger:
		money += int(entry.credit_delta)
		if entry.kind == "ship_exchange": continue
		var key := str(int(entry.id))
		var delta := int(entry.count) * (-1 if entry.kind == "sell_cargo" else 1)
		expected[key] = int(expected.get(key, 0)) + delta
		if expected[key] == 0: expected.erase(key)
	var actual := totals(snapshot())
	var additions := {}
	var gained := 0
	var conserved := true
	for key in expected:
		if int(actual.get(key, 0)) < int(expected[key]): conserved = false
	for key in actual:
		var delta := int(actual[key]) - int(expected.get(key, 0))
		if delta != 0: additions[key] = delta
		gained += delta
	var salvaged: int = app.game.session.stat("cargo_salvaged") - int(input_header.stats.get("cargo_salvaged", 0))
	check(app.game.session.credits == money, "all earned credit changes match the actual trade ledger")
	check(conserved and gained == salvaged and salvaged >= 0, "all combined inventory changes match purchases, sales and actual flight salvage")
	print("CAPACITY ACCOUNTING ", JSON.stringify({"ledger": ledger, "salvage": additions, "salvaged_delta": salvaged,
		"money": money, "hold": app.game.session.cargo_used(), "capacity": app.game.session.ship_stats().cargo_capacity}))

func finish() -> void:
	var file := FileAccess.open(out.path_join("capacity-ledger.json"), FileAccess.WRITE)
	if file != null: file.store_string(JSON.stringify({"transactions": ledger, "visited_offers": visited_offers}, "\t"))
	await super.finish()
