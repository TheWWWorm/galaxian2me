extends HBoxContainer
## The galaxy map: known systems at their map positions with the gate links
## between them, the systems' stations, and departure towards a chosen
## destination. Only systems linked to the current system's jump gate can be
## chosen, unless the ship carries a jump drive.

const UI := preload("res://src/presentation/ui.gd")
const Common := preload("res://src/screens/station/common.gd")

var station
var app
var game
var canvas: Control
var side: VBoxContainer
var selected_system := -1

class MapCanvas extends Control:
	var panel
	func _draw() -> void:
		panel._draw_map(self)
	func _gui_input(event: InputEvent) -> void:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			panel._pick(self, event.position)

func _ready() -> void:
	app = station.app
	game = station.game
	add_theme_constant_override("separation", 10)
	var frame := UI.Frame.new(app.library.text(72))
	frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(frame)
	canvas = MapCanvas.new()
	canvas.panel = self
	canvas.custom_minimum_size = Vector2(420, 360)
	canvas.size_flags_vertical = Control.SIZE_EXPAND_FILL
	canvas.focus_mode = Control.FOCUS_ALL
	frame.add_child(canvas)
	var info := UI.Frame.new(app.library.text(126))
	info.custom_minimum_size.x = 320
	add_child(info)
	var s := Common.scroll_list()
	info.add_child(s[0])
	side = s[1]
	selected_system = game.session.system_index
	_fill_side()

func _known(i: int) -> bool:
	var sys: Dictionary = app.catalogue.system(i)
	return bool(sys.get("visible", false)) or game.session.visited_systems.has(str(i)) or game.session.unlocked_systems.has(str(i))

func _reachable(i: int) -> bool:
	if i == game.session.system_index: return true
	if bool(game.session.ship_stats().jump_drive): return true
	var links: Array = app.catalogue.system(game.session.system_index).get("links", [])
	return links.has(i)

func _map_rect(c: Control) -> Rect2:
	return Rect2(Vector2(20, 20), c.size - Vector2(40, 40))

func _to_screen(c: Control, sys: Dictionary) -> Vector2:
	var r := _map_rect(c)
	return r.position + Vector2(float(sys.x) / 100.0 * r.size.x, float(sys.y) / 100.0 * r.size.y)

func _draw_map(c: Control) -> void:
	var cat = app.catalogue
	c.draw_rect(Rect2(Vector2.ZERO, c.size), Color(0, 0, 0, 0.55))
	var here: int = game.session.system_index
	for i in cat.system_count():
		if not _known(i): continue
		var a := _to_screen(c, cat.system(i))
		for j in cat.system(i).get("links", []):
			if int(j) < i or not _known(int(j)): continue
			var b := _to_screen(c, cat.system(int(j)))
			c.draw_line(a, b, UI.BORDER, 1.5)
	var glow: Texture2D = app.library.texture("map_sun_glow")
	for i in cat.system_count():
		if not _known(i): continue
		var sys: Dictionary = cat.system(i)
		var p := _to_screen(c, sys)
		if glow != null:
			c.draw_texture_rect(glow, Rect2(p - Vector2(14, 14), Vector2(28, 28)), false, Color(1, 1, 1, 0.8))
		var col := UI.TEXT if _reachable(i) else UI.TEXT_DIM
		if i == here: col = UI.TEXT_GOOD
		c.draw_circle(p, 4.0 if i != selected_system else 6.0, col)
		if i == selected_system: c.draw_arc(p, 10.0, 0, TAU, 24, UI.GREEN, 2.0)
		var font := c.get_theme_default_font()
		c.draw_string(font, p + Vector2(8, -6), str(sys.name), HORIZONTAL_ALIGNMENT_LEFT, -1, 13, col)
		var mission: Dictionary = game.session.story_mission
		if not mission.is_empty() and cat.system_of_station(int(mission.get("station", -2))) == i:
			var mark: Texture2D = app.library.texture("menu_map_mainmission")
			if mark: c.draw_texture_rect(mark, Rect2(p + Vector2(-18, -18), mark.get_size()), false)
		var job: Dictionary = game.session.job
		if not job.is_empty() and cat.system_of_station(int(job.get("station", -2))) == i:
			var mark2: Texture2D = app.library.texture("menu_map_sidemission")
			if mark2: c.draw_texture_rect(mark2, Rect2(p + Vector2(6, -18), mark2.get_size()), false)

func _pick(c: Control, at: Vector2) -> void:
	var best := -1
	var best_d := 24.0
	for i in app.catalogue.system_count():
		if not _known(i): continue
		var d := at.distance_to(_to_screen(c, app.catalogue.system(i)))
		if d < best_d: best_d = d; best = i
	if best >= 0:
		selected_system = best
		canvas.queue_redraw()
		_fill_side()

func _fill_side() -> void:
	for ch in side.get_children(): ch.queue_free()
	var cat = app.catalogue
	var sys: Dictionary = cat.system(selected_system)
	side.add_child(UI.label(str(sys.name), 18))
	side.add_child(UI.label("%s: %s" % [app.library.text(219), cat.faction_name(int(sys.faction))], 14, UI.TEXT_DIM))
	side.add_child(UI.label("%s: %s" % [app.library.text(220), app.library.text(225 + int(sys.safety))], 14, UI.TEXT_DIM))
	if selected_system != game.session.system_index:
		side.add_child(UI.label("%.0f km" % cat.travel_distance(game.session.system_index, selected_system), 14, UI.TEXT_DIM))
	var reachable := _reachable(selected_system)
	if not reachable:
		side.add_child(UI.paragraph(app.library.text(241), 14, UI.TEXT_WARN))
	for sid in sys.get("stations", []):
		var st: Dictionary = cat.station(int(sid))
		var label := "%s  (%s %d)" % [st.get("name", "?"), app.library.text(37), int(st.get("tech", 0))]
		if int(sid) == game.session.station_id: label += "  ◄"
		var b := UI.button(label, _choose.bind(int(sid)), reachable and int(sid) != game.session.station_id)
		side.add_child(b)
	side.add_child(HSeparator.new())
	side.add_child(UI.button(app.library.text(239), func(): _confirm_depart({})))

func _choose(station_id: int) -> void:
	var name: String = app.catalogue.station_name(station_id)
	_confirm_depart({"station": station_id}, "%s: %s\n%s" % [app.library.text(295), name, app.library.text(242)])

func _confirm_depart(destination: Dictionary, question := "") -> void:
	for ch in side.get_children(): ch.queue_free()
	side.add_child(UI.paragraph(question if not question.is_empty() else app.library.text(217)))
	var row := HBoxContainer.new()
	side.add_child(row)
	var yes := UI.button(app.library.text(38), func(): station.depart(destination))
	row.add_child(yes)
	row.add_child(UI.button(app.library.text(39), _fill_side))
	yes.grab_focus.call_deferred()
