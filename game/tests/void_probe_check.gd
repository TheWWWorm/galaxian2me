extends SceneTree
## Memory-only fixtures. These are not earned campaign inputs or play proofs.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
const Body := preload("res://src/flight/body.gd")
const Flight := preload("res://src/screens/flight_screen.gd")
var checks := 0
var failures := 0
func _init() -> void:
	run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)
func run() -> void:
	root.size = Vector2i(1280, 800)
	var app := Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		check(false, "supplied content installed")
		quit(1)
		return
	var game := Game.new(app.library, app.catalogue)
	game.new_game()
	game.session.story_step = 27
	game.campaign.advance()
	game.arrive(91)
	check(bool(app.catalogue.system(18).visible), "the supplied mission route is already visible, without a new unlock")
	app.game = game
	app.show_flight()
	var flight = app.screen
	flight.set_physics_process(false)
	var space = flight.space
	check(space.story != null and space.story.cast.size() == 5 and space.story.objective.is_empty(), "step twenty-eight creates five fighters without a destroy-all objective")
	var positioned := true
	for actor in space.story.cast:
		var offset: Vector3 = actor.pos - space.wormhole.pos
		positioned = positioned and actor.faction == 9 and actor.ship_index == 8
		for axis in 3: positioned = positioned and offset[axis] >= -20000 and offset[axis] <= 19999
	check(positioned, "fighters use the source portal-relative scatter and supplied hulls")
	for actor in space.story.cast: actor.alive = false
	space.story._check_objectives()
	check(not space.story.complete and not game.campaign.check(false, 91, 999999), "destroying all five fighters cannot complete the portal mission")
	var markets := JSON.stringify(game.session.markets)
	var credits: int = game.session.credits
	var attempts := app.save_attempts.size()
	space.player.hull -= 5
	var hull: int = space.player.hull + space.player.armor
	space.player.pos = space.wormhole.pos + Vector3(0, 0, 3000)
	space._collisions()
	check(game.session.story_step == 29 and game.session.in_void and app.screen is Flight, "physical step twenty-eight crossing advances exactly once into Void mission twenty-nine")
	check(game.session.ship.hull == hull and game.session.credits == credits and JSON.stringify(game.session.markets) == markets,
		"portal crossing preserves durability, money and markets without docking settlement")
	check(app.save_attempts.size() == attempts, "entry itself does not write an invented docking save")
	flight = app.screen
	flight.set_physics_process(false)
	space = flight.space
	var story = space.story
	check(story != null and story.cast.size() == 3, "real Void identity activates three source hunters")
	check(space.mothership != null and space.mothership.model == app.library.model_name(3337)
		and space.mothership.pos == Vector3.ZERO and space.mothership.kind == Body.Kind.MOTHERSHIP,
		"Void space contains the supplied mothership at the source origin")
	check(not space.station.visible and space.station.station_id == -1 and space.gate == null,
		"mothership does not expose a normal station or jump gate")
	space.target = space.mothership
	space.locked = false
	check(not story._triggered(0), "selecting the mothership without a completed scanner lock cannot launch the probe")
	space.locked = true
	check(story._triggered(0), "completed mothership target lock satisfies the source first-radio trigger")
	space._act_on_target()
	check(not space.autopilot and space.docking < 0, "acting on the mothership cannot start docking autopilot")
	check(space._inside_mothership(Vector3(0, -4444, 0)) and not space._inside_mothership(Vector3(100000, 0, 0)),
		"mothership collision bounds come from the supplied module table")
	story.clock = 17000
	story.fired[0] = true
	var before_basis: Basis = space.player.basis
	var before_pos: Vector3 = space.player.pos
	story._run_void_probe(0)
	check(story.stage == 1 and story.probe_visible and story.controls_locked and story.hud_hidden,
		"first radio starts the locked probe camera shot")
	check(story.probe_basis.is_equal_approx(before_basis) and story.probe_position == before_pos
		and story.camera_position.is_equal_approx(before_pos + before_basis.z * 16384.0 + before_basis.y * 1024.0),
		"probe and cinematic camera use the supplied player-relative transforms")
	var shot_hull: int = space.player.hull
	var shot_armor: int = space.player.armor
	space._harm(space.player, 1000000, 1000000, story.cast[0])
	check(space.player.hull == shot_hull and space.player.armor == shot_armor and space.player.alive,
		"cinematic protection preserves actual durability instead of replacing it")
	story._run_void_probe(100)
	check(story.probe_position.is_equal_approx(before_pos + before_basis.z * 300.0), "probe travels three source units per millisecond")
	flight.view.sync(0)
	check(flight.view.physics_interpolation_mode == Node.PHYSICS_INTERPOLATION_MODE_OFF,
		"manually presented camera and geometry do not receive a second physics interpolation")
	check(flight.hud._screen(flight.view.camera.global_position / flight.view.UNIT) == null,
		"HUD rejects the unprojectable camera plane")
	check(flight.view.probe_node != null and flight.view.probe_node.scale.is_equal_approx(Vector3.ONE * 0.1875),
		"native probe node uses the original model scale")
	story.finished[0] = true
	story.finished[1] = true
	story._run_void_probe(0)
	check(story.probe_started_at < 0 and story.objective.is_empty(), "first two radio acknowledgements cannot start or complete the scan timer")
	story.finished[2] = true
	story._run_void_probe(0)
	check(story.stage == 2 and story.probe_started_at == 17000 and story.probe_remaining_ms() == 180000,
		"third radio starts a fresh full three-minute countdown")
	check(not story.controls_locked and not story.hud_hidden and not story.probe_visible
		and not space.player.ai.has("probe_cinematic") and story.camera_mode == "chase",
		"countdown restores controls, HUD, damage and chase camera")
	flight.view.sync(0)
	check(flight.view.probe_node == null, "completed shot releases its native probe node")
	story.clock = 136999
	check(not story._triggered(3), "late Void radio cannot use time spent before the scan began")
	story.clock = 137000
	check(story._triggered(3), "late Void radio triggers at two minutes of actual scanning")
	story.clock = 197000
	story._check_objectives()
	check(not story.complete and not game.campaign.check(false, -1, 197000), "exactly three minutes is not greater than the original strict timer boundary")
	story.clock += 1
	story._check_objectives()
	check(story.complete and game.campaign.check(false, -1, 197001), "surviving beyond three minutes earns the result condition")
	check(game.session.story_step == 29, "objective completion alone does not skip its success dialogue")
	flight._finish_void_probe()
	check(game.session.story_step == 30 and game.session.in_void and int(game.session.story_mission.station) == 91,
		"result acknowledgement prepares the normal-world return mission without changing worlds")
	var saved: Dictionary = app.save_summary(app.AUTOSAVE_SLOT)
	check(int(saved.story_step) == 30 and bool(saved.in_void) and int(saved.ship.hull) == shot_hull + shot_armor,
		"native result autosave preserves the earned scan and real remaining durability")
	check(app.load_game(app.AUTOSAVE_SLOT).is_empty() and app.screen is Flight and app.game.session.in_void,
		"result checkpoint reload opens real Void flight, not a false station")
	app.screen.set_physics_process(false)
	check(int(app.game.session.ship.hull) == int(saved.ship.hull), "Void checkpoint reload grants no repair")
	var resumed = app.screen.space
	resumed.player.pos = resumed.wormhole.pos + Vector3(0, 0, 3000)
	resumed._collisions()
	check(not app.game.session.in_void and app.game.session.story_step == 30 and app.game.session.station_id == 91,
		"completed scan can physically return to station ninety-one without skipping its arrival goal")
	app.screen.set_physics_process(false)
	# A separate explicit premature-exit fixture; never saved as earned.
	var early_game := Game.new(app.library, app.catalogue)
	early_game.new_game()
	early_game.session.story_step = 28
	early_game.campaign.advance()
	early_game.session.in_void = true
	var early := Space.new(early_game)
	early.build()
	var events: Array = []
	early.event.connect(func(kind, _data): events.append(kind))
	early.player.pos = early.wormhole.pos + Vector3(0, 0, 3000)
	early._collisions()
	check(not early.player.alive and events.has("destroyed") and events.has("probe_escape_failed")
		and not events.has("wormhole_crossed") and early_game.session.story_step == 29,
		"premature portal exit fails the active scan instead of bypassing its countdown")
	early.dispose()
	app.queue_free()
	await process_frame
	await process_frame
	print("VOID PROBE: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
