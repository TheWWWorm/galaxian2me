extends RefCounted
## Converts a supplied Galaxy on Fire 2 MIDlet JAR into the private content
## cache the engine plays from. Acceptance is structural: any build that stores
## its data the way this reader expects converts, whatever the file is called.
## The output lives under user://content/<sha256 of the JAR>/ and is written to
## a staging folder first, so a failed import never replaces working content.

const Formats := preload("res://src/import/formats.gd")
const Micro3D := preload("res://src/import/micro3d.gd")
const ClassReader := preload("res://src/import/class_reader.gd")
const MidiSynth := preload("res://src/import/midi_synth.gd")

const FORMAT := "gof2-j2me-content-1"
const MAX_JAR := 32 * 1024 * 1024
const MAX_ENTRY := 8 * 1024 * 1024
const REQUIRED := ["data/txt/items.bin", "data/txt/stations.bin", "data/txt/systems.bin",
	"data/txt/ships.bin", "data/txt/agents.bin", "data/txt/shipparts.bin", "data/txt/stationparts.bin",
	"data/textures/space.bmp"]

var progress_mutex := Mutex.new()
var _progress := {"message": "", "ratio": 0.0}
var cancelled := false
var warnings: PackedStringArray = []

func progress() -> Dictionary:
	progress_mutex.lock()
	var p := _progress.duplicate()
	progress_mutex.unlock()
	return p

func _report(message: String, ratio: float) -> void:
	progress_mutex.lock()
	_progress = {"message": message, "ratio": clampf(ratio, 0.0, 1.0)}
	progress_mutex.unlock()

static func content_root() -> String:
	return "user://content"

static func sha256_file(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null: return ""
	var ctx := HashingContext.new()
	ctx.start(HashingContext.HASH_SHA256)
	while f.get_position() < f.get_length():
		ctx.update(f.get_buffer(1 << 20))
	return ctx.finish().hex_encode()

static func _write_json(path: String, value) -> bool:
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null: return false
	f.store_string(JSON.stringify(value, "", false))
	return true

static func _write_bytes(path: String, bytes: PackedByteArray) -> bool:
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null: return false
	f.store_buffer(bytes)
	return true

static func _remove_tree(path: String) -> void:
	var dir := DirAccess.open(path)
	if dir == null: return
	for sub in dir.get_directories(): _remove_tree(path.path_join(sub))
	for file in dir.get_files(): dir.remove(file)
	DirAccess.remove_absolute(path)

func _manifest(zip: ZIPReader) -> Dictionary:
	var raw := zip.read_file("META-INF/MANIFEST.MF")
	var text := raw.get_string_from_utf8().replace("\r\n", "\n").replace("\n ", "")
	var fields := {}
	for line in text.split("\n"):
		var at := line.find(": ")
		if at > 0: fields[line.substr(0, at)] = line.substr(at + 2).strip_edges()
	return fields

## Runs the whole conversion. Returns {"ok": true, "id": sha} or {"error": ...}.
func run(jar_path: String) -> Dictionary:
	warnings.clear()
	_report("Checking the archive…", 0.0)
	var probe := FileAccess.open(jar_path, FileAccess.READ)
	var size := probe.get_length() if probe != null else 0
	probe = null
	if size == 0: return {"error": "The file could not be read."}
	if size > MAX_JAR: return {"error": "The file is larger than any Galaxy on Fire 2 JAR."}
	var zip := ZIPReader.new()
	if zip.open(jar_path) != OK: return {"error": "This is not a readable JAR archive."}
	var names := zip.get_files()
	var present := {}
	for n in names: present[n] = true
	var manifest := _manifest(zip)
	var missing: Array = []
	for n in REQUIRED:
		if not present.has(n): missing.append(n)
	if not manifest.has("MIDlet-1") or not missing.is_empty():
		zip.close()
		return {"error": "This JAR is not a compatible Galaxy on Fire 2 build (missing %s)." % ", ".join(missing if not missing.is_empty() else ["MIDlet manifest"])}
	var has_mbac := false
	for n in names:
		if n.begins_with("data/v3d/") and n.ends_with(".mbac"): has_mbac = true; break
	if not has_mbac:
		zip.close()
		return {"error": "This build stores its models in a format the engine does not read (no Mascot Capsule models under data/v3d)."}
	var sha := sha256_file(jar_path)
	var final_dir := content_root().path_join(sha)
	var stage := content_root().path_join(".staging-" + sha)
	_remove_tree(stage)
	for sub in ["img", "img/faces", "tex", "models", "anims", "sfx", "music"]:
		DirAccess.make_dir_recursive_absolute(stage.path_join(sub))
	var result := _convert(zip, names, manifest, sha, stage)
	zip.close()
	if result.has("error") or cancelled:
		_remove_tree(stage)
		return result if result.has("error") else {"error": "Import cancelled."}
	for required in ["data.json", "manifest.json", "tex/space.png"]:
		if not FileAccess.file_exists(stage.path_join(required)):
			_remove_tree(stage)
			return {"error": "Conversion did not complete (%s missing)." % required}
	_remove_tree(final_dir)
	if DirAccess.rename_absolute(stage, final_dir) != OK:
		_remove_tree(stage)
		return {"error": "Could not store the converted content."}
	_report("Done", 1.0)
	return {"ok": true, "id": sha, "warnings": warnings}

func _convert(zip: ZIPReader, names: PackedStringArray, manifest: Dictionary, sha: String, stage: String) -> Dictionary:
	var data := {}
	var counts := {"models": 0, "animations": 0, "images": 0, "sounds": 0, "music": 0}
	# Tables.
	_report("Reading game data…", 0.02)
	var table_readers := {
		"stations": [Formats.stations, "data/txt/stations.bin"],
		"systems": [Formats.systems, "data/txt/systems.bin"],
		"items": [Formats.items, "data/txt/items.bin"],
		"ships": [Formats.ships, "data/txt/ships.bin"],
		"agents": [Formats.agents, "data/txt/agents.bin"],
		"ship_parts": [Formats.ship_parts, "data/txt/shipparts.bin"],
		"station_parts": [Formats.station_parts, "data/txt/stationparts.bin"],
	}
	for key in table_readers:
		var reader: Callable = table_readers[key][0]
		var parsed: Dictionary = reader.call(zip.read_file(table_readers[key][1]))
		if parsed.has("error"): return {"error": "Unsupported data layout: " + parsed.error}
		data[key] = parsed.value
	var name_lists := {}
	for n in names:
		if n.begins_with("data/txt/names_") and n.ends_with(".bin"):
			var parsed: Dictionary = Formats.names(zip.read_file(n))
			if parsed.has("error"): return {"error": "Unsupported data layout: " + n}
			name_lists[n.get_file().get_basename()] = parsed.value
	data.names = name_lists
	# Language: every data/lang/<code>/<code>.lang the build carries.
	var languages := {}
	for n in names:
		if n.begins_with("data/lang/") and n.ends_with(".lang"):
			var code := n.get_file().get_basename()
			var strings := Formats.lang_strings(zip.read_file(n))
			if strings.size() >= 1000: languages[code] = strings
	if languages.is_empty(): return {"error": "Unsupported build: no string table under data/lang."}
	data.languages = languages
	# Class constants: static initializers and resource registrations.
	_report("Reading constant data…", 0.08)
	var constants := _read_constants(zip, names)
	if constants.has("error"): return constants
	data.constants = constants.statics
	data.models = constants.models
	data.textures = constants.textures
	data.online = constants.online
	data.campaign = constants.campaign
	if constants.online.has("ships") and constants.online.ships.size() > data.ships.size():
		data.ships = constants.online.ships
	if data.models.size() < 50: return {"error": "Unsupported build: the model registry could not be read."}
	# Resources.
	var total := names.size()
	var index := 0
	var music: Array = []
	for n in names:
		index += 1
		if cancelled: return {"error": "Import cancelled."}
		if index % 12 == 0: _report("Converting resources…", 0.1 + 0.6 * float(index) / total)
		var file := n.get_file()
		var bytes: PackedByteArray
		if n.begins_with("data/interface/") and n.ends_with(".png"):
			bytes = zip.read_file(n)
			if bytes.size() > MAX_ENTRY: return {"error": "Oversized resource " + n}
			var img := Formats.png_image(bytes)
			if img == null:
				warnings.append("Unreadable image " + n); continue
			var sub := "img/faces/" if n.contains("/faces/") else "img/"
			img.save_png(stage.path_join(sub + file))
			counts.images += 1
		elif n.begins_with("data/textures/") and n.ends_with(".bmp"):
			var img := Formats.bmp_image(zip.read_file(n))
			if img == null: return {"error": "Unsupported texture encoding in " + n}
			img.save_png(stage.path_join("tex/" + file.get_basename() + ".png"))
		elif n.begins_with("data/v3d/") and (n.ends_with(".mbac") or n.ends_with(".mtra")):
			bytes = zip.read_file(n)
			if bytes.size() > MAX_ENTRY: return {"error": "Oversized resource " + n}
			if bytes.size() >= 2 and bytes[0] != 0x4D: bytes = Formats.unwrap(bytes)
			if n.ends_with(".mbac"):
				var m := Micro3D.model(bytes)
				if m.has("error"):
					warnings.append("%s: %s" % [n, m.error]); continue
				_write_json(stage.path_join("models/" + file.get_basename() + ".json"), m)
				counts.models += 1
			else:
				var a := Micro3D.animation(bytes)
				if a.has("error"):
					warnings.append("%s: %s" % [n, a.error]); continue
				_write_json(stage.path_join("anims/" + file.get_basename() + ".json"), a)
				counts.animations += 1
		elif n.begins_with("data/sound/") and n.ends_with(".wav"):
			bytes = zip.read_file(n)
			if Formats.wav_info(bytes).is_empty():
				warnings.append("Unsupported sound " + n); continue
			_write_bytes(stage.path_join("sfx/" + file), bytes)
			counts.sounds += 1
		elif n.begins_with("data/sound/") and n.ends_with(".mid"):
			bytes = zip.read_file(n)
			_write_bytes(stage.path_join("music/" + file), bytes)
			music.append(file)
	if counts.models < 50: return {"error": "Unsupported build: too few readable models."}
	# Music: the MIDI scores are rendered once by the engine's own synthesizer.
	for i in music.size():
		if cancelled: return {"error": "Import cancelled."}
		_report("Rendering music %d of %d…" % [i + 1, music.size()], 0.72 + 0.26 * float(i) / maxf(1, music.size()))
		var mid := FileAccess.get_file_as_bytes(stage.path_join("music/" + music[i]))
		var wav := MidiSynth.render(mid, func(): return cancelled)
		if wav.is_empty():
			warnings.append("Could not render " + music[i]); continue
		_write_bytes(stage.path_join("music/" + music[i].get_basename() + ".wav"), wav)
		counts.music += 1
	_report("Finishing…", 0.99)
	var info := {"format": FORMAT, "id": sha, "name": manifest.get("MIDlet-Name", ""),
		"version": manifest.get("MIDlet-Version", ""), "vendor": manifest.get("MIDlet-Vendor", ""),
		"languages": languages.keys(), "counts": counts, "warnings": warnings,
		"full_campaign": data.online.has("story_stations"), "ship_records": data.ships.size()}
	if not _write_json(stage.path_join("data.json"), data): return {"error": "Could not write converted data."}
	if not _write_json(stage.path_join("manifest.json"), info): return {"error": "Could not write converted data."}
	return {"ok": true}


## Evaluates every class's static initializer for literal constants, and finds
## the geometry/texture registrations: the method that registers dozens of
## resources by (id, path) through one static call.
func _read_constants(zip: ZIPReader, names: PackedStringArray) -> Dictionary:
	var started := Time.get_ticks_msec()
	var statics := {}
	var classes := {}
	for n in names:
		if not n.ends_with(".class"): continue
		var c = ClassReader.parse(zip.read_file(n))
		if not c.error.is_empty():
			warnings.append("Unreadable class " + n); continue
		classes[c.name] = c
	var ignore := func(_o, _m, _d, _a, _t): return null
	for cname in classes:
		var c = classes[cname]
		if not c.methods.has("<clinit>:()V"): continue
		var local := {}
		var r: Dictionary = c.evaluate("<clinit>:()V", local, _string_calls.bind(ignore))
		if r.has("error"): continue
		for k in local:
			if k.begins_with(cname + "."): statics[k] = _plain(local[k])
	# Literal tables assigned in constructors: evaluate each constructor on
	# an inert record and keep the arrays it was given before anything else.
	for cname in classes:
		var c = classes[cname]
		for key in c.method_keys():
			if not key.begins_with("<init>:"): continue
			var record := {"new": cname}
			var initial: Array = [record]
			for _a in ClassReader.argument_count(key.substr(key.find(":") + 1)): initial.append(0)
			c.evaluate(key, {}, _string_calls.bind(ignore), 20000, initial)
			for field in record:
				if field == "new": continue
				var v = _plain(record[field])
				if v is Array and not v.is_empty() and v.all(func(x): return x is int or x is float or x is Array):
					statics["%s#%s" % [cname, field]] = v
	var models := {}
	var textures := {}
	for cname in classes:
		var c = classes[cname]
		var strings: PackedStringArray = c.strings()
		var hits := 0
		for s in strings:
			if s.begins_with("ship_") or s.begins_with("stat_"): hits += 1
		if hits < 20: continue
		for key in c.method_keys():
			if not key.ends_with(")V") or key.begins_with("<"): continue
			var found := {}
			var found_tex := {}
			var capture := func(_owner, _method, desc, args, _target):
				if desc == "(ILjava/lang/String;II)V" and args[0] is int and args[1] is String:
					found[str(args[0])] = {"path": args[1], "radius": args[2], "texture": args[3]}
				elif desc == "(ILjava/lang/String;I)V" and args[0] is int and args[1] is String:
					found[str(args[0])] = {"path": args[1], "radius": -1, "texture": args[2]}
				elif desc == "(ILjava/lang/String;)V" and args[0] is int and args[1] is String:
					found_tex[str(args[0])] = args[1]
				return null
			var local := {}
			for k in statics:
				if k.begins_with(cname + "."): local[k] = statics[k]
			var r: Dictionary = c.evaluate(key, local, _string_calls.bind(capture))
			if r.has("error") or found.size() < 50: continue
			for id in found:
				var entry: Dictionary = found[id]
				entry.name = str(entry.path).get_file()
				models[id] = entry
			for id in found_tex: textures[id] = str(found_tex[id]).get_file()
	var t0 := Time.get_ticks_msec()
	var online := _read_online_data(classes, statics)
	var t1 := Time.get_ticks_msec()
	var campaign := _read_campaign(classes, statics, online)
	if OS.is_debug_build(): print("constants: clinit %d ms, online %d ms, campaign %d ms" % [t0 - started, t1 - t0, Time.get_ticks_msec() - t1])
	return {"statics": statics, "models": models, "textures": textures, "online": online, "campaign": campaign}

## The story's progression method advances a counter and switches on it,
## building the next story mission for each step. It is found by that shape
## (getstatic, +1, putstatic, tableswitch) and evaluated once per step with
## calls recorded instead of performed: the mission record it constructs,
## the settings applied to that record, and other recorded effects.
func _read_campaign(classes: Dictionary, statics: Dictionary, online: Dictionary) -> Dictionary:
	for cname in classes:
		var c = classes[cname]
		for key in c.method_keys():
			if not key.ends_with(":()V") or not (int(c.methods[key].flags) & 0x0008): continue
			var code: PackedByteArray = c.code(key)
			if code.size() < 24 or code[0] != 0xB2 or code[3] != 0x04 or code[4] != 0x60 or code[5] != 0x59 or code[6] != 0xB3 or code[9] != 0xAA:
				continue
			if code.decode_u16(1) != code.decode_u16(7) and ((code[1] << 8) | code[2]) != ((code[7] << 8) | code[8]):
				continue
			var ref: Array = c.member_ref((code[1] << 8) | code[2])
			var field := "%s.%s:%s" % [ref[0], ref[1], ref[2]]
			var high := (code[20] << 24) | (code[21] << 16) | (code[22] << 8) | code[23]
			if high < 20 or high > 200: continue
			var steps: Array = []
			for step in high:
				var local := {}
				for k in statics:
					if k.begins_with(cname + "."): local[k] = statics[k] if not (statics[k] is Array) else statics[k].duplicate(true)
				if online.has("story_stations"):
					for k in local:
						if local[k] is Array and local[k].size() == online.story_stations.size() and k.ends_with(":[I") and local[k].all(func(x): return x is int and x == -1):
							local[k] = online.story_stations.duplicate()
				local[field] = step
				var before := local.duplicate(true)
				var record := {"step": step + 1, "missions": [], "effects": []}
				var capture := func(owner, method, desc, args, target):
					if method == "<init>" and target is Dictionary:
						target.args = _plain(args)
						if desc == "(III)V": record.missions.append(target)
						return null
					var entry := {"owner": owner, "method": method, "desc": desc, "args": _plain(args)}
					if target is Dictionary and record.missions.has(target):
						entry.on_mission = true
					elif target == null and method != "<init>":
						entry.target = "none" if desc.begins_with("(") and not (owner in ["java/lang/StringBuffer"]) else ""
					record.effects.append(entry)
					if desc.ends_with(")Z"): return 0
					if desc.ends_with(")I"): return 0
					return null
				var r: Dictionary = c.evaluate(key, local, _string_calls.bind(capture), 20000)
				if r.has("error"):
					record.error = r.error
				var missions: Array = []
				for m in record.missions: missions.append(m.get("args", []))
				record.missions = missions
				var changes := {}
				for k in local:
					if k == field: continue
					if not before.has(k) or JSON.stringify(_plain(before[k])) != JSON.stringify(_plain(local[k])):
						changes[k] = _plain(local[k])
				record.statics = changes
				steps.append(record)
			return {"counter": field, "steps": steps, "start": _read_start(c, key, field, statics),
				"radio": _read_radio(classes, high)}
	return {}

## In-flight radio of the story: a method taking the story step and returning
## an array of records built from (line, speaker, trigger, parameter) or
## (line, speaker, trigger, [indices]). Evaluated once per step.
func _read_radio(classes: Dictionary, steps: int) -> Dictionary:
	for cname in classes:
		var c = classes[cname]
		for key in c.method_keys():
			if not key.contains(":(I)[L"): continue
			var code: PackedByteArray = c.code(key)
			if code.find(0xAA) < 0: continue
			var out := {}
			var total := 0
			for step in steps + 1:
				var records: Array = []
				var capture := func(_owner, method, desc, args, target):
					if method == "<init>" and target is Dictionary and (desc == "(IIII)V" or desc == "(III[I)V"):
						records.append(_plain(args))
					return null
				var initial: Array = [{"new": cname}, step]
				var r: Dictionary = c.evaluate(key, {}, _string_calls.bind(capture), 20000, initial)
				if r.has("error"): continue
				if not records.is_empty():
					out[str(step)] = records
					total += records.size()
			if total >= 10:
				return out
	return {}

## The retail game fetched two tables from the publisher's online service
## once the free chapters were over: the story's later station assignments
## and the full hull table. Some builds carry that data in their own
## classes. It is recovered here only when a static method assigns a literal
## array to the field the campaign reads, or hands the hull table as literal
## bytes to the method that parses it; otherwise it is reported as absent.
func _read_online_data(classes: Dictionary, statics: Dictionary) -> Dictionary:
	var out := {}
	# The campaign's station list starts as an array of -1 placeholders.
	var placeholder := ""
	for k in statics:
		var v = statics[k]
		if k.ends_with(":[I") and v is Array and v.size() >= 20 and v.all(func(x): return x is int and x == -1):
			placeholder = k
	for cname in classes:
		var c = classes[cname]
		for key in c.method_keys():
			if not key.ends_with(":()V") or key.begins_with("<"): continue
			var flags: int = c.methods[key].flags
			if not (flags & 0x0008): continue
			var calls: Array = []
			var capture := func(owner, method, desc, args, _t):
				if desc == "([B)V" and args.size() == 1 and args[0] is Array and args[0].size() >= 36 * 16:
					calls.append(args[0])
				return null
			var local := {}
			var r: Dictionary = c.evaluate(key, local, _string_calls.bind(capture), 60000)
			if r.has("error"): continue
			if not placeholder.is_empty() and local.has(placeholder):
				var v = local[placeholder]
				if v is Array and v.size() == statics[placeholder].size():
					out.story_stations = _plain(v)
			for bytes in calls:
				var ships := _ship_table(bytes)
				if not ships.is_empty(): out.ships = ships
	return out

## The new-game method of the same class: it zeroes the story counter and
## builds the first story mission the same way the progression does.
func _read_start(c, progression: String, field: String, statics: Dictionary) -> Dictionary:
	var owner := field.substr(0, field.find("."))
	for key in c.method_keys():
		if key == progression or not key.ends_with(":()V") or not (int(c.methods[key].flags) & 0x0008): continue
		var local := {}
		for k in statics:
			if k.begins_with(owner + "."): local[k] = statics[k] if not (statics[k] is Array) else statics[k].duplicate(true)
		local[field] = -1
		var missions: Array = []
		var capture := func(_owner, method, desc, args, target):
			if method == "<init>" and desc == "(III)V" and target is Dictionary: missions.append(_plain(args))
			if desc.ends_with(")Z") or desc.ends_with(")I"): return 0
			return null
		c.evaluate(key, local, _string_calls.bind(capture), 20000)
		if local.get(field) is int and local[field] == 0 and not missions.is_empty():
			return {"mission": missions[0]}
	return {}

## Hull records as the online table carries them: nine big-endian ints each.
static func _ship_table(values: Array) -> Array:
	if values.size() % 36 != 0: return []
	var raw := PackedByteArray()
	for v in values: raw.append(int(v) & 0xFF)
	var out: Array = []
	for i in values.size() / 36:
		var rec: Array = []
		for k in 9: rec.append(_be32(raw, i * 36 + k * 4))
		if rec[0] != i: return []
		out.append({"id": rec[0], "armor": rec[1], "cargo": rec[2], "price": rec[3], "primary": rec[4],
			"secondary": rec[5], "turret": rec[6], "equipment": rec[7], "handling": rec[8]})
	return out

static func _be32(raw: PackedByteArray, at: int) -> int:
	var v := (raw[at] << 24) | (raw[at + 1] << 16) | (raw[at + 2] << 8) | raw[at + 3]
	return v - 4294967296 if v > 2147483647 else v

## String concatenation as javac compiles it for CLDC (StringBuffer), and
## String.valueOf; everything else goes to `next`.
static func _string_calls(owner, method, desc, args, target, next: Callable):
	if owner == "java/lang/StringBuffer" or owner == "java/lang/StringBuilder":
		if method == "<init>":
			if target is Dictionary:
				target.text = str(args[0]) if args.size() > 0 and args[0] is String else ""
			return null
		if method == "append" and target is Dictionary:
			var v = args[0]
			target.text = str(target.get("text", "")) + ("" if v == null else str(v))
			return target
		if method == "toString" and target is Dictionary:
			return str(target.get("text", ""))
	if owner == "java/lang/String" and method == "valueOf":
		return str(args[0])
	return next.call(owner, method, desc, args, target)

static func _plain(v):
	if v is Array:
		var out: Array = []
		for e in v: out.append(_plain(e))
		return out
	if v is Dictionary:
		# Run-time values stay symbolic; built records are not data.
		if v.has("static"): return {"static": v.static}
		if v.has("expr"): return {"expr": [v.expr[0], _plain(v.expr[1]), _plain(v.expr[2])]}
		return null
	return v
