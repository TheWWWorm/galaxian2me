extends HBoxContainer
## Status: pilot record, standing with the factions and the ship's figures.

const UI := preload("res://src/presentation/ui.gd")
const StandingBar := preload("res://src/screens/station/standing_bar.gd")
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
	# The two standing axes, drawn with the original's standing art.
	for axis in 2:
		var bar := StandingBar.new()
		bar.setup(app, axis, int(s.reputation[axis]))
		box.add_child(bar)
	_medals_frame()

## The original's medal list: each medal with its tier, and what it was
## awarded for once held.
func _medals_frame() -> void:
	var Medals := preload("res://src/simulation/medals.gd")
	var lib = app.library
	var s = game.session
	var count: int = Medals.table(lib).size()
	var frame := UI.Frame.new("%s  %d/%d" % [lib.text(63), Medals.held_count(s, lib), count])
	frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(frame)
	var l := Common.scroll_list()
	frame.add_child(l[0])
	var box: VBoxContainer = l[1]
	var sheet: Texture2D = lib.texture("medals")
	for i in count:
		var t: int = Medals.tier(s, i)
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 8)
		if sheet != null: row.add_child(UI.picture(sheet, 1.5, Rect2(t * 31, 0, 31, 15)))
		var text := VBoxContainer.new()
		text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		text.add_child(UI.label(Medals.name(lib, i), 15, UI.TEXT if t > 0 else UI.TEXT_DIM))
		if t > 0:
			var d := UI.paragraph(Medals.description(lib, i, t), 12, UI.TEXT_DIM)
			text.add_child(d)
		row.add_child(text)
		box.add_child(row)
