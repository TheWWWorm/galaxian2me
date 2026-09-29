extends Control
## Docked at a station: the hangar view behind the original's six sections
## (Hangar, Space Lounge, Map, Missions, Status, Game Options). Sections the
## story has not opened yet stay locked, as in the original.

const UI := preload("res://src/presentation/ui.gd")
const HangarView := preload("res://src/presentation/hangar_view.gd")
const ShopPanel := preload("res://src/screens/station/shop_panel.gd")
const ShipPanel := preload("res://src/screens/station/ship_panel.gd")
const DealerPanel := preload("res://src/screens/station/dealer_panel.gd")
const BlueprintsPanel := preload("res://src/screens/station/blueprints_panel.gd")
const StatusPanel := preload("res://src/screens/station/status_panel.gd")
const MapPanel := preload("res://src/screens/station/map_panel.gd")
const MissionsPanel := preload("res://src/screens/station/missions_panel.gd")
const LoungePanel := preload("res://src/screens/station/lounge_panel.gd")
const GamePanel := preload("res://src/screens/station/game_panel.gd")
const DialoguePanel := preload("res://src/screens/dialogue_panel.gd")
const Common := preload("res://src/screens/station/common.gd")
const Portrait := preload("res://src/presentation/portrait.gd")

## Section labels (strings) and the story step each opens at.
## The original's highlight for the chosen entry of a list.
const ORANGE := Color8(0xff, 0x9a, 0x2e)
const SECTIONS := [[62, 5], [218, 13], [72, 9], [33, 13], [64, 0], [66, 0]]

var app
var game
var scene := Node3D.new()
var view: HangarView
var env := WorldEnvironment.new()
var header: Label
var credits_label: Label
var tech_label: Label
var footer: PanelContainer
var menu: VBoxContainer
var rail: Control
var home: VBoxContainer
var launch_button: Button
var back_button: Button
var content: Control
var current_panel: Control
var toast: Label
var toast_time := 0.0
var conversation: DialoguePanel
var progress_queued := false

func _ready() -> void:
	game = app.game
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build_scene()
	_build_layout()
	game.changed.connect(_session_changed)
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
	# The original's corner: the station's name over its tech level.
	header = UI.label("", 22)
	names.add_child(header)
	tech_label = UI.label("", 16)
	names.add_child(tech_label)
	# Held upright the rail gives way to the page; this leads back to the tiles.
	var gap := Control.new()
	gap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(gap)
	back_button = UI.button(app.library.text(74), close_panel)
	back_button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	top.add_child(back_button)
	var left := UI.Frame.new(app.library.text(40))
	rail = left
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
	# The docked home, as the original lays it out: the section list in a
	# window at the bottom left over the hangar view, the credits at the bottom
	# right and Depart on the footer bar.
	footer = PanelContainer.new()
	footer.add_theme_stylebox_override("panel", UI._box(UI.DEEP, UI.BORDER))
	footer.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	footer.offset_top = -46
	add_child(footer)
	var bar := HBoxContainer.new()
	footer.add_child(bar)
	var gap2 := Control.new()
	gap2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.add_child(gap2)
	launch_button = UI.button(app.library.text(239), depart.bind({}))
	launch_button.flat = true
	launch_button.add_theme_font_size_override("font_size", 20)
	bar.add_child(launch_button)
	credits_label = UI.label("", 18)
	credits_label.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	credits_label.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	credits_label.grow_vertical = Control.GROW_DIRECTION_BEGIN
	credits_label.offset_right = -12; credits_label.offset_bottom = -52
	credits_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	add_child(credits_label)
	home = VBoxContainer.new()
	home.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	home.offset_left = 12; home.offset_bottom = -54
	home.grow_vertical = Control.GROW_DIRECTION_BEGIN
	add_child(home)
	toast = UI.label("", 16, UI.TEXT_WARN)
	toast.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	toast.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	toast.offset_top = -44; toast.offset_left = -300; toast.offset_right = 300
	add_child(toast)
	_build_menu()
	resized.connect(_fit_orientation)

## Held upright (Deep's portrait mode) the section rail is dropped for the
## home tiles and a Back button, and each page stacks its columns.
func _fit_orientation() -> void:
	var tall := size.y > size.x
	# A page that fills the screen (the lounge's bar) brings its own Back.
	var full := current_panel != null and current_panel.has_meta("full_view")
	rail.visible = current_panel != null and not tall and not full
	back_button.visible = current_panel != null and tall and not full
	content.offset_left = 12 if tall or full else 256
	if current_panel == null: return
	var boxes: Array = [current_panel]
	if current_panel is TabContainer: boxes = current_panel.get_children()
	for box in boxes:
		if box is BoxContainer and not (box is HBoxContainer or box is VBoxContainer): _stack(box, tall)

static func _stack(box: BoxContainer, tall: bool) -> void:
	if box.vertical == tall: return
	box.vertical = tall
	for c in box.get_children():
		if not c is Control: continue
		if not c.has_meta("wide_layout"): c.set_meta("wide_layout", [c.size_flags_vertical, c.custom_minimum_size.x])
		var wide: Array = c.get_meta("wide_layout")
		c.size_flags_vertical = Control.SIZE_EXPAND_FILL if tall else int(wide[0])
		c.custom_minimum_size.x = 0.0 if tall else float(wide[1])

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
	# Departure cannot live exclusively in the Map section: that section
	# unlocks after the opening mining flights have already been completed.
	menu.add_child(HSeparator.new())
	menu.add_child(UI.button(app.library.text(239), depart.bind({})))
	_build_home()
	home.visible = current_panel == null
	footer.visible = current_panel == null
	credits_label.visible = current_panel == null
	_fit_orientation()
	if current_panel != null: (menu.get_child(0) as Control).grab_focus.call_deferred()

## The home list: the original's six sections, locked ones marked.
func _build_home() -> void:
	for c in home.get_children(): c.queue_free()
	var frame := UI.Frame.new("")
	frame.custom_minimum_size.x = 260
	home.add_child(frame)
	var list := VBoxContainer.new()
	list.add_theme_constant_override("separation", 0)
	frame.add_child(list)
	var step: int = game.session.story_step
	var first: Control = null
	for i in SECTIONS.size():
		var open: bool = step >= int(SECTIONS[i][1])
		var b := _menu_item(app.library.text(SECTIONS[i][0]), open, _open_section.bind(i))
		list.add_child(b)
		if first == null: first = b
	if first != null: first.grab_focus.call_deferred()

## A plain list entry, orange when chosen, as the original's menus draw them.
func _menu_item(text: String, open: bool, action: Callable) -> Button:
	var b := Button.new()
	b.text = text
	b.flat = true
	b.alignment = HORIZONTAL_ALIGNMENT_LEFT
	b.focus_mode = Control.FOCUS_ALL
	b.add_theme_font_size_override("font_size", 20)
	b.add_theme_color_override("font_hover_color", ORANGE)
	b.add_theme_color_override("font_focus_color", ORANGE)
	b.add_theme_color_override("font_pressed_color", ORANGE)
	b.add_theme_color_override("font_hover_pressed_color", ORANGE)
	var none := StyleBoxEmpty.new()
	for state in ["normal", "hover", "pressed", "focus", "hover_pressed"]: b.add_theme_stylebox_override(state, none)
	# Every entry keeps the lock's width so the names line up.
	var lock: Texture2D = app.library.texture("lock")
	if open:
		var room: Vector2i = Vector2i(lock.get_size()) if lock != null else Vector2i(8, 8)
		var blank := Image.create_empty(room.x, room.y, false, Image.FORMAT_RGBA8)
		b.icon = ImageTexture.create_from_image(blank)
	else:
		b.icon = lock
	b.expand_icon = false
	b.pressed.connect(action)
	return b

func _refresh() -> void:
	var st: Dictionary = game.station()
	header.text = str(st.get("name", "?"))
	tech_label.text = "%s: %d" % [app.library.text(37), int(st.get("tech", 0))]
	credits_label.text = UI.money(game.session.credits)

## Trading and fitting can satisfy a docked goal without another flight.
## Defer until the control's callback has finished rebuilding its rows. Merely
## opening a loaded station must not replay progression or checkpoint rewards.
func _session_changed() -> void:
	_refresh()
	_queue_progress()

func _queue_progress() -> void:
	if progress_queued: return
	progress_queued = true
	_settle_progress.call_deferred()

func _settle_progress() -> void:
	progress_queued = false
	if not is_inside_tree() or is_queued_for_deletion() or app.screen != self or conversation != null: return
	# The supplied station loop checks purchase orders while docked, including
	# after accepting an already-carried order or buying its final unit. Run
	# only after an explicit station mutation, never merely on load, and wait
	# until the lounge/shop callback has finished rebuilding its controls.
	if int(game.session.job.get("kind", -1)) == 8:
		game.settle_job(game.session.station_id)
		if game.session.job.is_empty():
			_refresh()
			_on_arrival()
			if conversation != null: return
	if not game.campaign.check(true, game.session.station_id): return
	game.campaign.conclude()
	_refresh()
	_build_menu()
	_on_arrival()
	if conversation == null: _queue_progress()

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
	var map_tip := "galaxy_map" if game.session.story_step >= 16 else "system_map"
	_tip(["shop", "lounge", map_tip, "missions", "status", ""][index])
	# Opened from the keyboard or pad: the highlight moves into the page.
	if Input.is_action_pressed("ui_accept"): _focus_first.call_deferred(current_panel)

## Focuses the page's first enabled button (never a text field, which would
## raise a phone's keyboard), unless focus is already inside it.
func _focus_first(p: Control) -> void:
	if not is_instance_valid(p) or not p.is_inside_tree() or conversation != null: return
	var owner := get_viewport().gui_get_focus_owner()
	if owner != null and p.is_ancestor_of(owner): return
	for c in p.find_children("*", "BaseButton", true, false):
		var b := c as BaseButton
		if b.is_visible_in_tree() and b.focus_mode != Control.FOCUS_NONE and not b.disabled:
			b.grab_focus()
			return

## First-time help for a station section, as the original's help windows.
func _tip(key: String) -> void:
	if key.is_empty() or conversation != null: return
	var Tips := preload("res://src/presentation/tips.gd")
	var line := Tips.station_tip(app, key)
	if line.is_empty(): return
	show_dialogue([line], func():
		if key == "status": _tip("medals"))

func _show(script) -> void:
	var p = script.new()
	p.station = self
	show_panel(p)

func show_panel(p: Control) -> void:
	if current_panel != null: current_panel.queue_free()
	current_panel = p
	content.add_child(p)
	p.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	home.visible = false
	footer.visible = false
	credits_label.visible = false
	_fit_orientation()

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
	var blueprints := BlueprintsPanel.new(); blueprints.station = self; blueprints.name = app.library.text(130)
	tabs.add_child(blueprints)
	tabs.tab_changed.connect(func(i):
		var child := tabs.get_child(i)
		if child == ship: _tip("ship")
		elif child == blueprints: _tip("blueprints"))
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
	if not app.last_save_error.is_empty(): notify(app.last_save_error)
	if not app.load_notice.is_empty():
		notify(app.load_notice)
		app.load_notice = ""
	var lines: Array = game.pending_dialogue
	game.pending_dialogue = []
	if not lines.is_empty():
		show_dialogue(lines, func():
			_build_menu()
			_show_medals(), true)
	else:
		_show_medals()

## The original's one-time notices for all medals (paying fans among the
## lounge's wingmen) and all gold medals (the Void prototype at Thynome).
func _medal_notices() -> void:
	var flags: Dictionary = game.session.flags
	for pair in [["all_medals", "notice_fans", 325], ["all_gold", "notice_prototype", 326]]:
		if bool(flags.get(pair[0], false)) and not bool(flags.get(pair[1], false)):
			flags[pair[1]] = true
			show_dialogue([{"speaker": -1, "name": app.library.text(63), "face": [], "text": app.library.text(int(pair[2]))}], _medal_notices)
			return

## Announces medals awarded at this docking, one window each, as the
## original's New Medal popup does.
func _show_medals() -> void:
	if game.new_medals.is_empty():
		_medal_notices()
		return
	var entry: Array = game.new_medals.pop_front()
	var Medals := preload("res://src/simulation/medals.gd")
	var layer := CenterContainer.new()
	layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.35)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(shade)
	add_child(layer)
	var f := UI.Frame.new(app.library.text(Medals.POPUP_TITLE))
	f.custom_minimum_size = Vector2(460, 0)
	layer.add_child(f)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	f.add_child(box)
	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 12)
	var sheet: Texture2D = app.library.texture("medals")
	if sheet != null:
		head.add_child(UI.picture(sheet, 3.0, Rect2(int(entry[1]) * 31, 0, 31, 15)))
	var names := VBoxContainer.new()
	names.add_child(UI.label(Medals.name(app.library, int(entry[0])), 18))
	names.add_child(UI.label(["", "Gold", "Silver", "Bronze"][clampi(int(entry[1]), 0, 3)], 14, UI.TEXT_DIM))
	head.add_child(names)
	box.add_child(head)
	box.add_child(UI.paragraph(Medals.description(app.library, int(entry[0]), int(entry[1])), 15))
	var ok := UI.button(app.library.text(495), func():
		shade.queue_free()
		layer.queue_free()
		_show_medals())
	ok.alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(ok)
	ok.grab_focus.call_deferred()

func show_dialogue(lines: Array, done: Callable, chime := false) -> void:
	var d := DialoguePanel.new()
	d.app = app
	d.chime = chime
	d.lines = lines
	conversation = d
	d.finished.connect(func():
		d.queue_free()
		if conversation == d: conversation = null
		done.call()
		_queue_progress())
	add_child(d)

func depart(destination: Dictionary) -> void:
	var error: String = game.departure_error()
	if not error.is_empty():
		notify(error)
		return
	game.depart(destination)
	app.show_flight()

func _exit_tree() -> void:
	scene.queue_free()
