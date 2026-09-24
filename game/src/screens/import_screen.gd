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
var dialog: FileDialog

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	var bg := ColorRect.new()
	bg.color = Color(0.01, 0.02, 0.05)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var frame := UI.Frame.new("Galaxy on Fire 2 — J2ME remake engine")
	frame.custom_minimum_size = Vector2(620, 0)
	center.add_child(frame)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	frame.add_child(box)
	box.add_child(UI.paragraph("This engine plays the mobile (J2ME) Galaxy on Fire 2 using the game data from your own copy. Choose the game's JAR file, or drop it onto this window. It is converted on this device; nothing is uploaded, and no game content comes with the engine."))
	box.add_child(UI.paragraph("The conversion takes under a minute and only happens once.", 14, UI.TEXT_DIM))
	choose = UI.button("Choose JAR file…", _choose)
	choose.alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(choose)
	bar = ProgressBar.new()
	bar.custom_minimum_size.y = 18
	bar.show_percentage = false
	bar.visible = false
	box.add_child(bar)
	status = UI.paragraph(message, 14, UI.TEXT_WARN if not message.is_empty() else UI.TEXT_DIM)
	box.add_child(status)
	dialog = FileDialog.new()
	dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dialog.access = FileDialog.ACCESS_FILESYSTEM
	dialog.filters = PackedStringArray(["*.jar ; Java MIDlet archives", "* ; All files"])
	dialog.use_native_dialog = true
	dialog.file_selected.connect(import_file)
	add_child(dialog)
	choose.grab_focus()

func _choose() -> void:
	dialog.popup_centered_ratio(0.7)

func import_file(path: String) -> void:
	if thread != null: return
	choose.disabled = true
	bar.visible = true
	status.text = "Starting…"
	status.add_theme_color_override("font_color", UI.TEXT_DIM)
	importer = Importer.new()
	thread = Thread.new()
	thread.start(importer.run.bind(path))

func _process(_delta: float) -> void:
	if thread == null: return
	var p := importer.progress()
	bar.value = p.ratio * 100.0
	status.text = p.message
	if thread.is_alive(): return
	var result: Dictionary = thread.wait_to_finish()
	thread = null
	choose.disabled = false
	bar.visible = false
	if result.has("error"):
		status.text = result.error
		status.add_theme_color_override("font_color", UI.TEXT_WARN)
		return
	if not app.activate(result.id):
		status.text = "The converted content could not be opened."
		return
	app.show_title()

func _exit_tree() -> void:
	if thread != null:
		importer.cancelled = true
		thread.wait_to_finish()
