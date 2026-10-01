extends RefCounted
## Player-supplied replacements for the converted art and audio. Nothing here
## ships with the engine: a `mods` folder in the user data folder, or next to
## the executable, may hold
##   textures/space.png   the 3D model atlas (any size: models address it in
##                        the original's texels, so a larger atlas is simply
##                        drawn sharper; keep the original's colour key),
##   interface/<name>.png an interface image, by its converted name,
##   music/<track>.ogg    (.mp3 or .wav) instead of a converted MIDI track,
##   sounds/<name>.wav    (.ogg) instead of a sound effect,
##   models/<name>.glb    (.gltf) a glTF scene instead of a converted model,
##                        scaled to its size and centred where it sat.
## The simulation never reads these files.

const EngineLanguage := preload("res://src/presentation/engine_language.gd")

## Set by engine checks so a test never reads a player's real mods.
static var only_root := ""

static func roots() -> Array[String]:
	if not only_root.is_empty(): return [only_root]
	var found: Array[String] = ["user://mods"]
	if not OS.has_feature("web") and not OS.has_feature("android") and not OS.has_feature("editor"):
		var beside := OS.get_executable_path().get_base_dir().path_join("mods")
		if OS.has_feature("macos"): beside = OS.get_executable_path().get_base_dir().path_join("../../../mods").simplify_path()
		found.append(beside)
	return found

## The first existing replacement among `relatives`, or "".
static func find(relatives: Array) -> String:
	for root in roots():
		for relative in relatives:
			var path: String = root.path_join(relative)
			if FileAccess.file_exists(path): return path
	return ""

static func image(folder: String, name: String) -> Image:
	var path := find([folder + "/" + name + ".png"])
	if path.is_empty(): return null
	var img := Image.load_from_file(path)
	if img == null: push_warning("Could not read replacement image: " + path)
	return img

static func audio(folder: String, name: String) -> AudioStream:
	var path := find([folder + "/" + name + ".ogg", folder + "/" + name + ".mp3", folder + "/" + name + ".wav"])
	if path.is_empty(): return null
	var stream := audio_file(path, path.get_extension())
	if stream == null: push_warning("Could not read replacement audio: " + path)
	return stream

## A replacement model's scene, freshly built, or null.
static func model(name: String) -> Node3D:
	var path := find(["models/" + name + ".glb", "models/" + name + ".gltf"])
	if path.is_empty(): return null
	var scene := gltf_file(path)
	if scene == null: push_warning("Could not read replacement model: " + path)
	return scene

static func gltf_file(path: String) -> Node3D:
	var doc := GLTFDocument.new()
	var state := GLTFState.new()
	if doc.append_from_file(path, state) != OK: return null
	return doc.generate_scene(state) as Node3D

# ------------------------------------------------------------------ managing

const IMAGE_FOLDERS := ["textures", "interface"]
const LIMIT := 64 * 1024 * 1024

## The folder the in-game Mods page writes to.
static func user_root() -> String:
	return only_root if not only_root.is_empty() else "user://mods"

## The replacement in use for `name` in `folder`, or "".
static func replacement(folder: String, name: String) -> String:
	if folder in IMAGE_FOLDERS: return find([folder + "/" + name + ".png"])
	if folder == "models": return find([folder + "/" + name + ".glb", folder + "/" + name + ".gltf"])
	return find([folder + "/" + name + ".ogg", folder + "/" + name + ".mp3", folder + "/" + name + ".wav"])

## The format a file's content is in (its extension does not decide):
## "png", "ogg", "mp3", "wav" or "".
static func sniff(bytes: PackedByteArray) -> String:
	if bytes.size() < 12: return ""
	if bytes.slice(0, 8) == PackedByteArray([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]): return "png"
	if bytes.slice(0, 4).get_string_from_ascii() == "OggS": return "ogg"
	if bytes.slice(0, 4).get_string_from_ascii() == "glTF": return "glb"
	if bytes.slice(0, 4).get_string_from_ascii() == "RIFF" and bytes.slice(8, 12).get_string_from_ascii() == "WAVE": return "wav"
	if bytes.slice(0, 3).get_string_from_ascii() == "ID3" or (bytes[0] == 0xff and (bytes[1] & 0xe0) == 0xe0): return "mp3"
	return ""

## Copies `source` in as the replacement for `name`; "" on success, else
## why not. Any earlier replacement of it in the user folder goes.
static func install(folder: String, name: String, source: String) -> String:
	var f := FileAccess.open(source, FileAccess.READ)
	if f == null: return EngineLanguage.translate("The file could not be opened.")
	if f.get_length() > LIMIT: return EngineLanguage.translate("The file is larger than 64 MiB.")
	var bytes := f.get_buffer(f.get_length())
	f.close()
	var kind := sniff(bytes)
	var wanted := ["png"] if folder in IMAGE_FOLDERS else (["glb"] if folder == "models" else ["ogg", "mp3", "wav"])
	if not kind in wanted:
		if folder == "models": return EngineLanguage.translate("Choose a binary glTF (.glb) file.")
		return EngineLanguage.translate("Choose a PNG image.") if folder in IMAGE_FOLDERS else EngineLanguage.translate("Choose an OGG Vorbis, MP3 or WAV file.")
	var target := user_root().path_join(folder).path_join(name + "." + kind)
	var tmp := target.get_basename() + ".new." + kind
	DirAccess.make_dir_recursive_absolute(target.get_base_dir())
	var out := FileAccess.open(tmp, FileAccess.WRITE)
	if out == null: return EngineLanguage.translate("The mods folder could not be written.")
	out.store_buffer(bytes)
	out.close()
	# Check it reads before it replaces anything.
	var readable := false
	match kind:
		"png": readable = Image.load_from_file(tmp) != null
		"glb": readable = gltf_file(tmp) != null
		_: readable = audio_file(tmp, kind) != null
	if not readable:
		DirAccess.remove_absolute(tmp)
		return EngineLanguage.translate("The file could not be read as %s.") % kind.to_upper()
	restore(folder, name)
	DirAccess.rename_absolute(tmp, target)
	return ""

## Removes the user folder's replacement of `name`; true if one was there.
static func restore(folder: String, name: String) -> bool:
	var removed := false
	for ext in ["png", "ogg", "mp3", "wav", "glb", "gltf"]:
		var path := user_root().path_join(folder).path_join(name + "." + ext)
		if FileAccess.file_exists(path):
			removed = DirAccess.remove_absolute(path) == OK or removed
	return removed

static func audio_file(path: String, kind: String) -> AudioStream:
	match kind:
		"ogg": return AudioStreamOggVorbis.load_from_file(path)
		"mp3": return AudioStreamMP3.load_from_file(path)
		"wav": return AudioStreamWAV.load_from_file(path)
	return null
