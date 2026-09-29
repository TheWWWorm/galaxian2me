extends BoxContainer
## The shop: the station's shelf on the left, the player's hold on the right,
## and the selected item's details with buy/sell controls.

const UI := preload("res://src/presentation/ui.gd")
const Common := preload("res://src/screens/station/common.gd")

var station
var app
var game
var shelf_list: VBoxContainer
var hold_list: VBoxContainer
var detail: VBoxContainer
var selected := -1
var selected_side := 0
var amount := 1

func _ready() -> void:
	app = station.app
	game = station.game
	add_theme_constant_override("separation", 10)
	var left := UI.Frame.new(app.library.text(40))
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(left)
	var l := Common.scroll_list()
	left.add_child(l[0])
	shelf_list = l[1]
	var right := UI.Frame.new(app.library.text(61))
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(right)
	var r := Common.scroll_list()
	right.add_child(r[0])
	hold_list = r[1]
	var info := UI.Frame.new(app.library.text(212))
	info.custom_minimum_size.x = 300
	add_child(info)
	detail = VBoxContainer.new()
	detail.add_theme_constant_override("separation", 6)
	info.add_child(detail)
	# The original notes the lowest and highest prices seen as the hangar opens.
	var here: int = game.session.system_index
	for e in game.shelf(): game.session.record_price(int(e.id), int(e.price), here)
	for k in game.session.cargo.keys(): game.session.record_price(int(k), game.price_here(int(k)), here)
	game.changed.connect(_fill)
	_fill()

func _fill() -> void:
	if not is_inside_tree(): return
	# Focus in the detail pane is kept by _detail; in the lists, here.
	var keep := Common.focus_index(self) if Common.focus_index(detail) < 0 else -1
	for c in shelf_list.get_children(): c.queue_free()
	for c in hold_list.get_children(): c.queue_free()
	var cat = app.catalogue
	for e in game.shelf():
		if int(e.count) <= 0: continue
		var id := int(e.id)
		shelf_list.add_child(Common.row(Common.item_icon(app.library, id), "%s  ×%d" % [cat.item_name(id), int(e.count)], UI.money(int(e.price)), _select.bind(id, 0)))
	var keys: Array = game.session.cargo.keys()
	keys.sort_custom(func(a, b): return int(a) < int(b))
	for k in keys:
		var id := int(k)
		hold_list.add_child(Common.row(Common.item_icon(app.library, id), "%s  ×%d" % [cat.item_name(id), game.session.cargo_count(id)], UI.money(game.price_here(id)), _select.bind(id, 1)))
	var used: int = game.session.cargo_used()
	var cap: int = int(game.session.ship_stats().cargo_capacity)
	hold_list.add_child(UI.label("%s: %d / %d t" % [app.library.text(61), used, cap], 14, UI.TEXT_DIM))
	_detail()
	Common.refocus(self, keep)

func _select(id: int, side: int) -> void:
	selected = id
	selected_side = side
	amount = 1
	_detail()

func _detail() -> void:
	var keep := Common.focus_index(detail)
	for c in detail.get_children(): c.queue_free()
	Common.refocus(detail, keep)
	if selected < 0:
		# The original's help here names phone keys; this says what to do here.
		detail.add_child(UI.paragraph("Pick an item on the station's shelf to buy it, or one in your cargo hold to sell it.\n\nEquipment you buy goes into the hold; fit it to your ship on the Ship tab.", 14, UI.TEXT_DIM))
		return
	var cat = app.catalogue
	var id := selected
	detail.add_child(Common.item_icon(app.library, id))
	detail.add_child(UI.label(cat.item_name(id), 18))
	detail.add_child(UI.label("%s · %s %d" % [cat.type_name(cat.type(id)), app.library.text(37), cat.tech(id)], 14, UI.TEXT_DIM))
	# Set against what is fitted in its place, the way the dealer sets hulls.
	var fitted := Common.fitted_counterpart(game.session, cat, id) if selected_side == 0 else -1
	if fitted >= 0:
		detail.add_child(UI.label("Compared with your %s" % cat.item_name(fitted), 13, UI.TEXT_DIM))
	for r in Common.fact_rows(app.library, cat, id, fitted): detail.add_child(r)
	var price: int = game.price_here(id)
	detail.add_child(UI.label("%s: %s" % [app.library.text(36), UI.money(price)], 16, UI.TEXT_GOOD))
	var rec: Array = game.session.price_record(id)
	if rec.size() == 4:
		for side in [[0, 93, 95], [2, 94, 96]]:
			var system := int(rec[side[0] + 1])
			var line: String = app.library.text(side[2] if system == game.session.system_index else side[1])
			line = line.replace("#C", str(int(rec[side[0]]))).replace("#S", str(cat.system(system).get("name", "?")))
			detail.add_child(UI.paragraph(line, 13, UI.TEXT_DIM))
	var available: int = _available()
	if available <= 0: return
	amount = clampi(amount, 1, available)
	var row := HBoxContainer.new()
	detail.add_child(row)
	row.add_child(UI.button("−", func(): amount = maxi(1, amount - 1); _detail()))
	var n := UI.label("%d" % amount, 16)
	n.custom_minimum_size.x = 40
	n.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	row.add_child(n)
	row.add_child(UI.button("+", func(): amount = mini(available, amount + 1); _detail()))
	row.add_child(UI.button("Max", func(): amount = available; _detail()))
	var action := UI.button(("Buy" if selected_side == 0 else app.library.text(137)) + "  (" + UI.money(price * amount) + ")", _trade)
	action.disabled = selected_side == 1 and not game.can_sell_cargo(id)
	detail.add_child(action)

func _available() -> int:
	if selected_side == 1: return game.session.cargo_count(selected)
	for e in game.shelf():
		if int(e.id) == selected:
			var n := int(e.count)
			var price := int(e.price)
			if price > 0: n = mini(n, int(game.session.credits / price))
			return mini(n, game.session.cargo_free())
	return 0

func _trade() -> void:
	var message: String
	if selected_side == 0:
		message = game.buy(selected, amount)
		# The first equipment bought: the original's note that it must be mounted.
		if message.is_empty() and app.catalogue.category(selected) != app.catalogue.Category.COMMODITY:
			station._tip("mounting")
	else:
		message = game.sell(selected, amount)
		if message.is_empty(): station.notify(app.library.format(86, {"#N": app.catalogue.item_name(selected)}))
	station.notify(message)
	if selected_side == 1 and game.session.cargo_count(selected) <= 0:
		# Sold out: the highlight goes back to the hold's first row.
		var had_focus := Common.focus_index(detail) >= 0
		selected = -1
		_detail()
		if had_focus: Common.refocus(hold_list, 0)
