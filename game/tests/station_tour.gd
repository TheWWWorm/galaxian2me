extends SceneTree
## Opens every station section with the story far enough along to unlock
## them, and saves a screenshot of each.
## godot --path game -s res://tests/station_tour.gd -- <out-dir> [station-id]

var out := ""
var app: Node
var frame := 0
var plan: Array = []

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	out = args[0]
	var station := int(args[1]) if args.size() > 1 else 98
	DirAccess.make_dir_recursive_absolute(out)
	root.size = Vector2i(1280, 800)
	app = load("res://scenes/main.tscn").instantiate()
	root.add_child(app)
	plan = [
		[20, func():
			app.new_game()
			app.game.session.story_step = 20
			app.game.session.credits = 250000
			app.game.arrive(station)
			app.show_station()],
		[50, func(): _shot("station")],
		[51, func(): app.screen._open_section(1)],
		[80, func(): _shot("lounge")],
		[81, func(): app.screen.current_panel._talk(0)],
		[95, func(): _shot("lounge_talk")],
		[96, func(): app.screen._open_section(0)],
		[120, func(): _shot("shop")],
		[121, func(): app.screen._open_section(2)],
		[150, func(): _shot("map")],
		[151, func(): app.screen._open_section(3)],
		[170, func(): _shot("missions")],
		[171, func(): app.screen._open_section(4)],
		[190, func(): _shot("status")],
		[191, func(): quit(0)],
	]
	process_frame.connect(_tick)

func _shot(name: String) -> void:
	root.get_texture().get_image().save_png(out.path_join(name + ".png"))

func _tick() -> void:
	frame += 1
	for step in plan:
		if step[0] == frame: step[1].call()
