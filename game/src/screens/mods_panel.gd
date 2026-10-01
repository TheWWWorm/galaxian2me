extends "res://src/presentation/ui.gd".Frame
## Title → Mods: the 3D model atlas, the music tracks and every still
## model, what stands for each now, and Replace… / Restore original. A
## replacement is a copy in the user data folder's mods folder; the
## converted originals are never touched. The model viewer doubles as a
## look through the game's own models.

const UI := preload("res://src/presentation/ui.gd")
const Mods := preload("res://src/content/mods.gd")
const ShipPreview := preload("res://src/presentation/ship_preview.gd")

## The converted tracks and where the game plays them.
func tracks() -> Array:
	return [["gof2_theme", tr("Title")], ["gof2_hangar", tr("Station")], ["gof2_bar", tr("Space Lounge")],
		["gof2_gneutral", tr("Flight")], ["gof2_gaction", tr("Combat")]]
const ATLAS := "space"
## Models drawn animated (or, for the sky, sized from their own mesh);
## these keep their originals.
const ANIMATED := ["skybox", "explosion", "asteroid_explo", "vortex", "vortex_dust"]

signal closed

var app
var rows: VBoxContainer
var preview: TextureRect
var viewer: ShipPreview
var model_pick: OptionButton
var model_names: Array[String] = []
var model := ""
var status: Label
var focus_key := ""

func _init() -> void:
	super._init(tr("Mods"))

func _ready() -> void:
	custom_minimum_size = Vector2(860, 520)
	var outer := VBoxContainer.new()
	outer.add_theme_constant_override("separation", 8)
	add_child(outer)
	var row := HBoxContainer.new()
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 12)
	outer.add_child(row)
	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.custom_minimum_size = Vector2(560, 400)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	row.add_child(scroll)
	rows = VBoxContainer.new()
	rows.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rows.add_theme_constant_override("separation", 6)
	scroll.add_child(rows)
	preview = TextureRect.new()
	preview.custom_minimum_size = Vector2(256, 256)
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	preview.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	var side := VBoxContainer.new()
	side.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	row.add_child(side)
	side.add_child(preview)
	viewer = ShipPreview.new()
	viewer.library = app.library
	viewer.custom_minimum_size = Vector2(256, 256)
	viewer.visible = false
	side.add_child(viewer)
	model_names = _still_models()
	if not model_names.is_empty(): model = model_names[0]
	status = UI.paragraph("", 14, UI.TEXT_DIM)
	outer.add_child(status)
	var foot := HBoxContainer.new()
	foot.add_theme_constant_override("separation", 8)
	outer.add_child(foot)
	if _can_open_folders():
		foot.add_child(UI.button(tr("Open mods folder"), func():
			DirAccess.make_dir_recursive_absolute(Mods.user_root())
			OS.shell_open(ProjectSettings.globalize_path(Mods.user_root()))))
		foot.add_child(UI.button(tr("Open converted originals"), func():
			OS.shell_open(ProjectSettings.globalize_path(app.library.root))))
	var back := UI.button(app.library.text(65), close)
	back.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	back.alignment = HORIZONTAL_ALIGNMENT_CENTER
	foot.add_child(back)
	_build()

func close() -> void:
	closed.emit()
	queue_free()

func _exit_tree() -> void:
	# Leave with the title's own music, whatever was being listened to.
	if app != null and app.library != null: app.play_music("gof2_theme")

func _can_open_folders() -> bool:
	return not OS.has_feature("web") and not OS.has_feature("mobile")

func _build() -> void:
	for c in rows.get_children():
		rows.remove_child(c)
		c.queue_free()
	var first: Control = null
	rows.add_child(UI.label(tr("Textures"), 15, UI.TEXT_GOOD))
	var atlas_row := _row("textures", ATLAS, tr("3D models (space.png)"), func():
		_show_texture(app.library.atlas_texture(ATLAS))
		status.text = tr("The atlas every ship, station and asteroid is painted from."))
	first = atlas_row
	rows.add_child(UI.paragraph(tr("Any size works: models address the atlas in the original's texels, so a 4× repaint is simply drawn sharper. Keep the original's layout and colour key. Applies from the next scene."), 13, UI.TEXT_DIM))
	rows.add_child(UI.label(tr("Music"), 15, UI.TEXT_GOOD))
	for track in tracks():
		if not FileAccess.file_exists(app.library.root.path_join("music/" + track[0] + ".wav")) and Mods.replacement("music", track[0]).is_empty():
			continue
		var name: String = track[0]
		_row("music", name, "%s (%s)" % [track[1], name], func():
			app.music_name = ""
			app.play_music(name)
			status.text = tr("Playing %s.") % track[1])
	rows.add_child(UI.paragraph(tr("OGG Vorbis, MP3 or WAV, up to 64 MiB, looped from start to end. Applies at once."), 13, UI.TEXT_DIM))
	if not model_names.is_empty():
		rows.add_child(UI.label(tr("Models"), 15, UI.TEXT_GOOD))
		model_pick = OptionButton.new()
		model_pick.name = "model_pick"
		for n in model_names:
			var mark := " ✓" if not Mods.replacement("models", n).is_empty() else ""
			model_pick.add_item(n + mark)
		model_pick.select(maxi(0, model_names.find(model)))
		model_pick.item_selected.connect(func(i: int):
			model = model_names[i]
			focus_key = "model_pick"
			_build()
			_show_model())
		rows.add_child(model_pick)
		_row("models", model, model, _show_model)
		rows.add_child(UI.paragraph(tr("A binary glTF (.glb) up to 64 MiB, scaled to the original's size and centred where it sat; one texture for every livery. Ships and stations are built from these parts. Explosions and other animated figures keep their originals. Applies from the next scene."), 13, UI.TEXT_DIM))
	rows.add_child(UI.label(tr("By hand"), 15, UI.TEXT_GOOD))
	rows.add_child(UI.paragraph(tr("Interface images go in mods/interface/<name>.png and sound effects in mods/sounds/<name>.wav (or .ogg), named as in the converted content's img and sfx folders. A mods folder next to the executable works too; the one in the user data folder wins."), 13, UI.TEXT_DIM))
	if preview.texture == null: preview.texture = app.library.atlas_texture(ATLAS)
	var focus: Control = rows.find_child("*" + focus_key + "*", true, false) as Control if not focus_key.is_empty() else null
	var target: Control = focus if focus != null else first
	(func(): if is_instance_valid(target) and target.is_inside_tree(): target.grab_focus()).call_deferred()

## One replaceable file: its name, what stands for it, and the actions. The
## returned control takes focus first.
func _row(folder: String, name: String, label: String, show: Callable) -> Control:
	var line := HBoxContainer.new()
	line.add_theme_constant_override("separation", 6)
	rows.add_child(line)
	var text := VBoxContainer.new()
	text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	line.add_child(text)
	text.add_child(UI.label(label, 15))
	var using := Mods.replacement(folder, name)
	var mine := using.begins_with(Mods.user_root())
	text.add_child(UI.label(tr("Replaced: %s") % using.get_file() if not using.is_empty() else tr("Original"), 12,
		UI.TEXT_GOOD if not using.is_empty() else UI.TEXT_DIM))
	var view := UI.button(tr("Listen") if folder == "music" else tr("View"), show)
	view.name = "view_" + name
	line.add_child(view)
	var replace := UI.button(tr("Replace…"), func(): _pick(folder, name))
	replace.name = "replace_" + name
	line.add_child(replace)
	var restore := UI.button(tr("Restore original"), func(): _restore(folder, name), mine)
	restore.name = "restore_" + name
	line.add_child(restore)
	return view

func _pick(folder: String, name: String) -> void:
	focus_key = "replace_" + name
	var dialog := FileDialog.new()
	dialog.use_native_dialog = true
	dialog.access = FileDialog.ACCESS_FILESYSTEM
	dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	var filters := [tr("*.ogg, *.mp3, *.wav ; Audio")]
	if folder == "textures": filters = [tr("*.png ; PNG image")]
	elif folder == "models": filters = [tr("*.glb ; Binary glTF")]
	dialog.filters = PackedStringArray(filters)
	dialog.file_selected.connect(func(path: String):
		dialog.queue_free()
		replace_with(folder, name, path))
	dialog.canceled.connect(dialog.queue_free)
	add_child(dialog)
	dialog.popup_centered_ratio(0.7)

## Installs `path` for `name` and shows the result.
func replace_with(folder: String, name: String, path: String) -> void:
	var error := Mods.install(folder, name, path)
	if error.is_empty():
		_changed(folder, name)
		status.text = tr("Replaced with %s.") % path.get_file()
	else:
		status.text = error
	_build()

func _restore(folder: String, name: String) -> void:
	focus_key = "replace_" + name
	Mods.restore(folder, name)
	_changed(folder, name)
	var still := Mods.replacement(folder, name)
	status.text = tr("Original restored.") if still.is_empty() else tr("A replacement is still in %s.") % still.get_base_dir()
	_build()

func _changed(folder: String, name: String) -> void:
	app.library.forget_replacements()
	if folder == "textures":
		_show_texture(app.library.atlas_texture(name))
	elif folder == "models":
		_show_model()
	else:
		app.music_name = ""
		app.play_music(name)

func _show_texture(tex: Texture2D) -> void:
	preview.texture = tex
	preview.visible = true
	viewer.visible = false

func _show_model() -> void:
	if model.is_empty(): return
	preview.visible = false
	viewer.visible = true
	viewer.show_model(model)
	var using := Mods.replacement("models", model)
	status.text = tr("%s: replaced by %s. Drag to turn it.") % [model, using.get_file()] if not using.is_empty() else tr("%s: the original. Drag to turn it.") % model

## Every converted model drawn still (animated figures are not offered).
func _still_models() -> Array[String]:
	var found: Array[String] = []
	for entry in app.library.data.get("models", {}).values():
		var n := str(entry.get("name", ""))
		if n.is_empty() or n in ANIMATED or n in found: continue
		found.append(n)
	found.sort()
	return found
