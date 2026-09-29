extends RefCounted
## Material hints for enhanced lighting, inferred at run time from the
## player's own texture atlas. The albedo is never changed.
##
## R: height for fine relief (the texel's brightness, lightly blurred)
## G: roughness (bright, plain paint is smoother than dark, busy texels)
## B: emission — small bright islands on a darker surround, which is how the
##    atlas paints window rows, lamps and indicator lights. Broad bright
##    panels and the edges of large light areas are painted surfaces, not
##    lamps, so islands that are large or long are left unlit.
## A: metalness — bare grey plating is metal; saturated paint and dark
##    vents, rubber and glazing much less so

## A lamp is at most this many texels across and this many texels in all.
const LAMP_EXTENT := 8
const LAMP_TEXELS := 40

static func derive(source: Image) -> Image:
	var img := source.duplicate() as Image
	if img.is_compressed(): img.decompress()
	img.clear_mipmaps()
	img.convert(Image.FORMAT_RGBA8)
	var w := img.get_width()
	var h := img.get_height()
	var count := w * h
	var bytes := img.get_data()
	var value := PackedFloat32Array(); value.resize(count)
	var luma := PackedFloat32Array(); luma.resize(count)
	var saturation := PackedFloat32Array(); saturation.resize(count)
	for i in count:
		var r := bytes[i * 4] / 255.0
		var g := bytes[i * 4 + 1] / 255.0
		var b := bytes[i * 4 + 2] / 255.0
		var hi := maxf(r, maxf(g, b))
		value[i] = hi
		luma[i] = r * 0.2126 + g * 0.7152 + b * 0.0722
		saturation[i] = hi - minf(r, minf(g, b))
	var surround := _box(value, w, h, 3)
	var smooth := _box(luma, w, h, 1)
	# Candidate lamp texels: bright and clearly brighter than around them.
	var candidate := PackedByteArray(); candidate.resize(count)
	for i in count:
		if bytes[i * 4 + 3] >= 128 and value[i] > 0.62 and value[i] - surround[i] > 0.24:
			candidate[i] = 1
	var lamp := PackedFloat32Array(); lamp.resize(count)
	var seen := PackedByteArray(); seen.resize(count)
	var stack := PackedInt32Array()
	var island := PackedInt32Array()
	for first in count:
		if candidate[first] == 0 or seen[first] != 0: continue
		island.clear(); stack.clear()
		stack.append(first); seen[first] = 1
		var lo := Vector2i(first % w, first / w)
		var hi := lo
		while not stack.is_empty():
			var i: int = stack[stack.size() - 1]
			stack.remove_at(stack.size() - 1)
			island.append(i)
			var x := i % w
			var y := i / w
			lo = Vector2i(mini(lo.x, x), mini(lo.y, y))
			hi = Vector2i(maxi(hi.x, x), maxi(hi.y, y))
			for n in [i - 1 if x > 0 else -1, i + 1 if x < w - 1 else -1, i - w if y > 0 else -1, i + w if y < h - 1 else -1]:
				if n >= 0 and candidate[n] != 0 and seen[n] == 0:
					seen[n] = 1
					stack.append(n)
		var extent := hi - lo + Vector2i.ONE
		if island.size() > LAMP_TEXELS or maxi(extent.x, extent.y) > LAMP_EXTENT: continue
		for i in island:
			lamp[i] = clampf((value[i] - surround[i] - 0.24) * 4.0 + 0.45, 0.0, 1.0)
	var out := PackedByteArray(); out.resize(count * 4)
	for i in count:
		var rough := clampf(0.78 - luma[i] * 0.2 + saturation[i] * 0.1 + absf(luma[i] - smooth[i]) * 0.8, 0.5, 0.92)
		out[i * 4] = int(smooth[i] * 255.0)
		out[i * 4 + 1] = int(rough * 255.0)
		out[i * 4 + 2] = int(lamp[i] * 255.0)
		var metal := clampf(0.95 - saturation[i] * 2.4, 0.08, 0.9) * (0.35 + 0.65 * smoothstep(0.08, 0.45, luma[i]))
		out[i * 4 + 3] = int(metal * 255.0)
	var result := Image.create_from_data(w, h, false, Image.FORMAT_RGBA8, out)
	result.generate_mipmaps()
	return result

## Mean over a (2r+1)² square, clamped at the edges; separable.
static func _box(src: PackedFloat32Array, w: int, h: int, r: int) -> PackedFloat32Array:
	var tmp := PackedFloat32Array(); tmp.resize(src.size())
	var dst := PackedFloat32Array(); dst.resize(src.size())
	var k := 1.0 / float(2 * r + 1)
	for y in h:
		var row := y * w
		for x in w:
			var s := 0.0
			for d in range(-r, r + 1): s += src[row + clampi(x + d, 0, w - 1)]
			tmp[row + x] = s * k
	for y in h:
		for x in w:
			var s := 0.0
			for d in range(-r, r + 1): s += tmp[clampi(y + d, 0, h - 1) * w + x]
			dst[y * w + x] = s * k
	return dst
