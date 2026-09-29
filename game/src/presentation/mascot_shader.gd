extends RefCounted
## Shader template for imported Mascot Capsule geometry. The library fills in
## blend mode, culling and texture filtering per material variant.

const CODE := """shader_type spatial;
// Renders imported Mascot Capsule geometry the way the phone's Effect3D does:
// one texture atlas, per-polygon lighting and colour-keyed transparency, an
// optional sphere-mapped highlight, and the four Micro3D blend modes.
// Blend mode and culling are chosen per material variant by the library.
render_mode BLEND_MODE, CULL_MODE, depth_draw_opaque;

uniform sampler2D atlas : source_color, FILTER_MODE, repeat_disable;
uniform sampler2D sphere : source_color, filter_linear, repeat_disable;
// Material hints derived from the atlas (surface_map.gd): R height,
// G roughness, B lamp emission. Relief reads the height smoothly even when
// the atlas itself is drawn crisp.
uniform sampler2D surface : FILTER_MODE, repeat_disable;
uniform sampler2D relief : filter_linear_mipmap, repeat_disable;
uniform bool has_surface = false;
// Enhanced lighting only: bare rock is matte and has no lamps; station
// plating has less sheen than a ship's paint.
uniform bool mineral = false;
uniform bool station_surface = false;
uniform vec2 atlas_size = vec2(256.0);
uniform bool textured = true;
uniform bool color_key = false;
uniform bool lit = true;
uniform bool specular = false;
uniform bool has_sphere = false;
uniform float blend_half = 0.0;
global uniform vec3 gof_light_direction;
// Enhanced lighting (Options): the scene's real lights (the system's sun,
// explosions, engines) shade the atlas as a material. Off, the phone's own
// per-polygon light is reproduced exactly and the scene's lights are off.
global uniform float gof_enhanced;
// Metal reflections option: how much of the atlas's metalness hint is used.
global uniform float gof_metal;
uniform float light_intensity = 1.0;
uniform float ambient = 0.415;
uniform vec4 tint : source_color = vec4(1.0);
uniform float emission_boost = 1.0;
// Skinning for animated figures: bone index in UV2.x, matrices per bone.
uniform bool skinned = false;
uniform mat4 bones[48];

varying float shade;
varying vec2 sphere_uv;

void vertex() {
	if (skinned) {
		int b = int(UV2.x + 0.5);
		VERTEX = (bones[b] * vec4(VERTEX, 1.0)).xyz;
		NORMAL = normalize(mat3(bones[b]) * NORMAL);
	}
	vec3 n = normalize((MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz);
	shade = 1.0;
	if (lit) {
		shade = min(1.0, ambient + light_intensity * max(dot(n, normalize(gof_light_direction)), 0.0));
	}
	vec3 vn = normalize((MODELVIEW_MATRIX * vec4(NORMAL, 0.0)).xyz);
	sphere_uv = vec2(vn.x, -vn.y) * 0.5 + 0.5;
}

void fragment() {
	vec4 c = textured ? texture(atlas, UV / atlas_size) : vec4(COLOR.rgb, 1.0);
	if (textured && color_key && c.a < 0.5) discard;
	vec3 highlight = (specular && has_sphere) ? texture(sphere, sphere_uv).rgb : vec3(0.0);
	if (gof_enhanced > 0.5 && lit) {
		vec3 base = c.rgb * tint.rgb * emission_boost;
		ALBEDO = base;
		METALLIC = mineral ? 0.0 : 0.1 * gof_metal;
		SPECULAR = mineral ? 0.1 : (station_surface ? 0.12 : 0.4);
		ROUGHNESS = 0.62;
		// The original's sphere-mapped sheen (the hangar walls' chrome, the
		// gloss on hulls) stays under the real reflections.
		EMISSION = mineral ? vec3(0.0) : highlight;
		if (textured && has_surface) {
			vec2 st = UV / atlas_size;
			vec4 hints = texture(surface, st);
			ROUGHNESS = mineral ? 0.95 : (station_surface ? max(hints.g, 0.7) : mix(hints.g, hints.g * 0.6, gof_metal));
			// Bare plating reflects the scene's sky like metal but keeps part
			// of its paint, so a hull never turns into a black mirror in a
			// dim room (as the HD game adds its reflection over the paint).
			if (!mineral) METALLIC = hints.a * gof_metal * (station_surface ? 0.3 : 0.6);
			// A light sheen along a ship's metal edges, as the HD game's rim.
			if (!mineral && !station_surface) { RIM = hints.a * 0.35 * gof_metal; RIM_TINT = 0.6; }
			EMISSION += mineral ? vec3(0.0) : base * hints.b * 2.4;
			// Fine relief from the texel brightness, in the surface's own frame.
			float h = texture(relief, st).r * (mineral ? 0.004 : 0.01);
			vec3 dx = dFdx(VERTEX), dy = dFdy(VERTEX);
			vec3 r1 = cross(dy, NORMAL), r2 = cross(NORMAL, dx);
			float det = dot(dx, r1);
			if (abs(det) > 0.000001) NORMAL = normalize(abs(det) * NORMAL - sign(det) * (dFdx(h) * r1 + dFdy(h) * r2));
		}
	} else {
		// The phone's look, unchanged: all of it is emitted, nothing is lit.
		ALBEDO = vec3(0.0);
		METALLIC = 0.0;
		SPECULAR = 0.0;
		ROUGHNESS = 1.0;
		EMISSION = (c.rgb * shade + highlight) * tint.rgb * emission_boost;
	}
	//ALPHA_LINE ALPHA = tint.a * (blend_half > 0.5 ? 0.5 : 1.0);
}
"""
