extends SceneTree
## Synthetic no-save controller test, including native movement and pull.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
const Pilot := preload("res://tests/support/portal_escort_pilot.gd")
var checks := 0
var failures := 0

func _init() -> void:
	run.call_deferred()

func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	var game := Game.new(app.library, app.catalogue)
	game.new_game()
	game.session.story_step = 40
	game.session.story_mission = game.campaign.mission_from(game.campaign.step_record(40).missions[0])
	game.session.station_id = 91
	game.session.system_index = 18
	game.session.flags.wormhole_station = 91
	game.session.flags.wormhole_system = 18
	var space := Space.new(game)
	space.build()
	var pilot := Pilot.new()
	var portal: Vector3 = space.wormhole.pos
	space.player.pos = portal - Vector3(0, 0, 70000)
	space.player.basis = Basis.IDENTITY
	var state := JSON.stringify(game.session.to_dict())
	var position: Vector3 = space.player.pos
	var proposal := {"yaw": 0.1, "pitch": -0.2, "fire": true, "boost": true}
	var result := pilot.guard(space, proposal)
	check(bool(result.fire) and result.yaw == proposal.yaw and result.pitch == proposal.pitch,
		"a distant enemy near the portal no longer cancels an otherwise valid shot or approach")
	check(not bool(result.boost), "incoming boost is released before a tight portal approach")
	check(proposal.boost and proposal.fire, "guard does not mutate its caller's proposed controls")
	check(space.player.pos == position and JSON.stringify(game.session.to_dict()) == state,
		"controller evaluation writes no world state or earned resource")
	space.player.pos = portal - Vector3(0, 0, 42000)
	result = pilot.guard(space, proposal)
	check(pilot.retreating and not bool(result.boost) and result.fire,
		"near-portal entry turns outward without firing an incoming booster or deleting a safe shot")
	space.player.basis = Basis(Vector3.UP, PI)
	result = pilot.guard(space, proposal)
	check(pilot.retreating and bool(result.boost), "outward-aligned recovery may use the fitted booster normally")
	space.player.pos = portal - Vector3(0, 0, 59000)
	pilot.guard(space, proposal)
	check(not pilot.retreating, "recovery releases only beyond its separate exit radius")
	# Isolate portal-flight mechanics: no test enemies fire and no random
	# rocks obstruct the course. This synthetic field is never a save input.
	space.bodies.assign([space.player, space.story.cast[0], space.wormhole])
	space.player.pos = portal - Vector3(0, 0, 70000)
	space.player.basis = Basis.IDENTITY
	var minimum := INF
	for tick in 3000:
		var approach: Dictionary = pilot.navigation.steer(space, portal, true, false)
		space.step(1.0 / 60.0, pilot.guard(space, approach))
		minimum = minf(minimum, space.player.pos.distance_to(portal))
		if not space.player.alive or space.portal_crossed: break
	print("GUARD MINIMUM DISTANCE ", minimum)
	check(space.player.alive and not space.portal_crossed and minimum > 8192.0,
		"48 seconds of native movement and portal attraction cannot force this guard into premature crossing")
	check(space.story.cast[0].visible and not bool(game.session.story_mission.get("done", false)),
		"guard test earns no escort departure or mission completion")
	check(app.save_attempts.is_empty(), "controller fixtures make zero save attempts")
	space.dispose()
	app.queue_free()
	await process_frame
	await process_frame
	print("PORTAL GUARD: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
