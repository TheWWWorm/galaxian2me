extends SceneTree
## Ships and stations choose smooth or pixelated textures apart (as Deep's
## options do); a station model follows the station choice, a ship its own.
const Host := preload("res://tests/support/isolated_app.gd")
const Assembly := preload("res://src/presentation/assembly.gd")
var checks := 0
var failures := 0

func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)

func filters(node: Node) -> Array:
	var out := []
	for m in node.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		for i in mi.get_surface_override_material_count():
			var mat := mi.get_surface_override_material(i) as ShaderMaterial
			if mat != null: out.append("filter_nearest" in mat.shader.code)
	return out

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		print("SKIP: no supplied content"); app.queue_free(); await process_frame; quit(2); return
	var lib = app.library
	lib.smooth_textures = false
	lib.smooth_stations = true
	var station_id := int(app.catalogue.data.stations[0].id)
	var st := Assembly.station(lib, station_id, 0)
	var ship := Assembly.ship(lib, 0, 0)
	var sf := filters(st)
	var hf := filters(ship)
	check(not sf.is_empty() and not sf.has(true), "stations smooth while ships stay pixelated")
	check(not hf.is_empty() and not hf.has(false), "the ship keeps its crisp pixels")
	lib.smooth_textures = true
	lib.smooth_stations = false
	check(not filters(Assembly.ship(lib, 0, 0)).has(true) and not filters(Assembly.station(lib, station_id, 0)).has(false), "and the other way round")
	st.free(); ship.free()
	app.queue_free()
	await process_frame
	print("TEXTURE SMOOTHING: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
