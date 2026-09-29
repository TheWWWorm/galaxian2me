extends BoxContainer
## Status: pilot record, standing with the factions and the ship's figures.

const UI := preload("res://src/presentation/ui.gd")
const StandingBar := preload("res://src/screens/station/standing_bar.gd")
const Common := preload("res://src/screens/station/common.gd")
const Portrait := preload("res://src/presentation/portrait.gd")
const Medals := preload("res://src/simulation/medals.gd")
## Keith T. Maxwell's face (Globals.CHAR_KEITH): Terran set, part 7 each.
const KEITH := [0, 7, 7, 7, 7]

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
	# The original's page: the pilot and his face, credit, level and time
	# played; the standing with the factions; then the statistics.
	box.add_child(UI.label(lib.text(819), 16, UI.TEXT_GOOD))
	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 12)
	box.add_child(head)
	var face := Control.new()
	var picture := Portrait.make(lib, -1, KEITH)
	face.custom_minimum_size = picture.custom_minimum_size
	face.add_child(picture)
	var shades := _medal_glasses()
	if not shades.is_empty():
		var glasses: Texture2D = lib.face(shades)
		if glasses != null:
			var g := TextureRect.new()
			g.texture = glasses
			g.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			g.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			g.position = Vector2(2, 2)
			g.size = glasses.get_size() * 2.0
			face.add_child(g)
	head.add_child(face)
	var top := VBoxContainer.new()
	top.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(top)
	for r in [[80, UI.money(s.credits)], [158, str(s.level())],
			[70, "%d:%02d:%02d" % [ms / 3600000, (ms / 60000) % 60, (ms / 1000) % 60]]]:
		top.add_child(_row(lib.text(r[0]), r[1]))
	box.add_child(HSeparator.new())
	box.add_child(UI.label(lib.text(298), 16, UI.TEXT_GOOD))
	# The two standing axes, drawn with the original's standing art.
	for axis in 2:
		var bar := StandingBar.new()
		bar.setup(app, axis, int(s.reputation[axis]))
		box.add_child(bar)
	box.add_child(HSeparator.new())
	box.add_child(UI.label(lib.text(299), 16, UI.TEXT_GOOD))
	var st: Dictionary = s.ship_stats()
	var rows := [
		[77, app.catalogue.ship_name(int(s.ship.index))],
		[290, str(int(st.damage))],
		[291, str(int(st.max_hull) + int(st.shield))],
		[33, str(s.stat("jobs"))],
		[71, str(s.stat("kills"))],
		[282, "%d t" % s.stat("cargo_salvaged")],
		[280, str(s.visited_stations.size())],
		[287, str(s.stat("jumpgates"))],
		[281, str(s.stat("goods_produced"))],
		[283, "%d t" % s.stat("ore_mined")],
		[284, str(s.stat("cores_mined"))],
		[289, str(s.stat("passengers"))],
	]
	for r in rows: box.add_child(_row(lib.text(r[0]), r[1]))
	_medals_frame()

func _row(label: String, value: String) -> HBoxContainer:
	var h := HBoxContainer.new()
	var a := UI.label(label, 15, UI.TEXT_DIM)
	a.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(a)
	h.add_child(UI.label(value, 15))
	return h

## The original puts black glasses on Keith once every medal is held and
## golden ones once every medal is gold.
func _medal_glasses() -> String:
	var count: int = Medals.table(app.library).size()
	if count == 0: return ""
	var gold := true
	for i in count:
		var t: int = Medals.tier(game.session, i)
		if t <= 0: return ""
		if t != 1: gold = false
	return "Brille_golden" if gold else "Brille_schwarz"

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
