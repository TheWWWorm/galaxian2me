extends CanvasLayer
## Full-screen placement editor for the touch controls: drag the stick or a
## button to move it, Reset puts everything back, Done keeps the new places.

const UI := preload("res://src/presentation/ui.gd")
const Touch := preload("res://src/flight/touch_controls.gd")

signal closed

var app
var touch: Touch
var chosen: Label
var smaller: Button
var larger: Button
var reset_one: Button

func _ready() -> void:
	layer = 60
	var shade := ColorRect.new()
	shade.color = Color(0.0, 0.02, 0.05, 0.82)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(shade)
	touch = Touch.new()
	touch.app = app
	touch.editing = true
	add_child(touch)
	touch._load_offsets()
	touch._layout()
	var bar := VBoxContainer.new()
	# The middle of the screen, clear of every control's default place.
	bar.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	bar.grow_horizontal = Control.GROW_DIRECTION_BOTH
	bar.grow_vertical = Control.GROW_DIRECTION_BOTH
	bar.add_theme_constant_override("separation", 10)
	add_child(bar)
	var hint := UI.label("Drag a control to move it. Tap one to select it and change its size.", 16)
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	bar.add_child(hint)
	chosen = UI.label("", 15, UI.TEXT_GOOD)
	chosen.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	bar.add_child(chosen)
	var sizing := HBoxContainer.new()
	sizing.alignment = BoxContainer.ALIGNMENT_CENTER
	sizing.add_theme_constant_override("separation", 12)
	bar.add_child(sizing)
	smaller = UI.button("Smaller", func(): touch.resize_selected(-0.1))
	larger = UI.button("Larger", func(): touch.resize_selected(0.1))
	reset_one = UI.button("Reset this one", func(): touch.reset_selected())
	for b in [smaller, larger, reset_one]:
		b.custom_minimum_size = Vector2(140, 44)
		b.alignment = HORIZONTAL_ALIGNMENT_CENTER
		sizing.add_child(b)
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 12)
	bar.add_child(row)
	var reset := UI.button("Reset all", func(): touch.reset_offsets())
	var done := UI.button("Done", _done)
	for b in [reset, done]:
		b.custom_minimum_size = Vector2(140, 44)
		b.alignment = HORIZONTAL_ALIGNMENT_CENTER
		row.add_child(b)
	touch.selection_changed.connect(_show_selection)
	_show_selection()
	done.grab_focus.call_deferred()

func _show_selection() -> void:
	var key := touch.selected
	chosen.text = "No control selected" if key.is_empty() else "%s · %d%%" % [touch.control_name(key), int(round(touch.selected_size() * 100.0))]
	smaller.disabled = key.is_empty() or touch.selected_size() <= Touch.MIN_SIZE + 0.001
	larger.disabled = key.is_empty() or touch.selected_size() >= Touch.MAX_SIZE - 0.001
	reset_one.disabled = key.is_empty()

func _done() -> void:
	touch.save_offsets()
	closed.emit()
	queue_free()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		closed.emit()
		queue_free()
