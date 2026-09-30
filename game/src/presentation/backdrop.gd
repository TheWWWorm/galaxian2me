extends Node3D
## The sky of a star system as the original composes it: the textured
## skybox model, the system's sun (a quarter sprite mirrored four ways), the
## docking station's planet, the other stations of the system as small star
## sprites on the same ring, and a few nebulae. Placement uses the original's
## seeded ring of 24 positions. The backdrop follows the camera.

const Assembly := preload("res://src/presentation/assembly.gd")
const JavaRandom := preload("res://src/simulation/java_random.gd")

## Sky objects sit this far out, inside the camera's range so nearer
## geometry hides them; sizes below are given for a radius of 200.
const RADIUS := 3500.0
const SIZE := RADIUS / 200.0
## Star sprite per planet texture, from the original's lookup table.
var star_for_planet: Array = [5, 1, 2, 3, 0, 2, 4, 5, 4, 4, 1, 5, 2, 3, 2, 3, 2, 2, 2, 5]

var library
var sun_direction := Vector3(0, 0, -1)
var tint := Color(0.04, 0.05, 0.04)
## For enhanced lighting: the star's colour (from its sprite) and the planet's
## (from its picture), and where the planet stands. No planet in Void space.
var sun_color := Color(1, 1, 1)
var planet_direction := Vector3.ZERO
var planet_color := Color(0, 0, 0)
var sky: MeshInstance3D
var sprites: Array = []
## The skybox's stars redrawn at screen resolution (null when the skybox is
## not made of star quads); shown instead of the skybox while `crisp` is on.
var stars: MeshInstance3D
const GROUP := "gof_backdrops"
static var crisp := true

func setup(lib, station_id: int, catalogue) -> void:
	library = lib
	var st: Dictionary = catalogue.station(station_id)
	var system: Dictionary = catalogue.system(int(st.get("system", 0)))
	# Skybox: the imported starfield, drawn behind everything.
	sky = lib.instance("skybox")
	var extent: float = sky.mesh.get_aabb().get_longest_axis_size() / 2.0 if sky.mesh != null else 1.0
	sky.scale = Vector3.ONE * (RADIUS * 1.2 / maxf(0.001, extent))
	sky.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	for i in sky.get_surface_override_material_count():
		var m: ShaderMaterial = sky.get_surface_override_material(i).duplicate()
		m.set_shader_parameter("lit", false)
		m.render_priority = -100
		m.shader = _sky_shader(m.shader)
		sky.set_surface_override_material(i, m)
	add_child(sky)
	stars = _crisp_stars(sky, lib)
	if stars != null:
		add_child(stars)
		add_to_group(GROUP)
		show_stars(crisp)
	if station_id == -1:
		# There is no ordinary star system in Void space: no planet, station
		# markers or normal-system nebulae. The source uses the green default.
		tint = Color(10.0 / 765.0, 136.0 / 765.0, 10.0 / 765.0)
		sun_direction = Vector3(0, 0, 1)
		_sprite(_sun_texture(0), sun_direction, 60.0, true)
		sun_color = _hue(lib.image("sun_0"), true)
		return
	var color: Array = system.get("color", [10, 136, 10])
	if color.size() >= 3:
		tint = Color(color[0] / 3.0 / 255.0, color[1] / 3.0 / 255.0, color[2] / 3.0 / 255.0)
	var sky_layout := layout(lib, catalogue, station_id)
	sun_direction = sky_layout.sun
	_sprite(_sun_texture(int(system.get("star", 0))), sun_direction, 60.0, true)
	_sprite(lib.texture("planet_%d" % int(st.get("planet", 0))), sky_layout.planet, 55.0, false)
	sun_color = _hue(lib.image("sun_%d" % int(system.get("star", 0))), true)
	planet_direction = sky_layout.planet
	planet_color = _hue(lib.image("planet_%d" % int(st.get("planet", 0))), false)
	for sid in sky_layout.stars:
		var entry: Dictionary = sky_layout.stars[sid]
		_sprite(lib.texture("star_%d" % int(entry.image)), entry.direction, 5.0, true)
	for n in sky_layout.nebulae:
		_sprite(lib.texture("nebula%d" % int(n.image)), n.direction, 50.0, true)

## The mean colour of a picture's visible texels: scaled to full brightness
## for a star (its light's hue), kept at its own brightness for a planet (the
## light it reflects).
static func _hue(img: Image, full: bool) -> Color:
	if img == null: return Color(1, 1, 1) if full else Color(0, 0, 0)
	var small := img.duplicate() as Image
	if small.is_compressed(): small.decompress()
	small.convert(Image.FORMAT_RGBA8)
	small.resize(16, 16, Image.INTERPOLATE_BILINEAR)
	var sum := Vector3.ZERO
	var weight := 0.0
	for y in 16:
		for x in 16:
			var c := small.get_pixel(x, y)
			var w := c.a * (maxf(c.r, maxf(c.g, c.b)) if full else 1.0)
			sum += Vector3(c.r, c.g, c.b) * w
			weight += w
	if weight <= 0.0: return Color(1, 1, 1) if full else Color(0, 0, 0)
	sum /= weight
	if full: sum /= maxf(0.001, maxf(sum.x, maxf(sum.y, sum.z)))
	return Color(sum.x, sum.y, sum.z)

## Where the sky's objects sit, by the original's seeded placement: the sun,
## this station's planet, the other stations' stars and the nebulae.
static func layout(lib, catalogue, station_id: int) -> Dictionary:
	var st: Dictionary = catalogue.station(station_id)
	var system: Dictionary = catalogue.system(int(st.get("system", 0)))
	var star_table: Array = [5, 1, 2, 3, 0, 2, 4, 5, 4, 4, 1, 5, 2, 3, 2, 3, 2, 2, 2, 5]
	var h_table = lib.constant("h#b:[I")
	if h_table is Array and h_table.size() >= 20: star_table = h_table
	var r := JavaRandom.new(station_id * 300)
	var used := {}
	var sun_slot := r.next_int(24)
	used[sun_slot] = true
	var out := {"sun": _ring(sun_slot, 0), "planet": Vector3.FORWARD, "stars": {}, "nebulae": []}
	for sid in system.get("stations", []):
		var slot := 0
		if int(sid) == station_id:
			var planet := int(st.get("planet", 0))
			if planet == 17 or planet == 18:
				slot = sun_slot
			else:
				while true:
					slot = r.next_int(24)
					if absi(slot - sun_slot) > 3 and not used.has(slot): break
			used[slot] = true
			out.planet = _ring(slot, 0, 64 if slot == sun_slot else 0)
		else:
			while true:
				slot = 7 + r.next_int(11)
				if absi(slot - sun_slot) > 2 and not used.has(slot): break
			used[slot] = true
			var tilt := -128 + r.next_int(256)
			var other: Dictionary = catalogue.station(int(sid))
			out.stars[int(sid)] = {"direction": _ring(slot, tilt), "image": star_table[int(other.get("planet", 0)) % star_table.size()]}
	var nebula_count := r.next_int(8)
	var spots = lib.constant("h#a:[I")
	if spots is Array and nebula_count > 0:
		var used_spots := {}
		var used_images := {}
		for _n in nebula_count:
			var spot := 0
			while true:
				spot = r.next_int(spots.size() / 3)
				if not used_spots.has(spot): break
			used_spots[spot] = true
			var image := 0
			while true:
				image = r.next_int(8)
				if not used_images.has(image): break
			used_images[image] = true
			var p := Assembly.position([spots[spot], spots[spot + 1], spots[spot + 2]])
			out.nebulae.append({"image": image, "direction": p.normalized()})
	return out

## Direction of ring slot `slot` (170 units apart) with a pitch of `tilt`.
static func _ring(slot: int, tilt: int, extra := 0) -> Vector3:
	var b := Assembly.basis(tilt, slot * 170 + extra, 0)
	# The original moves each sky object 20000 units along its −z axis.
	return (b * Vector3(0, 0, -1)).normalized()

func _sun_texture(star: int) -> Texture2D:
	var quarter: Image = library.image("sun_%d" % star)
	if quarter == null: return null
	var w := quarter.get_width()
	var h := quarter.get_height()
	var img := Image.create(w * 2, h * 2, false, Image.FORMAT_RGBA8)
	var q := quarter.duplicate()
	q.convert(Image.FORMAT_RGBA8)
	img.blit_rect(q, Rect2i(0, 0, w, h), Vector2i(0, 0))
	var m := q.duplicate(); m.flip_x()
	img.blit_rect(m, Rect2i(0, 0, w, h), Vector2i(w - 1, 0))
	var n := q.duplicate(); n.flip_y()
	img.blit_rect(n, Rect2i(0, 0, w, h), Vector2i(0, h - 1))
	var o := m.duplicate(); o.flip_y()
	img.blit_rect(o, Rect2i(0, 0, w, h), Vector2i(w - 1, h - 1))
	return ImageTexture.create_from_image(img)

func _sprite(tex: Texture2D, dir: Vector3, size: float, additive: bool) -> void:
	if tex == null: return
	var q := MeshInstance3D.new()
	var mesh := QuadMesh.new()
	size *= SIZE
	mesh.size = Vector2(size, size * tex.get_height() / float(tex.get_width()))
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.albedo_texture = tex
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	if additive: m.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	m.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	m.render_priority = -90
	m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR
	m.disable_fog = true
	mesh.material = m
	q.mesh = mesh
	q.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	q.position = dir * RADIUS
	add_child(q)
	sprites.append(q)

func _sky_shader(base: Shader) -> Shader:
	var s := Shader.new()
	s.code = base.code.replace("depth_draw_opaque", "depth_draw_never")
	return s

## Keeps the sky centred on the camera and returns the light direction the
## original derives from the sun (towards the sun).
func follow(camera: Camera3D) -> void:
	global_position = camera.global_position
	RenderingServer.global_shader_parameter_set("gof_light_direction", sun_direction)

func background_color(camera: Camera3D) -> Color:
	# Brighter when looking towards the sun, as the original shades its sky.
	var facing := maxf(0.0, (-camera.global_transform.basis.z).dot(sun_direction))
	return tint * (0.4 + 0.6 * facing) + Color(0.004, 0.006, 0.012)

## Crisp stars on or off for every backdrop in the tree.
static func apply(tree: SceneTree, on: bool) -> void:
	crisp = on
	if tree == null: return
	for b in tree.get_nodes_in_group(GROUP): b.show_stars(on)

func show_stars(on: bool) -> void:
	if stars == null: return
	stars.visible = on
	sky.visible = not on

## The original's skybox is a shell of small quads, each showing the same
## 13-texel star picture; enlarged on a large screen they turn into soft
## blobs. Each quad becomes a point drawn at the screen's own resolution: a
## sharp core and a faint halo in the picture's colour, where the quad was.
## Returns null (keeping the skybox) for a skybox of any other make-up.
static func _crisp_stars(sky: MeshInstance3D, lib) -> MeshInstance3D:
	if sky.mesh == null: return null
	var atlas: Texture2D = lib.atlas_texture("space")
	var img: Image = atlas.get_image() if atlas != null else null
	if img == null: return null
	if img.is_compressed(): img.decompress()
	var extent := sky.mesh.get_aabb().get_longest_axis_size()
	var verts := PackedVector3Array()
	var corners := PackedVector2Array()
	var colors := PackedColorArray()
	var indices := PackedInt32Array()
	var tints := {}
	for surface in sky.mesh.get_surface_count():
		var arrays := sky.mesh.surface_get_arrays(surface)
		var pos: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
		var uv: PackedVector2Array = arrays[Mesh.ARRAY_TEX_UV]
		if pos.size() % 6 != 0 or uv.size() != pos.size(): return null
		for q in range(0, pos.size(), 6):
			var box := AABB(pos[q], Vector3.ZERO)
			var region := Rect2(uv[q], Vector2.ZERO)
			var centre := Vector3.ZERO
			for k in 6:
				box = box.expand(pos[q + k])
				region = region.expand(uv[q + k])
				centre += pos[q + k]
			if box.get_longest_axis_size() > extent * 0.05: return null
			var key := region
			if not tints.has(key): tints[key] = _brightest(img, region)
			var tint: Color = tints[key]
			var at := sky.transform * (centre / 6.0)
			var base := verts.size()
			for c in [Vector2(-1, -1), Vector2(1, -1), Vector2(1, 1), Vector2(-1, 1)]:
				verts.append(at); corners.append(c); colors.append(tint)
			indices.append_array([base, base + 1, base + 2, base, base + 2, base + 3])
	if verts.is_empty(): return null
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = verts
	arrays[Mesh.ARRAY_TEX_UV] = corners
	arrays[Mesh.ARRAY_COLOR] = colors
	arrays[Mesh.ARRAY_INDEX] = indices
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	var node := MeshInstance3D.new()
	node.name = "crisp_stars"
	node.mesh = mesh
	node.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var m := ShaderMaterial.new()
	m.shader = _star_shader()
	m.render_priority = -100
	node.material_override = m
	return node

## A star picture's hue: its texels' mean colour weighted by brightness,
## raised to full brightness.
static func _brightest(img: Image, region: Rect2) -> Color:
	var sum := Vector3.ZERO
	var r := Rect2i(region.position.floor(), region.size.ceil()).intersection(Rect2i(Vector2i.ZERO, img.get_size()))
	for y in range(r.position.y, r.end.y):
		for x in range(r.position.x, r.end.x):
			var c := img.get_pixel(x, y)
			var w := c.a * c.get_luminance()
			sum += Vector3(c.r, c.g, c.b) * w
	var top := maxf(sum.x, maxf(sum.y, sum.z))
	if top <= 0.0: return Color(1, 1, 1)
	sum /= top
	return Color(sum.x, sum.y, sum.z)

static var _stars_shader: Shader
static func _star_shader() -> Shader:
	if _stars_shader == null:
		_stars_shader = Shader.new()
		_stars_shader.code = STAR_SHADER
	return _stars_shader

## Sizes are in pixels of a 1080-line picture and follow the screen's height.
const STAR_SHADER := """
shader_type spatial;
render_mode unshaded, blend_add, depth_draw_never, cull_disabled, fog_disabled, shadows_disabled;
uniform float core = 0.9;
uniform float halo = 2.4;
uniform float halo_strength = 0.3;
varying vec2 corner;
varying float pixels;

void vertex() {
	pixels = VIEWPORT_SIZE.y / 1080.0;
	float reach = (halo * 3.0 + 1.0) * pixels;
	vec4 clip = PROJECTION_MATRIX * (MODELVIEW_MATRIX * vec4(VERTEX, 1.0));
	clip.xy += UV * reach * 2.0 / VIEWPORT_SIZE * clip.w;
	POSITION = clip;
	corner = UV * reach;
}

void fragment() {
	float d2 = dot(corner, corner);
	float c = core * pixels, h = halo * pixels;
	float glow = exp(-d2 / (2.0 * c * c)) + halo_strength * exp(-d2 / (2.0 * h * h));
	// The core is paler, the halo keeps the picture's colour.
	ALBEDO = mix(COLOR.rgb * 0.8, vec3(1.0), 0.35 * exp(-d2 / (c * c))) * glow;
}
"""

