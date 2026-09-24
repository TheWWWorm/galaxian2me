extends "res://src/presentation/ui.gd".Frame
## Options: the original's sound settings plus the engine's display and
## content settings.

const UI := preload("res://src/presentation/ui.gd")

signal closed

var app
var box := VBoxContainer.new()

func _init() -> void:
	super._init("")

func _ready() -> void:
	title = app.library.text(3)
	custom_minimum_size = Vector2(460, 0)
	box.add_theme_constant_override("separation", 6)
	add_child(box)
	_build()

func _build() -> void:
	for c in box.get_children(): c.queue_free()
	var lib = app.library
	_toggle(lib.text(6), "audio", "music_on", true, func(on):
		if not on: app.stop_music())
	_slider(lib.text(6), "audio", "music", 0.8)
	_toggle(lib.text(7), "audio", "sound_on", true)
	_slider(lib.text(7), "audio", "sound", 0.8)
	_toggle(lib.text(13), "controls", "auto_fire", false)
	_toggle(lib.text(14), "controls", "invert", false)
	if not OS.has_feature("web") and not OS.has_feature("mobile"):
		_toggle("Fullscreen", "display", "fullscreen", false)
	_toggle("Smooth textures", "display", "smooth_textures", false, func(_on):
		app.activate(app.library.id))
	var langs: Array = lib.data.languages.keys()
	if langs.size() > 1:
		var row := HBoxContainer.new()
		row.add_child(UI.label(lib.text(12)))
		var pick := OptionButton.new()
		for code in langs: pick.add_item(code)
		pick.selected = langs.find(lib.language)
		pick.item_selected.connect(func(i):
			app.set_setting("content", "language", langs[i])
			app.activate(app.library.id)
			_build())
		row.add_child(pick)
		box.add_child(row)
	box.add_child(UI.button("Import a different JAR…", func(): app.show_import()))
	var back := UI.button(lib.text(65), func():
		closed.emit()
		queue_free())
	box.add_child(back)
	back.grab_focus.call_deferred()

func _toggle(text: String, section: String, key: String, fallback: bool, then := Callable()) -> void:
	var c := CheckButton.new()
	c.text = text
	c.button_pressed = bool(app.setting(section, key, fallback))
	c.toggled.connect(func(on):
		app.set_setting(section, key, on)
		if then.is_valid(): then.call(on))
	box.add_child(c)

func _slider(text: String, section: String, key: String, fallback: float) -> void:
	var row := HBoxContainer.new()
	var l := UI.label("   " + text, 14, UI.TEXT_DIM)
	l.custom_minimum_size.x = 140
	row.add_child(l)
	var s := HSlider.new()
	s.min_value = 0.0; s.max_value = 1.0; s.step = 0.05
	s.value = float(app.setting(section, key, fallback))
	s.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	s.value_changed.connect(func(v): app.set_setting(section, key, v))
	row.add_child(s)
	box.add_child(row)
