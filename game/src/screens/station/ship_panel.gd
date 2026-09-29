extends BoxContainer
## The player's ship: its slots by category with what is mounted, and the
## original's actions for a slot (mount from the hold, demount, sell).

const UI := preload("res://src/presentation/ui.gd")
const Common := preload("res://src/screens/station/common.gd")

## Slot categories and their headings.
const HEADINGS := [123, 124, 125, 127]

var station
var app
var game
var slots_list: VBoxContainer
var ship_frame: UI.Frame
var detail: VBoxContainer
var sel_cat := -1
var sel_slot := -1

func _ready() -> void:
	app = station.app
	game = station.game
	add_theme_constant_override("separation", 10)
	ship_frame = UI.Frame.new(app.catalogue.ship_name(int(game.session.ship.index)))
	ship_frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(ship_frame)
	var l := Common.scroll_list()
	ship_frame.add_child(l[0])
	slots_list = l[1]
	var info := UI.Frame.new(app.library.text(136))
	info.custom_minimum_size.x = 340
	add_child(info)
	var s := Common.scroll_list()
	info.add_child(s[0])
	detail = s[1]
	game.changed.connect(_fill)
	_fill()

func _fill() -> void:
	if not is_inside_tree(): return
	var current_name: String = app.catalogue.ship_name(int(game.session.ship.index))
	if ship_frame.title != current_name:
		ship_frame.title = current_name
		ship_frame.queue_redraw()
	var keep_slots_list := Common.focus_index(slots_list)
	for c in slots_list.get_children(): c.queue_free()
	Common.refocus(slots_list, keep_slots_list)
	var cat = app.catalogue
	for c in 4:
		var slots: Array = game.session.equipment[c]
		if slots.is_empty(): continue
		# The original heads each group with its filled and total slots.
		var filled := slots.filter(func(x): return x != null).size()
		slots_list.add_child(Common.heading("%s (%d/%d)" % [app.library.text(HEADINGS[c]), filled, slots.size()]))
		for i in slots.size():
			var e = slots[i]
			var icon: Control = Common.item_icon(app.library, int(e.id)) if e != null else TextureRect.new()
			var text: String = (cat.item_name(int(e.id)) + ("  ×%d" % int(e.count) if int(e.count) > 1 else "")) if e != null else app.library.text(69)
			slots_list.add_child(Common.row(icon, text, "", _select.bind(c, i), c == sel_cat and i == sel_slot))
	var st: Dictionary = game.session.ship_stats()
	slots_list.add_child(HSeparator.new())
	var facts := [[60, "%d / %d" % [int(game.session.ship.hull), int(st.max_hull)]], [61, "%d / %d t" % [game.session.cargo_used(), int(st.cargo_capacity)]],
		[59, "%.2f" % float(st.handling)], [50, str(st.damage)]]
	if int(st.shield) > 0: facts.append([107, str(st.shield)])
	for f in facts:
		slots_list.add_child(Common.fact_line(app.library.text(f[0]), f[1]))
	_detail()

func _select(c: int, i: int) -> void:
	sel_cat = c
	sel_slot = i
	_detail()
	# The first mounted item picked: what can be done with it.
	var slots: Array = game.session.equipment[c]
	if i < slots.size() and slots[i] != null: station._tip("actions")

func _detail() -> void:
	var keep_detail := Common.focus_index(detail)
	for c in detail.get_children(): c.queue_free()
	Common.refocus(detail, keep_detail)
	if sel_cat < 0:
		# The original's help here names phone keys; this says what to do here.
		detail.add_child(UI.paragraph("This is your ship with all its weapons and equipment. Pick a slot to see what is fitted there, fit an item from your hold, or remove or sell what is fitted.", 14, UI.TEXT_DIM))
		return
	var cat = app.catalogue
	var slots: Array = game.session.equipment[sel_cat]
	if sel_slot >= slots.size(): sel_cat = -1; _detail(); return
	var e = slots[sel_slot]
	if e != null:
		var id := int(e.id)
		var head := HBoxContainer.new()
		head.add_theme_constant_override("separation", 12)
		head.add_child(Common.item_icon(app.library, id))
		var name_label := UI.label(cat.item_name(id), 20)
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		head.add_child(name_label)
		detail.add_child(head)
		for f in Common.item_facts(app.library, cat, id):
			detail.add_child(Common.fact_line(f[0], f[1]))
		detail.add_child(UI.button(app.library.text(138), func(): station.notify(_msg(game.demount(sel_cat, sel_slot), 88, id))))
		detail.add_child(UI.button(app.library.text(137) + " (" + UI.money(game.price_here(id) * int(e.count)) + ")", func(): station.notify(_msg(game.sell_mounted(sel_cat, sel_slot), 86, id))))
	else:
		detail.add_child(UI.paragraph(app.library.text(82), 14))
	# Compatible items waiting in the hold.
	var any := false
	for k in game.session.cargo:
		var id := int(k)
		if cat.category(id) != sel_cat: continue
		if not any:
			detail.add_child(Common.heading(app.library.text(139)))
			any = true
		detail.add_child(Common.row(Common.item_icon(app.library, id), cat.item_name(id), "×%d" % game.session.cargo_count(id),
			func(): station.notify(_msg(game.mount(id, sel_slot), 87, id))))

func _msg(error: String, success: int, id: int) -> String:
	if not error.is_empty(): return error
	return app.library.format(success, {"#N": app.catalogue.item_name(id)})
