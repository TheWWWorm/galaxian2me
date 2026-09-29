extends "res://tests/earned_remote_blueprint_run.gd"
## Genuine finite-market sourcing. Only native UI and pilot inputs change play.
## No station/pose/cargo/credit/RNG assignments; incomplete routes remain partial.
const SUPPLY_SHA := "3acbd87af00f0fde3f044de2dd7b383f6a6e17cf78ed57a28dc5e78e4fbece19"
var stops: Array = []
var collected_products := 0
var run_kind := "earned"
var delivery_boundaries: Array = []

func remote_event(kind: String, data: Dictionary, reference: WeakRef, observer) -> void:
	if kind != "docked":
		super.remote_event(kind, data, reference, observer)
		return
	var flight = reference.get_ref()
	if flight == null: return
	check(observer != null and flight.space.completed_flight, "docking retires the old physics world before depot delivery")
	if observer == null: return
	# The normal screen's dock callback has already collected station products.
	# Compare that boundary explicitly; never label depot delivery as salvage.
	var before: Dictionary = JSON.parse_string(JSON.stringify(observer.previous))
	var after := snapshot()
	var pending: Dictionary = before.blueprints.get("85", {}).get("pending", {})
	var count := int(pending.get(str(int(data.station)), 0))
	var expected: Dictionary = before.cargo.duplicate(true)
	if count > 0: expected["85"] = int(expected.get("85", 0)) + count
	# Native snapshots normalize JSON numbers; compare matching value types.
	expected = JSON.parse_string(JSON.stringify(expected))
	check(after.cargo == expected and after.stats.cargo_salvaged == before.stats.cargo_salvaged,
		"only an already pending station product changes cargo at the physical docking boundary")
	delivery_boundaries.append({"before": before, "after": after, "collected": count, "station": int(data.station)})
	native_events.append({"kind": kind, "clock": flight.space.clock, "station": flight.space.station.station_id,
		"data": Observation.value(data), "native_observation": Observation.capture(flight.space)})
	print("MATERIAL DOCK BOUNDARY ", int(data.station), " collected=", count)

func _run() -> void:
	if started: return
	started = true
	node_added.connect(watch_flight_entry)
	node_added.connect(trace_flight_node)
	if not await start_host(SUPPLY_SHA): return
	last_native_kills = int(header.stats.kills)
	seen_screen = app.screen.get_instance_id()
	check(input_step == 45 and int(header.station) == 95 and int(header.credits) == 39236
		and app.game.session.cargo_used() == 25 and app.game.session.job.is_empty(),
		"material sourcing starts from the exact genuine remote-shipment checkpoint")
	# This route is selected from supplied station tech and gate links, not stock
	# previews or random seeds. Each new market is discovered only after docking.
	for sid in [99, 95, 70, 71, 72, 73, 74]:
		if failures > 0 or drive_completed(): break
		if not await visit(sid, sid != 95): break
	if failures == 0 and drive_completed():
		# Products finished remotely must really be collected at their origin.
		if app.game.session.system_index == 14:
			if app.game.session.station_id != 70: await visit(70, false)
			if failures == 0: await visit(95, false)
		if failures == 0 and app.game.session.station_id != 96: await visit(96, false)
	if failures == 0:
		check_travel_accounting()
		check(app.game.session.story_step == 45 and app.game.session.story_mission.is_empty()
			and app.game.session.job.is_empty() and snapshot().equipment == header.equipment
			and snapshot().flags == header.flags,
			"material sourcing preserves the completed story, flags and original fitted loadout")
		if drive_completed():
			check(collected_products == 1 and app.game.session.cargo_count(85) == 1
				and app.game.workshop.details(85).pending.is_empty(),
				"the remotely completed drive is collected exactly once by native origin docking")
		await open_blueprints()
		await shot("actual_material_final_recipe")
		if failures == 0: await save_checkpoint()
		if failures == 0:
			var path := out.path_join("earned-material-supply45.json")
			check(DirAccess.copy_absolute(app.save_path(0), path) == OK, "retain the actual UI-saved material result")
			accepted = {"path": path, "sha256": FileAccess.get_sha256(path), "state": snapshot()}
			await open_blueprints()
			await shot("actual_material_reloaded_recipe")
	await finish()

func drive_completed() -> bool:
	return int(app.game.session.blueprints["85"].get("produced", 0)) > int(header.blueprints["85"].get("produced", 0))

func visit(sid: int, purchase: bool) -> bool:
	if failures > 0: return false
	var before := snapshot()
	var first_event := native_events.size()
	if not await choose_destination(sid) or not await fly_to_dock(): return false
	check(app.screen is Station and app.game.session.station_id == sid
		and app.game.session.system_index == app.catalogue.system_of_station(sid),
		"real Map and physical flight reach the selected market %d" % sid)
	check(saved_state(app.AUTOSAVE_SLOT) == snapshot(), "arrival services and production collection settle before autosave")
	var expected_blueprints: Dictionary = before.blueprints.duplicate(true)
	var pending: Dictionary = expected_blueprints["85"].get("pending", {})
	var collected := int(pending.get(str(sid), 0))
	if collected > 0:
		pending.erase(str(sid))
		if pending.is_empty(): expected_blueprints["85"].erase("pending")
		collected_products += collected
	check(snapshot().blueprints == expected_blueprints and snapshot().credits == before.credits,
		"flight changes no production accounting except collecting an existing batch at its actual origin")
	check_travel_accounting()
	var row := {"station": sid, "before_flight": before, "arrival": snapshot(),
		"events": native_events.slice(first_event), "collected": collected,
		"shelf_before": app.game.shelf().duplicate(true), "transaction_start": transactions.size()}
	print("SUPPLY ARRIVAL ", sid, " ", JSON.stringify(app.game.shelf()))
	if failures == 0 and purchase and not drive_completed(): await source_available_materials()
	row.after = snapshot()
	row.transaction_end = transactions.size()
	stops.append(row)
	if failures == 0:
		await save_checkpoint()
		if failures == 0:
			var path := out.path_join("earned-material-stop-%02d.json" % stops.size())
			check(DirAccess.copy_absolute(app.save_path(0), path) == OK, "retain each genuinely earned market checkpoint")
			row.checkpoint = {"path": path, "sha256": FileAccess.get_sha256(path)}
	print("SUPPLY STOP ", sid, " credits=", app.game.session.credits, " recipe=", JSON.stringify(app.game.session.blueprints["85"]))
	return failures == 0

func source_available_materials() -> void:
	for id in [118, 125, 158, 163]:
		if failures > 0 or drive_completed(): return
		var need := 0
		for ingredient in app.game.workshop.details(85).ingredients:
			if int(ingredient.item) == id: need = int(ingredient.remaining)
		var entry: Dictionary = app.game._shelf_entry(id)
		if need <= 0 or int(entry.get("count", 0)) <= 0: continue
		var unit_cost := int(entry.price) + (10 if app.game.session.station_id != 96 else 0)
		var count := mini(need, mini(int(entry.count), int(app.game.session.credits / maxi(1, unit_cost))))
		if count <= 0 or app.game.session.cargo_free() <= 0: continue
		await buy_and_contribute(id, count)

func contribute_carried(id: int, _exercise_cancel := false) -> void:
	var panel = await open_blueprints()
	if panel == null or failures > 0: return
	press(item_row(panel.ingredients, app.catalogue.item_name(id)), "select actual purchased ingredient")
	await frames(2)
	press(named_button(panel.actions, "Max"), "contribute carried recipe quantity")
	await frames(2)
	var before := snapshot()
	var order: Dictionary = app.game.blueprint_offer(85, id, panel.amount)
	check(str(order.error).is_empty() and int(order.get("count", 0)) > 0
		and bool(order.get("remote", false)) and int(order.get("origin", -1)) == 96
		and int(order.get("fee", -1)) == int(order.get("count", 0)) * 10,
		"real order quotes finite carried material and the source ten-credit shipping fee")
	if failures > 0: return
	var text: String = app.library.text(142).replace("#S", app.catalogue.station_name(96)).replace("#C", Presentation.money(int(order.fee)))
	press(named_button(panel.actions, "Contribute"), "review material shipment")
	await frames(3)
	check(panel.confirmation.visible and panel.confirmation.dialog_text == text
		and panel.pending_order == order and snapshot() == before,
		"source shipping confirmation precedes every actual debit and recipe contribution")
	confirmations.append({"text": text, "order": order.duplicate(true), "state_before": before})
	await shot("actual_material_shipping_%02d" % transactions.size())
	if failures > 0: return
	press(panel.confirmation.get_ok_button(), "approve the real material shipment")
	await frames(3)
	var expected: Dictionary = before.duplicate(true)
	var key := str(id)
	var count := int(order.count)
	expected.cargo[key] = int(expected.cargo[key]) - count
	if int(expected.cargo[key]) == 0: expected.cargo.erase(key)
	expected.credits = int(expected.credits) - int(order.fee)
	var state: Dictionary = expected.blueprints["85"]
	state.progress[key] = int(state.progress.get(key, 0)) + count
	state.cost = int(state.cost) + int(order.unit_value) * count
	var complete := true
	var recipe: Dictionary = app.game.workshop.recipe(app.catalogue, 85)
	for ingredient in recipe:
		if int(state.progress.get(ingredient, 0)) != int(recipe[ingredient]): complete = false
	if complete:
		var pending: Dictionary = state.get("pending", {})
		pending["96"] = int(pending.get("96", 0)) + 1
		state.pending = pending
		state.produced = int(state.get("produced", 0)) + 1
		state.progress = {}
		state.cost = 0
		state.station = -1
		expected.stats.goods_produced = int(expected.stats.get("goods_produced", 0)) + 1
	expected = JSON.parse_string(JSON.stringify(expected))
	var after := snapshot()
	check(after == expected and panel.pending_order.is_empty() and not panel.confirmation.visible,
		"shipment changes exactly cargo, credits, recipe accounting and a genuinely completed pending batch")
	transactions.append({"kind": "contribute", "order": order, "before": before, "after": after, "completed": complete})
	await shot("actual_material_deposit_%02d" % transactions.size())

func check_travel_accounting() -> void:
	var cargo: Dictionary = header.cargo.duplicate(true)
	var salvaged := 0
	var valid := true
	for observer in observers.values():
		valid = valid and observer.errors.is_empty()
		for key in observer.totals:
			cargo[key] = int(cargo.get(key, 0)) + int(observer.totals[key])
			salvaged += int(observer.totals[key])
	var credits := int(header.credits)
	for transaction in transactions:
		var key := str(int(transaction.item)) if transaction.kind == "buy" else str(int(transaction.order.ingredient))
		var count := int(transaction.count) if transaction.kind == "buy" else -int(transaction.order.count)
		cargo[key] = int(cargo.get(key, 0)) + count
		if int(cargo[key]) == 0: cargo.erase(key)
		credits -= int(transaction.unit_price) * count if transaction.kind == "buy" else int(transaction.order.fee)
	if collected_products > 0: cargo["85"] = int(cargo.get("85", 0)) + collected_products
	cargo = JSON.parse_string(JSON.stringify(cargo))
	check(valid and snapshot().cargo == cargo and app.game.session.credits == credits
		and app.game.session.stat("cargo_salvaged") == int(header.stats.cargo_salvaged) + salvaged,
		"all earned cargo and credits reconcile with actual purchases, deposits, pickups and origin collection")
	check(app.game.session.stat("kills") == last_native_kills and app.game.session.stat("jobs") == int(header.stats.jobs)
		and app.game.session.stat("jumpgates") == int(header.stats.jumpgates) + gate_events.size(),
		"only observed native kills and gate crossings alter travel statistics")
	check(decisions > 0 and decisions_readonly and not native_events.is_empty(),
		"every actual flight used observation-only pilot decisions without pose or RNG changes")

func finish() -> void:
	check(FileAccess.get_file_as_bytes(source) == source_bytes, "immutable input remains byte-identical")
	check(source_hashes() == frozen_sources, "all candidate sources remain frozen throughout this native process")
	var pickups: Array = []
	for observer in observers.values(): pickups.append({"events": observer.events, "totals": observer.totals, "errors": observer.errors})
	var final := snapshot() if app != null and app.game != null else {}
	var ledger := {"kind": run_kind, "source_before": frozen_sources, "source_after": source_hashes(),
		"decisions": decisions, "decisions_readonly": decisions_readonly, "samples": samples,
		"events": native_events, "combat_events": combat_events, "pickups": pickups, "stops": stops,
		"transactions": transactions, "confirmations": confirmations, "collected_products": collected_products,
		"delivery_boundaries": delivery_boundaries,
		"accepted": accepted, "final_session": final}
	var file := FileAccess.open(out.path_join("material-supply-ledger.json"), FileAccess.WRITE)
	if file != null: file.store_string(JSON.stringify(ledger, "\t"))
	var report := {"kind": run_kind, "checks": checks, "failures": failures, "source": source,
		"source_sha256": FileAccess.get_sha256(source), "save_root": save_root,
		"final_session": final, "gate_events": gate_events, "travel_events": travel_events,
		"player_shots": shots, "player_hits": player_hits, "frames": frame}
	app.process_mode = Node.PROCESS_MODE_DISABLED
	app.queue_free()
	app = null
	await frames(3)
	file = FileAccess.open(out.path_join("report.json"), FileAccess.WRITE)
	if file != null: file.store_string(JSON.stringify(report, "\t"))
	print("EARNED MATERIAL SUPPLY: %d checks, %d failures" % [checks.size(), failures])
	quit(1 if failures else 0)
