extends SceneTree
## The first-start graphics measurement: the first preset from Quality down
## that holds the frame rate is recommended and, when graphics were never
## set by hand, applied; hand-set graphics are kept; leaving early measures
## nothing. Memory-only; frame times are fed in, not measured.
const Host := preload("res://tests/support/isolated_app.gd")
const Benchmark := preload("res://src/presentation/benchmark.gd")
const Prefs := preload("res://src/presentation/preferences.gd")
var checks := 0
var failures := 0

func _init() -> void:
	run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	print("PASS: " if ok else "FAIL: ", label)
	if not ok: failures += 1

## Runs one measurement with `fast` presets passing.
func measure(app, fast: Array) -> void:
	var b := Benchmark.new()
	b.app = app
	b.set_process(false)
	app.add_child(b)
	while not b.done:
		var passes: bool = fast.has(b.level)
		b.frames = Benchmark.WARM_FRAMES + Benchmark.SAMPLE_FRAMES - 1
		b.started = Time.get_ticks_usec() - (int(Benchmark.SAMPLE_FRAMES * 1000000.0 / 120.0) if passes else int(Benchmark.SAMPLE_FRAMES * 1000000.0 / 20.0))
		b._process(0.0)
	await process_frame

func clear(app) -> void:
	for key in Prefs.PRESET_FALLBACKS.keys() + ["recommended"]:
		if app.settings.has_section_key("graphics", key): app.settings.erase_section_key("graphics", key)

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	check(not Benchmark.due(app), "checks never measure on the title")
	clear(app)
	await measure(app, [1, 0])
	check(int(app.setting("graphics", "recommended", -1)) == 1 and Prefs.graphics_preset(app) == 1,
		"the best preset that holds the frame rate is recommended and applied")
	clear(app)
	app.settings.set_value("graphics", "msaa", 3)
	await measure(app, [2, 1, 0])
	check(int(app.setting("graphics", "recommended", -1)) == 2 and int(app.setting("graphics", "msaa", 0)) == 3
		and not app.settings.has_section_key("graphics", "render_scale"), "graphics set by hand are kept")
	clear(app)
	await measure(app, [])
	check(int(app.setting("graphics", "recommended", -1)) == 0, "a slow device gets Performance")
	clear(app)
	app.settings.set_value("graphics", "msaa", 3)
	var b := Benchmark.new()
	b.app = app
	b.set_process(false)
	app.add_child(b)
	b.queue_free()
	await process_frame
	check(app.setting("graphics", "recommended", -1) == -1 and int(app.setting("graphics", "msaa", 0)) == 3
		and not app.settings.has_section_key("graphics", "lens_flare"), "leaving early records nothing and puts graphics back")
	print("BENCHMARK: %d checks, %d failures" % [checks, failures])
	app.queue_free()
	quit(1 if failures else 0)
