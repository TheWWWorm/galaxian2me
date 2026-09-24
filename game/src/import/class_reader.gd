extends RefCounted
## Class-file reader for recovering constant data from the supplied MIDlet,
## implemented from the JVM specification. It never loads or runs a class: it
## parses the constant pool and member tables, and a bounded evaluator follows
## static initializers far enough to read literal arrays and registration
## calls. Unsupported operations stop the evaluation with an error.

var name := ""
var pool: Array = []          # [tag, value] per constant-pool index
var fields := {}              # "name:desc" -> {flags, attributes}
var methods := {}             # "name:desc" -> {flags, attributes}
var error := ""

class Bytes:
	var data: PackedByteArray
	var pos := 0
	var bad := false
	func _init(b: PackedByteArray) -> void: data = b
	func u1() -> int:
		if pos >= data.size(): bad = true; return 0
		pos += 1; return data[pos - 1]
	func u2() -> int: return (u1() << 8) | u1()
	func u4() -> int: return (u2() << 16) | u2()
	func s1() -> int:
		var v := u1(); return v - 256 if v > 127 else v
	func s2() -> int:
		var v := u2(); return v - 65536 if v > 32767 else v
	func s4() -> int:
		var v := u4(); return v - 4294967296 if v > 2147483647 else v
	func take(n: int) -> PackedByteArray:
		if pos + n > data.size(): bad = true; pos = data.size(); return PackedByteArray()
		pos += n; return data.slice(pos - n, pos)


static func parse(bytes: PackedByteArray) -> RefCounted:
	var c = load("res://src/import/class_reader.gd").new()
	c._parse(bytes)
	return c

func _parse(bytes: PackedByteArray) -> void:
	var r := Bytes.new(bytes)
	if r.u4() != 0xCAFEBABE:
		error = "Invalid class magic"; return
	r.u2(); r.u2()
	var count := r.u2()
	pool.resize(count)
	var i := 1
	while i < count and not r.bad:
		var tag := r.u1()
		var value = null
		match tag:
			1: value = _utf(r.take(r.u2()))
			3: value = r.s4()
			4:
				var raw := r.take(4); raw.reverse(); value = raw.decode_float(0)
			5:
				var hi := r.u4(); var lo := r.u4(); value = (hi << 32) | lo
			6:
				var raw := r.take(8); raw.reverse(); value = raw.decode_double(0)
			7, 8, 16: value = r.u2()
			9, 10, 11, 12: value = [r.u2(), r.u2()]
			_:
				error = "Unsupported constant tag %d" % tag; return
		pool[i] = [tag, value]
		i += 2 if tag in [5, 6] else 1
	r.u2()
	name = constant(r.u2())
	r.u2()
	r.take(r.u2() * 2)
	fields = _members(r)
	methods = _members(r)
	_attributes(r)
	if r.bad: error = "Truncated class data"

static func _utf(raw: PackedByteArray) -> String:
	var out := ""
	var i := 0
	while i < raw.size():
		var c := raw[i]
		if c < 0x80: out += char(c); i += 1
		elif c & 0xE0 == 0xC0 and i + 1 < raw.size():
			out += char(((c & 0x1F) << 6) | (raw[i + 1] & 0x3F)); i += 2
		elif i + 2 < raw.size():
			out += char(((c & 0x0F) << 12) | ((raw[i + 1] & 0x3F) << 6) | (raw[i + 2] & 0x3F)); i += 3
		else: i += 1
	return out

func constant(index: int):
	if index <= 0 or index >= pool.size() or pool[index] == null: return null
	var entry: Array = pool[index]
	if entry[0] in [7, 8]: return constant(entry[1])
	return entry[1]

## [owner, member name, descriptor] of a field or method reference.
func member_ref(index: int) -> Array:
	var pair = constant(index)
	if pair == null: return ["", "", ""]
	var nt = constant(pair[1])
	return [constant(pair[0]), constant(nt[0]), constant(nt[1])]

func _attributes(r: Bytes) -> Dictionary:
	var out := {}
	for _i in r.u2():
		var key = constant(r.u2())
		out[key] = r.take(r.u4())
	return out

func _members(r: Bytes) -> Dictionary:
	var out := {}
	for _i in r.u2():
		var flags := r.u2()
		var n = constant(r.u2())
		var d = constant(r.u2())
		out[str(n) + ":" + str(d)] = {"flags": flags, "attributes": _attributes(r)}
	return out

func code(key: String) -> PackedByteArray:
	if not methods.has(key) or not methods[key].attributes.has("Code"): return PackedByteArray()
	var r := Bytes.new(methods[key].attributes.Code)
	r.u2(); r.u2()
	return r.take(r.u4())

func method_keys() -> Array:
	return methods.keys()

func strings() -> PackedStringArray:
	var out := PackedStringArray()
	for e in pool:
		if e != null and e[0] == 8: out.append(constant(e[1]))
	return out

static func argument_count(desc: String) -> int:
	var count := 0
	var i := 1
	while i < desc.length() and desc[i] != ")":
		while desc[i] == "[": i += 1
		if desc[i] == "L": i = desc.find(";", i)
		count += 1
		i += 1
	return count


## Evaluates a method body over plain values: ints, floats, strings, arrays and
## null. Static reads come from `statics` (missing ones read as null), static
## writes go into it. Every invocation is handed to `on_call(owner, name, desc,
## args)`, whose return value is pushed for non-void methods. Branches are
## followed; a budget bounds the work. Returns {"error": ...} on anything else.
func evaluate(key: String, statics: Dictionary, on_call: Callable, budget := 400000, initial: Array = []) -> Dictionary:
	var body := code(key)
	if body.is_empty(): return {"error": "No code for " + name + "." + key}
	var r := Bytes.new(body)
	var locals: Array = []
	locals.resize(256)
	for i in initial.size(): locals[i] = initial[i]
	var stack: Array = []
	for _step in budget:
		if r.pos >= body.size(): return {"error": "Ran off the end of " + key}
		var start := r.pos
		var op := r.u1()
		if op == 0: pass
		elif op == 1: stack.append(null)
		elif op >= 2 and op <= 8: stack.append(op - 3)
		elif op == 9 or op == 10: stack.append(op - 9)
		elif op >= 11 and op <= 13: stack.append(float(op - 11))
		elif op == 14 or op == 15: stack.append(float(op - 14))
		elif op == 16: stack.append(r.s1())
		elif op == 17: stack.append(r.s2())
		elif op == 18: stack.append(constant(r.u1()))
		elif op == 19 or op == 20: stack.append(constant(r.u2()))
		elif op >= 21 and op <= 25: stack.append(locals[r.u1()])
		elif op >= 26 and op <= 45: stack.append(locals[(op - 26) % 4])
		elif op >= 46 and op <= 53:
			var index = stack.pop_back(); var array = stack.pop_back()
			if not (array is Array) or not (index is int) or index < 0 or index >= array.size():
				return {"error": "Invalid array read at %d" % start}
			stack.append(array[index])
		elif op >= 54 and op <= 58: locals[r.u1()] = stack.pop_back()
		elif op >= 59 and op <= 78: locals[(op - 59) % 4] = stack.pop_back()
		elif op >= 79 and op <= 86:
			var value = stack.pop_back(); var index = stack.pop_back(); var array = stack.pop_back()
			if not (array is Array) or not (index is int) or index < 0 or index >= array.size():
				return {"error": "Invalid array write at %d" % start}
			array[index] = value
		elif op == 87: stack.pop_back()
		elif op == 88: stack.pop_back(); stack.pop_back()
		elif op == 89: stack.append(stack[-1])
		elif op == 90:
			var a = stack.pop_back(); var b = stack.pop_back(); stack.append_array([a, b, a])
		elif op == 91:
			var a = stack.pop_back(); var b = stack.pop_back(); var c = stack.pop_back(); stack.append_array([a, c, b, a])
		elif op == 92: stack.append_array([stack[-2], stack[-1]])
		elif op == 95:
			var a = stack.pop_back(); var b = stack.pop_back(); stack.append_array([a, b])
		elif op in [96, 98, 100, 102, 104, 106, 108, 110, 112, 120, 122, 124, 126, 128, 130]:
			var b = stack.pop_back(); var a = stack.pop_back()
			if _symbolic(a) or _symbolic(b):
				stack.append({"expr": [op, a, b]})
				continue
			if not (a is int or a is float) or not (b is int or b is float):
				return {"error": "Arithmetic on non-number at %d" % start}
			var v = 0
			match op:
				96, 98: v = a + b
				100, 102: v = a - b
				104, 106: v = a * b
				108, 110:
					if b == 0: return {"error": "Division by zero"}
					v = a / b if op == 110 else int(a / b)
				112: v = a - int(a / b) * b
				120: v = a << (b & 31)
				122: v = a >> (b & 31)
				124: v = (a & 0xFFFFFFFF) >> (b & 31)
				126: v = a & b
				128: v = a | b
				130: v = a ^ b
			if v is int: v = ((v + 2147483648) % 4294967296 + 4294967296) % 4294967296 - 2147483648
			stack.append(v)
		elif op == 116 or op == 118:
			var v = stack.pop_back()
			stack.append({"expr": [104, v, -1]} if _symbolic(v) else (-v if (v is int or v is float) else v))
		elif op == 132:
			var index := r.u1(); locals[index] = int(locals[index]) + r.s1()
		elif op in [133, 136, 139, 142, 134, 135, 137, 138, 141]:
			var v = stack.pop_back()
			if _symbolic(v) or v == null: stack.append(v)
			elif op in [133, 136, 139, 142]: stack.append(int(v))
			else: stack.append(float(v))
		elif op in [145, 146, 147]:
			var raw = stack.pop_back()
			if not (raw is int or raw is float):
				stack.append(raw)
				continue
			var v := int(raw)
			if op == 146: v &= 0xFFFF
			elif op == 145: v = ((v & 0xFF) ^ 0x80) - 0x80
			else: v = ((v & 0xFFFF) ^ 0x8000) - 0x8000
			stack.append(v)
		elif op >= 153 and op <= 164:
			var offset := r.s2()
			var b = 0 if op <= 158 else stack.pop_back()
			var a = stack.pop_back()
			if not (a is int or a is float) or not (b is int or b is float):
				return {"error": "Branch on unknown value at %d" % start}
			var kind := (op - 153) % 6
			var taken: bool = [a == b, a != b, a < b, a >= b, a > b, a <= b][kind]
			if taken: r.pos = start + offset
		elif op == 165 or op == 166:
			var offset := r.s2(); var b = stack.pop_back(); var a = stack.pop_back()
			if is_same(a, b) == (op == 165): r.pos = start + offset
		elif op == 167: r.pos = start + r.s2()
		elif op == 170 or op == 171:
			while r.pos % 4 != 0: r.u1()
			var fallback := r.s4()
			var target := -1
			var selector = stack.pop_back()
			if not (selector is int): return {"error": "Switch on unknown value at %d" % start}
			if op == 170:
				var low := r.s4(); var high := r.s4()
				if high - low > 10000: return {"error": "Oversized switch"}
				for k in range(low, high + 1):
					var off := r.s4()
					if k == selector: target = off
			else:
				var count := r.s4()
				if count < 0 or count > 10000: return {"error": "Oversized switch"}
				for _k in count:
					var match_key := r.s4(); var off := r.s4()
					if match_key == selector: target = off
			r.pos = start + (fallback if target == -1 else target)
		elif op >= 172 and op <= 176: return {"value": stack.pop_back()}
		elif op == 177: return {"value": null}
		elif op == 178 or op == 179:
			var ref := member_ref(r.u2())
			var k := str(ref[0]) + "." + str(ref[1]) + ":" + str(ref[2])
			if op == 178:
				if statics.has(k): stack.append(statics[k])
				else:
					# A primitive static the initializers never set is a value
					# only known at run time: carry it symbolically.
					var d := str(ref[2])
					stack.append({"static": k} if d.length() == 1 else null)
			else: statics[k] = stack.pop_back()
		elif op == 180:
			# Inert records: objects built during evaluation are dictionaries.
			var ref := member_ref(r.u2())
			var obj = stack.pop_back()
			stack.append(obj.get(str(ref[1]) + ":" + str(ref[2])) if obj is Dictionary else null)
		elif op == 181:
			var ref := member_ref(r.u2())
			var value = stack.pop_back(); var obj = stack.pop_back()
			if obj is Dictionary: obj[str(ref[1]) + ":" + str(ref[2])] = value
		elif op >= 182 and op <= 185:
			var ref := member_ref(r.u2())
			if op == 185: r.u2()
			var argc := argument_count(ref[2])
			var args: Array = []
			if argc > 0:
				args = stack.slice(stack.size() - argc)
				stack.resize(stack.size() - argc)
			var target = null
			if op != 184: target = stack.pop_back()
			var result = on_call.call(ref[0], ref[1], ref[2], args, target)
			if result is Dictionary and result.has("error"): return result
			if not str(ref[2]).ends_with("V"): stack.append(result)
		elif op == 187: stack.append({"new": constant(r.u2())})
		elif op == 188 or op == 189:
			var array_type := r.u1() if op == 188 else r.u2()
			var count = stack.pop_back()
			if not (count is int) or count < 0 or count > 100000: return {"error": "Oversized array"}
			var array: Array = []
			array.resize(count)
			var fill = null
			if op == 188: fill = 0.0 if array_type in [6, 7] else 0
			array.fill(fill)
			stack.append(array)
		elif op == 197:
			r.u2()
			var dims := r.u1()
			var counts: Array = []
			for _d in dims: counts.push_front(stack.pop_back())
			stack.append(_multi_array(counts, 0))
		elif op == 190:
			var a = stack.pop_back()
			stack.append(a.size() if a is Array else 0)
		elif op == 192: r.u2()
		elif op == 198 or op == 199:
			var offset := r.s2(); var v = stack.pop_back()
			if (v == null) == (op == 198): r.pos = start + offset
		else:
			return {"error": "Unsupported opcode 0x%02x in %s.%s at %d" % [op, name, key, start]}
	return {"error": "Evaluation budget exceeded in " + name + "." + key}

static func _symbolic(v) -> bool:
	return v is Dictionary and (v.has("static") or v.has("expr"))

static func _multi_array(counts: Array, depth: int) -> Array:
	var out: Array = []
	var n: int = counts[depth]
	out.resize(n)
	if depth + 1 < counts.size():
		for i in n: out[i] = _multi_array(counts, depth + 1)
	else:
		out.fill(0)
	return out
