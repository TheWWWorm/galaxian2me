extends SceneTree
## Plays the opening story at high speed, skipping radio lines as soon as they
## show, and saves screenshots along the way.
## godot --path game -s res://tests/story_run.gd -- <out-dir>

var out := ""
var app: Node
var frame := 0
var shots := 0
var last_screen := ""

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
	if frame == 20: app.new_game()
	if frame < 25: return
	var screen: Node = app.screen
	var name: String = screen.get_script().resource_path.get_file().get_basename()
	if name != last_screen:
		last_screen = name
		print("frame ", frame, " -> ", name, " step ", app.game.session.story_step)
	if name == "flight_screen":
		Engine.time_scale = 6.0
		# Close the briefing and radio as soon as they show.
		for c in screen.get_children():
			if c.has_signal("finished") and c.has_method("_next"): c.finished.emit()
		var story = screen.space.story
		if story != null:
			var m: Dictionary = story.message()
			if not m.is_empty():
				if frame % 40 == 0: _shot("radio_s%d_%d" % [story.step, story.current])
				story.skip_message()
			# Let the player's guns do the work in the fight.
			for b in screen.space.bodies:
				if b.hostile and b.visible and b.alive and b.ai.get("mode", "") != "hold" and frame % 30 == 0:
					b.damage(40.0)
	elif name == "station_screen":
		Engine.time_scale = 1.0
		_shot("station_step%d" % app.game.session.story_step)
		print("reached station at step ", app.game.session.story_step)
		quit(0)
	if frame > 6000:
		print("timeout at step ", app.game.session.story_step)
		_shot("timeout")
		quit(1)
