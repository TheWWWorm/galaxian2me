extends RefCounted
## The real lights of enhanced lighting: a key light (the system's sun in
## flight, the ceiling in the station), ambient light and sky reflections,
## and point lights at what glows: engines, weapon fire, explosions, the
## wormhole and tractor beam, and the lamps, window rows and glow faces of
## stations, gates, the hangar and the lounge. Every view adds its lights
## through here; they stay out while the original's flat phone lighting is
## chosen, since that look is drawn entirely by the model shader.
##
## Graphics options: shadows, metal reflections, and light sources (Off,
## Few, Many). A point light made with `many` only shows at Many.

const GROUP := "gof_lights"
const SUN_GROUP := "gof_sun"
const SOURCE_GROUP := "gof_sources"
const ENV_GROUP := "gof_environments"
const SOURCE_NAMES := ["Off", "Few", "Many"]

static var enhanced := false
static var shadows := true
static var reflections := true
static var sources := 2

## Applies the current options to every light and environment in the tree.
static func apply(tree: SceneTree, on: bool, with_shadows: bool, with_reflections := true, source_level := 2) -> void:
	enhanced = on
	shadows = with_shadows
	reflections = with_reflections
	sources = clampi(source_level, 0, 2)
	RenderingServer.global_shader_parameter_set("gof_enhanced", 1.0 if on else 0.0)
	RenderingServer.global_shader_parameter_set("gof_metal", 1.0 if with_reflections else 0.0)
	if tree == null: return
	for light in tree.get_nodes_in_group(GROUP): light.visible = on
	for light in tree.get_nodes_in_group(SUN_GROUP): light.shadow_enabled = on and with_shadows
	for light in tree.get_nodes_in_group(SOURCE_GROUP): light.visible = _shown(light)
	for world in tree.get_nodes_in_group(ENV_GROUP): _reflect(world.environment)

static func _shown(light: Node) -> bool:
	return enhanced and sources > 0 and (sources == 2 or not light.get_meta("many", false))

## A directional key light shining along `towards_scene`; `reach` is how
## far from the camera its shadows are drawn.
static func key_light(parent: Node, towards_scene: Vector3, color: Color, energy: float, reach: float) -> DirectionalLight3D:
	var light := DirectionalLight3D.new()
	light.name = "KeyLight"
	var d := towards_scene.normalized()
	light.basis = Basis.looking_at(d, Vector3.UP if absf(d.y) < 0.95 else Vector3.RIGHT)
	light.light_color = color
	light.light_energy = energy
	light.light_specular = 1.0
	light.directional_shadow_mode = DirectionalLight3D.SHADOW_PARALLEL_4_SPLITS
	light.directional_shadow_max_distance = reach
	light.directional_shadow_blend_splits = true
	light.shadow_bias = 0.04
	light.shadow_normal_bias = 1.2
	light.shadow_blur = 1.5
	light.shadow_enabled = enhanced and shadows
	light.visible = enhanced
	light.add_to_group(GROUP)
	light.add_to_group(SUN_GROUP)
	parent.add_child(light)
	return light

## A soft, unshadowed directional light shining along `towards_scene`.
static func fill_light(parent: Node, towards_scene: Vector3, color: Color, energy: float) -> DirectionalLight3D:
	var fill := DirectionalLight3D.new()
	fill.name = "Fill"
	var d := towards_scene.normalized()
	fill.basis = Basis.looking_at(d, Vector3.UP if absf(d.y) < 0.95 else Vector3.RIGHT)
	fill.light_color = color
	fill.light_energy = energy
	fill.light_specular = 0.2
	fill.shadow_enabled = false
	fill.visible = enhanced
	fill.add_to_group(GROUP)
	parent.add_child(fill)
	return fill

## Light a system's sky gives a scene: the sun as the key light, tinted
## towards the star's own colour, and a soft coloured fill from its planet,
## as sunlight bounced off it. Returns the key light.
static func sky_lights(parent: Node, backdrop, reach: float) -> DirectionalLight3D:
	var star: Color = Color(1.0, 0.95, 0.88).lerp(backdrop.sun_color, 0.18)
	var key := key_light(parent, -backdrop.sun_direction, star, 1.15, reach)
	if backdrop.planet_direction != Vector3.ZERO:
		var planet: Color = backdrop.planet_color
		# Half its colour: a hint of the planet, not a coloured floodlight.
		var hue: Color = planet / maxf(0.001, maxf(planet.r, maxf(planet.g, planet.b)))
		fill_light(parent, -backdrop.planet_direction, Color(1, 1, 1).lerp(hue, 0.5),
			clampf(planet.get_luminance() * 0.6, 0.05, 0.18)).name = "PlanetFill"
	return key

## A point light that follows the options (explosions, engines, lamps).
## `many`: shown only when light sources are set to Many.
static func point(parent: Node, color: Color, reach: float, many := false) -> OmniLight3D:
	var light := OmniLight3D.new()
	light.light_color = color
	light.omni_range = reach
	# Godot's falloff also divides by distance^attenuation in world units,
	# which at station scale (tens of units) leaves almost nothing. The
	# range's own smooth falloff alone scales with the scene.
	light.omni_attenuation = 0.0
	light.light_specular = 0.6
	light.shadow_enabled = false
	light.set_meta("many", many)
	light.visible = _shown(light)
	light.add_to_group(SOURCE_GROUP)
	parent.add_child(light)
	return light

## A ship's engine flames light the stern around its nozzles, in the
## colour of the flame model. Only the player's own at Few. The flight view
## drives its brightness from the throttle (meta "light" on "Boosters").
static func engine_light(ship: Node3D, library, own: bool) -> void:
	var boosters := ship.get_node_or_null("Boosters")
	if boosters == null or boosters.get_child_count() == 0: return
	var centre := Vector3.ZERO
	var spread := 0.0
	for flame: Node3D in boosters.get_children(): centre += flame.position
	centre /= boosters.get_child_count()
	for flame: Node3D in boosters.get_children(): spread = maxf(spread, flame.position.distance_to(centre))
	var first: Node3D = boosters.get_child(0)
	var glow: Color = library.model_glow(str(first.get_meta("model", "")), Color(0.42, 0.66, 1.0))
	var light := point(boosters, glow, maxf(7.0, spread * 3.0 + centre.length() * 2.4), not own)
	# Just behind the flames, clear of the engine housing, so it lights the
	# stern rather than only the inside of the nozzles.
	var out := Vector3(centre.x, 0.0, centre.z)
	light.position = centre + (out.normalized() if out.length() > 0.01 else Vector3.BACK) * maxf(1.2, spread * 0.8)
	light.light_energy = 2.0
	boosters.set_meta("light", light)

## Lights at the places a model glows (Library.light_points), for every
## converted model under `root`, in `root`'s space: at most `budget`, the
## first `few` of them shown at Few. Each reaches `share` of the whole
## model's size; clusters closer than that merge into one light.
static func model_lights(root: Node3D, library, budget: int, few: int, energy: float, share: float) -> void:
	var found: Array = []
	var box := [AABB()]
	_gather(root, Transform3D.IDENTITY, library, found, true, box)
	var reach: float = maxf(1.0, (box[0] as AABB).get_longest_axis_size() * share)
	found.sort_custom(func(a, b): return a.weight > b.weight)
	var placed: Array = []
	for p in found:
		if placed.size() >= budget: break
		var near := false
		for q in placed:
			if (q.pos as Vector3).distance_to(p.pos) < reach * 0.6: near = true; break
		if near: continue
		placed.append(p)
	if placed.is_empty(): return
	var top: float = placed[0].weight
	for i in placed.size():
		var p: Dictionary = placed[i]
		var light := point(root, p.color, reach, i >= few)
		light.position = p.pos
		light.light_energy = energy * lerpf(0.55, 1.0, clampf(p.weight / top, 0.0, 1.0))

static func _gather(node: Node, at: Transform3D, library, found: Array, is_root: bool, box: Array) -> void:
	var here: Transform3D = at if is_root else at * ((node as Node3D).transform if node is Node3D else Transform3D.IDENTITY)
	if node is MeshInstance3D and (node as MeshInstance3D).mesh != null:
		var b: AABB = here * (node as MeshInstance3D).mesh.get_aabb()
		box[0] = b if (box[0] as AABB).size == Vector3.ZERO else (box[0] as AABB).merge(b)
	if node is MeshInstance3D and node.has_meta("model"):
		for p in library.light_points(str(node.get_meta("model"))):
			found.append({"pos": here * (p.pos as Vector3), "color": p.color, "weight": p.weight})
	for c in node.get_children(): _gather(c, here, library, found, false, box)

## Ambient light for the side of a scene turned away from its key light,
## and a soft sky for metal to reflect (from above `top`, around `horizon`,
## from below `below`) while metal reflections are on. The Compatibility
## renderer shades in the phone's own sRGB space, so the ambient share reads
## like the original's (about 0.4). No bloom: that renderer's glow lifts the
## clear colour of the background several times over.
static func environment(world: WorldEnvironment, ambient: Color, top := Color(0.2, 0.22, 0.28), horizon := Color(0.3, 0.3, 0.33), below := Color(0.03, 0.03, 0.04)) -> void:
	var env := world.environment
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = ambient
	env.ambient_light_energy = 1.0
	env.ambient_light_sky_contribution = 0.0
	# A bright band between a dark sky and a darker floor: metal reads as
	# metal by the contrast it reflects, not by how much.
	var sky := Sky.new()
	var look := ProceduralSkyMaterial.new()
	look.sky_top_color = top
	look.sky_horizon_color = horizon
	look.sky_curve = 0.06
	look.ground_horizon_color = horizon.darkened(0.2)
	look.ground_bottom_color = below
	look.ground_curve = 0.04
	look.sun_angle_max = 6.0
	look.sun_curve = 0.08
	sky.sky_material = look
	sky.radiance_size = Sky.RADIANCE_SIZE_128
	env.sky = sky
	world.add_to_group(ENV_GROUP)
	_reflect(env)

static func _reflect(env: Environment) -> void:
	if env == null: return
	env.reflected_light_source = Environment.REFLECTION_SOURCE_SKY if enhanced and reflections and env.sky != null else Environment.REFLECTION_SOURCE_BG
