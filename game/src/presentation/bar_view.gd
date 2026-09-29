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
## Guests left touching a table after the ring was turned, and by how far it
## turned from the original's placement (for the tests).
var turn_hits := [0, 0]
var library

func setup(lib, station_id: int, faction: int, guests: Array) -> void:
	library = lib
	var style := 2 if faction == 1 else (0 if faction == 0 else 1)
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
				_matte(node)
				add_child(node)
		figures.append(node)
	var meshes = lib.constant("an.a:[[S")
	if meshes is Array and style < meshes.size():
		var choices: Array = meshes[style]
		var count := 20 if style == 0 else 6
		var r := JavaRandom.new(station_id + 1000)
		var parts: Array = []
		for i in count:
			var id := int(choices[r.next_int(choices.size())])
			var part := Assembly.figure(lib, lib.model_name(id), 0, "", true)
			parts.append(part)
			if part != null: add_child(part)
		# The original keeps the segments after the guests in one list and
		# turns each by its place in that list, so the whole ring is turned by
		# the number of guests. Where that sets a table or a wall on someone,
		# the ring turns on by whole segments until everyone stands clear.
		var turn := _clear_turn(parts, guests.size())
		for i in count:
			if parts[i] != null: parts[i].transform = Transform3D(_segment_basis(i + turn, count), Vector3.ZERO)
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

## The guests are drawn from their texture alone: black figures whose
## edge strips are textured white, as the original shows them. The sphere-
## mapped highlight that ships wear would wash them out white.
static func _matte(node: Node) -> void:
	if node is MeshInstance3D and (node as MeshInstance3D).mesh != null:
		var mi := node as MeshInstance3D
		for i in mi.mesh.get_surface_count():
			var m = mi.get_surface_override_material(i)
			if m is ShaderMaterial:
				var own := (m as ShaderMaterial).duplicate() as ShaderMaterial
				own.set_shader_parameter("specular", false)
				mi.set_surface_override_material(i, own)
	for c in node.get_children(): _matte(c)

static func _segment_basis(place: int, count: int) -> Basis:
	return Assembly.basis(0, place * (4096 / count), 0)

## The ring turn, starting from the original's, that leaves the most guests
## clear of the segments' tables and walls. Anyone still touching one then
## steps to the nearest clear floor.
func _clear_turn(parts: Array, start: int) -> int:
	var feet: Array = []
	for f in figures:
		if f != null: feet.append(f)
	if feet.is_empty(): return start
	# Anything from the floor's kerbs up to head height (a figure is about
	# 500 units tall), in each segment's own space.
	var low := 15.0 * Assembly.UNIT
	var high := 450.0 * Assembly.UNIT
	var walls: Array = []
	for part in parts:
		var tris: Array = []
		if part != null: _gather(part, Transform3D.IDENTITY, low, high, tris)
		walls.append(tris)
	var best := start
	var fewest := 1 << 30
	for k in parts.size():
		var hits := 0
		for f in feet:
			if _touching(walls, start + k, f.position): hits += 1
		if hits < fewest:
			fewest = hits
			best = start + k
		if hits == 0: break
	turn_hits = [fewest, best - start]
	if fewest > 0:
		for f in feet:
			if _touching(walls, best, f.position): f.position = _nearest_clear(walls, best, f.position)
	return best

## Half a body's width: how close a table may come to a guest's feet.
const CLEARANCE := 60.0

func _touching(walls: Array, turn: int, at: Vector3) -> bool:
	for i in walls.size():
		var local: Vector3 = _segment_basis(i + turn, walls.size()).inverse() * at
		if _touches(walls[i], Vector2(local.x, local.z), CLEARANCE * Assembly.UNIT): return true
	return false

## The nearest point to `at` with no table or wall within reach, searched in
## widening rings; `at` itself if there is none near.
func _nearest_clear(walls: Array, turn: int, at: Vector3) -> Vector3:
	for ring in range(1, 13):
		var r := ring * 25.0 * Assembly.UNIT
		for step in 16:
			var a := step * TAU / 16.0
			var p := at + Vector3(cos(a), 0, sin(a)) * r
			if not _touching(walls, turn, p): return p
	return at

## The triangles under `node` that reach between `low` and `high`, flattened
## onto the floor.
static func _gather(node: Node, to_node: Transform3D, low: float, high: float, out: Array) -> void:
	if node is MeshInstance3D and (node as MeshInstance3D).mesh != null:
		var faces := (node as MeshInstance3D).mesh.get_faces()
		for t in range(0, faces.size() - 2, 3):
			var a := to_node * faces[t]
			var b := to_node * faces[t + 1]
			var c := to_node * faces[t + 2]
			if maxf(a.y, maxf(b.y, c.y)) < low or minf(a.y, minf(b.y, c.y)) > high: continue
			out.append(PackedVector2Array([Vector2(a.x, a.z), Vector2(b.x, b.z), Vector2(c.x, c.z)]))
	for c in node.get_children():
		if c is Node3D: _gather(c, to_node * (c as Node3D).transform, low, high, out)

## Whether any flattened triangle comes within `radius` of `p`.
static func _touches(tris: Array, p: Vector2, radius: float) -> bool:
	for t in tris:
		var tri: PackedVector2Array = t
		if Geometry2D.is_point_in_polygon(p, tri): return true
		for e in 3:
			var near := Geometry2D.get_closest_point_to_segment(p, tri[e], tri[(e + 1) % 3])
			if near.distance_to(p) < radius: return true
	return false

## Eases the camera back to take in every guest at once.
func look_at_all() -> void:
	var box := Rect2()
	var any := false
	for f in figures:
		if f == null: continue
		var at := Vector2(f.position.x, f.position.z)
		box = box.expand(at) if any else Rect2(at, Vector2.ZERO)
		any = true
	if not any: return
	# The camera looks along +z with a quarter-turn field of view: the
	# nearest guests set how far back it must stand to fit the row.
	var margin := 120.0 * Assembly.UNIT
	var back := maxf(box.size.x / 2.0 + margin, STAND_OFF * Assembly.UNIT)
	var start := Assembly.position(START)
	goal = Vector3(box.get_center().x, start.y, maxf(box.position.y - back, start.z))

## Eases the camera up to stand before guest `index`, for a conversation.
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
