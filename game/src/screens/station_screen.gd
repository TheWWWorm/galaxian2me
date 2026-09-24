extends Control
## Docked at a station: the hangar view behind the original's six sections
## (Hangar, Space Lounge, Map, Missions, Status, Game Options). Sections the
## story has not opened yet stay locked, as in the original.

const UI := preload("res://src/presentation/ui.gd")
const HangarView := preload("res://src/presentation/hangar_view.gd")
const ShopPanel := preload("res://src/screens/station/shop_panel.gd")
const ShipPanel := preload("res://src/screens/station/ship_panel.gd")
const DealerPanel := preload("res://src/screens/station/dealer_panel.gd")
const StatusPanel := preload("res://src/screens/station/status_panel.gd")
const MapPanel := preload("res://src/screens/station/map_panel.gd")
const MissionsPanel := preload("res://src/screens/station/missions_panel.gd")
const LoungePanel := preload("res://src/screens/station/lounge_panel.gd")
const GamePanel := preload("res://src/screens/station/game_panel.gd")
const DialoguePanel := preload("res://src/screens/dialogue_panel.gd")

## Section labels (strings) and the story step each opens at.
const SECTIONS := [[62, 5], [218, 13], [72, 9], [33, 13], [64, 0], [66, 0]]

var app
var game
var scene := Node3D.new()
var view: HangarView
var env := WorldEnvironment.new()
var header: Label
var credits_label: Label
var menu: VBoxContainer
var content: Control
var current_panel: Control
var toast: Label
var toast_time := 0.0

func _ready() -> void:
	game = app.game
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build_scene()
	_build_layout()
	game.changed.connect(_refresh)
	_refresh()
	app.play_music("gof2_hangar")
	_on_arrival.call_deferred()

func _build_scene() -> void:
	app.world_root.add_child(scene)
	var st: Dictionary = game.station()
	var faction := int(game.system().faction)
	view = HangarView.new()
	view.setup(app.library, int(st.id), faction, int(game.session.ship.index), int(game.session.ship.faction))
	scene.add_child(view)
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_COLOR
	env.environment.background_color = Color(0.02, 0.025, 0.03)
	scene.add_child(env)
	view.camera.make_current()

func _build_layout() -> void:
	var top := HBoxContainer.new()
	top.set_anchors_preset(Control.PRESET_TOP_WIDE)
	top.offset_left = 12; top.offset_top = 10; top.offset_right = -12
	add_child(top)
	var logo := UI.picture(app.library.texture("logo_%d" % int(game.system().faction)), 1.5)
	top.add_child(logo)
	var names := VBoxContainer.new()
	top.add_child(names)
	header = UI.label("", 22)
	names.add_child(header)
	credits_label = UI.label("", 16, UI.TEXT_GOOD)
	names.add_child(credits_label)
	var left := UI.Frame.new(app.library.text(40))
	left.set_anchors_preset(Control.PRESET_LEFT_WIDE)
	left.offset_left = 12; left.offset_top = 96; left.offset_bottom = -12
	left.custom_minimum_size.x = 230
	add_child(left)
	menu = VBoxContainer.new()
	menu.add_theme_constant_override("separation", 6)
	left.add_child(menu)
	content = Control.new()
	content.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	content.offset_left = 256; content.offset_top = 96; content.offset_right = -12; content.offset_bottom = -12
	content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(content)
	toast = UI.label("", 16, UI.TEXT_WARN)
	toast.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	toast.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	toast.offset_top = -44; toast.offset_left = -300; toast.offset_right = 300
	add_child(toast)
	_build_menu()

func _build_menu() -> void:
	for c in menu.get_children(): c.queue_free()
	var step: int = game.session.story_step
	for i in SECTIONS.size():
		var open: bool = step >= int(SECTIONS[i][1])
		var b := UI.button(app.library.text(SECTIONS[i][0]), _open_section.bind(i))
		if not open:
			b.icon = app.library.texture("lock")
			b.expand_icon = false
			b.modulate = Color(0.7, 0.7, 0.7)
		menu.add_child(b)
	(menu.get_child(0) as Control).grab_focus.call_deferred()

func _refresh() -> void:
	var st: Dictionary = game.station()
	header.text = "%s  ·  %s  ·  %s %d" % [st.get("name", "?"), app.catalogue.system_name(game.session.system_index), app.library.text(37), int(st.get("tech", 0))]
	credits_label.text = "%s: %s" % [app.library.text(80), UI.money(game.session.credits)]

func _process(delta: float) -> void:
	if toast_time > 0.0:
		toast_time -= delta
		if toast_time <= 0.0: toast.text = ""

func notify(text: String) -> void:
	if text.is_empty(): return
	toast.text = text
	toast_time = 4.0

func _open_section(index: int) -> void:
	if game.session.story_step < int(SECTIONS[index][1]):
		notify(app.library.text(257))
		return
	match index:
		0: show_panel(_hangar_panel())
		1: _show(LoungePanel)
		2: _show(MapPanel)
		3: _show(MissionsPanel)
		4: _show(StatusPanel)
		5: _show(GamePanel)

func _show(script) -> void:
	var p = script.new()
	p.station = self
	show_panel(p)

func show_panel(p: Control) -> void:
	if current_panel != null: current_panel.queue_free()
	current_panel = p
	content.add_child(p)
	p.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

func close_panel() -> void:
	if current_panel != null: current_panel.queue_free()
	current_panel = null
	_build_menu()

## The hangar: shop, own ship and (where one exists) the ship dealer.
func _hangar_panel() -> Control:
	var tabs := TabContainer.new()
	tabs.add_theme_color_override("font_selected_color", Color.WHITE)
	var shop := ShopPanel.new(); shop.station = self; shop.name = app.library.text(79)
	tabs.add_child(shop)
	var ship := ShipPanel.new(); ship.station = self; ship.name = app.library.text(77)
	tabs.add_child(ship)
	if not game.dealer().is_empty():
		var dealer := DealerPanel.new(); dealer.station = self; dealer.name = app.library.text(68)
		tabs.add_child(dealer)
	return tabs

func refresh_ship_model() -> void:
	view.replace_ship(int(game.session.ship.index), int(game.session.ship.faction))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and current_panel != null:
		close_panel()
		get_viewport().set_input_as_handled()
	elif event.is_action("ui_left") and current_panel == null: view.nudge(-1)
	elif event.is_action("ui_right") and current_panel == null: view.nudge(1)

## Arrival: story debriefings and mission settlement happen here.
func _on_arrival() -> void:
	var lines: Array = game.pending_dialogue
	game.pending_dialogue = []
	if not lines.is_empty():
		show_dialogue(lines, func(): _build_menu())

func show_dialogue(lines: Array, done: Callable) -> void:
	var d := DialoguePanel.new()
	d.app = app
	d.lines = lines
	d.finished.connect(func():
		d.queue_free()
		done.call())
	add_child(d)

func depart(destination: Dictionary) -> void:
	game.depart(destination)
	app.show_flight()

func _exit_tree() -> void:
	scene.queue_free()
