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
// Optional enhanced lighting (Options): per-pixel light with a soft
// highlight and rim, bright texels (windows, lamps) kept at full glow.
global uniform float gof_enhanced;
// Up to four explosion flashes lighting what is near them (enhanced only):
// xyz world position, w reach; colour rgb already scaled by brightness.
global uniform vec4 gof_flash_0;
global uniform vec4 gof_flash_1;
global uniform vec4 gof_flash_2;
global uniform vec4 gof_flash_3;
global uniform vec4 gof_flash_color_0;
global uniform vec4 gof_flash_color_1;
global uniform vec4 gof_flash_color_2;
global uniform vec4 gof_flash_color_3;
uniform float light_intensity = 1.0;
uniform float ambient = 0.415;
uniform vec4 tint : source_color = vec4(1.0);
uniform float emission_boost = 1.0;
// Skinning for animated figures: bone index in UV2.x, matrices per bone.
uniform bool skinned = false;
uniform mat4 bones[48];

varying float shade;
varying vec2 sphere_uv;
varying vec3 world_pos;
varying vec3 world_normal;

vec3 flash(vec4 f, vec4 col, vec3 p, vec3 n) {
	if (f.w <= 0.0) return vec3(0.0);
	vec3 d = f.xyz - p;
	float fall = clamp(1.0 - length(d) / f.w, 0.0, 1.0);
	return col.rgb * fall * fall * (0.35 + 0.65 * max(dot(n, normalize(d)), 0.0));
}

void vertex() {
	if (skinned) {
		int b = int(UV2.x + 0.5);
		VERTEX = (bones[b] * vec4(VERTEX, 1.0)).xyz;
		NORMAL = normalize(mat3(bones[b]) * NORMAL);
	}
	vec3 n = normalize((MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz);
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	world_normal = n;
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
	if (gof_enhanced > 0.5 && lit) {
		vec3 n = normalize(NORMAL);
		vec3 l = normalize((VIEW_MATRIX * vec4(gof_light_direction, 0.0)).xyz);
		float lit_amount = min(1.12, ambient * 0.8 + light_intensity * max(dot(n, l), 0.0));
		float highlight = pow(max(dot(n, normalize(l + VIEW)), 0.0), 28.0) * 0.4;
		float rim = pow(1.0 - max(dot(n, VIEW), 0.0), 3.0) * 0.22;
		float glow = smoothstep(0.78, 0.95, dot(c.rgb, vec3(0.299, 0.587, 0.114)));
		rgb = c.rgb * mix(lit_amount, 1.0, glow) + vec3(highlight) * (1.0 - glow) + vec3(0.32, 0.46, 0.66) * rim;
		vec3 wn = normalize(world_normal);
		vec3 flashes = flash(gof_flash_0, gof_flash_color_0, world_pos, wn) + flash(gof_flash_1, gof_flash_color_1, world_pos, wn)
			+ flash(gof_flash_2, gof_flash_color_2, world_pos, wn) + flash(gof_flash_3, gof_flash_color_3, world_pos, wn);
		rgb += c.rgb * flashes * (1.0 - glow);
	}
	if (specular && has_sphere) rgb += texture(sphere, sphere_uv).rgb;
	rgb *= tint.rgb * emission_boost;
	ALBEDO = rgb;
	//ALPHA_LINE ALPHA = tint.a * (blend_half > 0.5 ? 0.5 : 1.0);
}
"""
