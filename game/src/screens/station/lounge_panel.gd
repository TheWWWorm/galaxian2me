extends HBoxContainer
## The Space Lounge: the people in this station's bar with their portraits;
## talking to one shows what they say and offer, and the offer can be taken.

const UI := preload("res://src/presentation/ui.gd")
const Common := preload("res://src/screens/station/common.gd")
const Portrait := preload("res://src/presentation/portrait.gd")
const Lounge := preload("res://src/simulation/lounge.gd")

var station
var app
var game
var list: VBoxContainer
var detail: VBoxContainer
var selected := -1

func _ready() -> void:
	app = station.app
	game = station.game
	add_theme_constant_override("separation", 10)
	var left := UI.Frame.new(app.library.text(218))
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(left)
	var l := Common.scroll_list()
	left.add_child(l[0])
	list = l[1]
	var info := UI.Frame.new(app.library.text(212))
	info.custom_minimum_size.x = 420
	add_child(info)
	var s := Common.scroll_list()
	info.add_child(s[0])
	detail = s[1]
	app.play_music("gof2_bar")
	_fill()

func _exit_tree() -> void:
	app.play_music("gof2_hangar")

func _fill() -> void:
	for c in list.get_children(): c.queue_free()
	var people: Array = game.lounge()
	for i in people.size():
		var p: Dictionary = people[i]
		var face := Portrait.make(app.library, -1, p.get("face", []), 0.75)
		list.add_child(Common.row(face, "%s — %s" % [p.name, app.catalogue.faction_name(int(p.race))], game.bar.offer_label(p), _talk.bind(i)))
	if selected >= 0: _talk(selected)

func _talk(i: int) -> void:
	selected = i
	for c in detail.get_children(): c.queue_free()
	var people: Array = game.lounge()
	if i >= people.size(): return
	var p: Dictionary = people[i]
	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 12)
	head.add_child(Portrait.make(app.library, -1, p.get("face", []), 2.0))
	var names := VBoxContainer.new()
	names.add_child(UI.label(str(p.name), 18))
	names.add_child(UI.label(app.catalogue.faction_name(int(p.race)), 14, UI.TEXT_DIM))
	head.add_child(names)
	detail.add_child(head)
	var text := UI.paragraph(str(p.get("speech", "")), 15)
	text.custom_minimum_size.x = 380
	detail.add_child(text)
	var kind := int(p.kind)
	var has_offer: bool = kind != Lounge.Kind.TALK and (kind != Lounge.Kind.JOB or p.has("job")) and (kind != Lounge.Kind.BUYER or p.has("job"))
	if has_offer:
		var row := HBoxContainer.new()
		detail.add_child(row)
		var yes := UI.button(app.library.text(38), func():
			var err: String = game.accept_job(i)
			if not err.is_empty(): station.notify(err)
			station._refresh()
			_fill())
		row.add_child(yes)
		row.add_child(UI.button(app.library.text(39), func():
			game.session.add_stat("rejected")
			for c in detail.get_children(): c.queue_free()))
