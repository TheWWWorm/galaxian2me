extends SceneTree
## Story step 36 in practice: Errkt Uggut's contest at B'akka. The rival flies
## the contest route and hunts on his own; the player's share is scored by
## shooting down pirates in turn. Checks that winning moves the story on.
## godot --headless --path game -s res://tests/challenge_run.gd

var app: Node
var frame := 0
var started := false

func _init() -> void:
	app = load("res://scenes/main.tscn").instantiate()
	root.add_child(app)
	process_frame.connect(_tick)

func _tick() -> void:
	frame += 1
	if frame == 20:
		app.new_game()
		var g = app.game
		while g.session.story_step < 36: g.campaign.advance()
		var station := int(g.session.story_mission.station)
		print("step ", g.session.story_step, " kind ", g.session.story_mission.kind, " at ", g.cat.station_name(station))
		g.arrive(station)
		g.session.flags["briefed_36"] = true
		g.depart({})
		app.show_flight()
		return
	if frame < 25: return
	var screen = app.screen
	if screen.get_script().resource_path.ends_with("station_screen.gd"): return
	if not screen.get_script().resource_path.ends_with("flight_screen.gd"): return
	Engine.time_scale = 8.0
	var space = screen.space
	var story = space.story
	if not started:
		started = true
		print("cast ", story.cast.size(), " rival ", story.cast[0].name, " route ", story.cast[0].ai.get("route", []).size())
	for c in screen.get_children():
		if c.has_method("_next"): c.finished.emit()
	if frame == 140: space.set_meta("trace", true)
	# The player downs a pirate every so often.
	if frame % 900 == 0:
		for i in range(1, story.cast.size()):
			var p = story.cast[i]
			if p.alive:
				space._destroyed(p, space.player)
				break
	if frame % 600 == 0 or frame < 40 or frame % 50 == 0:
		print(Time.get_ticks_msec(), " frame ", frame, " shots ", space.projectiles.size(), " fx ", space.effects.size(), " player ", space.kills, " rival ", space.stats.get("rival_kills", 0),
			" rival at ", story.cast[0].pos.snapped(Vector3.ONE * 1000), " done ", app.game.session.story_mission.get("done", false))
	if app.game.session.story_step == 37:
		print("won: step 37, kills ", space.kills, " vs ", space.stats.get("rival_kills", 0))
		quit(0)
	if story.failed:
		print("lost: ", space.kills, " vs ", space.stats.get("rival_kills", 0))
		quit(0)
	if frame > 12000:
		print("timeout")
		quit(1)
