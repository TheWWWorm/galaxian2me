extends SceneTree
## Lists scroll when dragged anywhere inside them; a drag that starts on a
## row does not press it, and a short tap still does. Memory-only.
const TouchScroll := preload("res://src/presentation/touch_scroll.gd")
var checks := 0
var failures := 0
var presses := {}

func _init() -> void:
	run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	print("PASS: " if ok else "FAIL: ", label)
	if not ok: failures += 1

## A finger and the pointer Godot emulates from it.
func touch(at: Vector2, down: bool) -> void:
	var t := InputEventScreenTouch.new()
	t.index = 0; t.position = at; t.pressed = down
	root.push_input(t)
	var m := InputEventMouseButton.new()
	m.device = InputEvent.DEVICE_ID_EMULATION
	m.button_index = MOUSE_BUTTON_LEFT; m.pressed = down
	m.position = at; m.global_position = at
	m.button_mask = MOUSE_BUTTON_MASK_LEFT if down else 0
	root.push_input(m)

func slide(from: Vector2, to: Vector2) -> void:
	var t := InputEventScreenDrag.new()
	t.index = 0; t.position = to; t.relative = to - from
	root.push_input(t)
	var m := InputEventMouseMotion.new()
	m.device = InputEvent.DEVICE_ID_EMULATION
	m.position = to; m.global_position = to; m.relative = to - from
	m.button_mask = MOUSE_BUTTON_MASK_LEFT
	root.push_input(m)

func run() -> void:
	root.size = Vector2i(800, 600)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
	var scroller := TouchScroll.new()
	root.add_child(scroller)
	var list := ScrollContainer.new()
	list.position = Vector2(100, 100)
	list.size = Vector2(300, 300)
	list.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	root.add_child(list)
	var rows := VBoxContainer.new()
	rows.custom_minimum_size.x = 280
	list.add_child(rows)
	for i in 40:
		var b := Button.new()
		b.text = "Row %d" % i
		b.custom_minimum_size.y = 40
		b.pressed.connect(func(): presses[i] = presses.get(i, 0) + 1)
		rows.add_child(b)
	await process_frame
	await process_frame
	check(scroller.list_at(Vector2(200, 200)) == list, "the list under the finger is found through its rows")
	check(scroller.list_at(Vector2(600, 200)) == null, "nothing is dragged outside the list")

	# A tap on a row presses it.
	var row_two := Vector2(200, 100 + 2 * 44 + 20)
	touch(row_two, true)
	touch(row_two, false)
	await process_frame
	check(presses.get(2, 0) == 1 and list.scroll_vertical == 0, "a short tap selects the row and does not scroll")

	# A drag from a row scrolls the list and leaves the row unpressed.
	var at := Vector2(200, 350)
	touch(at, true)
	for i in 20:
		var next := at + Vector2(0, -10)
		slide(at, next)
		at = next
	touch(at, false)
	await process_frame
	var row := int((350 - 100 + 0) / 44.0)
	check(list.scroll_vertical >= 180, "dragging anywhere in the list scrolls it (%d)" % list.scroll_vertical)
	check(presses.get(row, 0) == 0 and presses.get(row + 1, 0) == 0, "the row the drag started on is not pressed")
	var after := list.scroll_vertical
	for i in 5: await process_frame
	check(list.scroll_vertical >= after, "a flick coasts on in its direction")

	# The next tap lands where it is made.
	for i in 60: await process_frame
	var settled := list.scroll_vertical
	var target := Vector2(200, 120)
	touch(target, true)
	touch(target, false)
	await process_frame
	var hit := int((120 - 100 + settled) / 44.0)
	check(presses.get(hit, 0) == 1, "a tap after a scroll presses the row under it")
	print("TOUCH SCROLL: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
