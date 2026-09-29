extends SceneTree
## Title → Mods: a replacement is checked by its content, copied into the
## mods folder, used at once, and removed again by Restore original. Uses a
## throwaway mods folder, never the player's.
const Host := preload("res://tests/support/isolated_app.gd")
const Mods := preload("res://src/content/mods.gd")
const ModsPanel := preload("res://src/screens/mods_panel.gd")
var checks := 0
var failures := 0

func _init() -> void:
	run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	print("PASS: " if ok else "FAIL: ", label)
	if not ok: failures += 1

func wipe(dir: String) -> void:
	for sub in DirAccess.get_directories_at(dir): wipe(dir.path_join(sub))
	for f in DirAccess.get_files_at(dir): DirAccess.remove_absolute(dir.path_join(f))
	DirAccess.remove_absolute(dir)

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		check(false, "supplied content installed")
	else:
		var temp := "user://mods-page-check"
		if DirAccess.dir_exists_absolute(temp): wipe(temp)
		DirAccess.make_dir_recursive_absolute(temp)
		Mods.only_root = temp.path_join("mods")
		var original: Vector2 = app.library.atlas_texture("space").get_size()
		var img := Image.create(512, 512, false, Image.FORMAT_RGBA8)
		img.fill(Color.MAGENTA)
		var png := temp.path_join("repaint.txt")
		img.save_png(png)
		var junk := temp.path_join("junk.png")
		var f := FileAccess.open(junk, FileAccess.WRITE)
		f.store_string("not really an image at all")
		f.close()
		check(Mods.install("textures", "space", junk) != "" and Mods.replacement("textures", "space").is_empty(),
			"a file that is not a PNG is refused whatever its name")
		var panel := ModsPanel.new()
		panel.app = app
		app.ui_layer.add_child(panel)
		await process_frame
		panel.replace_with("textures", "space", png)
		check(Mods.replacement("textures", "space") == Mods.only_root.path_join("textures/space.png"),
			"a PNG under another name is copied in as the atlas")
		check(app.library.atlas_texture("space").get_size() == Vector2(512, 512) and original != Vector2(512, 512),
			"the replacement is used without a restart")
		var restore: Button = panel.rows.find_child("restore_space", true, false)
		check(restore != null and not restore.disabled, "Restore original is offered for it")
		restore.pressed.emit()
		check(Mods.replacement("textures", "space").is_empty() and app.library.atlas_texture("space").get_size() == original,
			"Restore original brings back the converted atlas")
		var wav := temp.path_join("tune.wav")
		var stream := AudioStreamWAV.new()
		stream.format = AudioStreamWAV.FORMAT_16_BITS
		stream.mix_rate = 22050
		stream.data = PackedByteArray()
		stream.data.resize(4410)
		stream.save_to_wav(wav)
		panel.replace_with("music", "gof2_theme", wav)
		check(Mods.replacement("music", "gof2_theme").ends_with("music/gof2_theme.wav") and app.music_name == "gof2_theme"
			and app.library.music("gof2_theme") != null, "a WAV replaces a track and plays at once")
		# A glTF box stands in for a still model, fitted to its size.
		var cube := MeshInstance3D.new()
		cube.mesh = BoxMesh.new()
		var scene := Node3D.new()
		scene.add_child(cube)
		cube.owner = scene
		var doc := GLTFDocument.new()
		var state := GLTFState.new()
		doc.append_from_scene(scene, state)
		var glb := temp.path_join("box.glb")
		doc.write_to_filesystem(state, glb)
		scene.free()
		var name := "box"
		check(panel.model_names.has(name) and not panel.model_names.has("explosion"),
			"still models are offered, animated ones are not")
		var before: MeshInstance3D = app.library.instance(name)
		var size: float = before.mesh.get_aabb().get_longest_axis_size()
		before.free()
		panel.model = name
		panel.replace_with("models", name, glb)
		check(Mods.replacement("models", name).ends_with("models/box.glb"), "a .glb is copied in as the model")
		var after: MeshInstance3D = app.library.instance(name)
		check(after.mesh == null and after.get_child_count() == 1, "the model is drawn from the replacement")
		var box: AABB = app.library._scene_bounds(after, Transform3D.IDENTITY)
		check(absf(box.get_longest_axis_size() - size) < size * 0.01, "the replacement is fitted to the original's size")
		after.free()
		check(panel.viewer.visible and panel.viewer.model_name == name, "the viewer shows the replaced model")
		check(Mods.install("models", name, png) != "", "a PNG is refused as a model")
		var restore_model: Button = panel.rows.find_child("restore_" + name, true, false)
		restore_model.pressed.emit()
		var again: MeshInstance3D = app.library.instance(name)
		check(again.mesh != null and again.get_child_count() == 0, "Restore original brings back the converted model")
		again.free()
		panel.close()
		await process_frame
		Mods.only_root = "res://tests/no-mods"
		app.library.forget_replacements()
		wipe(temp)
	print("MODS PAGE: %d checks, %d failures" % [checks, failures])
	app.queue_free()
	quit(1 if failures else 0)
