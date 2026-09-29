extends SceneTree
## The ship dealer sets an offered hull's figures against the ship you fly:
## each figure that differs carries its lead or shortfall.
const Host := preload("res://tests/support/isolated_app.gd")
var checks := 0
var failures := 0

func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)
func frames(n: int) -> void:
	for i in n: await process_frame

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
	# The first station whose dealer offers a hull.
	var found := false
	for sd in app.catalogue.data.stations:
		g.session.station_id = int(sd.id)
		g.session.system_index = app.catalogue.system_of_station(int(sd.id))
		g.dock(g.session.station_id)
		if not g.dealer().is_empty(): found = true; break
	if not found:
		print("SKIP: no dealer offers"); app.queue_free(); await process_frame; quit(2); return
	app.game = g
	app.show_station()
	await frames(3)
	var st = app.screen
	st._open_section(0)
	await frames(2)
	var dealer = (st.current_panel as TabContainer).get_child(2)
	var offer: Dictionary = g.dealer()[0]
	dealer._select(offer)
	await frames(2)
	var mine: Dictionary = app.catalogue.ship(int(g.session.ship.index))
	var theirs: Dictionary = app.catalogue.ship(int(offer.index))
	var armour_row: HBoxContainer = null
	for r in dealer.detail.get_children():
		if r is HBoxContainer and not r.is_queued_for_deletion() and (r.get_child(0) as Label).text.begins_with(app.library.text(60)):
			armour_row = r
	check(armour_row != null, "the armour figure is listed")
	var diff := int(theirs.armor) - int(mine.armor)
	if diff == 0:
		check(armour_row.get_child_count() == 2, "equal armour shows no difference")
	else:
		var mark: String = (armour_row.get_child(2) as Label).text
		check(mark == ("+%d" % diff if diff > 0 else "−%d" % -diff), "the armour lead or shortfall is shown (%s)" % mark)
	dealer._select({})
	await frames(2)
	var plain := true
	for r in dealer.detail.get_children():
		if r is HBoxContainer and not r.is_queued_for_deletion() and r.get_child_count() > 2: plain = false
	check(plain, "your own ship is listed without comparisons")
	# The shop sets a gun on the shelf against the gun you have fitted.
	var Common = load("res://src/screens/station/common.gd")
	var shop = (st.current_panel as TabContainer).get_child(0)
	var gun := -1
	for e in g.shelf():
		if app.catalogue.category(int(e.id)) == 0 and Common.fitted_counterpart(g.session, app.catalogue, int(e.id)) >= 0:
			gun = int(e.id); break
	if gun < 0:
		print("(no gun on this shelf; shop comparison not checked)")
	else:
		var fitted: int = Common.fitted_counterpart(g.session, app.catalogue, gun)
		shop._select(gun, 0)
		await frames(2)
		var named := false
		var marked := 0
		for c in shop.detail.get_children():
			if c.is_queued_for_deletion(): continue
			if c is Label and (c as Label).text.contains(app.catalogue.item_name(fitted)): named = true
			if c is HBoxContainer and c.get_child_count() > 2: marked += 1
		var differs := false
		for a in [9, 11, 12]:
			if app.catalogue.attr(gun, a) != app.catalogue.attr(fitted, a): differs = true
		check(named, "the shop names the fitted gun it compares with")
		check(marked > 0 or not differs, "and marks the figures that differ (%d)" % marked)
		shop._select(gun, 1)
		await frames(2)
		var none := true
		for c in shop.detail.get_children():
			if not c.is_queued_for_deletion() and c is HBoxContainer and c.get_child_count() > 2 and not (c.get_child(0) is Button): none = false
		check(none, "an item in your own hold is not compared")
	app.queue_free()
	await process_frame
	print("DEALER COMPARE: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
