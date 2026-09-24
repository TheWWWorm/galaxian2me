extends Node
## Application controller: settings, the active content, the running game and
## which screen is showing. Screens are separate scripts that call back here.

const Library := preload("res://src/content/library.gd")
const Catalogue := preload("res://src/content/catalogue.gd")
const Importer := preload("res://src/import/importer.gd")
const UI := preload("res://src/presentation/ui.gd")
const Session := preload("res://src/simulation/session.gd")
const Game := preload("res://src/simulation/game.gd")

const ImportScreen := preload("res://src/screens/import_screen.gd")
const TitleScreen := preload("res://src/screens/title_screen.gd")
const StationScreen := preload("res://src/screens/station_screen.gd")
const FlightScreen := preload("res://src/screens/flight_screen.gd")

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

func _ready() -> void:
	get_tree().root.theme = UI.make_theme()
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
	get_window().files_dropped.connect(_on_files_dropped)
	_apply_display_settings()
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

func _apply_display_settings() -> void:
	var fullscreen: bool = settings.get_value("display", "fullscreen", false)
	if not OS.has_feature("web") and not OS.has_feature("mobile"):
		get_window().mode = Window.MODE_FULLSCREEN if fullscreen else Window.MODE_WINDOWED

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

func _swap(next: Node) -> void:
	if screen != null:
		screen.queue_free()
	screen = next
	ui_layer.add_child(next)

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

# ------------------------------------------------------------------ game

func new_game() -> void:
	game = Game.new(library, catalogue)
	game.new_game()
	# The story opens in space, with the ambush that strands Keith.
	if game.campaign.available(): show_flight()
	else: show_station()

func save_path(slot: int) -> String:
	return "user://saves/%s/slot%d.json" % [library.id, slot]

func save_game(slot: int) -> bool:
	if game == null: return false
	DirAccess.make_dir_recursive_absolute("user://saves/" + library.id)
	var f := FileAccess.open(save_path(slot), FileAccess.WRITE)
	if f == null: return false
	var d := game.session.to_dict()
	d.saved_at = Time.get_datetime_string_from_system()
	f.store_string(JSON.stringify(d))
	return true

func save_summary(slot: int) -> Dictionary:
	var path := save_path(slot)
	if not FileAccess.file_exists(path): return {}
	var d = JSON.parse_string(FileAccess.get_file_as_string(path))
	return d if d is Dictionary else {}

func load_game(slot: int) -> String:
	var d := save_summary(slot)
	if d.is_empty(): return "Nothing is saved in this slot."
	var g := Game.new(library, catalogue)
	var error := g.session.from_dict(d)
	if not error.is_empty(): return error
	g.resume()
	game = g
	show_station()
	return ""

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
