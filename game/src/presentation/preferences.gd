extends RefCounted
## Player preferences beyond the original's sound options: display and
## graphics quality, controls (bindings, mouse, gamepad, touch) and
## accessibility (interface size, colours, flashing and motion). Values live
## in the app's settings file; these helpers read them with defaults and
## apply the ones that act on the engine.

const FPS_LIMITS := [0, 30, 60, 120, 144]
const RENDER_SCALES := [0.5, 0.67, 0.75, 0.85, 1.0]
const MSAA := [Viewport.MSAA_DISABLED, Viewport.MSAA_2X, Viewport.MSAA_4X, Viewport.MSAA_8X]
const MSAA_NAMES := ["Off", "2×", "4×", "8×"]
## Picture shapes: Auto fills the window, the others letterbox it.
const ASPECTS := [0.0, 4.0 / 3.0, 16.0 / 9.0, 16.0 / 10.0, 21.0 / 9.0]
const ASPECT_NAMES := ["Auto", "4:3", "16:9", "16:10", "21:9"]
## The original's field of view: 750 of 4096 turn units, slightly narrowed.
const CLASSIC_FOV := 750.0 / 4096.0 * 360.0 * 0.9
## Graphics presets: each sets the graphics options below at once. The menu
## shows Custom when the current values match none of them.
const PRESET_NAMES := ["Performance", "Balanced", "Quality"]
const PRESETS := [
	{"render_scale": 0.67, "msaa": 0, "enhanced_lighting": false, "dust": false, "lens_flare": false},
	{"render_scale": 1.0, "msaa": 1, "enhanced_lighting": false, "dust": true, "lens_flare": true},
	{"render_scale": 1.0, "msaa": 2, "enhanced_lighting": true, "dust": true, "lens_flare": true},
]
const PRESET_FALLBACKS := {"render_scale": 1.0, "msaa": 1, "enhanced_lighting": false, "dust": true, "lens_flare": true}

## Keyboard actions players can rebind, in the order the menu lists them.
const BINDABLE := ["steer_up", "steer_down", "steer_left", "steer_right", "fire", "secondary",
	"boost", "autopilot", "next_target", "auto_fire", "rear_view", "action_menu", "map", "cloak", "time_warp", "photo"]
const ACTION_NAMES := {"steer_up": "Pitch up", "steer_down": "Pitch down", "steer_left": "Turn left",
	"steer_right": "Turn right", "fire": "Fire / use", "secondary": "Secondary weapon", "boost": "Booster",
	"autopilot": "Autopilot", "next_target": "Next target", "auto_fire": "Auto fire",
	"rear_view": "Rear view", "action_menu": "Actions / jump drive", "map": "Route map", "cloak": "Cloaking device", "time_warp": "Autopilot time speed", "photo": "Photo mode"}

## Colour sets for standing. The accessible set avoids red/green pairs and
## keeps enemy and friend apart by brightness as well as hue.
const PALETTES := {
	"classic": {"enemy": Color8(0xff, 0x6a, 0x4f), "friend": Color8(0x6a, 0xd8, 0x74),
		"neutral": Color8(0xd8, 0xd0, 0x9a), "waypoint": Color8(0x7c, 0xc4, 0xff)},
	"accessible": {"enemy": Color8(0xff, 0x9f, 0x1c), "friend": Color8(0x3f, 0xa9, 0xff),
		"neutral": Color8(0xf2, 0xf2, 0xf2), "waypoint": Color8(0xc9, 0x9b, 0xff)},
}

static func get_value(app, section: String, key: String, fallback):
	return app.setting(section, key, fallback) if app != null else fallback

static func palette(app) -> Dictionary:
	return PALETTES["accessible" if bool(get_value(app, "access", "colour_safe", false)) else "classic"]

static func hud_scale(app) -> float:
	return clampf(float(get_value(app, "interface", "hud_scale", 1.0)), 0.7, 1.6)

static func hud_opacity(app) -> float:
	return clampf(float(get_value(app, "interface", "hud_opacity", 1.0)), 0.35, 1.0)

static func text_size(app) -> int:
	return clampi(int(get_value(app, "interface", "text_size", 16)), 13, 24)

static func message_time(app) -> float:
	return clampf(float(get_value(app, "access", "message_time", 1.0)), 1.0, 3.0)

static func reduce_flashing(app) -> bool:
	return bool(get_value(app, "access", "reduce_flashing", false))

static func screen_shake(app) -> bool:
	return bool(get_value(app, "access", "screen_shake", true))

static func fov(app) -> float:
	return clampf(float(get_value(app, "graphics", "fov", CLASSIC_FOV)), 45.0, 90.0)

static func dust(app) -> bool:
	return bool(get_value(app, "graphics", "dust", true))

static func mouse_sensitivity(app) -> float:
	return clampf(float(get_value(app, "controls", "mouse_sensitivity", 1.0)), 0.3, 3.0)

static func deadzone(app) -> float:
	return clampf(float(get_value(app, "controls", "deadzone", 0.2)), 0.05, 0.5)

## Window, frame pacing and 3D quality on the root viewport.
## Index of the preset the graphics settings match, or -1 (Custom).
static func graphics_preset(app) -> int:
	for i in PRESETS.size():
		var same := true
		for key in PRESETS[i]:
			var v = get_value(app, "graphics", key, PRESET_FALLBACKS[key])
			if typeof(PRESETS[i][key]) == TYPE_FLOAT: same = same and is_equal_approx(float(v), PRESETS[i][key])
			elif typeof(PRESETS[i][key]) == TYPE_BOOL: same = same and bool(v) == PRESETS[i][key]
			else: same = same and int(v) == PRESETS[i][key]
		if same: return i
	return -1

static func set_graphics_preset(app, i: int) -> void:
	for key in PRESETS[i]: app.set_setting("graphics", key, PRESETS[i][key])
	apply_display(app)

static func apply_display(app) -> void:
	var tree: SceneTree = app.get_tree()
	if tree == null: return
	var root: Window = tree.root
	var vsync := bool(get_value(app, "display", "vsync", true))
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if vsync else DisplayServer.VSYNC_DISABLED)
	Engine.max_fps = int(get_value(app, "display", "max_fps", 0))
	var msaa := clampi(int(get_value(app, "graphics", "msaa", 1)), 0, MSAA.size() - 1)
	root.msaa_3d = MSAA[msaa]
	root.scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR
	root.scaling_3d_scale = clampf(float(get_value(app, "graphics", "render_scale", 1.0)), 0.5, 1.0)
	RenderingServer.global_shader_parameter_set("gof_enhanced", 1.0 if bool(get_value(app, "graphics", "enhanced_lighting", false)) else 0.0)
	var aspect: float = ASPECTS[clampi(int(get_value(app, "display", "aspect", 0)), 0, ASPECTS.size() - 1)]
	if aspect <= 0.0:
		root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_EXPAND
		root.content_scale_size = Vector2i(1280, 800)
	else:
		root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
		root.content_scale_size = Vector2i(int(round(800.0 * aspect)), 800)

## Rebuilds the keyboard events of each bindable action from the settings;
## gamepad and alternative defaults stay in place.
static func apply_bindings(app, defaults: Dictionary) -> void:
	for action in BINDABLE:
		if not InputMap.has_action(action): continue
		InputMap.action_set_deadzone(action, deadzone(app))
		var custom := int(get_value(app, "keys", action, -1))
		if custom <= 0: continue
		for e in InputMap.action_get_events(action):
			if e is InputEventKey: InputMap.action_erase_event(action, e)
		var key := InputEventKey.new()
		key.physical_keycode = int(custom)
		InputMap.action_add_event(action, key)
	for action in ["steer_left", "steer_right", "steer_up", "steer_down"]:
		if InputMap.has_action(action): InputMap.action_set_deadzone(action, deadzone(app))
	var _unused := defaults

## The key currently driving an action, for menus and hints.
static func key_name(action: String) -> String:
	if not InputMap.has_action(action): return "—"
	for e in InputMap.action_get_events(action):
		if e is InputEventKey:
			var code: int = e.physical_keycode if e.physical_keycode != 0 else e.keycode
			return OS.get_keycode_string(code)
	return "—"

## Brief rumble on hits: a connected gamepad, and a phone or tablet itself.
static func rumble(app, strength := 0.5, seconds := 0.2) -> void:
	if not bool(get_value(app, "controls", "vibration", true)): return
	for pad in Input.get_connected_joypads():
		Input.start_joy_vibration(pad, strength * 0.6, strength, seconds)
	# The phone itself buzzes, as the original's Vibration option did.
	if OS.has_feature("mobile"): Input.vibrate_handheld(int(seconds * 1000.0), clampf(strength, 0.0, 1.0))

## Steering by tilting a phone or tablet: the change in the device's
## gravity reading from the calibrated grip, as yaw and pitch in -1..1.
static func tilt(app) -> Vector2:
	if not OS.has_feature("mobile") or not bool(get_value(app, "controls", "tilt", false)): return Vector2.ZERO
	var g := Input.get_gravity()
	if g.length() < 1.0: return Vector2.ZERO
	var neutral: Vector3 = get_value(app, "controls", "tilt_neutral", Vector3(0, -1, -1).normalized())
	var d := g.normalized() - neutral.normalized()
	# About 25 degrees of lean for a full turn at normal sensitivity.
	var reach := 0.42 / clampf(float(get_value(app, "controls", "tilt_sensitivity", 1.0)), 0.4, 2.5)
	var v := Vector2(d.x, -d.y) / reach
	if v.length() < 0.08: return Vector2.ZERO
	return v.limit_length(1.0)

## Makes the current grip the neutral tilt.
static func calibrate_tilt(app) -> void:
	var g := Input.get_gravity()
	if g.length() >= 1.0: app.set_setting("controls", "tilt_neutral", g.normalized())

