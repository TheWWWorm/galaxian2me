extends Node
## Application controller: settings, the active content, the running game and
## which screen is showing. Screens are separate scripts that call back here.

const SafeMargins := preload("res://src/presentation/safe_margins.gd")
const TouchControls := preload("res://src/flight/touch_controls.gd")
const Library := preload("res://src/content/library.gd")
const Catalogue := preload("res://src/content/catalogue.gd")
const Importer := preload("res://src/import/importer.gd")
const UI := preload("res://src/presentation/ui.gd")
const Prefs := preload("res://src/presentation/preferences.gd")
const Session := preload("res://src/simulation/session.gd")
const Game := preload("res://src/simulation/game.gd")

const ImportScreen := preload("res://src/screens/import_screen.gd")
const TitleScreen := preload("res://src/screens/title_screen.gd")
const StationScreen := preload("res://src/screens/station_screen.gd")
const FlightScreen := preload("res://src/screens/flight_screen.gd")

const AUTOSAVE_SLOT := -1
const LOAD_SLOTS := [AUTOSAVE_SLOT, 0, 1, 2]

var settings := ConfigFile.new()
var library: Library = null
var catalogue: Catalogue = null
var game: Game = null
var screen: Node = null
var ui_layer := CanvasLayer.new()
var world_root := Node3D.new()
var music := AudioStreamPlayer.new()
var music_name := ""
var sfx_players: Array[AudioStreamPlayer] = []
var last_save_error := ""

func _ready() -> void:
	get_tree().root.theme = UI.make_theme()
	get_viewport().size_changed.connect(inset_screen)
	add_child(world_root)
	ui_layer.layer = 10
	add_child(ui_layer)
	music.bus = "Master"
	add_child(music)
	for i in 6:
		var p := AudioStreamPlayer.new()
		add_child(p)
		sfx_players.append(p)
	settings.load("user://settings.cfg")
	get_tree().root.theme = UI.make_theme(Prefs.text_size(self))
	get_window().files_dropped.connect(_on_files_dropped)
	_apply_display_settings()
	# The flight actions and the player's rebinds exist from the start, so
	# menus, Help and the game's key notes can name them before any flight.
	var Controls := preload("res://src/flight/controls.gd")
	Controls.ensure_actions()
	Prefs.apply_bindings(self, Controls.ACTIONS)
	fps_label.position = Vector2(8, 4)
	fps_label.add_theme_font_size_override("font_size", 13)
	fps_label.add_theme_color_override("font_color", UI.TEXT_GOOD)
	fps_layer.layer = 20
	fps_layer.add_child(fps_label)
	add_child(fps_layer)
	# Lists scroll by dragging anywhere in them on a touchscreen.
	add_child(preload("res://src/presentation/touch_scroll.gd").new())
	var active := str(settings.get_value("content", "active", ""))
	if active.is_empty() or not activate(active):
		var installed := Library.installed()
		if installed.is_empty() or not activate(installed[0]):
			show_import()
			return
	show_title()

func setting(section: String, key: String, fallback = null):
	return settings.get_value(section, key, fallback)

func set_setting(section: String, key: String, value) -> void:
	settings.set_value(section, key, value)
	settings.save("user://settings.cfg")
	if section == "display": _apply_display_settings()
	if section == "audio": _apply_audio()

## False in checks, which must not re-measure graphics on the title.
var benchmark_allowed := true

var fps_layer := CanvasLayer.new()
var fps_label := Label.new()

func _process(_delta: float) -> void:
	fps_label.visible = bool(settings.get_value("display", "show_fps", false))
	if fps_label.visible: fps_label.text = "%d FPS" % Engine.get_frames_per_second()

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_F12:
		save_picture()
		get_viewport().set_input_as_handled()
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_F11:
		if not OS.has_feature("web") and not OS.has_feature("mobile"):
			set_setting("display", "fullscreen", not bool(settings.get_value("display", "fullscreen", false)))
			get_viewport().set_input_as_handled()

## Saves the next drawn frame as a PNG in the user data folder's
## screenshots folder and says where; returns the path, or "" on failure.
func save_picture() -> String:
	# A headless display draws nothing, and never finishes a frame.
	if DisplayServer.get_name() == "headless":
		_toast("The picture could not be saved.")
		return ""
	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	var dir := "user://screenshots"
	DirAccess.make_dir_recursive_absolute(dir)
	var stamp := Time.get_datetime_string_from_system().replace(":", "").replace("-", "").replace("T", "-")
	var path := dir.path_join("gof2-%s.png" % stamp)
	var n := 2
	while FileAccess.file_exists(path):
		path = dir.path_join("gof2-%s-%d.png" % [stamp, n])
		n += 1
	var ok := img != null and img.save_png(path) == OK
	_toast("Picture saved: " + ProjectSettings.globalize_path(path) if ok else "The picture could not be saved.")
	return path if ok else ""

## A short line at the top of the screen that fades by itself.
func _toast(text: String) -> void:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", 14)
	l.add_theme_color_override("font_outline_color", Color.BLACK)
	l.add_theme_constant_override("outline_size", 4)
	l.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	l.grow_horizontal = Control.GROW_DIRECTION_BOTH
	l.offset_top = 12
	var layer := CanvasLayer.new()
	layer.layer = 120
	add_child(layer)
	layer.add_child(l)
	var t := l.create_tween()
	t.tween_interval(2.5)
	t.tween_property(l, "modulate:a", 0.0, 0.6)
	t.tween_callback(layer.queue_free)

func _apply_display_settings() -> void:
	var fullscreen: bool = settings.get_value("display", "fullscreen", false)
	if not OS.has_feature("web") and not OS.has_feature("mobile"):
		get_window().mode = Window.MODE_FULLSCREEN if fullscreen else Window.MODE_WINDOWED
	Prefs.apply_display(self)

func _apply_audio() -> void:
	music.volume_db = linear_to_db(maxf(0.001, float(settings.get_value("audio", "music", 0.8))))

func activate(content_id: String) -> bool:
	var lib := Library.new()
	lib.smooth_textures = bool(settings.get_value("display", "smooth_textures", false))
	if not lib.open(content_id, str(settings.get_value("content", "language", ""))): return false
	library = lib
	catalogue = Catalogue.new(lib)
	UI.library = lib
	settings.set_value("content", "active", content_id)
	settings.save("user://settings.cfg")
	return true

# ------------------------------------------------------------------ screens

## A brief black cover over a change of place. The new screen is already in
## place underneath; nothing waits for the fade.
var fade_layer := CanvasLayer.new()
var fade := ColorRect.new()
var fade_tween: Tween

## Keeps menus and panels clear of a phone's notch and rounded corners. The
## flight screen insets its own instruments, since its markers must stay
## over the 3D view.
func inset_screen() -> void:
	var c := screen as Control
	if c == null or not is_inside_tree() or c.get("own_safe_margins") == true: return
	var m := SafeMargins.margins(get_viewport().get_visible_rect().size, TouchControls.wanted(self))
	c.offset_left = m.side
	c.offset_right = -m.side
	c.offset_top = m.top
	c.offset_bottom = -m.bottom

func _swap(next: Node) -> void:
	if screen != null:
		screen.queue_free()
	screen = next
	ui_layer.add_child(next)
	inset_screen()
	if bool(settings.get_value("interface", "transitions", true)) and is_inside_tree():
		if fade.get_parent() == null:
			fade_layer.layer = 15
			fade.color = Color.BLACK
			fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
			fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
			fade_layer.add_child(fade)
			add_child(fade_layer)
		if fade_tween != null: fade_tween.kill()
		fade.modulate.a = 1.0
		fade_tween = create_tween()
		fade_tween.tween_property(fade, "modulate:a", 0.0, 0.35).set_ease(Tween.EASE_OUT)

func show_import(message := "") -> void:
	stop_music()
	var s := ImportScreen.new()
	s.app = self
	s.message = message
	_swap(s)

func show_title() -> void:
	var s := TitleScreen.new()
	s.app = self
	_swap(s)

func show_station() -> void:
	# A generic Continue callback must not expose the return station's shop
	# while the current world is Void space.
	if game != null and game.session.in_void:
		show_flight()
		return
	var s := StationScreen.new()
	s.app = self
	_swap(s)

func show_flight() -> void:
	var s := FlightScreen.new()
	s.app = self
	_swap(s)

func _on_files_dropped(files: PackedStringArray) -> void:
	if screen != null and screen.has_method("import_file") and files.size() > 0:
		screen.import_file(files[0])

func _exit_tree() -> void:
	# The presentation helper's shared library must not retain GPU resources
	# after this app closes (including an embedded/test app instance).
	if UI.library == library: UI.library = null

# ------------------------------------------------------------------ game

func new_game() -> void:
	game = _make_game()
	game.new_game()
	# The story opens in space, with the ambush that strands Keith.
	if game.campaign.available(): show_flight()
	else: show_station()

func _make_game() -> Game:
	var g := Game.new(library, catalogue)
	g.docked.connect(_on_docked)
	return g

func _on_docked(_station_id: int) -> void:
	# Do not save on show_station/load/new_game: only a completed docking
	# creates an autosave, after the rewards and new mission are settled.
	save_game(AUTOSAVE_SLOT)

func _save_directory() -> String:
	return "user://saves/" + library.id

func save_path(slot: int) -> String:
	if not slot in LOAD_SLOTS: return ""
	return _save_directory().path_join("autosave.json" if slot == AUTOSAVE_SLOT else "slot%d.json" % slot)

func save_game(slot: int) -> bool:
	if game == null: return false
	last_save_error = ""
	var path := save_path(slot)
	if path.is_empty():
		last_save_error = "Invalid save slot."
		return false
	if DirAccess.make_dir_recursive_absolute(path.get_base_dir()) != OK:
		last_save_error = "Could not create the save folder."
		return false
	# Write and flush a sibling first. A failed write must not truncate the
	# player's previous checkpoint; rename only after serialization succeeds.
	var temporary := path + ".tmp"
	var f := FileAccess.open(temporary, FileAccess.WRITE)
	if f == null:
		last_save_error = "Could not write the save file."
		return false
	var d := game.session.to_dict()
	d.saved_at = Time.get_datetime_string_from_system()
	f.store_string(JSON.stringify(d))
	f.flush()
	var error := f.get_error()
	f.close()
	# The save being replaced is kept as a backup, which loading falls back
	# to if this file is ever damaged.
	if error == OK and FileAccess.file_exists(path): DirAccess.copy_absolute(path, path + ".bak")
	if error == OK: error = DirAccess.rename_absolute(temporary, path)
	if error != OK:
		DirAccess.remove_absolute(temporary)
		last_save_error = "Could not replace the save file. Your previous save is unchanged."
		return false
	return true

func save_summary(slot: int, backup := false) -> Dictionary:
	var path := save_path(slot)
	if backup and not path.is_empty(): path += ".bak"
	if path.is_empty() or not FileAccess.file_exists(path): return {}
	# The instance parser returns a recoverable error for a damaged file;
	# parse_string logs an engine error every time the load menu lists it.
	var parser := JSON.new()
	if parser.parse(FileAccess.get_file_as_string(path)) != OK: return {}
	if not parser.data is Dictionary: return {}
	var d: Dictionary = parser.data
	# The load menu formats these fields before the full session validator
	# runs. Damaged headers must not crash while merely listing save slots.
	for value in [d.get("station"), d.get("credits")]:
		if not (value is int or value is float): return {}
		if not is_finite(float(value)) or value < 0 or value > 9007199254740991 or float(value) != floor(float(value)): return {}
	return d

## Writes the current game to a file of the player's choosing, to carry to
## another device. It holds the save only, never the game's content.
func export_save(path: String) -> String:
	if game == null: return "There is no game to export."
	var d := game.session.to_dict()
	d.saved_at = Time.get_datetime_string_from_system()
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null: return "Could not write %s." % path.get_file()
	f.store_string(JSON.stringify(d))
	f.close()
	return ""

## Loads a save exported on another device. It must come from the same
## imported game; the saves on this device are left as they are.
func import_save(path: String) -> String:
	var parser := JSON.new()
	if parser.parse(FileAccess.get_file_as_string(path)) != OK or not parser.data is Dictionary:
		return "%s is not a save file." % path.get_file()
	var g := _make_game()
	var error := g.session.from_dict(parser.data)
	if not error.is_empty(): return error
	g.resume()
	game = g
	if g.session.in_void: show_flight()
	else: show_station()
	return ""

## Opens the system file picker for a save transfer; `done` receives the path.
func pick_save_file(saving: bool, done: Callable) -> void:
	var dialog := FileDialog.new()
	dialog.use_native_dialog = true
	dialog.access = FileDialog.ACCESS_FILESYSTEM
	dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE if saving else FileDialog.FILE_MODE_OPEN_FILE
	dialog.filters = PackedStringArray(["*.json ; Galaxy on Fire 2 save"])
	if saving: dialog.current_file = "gof2-save-%s.json" % Time.get_date_string_from_system()
	dialog.file_selected.connect(func(path: String):
		dialog.queue_free()
		done.call(path))
	dialog.canceled.connect(dialog.queue_free)
	add_child(dialog)
	dialog.popup_centered_ratio(0.7)

## A slot's summary for menus: its backup stands in for a damaged save.
func slot_summary(slot: int) -> Dictionary:
	var d := save_summary(slot)
	return d if not d.is_empty() else save_summary(slot, true)

## Shown once at the next station, e.g. when a damaged save was replaced by
## its backup.
var load_notice := ""

func load_game(slot: int) -> String:
	var d := save_summary(slot)
	var g := _make_game()
	var error := "Nothing is saved in this slot." if d.is_empty() else g.session.from_dict(d)
	if not error.is_empty():
		# A damaged save falls back to the copy it replaced.
		var b := save_summary(slot, true)
		if b.is_empty(): return error
		var fallback := _make_game()
		if not fallback.session.from_dict(b).is_empty(): return error
		g = fallback
		if not d.is_empty() or FileAccess.file_exists(save_path(slot)):
			load_notice = "This save was damaged. Its previous copy was loaded instead."
	g.resume()
	game = g
	if g.session.in_void: show_flight()
	else: show_station()
	return ""

func recover_from_defeat() -> void:
	# Loading creates a fresh game and restores the same content-keyed
	# checkpoint used by the load menus. With no checkpoint, replay the
	# opening instead of incorrectly appearing docked at story step zero.
	if not load_game(AUTOSAVE_SLOT).is_empty(): new_game()

# ------------------------------------------------------------------ audio

func play_music(name: String) -> void:
	if name == music_name and music.playing: return
	music_name = name
	var s: AudioStream = library.music(name) if library != null else null
	if s == null or not bool(settings.get_value("audio", "music_on", true)):
		music.stop(); return
	music.stream = s
	_apply_audio()
	music.play()

func stop_music() -> void:
	music.stop()
	music_name = ""

## Plays one of the original's sound effects by file name (without extension).
func play_sound(name: String, volume := 1.0) -> void:
	if library == null or not bool(settings.get_value("audio", "sound_on", true)): return
	var s: AudioStream = library.sound(name)
	if s == null: return
	for p in sfx_players:
		if not p.playing:
			p.stream = s
			p.volume_db = linear_to_db(maxf(0.001, volume * float(settings.get_value("audio", "sound", 0.8))))
			p.play()
			return
