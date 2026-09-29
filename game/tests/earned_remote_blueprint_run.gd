extends "res://tests/earned_blueprint_run.gd"
## COPY real partial production, fly to the actual market and ship paid cargo.
## The driver returns ordinary controls; observations never replace live state.
const BLUEPRINT_SHA := "d9c1940128ffdb4c23e3891e5c3d87030475c53ee97f320a15db8f2be0e78219"
const Transit := preload("res://tests/support/transit_pilot.gd")
const Observation := preload("res://tests/support/simulation_snapshot.gd")
const Pickup := preload("res://tests/support/cargo_pickup_observer.gd")
const Presentation := preload("res://src/presentation/ui.gd")
var controller := Transit.new()
var observers := {}
var decisions := 0
var decisions_readonly := true
var sampled_clock := -1000
var samples: Array = []
var native_events: Array = []
var combat_events: Array = []
var last_native_kills := 0
var arrival := {}
var confirmations: Array = []

func _run() -> void:
	if started: return
	started = true
	node_added.connect(watch_flight_entry)
	node_added.connect(trace_flight_node)
	if not await start_host(BLUEPRINT_SHA): return
	last_native_kills = int(header.stats.kills)
	check(input_step == 45 and int(header.station) == 96 and int(header.credits) == 39806
		and app.game.session.cargo_used() == 25 and app.game.session.job.is_empty(),
		"remote production starts only from the genuine paid partial blueprint")
	seen_screen = app.screen.get_instance_id()
	if failures == 0 and await choose_destination(95) and await fly_to_dock():
		check(app.screen is Station and app.game.session.station_id == 95 and app.game.session.system_index == 19,
			"native star travel and physical docking reach the actual remote market")
		check(saved_state(app.AUTOSAVE_SLOT) == snapshot(), "remote arrival is settled before its native docking autosave")
		arrival = snapshot()
		check(arrival.blueprints == header.blueprints and arrival.equipment == header.equipment
			and int(arrival.credits) == int(header.credits) and int(arrival.story_step) == 45
			and arrival.story_mission.is_empty() and arrival.job.is_empty(),
			"real flight does not produce a drive, spend shipping fees or replay ending rewards")
		check_travel_accounting()
		var path := out.path_join("earned-remote-arrival45.json")
		check(DirAccess.copy_absolute(app.save_path(app.AUTOSAVE_SLOT), path) == OK,
			"retain the actual arrival autosave before buying or shipping anything")
		await shot("actual_remote_market_arrival")
	if failures == 0:
		var entry: Dictionary = app.game._shelf_entry(160)
		check(int(entry.get("count", 0)) >= 10 and int(entry.get("price", -1)) == 47,
			"the retained remote shelf really offers at least ten Wolperite at47")
		if failures == 0: await buy_and_contribute(160, 10)
	if failures == 0:
		var session = app.game.session
		var state: Dictionary = session.blueprints["85"]
		check(session.credits == int(arrival.credits) - 570 and session.cargo == arrival.cargo,
			"ten actual Wolperite cost470 plus100 shipping, leaving no invented cargo")
		check(int(state.station) == 96 and int(state.cost) == 6417 and int(state.progress.get("160", 0)) == 10,
			"remote deposit retains Kalun Amir origin and records material value without charging it twice")
		check(session.cargo_count(85) == 0 and int(state.get("produced", 0)) == 0
			and state.get("pending", {}).is_empty() and session.stat("goods_produced") == 0,
			"genuinely partial remote production grants no finished item or production credit")
		check(saved_state(app.AUTOSAVE_SLOT) == arrival,
			"purchase and remote shipment leave the earned arrival autosave unchanged")
		await open_blueprints()
		await shot("actual_remote_blueprint_paid")
		if failures == 0: await save_checkpoint()
		if failures == 0:
			var path := out.path_join("earned-remote-blueprint45.json")
			check(DirAccess.copy_absolute(app.save_path(0), path) == OK, "retain the actual UI-saved remote shipment")
			accepted = {"path": path, "sha256": FileAccess.get_sha256(path), "state": snapshot()}
			await open_blueprints()
			await shot("actual_remote_blueprint_reloaded")
	await finish()

func contribute_carried(id: int, _exercise_cancel := false) -> void:
	var panel = await open_blueprints()
	if panel == null or failures > 0: return
	press(item_row(panel.ingredients, app.catalogue.item_name(id)), "select actually purchased remote material")
	await frames(2)
	press(named_button(panel.actions, "Max"), "maximum carried remote material")
	await frames(2)
	var before := snapshot()
	var order: Dictionary = app.game.blueprint_offer(85, id, panel.amount)
	check(str(order.error).is_empty() and id == 160 and int(order.get("count", 0)) == 10
		and bool(order.get("remote", false)) and not bool(order.get("first", true))
		and int(order.get("origin", -1)) == 96 and int(order.get("station", -1)) == 95
		and int(order.get("fee", -1)) == 100 and int(order.get("unit_value", -1)) == 47,
		"the real remote order quotes ten carried units,100 shipping and the original production station")
	if failures > 0: return
	var expected_text: String = app.library.text(142).replace("#S", app.catalogue.station_name(96)).replace("#C", Presentation.money(100))
	for attempt in 2:
		press(named_button(panel.actions, "Contribute"), "review the native remote shipment")
		await frames(3)
		check(panel.confirmation.visible and panel.confirmation.dialog_text == expected_text
			and snapshot() == before and panel.pending_order == order,
			"the supplied remote confirmation shows correct origin and fee before any state changes")
		confirmations.append({"attempt": attempt, "text": panel.confirmation.dialog_text,
			"order": order.duplicate(true), "state_before": snapshot(), "cancelled": attempt == 0})
		await shot("actual_remote_shipping_confirmation_%d" % attempt)
		if failures > 0: return
		if attempt == 0:
			press(panel.confirmation.get_cancel_button(), "No to remote shipment")
			await frames(3)
			check(not panel.confirmation.visible and panel.pending_order.is_empty() and snapshot() == before,
				"canceling remote shipment clears its pending quote without charging or consuming anything")
		else:
			press(panel.confirmation.get_ok_button(), "Yes to the actual100-credit shipment")
			await frames(3)
	var after := snapshot()
	var expected: Dictionary = before.duplicate(true)
	expected.cargo[str(id)] = int(expected.cargo[str(id)]) - 10
	if int(expected.cargo[str(id)]) == 0: expected.cargo.erase(str(id))
	expected.credits = int(expected.credits) - 100
	expected.blueprints["85"].progress[str(id)] = int(expected.blueprints["85"].progress.get(str(id), 0)) + 10
	expected.blueprints["85"].cost = int(expected.blueprints["85"].cost) + 470
	expected = JSON.parse_string(JSON.stringify(expected))
	check(after == expected and panel.pending_order.is_empty() and not panel.confirmation.visible,
		"approved remote shipment changes only ten cargo units,100credits and the exact recipe accounting")
	transactions.append({"kind": "contribute", "order": order, "before": before, "after": after})
	await shot("actual_remote_material_deposited")

func check_flight_entry(reference: WeakRef) -> void:
	super.check_flight_entry(reference)
	var flight = reference.get_ref()
	if flight == null: return
	controller = Transit.new()
	sampled_clock = -1000
	var observer := Pickup.new()
	observer.begin_world(flight.space)
	observers[flight.space.get_instance_id()] = observer
	flight.controls.scripted = pilot.bind(reference)
	flight.space.event.connect(remote_event.bind(reference, observer))

func remote_event(kind: String, data: Dictionary, reference: WeakRef, observer) -> void:
	var flight = reference.get_ref()
	if flight == null: return
	observer.observe(flight.space)
	if kind == "killed":
		var count: int = app.game.session.stat("kills")
		var body: Body = data.body
		combat_events.append({"clock": flight.space.clock, "before": last_native_kills, "after": count,
			"body": Observation.fields(body)})
		if count != last_native_kills:
			check(count == last_native_kills + 1 and body.hostile and not body.friendly and not body.alive,
				"each defensive kill is backed by an actually destroyed hostile")
		last_native_kills = count
	if kind not in ["gate", "jumped", "docked", "destroyed"]: return
	native_events.append({"kind": kind, "clock": flight.space.clock, "station": flight.space.station.station_id,
		"data": Observation.value(data), "native_observation": Observation.capture(flight.space)})
	print("REMOTE TRAVEL EVENT ", kind, " ", flight.space.clock, " station ", flight.space.station.station_id)

func pilot(reference: WeakRef) -> Dictionary:
	if not is_instance_valid(app) or app.is_queued_for_deletion(): return {}
	var flight = reference.get_ref()
	if flight == null: return {}
	var space = flight.space
	var observer = observers.get(space.get_instance_id())
	if observer != null: observer.observe(space)
	var goal: Body = space.station
	var sid := int(app.game.destination.get("station", -1))
	if sid >= 0 and sid != space.station.station_id:
		if app.catalogue.system_of_station(sid) != app.game.session.system_index: goal = space.gate
		else:
			for body in space.bodies:
				if body.kind == Body.Kind.STAR and body.station_id == sid: goal = body; break
	var before := Observation.capture(space)
	var controls: Dictionary = controller.input(space, goal)
	decisions += 1
	decisions_readonly = decisions_readonly and Observation.capture(space) == before
	if space.clock - sampled_clock >= 1000:
		sampled_clock = space.clock
		samples.append({"clock": space.clock, "station": space.station.station_id, "mode": controller.mode,
			"controls": controls.duplicate(), "native_observation": before})
	return controls

func check_travel_accounting() -> void:
	var gains := {}
	var valid := true
	for observer in observers.values():
		valid = valid and observer.errors.is_empty()
		for key in observer.totals: gains[key] = int(gains.get(key, 0)) + int(observer.totals[key])
	var cargo: Dictionary = header.cargo.duplicate(true)
	var total := 0
	for key in gains: cargo[key] = int(cargo.get(key, 0)) + int(gains[key]); total += int(gains[key])
	cargo = JSON.parse_string(JSON.stringify(cargo))
	check(valid and cargo == snapshot().cargo and total == app.game.session.stat("cargo_salvaged") - int(header.stats.cargo_salvaged),
		"every flight cargo change matches a consumed native payload and the salvage count")
	check(app.game.session.stat("kills") == last_native_kills and app.game.session.stat("jobs") == int(header.stats.jobs)
		and app.game.session.stat("jumpgates") == int(header.stats.jumpgates) + gate_events.size(),
		"travel statistics record only observed native kills and gates, not fabricated jobs")
	check(decisions > 0 and decisions_readonly and not travel_events.is_empty(),
		"actual star travel was flown using read-only input decisions, without pose or RNG assignments")

func finish() -> void:
	var pickups: Array = []
	for observer in observers.values(): pickups.append({"events": observer.events, "totals": observer.totals, "errors": observer.errors})
	var file := FileAccess.open(out.path_join("remote-shipping-ledger.json"), FileAccess.WRITE)
	if file != null: file.store_string(JSON.stringify({"source_before": frozen_sources, "source_after": source_hashes(),
		"decisions": decisions, "decisions_readonly": decisions_readonly, "samples": samples, "events": native_events,
		"combat_events": combat_events, "pickups": pickups, "arrival": arrival, "confirmations": confirmations,
		"transactions": transactions, "accepted": accepted, "full_drive_earned": false}, "\t"))
	await super.finish()
