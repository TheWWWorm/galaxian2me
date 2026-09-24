extends Node3D
## Draws the simulated space with the imported models: ships assembled from
## their parts, the station, gate and asteroids, projectiles with their
## weapon models, explosions with their animated models, and the backdrop.
## The chase camera sits behind the ship at a per-hull distance.

const Body := preload("res://src/flight/body.gd")
const Assembly := preload("res://src/presentation/assembly.gd")
const Backdrop := preload("res://src/presentation/backdrop.gd")
const Library := preload("res://src/content/library.gd")

const UNIT := Library.UNIT

var app
var space
var library
var camera := Camera3D.new()
var env := WorldEnvironment.new()
var backdrop: Backdrop
var nodes := {}
var shot_nodes: Array = []
var effect_nodes := {}
var effect_serial := 0
var dust: MultiMeshInstance3D
var cam_distance := 1200.0
var shake := 0.0
var rear_view := false

func setup(owner, sim) -> void:
	app = owner
	space = sim
	library = owner.library
	backdrop = Backdrop.new()
	backdrop.setup(library, space.station.station_id, owner.catalogue)
	add_child(backdrop)
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_COLOR
	add_child(env)
	camera.near = 1.0
	camera.far = 6000.0
	# The original's 750/4096-turn view is across a portrait phone screen;
	# on landscape screens the same framing of the ship needs it vertically.
	camera.keep_aspect = Camera3D.KEEP_HEIGHT
	camera.fov = 750.0 / 4096.0 * 360.0 * 0.9
	add_child(camera)
	camera.make_current()
	var distances = library.constant("df.a:[S")
	var idx: int = space.player.ship_index
	if distances is Array and idx >= 0 and idx < distances.size():
		cam_distance = float(distances[idx])
	_make_dust()
	space.event.connect(_on_event)

func _node_for(b: Body) -> Node3D:
	if nodes.has(b): return nodes[b]
	var n: Node3D = null
	match b.kind:
		Body.Kind.PLAYER, Body.Kind.SHIP, Body.Kind.FREIGHTER:
			if b.ship_index < 0 and not b.model.is_empty():
				n = Assembly.figure(library, b.model, 0)
			else:
				n = Assembly.ship(library, b.ship_index, _livery(b))
				n.get_node("Boosters").visible = b.kind == Body.Kind.PLAYER and b.boosting
		Body.Kind.STATION:
			n = Assembly.station(library, b.station_id, b.faction)
		Body.Kind.GATE:
			n = _animated(b.model, 38)
		Body.Kind.ASTEROID:
			n = Assembly.figure(library, "asteroid", b.pattern_frame)
			n.scale = b.scale
		Body.Kind.LOOT:
			n = Assembly.figure(library, b.model, 0)
			n.scale = b.scale
	if n == null:
		n = Node3D.new()
	add_child(n)
	nodes[b] = n
	return n

func _livery(b: Body) -> int:
	match b.pattern_frame:
		0: return 8
		2: return 2
		3: return 3
	return 0

## A model posed at one frame of its own animation (the gate idles on frames
## 38–60 as the original loops it).
func _animated(model: String, frame: int) -> Node3D:
	return Assembly.figure(library, model, frame)

func sync(delta: float) -> void:
	var seen := {}
	for b in space.bodies:
		if not b.visible or b.kind == Body.Kind.STAR or b.kind == Body.Kind.ARRIVAL: continue
		if not b.alive and b.dead_timer <= 0.0: continue
		var n := _node_for(b)
		seen[b] = true
		n.visible = b.alive
		var t := Transform3D(b.basis, b.pos * UNIT)
		if b.kind == Body.Kind.ASTEROID or b.kind == Body.Kind.LOOT:
			t.basis = b.basis.scaled_local(b.scale)
		if b.is_ship():
			var bank := float(b.ai.get("bank", 0.0))
			t.basis = t.basis * Basis(Vector3.FORWARD, bank)
			var boosters := n.get_node_or_null("Boosters")
			if boosters != null: boosters.visible = b.boosting or b.kind != Body.Kind.PLAYER
		n.transform = t
	for b in nodes.keys():
		if not seen.has(b):
			nodes[b].queue_free()
			nodes.erase(b)
	_sync_shots()
	_sync_effects(delta)
	_camera(delta)
	backdrop.follow(camera)
	env.environment.background_color = backdrop.background_color(camera)
	_dust_follow()

## The original's chase camera: 2000 units behind and 700 above the ship,
## aimed 850 above it, easing an eighth of the way each frame; the rear
## view sits 3100 ahead and 600 above, aimed 300 above.
var cam_pos := Vector3.ZERO
var cam_started := false

func _camera(delta: float) -> void:
	var p: Body = space.player
	var story = space.story
	if story != null and story.camera_mode != "chase":
		var pos: Vector3 = story.camera_position
		var look_at_pos := Vector3.ZERO
		match story.camera_mode:
			"shot":
				pos = story.camera_target.pos + story.camera_offset
				look_at_pos = story.camera_target.pos
			"look":
				look_at_pos = story.camera_target.pos
			"fixed":
				camera.global_transform = Transform3D(Assembly.basis(0, int(story.camera_offset.y) % 4096, 0), pos * UNIT)
				cam_started = false
				return
		camera.global_position = pos * UNIT
		if not (pos * UNIT).is_equal_approx(look_at_pos * UNIT):
			camera.look_at(look_at_pos * UNIT, Vector3.UP)
		cam_started = false
		return
	var offset := Vector3(0, 700, -2000) if not rear_view else Vector3(0, 600, 3100)
	var aim := Vector3(0, 850, 0) if not rear_view else Vector3(0, 300, 0)
	var want: Vector3 = p.pos + p.basis * offset
	if not cam_started:
		cam_pos = want
		cam_started = true
	if space.docking < 0 and space.jumping < 0:
		var k := 1.0 - pow(7.0 / 8.0, delta * 30.0)
		cam_pos = cam_pos.lerp(want, k)
	camera.global_position = cam_pos * UNIT
	var look: Vector3 = (p.pos + p.basis * aim) * UNIT
	if not camera.global_position.is_equal_approx(look):
		camera.look_at(look, p.basis.y)
	if shake > 0.0:
		shake = maxf(0.0, shake - delta)
		camera.h_offset = randf_range(-0.3, 0.3) * shake
		camera.v_offset = randf_range(-0.3, 0.3) * shake
	else:
		camera.h_offset = 0.0
		camera.v_offset = 0.0

# ------------------------------------------------------------------ shots

func _sync_shots() -> void:
	var shots: Array = space.projectiles
	while shot_nodes.size() < shots.size():
		var holder := Node3D.new()
		add_child(holder)
		shot_nodes.append({"node": holder, "model": ""})
	for i in shot_nodes.size():
		var entry: Dictionary = shot_nodes[i]
		var node: Node3D = entry.node
		if i >= shots.size():
			node.visible = false
			continue
		var p: Dictionary = shots[i]
		var model: String = p.weapon.get("model", "")
		if entry.model != model:
			for c in node.get_children(): c.queue_free()
			var m: Node3D = Assembly.figure(library, model, 0) if not model.is_empty() else _default_shot()
			node.add_child(m)
			entry.model = model
		node.visible = true
		var dir: Vector3 = (p.vel as Vector3).normalized()
		var up := Vector3.UP if absf(dir.y) < 0.95 else Vector3.RIGHT
		node.global_transform = Transform3D(Basis.looking_at(dir, up), p.pos * UNIT)

func _default_shot() -> Node3D:
	var m := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = Vector3(0.1, 0.1, 3.0)
	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = Color(1.0, 0.6, 0.2)
	mat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	box.material = mat
	m.mesh = box
	return m

# ------------------------------------------------------------------ effects

func _sync_effects(_delta: float) -> void:
	var alive := {}
	for e in space.effects:
		# Effects are keyed by a stable id: their dictionaries change every frame.
		if not e.has("id"):
			effect_serial += 1
			e.id = effect_serial
		alive[e.id] = true
		if not effect_nodes.has(e.id):
			var n := _effect_node(e)
			add_child(n)
			effect_nodes[e.id] = n
		var node: Node3D = effect_nodes[e.id]
		node.position = (e.pos as Vector3) * UNIT
		var k: float = e.time / e.life
		match str(e.kind):
			"explosion", "asteroid":
				var anim = node.get_meta("anim", null)
				if anim != null:
					var frames: int = int(anim.actions[0].last_frame)
					_set_frame(node, anim, int(k * frames))
			"blast":
				node.scale = Vector3.ONE * maxf(0.01, float(e.radius) * UNIT * k)
				(node as MeshInstance3D).transparency = k
			"spark":
				node.scale = Vector3.ONE * (1.0 - k)
	for e in effect_nodes.keys():
		if not alive.has(e):
			effect_nodes[e].queue_free()
			effect_nodes.erase(e)

func _effect_node(e: Dictionary) -> Node3D:
	match str(e.kind):
		"explosion", "asteroid":
			var name := "explosion" if e.kind == "explosion" else "asteroid_explo"
			var n: MeshInstance3D = library.instance(name, true)
			for i in n.get_surface_override_material_count():
				n.set_surface_override_material(i, n.get_surface_override_material(i).duplicate())
			var anim: Dictionary = library.animation(name)
			if not anim.is_empty(): n.set_meta("anim", anim)
			n.scale = Vector3.ONE * float(e.get("scale", 1.0))
			return n
		"blast":
			var m := MeshInstance3D.new()
			var s := SphereMesh.new()
			s.radius = 1.0; s.height = 2.0
			var mat := StandardMaterial3D.new()
			mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
			mat.albedo_color = Color(0.4, 0.6, 1.0, 0.5) if e.get("emp", false) else Color(1.0, 0.7, 0.3, 0.5)
			mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			mat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
			mat.cull_mode = BaseMaterial3D.CULL_DISABLED
			s.material = mat
			m.mesh = s
			return m
	var q := MeshInstance3D.new()
	var quad := QuadMesh.new()
	quad.size = Vector2(1.5, 1.5)
	var qm := StandardMaterial3D.new()
	qm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	qm.albedo_texture = library.texture("lens2")
	qm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	qm.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	qm.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	quad.material = qm
	q.mesh = quad
	return q

## Poses a skinned model at one frame of its first action.
func _set_frame(node: MeshInstance3D, anim: Dictionary, frame: int) -> void:
	var action: Dictionary = anim.actions[0]
	frame = clampi(frame, 0, int(action.last_frame))
	var source: Dictionary = library.model_data(node.name)
	if source.is_empty(): return
	var transforms := Library.bone_transforms(source, action.matrices[frame])
	var rest := Library.bone_transforms(source)
	for i in node.get_surface_override_material_count():
		var mat: ShaderMaterial = node.get_surface_override_material(i)
		var list: Array = []
		for bi in mini(48, transforms.size()):
			var t: Transform3D = transforms[bi]
			list.append(Projection(t))
		while list.size() < 48: list.append(Projection.IDENTITY)
		mat.set_shader_parameter("bones", list)
	var _unused := rest

# ------------------------------------------------------------------ dust

## Space dust around the camera, like the original's drifting particles.
func _make_dust() -> void:
	dust = MultiMeshInstance3D.new()
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	var quad := QuadMesh.new()
	quad.size = Vector2(0.08, 0.08)
	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = Color(0.75, 0.8, 0.9, 0.7)
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	quad.material = mat
	mm.mesh = quad
	mm.instance_count = 160
	for i in mm.instance_count:
		mm.set_instance_transform(i, Transform3D(Basis.IDENTITY, Vector3(randf_range(-40, 40), randf_range(-40, 40), randf_range(-40, 40))))
	dust.multimesh = mm
	add_child(dust)

func _dust_follow() -> void:
	# Particles wrap within a box around the camera so the ship flies past them.
	var c := camera.global_position
	var mm := dust.multimesh
	for i in mm.instance_count:
		var t := mm.get_instance_transform(i)
		var p := t.origin
		var d := p - c
		var moved := false
		for axis in 3:
			if d[axis] > 40.0: p[axis] -= 80.0; moved = true
			elif d[axis] < -40.0: p[axis] += 80.0; moved = true
		if moved: mm.set_instance_transform(i, Transform3D(Basis.IDENTITY, p))

func _on_event(kind: String, _data: Dictionary) -> void:
	if kind == "hit": shake = 0.4
