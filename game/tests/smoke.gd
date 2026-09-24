extends SceneTree
## Drives the app through its main screens and saves screenshots.
## godot --path game -s res://tests/smoke.gd -- <out-dir> [steps]

var out := ""
var app: Node
var frame := 0
var plan: Array = []
var errors := 0

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	out = args[0] if args.size() > 0 else "user://smoke"
	DirAccess.make_dir_recursive_absolute(out)
	root.size = Vector2i(1280, 800)
	app = load("res://scenes/main.tscn").instantiate()
	root.add_child(app)
	plan = [
		[30, func(): _shot("title")],
		[31, func(): app.new_game()],
		[70, func(): _shot("station")],
		[71, func(): app.screen._open_section(0)],
		[100, func(): _shot("hangar")],
		[101, func(): app.screen._open_section(2)],
		[130, func(): _shot("map")],
		[131, func(): app.screen.depart({})],
		[200, func(): _shot("flight")],
		[260, func(): _shot("flight2")],
		[261, func(): quit(0)],
	]
	process_frame.connect(_tick)

func _shot(name: String) -> void:
	var img := root.get_texture().get_image()
	img.save_png(out.path_join(name + ".png"))
	print("shot ", name, " screen=", app.screen.get_script().resource_path if app.screen else "none")

func _tick() -> void:
	frame += 1
	for step in plan:
		if step[0] == frame: step[1].call()
