extends "res://src/main.gd"
## Test host for the real screens and simulation. Reads an installed content
## cache, but never reads/writes player saves or writes settings to disk.
## A check may opt into real JSON file IO in its own explicit output folder.

var saved_slots := {}
var disk_saves := ""
var save_attempts: Array[int] = []

func _ready() -> void:
	# Checks never read a player's real replacement art.
	preload("res://src/content/mods.gd").only_root = "res://tests/no-mods"
	benchmark_allowed = false
	get_tree().root.theme = UI.make_theme()
	add_child(world_root)
	ui_layer.layer = 10
	add_child(ui_layer)
	add_child(music)
	settings.set_value("controls", "touch", "on")
	# Checks drive the screens directly; first-time help would interrupt them.
	settings.set_value("interface", "help_popups", false)
	settings.set_value("controls", "mouse", false)
	settings.set_value("audio", "music_on", false)
	settings.set_value("audio", "sound_on", false)
	# As the game does at start: flight actions exist before any flight.
	var Controls := preload("res://src/flight/controls.gd")
	Controls.ensure_actions()
	Prefs.apply_bindings(self, Controls.ACTIONS)
	for content_id in Library.installed():
		if activate(str(content_id)):
			show_title()
			return

func activate(content_id: String) -> bool:
	var lib := Library.new()
	if not lib.open(content_id): return false
	library = lib
	catalogue = Catalogue.new(lib)
	UI.library = lib
	return true

func set_setting(section: String, key: String, value) -> void:
	settings.set_value(section, key, value)

func save_game(slot: int) -> bool:
	save_attempts.append(slot)
	if not disk_saves.is_empty(): return super.save_game(slot)
	if game == null: return false
	if not slot in LOAD_SLOTS: return false
	var d := game.session.to_dict()
	d.saved_at = Time.get_datetime_string_from_system()
	# Exercise JSON's integer-to-float conversion even in memory-only tests.
	saved_slots[slot] = JSON.stringify(d)
	return true

func save_summary(slot: int, backup := false) -> Dictionary:
	if not disk_saves.is_empty(): return super.save_summary(slot, backup)
	if backup: return {}
	var d = JSON.parse_string(saved_slots[slot]) if saved_slots.has(slot) else null
	return d if d is Dictionary else {}

func _save_directory() -> String:
	# The empty mode never delegates to disk IO. Its path must not accidentally
	# point at the user's real save directory even if a test queries it.
	return disk_saves.path_join(library.id) if not disk_saves.is_empty() else ""

func save_path(slot: int) -> String:
	return super.save_path(slot) if not disk_saves.is_empty() else ""
