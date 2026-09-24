extends HBoxContainer
## The Space Lounge: the people sitting in this station's bar. Story agents
## and generated clients come from the lounge rules in the simulation.

const UI := preload("res://src/presentation/ui.gd")
const Common := preload("res://src/screens/station/common.gd")
const Catalogue := preload("res://src/content/catalogue.gd")

var station
var app
var game
var list: VBoxContainer
var detail: VBoxContainer

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
	info.custom_minimum_size.x = 380
	add_child(info)
	var s := Common.scroll_list()
	info.add_child(s[0])
	detail = s[1]
	_fill()

func _fill() -> void:
	for c in list.get_children(): c.queue_free()
	for i in game.lounge().size():
		var person: Dictionary = game.lounge()[i]
		var what := ""
		if person.has("job"): what = app.library.text(Catalogue.STRING_MISSION_TYPES + int(person.job.kind))
		list.add_child(Common.row(TextureRect.new(), "%s — %s" % [person.name, app.catalogue.faction_name(int(person.race))], what, _talk.bind(i)))

func _talk(i: int) -> void:
	for c in detail.get_children(): c.queue_free()
	var person: Dictionary = game.lounge()[i]
	detail.add_child(UI.label(str(person.name), 18))
	detail.add_child(UI.paragraph(str(person.get("speech", "")), 15))
	if person.has("job"):
		var accept := UI.button(app.library.text(35), func():
			var err: String = game.accept_job(i)
			station.notify(err)
			_fill()
			for c in detail.get_children(): c.queue_free())
		detail.add_child(accept)
