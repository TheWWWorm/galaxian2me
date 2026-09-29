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
	if not OS.has_feature("web"):
		box.add_child(UI.button("Export save…", func(): app.pick_save_file(true, func(path):
			var err: String = app.export_save(path)
			station.notify("Saved to %s" % path.get_file() if err.is_empty() else err))))
	box.add_child(UI.button(lib.text(3), _options))
	box.add_child(UI.button(lib.text(4), func():
		frame.visible = false
		var p := preload("res://src/screens/help_panel.gd").new()
		p.app = app
		p.closed.connect(func(): frame.visible = true; _main())
		add_child(p)))
	box.add_child(UI.button(lib.text(67), func(): UI.ask(self, lib.text(31), func(): app.show_title(), _refocus.bind(lib.text(67)))))
	box.add_child(UI.button(lib.text(65), func(): station.close_panel()))
	(box.get_child(0) as Control).grab_focus.call_deferred()

## Puts the highlight back on the row that asked.
func _refocus(text: String) -> void:
	for b in box.get_children():
		if b is Button and b.text == text: b.grab_focus()

func _slot_label(slot: int) -> String:
	var d: Dictionary = app.slot_summary(slot)
	var prefix := "Autosave — " if slot == app.AUTOSAVE_SLOT else ""
	if d.is_empty(): return prefix + app.library.text(26)
	return prefix + "%s — %s  (%s)" % [app.catalogue.station_name(int(d.get("station", 0))), UI.money(int(d.get("credits", 0))), str(d.get("saved_at", "")).replace("T", " ")]

func _save() -> void:
	_clear()
	for slot in 3:
		var write := func():
			if app.save_game(slot): station.notify(app.library.text(28))
			else: station.notify(app.last_save_error)
			_main()
		var label := _slot_label(slot)
		# 27: "Are you sure you want to overwrite this game?"
		box.add_child(UI.button(label, func():
			if app.slot_summary(slot).is_empty(): write.call()
			else: UI.ask(self, app.library.text(27), write, _refocus.bind(label))))
	box.add_child(UI.button(app.library.text(65), _main))

func _load() -> void:
	_clear()
	for slot in app.LOAD_SLOTS:
		var used: bool = not app.slot_summary(slot).is_empty()
		var label := _slot_label(slot)
		var restore := func():
			var err: String = app.load_game(slot)
			if not err.is_empty(): station.notify(err)
		# 29: "Do you want to load the new game and discard the current one?"
		box.add_child(UI.button(label, func(): UI.ask(self, app.library.text(29), restore, _refocus.bind(label)), used))
	if not OS.has_feature("web"):
		box.add_child(UI.button("Import save…", func(): app.pick_save_file(false, func(path):
			var err: String = app.import_save(path)
			if not err.is_empty(): station.notify(err))))
	box.add_child(UI.button(app.library.text(65), _main))

func _options() -> void:
	frame.visible = false
	var p := OptionsPanel.new()
	p.app = app
	p.closed.connect(func(): frame.visible = true; _main())
	add_child(p)
