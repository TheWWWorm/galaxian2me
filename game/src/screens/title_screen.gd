extends Control
## Title: a random station seen along the original's title camera path, the
## logo, and the main menu with the original's labels.

const UI := preload("res://src/presentation/ui.gd")
const Assembly := preload("res://src/presentation/assembly.gd")
const Backdrop := preload("res://src/presentation/backdrop.gd")
const CameraPath := preload("res://src/presentation/camera_path.gd")
const OptionsPanel := preload("res://src/screens/options_panel.gd")
const HelpPanel := preload("res://src/screens/help_panel.gd")
const ModsPanel := preload("res://src/screens/mods_panel.gd")
const CreditsPanel := preload("res://src/screens/credits_panel.gd")
const Benchmark := preload("res://src/presentation/benchmark.gd")

var app
var scene := Node3D.new()
var camera := Camera3D.new()
var env := WorldEnvironment.new()
var backdrop: Backdrop
var path: CameraPath
var clock := 0.0
var menu: VBoxContainer
var menu_frame: Control
var panel_holder: Control

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build_scene()
	var column := VBoxContainer.new()
	column.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	column.offset_top = 24
	column.offset_bottom = -40
	column.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(column)
	var logo := UI.picture(app.library.texture("logo"), 3.0)
	logo.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	column.add_child(logo)
	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_child(spacer)
	var frame := UI.Frame.new(app.library.text(67))
	menu_frame = frame
	frame.custom_minimum_size = Vector2(320, 0)
	frame.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	column.add_child(frame)
	menu = VBoxContainer.new()
	menu.add_theme_constant_override("separation", 6)
	frame.add_child(menu)
	_fill_menu()
	panel_holder = CenterContainer.new()
	panel_holder.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	panel_holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(panel_holder)
	var version := UI.label("%s %s" % [app.library.manifest.get("name", ""), app.library.manifest.get("version", "")], 12, UI.TEXT_DIM)
	version.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	version.position = Vector2(10, -24)
	add_child(version)
	app.play_music("gof2_theme")
	if Benchmark.due(app):
		var b := Benchmark.new()
		b.app = app
		add_child(b)

func _fill_menu() -> void:
	for c in menu.get_children(): c.queue_free()
	menu_frame.visible = true
	var lib = app.library
	if app.game != null:
		menu.add_child(UI.button(lib.text(18), func(): app.show_station()))
	else:
		var latest = _latest_save()
		if latest != null:
			menu.add_child(UI.button(lib.text(18), func():
				var err: String = app.load_game(int(latest))
				if not err.is_empty(): _message(err)))
	menu.add_child(UI.button(lib.text(0), _new_game))
	menu.add_child(UI.button(lib.text(1), _load))
	menu.add_child(UI.button(lib.text(3), _options))
	menu.add_child(UI.button(lib.text(4), _help))
	menu.add_child(UI.button("Mods", _mods))
	menu.add_child(UI.button(lib.text(21), _credits))
	if not OS.has_feature("web"):
		menu.add_child(UI.button(lib.text(5), func(): get_tree().quit()))
	(menu.get_child(0) as Control).grab_focus.call_deferred()

## The most recently written save slot, or null when there is none.
func _latest_save():
	var best = null
	var when := ""
	for slot in app.LOAD_SLOTS:
		var d: Dictionary = app.slot_summary(slot)
		if d.is_empty(): continue
		var at := str(d.get("saved_at", ""))
		if best == null or at > when:
			best = slot
			when = at
	return best

func _build_scene() -> void:
	var lib = app.library
	var cat = app.catalogue
	# The station of the game in progress or of the latest save, the one the
	# player will return to; a random one before the first game.
	var station_id := randi_range(0, lib.data.stations.size() - 1)
	var latest = _latest_save()
	if app.game != null and not app.game.session.in_void:
		station_id = int(app.game.session.station_id)
	elif latest != null:
		var d: Dictionary = app.slot_summary(int(latest))
		if not bool(d.get("in_void", false)) and d.has("station"): station_id = int(d.station)
	station_id = clampi(station_id, 0, lib.data.stations.size() - 1)
	var st: Dictionary = cat.station(station_id)
	var faction: int = int(cat.system(int(st.system)).faction)
	app.world_root.add_child(scene)
	scene.add_child(Assembly.station(lib, station_id, faction))
	backdrop = Backdrop.new()
	backdrop.setup(lib, station_id, cat)
	scene.add_child(backdrop)
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_COLOR
	scene.add_child(env)
	camera.near = 1.0
	camera.far = 6000.0
	camera.keep_aspect = Camera3D.KEEP_WIDTH
	camera.fov = 70.0
	scene.add_child(camera)
	camera.make_current()
	var keys = lib.constant("co#a:[[I")
	path = CameraPath.new(keys[0] if keys is Array and keys.size() > 0 else [])

func _process(delta: float) -> void:
	clock += delta
	if path.valid():
		var pose := path.sample(clock * 1000.0)
		camera.global_transform = pose.transform
		camera.fov = pose.fov
	backdrop.follow(camera)
	env.environment.background_color = backdrop.background_color(camera)

func _exit_tree() -> void:
	scene.queue_free()

func _new_game() -> void:
	if app.game != null:
		_confirm(app.library.text(30), func(): app.new_game())
	else:
		app.new_game()

func _load() -> void:
	var f := UI.Frame.new(app.library.text(1))
	f.custom_minimum_size = Vector2(420, 0)
	var box := VBoxContainer.new()
	f.add_child(box)
	for slot in app.LOAD_SLOTS:
		var d: Dictionary = app.slot_summary(slot)
		var label: String = app.library.text(26) if d.is_empty() else "%s — %s  (%s)" % [app.catalogue.station_name(int(d.get("station", 0))), UI.money(int(d.get("credits", 0))), str(d.get("saved_at", "")).replace("T", " ")]
		if slot == app.AUTOSAVE_SLOT: label = "Autosave — " + label
		if bool(d.get("in_void", false)): label = app.library.text(269) + " — " + label
		var b := UI.button(label, func():
			var err: String = app.load_game(slot)
			if not err.is_empty(): _message(err), not d.is_empty())
		box.add_child(b)
	if not OS.has_feature("web"):
		box.add_child(UI.button("Import save…", func(): app.pick_save_file(false, func(path):
			var err: String = app.import_save(path)
			if not err.is_empty(): _message(err))))
	box.add_child(UI.button(app.library.text(65), func(): f.queue_free(); _fill_menu()))
	_show_panel(f)

func _options() -> void:
	var p := OptionsPanel.new()
	p.app = self.app
	p.closed.connect(_fill_menu)
	_show_panel(p)

func _help() -> void:
	var p := HelpPanel.new()
	p.app = app
	p.closed.connect(_fill_menu)
	_show_panel(p)

func _credits() -> void:
	var p := CreditsPanel.new()
	p.app = app
	p.closed.connect(_fill_menu)
	_show_panel(p)

func _mods() -> void:
	var p := ModsPanel.new()
	p.app = app
	p.closed.connect(_fill_menu)
	_show_panel(p)

## Esc or the pad's B leaves any title page for the menu.
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and panel_holder.get_child_count() > 0:
		get_viewport().set_input_as_handled()
		for c in panel_holder.get_children(): c.queue_free()
		_fill_menu()

func _show_panel(p: Control) -> void:
	for c in panel_holder.get_children(): c.queue_free()
	panel_holder.add_child(p)
	for c in menu.get_children(): c.queue_free()
	menu_frame.visible = false

func _message(text: String) -> void:
	var f := UI.Frame.new(app.library.text(212))
	f.custom_minimum_size = Vector2(400, 0)
	var box := VBoxContainer.new()
	f.add_child(box)
	box.add_child(UI.paragraph(text))
	var ok := UI.button(app.library.text(35), func(): f.queue_free(); _fill_menu())
	box.add_child(ok)
	_show_panel(f)
	ok.grab_focus.call_deferred()

func _confirm(text: String, action: Callable) -> void:
	var f := UI.Frame.new(app.library.text(240))
	f.custom_minimum_size = Vector2(420, 0)
	var box := VBoxContainer.new()
	f.add_child(box)
	box.add_child(UI.paragraph(text))
	var row := HBoxContainer.new()
	box.add_child(row)
	var yes := UI.button(app.library.text(38), func(): f.queue_free(); action.call())
	row.add_child(yes)
	row.add_child(UI.button(app.library.text(39), func(): f.queue_free(); _fill_menu()))
	_show_panel(f)
	yes.grab_focus.call_deferred()
