extends Node
## On the first start with content, the title measures the device on its own
## station scene: from Quality down, the first graphics preset that holds
## about 60 frames a second is recommended (Options marks it). When the
## player has not set graphics by hand, the recommendation is applied;
## otherwise their settings are put back. Leaving the title early cancels
## the measurement, which then runs again on the next start.

const Prefs := preload("res://src/presentation/preferences.gd")
const WARM_FRAMES := 30
const SAMPLE_FRAMES := 90
const TARGET_FPS := 55.0

var app
var level := -1
var frames := 0
var started := 0
var kept := {}
var hand_set := false
var done := false

## About 60 frames a second, or nearly the display's own rate when vertical
## sync holds it lower (a 50 Hz television, a 30 Hz panel).
static func target_fps() -> float:
	var refresh := DisplayServer.screen_get_refresh_rate()
	if refresh > 0.0 and DisplayServer.window_get_vsync_mode() != DisplayServer.VSYNC_DISABLED:
		return minf(TARGET_FPS, refresh * 0.92)
	return TARGET_FPS

static func due(app) -> bool:
	if DisplayServer.get_name() == "headless" or not bool(app.benchmark_allowed): return false
	return app.setting("graphics", "recommended", -1) == -1

func _ready() -> void:
	for key in Prefs.PRESET_FALLBACKS:
		if app.settings.has_section_key("graphics", key):
			kept[key] = app.settings.get_value("graphics", key)
	hand_set = not kept.is_empty()
	# A frame-rate limit would hide what the device can do.
	Engine.max_fps = 0
	_try(Prefs.PRESETS.size() - 1)

func _try(i: int) -> void:
	level = i
	frames = 0
	for key in Prefs.PRESETS[i]: app.settings.set_value("graphics", key, Prefs.PRESETS[i][key])
	Prefs.apply_display(app)
	Engine.max_fps = 0

func _process(_delta: float) -> void:
	if done: return
	frames += 1
	if frames == WARM_FRAMES:
		started = Time.get_ticks_usec()
	elif frames == WARM_FRAMES + SAMPLE_FRAMES:
		var fps := SAMPLE_FRAMES * 1000000.0 / maxf(1.0, float(Time.get_ticks_usec() - started))
		if fps >= target_fps() or level == 0: _finish(level)
		else: _try(level - 1)

func _finish(i: int) -> void:
	done = true
	if hand_set: _restore()
	else:
		for key in Prefs.PRESETS[i]: app.settings.set_value("graphics", key, Prefs.PRESETS[i][key])
	Prefs.apply_display(app)
	# Written last: saving the settings file keeps the choice too.
	app.set_setting("graphics", "recommended", i)
	queue_free()

## The player's own graphics settings, as they were before measuring.
func _restore() -> void:
	for key in Prefs.PRESET_FALLBACKS:
		if kept.has(key): app.settings.set_value("graphics", key, kept[key])
		elif app.settings.has_section_key("graphics", key): app.settings.erase_section_key("graphics", key)

func _exit_tree() -> void:
	if done: return
	_restore()
	Prefs.apply_display(app)
