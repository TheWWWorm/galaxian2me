extends SceneTree
## The dealer's showroom builds the imported hull, frames it, turns it by
## itself and lets a drag turn it by hand. Memory-only.
const Host := preload("res://tests/support/isolated_app.gd")
const ShipPreview := preload("res://src/presentation/ship_preview.gd")
var checks := 0
var failures := 0

func _init() -> void:
	run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	print("PASS: " if ok else "FAIL: ", label)
	if not ok: failures += 1

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		check(false, "supplied content installed")
	else:
		var p := ShipPreview.new()
		p.library = app.library
		app.ui_layer.add_child(p)
		await process_frame
		p.show_ship(0, 0)
		await process_frame
		var model: Node3D = p.pivot.get_child(p.pivot.get_child_count() - 1)
		var box: AABB = p._bounds(model, Transform3D.IDENTITY)
		check(box.size.length() > 0.0 and model.find_children("*", "MeshInstance3D", true, false).size() > 0, "the hull is built from its imported parts")
		check(p.camera.position.length() > box.size.length() * 0.5, "the camera stands clear of the hull")
		check(p.viewport.own_world_3d, "the showroom is its own world, apart from the hangar")
		var before: float = p.angle
		p._process(1.0)
		check(p.angle > before, "it turns by itself")
		var press := InputEventMouseButton.new()
		press.button_index = MOUSE_BUTTON_LEFT
		press.pressed = true
		p._gui_input(press)
		var drag := InputEventMouseMotion.new()
		drag.relative = Vector2(100, 0)
		var held: float = p.angle
		p._gui_input(drag)
		p._process(1.0)
		check(is_equal_approx(p.angle, held + 1.2), "a drag turns it by hand and holds it there")
		p.queue_free()
	print("SHIP PREVIEW: %d checks, %d failures" % [checks, failures])
	app.queue_free()
	quit(1 if failures else 0)
