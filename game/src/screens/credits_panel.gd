extends "res://src/presentation/ui.gd".Frame
## Title → Credits: the supplied game's own credits and copyright line,
## rolling slowly as the original's do, then this engine's notices. A
## wheel, drag, stick or arrow key takes over the scrolling.

const UI := preload("res://src/presentation/ui.gd")

## Pixels a second the roll advances by itself.
const ROLL_SPEED := 28.0

signal closed

var app
var scroll: ScrollContainer
var rolling := true
var roll := 0.0

func _init() -> void:
	super._init("")

func _ready() -> void:
	var lib = app.library
	title = lib.text(21)
	custom_minimum_size = Vector2(620, 520)
	var outer := VBoxContainer.new()
	outer.add_theme_constant_override("separation", 8)
	add_child(outer)
	scroll = ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(580, 440)
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	outer.add_child(scroll)
	var roll_box := VBoxContainer.new()
	roll_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	roll_box.add_theme_constant_override("separation", 18)
	scroll.add_child(roll_box)
	# A screen's height of space first, so the roll comes up from below.
	var lead := Control.new()
	lead.custom_minimum_size.y = 400
	roll_box.add_child(lead)
	roll_box.add_child(_centred(lib.text(25), 16, UI.TEXT))
	roll_box.add_child(_centred(lib.text(23), 13, UI.TEXT_DIM))
	roll_box.add_child(_centred(lib.text(24), 16, UI.TEXT_GOOD))
	roll_box.add_child(_centred(tr("-This engine-\nAn independent remake that plays the game from your own JAR.\nIts source is licensed under the Apache License 2.0.\n\nMicro3D model decoder ported from J2ME-Loader\n(Yury Kharchenko, Apache License 2.0)\n\nMade with the Godot Engine (MIT license)"), 13, UI.TEXT_DIM))
	var tail := Control.new()
	tail.custom_minimum_size.y = 200
	roll_box.add_child(tail)
	var back := UI.button(lib.text(65), func():
		closed.emit()
		queue_free())
	back.alignment = HORIZONTAL_ALIGNMENT_CENTER
	outer.add_child(back)
	back.grab_focus.call_deferred()
	scroll.gui_input.connect(_take_over)

func _centred(text: String, size: int, color: Color) -> Label:
	var l := UI.paragraph(text, size, color)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return l

func _process(delta: float) -> void:
	if not rolling: return
	roll += ROLL_SPEED * delta
	scroll.scroll_vertical = int(roll)
	# Stop at the end rather than looping.
	if scroll.scroll_vertical < int(roll) - 1: rolling = false

func _take_over(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventScreenDrag or event is InputEventScreenTouch:
		rolling = false

func _unhandled_input(event: InputEvent) -> void:
	if not is_visible_in_tree(): return
	for action in ["ui_up", "ui_down"]:
		if event.is_action_pressed(action):
			rolling = false
			scroll.scroll_vertical += 60 if action == "ui_down" else -60
			get_viewport().set_input_as_handled()
