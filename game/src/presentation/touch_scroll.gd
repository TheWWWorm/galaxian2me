extends Node
## Drag anywhere inside a list to scroll it, not only on its narrow bar.
## The rows are buttons, and a button takes the touch before the list can
## start its own drag, so the gesture is followed here. Once the finger has
## clearly travelled, the press is cancelled so the scroll does not also
## activate the row it started on; a short tap still selects it. A flick
## coasts on and slows to a stop.
##
## The press is cancelled by moving the emulated pointer off the button, not
## by swallowing the release: a swallowed release would leave the button
## owning the pointer, and the next tap would land on it.

const THRESHOLD := 10.0
const STOP_SPEED := 12.0
const FRICTION := 1800.0
## Far outside every control: a press let go here is let go elsewhere.
const AWAY := Vector2(-100000, -100000)

## The list the current finger, or the coasting after it, moves.
var target: ScrollContainer
var finger := -1
var travelled := 0.0
var scrolling := false
var last := Vector2.ZERO
var velocity := 0.0
var pointer_down := false
var pointer_from := Vector2.ZERO
var pointer_dragged := false
var pointer_guarded := false

func release() -> void:
	finger = -1
	scrolling = false
	velocity = 0.0
	target = null

func _usable() -> bool:
	# Pages rebuild their lists; a freed one is simply gone.
	return is_instance_valid(target) and target.is_visible_in_tree()

## The innermost list under the point that has something to scroll.
func list_at(point: Vector2) -> ScrollContainer:
	var hit := control_at(get_tree().root, point)
	while hit != null:
		if hit is ScrollContainer and hit.vertical_scroll_mode != ScrollContainer.SCROLL_MODE_DISABLED \
				and hit.get_global_rect().has_point(point):
			var bar: VScrollBar = hit.get_v_scroll_bar()
			if bar.max_value > bar.page: return hit
		hit = hit.get_parent() as Control
	return null

func _process(delta: float) -> void:
	if not _usable() or finger >= 0: return
	if absf(velocity) < STOP_SPEED:
		velocity = 0.0
		return
	target.scroll_vertical -= int(round(velocity * delta))
	velocity = move_toward(velocity, 0.0, FRICTION * delta)

func _input(event: InputEvent) -> void:
	_guard_pointer(event)
	if event is InputEventScreenTouch:
		if event.pressed:
			if finger < 0:
				var list := list_at(event.position)
				if list != null:
					target = list
					finger = event.index
					last = event.position
					travelled = 0.0
					scrolling = false
					velocity = 0.0
				elif event.index == 0:
					velocity = 0.0
		elif event.index == finger:
			finger = -1
			if scrolling: get_viewport().set_input_as_handled()
	elif event is InputEventScreenDrag and event.index == finger:
		if not _usable():
			release()
			return
		var step: Vector2 = event.position - last
		last = event.position
		travelled += absf(step.y)
		if travelled > THRESHOLD: scrolling = true
		if scrolling:
			target.scroll_vertical -= int(round(step.y))
			velocity = step.y * 60.0
			get_viewport().set_input_as_handled()
	elif scrolling and event is InputEventMouseButton and not event.pressed:
		scrolling = false

## Follows the pointer that touch emulates. Once it has travelled, its
## motion and release are moved off the button it pressed, which then lets
## go without firing.
func _guard_pointer(event: InputEvent) -> void:
	if not event is InputEventMouse or event.device != InputEvent.DEVICE_ID_EMULATION: return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			pointer_down = true
			pointer_dragged = false
			pointer_from = event.position
			pointer_guarded = _on_button(event.position)
			return
		if pointer_down and (pointer_dragged or scrolling) and pointer_guarded: _move_away(event)
		pointer_down = false
		pointer_dragged = false
	elif event is InputEventMouseMotion and pointer_down:
		if event.position.distance_to(pointer_from) > THRESHOLD: pointer_dragged = true
		if (pointer_dragged or scrolling) and pointer_guarded: _move_away(event)

func _move_away(event: InputEventMouse) -> void:
	event.position = AWAY
	event.global_position = AWAY

## Sliders and text fields follow the finger, so only buttons are guarded.
func _on_button(point: Vector2) -> bool:
	var hit := control_at(get_tree().root, point)
	while hit != null:
		if hit is BaseButton: return true
		hit = hit.get_parent() as Control
	return false

## The topmost visible control under a point that takes the pointer.
static func control_at(node: Node, point: Vector2) -> Control:
	if node is CanvasItem and not node.is_visible_in_tree(): return null
	for i in range(node.get_child_count() - 1, -1, -1):
		var found := control_at(node.get_child(i), point)
		if found != null: return found
	if node is Control and node.mouse_filter != Control.MOUSE_FILTER_IGNORE and node.get_global_rect().has_point(point): return node
	return null
