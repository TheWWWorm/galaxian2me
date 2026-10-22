extends Control
## The galaxy map on a reference page: every system at its map position,
## jump gate links between them, coloured by the faction that holds it. The
## page's system is ringed and named; a faction page lights its own systems.
## Clicking a system opens its page.
signal followed(key: String)

const UI := preload("res://src/presentation/ui.gd")
## Faction colours, as the reference's web page export draws them.
const COLOURS := [Color8(0x4a, 0xa3, 0xff), Color8(0xe0, 0x6a, 0x3a), Color8(0x6a, 0xc7, 0x64), Color8(0xc0, 0x8c, 0xff)]

var catalog
var highlight := -1
var faction := -1

func configure(owner_catalog, descriptor: Dictionary) -> void:
	catalog = owner_catalog
	highlight = int(descriptor.get("highlight", -1))
	faction = int(descriptor.get("faction", -1))
	custom_minimum_size = Vector2(200, 200)
	mouse_filter = Control.MOUSE_FILTER_STOP
	tooltip_text = ""

static func colour(race: int) -> Color:
	return COLOURS[race] if race >= 0 and race < COLOURS.size() else Color(0.7, 0.7, 0.7)

## The square the map is drawn in, and a system's place in it.
func square() -> Rect2:
	var side := minf(size.x, size.y)
	return Rect2((size - Vector2(side, side)) / 2.0, Vector2(side, side))

func point(system: int) -> Vector2:
	var s: Dictionary = catalog.cat.system(system)
	var box := square()
	return box.position + Vector2(int(s.x), int(s.y)) / 100.0 * box.size

func _draw() -> void:
	if catalog == null: return
	var box := square()
	draw_rect(box, Color(UI.PANEL, 0.6))
	var count: int = catalog.cat.system_count()
	for id in count:
		for other in catalog.cat.system(id).get("links", []):
			if int(other) > id: draw_line(point(id), point(int(other)), Color(UI.BORDER, 0.8), 1.0, true)
	var font := get_theme_default_font()
	var scale := box.size.x / 300.0
	for id in count:
		var race := int(catalog.cat.system(id).faction)
		var lit := faction < 0 or race == faction
		var r := (3.5 if id != highlight else 6.0) * maxf(1.0, scale)
		draw_circle(point(id), r, Color(colour(race), 0.95 if lit else 0.3))
		if id == highlight: draw_arc(point(id), r + 3.0, 0, TAU, 24, UI.TEXT, 1.5, true)
		if id == highlight or box.size.x >= 360:
			var name: String = catalog.system_name(id)
			var size_ := 13 if id == highlight else 10
			var at := point(id) + Vector2(r + 3.0, -r)
			at.x = minf(at.x, box.end.x - font.get_string_size(name, HORIZONTAL_ALIGNMENT_LEFT, -1, size_).x)
			draw_string(font, at, name, HORIZONTAL_ALIGNMENT_LEFT, -1, size_, UI.TEXT if id == highlight else UI.TEXT_DIM)

func nearest(at: Vector2) -> int:
	var best := -1
	var distance := 18.0
	for id in catalog.cat.system_count():
		var d := point(id).distance_to(at)
		if d < distance: distance = d; best = id
	return best

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var id := nearest(event.position)
		tooltip_text = catalog.system_name(id) if id >= 0 else ""
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var id := nearest(event.position)
		if id >= 0: followed.emit("system/%d" % id); accept_event()

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED: queue_redraw()
