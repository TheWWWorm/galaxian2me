extends Node3D
## The Space Lounge as the original shows it: the station's bar, built from
## the race's bar segments turned evenly about the room's centre (six
## copies, or twenty in Terran stations), with each guest's figure standing at one of
## the bar's five places. The camera starts at the room's entrance and eases
## over to whoever is chosen.

const Assembly := preload("res://src/presentation/assembly.gd")
const JavaRandom := preload("res://src/simulation/java_random.gd")

## The original's lounge camera: where it starts and how it is turned.
const START := [920, 500, -1240]
## (The decompiled source names 2048 "Q_PI_HALF"; in the engine's units,
## where 4096 is a full turn, it is a half turn: the camera faces into the bar.)
const TURN := [-160, 2048, 0]
## How far in front of a guest the camera stops.
const STAND_OFF := 1000

var camera := Camera3D.new()
## One entry per guest: the figure node (null if it has no model).
var figures: Array = []
var goal := Vector3.ZERO
var library

func setup(lib, station_id: int, faction: int, guests: Array) -> void:
	library = lib
	var style := 2 if faction == 1 else (0 if faction == 0 else 1)
	var meshes = lib.constant("an.a:[[S")
	if meshes is Array and style < meshes.size():
		var choices: Array = meshes[style]
		var parts := 20 if style == 0 else 6
		var r := JavaRandom.new(station_id + 1000)
		for i in parts:
			var id := int(choices[r.next_int(choices.size())])
			var part := Assembly.figure(lib, lib.model_name(id), 0, "", true)
			if part == null: continue
			part.transform = Transform3D(Assembly.basis(0, i * (4096 / parts), 0), Vector3.ZERO)
			add_child(part)
	var kinds = lib.constant("an.a:[S")
	var places = lib.constant("ed#a:[I")
	var spots: Array = []
	if places is Array:
		for i in range(0, places.size() - 2, 3): spots.append([int(places[i]), int(places[i + 1]), int(places[i + 2])])
	# The same guests stand at the same places each visit.
	var pick := JavaRandom.new(station_id)
	var free := range(spots.size())
	for g in guests:
		var node: Node3D = null
		if not free.is_empty() and kinds is Array:
			var race := int(g.get("race", 0))
			var name: String = lib.model_name(int(kinds[race])) if race >= 0 and race < kinds.size() else ""
			# The original swaps in its Terran woman's figure for female Terrans.
			if race == 0 and not bool(g.get("male", true)) and lib.model_id("fig_terran_f") >= 0: name = "fig_terran_f"
			var spot: Array = spots[free.pop_at(pick.next_int(free.size()))]
			if not name.is_empty(): node = Assembly.figure(lib, name, 0, "", true)
			if node != null:
				node.position = Assembly.position(spot)
				add_child(node)
		figures.append(node)
	add_child(camera)
	camera.keep_aspect = Camera3D.KEEP_WIDTH
	camera.fov = 1024.0 / 4096.0 * 360.0
	camera.near = 0.1
	camera.far = 400.0
	# The original turns this camera about its height first, then tilts it
	# (rotation order 2).
	camera.transform = Transform3D(Assembly.basis(0, TURN[1], 0) * Assembly.basis(TURN[0], 0, TURN[2]), Assembly.position(START))
	goal = camera.position
	RenderingServer.global_shader_parameter_set("gof_light_direction", Vector3(0.3, 0.9, 0.3).normalized())

## Eases the camera to stand before guest `index`.
func look_at_guest(index: int) -> void:
	if index < 0 or index >= figures.size() or figures[index] == null: return
	var at: Vector3 = figures[index].position
	goal = Vector3(at.x, Assembly.position(START).y, at.z - STAND_OFF * Assembly.UNIT)

## The screen rectangle guest `index`'s figure covers, or an empty one
## when they are out of view.
func screen_box(index: int) -> Rect2:
	if index < 0 or index >= figures.size() or figures[index] == null: return Rect2()
	var node: Node3D = figures[index]
	var box := _extent(node, Transform3D.IDENTITY)
	var out := Rect2()
	var first := true
	for c in 8:
		var corner: Vector3 = node.global_transform * box.get_endpoint(c)
		if camera.is_position_behind(corner): return Rect2()
		var at := camera.unproject_position(corner)
		if first: out = Rect2(at, Vector2.ZERO); first = false
		else: out = out.expand(at)
	return out

## The bounds of `node`'s mesh and every mesh under it, in `node`'s own space.
static func _extent(node: Node, to_node: Transform3D) -> AABB:
	var box := AABB()
	var any := false
	if node is MeshInstance3D and (node as MeshInstance3D).mesh != null and to_node == Transform3D.IDENTITY:
		box = (node as MeshInstance3D).mesh.get_aabb(); any = true
	for c in node.get_children():
		if not c is Node3D: continue
		var t: Transform3D = to_node * (c as Node3D).transform
		var part := AABB()
		var has := false
		if c is MeshInstance3D and (c as MeshInstance3D).mesh != null:
			part = t * (c as MeshInstance3D).mesh.get_aabb(); has = true
		var inner := _extent(c, t)
		if inner.size != Vector3.ZERO:
			part = part.merge(inner) if has else inner; has = true
		if has:
			box = box.merge(part) if any else part; any = true
	return box

func _process(delta: float) -> void:
	camera.position = camera.position.lerp(goal, 1.0 - pow(0.02, delta))
