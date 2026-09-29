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
const SECTIONS := [[62, 5], [218, 13], [72, 9], [33, 13], [64, 0], [66, 0]]

var app
var game
var scene := Node3D.new()
var view: HangarView
var env := WorldEnvironment.new()
var header: Label
var credits_label: Label
var menu: VBoxContainer
var rail: Control
var home: VBoxContainer
var launch_button: Button
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
	header = UI.label("", 22)
	names.add_child(header)
	credits_label = UI.label("", 16, UI.TEXT_GOOD)
	names.add_child(credits_label)
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
	# The docked home: the six sections as tiles along the foot of the view,
	# the hangar and ship left in sight above them.
	home = VBoxContainer.new()
	home.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	home.offset_left = 12; home.offset_right = -12; home.offset_bottom = -54
	home.grow_vertical = Control.GROW_DIRECTION_BEGIN
	home.alignment = BoxContainer.ALIGNMENT_END
	add_child(home)
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
	# Departure cannot live exclusively in the Map section: that section
	# unlocks after the opening mining flights have already been completed.
	menu.add_child(HSeparator.new())
	launch_button = UI.button(app.library.text(239), depart.bind({}))
	menu.add_child(launch_button)
	_build_home()
	rail.visible = current_panel != null
	home.visible = current_panel == null
	if current_panel != null: (menu.get_child(0) as Control).grab_focus.call_deferred()

## The home tiles: each section with its picture and what is waiting there.
func _build_home() -> void:
	for c in home.get_children(): c.queue_free()
	var flow := HFlowContainer.new()
	flow.alignment = FlowContainer.ALIGNMENT_CENTER
	flow.add_theme_constant_override("h_separation", 10)
	flow.add_theme_constant_override("v_separation", 10)
	home.add_child(flow)
	var step: int = game.session.story_step
	var first: Control = null
	for i in SECTIONS.size():
		var open: bool = step >= int(SECTIONS[i][1])
		var tile := _tile(app.library.text(SECTIONS[i][0]), _tile_picture(i) if open else UI.picture(app.library.texture("lock"), 3.0),
			_tile_summary(i) if open else "—", _open_section.bind(i), open)
		flow.add_child(tile)
		if first == null and open: first = tile
	var arrow := UI.picture(app.library.texture("arrow"), 3.0)
	arrow.flip_h = true
	var go := _tile(app.library.text(239), arrow, game.station().get("name", ""), depart.bind({}), true)
	go.add_theme_stylebox_override("normal", UI._box(UI.GREEN_DARK, UI.GREEN))
	go.add_theme_stylebox_override("hover", UI._box(UI.GREEN_DARK.lightened(0.15), UI.TEXT_GOOD))
	flow.add_child(go)
	if first != null: first.grab_focus.call_deferred()

func _tile(title: String, picture: Control, summary: String, action: Callable, open: bool) -> Button:
	var b := Button.new()
	b.focus_mode = Control.FOCUS_ALL
	b.custom_minimum_size = Vector2(158, 132)
	b.pressed.connect(action)
	if not open: b.modulate = Color(0.65, 0.65, 0.65)
	var v := VBoxContainer.new()
	v.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	v.offset_left = 8; v.offset_right = -8; v.offset_top = 8; v.offset_bottom = -8
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_child(v)
	var frame := CenterContainer.new()
	frame.custom_minimum_size.y = 58
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_child(picture)
	v.add_child(frame)
	var t := UI.label(title, 16)
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(t)
	var sub := UI.label(summary, 12, UI.TEXT_DIM)
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	sub.custom_minimum_size.x = 140
	v.add_child(sub)
	return b

func _tile_picture(index: int) -> Control:
	var lib = app.library
	match index:
		0: return Common.ship_icon(lib, int(game.session.ship.index))
		1:
			var people: Array = game.lounge()
			if not people.is_empty(): return Portrait.make(lib, -1, people[0].get("face", []), 1.0)
		2: return UI.picture(lib.texture("planet_%d" % int(game.station().get("planet", 0))), 0.5)
		3: return UI.picture(lib.texture("menu_map_mainmission"), 3.0)
		4: return UI.picture(lib.texture("medals"), 3.0, Rect2(31, 0, 31, 15))
		5: return UI.picture(lib.texture("logos_small"), 3.0, Rect2(15 * int(game.system().faction), 0, 15, 15))
	return Control.new()

func _tile_summary(index: int) -> String:
	var lib = app.library
	match index:
		0:
			var parts: Array = [lib.text(79), lib.text(77)]
			if not game.dealer().is_empty(): parts.append(lib.text(68))
			return " · ".join(parts)
		1: return "%d %s" % [game.lounge().size(), "guest" if game.lounge().size() == 1 else "guests"]
		2: return app.catalogue.system_name(game.session.system_index)
		3:
			var m: Dictionary = game.session.story_mission
			if not m.is_empty() and int(m.get("station", -1)) >= 0:
				return "→ " + app.catalogue.station_name(int(m.station))
			var j: Dictionary = game.session.job
			if not j.is_empty() and int(j.get("station", -1)) >= 0: return "→ " + app.catalogue.station_name(int(j.station))
			return ""
		4: return "Medals %d/%d" % [preload("res://src/simulation/medals.gd").held_count(game.session, lib), preload("res://src/simulation/medals.gd").table(lib).size()]
		5: return "%s · %s" % [lib.text(2), lib.text(3)]
	return ""

func _refresh() -> void:
	var st: Dictionary = game.station()
	header.text = "%s  ·  %s  ·  %s %d" % [st.get("name", "?"), app.catalogue.system_name(game.session.system_index), app.library.text(37), int(st.get("tech", 0))]
	credits_label.text = "%s: %s" % [app.library.text(80), UI.money(game.session.credits)]

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
	rail.visible = true
	home.visible = false

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
			_show_medals())
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
	app.play_sound("fx_message_03")
	ok.grab_focus.call_deferred()

func show_dialogue(lines: Array, done: Callable) -> void:
	var d := DialoguePanel.new()
	d.app = app
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
