extends Control
## The Space Lounge as the original shows it: the station's bar in 3D with
## its guests standing about, all in view, each named with what they offer
## over their head. Clicking someone steps up to them for a conversation,
## with their face and words at the top and the answers at the bottom; a
## click beside it steps back.

const UI := preload("res://src/presentation/ui.gd")
const Common := preload("res://src/screens/station/common.gd")
const Portrait := preload("res://src/presentation/portrait.gd")
const Lounge := preload("res://src/simulation/lounge.gd")
const BarView := preload("res://src/presentation/bar_view.gd")

var station
var app
var game
## One see-through button over each guest's figure, carrying their name tag.
var list: Control
## The conversation: face and words above, answers below.
var detail: Control
var selected := -1
## The bar itself, in place of the hangar while the lounge is open.
var bar: Node3D
## The guest the keyboard or pad is on.
var shown := -1
var close_button: Button
## Catches clicks beside the conversation while it is open.
var outside: Control

func _ready() -> void:
	app = station.app
	game = station.game
	# The lounge fills the screen; the station's section list steps aside.
	set_meta("full_view", true)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	list = Control.new()
	list.mouse_filter = Control.MOUSE_FILTER_IGNORE
	list.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(list)
	# While talking, a click anywhere outside the conversation ends it.
	outside = Control.new()
	outside.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	outside.mouse_filter = Control.MOUSE_FILTER_STOP
	outside.visible = false
	outside.gui_input.connect(func(e: InputEvent):
		if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT: _end_chat()
		elif e is InputEventScreenTouch and e.pressed: _end_chat())
	add_child(outside)
	detail = Control.new()
	detail.mouse_filter = Control.MOUSE_FILTER_IGNORE
	detail.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	detail.offset_top = BAR + 12
	detail.offset_bottom = -12
	add_child(detail)
	# The original's window: the title strip over the bar, with a small
	# close button in its corner. Clicking a guest starts the conversation.
	var head := _strip(Control.PRESET_TOP_WIDE)
	var row := HBoxContainer.new()
	head.add_child(row)
	var title := UI.label(app.library.text(218), 20)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(title)
	close_button = _softkey("✕", _back)
	close_button.tooltip_text = app.library.text(65)
	row.add_child(close_button)
	app.play_music("gof2_bar")
	bar = BarView.new()
	bar.setup(app.library, game.session.station_id, int(game.system().faction), game.lounge())
	station.scene.add_child(bar)
	station.view.visible = false
	bar.camera.make_current()
	bar.look_at_all()
	_fill()

const BAR := 52

## A strip across the top or the foot of the screen.
func _strip(preset: int) -> PanelContainer:
	var strip := PanelContainer.new()
	var look := UI.panel_box(false)
	look.set_corner_radius_all(0)
	look.border_width_left = 0; look.border_width_right = 0
	if preset == Control.PRESET_TOP_WIDE: look.border_width_top = 0
	else: look.border_width_bottom = 0
	look.content_margin_top = 6; look.content_margin_bottom = 6
	look.content_margin_left = 20; look.content_margin_right = 20
	strip.add_theme_stylebox_override("panel", look)
	strip.set_anchors_and_offsets_preset(preset)
	if preset == Control.PRESET_TOP_WIDE: strip.offset_bottom = BAR
	else:
		strip.offset_top = -BAR
		strip.grow_vertical = Control.GROW_DIRECTION_BEGIN
	strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(strip)
	return strip

func _softkey(text: String, callback: Callable) -> Button:
	var b := UI.button(text, callback)
	b.flat = true
	b.add_theme_font_size_override("font_size", 20)
	b.alignment = HORIZONTAL_ALIGNMENT_CENTER
	b.custom_minimum_size = Vector2(BAR - 12, BAR - 12)
	b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	return b

func _exit_tree() -> void:
	app.play_music("gof2_hangar")
	if bar != null: bar.queue_free()
	if is_instance_valid(station.view):
		station.view.visible = true
		station.view.camera.make_current()

## Back ends the conversation first, then leaves the lounge.
func _back() -> void:
	if selected >= 0: _end_chat()
	else: station.close_panel()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and selected >= 0:
		_end_chat()
		get_viewport().set_input_as_handled()

func _end_chat() -> void:
	var i := selected
	selected = -1
	outside.visible = false
	bar.look_at_all()
	for c in detail.get_children(): c.queue_free()
	Common.refocus(list, maxi(i, 0))

## Marks guest `i` as the one the keyboard or pad is on. The camera keeps
## the whole room in view.
func _show_guest(i: int) -> void:
	if i < 0 or i >= game.lounge().size(): return
	shown = i

func _process(_delta: float) -> void:
	if bar == null or list == null: return
	for i in list.get_child_count():
		var b := list.get_child(i) as Button
		if b == null or b.is_queued_for_deletion(): continue
		var box: Rect2 = bar.screen_box(i)
		b.visible = box.size != Vector2.ZERO
		if not b.visible: continue
		b.position = box.position - list.global_position
		b.size = box.size
		# Every guest's name floats over them, lit while pointed at; while
		# talking, the conversation window names the speaker.
		var tag: Control = b.get_child(0)
		tag.visible = selected < 0
		tag.modulate = Color.WHITE if b.is_hovered() or b.has_focus() else Color(1, 1, 1, 0.75)
		tag.position = Vector2((box.size.x - tag.size.x) / 2.0, -tag.size.y)
	_unstack_tags()

## Lifts a name tag above any it would cover, so guests standing close
## together stay readable.
func _unstack_tags() -> void:
	var placed: Array = []
	for b in list.get_children():
		if not (b is Button and b.visible and b.get_child_count() > 0): continue
		var tag: Control = b.get_child(0)
		if not tag.visible: continue
		var at := Rect2(b.position + tag.position, tag.size)
		var moved := true
		while moved:
			moved = false
			for r in placed:
				if (r as Rect2).grow(-1).intersects(at):
					at.position.y = (r as Rect2).position.y - at.size.y
					moved = true
		tag.position = at.position - b.position
		placed.append(at)

func _fill() -> void:
	var keep_list := Common.focus_index(list)
	for c in list.get_children(): c.queue_free()
	Common.refocus(list, keep_list)
	var people: Array = game.lounge()
	var clear := StyleBoxEmpty.new()
	for i in people.size():
		var p: Dictionary = people[i]
		var b := Button.new()
		b.focus_mode = Control.FOCUS_ALL
		for state in ["normal", "hover", "pressed", "focus", "disabled", "hover_pressed"]: b.add_theme_stylebox_override(state, clear)
		b.pressed.connect(_talk.bind(i))
		b.focus_entered.connect(_preview.bind(i))
		var tag := VBoxContainer.new()
		tag.mouse_filter = Control.MOUSE_FILTER_IGNORE
		tag.add_theme_constant_override("separation", 0)
		tag.visible = false
		var name_line := _floating(str(p.name), 20, station.ORANGE)
		tag.add_child(name_line)
		var offer: String = game.bar.offer_label(p)
		if not offer.is_empty(): tag.add_child(_floating(offer, 17, UI.TEXT))
		b.add_child(tag)
		list.add_child(b)
	if people.is_empty():
		var none := UI.label("Nobody is here right now.", 18, UI.TEXT_DIM)
		none.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
		list.add_child(none)
	if selected >= 0: _talk(selected)

func _floating(text: String, size: int, color: Color) -> Label:
	var l := UI.label(text, size, color)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.add_theme_constant_override("outline_size", 5)
	l.add_theme_color_override("font_outline_color", Color.BLACK)
	return l

## Moving the keyboard or pad focus over someone marks them; it is not a
## conversation.
func _preview(i: int) -> void:
	if selected < 0: _show_guest(i)

func _talk(i: int) -> void:
	var people: Array = game.lounge()
	if i < 0 or i >= people.size(): return
	selected = i
	_show_guest(i)
	bar.look_at_guest(i)
	outside.visible = true
	for c in detail.get_children(): c.queue_free()
	var p: Dictionary = people[i]
	# The original's conversation: the face and words in a window at the top,
	# the answers in one at the bottom.
	# Both windows keep to the middle of the screen, over the bar.
	var room := detail.size.x if detail.size.x > 0 else get_viewport_rect().size.x
	var top := UI.Frame.new("", false)
	top.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	top.custom_minimum_size.x = minf(720.0, room - 32.0)
	top.grow_horizontal = Control.GROW_DIRECTION_BOTH
	top.offset_left = -top.custom_minimum_size.x / 2.0
	top.offset_right = top.custom_minimum_size.x / 2.0
	detail.add_child(top)
	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 12)
	top.add_child(head)
	head.add_child(Portrait.make(app.library, -1, p.get("face", []), 2.0))
	var words := VBoxContainer.new()
	words.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(words)
	words.add_child(UI.label(str(p.name), 18, station.ORANGE))
	var text := UI.paragraph(str(p.get("speech", "")), 15)
	text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	words.add_child(text)
	var reply := UI.paragraph("", 15, UI.TEXT_GOOD)
	reply.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	words.add_child(reply)
	var kind := int(p.kind)
	var has_offer: bool = kind != Lounge.Kind.TALK and (kind != Lounge.Kind.JOB or p.has("job")) and (kind != Lounge.Kind.BUYER or p.has("job"))
	if not bool(p.get("talked", false)):
		p["talked"] = true
		if has_offer: game.session.add_stat("bar_talks")
	if game.session.flags.has("discover_system"):
		# Bought coordinates: after the thanks, SpaceLounge opens the map
		# on the newly revealed system (StarMap's discovery scene).
		var ok := UI.button(app.library.text(253), _show_discovery)
		ok.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		words.add_child(ok)
		ok.grab_focus.call_deferred()
		return
	if not has_offer: return
	var lib = app.library
	var bottom := UI.Frame.new("", false)
	bottom.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
	bottom.custom_minimum_size.x = minf(460.0, room - 32.0)
	bottom.grow_vertical = Control.GROW_DIRECTION_BEGIN
	bottom.grow_horizontal = Control.GROW_DIRECTION_BOTH
	bottom.offset_left = -bottom.custom_minimum_size.x / 2.0
	bottom.offset_right = bottom.custom_minimum_size.x / 2.0
	detail.add_child(bottom)
	var answers := VBoxContainer.new()
	answers.add_theme_constant_override("separation", 4)
	bottom.add_child(answers)
	# The original's answers: OK, No thanks, How was that again?, then
	# questions about a job elsewhere or a look at the goods on offer.
	answers.add_child(UI.button(lib.text(495), func(): _confirm(i, answers)))
	answers.add_child(UI.button(lib.text(496), func():
		game.session.add_stat("rejected")
		bottom.queue_free()
		text.text = lib.text(479 + randi() % 4)
		# The answers are gone: the highlight returns to the guest.
		Common.refocus(list, i)))
	answers.add_child(UI.button(lib.text(497), func():
		game.session.add_stat("asked_repeat")
		# The words again, in place: the window does not grow a copy.
		text.text = str(p.get("speech", ""))
		reply.text = ""))
	var job: Dictionary = p.get("job", {})
	if kind == Lounge.Kind.JOB and not job.is_empty() and int(job.get("station", -1)) != game.session.station_id:
		answers.add_child(UI.button(lib.text(440), func():
			p["asked_location"] = true
			var target := int(job.station)
			reply.text = "%s — %s" % [app.catalogue.station_name(target), app.catalogue.system_name(app.catalogue.system_of_station(target))]))
		answers.add_child(UI.button(lib.text(442), func():
			p["asked_difficulty"] = true
			reply.text = lib.text(443 + clampi(int(float(job.get("difficulty", 0)) / 10.0 * 5.0), 0, 4))))
	elif kind == Lounge.Kind.JOB and not job.is_empty():
		answers.add_child(UI.button(lib.text(440), func(): reply.text = lib.text(441)))
	if kind in [Lounge.Kind.SELLER, Lounge.Kind.BLUEPRINT_AGENT]:
		var goods := int(p.get("blueprint", p.get("item", -1)))
		if goods >= 0:
			answers.add_child(UI.button(lib.text(415), func():
				var cat = app.catalogue
				var lines: Array = ["%s · %s %d" % [cat.item_name(goods), lib.text(37), cat.tech(goods)]]
				for f in Common.item_facts(lib, cat, goods): lines.append("%s: %s" % [f[0], f[1]])
				reply.text = "\n".join(lines)))
	Common.refocus(answers, 0)

func _show_discovery() -> void:
	var system := int(game.session.flags.get("discover_system", -1))
	game.session.flags.erase("discover_system")
	station._open_section(2)
	var map = station.current_panel
	if map != null and map.has_method("start_discovery"): map.start_discovery(system)

## The original's popup after OK: the deal asked once more ("Accept this
## mission?", "Buy 8x Microchips for 192$?"), with Yes and No.
func _confirm(i: int, answers: VBoxContainer) -> void:
	var p: Dictionary = game.lounge()[i]
	var lib = app.library
	for c in answers.get_children(): c.queue_free()
	answers.add_child(UI.paragraph(_question(p), 15, UI.TEXT))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	answers.add_child(row)
	var yes := UI.button(lib.text(38), func():
		var err: String = game.accept_job(i)
		if not err.is_empty(): station.notify(err)
		station._refresh()
		_fill()
		if err.is_empty() and game.session.flags.has("discover_system"): _talk(i))
	var no := UI.button(lib.text(39), func(): _talk(i))
	for b in [yes, no]:
		b.alignment = HORIZONTAL_ALIGNMENT_CENTER
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(b)
	yes.grab_focus.call_deferred()

func _question(p: Dictionary) -> String:
	var lib = app.library
	var cat = app.catalogue
	var price := UI.money(int(p.get("price", 0)))
	match int(p.kind):
		Lounge.Kind.JOB, Lounge.Kind.BUYER:
			var job: Dictionary = p.get("job", {})
			if job.is_empty(): return lib.text(498)
			return lib.text(499).replace("#M", lib.text(179 + int(job.kind))).replace("#C", UI.money(int(job.get("reward", 0))))
		Lounge.Kind.SELLER:
			return lib.text(502).replace("#Q", str(int(p.get("count", 1)))).replace("#P", cat.item_name(int(p.get("item", -1)))).replace("#C", price)
		Lounge.Kind.BLUEPRINT_AGENT:
			return lib.text(503).replace("#P", cat.item_name(int(p.get("blueprint", -1)))).replace("#C", price)
		Lounge.Kind.COORDINATES_AGENT:
			return lib.text(504).replace("#S", cat.system_name(int(p.get("system", -1)))).replace("#C", price)
		Lounge.Kind.WINGMEN:
			if bool(game.session.flags.get("all_medals", false)): return lib.text(501).replace("#C", price)
			return lib.text(500).replace("#Q", str(p.get("pilots", []).size())).replace("#C", price)
	return lib.text(498)
