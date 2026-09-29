extends RefCounted
## Small procedural MIDI renderer, ported from the Abyssal engine's browser
## converter. SMF 0/1, PPQN/SMPTE timing, running status, tempo, program,
## sustain, volume, expression and pan. Instruments approximate General MIDI
## families with additive tones; there are no instrument samples. The score is
## the player's own MIDI data; only the synthesis is engine code.

const RATE := 22050

static func notes(bytes: PackedByteArray) -> Dictionary:
	var pos := 0
	var n := bytes.size()
	if n < 14 or bytes.slice(0, 4).get_string_from_ascii() != "MThd": return {}
	var hlen := (bytes[4] << 24) | (bytes[5] << 16) | (bytes[6] << 8) | bytes[7]
	var format := (bytes[8] << 8) | bytes[9]
	var tracks := (bytes[10] << 8) | bytes[11]
	var division := (bytes[12] << 8) | bytes[13]
	if format > 1 or tracks == 0 or tracks > 128 or division == 0 or hlen < 6: return {}
	pos = 8 + hlen
	var events: Array = []
	var order := 0
	for _t in tracks:
		if pos + 8 > n or bytes.slice(pos, pos + 4).get_string_from_ascii() != "MTrk": return {}
		var size := (bytes[pos + 4] << 24) | (bytes[pos + 5] << 16) | (bytes[pos + 6] << 8) | bytes[pos + 7]
		pos += 8
		var end := mini(pos + size, n)
		var tick := 0
		var running := 0
		while pos < end:
			var delta := 0
			for _i in 4:
				var b := bytes[pos]; pos += 1
				delta = delta * 128 + (b & 127)
				if not (b & 128): break
			tick += delta
			if pos >= end: break
			var status := bytes[pos]; pos += 1
			if status < 128:
				if running == 0: return {}
				pos -= 1; status = running
			if status == 255:
				var kind := bytes[pos]; pos += 1
				var count := 0
				for _i in 4:
					var b := bytes[pos]; pos += 1
					count = count * 128 + (b & 127)
					if not (b & 128): break
				if kind == 81 and count == 3:
					events.append([tick, order, -1, 0, (bytes[pos] << 16) | (bytes[pos + 1] << 8) | bytes[pos + 2], 0])
					order += 1
				pos += count
				if kind == 47: pos = end; break
			elif status == 240 or status == 247:
				running = 0
				var count := 0
				for _i in 4:
					var b := bytes[pos]; pos += 1
					count = count * 128 + (b & 127)
					if not (b & 128): break
				pos += count
			else:
				if status >= 240: return {}
				running = status
				var kind := status >> 4
				var a := bytes[pos]; pos += 1
				var b := 0
				if kind != 12 and kind != 13:
					b = bytes[pos]; pos += 1
				events.append([tick, order, status & 15, kind, a, b])
				order += 1
			if events.size() > 200000: return {}
		pos = end
	events.sort_custom(func(x, y): return x[0] < y[0] or (x[0] == y[0] and x[1] < y[1]))
	var channels: Array = []
	for _c in 16:
		channels.append({"program": 0, "volume": 100, "expression": 127, "pan": 64, "sustain": false, "active": {}, "held": []})
	var out: Array = []
	var tick := 0
	var time := 0.0
	var tempo := 500000
	var smpte := division & 32768
	var fps := 256 - (division >> 8) if smpte else 0
	var rate := 30000.0 / 1001.0 if fps == 29 else float(fps)
	for e in events:
		if smpte: time += (e[0] - tick) / (rate * (division & 255))
		else: time += (e[0] - tick) * tempo / (division * 1e6)
		tick = e[0]
		if time > 600.0: return {}
		if e[2] == -1:
			tempo = e[4]; continue
		var c: Dictionary = channels[e[2]]
		var kind: int = e[3]
		var a: int = e[4]
		var b: int = e[5]
		if kind == 12: c.program = a
		elif kind == 11:
			if a == 7: c.volume = b
			elif a == 11: c.expression = b
			elif a == 10: c.pan = b
			elif a == 64:
				c.sustain = b >= 64
				if not c.sustain:
					for note in c.held: out.append(_finish(note, time))
					c.held = []
			elif a == 120 or a == 123:
				for list in c.active.values():
					for note in list: out.append(_finish(note, time))
				c.active = {}
				for note in c.held: out.append(_finish(note, time))
				c.held = []
		elif kind == 9 and b > 0:
			var note := {"start": time, "key": a, "velocity": b / 127.0 * c.volume / 127.0 * c.expression / 127.0,
				"pan": c.pan / 127.0, "program": c.program, "drum": e[2] == 9}
			if not c.active.has(a): c.active[a] = []
			c.active[a].append(note)
		elif kind == 8 or (kind == 9 and b == 0):
			if c.active.has(a) and not c.active[a].is_empty():
				var note: Dictionary = c.active[a].pop_front()
				if c.sustain: c.held.append(note)
				else: out.append(_finish(note, time))
	for c in channels:
		for list in c.active.values():
			for note in list: out.append(_finish(note, time))
		for note in c.held: out.append(_finish(note, time))
	return {"notes": out, "duration": time + 0.45}

static func _finish(note: Dictionary, end: float) -> Dictionary:
	note.end = maxf(note.start + 0.01, end)
	return note

## Renders a MIDI file to a 16-bit stereo WAV. `is_cancelled` is polled per note.
## `pace`, when given, is awaited between notes and sample blocks so a
## single-threaded caller can keep drawing frames.
static func render(bytes: PackedByteArray, is_cancelled: Callable = Callable(), pace: Callable = Callable()) -> PackedByteArray:
	var parsed := notes(bytes)
	if parsed.is_empty(): return PackedByteArray()
	var length := int(ceil(parsed.duration * RATE))
	var left := PackedFloat32Array(); left.resize(length)
	var right := PackedFloat32Array(); right.resize(length)
	# One period tables per timbre family, so the inner loop is a lookup.
	const TABLE := 2048
	var tables := {}
	for note in parsed.notes:
		if is_cancelled.is_valid() and is_cancelled.call(): return PackedByteArray()
		if pace.is_valid(): await pace.call()
		var family: int = note.program >> 3
		var frequency := 440.0 * pow(2.0, (note.key - 69) / 12.0)
		var start := int(floor(note.start * RATE))
		var held: float = note.end - note.start
		var release := 0.12 if note.drum else 0.25
		var end := mini(length, int(ceil((note.end + release) * RATE)))
		var gain: float = 0.18 * note.velocity
		var gl := cos(note.pan * PI / 2.0) * gain
		var gr := sin(note.pan * PI / 2.0) * gain
		if note.drum:
			var random: int = (int(note.key) + 1) * 1234567
			var kick: bool = note.key == 35 or note.key == 36
			var decay := 18.0 if kick else 28.0
			for i in range(start, end):
				var t := (i - start) / float(RATE)
				var env := minf(1.0, t / 0.008) * clampf((held + release - t) / release, 0.0, 1.0) * exp(-t * decay)
				var sample := 0.0
				if kick:
					sample = sin(TAU * (60.0 * t + 4.0 * (1.0 - exp(-t * 20.0))))
				else:
					random ^= (random << 13) & 0xFFFFFFFF
					random ^= random >> 17
					random ^= (random << 5) & 0xFFFFFFFF
					sample = float(random & 0xFFFFFFFF) / 2147483648.0 - 1.0
				left[i] += sample * env * gl
				right[i] += sample * env * gr
			continue
		var overtone_ok := frequency * 3.0 < RATE * 0.45
		var key := family * 2 + (1 if overtone_ok else 0)
		if not tables.has(key):
			var table := PackedFloat32Array(); table.resize(TABLE)
			var weight := 0.12 if family == 10 else (0.35 if family == 7 else 0.22)
			for k in TABLE:
				var ph := TAU * k / TABLE
				table[k] = sin(ph) + (weight * sin(ph * 3.0) if overtone_ok else 0.0)
			tables[key] = table
		var wave: PackedFloat32Array = tables[key]
		var step := frequency * TABLE / RATE
		var phase := 0.0
		var plucked := family == 0 or family == 1 or family == 3
		var decay := 5.0 if family == 3 else 2.5
		var slow := family == 5 or family == 6 or family == 11
		for i in range(start, end):
			var t := (i - start) / float(RATE)
			var env := minf(1.0, t / 0.008) * clampf((held + release - t) / release, 0.0, 1.0)
			if plucked: env *= 0.25 + 0.75 * exp(-t * decay)
			if slow: env *= minf(1.0, t / 0.06)
			var s := wave[int(phase) & (TABLE - 1)] * env
			phase += step
			left[i] += s * gl
			right[i] += s * gr
	var peak := 1.0
	for i in length:
		peak = maxf(peak, maxf(absf(left[i]), absf(right[i])))
		if i & 0xFFFF == 0 and pace.is_valid(): await pace.call()
	var out := PackedByteArray()
	out.resize(44 + length * 4)
	out.encode_u32(0, 0x46464952)  # RIFF
	out.encode_u32(4, out.size() - 8)
	out.encode_u32(8, 0x45564157)  # WAVE
	out.encode_u32(12, 0x20746D66) # "fmt "
	out.encode_u32(16, 16)
	out.encode_u16(20, 1)
	out.encode_u16(22, 2)
	out.encode_u32(24, RATE)
	out.encode_u32(28, RATE * 4)
	out.encode_u16(32, 4)
	out.encode_u16(34, 16)
	out.encode_u32(36, 0x61746164) # data
	out.encode_u32(40, length * 4)
	var scale := 30000.0 / peak
	for i in length:
		if i & 0xFFFF == 0 and pace.is_valid(): await pace.call()
		out.encode_s16(44 + i * 4, int(round(left[i] * scale)))
		out.encode_s16(46 + i * 4, int(round(right[i] * scale)))
	return out
