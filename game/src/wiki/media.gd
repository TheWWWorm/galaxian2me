extends VBoxContainer
## The picture beside a reference page: a ship or station turning in its own
## showroom, an item's icon, a portrait, a faction's emblem or the galaxy map,
## all from the player's imported art. A model can be turned by dragging it.
## Without a renderer (a headless check) a model is left out.
signal followed(key: String)

const UI := preload("res://src/presentation/ui.gd")
const Common := preload("res://src/screens/station/common.gd")
const Portrait := preload("res://src/presentation/portrait.gd")
const ShipPreview := preload("res://src/presentation/ship_preview.gd")
const WikiMap := preload("res://src/wiki/map.gd")

## What is shown now: "ship", "station", "item", "portrait", "image", "map", "glyph" or "".
var shown := ""

## Builds the picture for a page. Returns false when there is nothing to show.
func show_media(descriptor: Dictionary, catalog) -> bool:
	for child in get_children(): remove_child(child); child.queue_free()
	shown = ""
	add_theme_constant_override("separation", 8)
	var library = catalog.library
	var renders := DisplayServer.get_name() != "headless"
	if renders and (descriptor.has("ship") or descriptor.has("station")):
		var preview := ShipPreview.new()
		preview.library = library
		# A landscape frame: the showroom's camera frames for one, and a tall
		# column would crop the model at its sides.
		preview.custom_minimum_size = Vector2(240, 230)
		preview.size_flags_vertical = Control.SIZE_FILL
		add_child(framed(preview))
		if descriptor.has("ship"): preview.show_ship(int(descriptor.ship), int(descriptor.get("faction", 0)))
		else: preview.show_station(int(descriptor.station), int(catalog.cat.system(catalog.cat.system_of_station(int(descriptor.station))).faction))
		add_child(caption(tr("Drag to turn")))
		shown = "ship" if descriptor.has("ship") else "station"
	# The game's own sprite of a ship, as the dealer lists show it; alone
	# where nothing can be drawn.
	if descriptor.has("ship"):
		var sprite := Common.ship_icon(library, int(descriptor.ship))
		if sprite.texture != null:
			sprite.custom_minimum_size *= 1.5
			sprite.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			add_child(sprite)
			if shown.is_empty(): shown = "image"
	var picture: Control = null
	if descriptor.has("item"):
		picture = Common.item_icon(library, int(descriptor.item))
		picture.custom_minimum_size *= 2.0
		shown = "item"
	elif descriptor.has("portrait") and not descriptor.portrait.is_empty():
		picture = Portrait.make(library, int(descriptor.get("speaker", -1)), descriptor.portrait, 4.0)
		shown = "portrait"
	elif descriptor.has("medal"):
		picture = UI.picture(library.texture("medals"), 6.0, Rect2(int(descriptor.medal) * 31, 0, 31, 15))
		shown = "image"
	elif descriptor.has("image") and library.texture(str(descriptor.image)) != null:
		picture = UI.picture(library.texture(str(descriptor.image)), 3.0)
		shown = "image"
	if picture != null:
		picture.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		var holder := CenterContainer.new(); holder.custom_minimum_size.y = 150; holder.add_child(picture)
		add_child(framed(holder))
	if descriptor.has("map"):
		var map := WikiMap.new()
		map.configure(catalog, descriptor.map)
		map.followed.connect(func(key): followed.emit(key))
		map.size_flags_vertical = Control.SIZE_EXPAND_FILL
		map.custom_minimum_size = Vector2(200, 200 if shown.is_empty() else 170)
		add_child(framed(map))
		if shown.is_empty(): shown = "map"
	if shown.is_empty() and descriptor.has("glyph"):
		var glyph := Glyph.new(); glyph.icon = str(descriptor.glyph); glyph.custom_minimum_size = Vector2(96, 96)
		var holder := CenterContainer.new(); holder.custom_minimum_size.y = 130; holder.add_child(glyph)
		add_child(framed(holder))
		shown = "glyph"
	return not shown.is_empty()

func framed(inner: Control) -> PanelContainer:
	var frame := PanelContainer.new()
	var style := StyleBoxFlat.new(); style.bg_color = Color(UI.DEEP, 0.7); style.border_color = Color(UI.BORDER, 0.8)
	style.set_border_width_all(1); style.set_corner_radius_all(6); style.set_content_margin_all(6)
	frame.add_theme_stylebox_override("panel", style)
	frame.clip_contents = true
	frame.size_flags_vertical = inner.size_flags_vertical
	frame.add_child(inner)
	return frame

func caption(text: String) -> Label:
	var label := UI.label(text, 13, UI.TEXT_DIM)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return label

## A small fixed-size picture for a list row.
static func thumbnail(descriptor: Dictionary, catalog, extent := Vector2(48, 30)) -> Control:
	var library = catalog.library
	var picture: Control = null
	if descriptor.has("item"): picture = Common.item_icon(library, int(descriptor.item))
	elif descriptor.has("ship"): picture = Common.ship_icon(library, int(descriptor.ship))
	elif descriptor.has("portrait") and not descriptor.portrait.is_empty():
		picture = Portrait.make(library, int(descriptor.get("speaker", -1)), descriptor.portrait, 0.55)
	elif descriptor.has("medal"): picture = UI.picture(library.texture("medals"), 1.0, Rect2(int(descriptor.medal) * 31, 0, 31, 15))
	elif descriptor.has("image") and library.texture(str(descriptor.image)) != null: picture = UI.picture(library.texture(str(descriptor.image)), -1.0)
	var holder := CenterContainer.new(); holder.custom_minimum_size = extent; holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if picture == null:
		var glyph := Glyph.new(); glyph.icon = str(descriptor.get("glyph", "info")); glyph.custom_minimum_size = Vector2(extent.y * 0.8, extent.y * 0.8)
		picture = glyph
	if picture is TextureRect:
		var tex: Texture2D = picture.texture
		if tex != null:
			var fit := minf(extent.x / tex.get_width(), extent.y / tex.get_height())
			picture.custom_minimum_size = tex.get_size() * fit
	picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for child in picture.get_children(): if child is Control: child.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.add_child(picture)
	return holder

## One of the interface's drawn icons.
class Glyph extends Control:
	var icon := "info"
	func _draw() -> void:
		load("res://src/presentation/ui.gd").draw_icon(self, icon, Rect2(Vector2.ZERO, size), load("res://src/presentation/ui.gd").ACCENT)
	func _notification(what: int) -> void:
		if what == NOTIFICATION_RESIZED: queue_redraw()
