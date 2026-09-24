extends SceneTree
## Story step 2 in practice: fly out from Var Hastra with the mining ship, mine
## asteroids with a drill kept in the green, dock, and check that the story
## moves on. Saves screenshots of the drill.
## godot --path game -s res://tests/mining_run.gd -- <out-dir>

var out := ""
var app: Node
var frame := 0
var phase := "start"
var shots := 0

func _init() -> void:
	out = OS.get_cmdline_user_args()[0]
	DirAccess.make_dir_recursive_absolute(out)
	root.size = Vector2i(1280, 800)
	app = load("res://scenes/main.tscn").instantiate()
	root.add_child(app)
	process_frame.connect(_tick)

func _shot(name: String) -> void:
	root.get_texture().get_image().save_png(out.path_join("%02d_%s.png" % [shots, name]))
	shots += 1

func _tick() -> void:
	frame += 1
	if frame == 20:
		app.new_game()
		var g = app.game
		# Skip the opening scenes: step 1's station event gives the mining ship.
		g.session.story_step = 1
		g.session.story_mission = g.campaign.mission_from([11, 0, 78])
		g.dock(78)
		print("after dock: step ", g.session.story_step, " ship ", g.session.ship.index, " kind ", g.session.story_mission.get("kind"), " target ", g.session.story_mission.get("target"))
		g.depart({})
		app.show_flight()
		phase = "flying"
		return
	if frame < 25 or phase == "done": return
	var screen = app.screen
	if screen.get_script().resource_path.ends_with("station_screen.gd"):
		print("docked: step ", app.game.session.story_step, " cargo ", app.game.session.cargo)
		_shot("station")
		phase = "done"
		quit(0)
		return
	if not screen.get_script().resource_path.ends_with("flight_screen.gd"): return
	Engine.time_scale = 4.0
	for c in screen.get_children():
		if c.has_method("_next"): c.finished.emit()
	var space = screen.space
	if screen.controls.scripted.is_valid() == false:
		screen.controls.scripted = func():
			var m = space.mining
			if m == null: return {"yaw": 0.0, "pitch": 0.0}
			# Keep the drill centred: push against its drift.
			return {"yaw": -1.0 if m.drill > 1.0 else (1.0 if m.drill < -1.0 else 0.0), "pitch": 0.0}
	var ore := 0
	for id in range(154, 176): ore += app.game.session.cargo_count(id)
	if space.mining != null and frame % 200 == 0: _shot("drill")
	if ore >= 10 and space.mining_target == null:
		if space.docking < 0:
			space.target = space.station
			space.locked = true
			space.autopilot = true
		return
	if space.mining_target == null:
		var best = null
		for b in space.bodies:
			if b.kind == 7 and b.alive and b.ore >= 0 and (best == null or b.pos.distance_to(space.player.pos) < best.pos.distance_to(space.player.pos)):
				best = b
		if best != null:
			space._begin_mining(best)
	if frame > 20000:
		print("timeout, ore ", ore)
		quit(1)
