extends HBoxContainer
## The ship dealer: hulls on offer at this station, their figures, and the
## purchase (the current hull is traded in; its equipment goes to the hold).

const UI := preload("res://src/presentation/ui.gd")
const Common := preload("res://src/screens/station/common.gd")

var station
var app
var game
var list: VBoxContainer
var detail: VBoxContainer
var selected := {}

func _ready() -> void:
	app = station.app
	game = station.game
	add_theme_constant_override("separation", 10)
	var left := UI.Frame.new(app.library.text(68))
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(left)
	var l := Common.scroll_list()
	left.add_child(l[0])
	list = l[1]
	var info := UI.Frame.new(app.library.text(212))
	info.custom_minimum_size.x = 340
	add_child(info)
	detail = VBoxContainer.new()
	info.add_child(detail)
	game.changed.connect(_fill)
	_fill()

func _fill() -> void:
	if not is_inside_tree(): return
	for c in list.get_children(): c.queue_free()
	for offer in game.dealer():
		list.add_child(Common.row(Common.ship_icon(app.library, int(offer.index)), app.catalogue.ship_name(int(offer.index)), UI.money(int(offer.price)), _select.bind(offer)))
	_detail()

func _select(offer: Dictionary) -> void:
	selected = offer
	_detail()

func _detail() -> void:
	for c in detail.get_children(): c.queue_free()
	if selected.is_empty() or not game.dealer().has(selected): return
	var cat = app.catalogue
	var s: Dictionary = cat.ship(int(selected.index))
	detail.add_child(UI.label(cat.ship_name(int(selected.index)), 18))
	for f in [[60, str(s.armor)], [61, "%d t" % int(s.cargo)], [59, "%.2f" % (float(s.handling) / 100.0)],
			[123, str(s.primary)], [124, str(s.secondary)], [125, str(s.turret)], [127, str(s.equipment)]]:
		detail.add_child(UI.label("%s: %s" % [app.library.text(f[0]), f[1]], 14))
	detail.add_child(UI.label("%s: %s" % [app.library.text(36), UI.money(int(selected.price))], 16, UI.TEXT_GOOD))
	detail.add_child(UI.label("%s %s" % [app.catalogue.ship_name(int(game.session.ship.index)), UI.money(game.ship_value())], 14, UI.TEXT_DIM))
	var buy := UI.button(app.library.text(144), func():
		var error: String = game.buy_ship(selected)
		if error.is_empty():
			station.notify(app.library.format(143, {"#N": app.catalogue.ship_name(int(game.session.ship.index))}))
			station.refresh_ship_model()
			selected = {}
		else:
			station.notify(error))
	detail.add_child(buy)
