extends RefCounted
## Shared pieces for the docked panels: item icons from the imported sheet,
## item rows and the attribute summary the original shows for an item.

const UI := preload("res://src/presentation/ui.gd")
const Catalogue := preload("res://src/content/catalogue.gd")

## One cell of items.png per item id.
static func item_icon(library, id: int) -> TextureRect:
	var sheet: Texture2D = library.texture("items")
	if sheet == null: return TextureRect.new()
	var cell := int(sheet.get_width() / max(1, library.data.items.size()))
	return UI.picture(sheet, 2.0, Rect2(id * cell, 0, cell, sheet.get_height()))

static func ship_icon(library, index: int) -> TextureRect:
	var sheet: Texture2D = library.texture("ships")
	if sheet == null: return TextureRect.new()
	var count: int = library.data.ship_parts.size()
	var cell := int(sheet.get_width() / max(1, count))
	return UI.picture(sheet, 2.0, Rect2(index * cell, 0, cell, sheet.get_height()))

## Attribute lines worth showing for an item, labelled with the original's
## strings where it has them.
static func item_facts(library, cat, id: int) -> Array:
	var out: Array = []
	var lines := [
		[Catalogue.A_DAMAGE, 50], [Catalogue.A_EMP_DAMAGE, 42], [Catalogue.A_RELOAD, 51],
		[Catalogue.A_RANGE, 54], [Catalogue.A_SPEED, 57], [Catalogue.A_BLAST_RADIUS, 43],
		[Catalogue.A_TURRET_SPEED, 59], [Catalogue.A_SHIELD, 52], [Catalogue.A_SHIELD_RECHARGE, 53],
		[Catalogue.A_ARMOR, 60], [Catalogue.A_EMP_DEFENSE, 44], [Catalogue.A_COMPRESSION, 52],
		[Catalogue.A_BOOST_SPEED, 57], [Catalogue.A_BOOST_LENGTH, 55], [Catalogue.A_HANDLING, 59],
		[Catalogue.A_SCAN_LOCK, 45], [Catalogue.A_MINING_YIELD, 48], [Catalogue.A_CABIN, 49]]
	for l in lines:
		if cat.has_attr(id, l[0]):
			var v: int = cat.attr(id, l[0])
			var text := str(v)
			if l[0] == Catalogue.A_RELOAD or l[0] == Catalogue.A_SHIELD_RECHARGE or l[0] == Catalogue.A_BOOST_LENGTH or l[0] == Catalogue.A_SCAN_LOCK:
				text = "%.1f s" % (v / 1000.0)
			if l[0] == Catalogue.A_COMPRESSION or l[0] == Catalogue.A_BOOST_SPEED: text += "%"
			out.append([library.text(l[1]), text])
	if cat.has_attr(id, Catalogue.A_SCAN_ASTEROIDS) and cat.attr(id, Catalogue.A_SCAN_ASTEROIDS) == 1:
		out.append([library.text(46), library.text(15)])
	if cat.has_attr(id, Catalogue.A_SCAN_CARGO) and cat.attr(id, Catalogue.A_SCAN_CARGO) == 1:
		out.append([library.text(47), library.text(15)])
	return out

## A selectable row: icon, name, right-aligned figures.
static func row(icon: Control, text: String, right: String, on_press: Callable) -> Button:
	var b := Button.new()
	b.focus_mode = Control.FOCUS_ALL
	b.custom_minimum_size.y = 38
	b.pressed.connect(on_press)
	var h := HBoxContainer.new()
	h.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	h.offset_left = 6; h.offset_right = -8
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_child(h)
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	h.add_child(icon)
	var l := UI.label(text, 15)
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	l.clip_text = true
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	h.add_child(l)
	var r := UI.label(right, 15, UI.TEXT_GOOD)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	r.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	h.add_child(r)
	return b

static func scroll_list() -> Array:
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	var list := VBoxContainer.new()
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list.add_theme_constant_override("separation", 3)
	scroll.add_child(list)
	return [scroll, list]
