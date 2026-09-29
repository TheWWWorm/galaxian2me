extends RefCounted
## Shared pieces for the docked panels: item icons from the imported sheet,
## item rows and the attribute summary the original shows for an item.

const UI := preload("res://src/presentation/ui.gd")
const Catalogue := preload("res://src/content/catalogue.gd")

## One cell of items.png per item id, over the original's frame for the
## item's kind (item_types.png: primary, secondary, turret, equipment,
## commodity), as its hangar lists draw them.
static func item_icon(library, id: int) -> TextureRect:
	var sheet: Texture2D = library.texture("items")
	if sheet == null: return TextureRect.new()
	var cell := int(sheet.get_width() / max(1, library.data.items.size()))
	var icon := UI.picture(sheet, 2.0, Rect2(id * cell, 0, cell, sheet.get_height()))
	var frames: Texture2D = library.texture("item_types")
	if frames == null or id < 0 or id >= library.data.items.size(): return icon
	var kind := int(library.data.items[id].get("attributes", {}).get(str(Catalogue.A_CATEGORY), -1))
	var fw := int(frames.get_width() / 5)
	if kind < 0 or kind >= 5: return icon
	var frame := UI.picture(frames, 2.0, Rect2(kind * fw, 0, fw, frames.get_height()))
	frame.custom_minimum_size = icon.custom_minimum_size
	icon.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	frame.add_child(icon)
	return frame

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
			out.append([library.text(l[1]), text, l[0], v])
	if cat.has_attr(id, Catalogue.A_SCAN_ASTEROIDS) and cat.attr(id, Catalogue.A_SCAN_ASTEROIDS) == 1:
		out.append([library.text(46), library.text(15)])
	if cat.has_attr(id, Catalogue.A_SCAN_CARGO) and cat.attr(id, Catalogue.A_SCAN_CARGO) == 1:
		out.append([library.text(47), library.text(15)])
	return out

## Figures where less is better (waiting times).
const LOWER_BETTER := [Catalogue.A_RELOAD, Catalogue.A_SHIELD_RECHARGE, Catalogue.A_SCAN_LOCK]

## The fitted item a shop item would stand in for: the same kind of
## equipment or secondary, else (guns and turrets) the first fitted in the
## category. -1 when nothing comparable is fitted or it is the same item.
static func fitted_counterpart(session, cat, id: int) -> int:
	var c: int = cat.category(id)
	if c < 0 or c >= session.equipment.size(): return -1
	var first := -1
	for e in session.equipment[c]:
		if e == null: continue
		if cat.type(int(e.id)) == cat.type(id): first = int(e.id); break
		if first < 0 and (c == Catalogue.Category.PRIMARY or c == Catalogue.Category.TURRET): first = int(e.id)
	return -1 if first == id else first

## item_facts lines as table rows, each with its lead or shortfall against
## `against` (an item id; -1 for none) in green or red.
static func fact_rows(library, cat, id: int, against := -1) -> Array[Control]:
	var theirs := {}
	if against >= 0:
		for f in item_facts(library, cat, against):
			if f.size() > 2: theirs[f[2]] = int(f[3])
	var out: Array[Control] = []
	for f in item_facts(library, cat, id):
		if against >= 0 and f.size() > 2 and theirs.has(f[2]) and int(f[3]) != int(theirs[f[2]]):
			var diff: int = int(f[3]) - int(theirs[f[2]])
			var seconds: bool = f[1].ends_with(" s")
			var amount: String = ("%.1f s" % (absi(diff) / 1000.0)) if seconds else str(absi(diff))
			if f[1].ends_with("%"): amount += "%"
			var better := (diff < 0) if LOWER_BETTER.has(f[2]) else (diff > 0)
			out.append(fact_line(f[0], f[1], ("+" if diff > 0 else "−") + amount, better))
		else:
			out.append(fact_line(f[0], f[1]))
	return out

## One line of a figures table: the name, the value at the right, and an
## optional difference after it (green when better, red when worse), over a
## faint rule. Children: name, value[, difference].
static func fact_line(name: String, value: String, delta := "", good := true) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	var n := UI.label(name, 15, UI.TEXT.darkened(0.12))
	n.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(n)
	var v := UI.label(value, 15)
	v.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	v.custom_minimum_size.x = 64
	row.add_child(v)
	if not delta.is_empty():
		var d := UI.label(delta, 15, UI.TEXT_GOOD if good else UI.TEXT_WARN)
		d.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		d.custom_minimum_size.x = 64
		row.add_child(d)
	row.custom_minimum_size.y = 28
	row.draw.connect(func(): row.draw_line(Vector2(0, row.size.y + 1), Vector2(row.size.x, row.size.y + 1), Color(UI.BORDER, 0.35), 1.0))
	return row

## The price line under a table: the word and the sum, both green.
static func price_line(label: String, value: String) -> HBoxContainer:
	var row := HBoxContainer.new()
	var l := UI.label(label, 18, UI.TEXT_GOOD)
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(l)
	row.add_child(UI.label(value, 18, UI.TEXT_GOOD))
	row.custom_minimum_size.y = 36
	return row

## The big action at the foot of an info panel (buy, sell), with its icon.
static func action_button(text: String, icon: String, callback: Callable, enabled := true) -> Button:
	var b := UI.icon_button(text, icon, callback, enabled)
	b.alignment = HORIZONTAL_ALIGNMENT_CENTER
	b.custom_minimum_size.y = 52
	b.add_theme_font_size_override("font_size", 18)
	return b

## A heading inside a list (a slot group, a section): accent capitals.
static func heading(text: String) -> Label:
	var l := UI.label(text.to_upper(), 14, UI.ACCENT)
	l.custom_minimum_size.y = 30
	l.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	return l

## A selectable row: icon, name, right-aligned figures. It stays lit while
## it is the chosen one (`chosen`, or the last one pressed in its list).
static func row(icon: Control, text: String, right: String, on_press: Callable, chosen := false) -> Button:
	var b := Button.new()
	b.focus_mode = Control.FOCUS_ALL
	b.toggle_mode = true
	b.button_pressed = chosen
	b.custom_minimum_size.y = 50
	b.pressed.connect(func():
		# Only one row of a list is lit.
		for sib in b.get_parent().get_children():
			if sib is Button and sib.toggle_mode: sib.set_pressed_no_signal(sib == b)
		on_press.call())
	var h := HBoxContainer.new()
	h.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	h.offset_left = 8; h.offset_right = -12
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	h.add_theme_constant_override("separation", 14)
	b.add_child(h)
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(icon)
	var l := UI.label(text, 16)
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	l.clip_text = true
	l.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	h.add_child(l)
	var r := UI.label(right, 16, UI.TEXT_GOOD)
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
	list.add_theme_constant_override("separation", 6)
	scroll.add_child(list)
	return [scroll, list]

## Rebuilding a list or a detail pane frees the focused button; a pad or
## keyboard user would lose their place. focus_index() before the rebuild
## and refocus() after put the highlight back on the same row (the n-th
## focusable control of `root`).
static func focusables(root: Control) -> Array:
	var out: Array = []
	for c in root.find_children("*", "Control", true, false):
		var ctl := c as Control
		if ctl.focus_mode == Control.FOCUS_NONE or not ctl.visible or _dying(ctl, root): continue
		out.append(ctl)
	return out

static func _dying(node: Node, root: Node) -> bool:
	while node != null and node != root:
		if node.is_queued_for_deletion(): return true
		node = node.get_parent()
	return false

static func focus_index(root: Control) -> int:
	if not root.is_inside_tree(): return -1
	var owner := root.get_viewport().gui_get_focus_owner()
	if owner == null or not root.is_ancestor_of(owner): return -1
	return focusables(root).find(owner)

static func refocus(root: Control, index: int) -> void:
	if index < 0: return
	_refocus_now.call_deferred(root, index)

static func _refocus_now(root: Control, index: int) -> void:
	if not is_instance_valid(root) or not root.is_inside_tree(): return
	var list := focusables(root)
	if list.is_empty(): return
	(list[mini(index, list.size() - 1)] as Control).grab_focus()
