extends Node3D
## Draws the simulated space with the imported models: ships assembled from
## their parts, the station, gate and asteroids, projectiles with their
## weapon models, explosions with their animated models, and the backdrop.
## The chase camera sits behind the ship at a per-hull distance.

const Body := preload("res://src/flight/body.gd")
const Assembly := preload("res://src/presentation/assembly.gd")
const Prefs := preload("res://src/presentation/preferences.gd")
const Backdrop := preload("res://src/presentation/backdrop.gd")
const Library := preload("res://src/content/library.gd")
const VortexView := preload("res://src/presentation/vortex_view.gd")
const Lighting := preload("res://src/presentation/lighting.gd")

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

## The look key: the turret view on ships with a turret (as the original's
## key 0), otherwise the rear view.
func toggle_look() -> void:
	if space.turret_mode or space.has_turret():
		if not space.set_turret_mode(not space.turret_mode): rear_view = not rear_view
	else:
		rear_view = not rear_view
var probe_node: Node3D
var drive_node: Node3D
var tractor_crate: Node3D
var tractor_beam: MeshInstance3D
var tractor_light: OmniLight3D
var wormhole_light: OmniLight3D

func setup(owner, sim) -> void:
	# This subtree receives already-presented poses in sync(), not physics
	# transforms. Engine interpolation would blend them a second time (and
	# can project a new target through the camera's stale origin pose).
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	app = owner
	space = sim
	library = owner.library
	backdrop = Backdrop.new()
	backdrop.setup(library, space.station.station_id, owner.catalogue)
	add_child(backdrop)
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_COLOR
	add_child(env)
	# Enhanced lighting: the system's sun lights and shadows everything from
	# where its sprite sits; the dark side keeps the phone's ambient share,
	# tinted by the system's sky.
	# Metal reflects a dim sky in the system's colour, brighter towards the
	# galactic band, and black below.
	Lighting.environment(env, Color(0.3, 0.32, 0.38) + backdrop.tint * 0.9,
		Color(0.05, 0.055, 0.08) + backdrop.tint, Color(0.8, 0.8, 0.84) + backdrop.tint * 2.0, Color(0.02, 0.02, 0.03))
	Lighting.sky_lights(self, backdrop, 700.0)
	for i in FLASH_LIGHTS: flash_lights.append(Lighting.point(self, Color.WHITE, 1.0, i >= 2))
	camera.near = 1.0
	camera.far = 6000.0
	# The original's 750/4096-turn view is across a portrait phone screen;
	# on landscape screens the same framing of the ship needs it vertically.
	camera.keep_aspect = Camera3D.KEEP_HEIGHT
	camera.fov = Prefs.fov(app)
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
				Lighting.engine_light(n, library, b == space.player)
		Body.Kind.STATION:
			n = Assembly.station(library, b.station_id, b.faction)
			Lighting.model_lights(n, library, 10, 4, 1.3, 0.25)
		Body.Kind.MOTHERSHIP:
			n = Assembly.figure(library, b.model)
			Lighting.model_lights(n, library, 6, 2, 1.0, 0.15)
		Body.Kind.GATE:
			n = _animated(b.model, 38)
			Lighting.model_lights(n, library, 4, 2, 1.2, 0.3)
		Body.Kind.WORMHOLE:
			n = VortexView.new()
			n.setup(library)
		Body.Kind.ASTEROID:
			n = Assembly.figure(library, b.model, b.pattern_frame)
			n.scale = b.scale
			_mineral(n)
		Body.Kind.LOOT:
			n = Assembly.figure(library, b.model, 0)
			n.scale = b.scale
	if n == null:
		n = Node3D.new()
	add_child(n)
	nodes[b] = n
	return n

## Enhanced lighting: bare rock is matte and has no lamps. One set of
## materials per rock model, shared by every asteroid wearing it.
var mineral_materials := {}
func _mineral(node: Node) -> void:
	if node is MeshInstance3D:
		var mi := node as MeshInstance3D
		for i in mi.get_surface_override_material_count():
			var m := mi.get_surface_override_material(i) as ShaderMaterial
			if m == null: continue
			if not mineral_materials.has(m):
				var own := m.duplicate() as ShaderMaterial
				own.set_shader_parameter("mineral", true)
				mineral_materials[m] = own
			mi.set_surface_override_material(i, mineral_materials[m])
	for c in node.get_children(): _mineral(c)

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
	# The simulation ticks at a fixed rate; the display may run faster or
	# unevenly. Bodies are drawn (and the HUD placed) between their last two
	# poses so motion is smooth instead of stepping.
	space.present(Engine.get_physics_interpolation_fraction())
	_present(delta)

func _present(delta: float) -> void:
	# Billboard against this frame's camera, including the first frame after
	# a physical crossing or a change to the source cinematic camera.
	_camera(delta)
	var seen := {}
	if wormhole_light != null: wormhole_light.light_energy = 0.0
	for b in space.bodies:
		if not b.visible or b.kind == Body.Kind.STAR or b.kind == Body.Kind.ARRIVAL: continue
		if not b.alive and b.dead_timer <= 0.0: continue
		var n := _node_for(b)
		seen[b] = true
		n.visible = b.alive
		var t := Transform3D(b.basis, b.pos * UNIT)
		if b.kind == Body.Kind.WORMHOLE:
			n.sync(space.clock, b.pos * UNIT, camera.global_position, b.opening_scale)
			# Enhanced lighting: the open vortex lights ships near its mouth.
			if wormhole_light == null:
				wormhole_light = Lighting.point(self, library.model_glow(library.model_name(6805), Color(0.5, 0.7, 1.0)), 260.0)
			wormhole_light.position = b.pos * UNIT
			wormhole_light.light_energy = 1.5 * clampf(float(b.opening_scale), 0.0, 1.0)
			continue
		if b.kind == Body.Kind.ASTEROID or b.kind == Body.Kind.LOOT:
			t.basis = b.basis.scaled_local(b.scale)
		if b.is_ship():
			var bank := float(b.ai.get("bank", 0.0))
			t.basis = t.basis * Basis(Vector3.FORWARD, bank)
			if b == space.player and space.cloak_coef > 0.0:
				var stretch: float = space.cloak_scale()
				n.visible = b.alive and stretch > 0.0
				t.basis = t.basis.scaled_local(Vector3(maxf(0.01, stretch), 1.0, 1.0))
			var boosters := n.get_node_or_null("Boosters")
			if boosters != null:
				# Out in scripted scenes and while the drill is in the rock.
				boosters.visible = b.exhaust and not (b == space.player and space.mining != null)
				var flare: float = space.boost_flare() if b == space.player else 0.0
				var power: float = space.throttle / 100.0 if b == space.player else 1.0
				Assembly.stretch_boosters(boosters, flare, power)
				if boosters.has_meta("light"): boosters.get_meta("light").light_energy = 2.0 * (0.35 + 0.65 * power) + flare * 1.2
		n.transform = t
	for b in nodes.keys():
		if not seen.has(b):
			nodes[b].queue_free()
			nodes.erase(b)
	_sync_shots()
	_sync_probe()
	_sync_drive()
	_sync_tractor()
	_sync_trails()
	_sync_effects(delta)
	backdrop.follow(camera)
	env.environment.background_color = backdrop.background_color(camera)
	_dust_follow()

## The original's chase camera: 2000 units behind and 700 above the ship,
## aimed 850 above it, easing an eighth of the way each frame; the rear
## view sits 3100 ahead and 600 above, aimed 300 above.
var cam_pos := Vector3.ZERO
var cam_started := false
## Look-around input (-1..1 per axis) and the camera's current swing.
var look_input := Vector2.ZERO
var look_yaw := 0.0
var look_pitch := 0.0

func _sync_probe() -> void:
	var story = space.story
	if story == null or not story.probe_visible:
		if is_instance_valid(probe_node): probe_node.queue_free()
		probe_node = null
		return
	if probe_node == null:
		probe_node = Assembly.figure(library, library.model_name(18))
		probe_node.name = "Probe"
		add_child(probe_node)
	probe_node.transform = Transform3D(story.probe_basis.scaled_local(Vector3.ONE * (768.0 / 4096.0)), story.probe_position * UNIT)

## Photo mode: the flight is frozen and the camera orbits the ship freely.
var photo := false
var photo_yaw := 0.0
var photo_pitch := 0.25
var photo_distance := 3200.0

func _camera(delta: float) -> void:
	var p: Body = space.player
	if photo:
		var orbit := Basis(Vector3.UP, photo_yaw) * Basis(Vector3.RIGHT, -photo_pitch)
		var eye: Vector3 = p.pos + orbit * Vector3(0, 0, -photo_distance)
		camera.global_position = eye * UNIT
		camera.h_offset = 0.0
		camera.v_offset = 0.0
		if not eye.is_equal_approx(p.pos): camera.look_at(p.pos * UNIT, Vector3.UP)
		cam_started = false
		return
	var story = space.story
	if space.using_jump_drive and space.jumping >= 0:
		cam_pos = space.drive_origin + space.drive_basis * Vector3(-2000, 300, 4000)
		cam_started = false
		camera.global_position = cam_pos * UNIT
		if not cam_pos.is_equal_approx(p.pos): camera.look_at(p.pos * UNIT, p.basis.y)
		return
	if space.starting():
		# The original's start: the camera stays put and watches the ship go.
		cam_pos = space.start_camera
		# Afterwards the chase camera starts afresh behind the ship.
		cam_started = false
		camera.global_position = cam_pos * UNIT
		camera.h_offset = 0.0
		camera.v_offset = 0.0
		if not cam_pos.is_equal_approx(p.pos): camera.look_at(p.pos * UNIT, p.basis.y)
		return
	if space.portal_arriving():
		cam_pos = space.portal_arrival_camera
		cam_started = true
		camera.global_position = cam_pos * UNIT
		if not cam_pos.is_equal_approx(p.pos): camera.look_at(p.pos * UNIT, Vector3.UP)
		return
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
	if space.turret_mode:
		# From just above the hull, looking where the turret points.
		var eye: Vector3 = p.pos + p.basis * Vector3(0, 900, 0)
		camera.global_position = eye * UNIT
		var dir: Vector3 = space.aim_direction()
		camera.look_at((eye + dir * 10000.0) * UNIT, p.basis.y)
		cam_started = false
		return
	var offset := Vector3(0, 700, -2000) if not rear_view else Vector3(0, 600, 3100)
	var aim := Vector3(0, 850, 0) if not rear_view else Vector3(0, 300, 0)
	# Looking around swings the camera about the ship and eases back behind
	# it when released.
	var look_k := 1.0 - pow(0.001, delta)
	look_yaw = lerpf(look_yaw, -look_input.x * PI * 0.95, look_k)
	look_pitch = lerpf(look_pitch, look_input.y * PI * 0.4, look_k)
	if absf(look_yaw) > 0.001 or absf(look_pitch) > 0.001:
		offset = Basis(Vector3.UP, look_yaw) * Basis(Vector3.RIGHT, look_pitch) * offset
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

## Main/o uses supplied geometry6783 for the drive flash. The native timer
## poses that animation without substituting generated artwork or gate art.
func _sync_drive() -> void:
	if not space.using_jump_drive or space.jumping < 0:
		if is_instance_valid(drive_node): drive_node.visible = false
		return
	var model: String = library.model_name(6783)
	if model.is_empty(): return
	if drive_node == null:
		drive_node = Assembly.figure(library, model, 0)
		drive_node.name = "KhadorDriveFlash"
		add_child(drive_node)
	drive_node.visible = true
	drive_node.transform = Transform3D(space.drive_basis, (space.drive_origin + space.drive_basis.z * 5000.0) * UNIT)
	var anim: Dictionary = library.animation(model)
	if not anim.is_empty() and not anim.get("actions", []).is_empty():
		_set_frame(drive_node, anim, int(clampf(space.jumping / 2500.0, 0.0, 0.999) * int(anim.actions[0].last_frame)))

## The carrier remains where physics put it; only the imported container
## moves along the native beam. This geometry never changes the simulation.
func _sync_tractor() -> void:
	var pulling_crate: bool = space.tractor.crate_pulling and space.tractor.crate != null
	if (space.tractor.source == null and not pulling_crate) or space.navigation_locked():
		if is_instance_valid(tractor_crate): tractor_crate.visible = false
		if is_instance_valid(tractor_beam): tractor_beam.visible = false
		return
	if tractor_crate == null:
		tractor_crate = Assembly.figure(library, "box", 0)
		tractor_crate.name = "TractorContainer"
		tractor_crate.scale = Vector3.ONE * 4.0
		add_child(tractor_crate)
	if tractor_beam == null:
		tractor_beam = MeshInstance3D.new()
		tractor_beam.name = "TractorBeam"
		tractor_beam.mesh = ImmediateMesh.new()
		var material := StandardMaterial3D.new()
		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		material.cull_mode = BaseMaterial3D.CULL_DISABLED
		material.albedo_color = Color(0.4, 0.75, 1.0, 0.65)
		tractor_beam.material_override = material
		add_child(tractor_beam)
		# Enhanced lighting: the beam's glow on the container it holds.
		tractor_light = Lighting.point(tractor_beam, Color(0.4, 0.75, 1.0), 9.0)
		tractor_light.light_energy = 0.8
	# A wreck crate is drawn as itself; a disabled ship's container is not
	# a body of its own until it arrives.
	var crate_at: Vector3 = space.tractor.crate.pos if pulling_crate else space.tractor.position
	tractor_crate.visible = not pulling_crate
	tractor_crate.position = crate_at * UNIT
	tractor_beam.visible = true
	tractor_light.position = crate_at * UNIT
	var mesh: ImmediateMesh = tractor_beam.mesh
	mesh.clear_surfaces()
	var start: Vector3 = (space.player.pos + space.player.forward() * 1024.0) * UNIT
	var end: Vector3 = crate_at * UNIT
	var along := (end - start).normalized()
	var side := along.cross(Vector3.UP)
	if side.length_squared() < 0.0001: side = along.cross(Vector3.RIGHT)
	side = side.normalized() * 100.0 * UNIT
	for axis in [side, along.cross(side)]:
		mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
		for vertex in [start - axis, start + axis, end - axis, end + axis]: mesh.surface_add_vertex(vertex)
		mesh.surface_end()

# ------------------------------------------------------------------ trails

## The original's engine trails behind fighters: a ribbon through the
## ship's positions sampled every 200 ms, sixteen long (thirteen for
## pirates and Voids), textured with a strip of space.png (blue-white, or
## white through yellow to red) and drawn additively so its dark end fades
## out. The original's strip lay flat; this one faces the camera so it
## reads from every side.
const TRAIL_STEP_MS := 200
const TRAIL_WIDTH := 60.0
## Trails fade out close to the camera (world units), so a wingman's
## ribbon never sweeps across the view as a solid band.
const TRAIL_FADE_NEAR := 500.0
const TRAIL_FADE_FULL := 2000.0
## The space.png regions: x, top row, width, rows; the bottom row is the
## ship's end.
const TRAIL_REGIONS := [Rect2i(80, 224, 16, 32), Rect2i(32, 228, 32, 13)]
var trails := {}
var trail_mesh: MeshInstance3D
var trail_materials: Array = []

func _trail_materials() -> Array:
	var tex: Texture2D = library.atlas_texture("space")
	var img: Image = tex.get_image() if tex != null else null
	var out: Array = []
	for kind in 2:
		var mat := StandardMaterial3D.new()
		mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		mat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
		mat.cull_mode = BaseMaterial3D.CULL_DISABLED
		mat.depth_draw_mode = BaseMaterial3D.DEPTH_DRAW_DISABLED
		mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR
		mat.vertex_color_use_as_albedo = true
		var region: Rect2i = TRAIL_REGIONS[kind]
		if img != null and Rect2i(Vector2i.ZERO, img.get_size()).encloses(region):
			var part := img.get_region(region)
			part.convert(Image.FORMAT_RGBA8)
			# Additive: let transparent texels add nothing.
			for y in part.get_height():
				for x in part.get_width():
					var c := part.get_pixel(x, y)
					part.set_pixel(x, y, Color(c.r * c.a, c.g * c.a, c.b * c.a, 1.0))
			mat.albedo_texture = ImageTexture.create_from_image(part)
		else:
			mat.albedo_color = Color(0.3, 0.45, 0.7) if kind == 0 else Color(0.7, 0.45, 0.2)
		out.append(mat)
	return out

## Other ships only: the player's own trail would run back through the
## chase camera.
func _trailed(b: Body) -> bool:
	return b != space.player and b.kind == Body.Kind.SHIP and b.alive and b.visible and b.ship_index >= 0 and not b.disabled

func _sync_trails() -> void:
	if trail_materials.is_empty(): trail_materials = _trail_materials()
	if trail_mesh == null:
		trail_mesh = MeshInstance3D.new()
		trail_mesh.name = "Trails"
		trail_mesh.mesh = ImmediateMesh.new()
		trail_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		add_child(trail_mesh)
	var clock: int = space.clock
	var live := {}
	for b in space.bodies:
		if not _trailed(b): continue
		live[b] = true
		var t: Dictionary = trails.get(b, {})
		var length := 13 if b.faction == 8 or b.faction == 9 else 16
		if t.is_empty() or (t.points as Array).is_empty() or b.pos.distance_to(t.points[0]) > 20000.0:
			# New, or moved by a jump: start again where it is.
			t = {"points": [b.pos], "at": clock, "kind": 1 if length == 13 else 0}
			trails[b] = t
		elif clock - int(t.at) >= TRAIL_STEP_MS:
			t.at = clock
			(t.points as Array).push_front(b.pos)
			while (t.points as Array).size() > length: (t.points as Array).pop_back()
	for b in trails.keys():
		if not live.has(b): trails.erase(b)
	var mesh: ImmediateMesh = trail_mesh.mesh
	mesh.clear_surfaces()
	if trails.is_empty(): return
	var eye := camera.global_position
	for kind in 2:
		var begun := false
		for b in trails:
			var t: Dictionary = trails[b]
			if int(t.kind) != kind: continue
			# The newest point follows the ship; the rest are the samples.
			var pts: Array = [b.pos] + (t.points as Array).slice(1)
			if pts.size() < 2: continue
			var length := 13 if kind == 1 else 16
			if not begun:
				mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES, trail_materials[kind])
				begun = true
			var edges: Array = []
			for i in pts.size():
				var p: Vector3 = pts[i] * UNIT
				var along: Vector3 = (pts[maxi(0, i - 1)] - pts[mini(pts.size() - 1, i + 1)]) * UNIT
				var side := (p - eye).cross(along)
				# A ship that has hardly moved leaves no ribbon: the original's
				# quads of a still trail have no area. Full width only once the
				# samples are a trail's width apart, so waiting or bobbing ships
				# never draw squares.
				var reach := clampf(along.length() / (TRAIL_WIDTH * UNIT * 4.0), 0.0, 1.0)
				side = side.normalized() * TRAIL_WIDTH * UNIT * reach if side.length_squared() > 0.0000001 else Vector3.ZERO
				# v runs from the ship's end (the region's bottom) back.
				var near := clampf((p.distance_to(eye) / UNIT - TRAIL_FADE_NEAR) / (TRAIL_FADE_FULL - TRAIL_FADE_NEAR), 0.0, 1.0)
				edges.append([p - side, p + side, 1.0 - float(i) / length, Color(near, near, near)])
			for i in edges.size() - 1:
				var a: Array = edges[i]
				var n: Array = edges[i + 1]
				for v in [[a[0], 0.0, a[2], a[3]], [a[1], 1.0, a[2], a[3]], [n[0], 0.0, n[2], n[3]], [a[1], 1.0, a[2], a[3]], [n[1], 1.0, n[2], n[3]], [n[0], 0.0, n[2], n[3]]]:
					mesh.surface_set_color(v[3])
					mesh.surface_set_uv(Vector2(v[1], v[2]))
					mesh.surface_add_vertex(v[0])
		if begun: mesh.surface_end()

## Shots nearer the camera than this (original units) are not drawn.
const SHOT_NEAR := 700.0
const SHOT_THIN := 5000.0

func _sync_shots() -> void:
	var shots: Array = space.projectiles + space.spent
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
			# How far the bolt's streak trails behind its head (the bolt faces
			# -z, so its tail is its furthest +z).
			entry.tail = maxf(0.0, _furthest_z(m, m.transform))
		# A bolt grazing the camera would sweep across the whole screen for
		# a frame; it is gone by the next one anyway.
		var near := camera.global_position.distance_to(p.pos * UNIT) / UNIT
		node.visible = near > SHOT_NEAR
		# The bolt is a flat fan meant to be seen from afar; passing close to
		# the camera it would fill the view as a wide flat band, so it thins
		# to a streak on the way in.
		var width := clampf((near - SHOT_NEAR) / SHOT_THIN, 0.2, 1.0)
		var dir: Vector3 = (p.vel as Vector3).normalized()
		var up := Vector3.UP if absf(dir.y) < 0.95 else Vector3.RIGHT
		# A fresh bolt's streak would reach back through the ship that fired
		# it: it grows out of the muzzle instead.
		var length := 1.0
		var tail: float = entry.get("tail", 0.0)
		if tail > 0.0 and p.has("muzzle"):
			var out := ((p.pos as Vector3) - (p.muzzle as Vector3)).dot(dir) * UNIT
			length = clampf(out / tail, 0.02, 1.0)
		node.global_transform = Transform3D(Basis.looking_at(dir, up) * Basis.from_scale(Vector3(width, width, length)), p.pos * UNIT)
	_sync_bolt_lights(shots)

## Enhanced lighting: the bolts nearest the camera light what they pass in
## their own colour; a fresh one flares at the muzzle and a spent one at
## the point it struck.
const BOLT_LIGHTS := 6
const BOLT_REACH := 16.0
var bolt_lights: Array[OmniLight3D] = []
func _sync_bolt_lights(shots: Array) -> void:
	if bolt_lights.is_empty():
		for i in BOLT_LIGHTS: bolt_lights.append(Lighting.point(self, Color.WHITE, BOLT_REACH, i >= 2))
	var near: Array = []
	if Lighting.enhanced:
		var eye := camera.global_position
		for i in shots.size():
			var p: Dictionary = shots[i]
			var at: Vector3 = (p.get("hit_at", p.pos) as Vector3) * UNIT
			var d := eye.distance_to(at)
			if d > BOLT_REACH * 12.0: continue
			var strength := 1.0
			if p.has("hit_at"): strength = 2.2
			elif p.has("muzzle") and ((p.pos as Vector3) - (p.muzzle as Vector3)).length() * UNIT < 6.0: strength = 2.6
			near.append([d, at, str(p.weapon.get("model", "")), strength])
		near.sort_custom(func(a, b): return a[0] < b[0])
	for i in bolt_lights.size():
		var light := bolt_lights[i]
		if i >= near.size():
			light.light_energy = 0.0
			continue
		light.position = near[i][1]
		light.light_color = library.model_glow(near[i][2], Color(1.0, 0.6, 0.3))
		light.light_energy = 0.7 * near[i][3]

## The largest z any mesh under `node` reaches, in its parent's space.
static func _furthest_z(node: Node, to_parent: Transform3D) -> float:
	var most := 0.0
	if node is MeshInstance3D and (node as MeshInstance3D).mesh != null:
		var box: AABB = to_parent * (node as MeshInstance3D).mesh.get_aabb()
		most = box.end.z
	for c in node.get_children():
		if c is Node3D: most = maxf(most, _furthest_z(c, to_parent * (c as Node3D).transform))
	return most

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
				_spark_frame(node, float(e.time))
	for e in effect_nodes.keys():
		if not alive.has(e):
			effect_nodes[e].queue_free()
			effect_nodes.erase(e)
	_sync_flashes()

## Enhanced lighting: the brightest explosions light the hulls, stations
## and asteroids around them, fading as they burn out.
const FLASH_REACH := 9000.0
const FLASH_LIGHTS := 4
var flash_lights: Array[OmniLight3D] = []
func _sync_flashes() -> void:
	var lights: Array = []
	if Lighting.enhanced:
		for e in space.effects:
			var k := clampf(float(e.time) / maxf(0.001, float(e.life)), 0.0, 1.0)
			var reach := 0.0
			var color := Color(1.0, 0.62, 0.28)
			match str(e.kind):
				"explosion": reach = FLASH_REACH * float(e.get("scale", 1.0))
				"asteroid": reach = FLASH_REACH * 0.6; color = Color(0.9, 0.7, 0.45)
				"blast":
					reach = float(e.radius) * 1.6
					if e.get("emp", false): color = Color(0.45, 0.65, 1.0)
			if reach <= 0.0: continue
			var strength := pow(1.0 - k, 1.5)
			var near := 1.0 / (1.0 + camera.global_position.distance_to((e.pos as Vector3) * UNIT) / (reach * UNIT * 4.0))
			lights.append([strength * near, (e.pos as Vector3) * UNIT, reach * UNIT, color, strength])
		lights.sort_custom(func(a, b): return a[0] > b[0])
	for i in flash_lights.size():
		var light := flash_lights[i]
		if i < lights.size():
			var l: Array = lights[i]
			light.position = l[1]
			light.omni_range = l[2]
			light.light_color = l[3]
			light.light_energy = 2.5 * l[4]
		else:
			light.light_energy = 0.0

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
		"spark":
			return _spark_node()
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

## Level's gun sparks: ten fire sprites from the space atlas, scattered a
## quarter of their full size about the hit, each swelling to 500 units over
## its own ~0.7 s and then fading.
const SPARK_REGION := Rect2i(33, 225, 30, 30)
const SPARK_COUNT := 10
const SPARK_SIZE := 500.0
var spark_material: StandardMaterial3D

func _spark_node() -> Node3D:
	if spark_material == null:
		spark_material = StandardMaterial3D.new()
		spark_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		spark_material.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
		spark_material.depth_draw_mode = BaseMaterial3D.DEPTH_DRAW_DISABLED
		spark_material.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
		spark_material.billboard_keep_scale = true
		spark_material.vertex_color_use_as_albedo = true
		var tex: Texture2D = library.atlas_texture("space")
		var img: Image = tex.get_image() if tex != null else null
		if img != null and Rect2i(Vector2i.ZERO, img.get_size()).encloses(SPARK_REGION):
			var part := img.get_region(SPARK_REGION)
			part.convert(Image.FORMAT_RGBA8)
			# Additive: let transparent texels add nothing.
			for y in part.get_height():
				for x in part.get_width():
					var c := part.get_pixel(x, y)
					part.set_pixel(x, y, Color(c.r * c.a, c.g * c.a, c.b * c.a, 1.0))
			spark_material.albedo_texture = ImageTexture.create_from_image(part)
		else:
			spark_material.albedo_color = Color(1.0, 0.6, 0.25)
	var quad := QuadMesh.new()
	quad.size = Vector2.ONE
	quad.material = spark_material
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.use_colors = true
	mm.mesh = quad
	mm.instance_count = SPARK_COUNT
	var node := MultiMeshInstance3D.new()
	node.multimesh = mm
	node.extra_cull_margin = SPARK_SIZE * UNIT
	var spread := SPARK_SIZE * UNIT / 4.0
	var bits: Array = []
	for i in SPARK_COUNT:
		bits.append([Vector3(randf_range(-spread, spread), randf_range(-spread, spread), randf_range(-spread, spread)),
			space.SPARK_GROW + randf_range(-0.05, 0.05)])
	node.set_meta("bits", bits)
	_spark_frame(node, 0.0)
	return node

func _spark_frame(node: Node3D, time: float) -> void:
	var mm: MultiMesh = (node as MultiMeshInstance3D).multimesh
	var bits: Array = node.get_meta("bits")
	for i in bits.size():
		var grow: float = bits[i][1]
		var size := SPARK_SIZE * UNIT * minf(1.0, time / grow)
		var fade := 1.0 - clampf((time - grow) / space.SPARK_FADE, 0.0, 1.0)
		mm.set_instance_transform(i, Transform3D(Basis.from_scale(Vector3.ONE * maxf(size, 0.001)), bits[i][0]))
		mm.set_instance_color(i, Color(fade, fade, fade, 1.0))

## Poses a skinned model at one frame of its first action.
func _set_frame(node: MeshInstance3D, anim: Dictionary, frame: int) -> void:
	var action: Dictionary = anim.actions[0]
	frame = clampi(frame, 0, int(action.last_frame))
	var source: Dictionary = library.model_data(node.name)
	if source.is_empty(): return
	var transforms := Library.bone_transforms(source, action.matrices[frame])
	for i in node.get_surface_override_material_count():
		var mat: ShaderMaterial = node.get_surface_override_material(i)
		var list: Array = []
		for bi in mini(48, transforms.size()):
			var t: Transform3D = transforms[bi]
			list.append(Projection(t))
		while list.size() < 48: list.append(Projection.IDENTITY)
		mat.set_shader_parameter("bones", list)

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
	# A speck drifting past the lens would fill the screen as a grey square:
	# nearby ones fade out before they get that close.
	mat.distance_fade_mode = BaseMaterial3D.DISTANCE_FADE_PIXEL_ALPHA
	mat.distance_fade_min_distance = 4.0
	mat.distance_fade_max_distance = 12.0
	quad.material = mat
	mm.mesh = quad
	mm.instance_count = 160
	for i in mm.instance_count:
		mm.set_instance_transform(i, Transform3D(Basis.IDENTITY, Vector3(randf_range(-40, 40), randf_range(-40, 40), randf_range(-40, 40))))
	dust.multimesh = mm
	add_child(dust)

func _dust_follow() -> void:
	dust.visible = Prefs.dust(app)
	camera.fov = Prefs.fov(app)
	# Held upright the screen is the original's own shape: the angle spans
	# its width again, and the view gains height instead of becoming a slit.
	var shape := get_viewport().get_visible_rect().size
	camera.keep_aspect = Camera3D.KEEP_WIDTH if shape.y > shape.x else Camera3D.KEEP_HEIGHT
	if not dust.visible: return
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
	if kind == "hit":
		if Prefs.screen_shake(app): shake = 0.4
		Prefs.rumble(app, 0.5, 0.2)
