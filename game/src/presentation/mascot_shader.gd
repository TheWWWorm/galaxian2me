extends RefCounted
## Shader template for imported Mascot Capsule geometry. The library fills in
## blend mode, culling and texture filtering per material variant.

const CODE := """shader_type spatial;
// Renders imported Mascot Capsule geometry the way the phone's Effect3D does:
// one texture atlas, per-polygon lighting and colour-keyed transparency, an
// optional sphere-mapped highlight, and the four Micro3D blend modes.
// Blend mode and culling are chosen per material variant by the library.
render_mode BLEND_MODE, CULL_MODE, depth_draw_opaque, unshaded;

uniform sampler2D atlas : source_color, FILTER_MODE, repeat_disable;
uniform sampler2D sphere : source_color, filter_linear, repeat_disable;
uniform vec2 atlas_size = vec2(256.0);
uniform bool textured = true;
uniform bool color_key = false;
uniform bool lit = true;
uniform bool specular = false;
uniform bool has_sphere = false;
uniform float blend_half = 0.0;
global uniform vec3 gof_light_direction;
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
	vec3 rgb = c.rgb * shade;
	if (specular && has_sphere) rgb += texture(sphere, sphere_uv).rgb;
	rgb *= tint.rgb * emission_boost;
	ALBEDO = rgb;
	//ALPHA_LINE ALPHA = tint.a * (blend_half > 0.5 ? 0.5 : 1.0);
}
"""
