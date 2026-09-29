extends SceneTree
## Pad and keyboard users keep their place in the shop: stepping the amount
## and buying rebuild the pane, and the highlight stays on the same button.
const Host := preload("res://tests/support/isolated_app.gd")
const Common := preload("res://src/screens/station/common.gd")
var checks := 0
var failures := 0

func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)
func frames(n: int) -> void:
	for i in n: await process_frame

func button(root: Node, prefix: String) -> Button:
	for b in root.find_children("*", "Button", true, false):
		if (b as Button).text.begins_with(prefix) and not b.is_queued_for_deletion(): return b
	return null

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		print("SKIP: no supplied content"); app.queue_free(); await process_frame; quit(2); return
	app.settings.set_value("interface", "help_popups", false)
	var g = app._make_game()
	g.new_game()
	g.session.story_step = maxi(g.session.story_step, 20)
	g.session.credits = 1000000
	# A busy market: the first tech-4-or-better station of the map.
	for sd in app.catalogue.data.stations:
		if int(sd.get("tech", 0)) >= 4:
			g.session.station_id = int(sd.id)
			g.session.system_index = app.catalogue.system_of_station(int(sd.id))
			break
	g.dock(g.session.station_id)
	app.game = g
	app.show_station()
	await frames(3)
	var st = app.screen
	st._open_section(0)
	await frames(2)
	var shop = (st.current_panel as TabContainer).get_child(0)
	var goods := -1
	for e in g.shelf():
		if int(e.count) >= 3: goods = int(e.id); break
	if goods < 0:
		print("SKIP: nothing stocked three deep"); app.queue_free(); await process_frame; quit(2); return
	shop._select(goods, 0)
	await frames(2)
	var plus := button(shop.detail, "+")
	plus.grab_focus()
	plus.pressed.emit()
	await frames(2)
	var owner := shop.get_viewport().gui_get_focus_owner()
	check(shop.amount == 2 and owner is Button and (owner as Button).text == "+", "after + the highlight stays on +")
	var buy := button(shop.detail, "Buy")
	buy.grab_focus()
	buy.pressed.emit()
	await frames(2)
	owner = shop.get_viewport().gui_get_focus_owner()
	check(g.session.cargo_count(goods) == 2 and owner is Button and (owner as Button).text.begins_with("Buy"), "after buying it stays on Buy")
	var rows: Array = Common.focusables(shop.shelf_list)
	(rows[1] as Control).grab_focus()
	g.changed.emit()
	await frames(2)
	check(Common.focus_index(shop.shelf_list) == 1, "a refreshed list keeps the highlighted row")
	app.queue_free()
	await process_frame
	print("STATION FOCUS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
