extends Node3D
## Native presentation of the supplied vortex and its ten dust figures.
## The action tables supply motion; the engine supplies clocks, billboarding
## and the original distance-compensated rendering proxy, never collision.

const Library := preload("res://src/content/library.gd")
const Assembly := preload("res://src/presentation/assembly.gd")
const DRAW_DISTANCE := 28000.0 * Library.UNIT
const DUST_LAYERS := 10
var layers: Array = []
var _actions := {}

## The original map uses only the animated portal, not the flight dust.
func setup_marker(library) -> void:
	_add_layer(library, library.model_name(6805), 30, Basis.IDENTITY)

func setup(library, random: RandomNumberGenerator = null) -> void:
	if random == null:
		random = RandomNumberGenerator.new()
		random.randomize()
	var tilt := Assembly.basis(-128, -128, 0)
	_add_layer(library, library.model_name(6805), 30, tilt)
	for i in DUST_LAYERS:
		# This source value is rotation about local Z, NOT a time offset.
		var roll := (i + 1) * random.randi_range(0, 399)
		_add_layer(library, library.model_name(6806), random.randi_range(20, 69),
			tilt * Assembly.basis(0, 0, roll))

func _add_layer(library, model: String, interval: int, orientation: Basis) -> void:
	var animation: Dictionary = library.animation(model)
	if animation.is_empty():
		push_warning("Missing supplied vortex action: " + model)
		return
	if not _actions.has(model): _actions[model] = _prepare_action(library, model, animation.actions[0])
	var action: Dictionary = _actions[model]
	var figure: MeshInstance3D = library.instance(model, true, Assembly.frame_pattern(animation, 0))
	figure.custom_aabb = action.bounds
	# Each dust figure has a different clock; sharing its material would let
	# the last update overwrite the poses of the other nine figures.
	for i in figure.get_surface_override_material_count():
		figure.set_surface_override_material(i, figure.get_surface_override_material(i).duplicate())
	figure.basis = orientation
	add_child(figure)
	var layer := {"figure": figure, "action": action, "interval": interval, "start": -1, "frame": -1}
	layers.append(layer)
	_pose(layer, 0)

func _prepare_action(library, model: String, action: Dictionary) -> Dictionary:
	var source: Dictionary = library.model_data(model)
	var poses: Array = []
	var bounds := AABB()
	var first := true
	for row in action.matrices:
		var transforms := Library.bone_transforms(source, row)
		var pose: Array[Projection] = []
		for transform in transforms: pose.append(Projection(transform))
		while pose.size() < 48: pose.append(Projection.IDENTITY)
		poses.append(pose)
		# Shader displacement is invisible to the renderer's static AABB.
		# Bound ALL imported poses, including the far-offset dust rest pose.
		var vertex := 0
		for bone in source.bones.size():
			for _v in int(source.bones[bone].vertices):
				var at: Vector3 = transforms[bone] * Library.point(source.vertices, vertex * 3)
				bounds = AABB(at, Vector3.ZERO) if first else bounds.expand(at)
				first = false
				vertex += 1
	return {"poses": poses, "bounds": bounds.grow(0.01), "last": int(action.last_frame)}

func _pose(layer: Dictionary, frame: int) -> void:
	if layer.frame == frame: return
	layer.frame = frame
	var figure: MeshInstance3D = layer.figure
	for i in figure.get_surface_override_material_count():
		figure.get_surface_override_material(i).set_shader_parameter("bones", layer.action.poses[frame])

## The supplied clock includes the last frame, then restarts at the current
## clock (discarding overshoot), rather than stretching motion across it.
func animate(clock_ms: int) -> void:
	for layer in layers:
		if int(layer.start) < 0: layer.start = clock_ms
		var frame := maxi(0, int(float(clock_ms - int(layer.start)) / int(layer.interval)))
		if frame > int(layer.action.last):
			layer.start = clock_ms
			frame = 0
		_pose(layer, frame)

static func billboard(at: Vector3, eye: Vector3, opening: float) -> Transform3D:
	var offset := at - eye
	var distance := offset.length()
	var ratio := minf(1.0, DRAW_DISTANCE / distance) if distance > 0.0 else 1.0
	var direction := -offset.normalized() if distance > 0.0 else Vector3.FORWARD
	var up := Vector3.RIGHT if absf(direction.dot(Vector3.UP)) > 0.999 else Vector3.UP
	# The imported one-sided vortex faces -Z. Body.facing is for ships (+Z)
	# and points this surface AWAY from the camera, making it disappear.
	var orientation := Basis.looking_at(direction, up)
	return Transform3D(orientation.scaled_local(Vector3.ONE * maxf(0.00001, opening * ratio)), eye + offset * ratio)

func sync(clock_ms: int, at: Vector3, eye: Vector3, opening: float) -> void:
	visible = opening > 0.0
	transform = billboard(at, eye, opening)
	animate(clock_ms)

func _exit_tree() -> void:
	# Detach mesh material listeners before the independent override
	# materials and shared library resources are released on world change.
	for layer in layers:
		var figure: MeshInstance3D = layer.figure
		if is_instance_valid(figure): figure.mesh = null
	layers.clear()
	_actions.clear()
