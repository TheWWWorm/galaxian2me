extends Control
## Conversation box in the original's style: the speaker's portrait and name
## above the line, paged with Next/Back like the phone game.

const UI := preload("res://src/presentation/ui.gd")
const Portrait := preload("res://src/presentation/portrait.gd")

signal finished

var app
var lines: Array = []
var index := 0
var frame
var portrait: Control
## Mission dialogue (briefing/result) rather than a help or notice box.
var chime := false
var name_label: Label
var text: Label
## What to press here for keys the line names in the phone's terms.
var key_note: Label
var next_button: Button
var back_button: Button

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	# The original chimes only when a mission's own dialogue opens (briefing,
	# success, failure); help windows and computer notices are silent.
	if app != null and chime: app.play_sound("fx_message_02", 0.7)
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.35)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(shade)
	frame = UI.Frame.new("")
	frame.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	frame.custom_minimum_size = Vector2(760, 0)
	frame.grow_horizontal = Control.GROW_DIRECTION_BOTH
	frame.grow_vertical = Control.GROW_DIRECTION_BEGIN
	frame.offset_bottom = -30
	add_child(frame)
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 14)
	frame.add_child(h)
	portrait = Control.new()
	portrait.custom_minimum_size = Vector2(96, 96)
	h.add_child(portrait)
	var v := VBoxContainer.new()
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(v)
	text = UI.paragraph("", 16)
	text.custom_minimum_size = Vector2(560, 90)
	v.add_child(text)
	key_note = UI.paragraph("", 13, UI.TEXT_DIM)
	key_note.custom_minimum_size.x = 560
	v.add_child(key_note)
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_END
	v.add_child(row)
	back_button = UI.button(app.library.text(74), _back)
	row.add_child(back_button)
	next_button = UI.button(app.library.text(75), _next)
	row.add_child(next_button)
	_show()

func _show() -> void:
	var line: Dictionary = lines[index]
	frame.title = str(line.get("name", ""))
	frame.queue_redraw()
	text.text = str(line.get("text", ""))
	key_note.text = preload("res://src/screens/help_panel.gd").key_note(app, text.text)
	key_note.visible = not key_note.text.is_empty()
	for c in portrait.get_children(): c.queue_free()
	# Help windows and notices have nobody speaking: no empty portrait box.
	var face: Array = line.get("face", [])
	portrait.visible = not face.is_empty() or int(line.get("speaker", -1)) >= 0
	if portrait.visible:
		var p := Portrait.make(app.library, int(line.get("speaker", -1)), face)
		if p != null: portrait.add_child(p)
	back_button.disabled = index == 0
	next_button.text = app.library.text(75) if index < lines.size() - 1 else app.library.text(35)
	next_button.grab_focus.call_deferred()

func _next() -> void:
	if index < lines.size() - 1:
		index += 1
		_show()
	else:
		finished.emit()

func _back() -> void:
	if index > 0:
		index -= 1
		_show()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		finished.emit()
