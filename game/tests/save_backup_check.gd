extends SceneTree
## Saving keeps the replaced save as a backup; a damaged save loads that
## backup instead and says so; saves also export and import as files. Uses a
## throwaway folder, never player saves.
const Host := preload("res://tests/support/isolated_app.gd")
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
		var folder := OS.get_temp_dir().path_join("gof2-save-backup-check-%d" % Time.get_ticks_usec())
		app.disk_saves = folder
		app.game = app._make_game()
		app.game.new_game()
		app.game.session.credits = 1111
		check(app.save_game(0), "first save is written")
		var path: String = app.save_path(0)
		check(not FileAccess.file_exists(path + ".bak"), "a first save has nothing to back up")
		app.game.session.credits = 2222
		check(app.save_game(0), "second save is written")
		check(FileAccess.file_exists(path + ".bak"), "the replaced save is kept as a backup")
		check(int(app.save_summary(0, true).get("credits", 0)) == 1111, "the backup holds the previous save")
		var f := FileAccess.open(path, FileAccess.WRITE)
		f.store_string("{\"station\": 3, \"credits\": ")
		f.close()
		check(app.save_summary(0).is_empty(), "the damaged save is not listed as itself")
		check(int(app.slot_summary(0).get("credits", 0)) == 1111, "menus offer the backup in its place")
		app.load_notice = ""
		var err: String = app.load_game(0)
		check(err.is_empty() and app.game.session.credits == 1111, "loading falls back to the backup")
		check(not app.load_notice.is_empty(), "the player is told the backup was loaded")
		check(not app.load_game(1).is_empty(), "an empty slot still reports that nothing is saved")
		# Transfer: export, change the game, import the export back.
		var transfer := folder.path_join("transfer.json")
		app.game.session.credits = 3333
		check(app.export_save(transfer).is_empty(), "the game exports to a file")
		app.game.session.credits = 1
		check(app.import_save(transfer).is_empty() and app.game.session.credits == 3333, "an exported save imports")
		var foreign: Dictionary = app.game.session.to_dict()
		foreign.content = "another-game"
		var ff := FileAccess.open(transfer, FileAccess.WRITE)
		ff.store_string(JSON.stringify(foreign))
		ff.close()
		check(not app.import_save(transfer).is_empty() and app.game.session.credits == 3333, "a save from other game content is refused")
		DirAccess.remove_absolute(transfer)
		for name in DirAccess.get_files_at(path.get_base_dir()): DirAccess.remove_absolute(path.get_base_dir().path_join(name))
		DirAccess.remove_absolute(path.get_base_dir())
		DirAccess.remove_absolute(folder)
	app.queue_free()
	await process_frame
	await process_frame
	print("SAVE BACKUP: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
