extends "res://tests/earned_drive_branches.gd"
## COPY the accepted native paid-crew continuation. This preparation uses
## real viewport pointer events, public catalogue locations and actual shops.
## No generated stock previews, state assignments, rewards or saved fixtures.
const RECOVERY_PARENT_SHA := "36ceb3fb85159fcd924ee195b1a5b02970f3537e70cbe001365f273d188ff836"
const RECOVERY_DOCK_SHA := "5d6d2de87ac161a1f2bfcc72a8cdb47b6bd52e5cc36306ead56f5aacc23d7d07"
const RECOVERY_GEAR_SHA := "aab023da902fbbf24382b9678b73b83c3abdcb6d932447937957722152b315d2"
const RECOVERY_SCOUT_SHA := "3cf539f48c1db18a6b2c2af7f48da6fec83587d6a16651c2341282729f756294"
const RecoveryNavigation := preload("res://src/simulation/navigation.gd")
var recovery_offer := {}
var preparation_checkpoints := []
var preparation_docks := []

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 3: source = args[0]; out = args[1]; recorded_sha = args[2]
	branch = "recovery-preparation"
	_run.call_deferred()

func _run() -> void:
	if started: return
	started = true
	node_added.connect(watch_flight_entry)
	if recorded_sha not in [RECOVERY_PARENT_SHA, RECOVERY_DOCK_SHA, RECOVERY_GEAR_SHA, RECOVERY_SCOUT_SHA]: quit(2); return
	if not await start_host(recorded_sha): return
	var shop_resumed := recorded_sha == RECOVERY_SCOUT_SHA
	var gear_resumed := recorded_sha in [RECOVERY_GEAR_SHA, RECOVERY_SCOUT_SHA]
	var resumed := recorded_sha != RECOVERY_PARENT_SHA
	check((resumed or (app.game.session.station_id == 95 and app.game.session.job.is_empty()))
		and app.game.session.credits == (20884 if gear_resumed else 30959) and app.game.session.story_step == 45,
		"preparation starts only from the recorded Gome C tactical-flight checkpoint")
	if resumed:
		recovery_offer = normalized(header.job)
		check(app.game.session.station_id == (15 if shop_resumed else 96) and int(recovery_offer.return_station) == 95
			and int(recovery_offer.station) == 97 and app.game.session.credits == (20884 if gear_resumed else 30959),
			"resume the independently reconciled physical docking without replaying acceptance or flight time")
	else:
		if failures == 0: await accept_recovery()
		if failures == 0: await retain_preparation("accepted")
	# Kalun Amir is an actually retained shelf, not a generated-stock preview.
	if failures == 0 and not resumed: await preparation_trip(96)
	if failures == 0 and not gear_resumed: await buy_equipment(68, 1)
	if failures == 0 and not gear_resumed: await buy_equipment(41, 6)
	if failures == 0 and not gear_resumed: await retain_preparation("tractor-ammunition")
	if failures == 0 and not await source_scanner():
		if failures == 0:
			await retain_preparation("scanner-pending")
			print("RECOVERY SCANNER PENDING: bounded real shops exhausted; no fabricated equipment or discovery")
		await finish(); return
	if failures == 0: await fit_equipment(1, 0, 41, -1)
	if failures == 0: await fit_equipment(3, 1, 82, 71)
	if failures == 0: await fit_equipment(3, 2, 68, 56)
	if failures == 0:
		var s = app.game.session
		check(normalized(s.job) == normalized(recovery_offer) and s.stat("jobs") == int(header.stats.jobs) and s.story_step == 45,
			"procurement keeps recovery pending and does not pay or reopen the closed campaign")
		check(s.has_equipped_type(app.catalogue.Type.SCANNER) and s.has_equipped_type(app.catalogue.Type.TRACTOR_BEAM)
			and int(s.equipment[1][0].id) == 41 and int(s.equipment[1][0].count) == 6,
			"actual UI purchases and fitting provide a cargo scanner, tractor and six paid EMP bombs")
		check(s.cargo_count(56) == 1 and s.cargo_count(71) == 1 and s.cargo_count(77) == 1
			and int(s.equipment[3][0].id) == 52 and int(s.equipment[3][3].id) == 85,
			"finite fitting keeps the shield and earned drive, storing armor and booster rather than adding slots")
		check(s.flags.get("wingmen", []) == header.flags.wingmen and int(s.flags.wingmen_remaining_ms) > 0
			and int(s.flags.wingmen_remaining_ms) == int(header.flags.wingmen_remaining_ms) - (s.playtime_ms - int(header.playtime_ms)),
			"the same two paid pilots retain only genuinely remaining flight time")
		await retain_preparation("prepared")
		await click_button(app.screen.menu.get_child(3), "prepared recovery Missions")
		await shot("recovery_prepared_missions")
		print("RECOVERY PREPARED ", JSON.stringify({"station": s.station_id, "credits": s.credits,
			"crew_ms": s.flags.wingmen_remaining_ms, "job": s.job, "equipment": s.equipment}))
	await finish()

func source_scanner() -> bool:
	var cat = app.catalogue
	# Resuming an already reached shop reads its persisted shelf only. No
	# additional visit, market generation, saved time or credit replay.
	for item in app.game.shelf():
		if int(item.id) == 82 and int(item.count) > 0:
			await buy_equipment(82, 1)
			return failures == 0
	var home: int = cat.attr(82, cat.A_HOME_STATION, -1)
	var home_system: int = cat.system_of_station(home)
	var home_known: bool = RecoveryNavigation.known(app.game.session, cat, home_system)
	check(home >= 0 and cat.attr(82, cat.A_SCAN_CARGO) == 1, "supplied Ecoscan supports cargo identification")
	var routes: Array = []
	if home_known: routes.append({"station": home, "score": -1, "tech": cat.station(home).tech})
	# Ordinary shop eligibility: tech3 Ecoscan fits stations3..7. This
	# filters PUBLIC map data only; not one future shelf or RNG is sampled.
	for system in cat.system_count():
		if not RecoveryNavigation.known(app.game.session, cat, system): continue
		for sid in cat.system(system).get("stations", []):
			var station_id := int(sid)
			var tech := int(cat.station(station_id).tech)
			if tech < 3 or tech > 7 or station_id in [int(recovery_offer.station), int(recovery_offer.return_station), home]: continue
			if header.markets.any(func(m): return int(m.station) == station_id): continue
			routes.append({"station": station_id, "tech": tech,
				"score": (0 if system == app.game.session.system_index else 1000) + tech * 10 + station_id})
	routes.sort_custom(func(a, b): return int(a.score) < int(b.score))
	print("RECOVERY PUBLIC SOURCING ", JSON.stringify({"home_known": home_known, "routes": routes}))
	var inspected := 0
	for route in routes:
		if inspected >= 4 or int(app.game.session.flags.get("wingmen_remaining_ms", 0)) < 120000: break
		await preparation_trip(int(route.station))
		if failures: return false
		inspected += 1
		await click_button(app.screen.menu.get_child(0), "inspect the actually reached scanner shop")
		var stock: Array = app.game.shelf()
		print("RECOVERY VISITED SHELF ", JSON.stringify({"station": app.game.session.station_id, "items": stock}))
		for item in stock:
			if int(item.id) == 82 and int(item.count) > 0 and int(item.price) <= app.game.session.credits:
				await buy_equipment(82, 1)
				return failures == 0
		await retain_preparation("scouted-%d" % int(route.station))
		if failures: return false
	return false

func accept_recovery() -> void:
	await click_button(app.screen.menu.get_child(1), "real Gome C Lounge")
	var index := -1
	for i in app.game.lounge().size():
		var person: Dictionary = app.game.lounge()[i]
		if person.has("job") and int(person.job.kind) == 3 and str(person.name) == "Amaror": index = i
	check(index >= 0, "Amaror's actual retained document recovery offer exists")
	if failures: return
	var lounge = app.screen.current_panel
	await click_button(lounge.list.get_child(index), "actual Amaror recovery briefing")
	await shot("recovery_actual_briefing")
	var before := snapshot()
	recovery_offer = normalized(app.game.lounge()[index].job)
	recovery_offer.return_station = int(before.station)
	await click_button(named_button(lounge.detail, app.library.text(38)), "accept actual offered recovery")
	check(normalized(app.game.session.job) == normalized(recovery_offer) and app.game.session.credits == int(before.credits)
		and snapshot().cargo == before.cargo and snapshot().flags == before.flags,
		"visible acceptance stores the actual client origin without granting cargo, money or hire time")
	await click_button(app.screen.menu.get_child(3), "accepted recovery Missions")
	await shot("recovery_accepted_missions")

func preparation_trip(station_id: int) -> void:
	var before := snapshot()
	preflight_saves = app.save_attempts.size()
	pilot_mode = "hold"
	await click_button(app.screen.menu.get_child(2), "equipment sourcing Map")
	var map = app.screen.current_panel
	var system: int = app.catalogue.system_of_station(station_id)
	check(map._known(system), "source destination is genuinely discovered before any map interaction")
	if failures: return
	await pointer_at(map.canvas.get_global_transform_with_canvas() * map._to_screen(map.canvas, app.catalogue.system(system)))
	await shot("recovery_map_pick_%d" % station_id)
	check(map.selected_system == system, "real pointer selects the equipment source's supplied system")
	if failures: return
	await click_button(named_button(map.side, app.catalogue.station_name(station_id)), "actual equipment-source station")
	await click_button(named_button(map.side, app.library.text(38)), "confirm equipment sourcing departure")
	check(app.screen is Flight and app.screen.space.using_jump_drive, "source trip begins a native fitted-drive flight")
	if failures: return
	await await_drive(app.screen, false, "recovery_source_%d" % station_id)
	if failures: return
	pilot_mode = "dock"
	app.screen.controls.scripted = drive_input.bind(weakref(app.screen), observers.back())
	for tick in 16000:
		resume_focus()
		if app.screen is Station or (app.screen is Flight and app.screen.defeated): break
		await frames(1)
	check(app.screen is Station and app.game.session.station_id == station_id,
		"ordinary read-only steering earns physical docking at equipment source %d" % station_id)
	if failures: await shot("recovery_sourcing_failed_%d" % station_id); return
	await frames(3)
	check(saved_state(app.AUTOSAVE_SLOT) == snapshot(), "source docking autosaves its actual native result")
	check(normalized(app.game.session.job) == normalized(recovery_offer) and app.game.session.credits == int(before.credits)
		and app.game.session.stat("jobs") == int(before.stats.jobs), "equipment-source docking cannot settle the still unretrieved contract")
	check(decisions_readonly and observers.all(func(observer): return observer.errors.is_empty()),
		"sourcing controller never writes live state and every physical pickup reconciles")
	preparation_docks.append(snapshot())
	await shot("recovery_sourcing_docked_%d" % station_id)

func buy_equipment(id: int, count: int) -> void:
	var entry: Dictionary = {}
	for item in app.game.shelf():
		if int(item.id) == id: entry = item
	check(not entry.is_empty() and int(entry.get("count", 0)) >= count,
		"requested equipment exists on the actually visited shelf: %d" % id)
	if failures: return
	var price := int(entry.price)
	check(app.game.session.credits >= price * count and app.game.session.cargo_free() >= count,
		"actual finite budget and hold cover the equipment purchase")
	if failures: return
	await click_button(app.screen.menu.get_child(0), "actual equipment Hangar shop")
	var shop = app.screen.current_panel.get_child(0)
	await click_button(item_row(shop.shelf_list, app.catalogue.item_name(id)), "exact supplied equipment row")
	print("RECOVERY SELECTED ROW ", JSON.stringify({"requested": id, "selected": shop.selected, "side": shop.selected_side}))
	await shot("recovery_selected_%d" % id)
	check(shop.selected == id and shop.selected_side == 0, "real pointer actually selects the exact visible shelf item")
	if failures: return
	for i in count - 1: await click_button(named_button(shop.detail, "+"), "actual ammunition quantity")
	check(shop.amount == count, "visible purchase quantity is the requested finite amount")
	var before := snapshot()
	await shot("recovery_purchase_%d" % id)
	await click_button(named_button(shop.detail, "Buy"), "pay the actual visited-shelf price")
	if failures: return
	var expected := before.duplicate(true)
	expected.credits = int(expected.credits) - price * count
	expected.cargo[str(id)] = int(expected.cargo.get(str(id), 0)) + count
	for market in expected.markets:
		if int(market.station) != int(before.station): continue
		for item in market.items:
			if int(item.id) == id: item.count = int(item.count) - count
	check(snapshot() == normalized(expected), "equipment purchase changes only exact credits, stock and acquired units")
	transactions.append({"kind": "buy", "item": id, "count": count, "unit_price": price, "before": before, "after": snapshot()})

func fit_equipment(category: int, slot: int, id: int, previous: int) -> void:
	await click_button(app.screen.menu.get_child(0), "native recovery fitting Hangar")
	var tabs: TabContainer = app.screen.current_panel
	var bar := tabs.get_tab_bar()
	await pointer_at(bar.get_global_transform_with_canvas() * bar.get_tab_rect(1).get_center())
	check(tabs.current_tab == 1, "pointer opens the actual ship-fitting tab")
	if failures: return
	var fitting = tabs.get_child(1)
	var row_index := slot
	for c in category: row_index += app.game.session.equipment[c].size()
	var rows: Array = fitting.slots_list.get_children().filter(func(node): return node is Button and not node.is_queued_for_deletion())
	await click_button(rows[row_index], "real finite equipment slot")
	var before := snapshot()
	if previous >= 0:
		check(int(app.game.session.equipment[category][slot].id) == previous, "demount only the recorded replaceable device")
		await click_button(named_button(fitting.detail, app.library.text(138)), "demount into existing cargo capacity")
		var demounted := before.duplicate(true)
		demounted.equipment[category][slot] = null
		demounted.cargo[str(previous)] = int(demounted.cargo.get(str(previous), 0)) + 1
		if previous == 56:
			# Saved hull includes remaining plate. Normal demount removes
			# that protection; it is not a repair or a lost base-hull point.
			demounted.ship.hull = int(before.ship.hull) - int(before.ship.armor)
			demounted.ship.armor = 0
		check(snapshot() == normalized(demounted), "demount stores the device and removes only its actual armor, without repair")
		transactions.append({"kind": "demount", "item": previous, "slot": slot, "category": category, "before": before, "after": snapshot()})
	before = snapshot()
	var count: int = app.game.session.cargo_count(id)
	await click_button(item_row(fitting.detail, app.catalogue.item_name(id)), "mount only the actually purchased equipment")
	check(int(app.game.session.equipment[category][slot].id) == id and app.game.session.cargo_count(id) == 0,
		"native fitting consumes only its real held item stack")
	check(app.game.session.credits == int(before.credits) and int(app.game.session.equipment[category][slot].count) == count,
		"fitting grants no credits or extra ammunition")
	var mounted := before.duplicate(true)
	mounted.cargo.erase(str(id))
	mounted.equipment[category][slot] = {"id": id, "count": count}
	check(snapshot() == normalized(mounted), "mount changes only the actual held stack and selected finite slot")
	transactions.append({"kind": "fit", "item": id, "slot": slot, "category": category, "before": before, "after": snapshot()})
	await shot("recovery_fitted_%d" % id)

func retain_preparation(stage: String) -> void:
	await save_checkpoint()
	if failures: return
	var path := out.path_join("earned-recovery-%s45.json" % stage)
	check(DirAccess.copy_absolute(app.save_path(0), path) == OK, "retain actual UI-saved recovery stage: " + stage)
	accepted = {"path": path, "sha256": FileAccess.get_sha256(path), "state": snapshot()}
	preparation_checkpoints.append(accepted.duplicate(true))
	print("RECOVERY CHECKPOINT ", JSON.stringify({"stage": stage, "path": path, "sha256": accepted.sha256}))

func click_button(button: Button, label: String) -> void:
	if button == null or button.disabled or not button.is_visible_in_tree():
		await super.click_button(button, label)
		return
	# Control.is_visible_in_tree does not account for ScrollContainer clipping.
	# Scroll with ordinary input instead of dispatching a click off-screen or
	# assigning a hidden selected item/scroll offset in the application.
	var ancestor := button.get_parent()
	while ancestor != null:
		if ancestor is ScrollContainer:
			for attempt in 48:
				# Keep the full row clear of themed padding and the bottom
				# clipping edge, not just one point inside the outer frame.
				var clip: Rect2 = ancestor.get_global_rect().grow(-40.0)
				var at := button.get_global_rect().get_center()
				if clip.has_point(at): break
				var before := snapshot()
				var pointer := clip.get_center()
				var motion := InputEventMouseMotion.new()
				motion.position = pointer; motion.global_position = pointer
				Input.parse_input_event(motion)
				var event := InputEventMouseButton.new()
				event.position = pointer; event.global_position = pointer
				event.button_index = MOUSE_BUTTON_WHEEL_DOWN if at.y > clip.end.y else MOUSE_BUTTON_WHEEL_UP
				event.pressed = true; event.factor = 1.0
				Input.parse_input_event(event); Input.flush_buffered_events()
				event = event.duplicate(); event.pressed = false
				Input.parse_input_event(event); Input.flush_buffered_events()
				await frames(6)
				check(snapshot() == before, "ordinary list scrolling does not alter saved game state")
				dispatched.append({"kind": "wheel", "button": event.button_index, "position": [pointer.x, pointer.y], "label": label})
			check(ancestor.get_global_rect().grow(-40.0).has_point(button.get_global_rect().get_center()),
				"requested pointer control is actually inside its visible scroll viewport")
			if failures: return
		ancestor = ancestor.get_parent()
	check(Rect2(Vector2.ZERO, Vector2(root.size)).has_point(button.get_global_rect().get_center()),
		"requested pointer control is inside the actual native window")
	if failures: return
	await super.click_button(button, label)

func finish() -> void:
	var file := FileAccess.open(out.path_join("recovery-ledger.json"), FileAccess.WRITE)
	if file != null: file.store_string(JSON.stringify({"offer": recovery_offer, "checkpoints": preparation_checkpoints,
		"docks": preparation_docks, "accepted": accepted, "earned_retrieval": false, "earned_delivery": false}, "\t"))
	await super.finish()
