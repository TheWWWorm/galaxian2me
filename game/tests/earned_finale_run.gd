extends "res://tests/earned_portal_escort_run.gd"
## COPY actual C41 -> protect actual810HP freighter -> timed physical exit
## -> real normal-space docking. NO assignments of progress or combat state.
const C41_SHA := "057d6c40a370f9889d0d81e8c5401db82a2361c6319e29cc901ae20fd57af344"
const FinalePilot := preload("res://tests/support/finale_pilot.gd")
const PickupObserver := preload("res://tests/support/cargo_pickup_observer.gd")
var final_pilot := FinalePilot.new()
var pickup_observers := {}
var final_events: Array = []
var lines_seen: Array = []
var crossed := false
var delivered_freighter := false
var final_checkpoint := {}
var native_outcome := "unfinished"

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 2:
		source = args[0]
		out = args[1]
	_run.call_deferred()

func _run() -> void:
	if started: return
	started = true
	if source.is_empty() or out.is_empty() or FileAccess.get_sha256(source) != C41_SHA or DirAccess.dir_exists_absolute(out):
		push_error("Provide accepted C41 and a NEW isolated finale directory.")
		quit(2)
		return
	root.size = Vector2i(1280, 800)
	DirAccess.make_dir_recursive_absolute(out)
	frozen_sources = source_hashes()
	source_bytes = FileAccess.get_file_as_bytes(source)
	header = JSON.parse_string(source_bytes.get_string_from_utf8())
	input_step = int(header.story_step)
	app = TestApp.new()
	save_root = out.path_join("test-saves-%d" % Time.get_ticks_usec())
	app.disk_saves = save_root
	node_added.connect(watch_flight_entry)
	node_added.connect(trace_flight_node)
	root.add_child(app)
	await frames(3)
	check(app.activate(str(header.content)), "accepted finale's supplied content is installed")
	DirAccess.make_dir_recursive_absolute(app.save_path(app.AUTOSAVE_SLOT).get_base_dir())
	check(DirAccess.copy_absolute(source, app.save_path(app.AUTOSAVE_SLOT)) == OK, "COPY immutable C41 into fresh isolated native storage")
	app.show_title()
	await frames(3)
	app.screen._load()
	await frames(2)
	press(app.screen.panel_holder.get_child(0).get_child(0).get_child(0), "title Load actual native C41 autosave")
	await frames(3)
	var expected := header.duplicate(true)
	expected.erase("saved_at")
	check(app.screen is Flight and snapshot() == expected and app.save_attempts.is_empty(),
		"native cold load preserves all earned resources and creates no save or reward")
	check(app.screen is Flight and app.screen.menu_paused and app.screen.space.clock == 0,
		"ordinary Pause freezes the real entry before its first simulation tick")
	if failures > 0:
		await finish()
		return
	last_kills = app.game.session.stat("kills")
	await shot("accepted_native_c41")
	app.screen.set_paused(false)
	for tick in 30000:
		frame += 1
		if app.screen is Flight:
			var flight = app.screen
			var story = flight.space.story
			# Window focus loss uses the ordinary pause menu. The isolated
			# unattended run resumes that menu, never advances a paused clock
			# or rewrites any simulation state to compensate for lost time.
			if flight.menu_paused and not flight.defeated:
				focus_resumes += 1
				print("FINAL FOCUS RESUME ", flight.space.clock)
				flight.set_paused(false)
			if flight.defeated or (story != null and story.failed):
				native_outcome = "native_failure"
				await shot("actual_finale_failure")
				check(false, "player and required freighter survive the real finale")
				break
			if flight.conversation != null:
				if app.game.session.story_step == 41 and story != null and story.complete:
					check(delivered_freighter and story.escape_remaining_ms() == -1,
						"real delivered result waits without using the sixty-second escape clock")
				if app.game.session.story_step == 42:
					check(crossed and not app.game.session.in_void, "Brent's result follows the actual physical escape")
				lines_seen.append({"step": app.game.session.story_step, "clock": flight.space.clock,
					"lines": app.game.campaign.dialogue(app.game.session.story_step, 1)})
				await clear_dialogue()
			if flight.space != null and flight.space.in_void:
				if flight.space.clock > 15000: await shot("actual_void_defense")
				if flight.space.shots_fired > 0: await shot("actual_finale_gunfire")
				if story != null and story.step == 42:
					await shot("actual_sixty_second_escape")
			else:
				await shot("actual_normal_space_return")
		elif app.screen is Station:
			await clear_dialogue()
			check(crossed and delivered_freighter and app.game.session.story_step == 43
				and not app.game.session.in_void, "real delivery, timed crossing and station docking earn the Alioth continuation")
			check(app.save_attempts == [app.AUTOSAVE_SLOT], "only the actual return docking writes a new native autosave")
			check(app.game.session.credits == int(header.credits)
				and app.game.session.stat("jobs") == int(header.stats.jobs)
				and app.game.session.stat("jumpgates") == int(header.stats.jumpgates),
				"finale return invents no reward, freelance completion or gate trip")
			check(pickups_reconcile(), "original cargo plus observed physical pickups exactly reconcile within the unchanged hold")
			check(snapshot().equipment == header.equipment and app.game.session.blueprints == header.blueprints,
				"finite loadout and unfinished drive survive the real finale")
			check(saved_state(app.AUTOSAVE_SLOT) == snapshot(), "actual return docking autosave contains the complete settled state")
			if failures == 0:
				var path := out.path_join("earned-finale-return.json")
				check(DirAccess.copy_absolute(app.save_path(app.AUTOSAVE_SLOT), path) == OK, "retain actual earned finale-return autosave")
				final_checkpoint = {"path": path, "sha256": FileAccess.get_sha256(path), "state": snapshot()}
				native_outcome = "earned_native43"
			await shot("actual_return_docked43")
			break
		await frames(1)
	if native_outcome == "unfinished": check(false, "bounded native attempt reaches docking or a recorded loss")
	check(FileAccess.get_file_as_bytes(source) == source_bytes, "accepted C41 remains byte-identical after the attempt")
	await finish()

func check_flight_entry(reference: WeakRef) -> void:
	super.check_flight_entry(reference)
	var flight = reference.get_ref()
	if flight == null: return
	final_pilot = FinalePilot.new()
	var pickup := PickupObserver.new()
	pickup.begin_world(flight.space)
	pickup_observers[flight.space.get_instance_id()] = pickup
	flight.space.event.connect(observe_pickups.bind(weakref(flight.space), pickup))
	sample_clock = -1000
	flight.controls.scripted = pilot.bind(reference)
	flight.space.event.connect(final_event.bind(reference))

func final_event(kind: String, data: Dictionary, reference: WeakRef) -> void:
	if kind not in ["escort_delivered", "final_escape_started", "final_escape_failed", "wormhole_crossed", "portal_arrival_finished", "docked", "destroyed"]: return
	var flight = reference.get_ref()
	if flight == null: return
	var space = flight.space
	var record := {"event": kind, "data": data.duplicate(true), "clock": space.clock,
		"player": Observation.fields(space.player), "native_observation": Observation.capture(space)}
	final_events.append(record)
	print("FINAL EVENT ", kind, " ", space.clock, " ", JSON.stringify(data))
	if kind == "escort_delivered":
		delivered_freighter = true
		check(space.story.cast[0].alive and space.story.cast[0].pos.z > -10000 and space.story.cast[0].speed == 0,
			"native forward flight physically delivers the living freighter to the source threshold")
	if kind == "final_escape_started":
		check(delivered_freighter and int(data.duration) == 60000 and space.story.escape_remaining_ms() == 60000,
			"actual result acknowledgement arms exactly sixty seconds")
	if kind == "wormhole_crossed":
		crossed = bool(data.get("from_void", false))
		check(crossed and int(data.get("step", -1)) == 42 and delivered_freighter
			and space.story.clock - space.story.escape_started_at <= 60000,
			"actual player crossing leaves Void42 before its deadline")

func pilot(reference: WeakRef) -> Dictionary:
	var flight = reference.get_ref()
	if flight == null: return {}
	var space = flight.space
	if pickup_observers.has(space.get_instance_id()): pickup_observers[space.get_instance_id()].observe(space)
	var before := Observation.capture(space)
	var controls := final_pilot.input(space)
	decisions_readonly = decisions_readonly and before == Observation.capture(space)
	decisions_observed += 1
	if space.clock - sample_clock >= 1000:
		sample_clock = space.clock
		var sample := {"clock": space.clock, "station": app.game.session.station_id, "step": app.game.session.story_step,
			"position": str(space.player.pos), "hull": space.player.hull, "armor": space.player.armor,
			"shield": space.player.shield, "controls": controls.duplicate(), "mode": final_pilot.mode,
			"shots": space.shots_fired, "cast": cast_state(space.story) if space.story != null else [],
			"native_observation": before, "policy_observation": var_to_str([Observation.fields(final_pilot),
				Observation.fields(final_pilot.combat), Observation.fields(final_pilot.combat.navigation), Observation.fields(final_pilot.navigation)])}
		samples.append(sample)
		if space.clock % 10000 < 1000:
			print("FINAL PILOT ", JSON.stringify({"clock": space.clock, "mode": final_pilot.mode,
				"hull": space.player.hull, "shield": space.player.shield,
				"guide_hull": space.story.cast[0].hull if space.story != null and not space.story.cast.is_empty() else -1,
				"guide_position": str(space.story.cast[0].pos) if space.story != null and not space.story.cast.is_empty() else "",
				"shots": space.shots_fired}))
	return controls

func observe_pickups(_kind: String, _data: Dictionary, reference: WeakRef, observer) -> void:
	var space = reference.get_ref()
	if space != null and space.game != null: observer.observe(space)

func pickup_summary() -> Dictionary:
	var result := {"totals": {}, "events": [], "errors": []}
	for observer in pickup_observers.values():
		result.events.append_array(observer.events)
		result.errors.append_array(observer.errors)
		for key in observer.totals:
			result.totals[key] = int(result.totals.get(key, 0)) + int(observer.totals[key])
	return result

func pickups_reconcile() -> bool:
	var summary := pickup_summary()
	var combined := PickupObserver.new()
	combined.totals = summary.totals
	combined.errors = summary.errors
	return combined.reconciles(header, snapshot(), int(app.game.session.ship_stats().cargo_capacity))

func finish() -> void:
	if native_outcome != "earned_native43" and app != null and app.game != null:
		check(pickups_reconcile(), "even a failed attempt accounts for physical pickups without inventing cargo")
	var file := FileAccess.open(out.path_join("finale-ledger.json"), FileAccess.WRITE)
	if file != null: file.store_string(JSON.stringify({"source_sha256": FileAccess.get_sha256(source),
		"native_outcome": native_outcome, "events": final_events, "dialogue": lines_seen,
		"checkpoint": final_checkpoint, "pickups": pickup_summary(), "source_hashes_before": frozen_sources,
		"source_hashes_after": source_hashes()}, "\t"))
	await super.finish()
