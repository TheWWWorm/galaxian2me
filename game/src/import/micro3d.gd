# Copyright 2020 Yury Kharchenko
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy at http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.
# Modified: GDScript data-only port of J2ME-Loader's Loader/Action (by way of the
# Abyssal engine's Python port), with bounded parsing and dictionary output.
extends RefCounted
## Mascot Capsule v3 MBAC (model) and MTRA (animation) decoder. Pure data; the
## output is plain arrays and dictionaries that the importer stores as JSON.

class Reader:
	var data: PackedByteArray
	var pos := 0
	var cache := 0
	var cached := 0
	var error := ""

	func _init(bytes: PackedByteArray) -> void:
		data = bytes

	func fail(message: String) -> void:
		if error.is_empty(): error = message

	func u8() -> int:
		if pos + 1 > data.size():
			fail("Truncated Micro3D resource"); return 0
		pos += 1
		return data[pos - 1]

	func u16() -> int:
		if pos + 2 > data.size():
			fail("Truncated Micro3D resource"); return 0
		var v := data.decode_u16(pos)
		pos += 2
		return v

	func s16() -> int:
		if pos + 2 > data.size():
			fail("Truncated Micro3D resource"); return 0
		var v := data.decode_s16(pos)
		pos += 2
		return v

	func i32() -> int:
		if pos + 4 > data.size():
			fail("Truncated Micro3D resource"); return 0
		var v := data.decode_s32(pos)
		pos += 4
		return v

	func skip(count: int) -> void:
		if pos + count > data.size(): fail("Truncated Micro3D resource")
		pos = mini(pos + count, data.size())

	func bits(count: int, signed := false) -> int:
		while cached < count:
			cache |= u8() << cached
			cached += 8
		var value := cache & ((1 << count) - 1)
		cache >>= count
		cached -= count
		if signed and count > 0 and value & (1 << (count - 1)):
			return value - (1 << count)
		return value

	func align() -> void:
		cache = 0
		cached = 0

	func matrix() -> Array:
		var m: Array = []
		for i in 12:
			var v := s16()
			m.append(float(v) if i % 4 == 3 else float(v) / 4096.0)
		return m

	func header(magic: String) -> int:
		var a := u8()
		var b := u8()
		if a != magic.unicode_at(0) or b != magic.unicode_at(1):
			fail("Invalid Micro3D signature"); return 0
		var version := u8()
		if u8() != 0 or version < 2 or version > 5:
			fail("Unsupported Micro3D version"); return 0
		return version


static func _polygon(indices: Array, attrs: Array, material: int, face: int, nv: int, r: Reader) -> Dictionary:
	for i in indices:
		if i >= nv: r.fail("Vertex index outside model")
	var order: Array = [0, 1, 2] if indices.size() == 3 else [0, 1, 2, 2, 1, 3]
	var out_indices: Array = []
	var out_attrs: Array = []
	for i in order:
		out_indices.append(indices[i])
		for v in attrs[i]: out_attrs.append(int(v) & 255)
	return {"indices": out_indices, "attributes": out_attrs, "texture": face, "pattern": 0,
		"blend": material & 6, "double_sided": bool(material & 16)}


## Decodes an MBAC model. Returns {} and sets `error` in the returned dictionary on failure.
static func model(bytes: PackedByteArray) -> Dictionary:
	var r := Reader.new(bytes)
	var version := r.header("MB")
	if not r.error.is_empty(): return {"error": r.error}
	var vf := 1; var nf := 0; var pf := 1; var bf := 1
	if version > 3:
		vf = r.u8(); nf = r.u8(); pf = r.u8(); bf = r.u8()
	var nv := r.u16(); var t3 := r.u16(); var t4 := r.u16(); var nb := r.u16()
	var c3 := 0; var c4 := 0; var nt := 1; var np := 1; var nc := 0
	if pf >= 3:
		c3 = r.u16(); c4 = r.u16(); nt = r.u16(); np = r.u16(); nc = r.u16()
	if bf != 1 or nv > 21845 or nb > nv or nt > 16 or np < 1 or np > 33 or nc > 256:
		return {"error": "Invalid model dimensions"}
	var patterns: Array = []
	if version == 5:
		for _p in np:
			var groups: Array = []
			for _t in nt + 1: groups.append([r.u16(), r.u16()])
			patterns.append(groups)
	else:
		patterns = [[[c3, c4], [t3, t4]]]
	var vertices := PackedInt32Array()
	if vf == 1:
		for _i in nv * 3: vertices.append(r.s16())
	elif vf == 2:
		var widths := [8, 10, 13, 16]
		while vertices.size() < nv * 3 and r.error.is_empty():
			var chunk := r.bits(8)
			var count := ((chunk & 63) + 1) * 3
			if vertices.size() + count > nv * 3: return {"error": "Oversized vertex block"}
			var w: int = widths[chunk >> 6]
			for _i in count: vertices.append(r.bits(w, true))
	else:
		return {"error": "Unsupported vertex encoding"}
	r.align()
	var normals := PackedInt32Array()
	if nf == 1:
		for _i in nv * 3: normals.append(r.s16())
	elif nf == 2:
		var table := [0, 0, 64, 0, 0, -64, 0, 0]
		for _i in nv:
			var x := r.bits(7)
			var y := 0; var z := 0
			if x == 64:
				var kind := r.bits(3)
				if kind > 5: return {"error": "Invalid normal"}
				z = table[kind]; y = table[kind + 1]; x = table[kind + 2]
			else:
				if x & 64: x -= 128
				y = r.bits(7, true)
				var sign := r.bits(1)
				z = int(floor(sqrt(maxf(0.0, 4096.0 - x * x - y * y)) + 0.5)) * (-1 if sign else 1)
			normals.append(x); normals.append(y); normals.append(z)
	elif nf != 0:
		return {"error": "Unsupported normal encoding"}
	r.align()
	var colored: Array = []
	var textured: Array = []
	if c3 + c4 > 0:
		var mb := r.u8(); var ib := r.u8(); var cb := r.u8(); var ci := r.u8(); r.u8()
		var palette: Array = []
		for _i in nc: palette.append([r.bits(cb), r.bits(cb), r.bits(cb)])
		for i in c3 + c4:
			var m := r.bits(mb) << 1
			if m & 0xFC09: return {"error": "Invalid colored material"}
			var indices: Array = []
			for _k in (3 if i < c3 else 4): indices.append(r.bits(ib))
			var color := r.bits(ci)
			if color >= nc: return {"error": "Invalid palette index"}
			var attr: Array = palette[color] + [(m & 32) >> 5, (m & 64) >> 6]
			var attrs: Array = []
			for _k in indices.size(): attrs.append(attr)
			colored.append(_polygon(indices, attrs, m, -1, nv, r))
	if t3 + t4 > 0:
		var mb := 0; var ib := 0; var uv := 7
		if pf == 2:
			mb = r.u8(); ib = r.u8()
		elif pf == 3:
			mb = r.bits(8); ib = r.bits(8); uv = r.bits(8); r.bits(8)
		elif pf != 1:
			return {"error": "Unsupported polygon encoding"}
		for i in t3 + t4:
			var count := 3 if i < t3 else 4
			var indices: Array = []
			var attrs: Array = []
			var m := 0
			if pf == 1:
				m = r.u16()
				if m & (0xFFF9 if count == 3 else 0xFFF8) or (count == 4 and not (m & 1)):
					return {"error": "Invalid material"}
				for _k in count: indices.append(r.u16())
				m = (m & 4) << 2 | (m & 2) >> 1
				for _k in count: attrs.append([r.u8(), r.u8(), 1, 0, m & 1])
			else:
				m = r.bits(mb)
				if m & (0xFF88 if pf == 2 else 0xFC08): return {"error": "Invalid material"}
				for _k in count: indices.append(r.bits(ib))
				for _k in count: attrs.append([r.bits(uv), r.bits(uv), (m & 32) >> 5, (m & 64) >> 6, m & 1])
			textured.append(_polygon(indices, attrs, m, -1, nv, r))
	r.align()
	var cursor := [0, c3, 0, t3]
	for i in patterns.size():
		var pattern := 0 if i == 0 else 1 << (i % 32)
		if pattern >= 2147483648: pattern -= 4294967296
		var groups: Array = patterns[i]
		for face in groups.size():
			var polys: Array = colored if face == 0 else textured
			var counts: Array = groups[face]
			for kind in counts.size():
				var slot: int = kind + (0 if face == 0 else 2)
				for _c in int(counts[kind]):
					if cursor[slot] >= polys.size(): return {"error": "Invalid pattern counts"}
					var p: Dictionary = polys[cursor[slot]]
					p.pattern = pattern
					if face: p.texture = face - 1
					cursor[slot] += 1
	var bones: Array = []
	var total := 0
	for i in nb:
		var count := r.u16(); var parent := r.s16()
		if parent < -1 or parent >= i: return {"error": "Invalid bone parent"}
		bones.append({"vertices": count, "parent": parent, "matrix": r.matrix()})
		total += count
	if total != nv: return {"error": "Invalid bone vertex blocks"}
	if not r.error.is_empty(): return {"error": r.error}
	return {"vertices": Array(vertices), "normals": Array(normals), "polygons": textured + colored,
		"bones": bones, "patterns": np}


const IDENTITY := [1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0]

static func _sample(track: Array, frame: int) -> Array:
	if frame >= int(track[-1][0]): return track[-1][1]
	for i in range(track.size() - 2, -1, -1):
		var key: int = track[i][0]
		if frame < key: continue
		var next_key: int = track[i + 1][0]
		var amount := float(frame - key) / float(next_key - key)
		var out: Array = []
		var a: Array = track[i][1]
		var b: Array = track[i + 1][1]
		for k in a.size(): out.append(a[k] + (b[k] - a[k]) * amount)
		return out
	var zero: Array = []
	zero.resize(track[0][1].size()); zero.fill(0.0)
	return zero

static func _bone_matrix(bone: Dictionary, frame: int) -> Array:
	if bone.has("matrix"): return bone.matrix.duplicate()
	var m: Array = IDENTITY.duplicate()
	if bone.has("translate"):
		var t := _sample(bone.translate, frame)
		m[3] = t[0]; m[7] = t[1]; m[11] = t[2]
	var rot := _sample(bone.rotate, frame)
	var x: float = rot[0]; var y: float = rot[1]; var z: float = rot[2]
	if x == 0.0 and y == 0.0:
		if z < 0.0:
			m[5] = -1.0; m[10] = -1.0
	else:
		var length := sqrt(x * x + y * y + z * z)
		x /= length; y /= length; z /= length
		length = sqrt(x * x + y * y)
		var rx := -y / length; var ry := x / length
		var s := sqrt(maxf(0.0, 1.0 - z * z)); var nc := 1.0 - z
		m[0] = rx * rx * nc + z; m[1] = rx * ry * nc; m[2] = ry * s
		m[4] = rx * ry * nc; m[5] = ry * ry * nc + z; m[6] = -rx * s
		m[8] = -ry * s; m[9] = rx * s; m[10] = z
	if bone.has("roll"):
		var angle: float = _sample(bone.roll, frame)[0]
		var c := cos(angle); var sn := sin(angle)
		for row in [0, 4, 8]:
			var a: float = m[row]; var b: float = m[row + 1]
			m[row] = a * c + b * sn; m[row + 1] = b * c - a * sn
	if bone.has("scale"):
		var sc := _sample(bone.scale, frame)
		for row in [0, 4, 8]:
			for col in 3: m[row + col] *= sc[col]
	return m


static func _track(r: Reader, width := 3, factor := 1.0) -> Array:
	var count := r.u16()
	if count < 1 or count > 4096:
		r.fail("Invalid animation track"); return [[0, [0.0, 0.0, 0.0].slice(0, width)]]
	var values: Array = []
	for _i in count:
		var key := r.u16()
		var v: Array = []
		for _k in width: v.append(r.s16() * factor)
		values.append([key, v])
	for i in values.size() - 1:
		if values[i][0] >= values[i + 1][0]: r.fail("Unsorted animation track")
	return values


## Decodes an MTRA action table into per-frame bone matrices.
static func animation(bytes: PackedByteArray) -> Dictionary:
	var r := Reader.new(bytes)
	var version := r.header("MT")
	if not r.error.is_empty(): return {"error": r.error}
	var actions := r.u16(); var nb := r.u16()
	r.skip(20)
	if actions > 256 or nb > 256: return {"error": "Animation exceeds limits"}
	var out: Array = []
	var total := 0
	for _a in actions:
		var last := r.u16()
		total += (last + 1) * nb * 12
		if total > 4000000: return {"error": "Animation exceeds limits"}
		var bones: Array = []
		for _b in nb:
			var kind := r.u8()
			var bone := {}
			if kind == 0: bone.matrix = r.matrix()
			elif kind == 1: bone.matrix = IDENTITY.duplicate()
			elif kind in [2, 3, 4, 5, 6]:
				if kind == 2 or kind == 6: bone.translate = _track(r)
				if kind == 3: bone.translate = [[0, [r.s16(), r.s16(), r.s16()]]]
				if kind == 2: bone.scale = _track(r, 3, 1.0 / 4096.0)
				bone.rotate = _track(r)
				if kind == 3: bone.roll = [[0, [r.s16() * TAU / 4096.0]]]
				elif kind != 5: bone.roll = _track(r, 1, TAU / 4096.0)
			else:
				return {"error": "Unsupported animation bone"}
			if not r.error.is_empty(): return {"error": r.error}
			bones.append(bone)
		var patterns := {}
		if version == 5:
			for _p in r.u16():
				var key := str(r.u16())
				patterns[key] = r.i32()
		var frames: Array = []
		for f in last + 1:
			var row: Array = []
			for bone in bones: row.append_array(_bone_matrix(bone, f))
			frames.append(row)
		out.append({"last_frame": last, "matrices": frames, "patterns": patterns})
	if not r.error.is_empty(): return {"error": r.error}
	return {"actions": out}
