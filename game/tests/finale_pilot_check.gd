extends SceneTree
## Declared memory-only policy geometries, not replay or earned progress.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
const Body := preload("res://src/flight/body.gd")
const Pilot := preload("res://tests/support/finale_pilot.gd")
const Snapshot := preload("res://tests/support/simulation_snapshot.gd")
var checks := 0
var failures := 0
func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)
func run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 1 or FileAccess.get_sha256(args[0]) != "057d6c40a370f9889d0d81e8c5401db82a2361c6319e29cc901ae20fd57af344":
		push_error("Provide immutable accepted C41 for memory-only policy checks.")
		quit(2)
		return
	var header: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(args[0]))
	var app := Host.new()
	root.add_child(app)
	await process_frame
	check(app.activate(str(header.content)), "supplied content is available")
	var game := Game.new(app.library, app.catalogue)
	check(game.session.from_dict(header).is_empty(), "fixture loads actual earned resources without inventing equipment")
	game.resume()
	var space := Space.new(game)
	space.rng.seed = 41 # declared fixture setup, before build
	space.build()
	# Synthetic snapshots isolate control decisions, never drive a live run.
	space.player.pos = Vector3(25000, -55000, -40000)
	space.story.cast[0].pos = Vector3(0, 0, -50000)
	for enemy in space.hostiles():
		enemy.pos = Vector3(100000, 100000, 100000)
		enemy.ai.target = null
	space.wormhole.pos = Vector3(-180000, 140000, 200000)
	var pilot := Pilot.new()
	var before := Snapshot.capture(space)
	var controls: Dictionary = pilot.input(space)
	check(before == Snapshot.capture(space), "late escort decision preserves every native field and RNG")
	check(pilot.mode == "stage_escape" and pilot.desired.y < -40000, "late unthreatened delivery stages below the hull instead of chasing remote fighters")
	check(not bool(controls.get("fire", false)) and not bool(controls.get("secondary", false)), "remote unengaged fighters provoke no invented shot or EMP")
	var enemy = space.hostiles()[0]
	enemy.pos = space.player.pos - Vector3(0, 0, 10000)
	enemy.basis = Body.facing(space.player.pos - enemy.pos)
	enemy.ai.target = space.player
	var nearby := space.player.pos + Vector3(0, 0, 10000)
	before = Snapshot.capture(space)
	var evaded := pilot.evasive_point(space, nearby)
	check(pilot.evading and evaded != nearby, "nearby loiter waypoint does not disable evasive steering")
	check(before == Snapshot.capture(space), "evasion observes aiming threat without modifying its target or projectile state")
	check(pilot.evasive_point(space, nearby, true) == nearby and not pilot.evading, "only a precise final portal intercept suppresses weaving")
	enemy.disabled = true
	check(pilot.evasive_point(space, nearby) == nearby and not pilot.evading, "disabled gun cannot trigger evasive policy")
	enemy.disabled = false
	enemy.ai.target = null
	check(pilot.evasive_point(space, nearby) == nearby, "an unengaged ship does not trigger targeted-fire evasion")
	enemy.pos = space.story.cast[0].pos + Vector3(20000, 0, 0)
	enemy.ai.target = space.story.cast[0]
	before = Snapshot.capture(space)
	pilot.input(space)
	check(pilot.mode.begins_with("protect_guide_"), "observed active attack on the guide overrides staging")
	check(before == Snapshot.capture(space), "guide defense still returns only ordinary controls")
	space.player.pos = Vector3(40000, 25000, -40000)
	var exit := Vector3(5000, -40000, 10000)
	var bypass := pilot.clear_mothership_course(space, exit)
	var centre: Vector3 = space.mothership.ai.centre
	var half: Vector3 = space.mothership.ai.half
	check(bypass.y < centre.y - half.y and AABB(centre - half, half * 2).intersects_segment(space.player.pos, bypass) == null,
		"blocked exit first follows a leg outside the real mothership box")
	space.player.pos = Vector3(25000, -55000, -22000)
	check(pilot.clear_mothership_course(space, exit) == exit, "below-hull escape takes the direct clear portal leg")
	space.story.failed = true
	check(pilot.input(space).is_empty(), "failed mission produces no further player controls")
	check(app.save_attempts.is_empty(), "policy fixtures write zero saves")
	space.dispose()
	app.queue_free()
	await process_frame
	await process_frame
	print("FINALE PILOT: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
