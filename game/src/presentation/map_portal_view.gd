extends SubViewport
## Render the supplied animated portal once for both levels of the map.
## This private world never creates a flight, collision or travel endpoint.
const Vortex := preload("res://src/presentation/vortex_view.gd")
var library
var portal: Vortex
var elapsed_ms := 0.0

func _ready() -> void:
	size = Vector2i(96, 96)
	transparent_bg = true
	own_world_3d = true
	gui_disable_input = true
	render_target_update_mode = SubViewport.UPDATE_ALWAYS
	portal = Vortex.new()
	add_child(portal)
	portal.setup_marker(library)
	if portal.layers.is_empty(): return
	# Frame every imported pose; shader animation extends beyond the rest mesh.
	var bounds: AABB = portal.layers[0].action.bounds
	var centre := bounds.get_center()
	var span := maxf(0.01, maxf(bounds.size.x, bounds.size.y))
	var camera := Camera3D.new()
	camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	camera.size = span * 1.08
	camera.near = 0.001
	camera.far = maxf(100.0, bounds.size.length() * 5.0)
	add_child(camera)
	# Imported one-sided portal faces -Z, unlike the ships' +Z convention.
	camera.look_at_from_position(centre - Vector3(0, 0, bounds.size.length() + 1.0), centre, Vector3.UP)
	camera.current = true

func _process(delta: float) -> void:
	elapsed_ms += delta * 1000.0
	if portal != null: portal.animate(int(elapsed_ms))
