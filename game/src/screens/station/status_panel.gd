extends HBoxContainer
## Status: pilot record, standing with the factions and the ship's figures.

const UI := preload("res://src/presentation/ui.gd")
const Common := preload("res://src/screens/station/common.gd")

var station
var app
var game

func _ready() -> void:
	app = station.app
	game = station.game
	add_theme_constant_override("separation", 10)
	var lib = app.library
	var s = game.session
	var left := UI.Frame.new(lib.text(64))
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(left)
	var l := Common.scroll_list()
	left.add_child(l[0])
	var box: VBoxContainer = l[1]
	var ms: int = s.playtime_ms
	var rows := [
		[80, UI.money(s.credits)],
		[70, "%d:%02d:%02d" % [ms / 3600000, (ms / 60000) % 60, (ms / 1000) % 60]],
		[71, str(s.stat("kills"))],
		[280, str(s.visited_stations.size())],
		[283, "%d t" % s.stat("ore_mined")],
		[284, str(s.stat("cores_mined"))],
		[282, "%d t" % s.stat("cargo_salvaged")],
		[287, str(s.stat("jumpgates"))],
		[289, str(s.stat("passengers"))],
	]
	for r in rows:
		var h := HBoxContainer.new()
		var a := UI.label(lib.text(r[0]), 15, UI.TEXT_DIM)
		a.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h.add_child(a)
		h.add_child(UI.label(r[1], 15))
		box.add_child(h)
	box.add_child(HSeparator.new())
	box.add_child(UI.label(lib.text(298), 16, UI.TEXT_GOOD))
	# The two standing axes: Terran/Vossk and Midorian/Nivelian.
	for axis in 2:
		var h := HBoxContainer.new()
		var pos := 0 if axis == 0 else 3
		var neg := 1 if axis == 0 else 2
		var left_name := UI.label(app.catalogue.faction_name(neg), 14)
		left_name.custom_minimum_size.x = 90
		h.add_child(left_name)
		var bar := ProgressBar.new()
		bar.min_value = -100; bar.max_value = 100
		bar.value = int(s.reputation[axis])
		bar.show_percentage = false
		bar.custom_minimum_size = Vector2(200, 14)
		bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h.add_child(bar)
		h.add_child(UI.label(app.catalogue.faction_name(pos), 14))
		box.add_child(h)
