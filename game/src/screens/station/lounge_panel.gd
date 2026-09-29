extends Control
## The Space Lounge as the original shows it: the station's bar in 3D with
## its guests standing about. Pointing at someone names them and what they
## offer over their head; clicking them (or Chat) starts a conversation, with
## their face and words at the top and the answers at the bottom.

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
## The guest the camera is on.
var shown := -1
var chat_button: Button

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
	detail = Control.new()
	detail.mouse_filter = Control.MOUSE_FILTER_IGNORE
	detail.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	detail.offset_bottom = -50
	add_child(detail)
	var footer := HBoxContainer.new()
	footer.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	footer.offset_top = -44
	add_child(footer)
	# The original's softkeys: Chat and Back.
	chat_button = _softkey(app.library.text(494), func(): _talk(shown))
	footer.add_child(chat_button)
	var gap := Control.new()
	gap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	footer.add_child(gap)
	footer.add_child(_softkey(app.library.text(65), _back))
	app.play_music("gof2_bar")
	bar = BarView.new()
	bar.setup(app.library, game.session.station_id, int(game.system().faction), game.lounge())
	station.scene.add_child(bar)
	station.view.visible = false
	bar.camera.make_current()
	_fill()
	if not game.lounge().is_empty(): _show_guest(0)

func _softkey(text: String, callback: Callable) -> Button:
	var b := UI.button(text, callback)
	b.flat = true
	b.add_theme_font_size_override("font_size", 20)
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
	for c in detail.get_children(): c.queue_free()
	Common.refocus(list, maxi(i, 0))

## Turns the camera to guest `i`.
func _show_guest(i: int) -> void:
	if i < 0 or i >= game.lounge().size(): return
	shown = i
	bar.look_at_guest(i)

func _process(_delta: float) -> void:
	if bar == null or list == null: return
	chat_button.visible = selected < 0 and shown >= 0
	for i in list.get_child_count():
		var b := list.get_child(i) as Button
		if b == null or b.is_queued_for_deletion(): continue
		var box: Rect2 = bar.screen_box(i)
		b.visible = box.size != Vector2.ZERO
		if not b.visible: continue
		b.position = box.position - list.global_position
		b.size = box.size
		# The name floats over whoever is pointed at, highlighted or talked to.
		var tag: Control = b.get_child(0)
		tag.visible = b.is_hovered() or b.has_focus() or i == selected or (i == shown and selected < 0 and not _any_pointed())
		tag.position = Vector2((box.size.x - tag.size.x) / 2.0, -tag.size.y)

func _any_pointed() -> bool:
	for b in list.get_children():
		if b is Button and ((b as Button).is_hovered() or (b as Button).has_focus()): return true
	return false

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

## Moving the keyboard or pad focus over someone turns to them; it is not a
## conversation.
func _preview(i: int) -> void:
	if selected < 0: _show_guest(i)

func _talk(i: int) -> void:
	var people: Array = game.lounge()
	if i < 0 or i >= people.size(): return
	selected = i
	_show_guest(i)
	for c in detail.get_children(): c.queue_free()
	var p: Dictionary = people[i]
	# The original's conversation: the face and words in a window at the top,
	# the answers in one at the bottom.
	var top := UI.Frame.new("")
	top.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
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
	if not has_offer: return
	var lib = app.library
	var bottom := UI.Frame.new("")
	bottom.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	bottom.grow_vertical = Control.GROW_DIRECTION_BEGIN
	detail.add_child(bottom)
	var answers := VBoxContainer.new()
	answers.add_theme_constant_override("separation", 4)
	bottom.add_child(answers)
	# The original's answers: OK, No thanks, How was that again?, then
	# questions about a job elsewhere or a look at the goods on offer.
	answers.add_child(UI.button(lib.text(495), func():
		var err: String = game.accept_job(i)
		if not err.is_empty(): station.notify(err)
		station._refresh()
		_fill()))
	answers.add_child(UI.button(lib.text(496), func():
		game.session.add_stat("rejected")
		bottom.queue_free()
		text.text = lib.text(479 + randi() % 4)
		# The answers are gone: the highlight returns to the guest.
		Common.refocus(list, i)))
	answers.add_child(UI.button(lib.text(497), func():
		game.session.add_stat("asked_repeat")
		reply.text = str(p.get("speech", ""))))
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
	if kind in [Lounge.Kind.SELLER, Lounge.Kind.ITEM_AGENT, Lounge.Kind.BLUEPRINT_AGENT]:
		var goods := int(p.get("blueprint", p.get("item", -1)))
		if goods >= 0:
			answers.add_child(UI.button(lib.text(415), func():
				var cat = app.catalogue
				var lines: Array = ["%s · %s %d" % [cat.item_name(goods), lib.text(37), cat.tech(goods)]]
				for f in Common.item_facts(lib, cat, goods): lines.append("%s: %s" % [f[0], f[1]])
				reply.text = "\n".join(lines)))
	Common.refocus(answers, 0)
