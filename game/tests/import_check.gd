extends SceneTree
## Headless: godot --headless --path game -s res://tests/import_check.gd -- /path/to.jar [--paced]
## --paced runs the conversion on the main thread as the thread-less Web build
## does and reports the longest time between frames.

func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.is_empty():
		push_error("usage: -- /path/to/game.jar [--paced]"); quit(2); return
	var started := Time.get_ticks_msec()
	var importer = load("res://src/import/importer.gd").new()
	if "--paced" in args: importer.tree = self
	var result: Dictionary = await importer.run(args[0])
	print(JSON.stringify(result))
	print("import took %.1f s" % ((Time.get_ticks_msec() - started) / 1000.0))
	if importer.tree != null: print("longest slice %d ms" % importer.longest_slice)
	if result.has("id"):
		var m = JSON.parse_string(FileAccess.get_file_as_string("user://content/%s/manifest.json" % result.id))
		print(JSON.stringify(m.counts))
	quit(0 if result.get("ok", false) else 1)
