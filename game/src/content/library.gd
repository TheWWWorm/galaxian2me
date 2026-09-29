extends RefCounted
## The converted content of one supplied JAR: tables, strings, recovered
## constants, and lazily built Godot resources (meshes, materials, textures,
## sounds). Everything the running game knows about the original comes from
## here; nothing is invented when something is missing.

const Mods := preload("res://src/content/mods.gd")
const ShaderTemplate := preload("res://src/presentation/mascot_shader.gd")
const Formats := preload("res://src/import/formats.gd")

## One model unit of the original is this many Godot units.
const UNIT := 0.01

var id := ""
var root := ""
var manifest := {}
var data := {}
var strings := PackedStringArray()
var language := ""
## Filtered (smooth) or pixelated surfaces, chosen apart for station modules
## and for everything else (ships, rocks, crates), as Deep's options do.
var smooth_textures := false
var smooth_stations := false
var flip_winding := false

var _models := {}
var _meshes := {}
var _anims := {}
var _images := {}
var _textures := {}
var _materials := {}
var _shaders := {}
var _sounds := {}
## Replacement models by name (a template scene, or null for none).
var _replaced := {}
var _registry_by_name := {}

static func installed() -> Array:
	var out: Array = []
	var dir := DirAccess.open("user://content")
	if dir == null: return out
	for sub in dir.get_directories():
		if sub.begins_with("."): continue
		if FileAccess.file_exists("user://content/%s/manifest.json" % sub): out.append(sub)
	return out

func open(content_id: String, preferred_language := "") -> bool:
	var base := "user://content/" + content_id
	var m = JSON.parse_string(FileAccess.get_file_as_string(base + "/manifest.json"))
	var d = JSON.parse_string(FileAccess.get_file_as_string(base + "/data.json"))
	if not (m is Dictionary) or not (d is Dictionary): return false
	if m.get("format", "") != preload("res://src/import/importer.gd").FORMAT: return false
	id = content_id
	root = base
	manifest = m
	data = d
	var langs: Dictionary = data.languages
	language = preferred_language if langs.has(preferred_language) else ("en" if langs.has("en") else langs.keys()[0])
	strings = PackedStringArray(langs[language])
	for key in data.models:
		_registry_by_name[data.models[key].name] = int(key)
	return true

# ------------------------------------------------------------------ text

func text(index: int) -> String:
	if index < 0 or index >= strings.size(): return ""
	return strings[index]

## Replaces the original's inline markers (#C credits, #N name, #S station…)
## with values from `values`.
func format(index: int, values := {}) -> String:
	var s := text(index)
	for key in values: s = s.replace(key, str(values[key]))
	return s

## A constant recovered from a static initializer, by "class.field:descriptor".
func constant(key: String, fallback = null):
	return data.constants.get(key, fallback)

# ------------------------------------------------------------------ images

func image(name: String) -> Image:
	if not _images.has(name):
		var path := root.path_join("img/" + name + ".png")
		var replaced := Mods.image("interface", name)
		_images[name] = replaced if replaced != null else (Image.load_from_file(path) if FileAccess.file_exists(path) else null)
	return _images[name]

## Drops cached images, textures and audio so replaced files are read again.
func forget_replacements() -> void:
	_images.clear()
	_textures.clear()
	_sounds.clear()
	for scene in _replaced.values():
		if scene != null: scene.free()
	_replaced.clear()

func texture(name: String) -> Texture2D:
	if not _textures.has(name):
		var img := image(name)
		_textures[name] = ImageTexture.create_from_image(img) if img != null else null
	return _textures[name]

func face(name: String) -> Texture2D:
	return texture("faces/" + name)

func atlas_texture(name: String) -> Texture2D:
	var key := "tex:" + name
	if not _textures.has(key):
		var path := root.path_join("tex/" + name + ".png")
		var img := Mods.image("textures", name)
		if img == null: img = Image.load_from_file(path) if FileAccess.file_exists(path) else null
		if img != null:
			img.generate_mipmaps()
		_textures[key] = ImageTexture.create_from_image(img) if img != null else null
	return _textures[key]

# ------------------------------------------------------------------ audio

func sound(name: String) -> AudioStream:
	var key := "sfx:" + name
	if not _sounds.has(key):
		var replaced := Mods.audio("sounds", name)
		_sounds[key] = replaced if replaced != null else _wav(root.path_join("sfx/" + name + ".wav"))
	return _sounds[key]

func music(name: String) -> AudioStream:
	var key := "mus:" + name
	if not _sounds.has(key):
		var replaced := Mods.audio("music", name)
		if replaced != null:
			if replaced is AudioStreamOggVorbis or replaced is AudioStreamMP3: replaced.loop = true
			_sounds[key] = replaced
			return replaced
		var s := _wav(root.path_join("music/" + name + ".wav"))
		if s != null:
			s.loop_mode = AudioStreamWAV.LOOP_FORWARD
			s.loop_end = s.data.size() / (4 if s.stereo else 2)
		_sounds[key] = s
	return _sounds[key]

static func _wav(path: String) -> AudioStreamWAV:
	if not FileAccess.file_exists(path): return null
	var info := Formats.wav_info(FileAccess.get_file_as_bytes(path))
	if info.is_empty(): return null
	var s := AudioStreamWAV.new()
	s.mix_rate = info.rate
	s.stereo = info.channels == 2
	if info.bits == 8:
		# WAV 8-bit is unsigned; Godot's 8-bit format is signed.
		var pcm: PackedByteArray = info.data.duplicate()
		for i in pcm.size(): pcm[i] = (pcm[i] - 128) & 0xFF
		s.format = AudioStreamWAV.FORMAT_8_BITS
		s.data = pcm
	else:
		s.format = AudioStreamWAV.FORMAT_16_BITS
		s.data = info.data
	return s

# ------------------------------------------------------------------ geometry

func model_name(model_id: int) -> String:
	var entry = data.models.get(str(model_id))
	return entry.name if entry != null else ""

func model_id(name: String) -> int:
	return _registry_by_name.get(name, -1)

func model_data(name: String) -> Dictionary:
	if not _models.has(name):
		var path := root.path_join("models/" + name + ".json")
		var parsed = JSON.parse_string(FileAccess.get_file_as_string(path)) if FileAccess.file_exists(path) else null
		_models[name] = parsed if parsed is Dictionary else {}
	return _models[name]

func animation(name: String) -> Dictionary:
	if not _anims.has(name):
		var path := root.path_join("anims/" + name + ".json")
		var parsed = JSON.parse_string(FileAccess.get_file_as_string(path)) if FileAccess.file_exists(path) else null
		_anims[name] = parsed if parsed is Dictionary else {}
	return _anims[name]

## The original's world is right-handed with y up and cameras looking down
## −z, like Godot's; only the scale differs.
static func point(v: Array, offset: int) -> Vector3:
	return Vector3(float(v[offset]), float(v[offset + 1]), float(v[offset + 2])) * UNIT

## A 3×4 Micro3D matrix (rows of rotation plus translation).
static func matrix(m: Array, base := 0) -> Transform3D:
	var b := Basis(Vector3(m[base], m[base + 4], m[base + 8]), Vector3(m[base + 1], m[base + 5], m[base + 9]),
		Vector3(m[base + 2], m[base + 6], m[base + 10]))
	return Transform3D(b, Vector3(m[base + 3], m[base + 7], m[base + 11]) * UNIT)

## World transforms of every bone. MTRA matrices are local action DELTAS,
## not replacements for MBAC rest matrices: parent * rest * action. Vertices
## remain bone-local, so no inverse-bind matrix is needed here.
static func bone_transforms(source: Dictionary, frame: Array = []) -> Array[Transform3D]:
	var out: Array[Transform3D] = []
	var bones: Array = source.get("bones", [])
	for i in bones.size():
		var local := matrix(bones[i].matrix)
		if frame.size() >= (i + 1) * 12: local = local * matrix(frame, i * 12)
		var parent: int = bones[i].parent
		out.append(out[parent] * local if parent >= 0 else local)
	return out

## Builds (and caches) a mesh for a model. Static meshes are posed in their
## rest pose on the CPU; `skinned` meshes keep bone-local vertices and a bone
## index in UV2 for the shader. `pattern` selects Micro3D polygon patterns.
func mesh(name: String, skinned := false, pattern := 0) -> Array:
	var key := "%s:%s:%d" % [name, skinned, pattern]
	if _meshes.has(key): return _meshes[key]
	var source := model_data(name)
	if source.is_empty():
		_meshes[key] = []
		return []
	var vertex_bone := PackedInt32Array()
	for i in source.bones.size():
		for _j in int(source.bones[i].vertices): vertex_bone.append(i)
	var rest := bone_transforms(source)
	var groups := {}
	for poly: Dictionary in source.polygons:
		var p := int(poly.pattern)
		if p != 0 and (p & pattern) == 0: continue
		var a: Array = poly.attributes
		var textured := int(poly.texture) >= 0
		var lit := int(a[2 if textured else 3]) != 0
		var spec := int(a[3 if textured else 4]) != 0
		var keyed := textured and int(a[4]) != 0
		var gk := "%d|%d|%s|%s|%s|%s" % [int(poly.texture), int(poly.blend), poly.double_sided, lit, spec, keyed]
		if not groups.has(gk):
			groups[gk] = {"texture": int(poly.texture), "blend": int(poly.blend), "double": bool(poly.double_sided),
				"lit": lit, "specular": spec, "key": keyed, "faces": []}
		groups[gk].faces.append(poly)
	var m := ArrayMesh.new()
	var surfaces: Array = []
	var box := AABB()
	var first := true
	for g: Dictionary in groups.values():
		var verts := PackedVector3Array()
		var norms := PackedVector3Array()
		var uvs := PackedVector2Array()
		var uv2 := PackedVector2Array()
		var colors := PackedColorArray()
		for poly: Dictionary in g.faces:
			var a: Array = poly.attributes
			var stride := 5
			# Blended faces (flames, glows) are often seen edge on, where a
			# corner lying on its region's border reaches the atlas texel
			# beside it: thin dotted lines along the edges. Their texture
			# coordinates are pulled half a texel inside the region.
			var inset := Rect2()
			if g.texture >= 0 and int(g.blend) != 0:
				inset = Rect2(Vector2(a[0], a[1]), Vector2.ZERO)
				for j in poly.indices.size(): inset = inset.expand(Vector2(a[j * stride], a[j * stride + 1]))
			for j in poly.indices.size():
				var index := int(poly.indices[j])
				var bone := vertex_bone[index]
				var v := point(source.vertices, index * 3)
				var n := Vector3.UP
				if source.normals.size() > index * 3 + 2:
					n = point(source.normals, index * 3).normalized()
				if not skinned:
					v = rest[bone] * v
					n = (rest[bone].basis * n).normalized()
				verts.append(v)
				norms.append(n)
				uv2.append(Vector2(bone, 0))
				if g.texture >= 0:
					var uv := Vector2(a[j * stride], a[j * stride + 1])
					if inset.size.x >= 1.0: uv.x = clampf(uv.x, inset.position.x + 0.5, inset.end.x - 0.5)
					if inset.size.y >= 1.0: uv.y = clampf(uv.y, inset.position.y + 0.5, inset.end.y - 0.5)
					uvs.append(uv)
					colors.append(Color.WHITE)
				else:
					uvs.append(Vector2.ZERO)
					colors.append(Color8(a[j * stride], a[j * stride + 1], a[j * stride + 2]))
				if first:
					box = AABB(v, Vector3.ZERO); first = false
				else:
					box = box.expand(v)
		# Micro3D's front faces wind the other way round from Godot's.
		for i in range(0, verts.size() if flip_winding else 0, 3):
			var t := verts[i + 1]; verts[i + 1] = verts[i + 2]; verts[i + 2] = t
			var tn := norms[i + 1]; norms[i + 1] = norms[i + 2]; norms[i + 2] = tn
			var tu := uvs[i + 1]; uvs[i + 1] = uvs[i + 2]; uvs[i + 2] = tu
			var t2 := uv2[i + 1]; uv2[i + 1] = uv2[i + 2]; uv2[i + 2] = t2
			var tc := colors[i + 1]; colors[i + 1] = colors[i + 2]; colors[i + 2] = tc
		var arrays := []
		arrays.resize(Mesh.ARRAY_MAX)
		arrays[Mesh.ARRAY_VERTEX] = verts
		arrays[Mesh.ARRAY_NORMAL] = norms
		arrays[Mesh.ARRAY_TEX_UV] = uvs
		arrays[Mesh.ARRAY_TEX_UV2] = uv2
		arrays[Mesh.ARRAY_COLOR] = colors
		m.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
		surfaces.append(g)
	var result := [m, surfaces, box]
	_meshes[key] = result
	return result

func material(g: Dictionary, skinned := false, station := false) -> ShaderMaterial:
	var blend: int = g.blend
	var smooth := smooth_stations if station else smooth_textures
	var key := "%d|%s|%s|%s|%s|%s|%s|%s" % [blend, g.double, g.lit, g.specular, g.key, g.texture >= 0, skinned, smooth]
	if _materials.has(key): return _materials[key]
	var mode := "blend_mix"
	if blend == 4: mode = "blend_add"
	elif blend == 6: mode = "blend_sub"
	var cull := "cull_disabled" if g.double else "cull_back"
	var filter := "filter_linear_mipmap" if smooth else "filter_nearest"
	var skey := mode + cull + filter
	if not _shaders.has(skey):
		var sh := Shader.new()
		var code: String = ShaderTemplate.CODE.replace("BLEND_MODE", mode).replace("CULL_MODE", cull).replace("FILTER_MODE", filter)
		# Only blended variants belong in the transparent pass; opaque ones
		# keep writing depth so later blended faces are occluded by them.
		if blend != 0:
			code = code.replace("depth_draw_opaque", "depth_draw_never").replace("//ALPHA_LINE", "")
		sh.code = code
		_shaders[skey] = sh
	var mat := ShaderMaterial.new()
	mat.shader = _shaders[skey]
	mat.set_shader_parameter("atlas", atlas_texture("space"))
	var sphere := atlas_texture("spec")
	mat.set_shader_parameter("sphere", sphere)
	mat.set_shader_parameter("has_sphere", sphere != null)
	mat.set_shader_parameter("textured", g.texture >= 0)
	mat.set_shader_parameter("color_key", g.key)
	mat.set_shader_parameter("lit", g.lit and blend == 0)
	mat.set_shader_parameter("specular", g.specular)
	mat.set_shader_parameter("blend_half", 1.0 if blend == 2 else 0.0)
	mat.set_shader_parameter("skinned", skinned)
	if blend != 0: mat.render_priority = 1
	_materials[key] = mat
	return mat

## A ready-to-place instance of a model by file name (without extension).
func instance(name: String, skinned := false, pattern := 0, station := false) -> MeshInstance3D:
	var built := mesh(name, skinned, pattern)
	var node := MeshInstance3D.new()
	node.name = name
	if built.is_empty(): return node
	# A player's glTF in place of a still model: scaled to the converted
	# model's longest extent and centred where it sat. Animated (skinned)
	# figures keep the original, whose motion the simulation relies on; the
	# sky keeps it too, as the backdrop sizes itself from its mesh.
	if not skinned and name != "skybox":
		var scene := replacement_model(name)
		if scene != null:
			_fit(scene, (built[0] as Mesh).get_aabb())
			node.add_child(scene)
			return node
	node.mesh = built[0]
	for i in built[1].size():
		node.set_surface_override_material(i, material(built[1][i], skinned, station))
	if skinned: node.custom_aabb = built[2].grow(built[2].get_longest_axis_size())
	return node

## A fresh copy of the player's replacement for `name`, or null.
func replacement_model(name: String) -> Node3D:
	if not _replaced.has(name): _replaced[name] = Mods.model(name)
	var template: Node3D = _replaced[name]
	return template.duplicate() as Node3D if template != null else null

static func _fit(scene: Node3D, to: AABB) -> void:
	var box := _scene_bounds(scene, Transform3D.IDENTITY)
	if box.size == Vector3.ZERO: return
	var k := to.get_longest_axis_size() / maxf(0.0001, box.get_longest_axis_size())
	scene.transform = Transform3D(Basis.from_scale(Vector3.ONE * k), to.get_center() - box.get_center() * k)

static func _scene_bounds(node: Node, at: Transform3D) -> AABB:
	var here: Transform3D = at * ((node as Node3D).transform if node is Node3D else Transform3D.IDENTITY)
	var box := AABB()
	if node is MeshInstance3D and node.mesh != null: box = here * node.mesh.get_aabb()
	for c in node.get_children():
		var child := _scene_bounds(c, here)
		if child.size == Vector3.ZERO: continue
		box = child if box.size == Vector3.ZERO else box.merge(child)
	return box

func instance_by_id(model: int, skinned := false) -> MeshInstance3D:
	return instance(model_name(model), skinned)
