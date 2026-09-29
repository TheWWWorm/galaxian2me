extends BoxContainer
## The ship dealer: hulls on offer at this station, their figures, and the
## purchase (the current hull is traded in; its equipment goes to the hold).

const UI := preload("res://src/presentation/ui.gd")
const Common := preload("res://src/screens/station/common.gd")
const ShipPreview := preload("res://src/presentation/ship_preview.gd")

var station
var app
var game
var list: VBoxContainer
var detail: VBoxContainer
var selected := {}
var preview: ShipPreview

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
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 8)
	info.add_child(column)
	# The hull on offer, turning in its own showroom (drag to turn it).
	preview = ShipPreview.new()
	preview.library = app.library
	column.add_child(preview)
	detail = VBoxContainer.new()
	column.add_child(detail)
	game.changed.connect(_fill)
	_fill()

func _fill() -> void:
	if not is_inside_tree(): return
	var keep_list := Common.focus_index(list)
	for c in list.get_children(): c.queue_free()
	Common.refocus(list, keep_list)
	for offer in game.dealer():
		list.add_child(Common.row(Common.ship_icon(app.library, int(offer.index)), app.catalogue.ship_name(int(offer.index)), UI.money(int(offer.price)), _select.bind(offer)))
	_detail()

func _select(offer: Dictionary) -> void:
	selected = offer
	_detail()

func _detail() -> void:
	var keep_detail := Common.focus_index(detail)
	for c in detail.get_children(): c.queue_free()
	Common.refocus(detail, keep_detail)
	var cat = app.catalogue
	if selected.is_empty() or not game.dealer().has(selected):
		# Nothing chosen: the ship you fly, to compare the offers against.
		var own := int(game.session.ship.index)
		if preview.ship_index != own: preview.show_ship(own, int(game.session.ship.faction))
		detail.add_child(UI.label(cat.ship_name(own), 18))
		_facts(cat.ship(own))
		detail.add_child(UI.label("%s %s" % [cat.ship_name(own), UI.money(game.ship_value())], 14, UI.TEXT_DIM))
		return
	var s: Dictionary = cat.ship(int(selected.index))
	if preview.ship_index != int(selected.index): preview.show_ship(int(selected.index), int(selected.get("faction", 0)))
	detail.add_child(UI.label(cat.ship_name(int(selected.index)), 18))
	_facts(s, cat.ship(int(game.session.ship.index)))
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

## The hull's figures; with `against` (the ship you fly) each one also shows
## how far the offer is ahead of it or behind.
func _facts(s: Dictionary, against := {}) -> void:
	# Imported numbers arrive as floats; the counts are whole.
	for f in [[60, "armor", "%d"], [61, "cargo", "%d t"], [59, "handling", "%.2f"],
			[123, "primary", "%d"], [124, "secondary", "%d"], [125, "turret", "%d"], [127, "equipment", "%d"]]:
		var value := _figure(s, f[1])
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 8)
		row.add_child(UI.label("%s: %s" % [app.library.text(f[0]), f[2] % value], 14))
		if not against.is_empty():
			var diff := value - _figure(against, f[1])
			if absf(diff) > 0.001:
				var text: String = ("+" if diff > 0 else "−") + (f[2] % absf(diff))
				row.add_child(UI.label(text, 14, UI.TEXT_GOOD if diff > 0 else UI.TEXT_WARN))
		detail.add_child(row)

func _figure(s: Dictionary, key: String) -> float:
	var v := float(s.get(key, 0))
	return v / 100.0 if key == "handling" else floorf(v)
