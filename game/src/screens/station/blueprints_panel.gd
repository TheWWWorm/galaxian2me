extends BoxContainer
## Owned recipes, deposited materials and products waiting at their origin.
## Buttons quote a real cargo contribution; confirmations never pre-spend it.
const UI := preload("res://src/presentation/ui.gd")
const Tips := preload("res://src/presentation/tips.gd")
const Common := preload("res://src/screens/station/common.gd")
var station
var app
var game
var list: VBoxContainer
var detail: VBoxContainer
var ingredients: VBoxContainer
var actions: VBoxContainer
var confirmation: ConfirmationDialog
var pending_order := {}
var selected := -1
var selected_item := -1
var amount := 1

func _ready() -> void:
	app = station.app
	game = station.game
	add_theme_constant_override("separation", 10)
	var left := UI.Frame.new(app.library.text(131))
	left.custom_minimum_size.x = 265
	add_child(left)
	var rows := Common.scroll_list()
	left.add_child(rows[0])
	list = rows[1]
	var right := UI.Frame.new(app.library.text(129))
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(right)
	var info := Common.scroll_list()
	right.add_child(info[0])
	detail = info[1]
	confirmation = ConfirmationDialog.new()
	confirmation.title = app.library.text(129)
	confirmation.ok_button_text = app.library.text(38)
	confirmation.cancel_button_text = app.library.text(39)
	confirmation.min_size = Vector2i(560, 180)
	confirmation.dialog_autowrap = true
	add_child(confirmation)
	confirmation.confirmed.connect(_confirmed)
	confirmation.canceled.connect(func(): pending_order = {})
	game.changed.connect(_fill)
	_fill()

func _fill() -> void:
	if not is_inside_tree(): return
	var keep_list := Common.focus_index(list)
	for child in list.get_children(): child.queue_free()
	Common.refocus(list, keep_list)
	var keys: Array = game.session.blueprints.keys()
	keys.sort_custom(func(a, b): return int(a) < int(b))
	for key in keys:
		var id := int(key)
		var data: Dictionary = game.workshop.details(id)
		if data.is_empty(): continue
		list.add_child(Common.row(Common.item_icon(app.library, id), app.catalogue.item_name(id),
			"%.1f%%" % (float(data.fraction) * 100.0), _select.bind(id)))
	if keys.is_empty(): list.add_child(UI.label(app.library.text(141), 15, UI.TEXT_DIM))
	for key in keys:
		var data: Dictionary = game.workshop.details(int(key))
		for origin in data.get("pending", {}):
			list.add_child(UI.paragraph("%s: %dx %s\n%s %s" % [app.library.text(132), int(data.pending[origin]),
				app.catalogue.item_name(int(key)), app.library.text(133), app.catalogue.station_name(int(origin))], 14))
	_draw_details()

func _select(product: int) -> void:
	selected = product
	selected_item = -1
	amount = 1
	_draw_details()
	station._tip("blueprint_info")

func _draw_details() -> void:
	var keep_detail := Common.focus_index(detail)
	for child in detail.get_children(): child.queue_free()
	Common.refocus(detail, keep_detail)
	var data: Dictionary = game.workshop.details(selected)
	if data.is_empty():
		# Nothing chosen: the original's help for this page.
		detail.add_child(UI.paragraph(Tips.split(app.library.text(312))[1], 14, UI.TEXT_DIM))
		return
	detail.add_child(UI.label(app.catalogue.item_name(selected), 20))
	var progress := ProgressBar.new()
	progress.value = float(data.fraction) * 100.0
	progress.custom_minimum_size.y = 22
	detail.add_child(progress)
	var origin := int(data.station)
	var location: String = app.catalogue.station_name(origin) if origin >= 0 else "—"
	detail.add_child(UI.label("%s %s  ·  %d per production" % [app.library.text(133), location, int(data.batch)], 14, UI.TEXT_DIM))
	ingredients = VBoxContainer.new()
	ingredients.add_theme_constant_override("separation", 3)
	detail.add_child(ingredients)
	for row in data.ingredients:
		var id := int(row.item)
		var button := Common.row(Common.item_icon(app.library, id), app.catalogue.item_name(id),
			"%d / %d  ·  %s: %d" % [int(row.contributed), int(row.required), app.library.text(61), int(row.cargo)], _select_item.bind(id))
		button.tooltip_text = "%s %d" % [app.library.text(134), int(row.remaining)]
		ingredients.add_child(button)
	actions = VBoxContainer.new()
	detail.add_child(actions)
	_draw_actions()

func _select_item(id: int) -> void:
	selected_item = id
	amount = 1
	_draw_actions()

func _draw_actions() -> void:
	var keep_actions := Common.focus_index(actions)
	for child in actions.get_children(): child.queue_free()
	Common.refocus(actions, keep_actions)
	var data: Dictionary = game.workshop.details(selected)
	var available := 0
	for row in data.get("ingredients", []):
		if int(row.item) == selected_item: available = mini(int(row.remaining), int(row.cargo))
	if selected_item < 0:
		actions.add_child(UI.paragraph("Select a material to contribute from the cargo hold.", 14, UI.TEXT_DIM))
		return
	actions.add_child(UI.label(app.catalogue.item_name(selected_item), 16))
	if available <= 0:
		actions.add_child(UI.paragraph("No carried material is needed for this ingredient.", 14, UI.TEXT_DIM))
		return
	amount = clampi(amount, 1, available)
	var quantity := HBoxContainer.new()
	actions.add_child(quantity)
	quantity.add_child(UI.button("−", func(): amount = maxi(1, amount - 1); _draw_actions()))
	quantity.add_child(UI.label(str(amount), 16))
	quantity.add_child(UI.button("+", func(): amount = mini(available, amount + 1); _draw_actions()))
	quantity.add_child(UI.button("Max", func(): amount = available; _draw_actions()))
	var order: Dictionary = game.blueprint_offer(selected, selected_item, amount)
	if not str(order.error).is_empty():
		actions.add_child(UI.paragraph(str(order.error), 14, UI.TEXT_WARN))
		return
	var label := "Contribute %d" % amount
	if int(order.fee) > 0: label += "  (" + UI.money(int(order.fee)) + ")"
	actions.add_child(UI.button(label, _submit.bind(order)))

func _submit(order: Dictionary) -> void:
	if bool(order.first) or bool(order.remote):
		pending_order = order.duplicate(true)
		confirmation.dialog_text = app.library.text(91) if bool(order.first) else app.library.format(142,
			{"#S": app.catalogue.station_name(int(order.origin)), "#C": UI.money(int(order.fee))})
		confirmation.popup_centered()
	else:
		_commit(order)

func _confirmed() -> void:
	var order := pending_order
	pending_order = {}
	if not order.is_empty(): _commit(order)

func _commit(order: Dictionary) -> void:
	var error: String = game.contribute_blueprint(order)
	if not error.is_empty(): station.notify(error); return
	var after: Dictionary = game.workshop.details(int(order.product))
	if int(after.produced) > int(order.state.get("produced", 0)):
		var text: String = app.library.text(89 if bool(order.remote) else 90)
		station.notify(text.replace("#N", app.catalogue.item_name(int(order.product))).replace("#S", app.catalogue.station_name(int(order.origin))))
	else:
		station.notify("%dx %s" % [int(order.count), app.catalogue.item_name(int(order.ingredient))])
