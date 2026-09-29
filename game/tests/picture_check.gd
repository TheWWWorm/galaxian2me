extends SceneTree
## F12 / photo mode's Save picture: the next frame lands as a PNG in the
## user data folder's screenshots folder, with a notice that fades. Under a
## headless display there is no frame to read; saving then fails cleanly.
const Host := preload("res://tests/support/isolated_app.gd")
var checks := 0
var failures := 0

func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	for f in 3: await process_frame
	var layers := app.get_children().size()
	var path: String = await app.save_picture()
	check(app.get_children().size() == layers + 1, "a notice says what happened")
	if DisplayServer.get_name() == "headless":
		check(path.is_empty(), "no frame to read: nothing is written and no error is raised")
	else:
		check(path.begins_with("user://screenshots/") and FileAccess.file_exists(path), "the picture is written")
		var img := Image.load_from_file(path)
		check(img != null and img.get_size() == Vector2i(root.get_viewport().get_texture().get_size()), "it is the whole frame")
		DirAccess.remove_absolute(path)
	app.queue_free()
	await process_frame
	print("checks=%d failures=%d" % [checks, failures])
	quit(1 if failures else 0)
