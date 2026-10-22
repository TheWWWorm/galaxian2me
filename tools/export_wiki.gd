extends SceneTree
## Writes the reference of an imported game as a web page folder:
##   godot --path game --script ../tools/export_wiki.gd -- CONTENT_ID OUTPUT [--step=N]
## (from the repository root; Godot finds the script from the game folder)
## CONTENT_ID is the imported game's id (the folder under the user data's
## content/). Without --headless, a window opens while ships and stations are
## rendered for their pages. The pages hold that game's own text and art, so
## keep OUTPUT outside this repository unless you mean to publish it. With
## --step the story stops there, as it does in the game.
const Library := preload("res://src/content/library.gd")
const Catalog := preload("res://src/wiki/catalog.gd")
const WikiExport := preload("res://src/wiki/export.gd")
const WikiSnapshots := preload("res://src/wiki/snapshots.gd")
const EngineLanguage := preload("res://src/presentation/engine_language.gd")

func _initialize() -> void: run.call_deferred()

func run() -> void:
	var paths: Array = []
	var step := -1
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--step="): step = argument.trim_prefix("--step=").to_int()
		# --path moves Godot into the project; a relative path means the shell's.
		elif paths.size() == 1 and argument.is_relative_path() and not OS.get_environment("PWD").is_empty(): paths.append(OS.get_environment("PWD").path_join(argument))
		else: paths.append(argument)
	if paths.size() != 2:
		printerr("Usage: -- CONTENT_ID OUTPUT [--step=N]"); quit(2); return
	var library := Library.new()
	if not library.open(str(paths[0])):
		printerr("Not an imported game: ", paths[0]); quit(1); return
	EngineLanguage.apply(EngineLanguage.resolve(EngineLanguage.AUTO, EngineLanguage.content_language(library.language, Array(library.strings))))
	var catalog := Catalog.new(library, step)
	var renders := {}
	if WikiSnapshots.available():
		var camera := WikiSnapshots.new(); root.add_child(camera)
		renders = await camera.render(catalog, paths[1])
		print("Rendered %d pictures" % renders.size())
	var result := WikiExport.write(catalog, paths[1], EngineLanguage.codes(), renders)
	if result != OK:
		printerr("Could not write ", paths[1], ": ", error_string(result)); quit(1); return
	print("Wrote %d pages in %d languages to %s" % [catalog.ordered.size(), EngineLanguage.codes().size(), paths[1]])
	quit(0)
