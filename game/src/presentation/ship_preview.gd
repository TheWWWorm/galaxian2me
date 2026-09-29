extends SubViewportContainer
## A small showroom for a ship on offer or a station on the chart: the
## imported model in its own world, lit from above as in the hangar,
## turning slowly. Dragging across the picture turns it by hand.

const Assembly := preload("res://src/presentation/assembly.gd")

var library
var ship_index := -1
var ship_faction := 0
var station_id := -1
var model_name := ""
var viewport := SubViewport.new()
var pivot := Node3D.new()
var camera := Camera3D.new()
var angle := 0.6
var dragging := false
## Turning speed by itself, radians a second.
const TURN := 0.45

func _init() -> void:
	stretch = true
	custom_minimum_size = Vector2(280, 170)
	mouse_filter = Control.MOUSE_FILTER_STOP

func _ready() -> void:
	viewport.own_world_3d = true
	viewport.transparent_bg = true
	viewport.msaa_3d = Viewport.MSAA_4X
	add_child(viewport)
	viewport.add_child(pivot)
	var light := DirectionalLight3D.new()
	light.transform = Transform3D(Basis.looking_at(Vector3(-0.3, -0.9, -0.3)), Vector3.ZERO)
	viewport.add_child(light)
	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_CLEAR_COLOR
	env.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.environment.ambient_light_color = Color(0.55, 0.6, 0.7)
	viewport.add_child(env)
	viewport.add_child(camera)
	if ship_index >= 0: show_ship(ship_index, ship_faction)

## Puts `index` in the showroom, framed to fit.
func show_ship(index: int, faction: int) -> void:
	ship_index = index
	ship_faction = faction
	station_id = -1
	if not is_inside_tree() or library == null: return
	var model: Node3D = Assembly.ship(library, index, faction)
	var boosters := model.get_node_or_null("Boosters")
	if boosters != null: boosters.visible = false
	_present(model)

## A station, built from the same parts as in flight, in place of a ship.
func show_station(id: int, faction: int) -> void:
	station_id = id
	ship_index = -1
	if not is_inside_tree() or library == null: return
	_present(Assembly.station(library, id, faction))

## Any single converted model by name (the Mods page's viewer).
func show_model(name: String) -> void:
	model_name = name
	ship_index = -1
	station_id = -1
	if not is_inside_tree() or library == null: return
	_present(library.instance(name))

func _present(model: Node3D) -> void:
	for c in pivot.get_children(): c.queue_free()
	pivot.add_child(model)
	var box := _bounds(model, Transform3D.IDENTITY)
	model.position = -box.get_center()
	var reach := maxf(0.01, box.size.length() * 0.5)
	camera.fov = 40.0
	camera.near = reach * 0.02
	camera.far = reach * 20.0
	# From a little above and ahead, as a showroom shot, far enough back
	# that the whole bounding sphere fits the 40° view as it turns.
	var eye := Vector3(0.0, 0.3, 1.0).normalized() * (reach / sin(deg_to_rad(20.0)) * 1.05)
	camera.transform = Transform3D(Basis.looking_at(-eye), eye)

func _bounds(node: Node, at: Transform3D) -> AABB:
	var box := AABB()
	var first := true
	if node is Node3D and not (node as Node3D).visible: return box
	var here: Transform3D = at * ((node as Node3D).transform if node is Node3D else Transform3D.IDENTITY)
	if node is MeshInstance3D and node.mesh != null:
		box = here * node.mesh.get_aabb()
		first = false
	for c in node.get_children():
		var child := _bounds(c, here)
		if child.size == Vector3.ZERO: continue
		box = child if first else box.merge(child)
		first = false
	return box

func _process(delta: float) -> void:
	if not dragging: angle += TURN * delta
	pivot.transform.basis = Basis(Vector3.UP, angle)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		dragging = event.pressed
		accept_event()
	elif event is InputEventScreenTouch:
		dragging = event.pressed
		accept_event()
	elif (event is InputEventMouseMotion and dragging) or event is InputEventScreenDrag:
		angle += event.relative.x * 0.012
		accept_event()
