extends CenterContainer
## Game options while docked: save, load, settings, back to the title.

const UI := preload("res://src/presentation/ui.gd")
const OptionsPanel := preload("res://src/screens/options_panel.gd")

var station
var app
var frame
var box: VBoxContainer

func _ready() -> void:
	app = station.app
	frame = UI.Frame.new(app.library.text(66))
	frame.custom_minimum_size = Vector2(440, 0)
	add_child(frame)
	box = VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	frame.add_child(box)
	_main()

func _clear() -> void:
	for c in box.get_children(): c.queue_free()

func _main() -> void:
	_clear()
	var lib = app.library
	box.add_child(UI.button(lib.text(2), _save))
	box.add_child(UI.button(lib.text(1), _load))
	box.add_child(UI.button(lib.text(3), _options))
	box.add_child(UI.button(lib.text(67), func(): app.show_title()))
	box.add_child(UI.button(lib.text(65), func(): station.close_panel()))
	(box.get_child(0) as Control).grab_focus.call_deferred()

func _slot_label(slot: int) -> String:
	var d: Dictionary = app.save_summary(slot)
	if d.is_empty(): return app.library.text(26)
	return "%s — %s  (%s)" % [app.catalogue.station_name(int(d.get("station", 0))), UI.money(int(d.get("credits", 0))), str(d.get("saved_at", "")).replace("T", " ")]

func _save() -> void:
	_clear()
	for slot in 3:
		box.add_child(UI.button(_slot_label(slot), func():
			if app.save_game(slot): station.notify(app.library.text(28))
			_main()))
	box.add_child(UI.button(app.library.text(65), _main))

func _load() -> void:
	_clear()
	for slot in 3:
		var used: bool = not app.save_summary(slot).is_empty()
		box.add_child(UI.button(_slot_label(slot), func():
			var err: String = app.load_game(slot)
			if not err.is_empty(): station.notify(err), used))
	box.add_child(UI.button(app.library.text(65), _main))

func _options() -> void:
	frame.visible = false
	var p := OptionsPanel.new()
	p.app = app
	p.closed.connect(func(): frame.visible = true; _main())
	add_child(p)
