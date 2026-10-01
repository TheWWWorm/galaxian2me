extends Control
## First-run screen: asks for the player's own Galaxy on Fire 2 JAR and
## converts it on a worker thread.

const UI := preload("res://src/presentation/ui.gd")
const Importer := preload("res://src/import/importer.gd")

var app
var message := ""
var status: Label
var bar: ProgressBar
var choose: Button
var importer: Importer
var thread: Thread
## True while a thread-less build converts on the main thread.
var running := false
var dialog: FileDialog
## In a browser the JAR comes through the page's own file picker; its bytes
## are copied into browser storage and converted there, never uploaded.
var web_callback: JavaScriptObject
const WEB_JAR := "user://selected.jar"

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var bg := ColorRect.new()
	bg.color = Color(0.01, 0.02, 0.05)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var stars := Stars.new()
	stars.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	stars.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(stars)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var frame := UI.Frame.new(tr("Galaxy on Fire 2 — J2ME remake engine"))
	frame.custom_minimum_size = Vector2(620, 0)
	center.add_child(frame)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	frame.add_child(box)
	var how := tr("Choose the game's JAR file.") if OS.has_feature("web") else tr("Choose the game's JAR file, or drop it onto this window.")
	box.add_child(UI.paragraph(tr("This engine plays the mobile (J2ME) Galaxy on Fire 2 using the game data from your own copy. %s It is converted on this device; nothing is uploaded, and no game content comes with the engine.") % how))
	box.add_child(UI.paragraph(tr("You need the Sony Ericsson version of the game (Mascot Capsule 3D); versions for other phones cannot be played."), 14, UI.TEXT_WARN))
	box.add_child(UI.paragraph(tr("The conversion takes under a minute and only happens once."), 14, UI.TEXT_DIM))
	choose = UI.button(tr("Choose JAR file…"), _choose)
	choose.alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(choose)
	bar = ProgressBar.new()
	bar.custom_minimum_size.y = 18
	bar.show_percentage = false
	bar.visible = false
	box.add_child(bar)
	status = UI.paragraph(message, 14, UI.TEXT_WARN if not message.is_empty() else UI.TEXT_DIM)
	box.add_child(status)
	if OS.has_feature("web"):
		web_callback = JavaScriptBridge.create_callback(_web_received)
		JavaScriptBridge.eval("""
window.gof2Files = {
 choose: function(callback) {
  const input = document.createElement('input');
  input.type = 'file'; input.accept = '.jar';
  input.onchange = async () => {
   const file = input.files[0]; if (!file) return;
   if (file.size > 16777216) { callback('error', 'The selected file is too large to be the game JAR.'); return; }
   callback('progress', 'Reading your local file…');
   try { callback('complete', await file.arrayBuffer()); }
   catch (error) { callback('error', String(error.message || error)); }
  };
  input.click();
 }
};
""", true)
	dialog = FileDialog.new()
	dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dialog.access = FileDialog.ACCESS_FILESYSTEM
	# Android's picker filters by media type, which a .jar rarely carries.
	if not OS.has_feature("android"):
		dialog.filters = PackedStringArray([tr("*.jar ; Java MIDlet archives"), tr("* ; All files")])
	dialog.use_native_dialog = true
	dialog.file_selected.connect(import_file)
	add_child(dialog)
	choose.grab_focus()

func _choose() -> void:
	if OS.has_feature("web"):
		JavaScriptBridge.get_interface("gof2Files").choose(web_callback)
		return
	dialog.popup_centered_ratio(0.7)

func _web_received(args: Array) -> void:
	if args.size() < 2: return
	match str(args[0]):
		"progress":
			status.text = importer_message(str(args[1]))
		"complete":
			var file := FileAccess.open(WEB_JAR, FileAccess.WRITE)
			if file == null:
				_show_error(tr("Browser storage is unavailable."))
				return
			file.store_buffer(JavaScriptBridge.js_buffer_to_packed_byte_array(args[1]))
			var failed := file.get_error() != OK
			file.close()
			if failed:
				DirAccess.remove_absolute(WEB_JAR)
				_show_error(tr("Browser storage is full. Free some space and try again."))
				return
			import_file(WEB_JAR)
		_:
			_show_error(importer_message(str(args[1])))

func _show_error(text: String) -> void:
	status.text = text
	status.add_theme_color_override("font_color", UI.TEXT_WARN)

func import_file(path: String) -> void:
	if thread != null: return
	choose.disabled = true
	bar.visible = true
	status.text = tr("Starting…")
	status.add_theme_color_override("font_color", UI.TEXT_DIM)
	importer = Importer.new()
	if OS.has_feature("android") and path != WEB_JAR:
		# The system picker hands over a document address the archive reader
		# cannot open; its bytes are copied into the app's own storage first.
		var bytes := FileAccess.get_file_as_bytes(path)
		var copy := FileAccess.open(WEB_JAR, FileAccess.WRITE)
		if bytes.is_empty() or copy == null:
			choose.disabled = false
			bar.visible = false
			_show_error(tr("That file could not be read. Choose the game's .jar file."))
			return
		copy.store_buffer(bytes)
		copy.close()
		path = WEB_JAR
	if OS.has_feature("web") and not OS.has_feature("threads"):
		# A browser build without threads converts on the main thread in
		# short slices, drawing a frame between them.
		importer.tree = get_tree()
		running = true
		var result: Dictionary = await importer.run(path)
		running = false
		if path == WEB_JAR: DirAccess.remove_absolute(WEB_JAR)
		_finish(result)
		return
	thread = Thread.new()
	thread.start(importer.run.bind(path))

func _process(_delta: float) -> void:
	if thread == null and not running: return
	var p := importer.progress()
	bar.value = p.ratio * 100.0
	status.text = importer_message(p.message)
	if running or thread.is_alive(): return
	var result: Dictionary = thread.wait_to_finish()
	thread = null
	if OS.has_feature("web") or OS.has_feature("android"): DirAccess.remove_absolute(WEB_JAR)
	_finish(result)

func _finish(result: Dictionary) -> void:
	choose.disabled = false
	bar.visible = false
	if result.has("error"):
		status.text = importer_message(result.error)
		status.add_theme_color_override("font_color", UI.TEXT_WARN)
		return
	if not app.activate(result.id):
		status.text = tr("The converted content could not be opened.")
		return
	app.show_title()

## The importer's progress and failure text, which it writes in English, in
## the engine language. Text it does not know stays as it came.
func importer_message(message: String) -> String:
	var patterns := [
		["^Rendering music (\\d+) of (\\d+)…$", tr("Rendering music %d of %d…")],
		["^This JAR is not a compatible Galaxy on Fire 2 build \\(missing (.+)\\)\\.$", tr("This JAR is not a compatible Galaxy on Fire 2 build (missing %s).")],
		["^Conversion did not complete \\((.+) missing\\)\\.$", tr("Conversion did not complete (%s missing).")],
		["^Unsupported data layout: (.+)$", tr("Unsupported data layout: %s")],
		["^Oversized resource (.+)$", tr("Oversized resource %s")],
		["^Unsupported texture encoding in (.+)$", tr("Unsupported texture encoding in %s")],
	]
	for pattern in patterns:
		var found := RegEx.create_from_string(pattern[0]).search(message)
		if found == null: continue
		var values: Array = []
		for i in range(1, found.get_group_count() + 1):
			var value := found.get_string(i)
			values.append(int(value) if value.is_valid_int() and pattern[1].contains("%d") else tr(value))
		return pattern[1] % values
	return tr(message)

## Listed so that the fixed importer text is translated; importer_message()
## looks each one up.
func importer_messages() -> Array:
	return [tr("Checking the archive…"), tr("The file could not be read."), tr("The file is larger than any Galaxy on Fire 2 JAR."),
		tr("This is not a readable JAR archive."), tr("MIDlet manifest"),
		tr("This build stores its models in a format the engine does not read (no Mascot Capsule models under data/v3d). Use the Sony Ericsson version of the game."),
		tr("Import cancelled."), tr("Could not store the converted content."), tr("Done"), tr("Reading game data…"),
		tr("Unsupported build: no string table under data/lang."), tr("Reading constant data…"),
		tr("Unsupported build: the model registry could not be read."), tr("Converting resources…"),
		tr("Unsupported build: too few readable models."), tr("Finishing…"), tr("Could not write converted data."),
		tr("Reading the campaign…"), tr("Reading your local file…"), tr("The selected file is too large to be the game JAR.")]

func _exit_tree() -> void:
	if running: importer.cancelled = true
	if thread != null:
		importer.cancelled = true
		thread.wait_to_finish()

## Slowly drifting stars behind the first-run panel (drawn, so it needs no
## game content, which is not installed yet).
class Stars extends Control:
	var stars: Array = []
	var t := 0.0
	func _ready() -> void:
		var rng := RandomNumberGenerator.new()
		rng.seed = 2
		for i in 260:
			stars.append([rng.randf(), rng.randf(), rng.randf_range(0.2, 1.0), rng.randf() * TAU])
	func _process(delta: float) -> void:
		t += delta
		queue_redraw()
	func _draw() -> void:
		for s in stars:
			var depth: float = s[2]
			var x := fposmod(float(s[0]) - t * 0.004 * depth, 1.0) * size.x
			var p := Vector2(x, float(s[1]) * size.y)
			var a := (0.35 + 0.65 * depth) * (0.8 + 0.2 * sin(t * 1.3 + float(s[3])))
			draw_rect(Rect2(p, Vector2.ONE * (1.0 + depth)), Color(0.75, 0.85, 1.0, a))
