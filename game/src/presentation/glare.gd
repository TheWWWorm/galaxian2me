extends Node
## Glare (Options): light from the brightest parts of the 3D picture (the
## sun, flames, explosions, lamps, sunlit metal) spills softly around them,
## as the HD game's display glare does. Drawn between the 3D world and the
## interface in two passes, since the Compatibility renderer's own glow
## lifts the background colour: the first keeps the picture and stores how
## far each pixel is past the threshold in its alpha; the second spreads
## that from the picture's smaller mip levels and adds it on top, leaving
## the picture opaque again.

const MASK := """shader_type canvas_item;
render_mode unshaded, blend_disabled;
uniform sampler2D screen : hint_screen_texture, filter_nearest;
uniform float threshold = 0.7;
void fragment() {
	vec3 c = texture(screen, SCREEN_UV).rgb;
	float peak = max(c.r, max(c.g, c.b));
	float past = clamp((peak - threshold) / (1.0 - threshold), 0.0, 1.0);
	// Squared: the core of the sun keeps its rays instead of a flat disc.
	COLOR = vec4(c, past * past);
}
"""

const SPREAD := """shader_type canvas_item;
render_mode unshaded, blend_disabled;
uniform sampler2D screen : hint_screen_texture, filter_linear_mipmap;
uniform float strength = 1.0;
void fragment() {
	vec3 glow = vec3(0.0);
	for (int i = 0; i < 5; i++) {
		float lod = 1.5 + float(i);
		vec4 m = textureLod(screen, SCREEN_UV, lod);
		// Averaged mask and colour: the colour of what glows, as bright as
		// the share of it that is past the threshold; wider is fainter.
		vec3 hue = m.rgb / max(0.02, max(m.r, max(m.g, m.b)));
		glow += hue * m.a * (0.55 - float(i) * 0.08);
	}
	vec3 picture = textureLod(screen, SCREEN_UV, 0.0).rgb;
	// Added softly, so what is already bright is not flattened to white.
	COLOR = vec4(picture + glow * strength * (1.0 - picture * 0.6), 1.0);
}
"""

var mask_layer := CanvasLayer.new()
var spread_layer := CanvasLayer.new()
var _spread: ShaderMaterial
var _on := false
var _strength := 1.3

func _ready() -> void:
	mask_layer.layer = 1
	spread_layer.layer = 2
	add_child(mask_layer)
	add_child(spread_layer)
	mask_layer.add_child(_rect(MASK))
	var rect := _rect(SPREAD)
	_spread = rect.material
	spread_layer.add_child(rect)
	configure(_on, _strength)

func _rect(code: String) -> ColorRect:
	var rect := ColorRect.new()
	rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var material := ShaderMaterial.new()
	material.shader = Shader.new()
	material.shader.code = code
	rect.material = material
	return rect

## Shown or hidden, and how strong.
func configure(on: bool, strength := 1.0) -> void:
	_on = on
	_strength = strength
	mask_layer.visible = on
	spread_layer.visible = on
	if _spread != null: _spread.set_shader_parameter("strength", strength)
