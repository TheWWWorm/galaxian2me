extends SceneTree
## Declared memory-only boundary fixtures, NOT earned campaign progress.
## Loads the retained entry without modifying it; never writes a save.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
const Flight := preload("res://src/screens/flight_screen.gd")
const INPUT_SHA := "057d6c40a370f9889d0d81e8c5401db82a2361c6319e29cc901ae20fd57af344"
var app
var header := {}
var checks := 0
var failures := 0
var fixtures: Array = []
var events: Array = []

func _init() -> void:
	run.call_deferred()

func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)

func frames(n: int) -> void:
	for i in n:
		await physics_frame
		await process_frame

func freeze_entry(node: Node) -> void:
	if node is Flight:
		node.ready.connect(func(): node.set_physics_process(false), CONNECT_ONE_SHOT)

func fixture():
	var game := Game.new(app.library, app.catalogue)
	check(game.session.from_dict(header).is_empty(), "fixture accepts the unchanged earned entry schema")
	var space := Space.new(game)
	space.build()
	fixtures.append(space)
	return space

func dismiss() -> void:
	for i in 100:
		if not app.screen is Flight or app.screen.conversation == null: return
		app.screen.conversation.next_button.pressed.emit()
		await frames(1)
	check(false, "dialogue closes within its supplied line count")

func delivered(space) -> void:
	# A synthetic threshold pose isolates the transaction, never a live run.
	space.story.cast[0].pos.z = -9999
	space.story.step_scene(0)

func run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 1 or FileAccess.get_sha256(args[0]) != INPUT_SHA:
		push_error("Provide the independently accepted immutable C41 input.")
		quit(2)
		return
	header = JSON.parse_string(FileAccess.get_file_as_string(args[0]))
	app = Host.new()
	node_added.connect(freeze_entry)
	root.add_child(app)
	await frames(2)
	check(app.activate(str(header.content)), "original supplied content is available")
	for step in range(41, 46):
		var campaign = Game.new(app.library, app.catalogue).campaign
		print("FINAL SOURCE RECORD ", step, " ", JSON.stringify(campaign.step_record(step)))
		print("FINAL SOURCE DIALOGUE ", step, " ", JSON.stringify(campaign.dialogue(step, 1)))
	var geometry = fixture()
	var centre := Vector3(0, -4444, 0)
	var half := Vector3(13611, 30277, 13611)
	check(geometry.mothership.ai.centre == centre and geometry.mothership.ai.half == half,
		"mothership halves each original padded full dimension using integer truncation")
	for axis in 3:
		for sign_value in [-1.0, 1.0]:
			var inside := centre
			var face := centre
			var outside := centre
			inside[axis] += sign_value * (half[axis] - 1)
			face[axis] += sign_value * half[axis]
			outside[axis] += sign_value * (half[axis] + 1)
			check(geometry._inside_mothership(inside) and not geometry._inside_mothership(face)
				and not geometry._inside_mothership(outside), "strict original mothership face %d/%s" % [axis, sign_value])
	app.game = app._make_game()
	check(app.game.session.from_dict(header).is_empty(), "native screen fixture loads actual C41 resources in memory")
	app.show_flight()
	await frames(2)
	await dismiss()
	var flight = app.screen
	var story = flight.space.story
	check(not app.game.campaign.check(false, -1, 999999), "elapsed time cannot deliver the unarrived freighter")
	story.cast[0].pos.z = -10000
	story.step_scene(0)
	check(not story.complete, "delivery position threshold is strictly greater than minus ten thousand")
	delivered(flight.space)
	check(story.complete and story.cast[0].speed == 0 and not story.cast[0].combat_active,
		"delivery stops and transiently protects the living freighter")
	var resources: Dictionary = app.game.session.to_dict().duplicate(true)
	flight._physics_process(1.01)
	check(flight.conversation != null and flight.paused, "native delivery result opens the supplied paused dialogue")
	check(app.game.session.story_step == 41 and story.step == 41,
		"delivery does not advance the campaign before result acknowledgement")
	var has_timer: bool = story.has_method("escape_remaining_ms")
	check(has_timer, "native final escape countdown is implemented")
	if has_timer:
		check(story.escape_remaining_ms() == -1, "escape clock is not running during the delivery dialogue")
	var clock: int = story.clock
	flight._physics_process(99.0)
	check(story.clock == clock, "paused result does not consume flight or escape time")
	await dismiss()
	check(app.game.session.story_step == 42 and story.step == 42, "acknowledgement starts the supplied escape step once")
	check(int(app.game.session.flags.wormhole_station) == -1 and int(app.game.session.flags.wormhole_system) == -1,
		"source disabled portal sentinel prevents future re-entry without changing the return anchor")
	check(app.game.session.station_id == int(header.station) and app.game.session.in_void,
		"delivery acknowledgement neither teleports nor docks the player")
	check(app.game.session.credits == int(header.credits) and app.game.session.cargo == resources.cargo
		and app.game.session.equipment == resources.equipment and app.game.session.blueprints == resources.blueprints,
		"delivery invents no credits, ammunition, cargo or completed drive")
	if has_timer:
		check(story.escape_remaining_ms() == 60000 and not story.complete and not story.failed,
			"escape receives exactly sixty seconds measured from acknowledgement")
		if flight.has_method("_finish_final_delivery"): flight._finish_final_delivery()
		check(app.game.session.story_step == 42 and story.escape_remaining_ms() == 60000,
			"repeated delivery callback cannot advance or extend the countdown")
		flight.set_paused(true)
		flight._physics_process(99.0)
		check(story.escape_remaining_ms() == 60000, "ordinary Pause preserves the countdown")
		flight.set_paused(false)
		story.step_scene(60000)
		check(not story.failed and story.escape_remaining_ms() == 0 and not story.portal_escape_forbidden(),
			"exact sixty-second boundary is not expired under the source strict comparison")
		story.step_scene(1)
		check(story.failed and not story.complete and app.game.session.story_step == 42
			and not bool(app.game.session.story_mission.get("done", false)), "one millisecond past deadline fails and never wins or advances")
		check(story.portal_escape_forbidden(), "an expired escape cannot be recovered by a late portal crossing")
		check(flight.conversation != null and flight.paused, "native timeout presents a paused failure instead of silently continuing")
		check(flight.space.player.alive, "timeout is a mission failure, not invented projectile damage")
		var crossing = fixture()
		delivered(crossing)
		crossing.game.campaign.conclude()
		check(crossing.story.begin_final_escape(), "delivery can arm a distinct memory-only crossing fixture")
		crossing.story.step_scene(59999)
		crossing.player.pos = crossing.wormhole.pos
		crossing._collisions()
		check(crossing.portal_crossed and crossing.player.alive and crossing.game.session.story_step == 42,
			"a physical crossing before expiry is safe and does not prematurely advance the return mission")
		check(crossing.story.escape_remaining_ms() == -1, "crossed portal stops exposing the discarded world's timer")
		var expired = fixture()
		delivered(expired)
		expired.game.campaign.conclude()
		expired.story.begin_final_escape()
		expired.story.step_scene(60000)
		expired.player.pos = expired.wormhole.pos
		var expiry_pose: Vector3 = expired.player.pos
		expired.step(0.001, {"boost": true, "fire": true})
		check(expired.story.failed and expired.player.alive and not expired.portal_crossed
			and expired.player.pos == expiry_pose, "native timeout wins the frame before movement, weapons or portal collision")
		var premature = fixture()
		premature.player.pos = premature.wormhole.pos
		premature._collisions()
		check(not premature.player.alive and not premature.portal_crossed, "original unfinished41 premature crossing remains fatal")
	# Explicit return-world and elapsed-time fixtures isolate the second
	# result transaction. They are NOT physical escape evidence or saves.
	app.game = app._make_game()
	app.game.session.from_dict(header)
	app.game.campaign.advance()
	app.game.session.in_void = false
	app.show_flight()
	await frames(2)
	await dismiss()
	var returned = app.screen
	returned.flight_ms = 10000
	returned.story_poll = 2.0
	returned._physics_process(0.0)
	check(app.game.session.story_step == 42 and returned.conversation == null,
		"normal-space return still requires strictly more than ten flight seconds")
	returned.flight_ms = 10001
	returned.story_poll = 2.0
	returned._physics_process(0.0)
	check(app.game.session.story_step == 42 and returned.conversation != null,
		"Brent's return result waits for acknowledgement before advancing to Alioth")
	await dismiss()
	check(app.game.session.story_step == 43 and int(app.game.session.story_mission.station) == 98
		and app.game.session.credits == int(header.credits), "return result requests Alioth without paying its later ending reward")
	var ending := Game.new(app.library, app.catalogue)
	ending.session.from_dict(header)
	ending.session.story_step = 42 # terminal contract fixture only
	ending.campaign.advance()
	ending.session.in_void = false
	ending.dock(98)
	check(ending.session.story_step == 45 and ending.session.story_mission.is_empty(),
		"supplied Alioth epilogues settle into the empty terminal step")
	check(ending.pending_dialogue.size() == ending.campaign.dialogue(43, 1).size() + ending.campaign.dialogue(44, 1).size(),
		"both supplied epilogue conversations remain queued for native presentation")
	check(ending.session.credits == int(header.credits) + 40000,
		"terminal source effect pays exactly forty thousand credits once")
	var finished_state: Dictionary = ending.session.to_dict().duplicate(true)
	ending.campaign.on_dock(98)
	ending.campaign.conclude()
	ending.campaign.advance()
	check(ending.session.to_dict() == finished_state, "terminal repeated settlement cannot advance, halt or pay twice")
	var restored := Game.new(app.library, app.catalogue)
	check(restored.session.from_dict(JSON.parse_string(JSON.stringify(finished_state))).is_empty(),
		"terminal checkpoint shape validates without writing fixture files")
	restored.resume()
	check(restored.session.credits == int(header.credits) + 40000 and restored.session.story_step == 45,
		"cold terminal resume does not replay the final payment")
	check(app.save_attempts.is_empty(), "all boundary fixtures make zero save attempts")
	check(FileAccess.get_sha256(args[0]) == INPUT_SHA, "accepted C41 bytes remain unchanged")
	for space in fixtures: space.dispose()
	fixtures.clear()
	app.process_mode = Node.PROCESS_MODE_DISABLED
	app.queue_free()
	await frames(3)
	print("FINALE DELIVERY: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
