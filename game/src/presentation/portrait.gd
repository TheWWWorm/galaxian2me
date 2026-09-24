extends RefCounted
## Portraits are layered from face parts: a face record is [set, part 0
## variant, part 1 variant, ...] and each part is faces/<set>_<part>_<variant>.
## Story speakers have fixed records; generated characters get random ones
## within the original's per-set variant counts.

const UI := preload("res://src/presentation/ui.gd")

const FRAME := Vector2(42, 52)

## The fixed face record of a story speaker, from the recovered speaker table.
static func speaker_face(library, speaker: int) -> Array:
	for key in library.data.constants:
		if not key.ends_with(":[[B"): continue
		var v = library.data.constants[key]
		if v is Array and v.size() >= 20 and v.size() <= 30 and v[0] is Array and v[0].size() == 5:
			return v[speaker] if speaker >= 0 and speaker < v.size() else []
	return []

## Variant counts per face set, for generating new faces.
static func variant_table(library) -> Array:
	for key in library.data.constants:
		if not key.ends_with(":[[B"): continue
		var v = library.data.constants[key]
		if v is Array and v.size() >= 10 and v.size() <= 14 and v[0] is Array and v[0].size() == 5 and int(v[0][0]) > 4:
			return v
	return []

## A random face for a character of a race, the original's way.
static func random_face(library, male: bool, race: int, rng: RandomNumberGenerator) -> Array:
	var table := variant_table(library)
	if table.is_empty(): return []
	var set := race
	if set == 3: set = 0 if rng.randi_range(0, 3) == 0 else 2
	if not male and set == 0: set = 10
	if set < 0 or set >= table.size(): return []
	var n: int = table[set].size() + (0 if set == 0 else 1)
	if set == 5: set = 0
	var counts: Array = table[set]
	var face: Array = [set]
	for i in range(1, n):
		var c: int = int(counts[i - 1]) if i - 1 < counts.size() else 1
		face.append(rng.randi_range(0, maxi(0, c - 1)))
	return face

static func make(library, speaker: int, face: Array, factor := 2.0) -> Control:
	var record := face
	if record.is_empty() and speaker >= 0: record = speaker_face(library, speaker)
	var box := Panel.new()
	box.custom_minimum_size = FRAME * factor
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 0.6)
	style.border_color = UI.BORDER
	style.set_border_width_all(2)
	box.add_theme_stylebox_override("panel", style)
	if record.size() < 2: return box
	var set := int(record[0])
	for i in range(1, record.size()):
		var variant := int(record[i])
		if variant < 0: continue
		var tex: Texture2D = library.face("%d_%d_%d" % [set, i - 1, variant])
		if tex == null: continue
		var r := TextureRect.new()
		r.texture = tex
		r.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		r.position = Vector2(factor, factor)
		r.size = tex.get_size() * factor
		box.add_child(r)
	return box
