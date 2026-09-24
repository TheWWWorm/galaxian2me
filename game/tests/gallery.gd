extends SceneTree
## Renders imported assemblies to a PNG for visual checks.
## godot --path game -s res://tests/gallery.gd -- <content-id> <out.png> ships|stations|models [faction]

const Library := preload("res://src/content/library.gd")
const Assembly := preload("res://src/presentation/assembly.gd")

var frames := 0
var out := ""

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	var lib := Library.new()
	if not lib.open(args[0]):
		push_error("cannot open content"); quit(1); return
	out = args[1]
	var mode: String = args[2]
	var faction := int(args[3]) if args.size() > 3 else 0
	root.size = Vector2i(1600, 1000)
	var world := Node3D.new()
	root.add_child(world)
	var cam := Camera3D.new()
	world.add_child(cam)
	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_COLOR
	env.environment.background_color = Color(0.05, 0.06, 0.1)
	world.add_child(env)
	var items: Array = []
	if mode == "ships":
		for i in 37:
			var s := Assembly.ship(lib, i, faction)
			s.get_node("Boosters").visible = true
			items.append(s)
	elif mode.begins_with("ship:"):
		var s := Assembly.ship(lib, int(mode.substr(5)), faction)
		items.append(s)
	elif mode.begins_with("station:"):
		items.append(Assembly.station(lib, int(mode.substr(8)), faction))
	elif mode == "stations":
		for id in [0, 5, 10, 20, 30, 40, 55, 75, 98, 12]:
			items.append(Assembly.station(lib, id, faction))
	else:
		var names: Array = []
		for k in lib.data.models: names.append(lib.data.models[k].name)
		names.sort()
		var start := int(args[3]) if args.size() > 3 else 0
		for n in names.slice(start, start + 48):
			var node := Assembly.figure(lib, n, 0)
			node.set_meta("label", n)
			items.append(node)
	var cols := int(ceil(sqrt(items.size() * 1.6)))
	var spacing := 1.2
	for i in items.size():
		var inner: Node3D = items[i]
		var box := _bounds(inner)
		var it := Node3D.new()
		it.add_child(inner)
		inner.position = -box.get_center()
		world.add_child(it)
		it.scale = Vector3.ONE / maxf(box.get_longest_axis_size(), 0.001)
		it.position = Vector3((i % cols) * spacing, -(i / cols) * spacing, 0)
		it.rotation = Vector3(0.5, 0.7, 0.0)
		if inner.has_meta("label"): it.set_meta("label", inner.get_meta("label"))
		box = AABB()
		if it.has_meta("label"):
			var l := Label3D.new(); l.text = it.get_meta("label"); l.pixel_size = spacing * 0.002
			l.position = it.position + Vector3(0, -spacing * 0.45, 0); world.add_child(l)
	var rows := int(ceil(items.size() / float(cols)))
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	cam.size = rows * spacing * 1.05
	cam.position = Vector3((cols - 1) * spacing / 2.0, -(rows - 1) * spacing / 2.0, spacing * 10)
	cam.far = spacing * 40
	process_frame.connect(_frame)

func _bounds(n: Node) -> AABB:
	var box := AABB()
	var first := true
	for c in [n] + n.find_children("*", "MeshInstance3D", true, false):
		if c is MeshInstance3D and c.mesh != null:
			var b: AABB = (c.transform if c != n else Transform3D.IDENTITY) * c.mesh.get_aabb()
			if first: box = b; first = false
			else: box = box.merge(b)
	return box

func _frame() -> void:
	frames += 1
	if frames == 4:
		root.get_texture().get_image().save_png(out)
		quit(0)
