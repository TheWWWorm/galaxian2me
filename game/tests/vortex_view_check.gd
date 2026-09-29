extends SceneTree
## Synthetic, memory-only presentation fixtures. Never campaign inputs.
const TestApp := preload("res://tests/support/isolated_app.gd")
const Library := preload("res://src/content/library.gd")
const Vortex := preload("res://src/presentation/vortex_view.gd")
var checks := 0
var failures := 0

func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)

func run() -> void:
	var app := TestApp.new()
	root.add_child(app)
	await process_frame
	check(app.library != null, "supplied content is available")
	if app.library == null: quit(1); return
	var lib = app.library
	for model in ["vortex", "vortex_dust", "explosion", "asteroid_explo"]:
		var source: Dictionary = lib.model_data(model)
		var anim: Dictionary = lib.animation(model)
		check(not source.is_empty() and not anim.is_empty(), "supplied model/action pair " + model)
		if source.is_empty() or anim.is_empty(): continue
		var rest := Library.bone_transforms(source)
		var identity: Array = []
		for _i in source.bones.size(): identity.append_array([1,0,0,0,0,1,0,0,0,0,1,0])
		var still := Library.bone_transforms(source, identity)
		var equal := true
		for i in rest.size(): equal = equal and still[i].is_equal_approx(rest[i])
		check(equal, "identity action preserves every rest transform: " + model)
		var row: Array = anim.actions[0].matrices[int(anim.actions[0].last_frame) / 2]
		var actual := Library.bone_transforms(source, row)
		var expected: Array[Transform3D] = []
		var composed := true
		for i in source.bones.size():
			var parent := int(source.bones[i].parent)
			var bone := Library.matrix(source.bones[i].matrix)
			var delta := Library.matrix(row, i * 12)
			expected.append((expected[parent] if parent >= 0 else Transform3D.IDENTITY) * bone * delta)
			composed = composed and actual[i].is_equal_approx(expected[i])
		check(composed, "animated hierarchy composes parent, rest and delta: " + model)
	var rng := RandomNumberGenerator.new()
	rng.seed = 6806
	var vortex := Vortex.new()
	root.add_child(vortex)
	vortex.setup(lib, rng)
	check(vortex.layers.size() == 11, "one vortex and exactly ten imported dust figures")
	check(vortex.layers[0].interval == 30, "main action uses thirty milliseconds per frame")
	var rates := true
	var independent := true
	var material_ids: Array = []
	for i in range(1, vortex.layers.size()):
		var layer: Dictionary = vortex.layers[i]
		rates = rates and layer.interval >= 20 and layer.interval <= 69
		var mat = layer.figure.get_surface_override_material(0)
		independent = independent and not material_ids.has(mat.get_instance_id())
		material_ids.append(mat.get_instance_id())
	check(rates, "dust intervals stay within supplied twenty-to-sixty-nine bounds")
	check(independent, "each dust action has an independent material pose")
	check(vortex.layers[1].figure.mesh == vortex.layers[2].figure.mesh, "dust figures share geometry, not animation state")
	var poses_bounded := true
	for model in vortex._actions:
		var source: Dictionary = lib.model_data(model)
		var action: Dictionary = vortex._actions[model]
		for pose in action.poses:
			var vertex := 0
			for bone in source.bones.size():
				for _v in int(source.bones[bone].vertices):
					var point: Vector3 = Transform3D(pose[bone]) * Library.point(source.vertices, vertex * 3)
					poses_bounded = poses_bounded and action.bounds.has_point(point)
					vertex += 1
	check(poses_bounded, "culling bounds contain every vertex of all imported animation frames")
	vortex.animate(0)
	vortex.animate(29)
	check(vortex.layers[0].frame == 0, "main action does not advance early")
	vortex.animate(30)
	check(vortex.layers[0].frame == 1, "main action advances at its actual interval")
	vortex.animate(1500)
	check(vortex.layers[0].frame == 50 and vortex.layers[1].frame != vortex.layers[0].frame, "main and dust clocks advance independently")
	var mesh: MeshInstance3D = vortex.layers[0].figure
	var sent = mesh.get_surface_override_material(0).get_shader_parameter("bones")
	check(sent == vortex.layers[0].action.poses[50], "shader receives the actual composed action pose")
	vortex.animate(3000)
	check(vortex.layers[0].frame == 100, "the last imported frame is displayed")
	vortex.animate(3035)
	check(vortex.layers[0].frame == 0 and vortex.layers[0].start == 3035, "loop resets at the current clock without residual overshoot")
	var eye := Vector3(20, 30, 900)
	var at := Vector3(-20, -30, -100)
	var t := Vortex.billboard(at, eye, 1.0)
	check(is_equal_approx(t.origin.distance_to(eye), 280.0), "far rendering proxy is capped at twenty-eight thousand source units")
	check(is_equal_approx(t.basis.get_scale().x, 280.0 / at.distance_to(eye)), "far proxy compensates scale instead of enlarging the model")
	check((-t.basis.z.normalized()).dot((eye - at).normalized()) > 0.9999, "one-sided minus-Z vortex faces the camera")
	var near := Vortex.billboard(Vector3.ZERO, Vector3(0, 0, 100), 0.5)
	check(near.origin == Vector3.ZERO and is_equal_approx(near.basis.get_scale().x, 0.5), "near portal retains its position and exact opening scale")
	var vertical := Vortex.billboard(Vector3.ZERO, Vector3(0, 100, 0), 1.0)
	check(vertical.basis.is_finite() and absf(vertical.basis.determinant()) > 0.99, "vertical billboard remains nonsingular")
	vortex.sync(3035, at, eye, 0.0)
	check(not vortex.visible, "zero-size opening hides the visual without altering collision state")
	# Release the independent view before the host's cached shaders. Keeping
	# both queued until one flush exposes dummy-renderer material teardown.
	vortex.free()
	await process_frame
	app.queue_free()
	await process_frame
	await process_frame
	print("VORTEX VIEW: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
