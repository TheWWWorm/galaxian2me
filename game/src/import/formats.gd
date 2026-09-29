extends RefCounted
## Readers for the resource formats a Galaxy on Fire 2 MIDlet stores: the byte
## envelope around its PNG files, 8-bit BMP textures, the string table and the
## big-endian record files under data/txt. Nothing here executes game code.

## Big-endian reader with the semantics of java.io.DataInputStream.
class DataReader:
	var data: PackedByteArray
	var pos := 0
	var error := ""

	func _init(bytes: PackedByteArray) -> void:
		data = bytes

	func left() -> int:
		return data.size() - pos

	func _need(count: int) -> bool:
		if pos + count > data.size():
			if error.is_empty(): error = "Truncated record at byte %d" % pos
			return false
		return true

	func s8() -> int:
		if not _need(1): return 0
		var v := data[pos]
		pos += 1
		return v - 256 if v > 127 else v

	func s16() -> int:
		if not _need(2): return 0
		var v := (data[pos] << 8) | data[pos + 1]
		pos += 2
		return v - 65536 if v > 32767 else v

	func u16() -> int:
		if not _need(2): return 0
		var v := (data[pos] << 8) | data[pos + 1]
		pos += 2
		return v

	func s32() -> int:
		if not _need(4): return 0
		var v := (data[pos] << 24) | (data[pos + 1] << 16) | (data[pos + 2] << 8) | data[pos + 3]
		pos += 4
		return v - 4294967296 if v > 2147483647 else v

	func utf() -> String:
		var n := u16()
		if not _need(n): return ""
		var s := _modified_utf8(data.slice(pos, pos + n))
		pos += n
		return s

	## Java's modified UTF-8: like UTF-8, with NUL written as C0 80.
	static func _modified_utf8(bytes: PackedByteArray) -> String:
		var out := ""
		var i := 0
		while i < bytes.size():
			var c := bytes[i]
			if c < 0x80:
				out += char(c); i += 1
			elif c & 0xE0 == 0xC0 and i + 1 < bytes.size():
				out += char(((c & 0x1F) << 6) | (bytes[i + 1] & 0x3F)); i += 2
			elif c & 0xF0 == 0xE0 and i + 2 < bytes.size():
				out += char(((c & 0x0F) << 12) | ((bytes[i + 1] & 0x3F) << 6) | (bytes[i + 2] & 0x3F)); i += 3
			else:
				out += "?"; i += 1
		return out


## Fishlabs resources swap a size-dependent number of bytes between the start
## and end of the file. Swapping them again restores the original bytes.
static func unwrap(bytes: PackedByteArray) -> PackedByteArray:
	var data := bytes.duplicate()
	var n := data.size()
	var count := 0
	if n < 100: count = 10 + n % 10
	elif n < 200: count = 50 + n % 20
	elif n < 300: count = 80 + n % 20
	else: count = 100 + n % 50
	if n < count: return PackedByteArray()
	for i in count:
		var a := data[i]
		data[i] = data[n - 1 - i]
		data[n - 1 - i] = a
	return data

static func is_png(bytes: PackedByteArray) -> bool:
	return bytes.size() > 8 and bytes[0] == 0x89 and bytes[1] == 0x50 and bytes[2] == 0x4E and bytes[3] == 0x47

## A PNG as stored in the archive: some are plain, most wear the envelope.
static func png_image(bytes: PackedByteArray) -> Image:
	var data := bytes if is_png(bytes) else unwrap(bytes)
	if not is_png(data): return null
	var img := Image.new()
	if img.load_png_from_buffer(data) != OK: return null
	return img

## Uncompressed 8-bit indexed BMP, as the textures use. Palette index 0 is the
## colour-key the renderer treats as transparent on alpha polygons; the image
## keeps it opaque and the material keys it out.
static func bmp_image(bytes: PackedByteArray) -> Image:
	if bytes.size() < 54 or bytes[0] != 0x42 or bytes[1] != 0x4D: return null
	var offset := bytes.decode_u32(10)
	var header := bytes.decode_u32(14)
	var width := bytes.decode_s32(18)
	var height := bytes.decode_s32(22)
	var planes := bytes.decode_u16(26)
	var bits := bytes.decode_u16(28)
	var compression := bytes.decode_u32(30)
	if header != 40 or planes != 1 or bits != 8 or compression != 0: return null
	if width <= 0 or width > 4096 or height == 0 or absi(height) > 4096: return null
	var colors := bytes.decode_u32(46)
	if colors == 0: colors = 256
	if colors > 256 or offset < 54 + colors * 4: return null
	var stride := (width + 3) / 4 * 4
	var rows := absi(height)
	if offset + rows * stride > bytes.size(): return null
	var pixels := PackedByteArray()
	pixels.resize(width * rows * 4)
	for y in rows:
		var src := offset + ((rows - 1 - y) if height > 0 else y) * stride
		for x in width:
			var index := bytes[src + x]
			if index >= colors: return null
			var p := 54 + index * 4
			var d := (y * width + x) * 4
			pixels[d] = bytes[p + 2]
			pixels[d + 1] = bytes[p + 1]
			pixels[d + 2] = bytes[p]
			pixels[d + 3] = 0 if index == 0 else 255
	return Image.create_from_data(width, rows, false, Image.FORMAT_RGBA8, pixels)

## A .lang file is a flat run of DataInputStream UTF strings.
static func lang_strings(bytes: PackedByteArray) -> PackedStringArray:
	var r := DataReader.new(bytes)
	var out := PackedStringArray()
	while r.left() > 1 and r.error.is_empty():
		out.append(r.utf())
	return out


## data/txt record files. Each reader returns plain arrays of dictionaries and
## reports trailing or missing bytes as an error, so a differently laid out
## build is refused rather than misread.
static func _checked(r: DataReader, value, name: String) -> Dictionary:
	if not r.error.is_empty(): return {"error": name + ": " + r.error}
	if r.left() != 0: return {"error": name + ": %d unexpected trailing bytes" % r.left()}
	return {"value": value}

static func stations(bytes: PackedByteArray) -> Dictionary:
	var r := DataReader.new(bytes)
	var out: Array = []
	while r.left() > 0 and r.error.is_empty():
		out.append({"name": r.utf(), "id": r.s32(), "system": r.s32(), "tech": r.s32(), "planet": r.s32()})
	return _checked(r, out, "stations.bin")

static func _int_list(r: DataReader) -> Array:
	var n := r.s32()
	var out: Array = []
	if n > 4096:
		r.error = "Implausible list length"; return out
	for _i in maxi(n, 0): out.append(r.s32())
	return out

static func systems(bytes: PackedByteArray) -> Dictionary:
	var r := DataReader.new(bytes)
	var out: Array = []
	while r.left() > 0 and r.error.is_empty():
		var s := {"name": r.utf(), "safety": r.s32(), "visible": r.s32() == 1, "faction": r.s32(),
			"x": r.s32(), "y": r.s32(), "z": r.s32(), "jumpgate_station": r.s32(), "star": r.s32()}
		s.color = _int_list(r)
		s.stations = _int_list(r)
		s.links = _int_list(r)
		s.extra = _int_list(r)
		out.append(s)
	return _checked(r, out, "systems.bin")

static func items(bytes: PackedByteArray) -> Dictionary:
	var r := DataReader.new(bytes)
	var out: Array = []
	while r.left() > 0 and r.error.is_empty():
		var ingredients := _int_list(r)
		var amounts := _int_list(r)
		var pairs := _int_list(r)
		var attributes := {}
		for i in range(0, pairs.size() - 1, 2): attributes[str(pairs[i])] = pairs[i + 1]
		out.append({"ingredients": ingredients, "amounts": amounts, "attributes": attributes})
	return _checked(r, out, "items.bin")

static func ships(bytes: PackedByteArray) -> Dictionary:
	var r := DataReader.new(bytes)
	var out: Array = []
	while r.left() > 0 and r.error.is_empty():
		out.append({"id": r.s32(), "armor": r.s32(), "cargo": r.s32(), "price": r.s32(),
			"primary": r.s32(), "secondary": r.s32(), "turret": r.s32(), "equipment": r.s32(),
			"handling": r.s32()})
	return _checked(r, out, "ships.bin")

static func agents(bytes: PackedByteArray) -> Dictionary:
	var r := DataReader.new(bytes)
	var out: Array = []
	while r.left() > 0 and r.error.is_empty():
		var a := {"name": r.utf(), "id": r.s32(), "station": r.s32(), "system": r.s32(), "race": r.s32(),
			"male": r.s32() == 1, "secret_system": r.s32(), "blueprint_item": r.s32(), "price": r.s32()}
		var n := r.s32()
		var face: Array = []
		for _i in maxi(n, 0): face.append(r.s8())
		a.face = face
		out.append(a)
	return _checked(r, out, "agents.bin")

static func ship_parts(bytes: PackedByteArray) -> Dictionary:
	var r := DataReader.new(bytes)
	var out := {}
	while r.left() > 0 and r.error.is_empty():
		var index := r.s8()
		var count := r.s8()
		var parts: Array = []
		for _i in maxi(count, 0):
			parts.append({"model": r.s16(), "position": [r.s32(), r.s32(), r.s32()],
				"rotation": [r.s16(), r.s16(), r.s16()], "scale": [r.s16(), r.s16(), r.s16()]})
		if not out.has(str(index - 1)): out[str(index - 1)] = parts
	return _checked(r, out, "shipparts.bin")

static func station_parts(bytes: PackedByteArray) -> Dictionary:
	var r := DataReader.new(bytes)
	var out := {}
	while r.left() > 0 and r.error.is_empty():
		var index := r.s8()
		var root := r.s16()
		var count := r.s8()
		var parts: Array = []
		for _i in maxi(count, 0):
			parts.append({"model": r.s16(), "position": [r.s32(), r.s32(), r.s32()],
				"rotation": [r.s16(), r.s16(), r.s16()]})
		if not out.has(str(index - 1)): out[str(index - 1)] = {"root": root, "parts": parts}
	return _checked(r, out, "stationparts.bin")

static func names(bytes: PackedByteArray) -> Dictionary:
	var r := DataReader.new(bytes)
	var n := r.s32()
	var out: Array = []
	for _i in maxi(n, 0): out.append(r.utf())
	return _checked(r, out, "names")

## RIFF WAVE with 8- or 16-bit PCM, as the sound effects are stored.
static func wav_info(bytes: PackedByteArray) -> Dictionary:
	if bytes.size() < 12 or bytes.slice(0, 4).get_string_from_ascii() != "RIFF" or bytes.slice(8, 12).get_string_from_ascii() != "WAVE":
		return {}
	var pos := 12
	var info := {}
	while pos + 8 <= bytes.size():
		var tag := bytes.slice(pos, pos + 4).get_string_from_ascii()
		var size := bytes.decode_u32(pos + 4)
		var body := pos + 8
		if tag == "fmt " and size >= 16:
			info.format = bytes.decode_u16(body)
			info.channels = bytes.decode_u16(body + 2)
			info.rate = bytes.decode_u32(body + 4)
			info.bits = bytes.decode_u16(body + 14)
		elif tag == "data":
			info.data = bytes.slice(body, mini(body + size, bytes.size()))
		pos = body + size + (size & 1)
	if not info.has("data") or info.get("format", 0) != 1 or not info.get("bits", 0) in [8, 16]:
		return {}
	return info
