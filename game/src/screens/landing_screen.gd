extends Control
## Presentation only: docking, repairs, rewards and autosaving have already
## finished. Completion and every skip route only open the station screen.

const UI := preload("res://src/presentation/ui.gd")
const LandingView := preload("res://src/presentation/landing_view.gd")

var app
var scene := Node3D.new()
var view: LandingView
var elapsed := 0.0
var finished := false
var skip_button: Button

static func supported(owner) -> bool:
	return owner.game != null and not owner.game.session.in_void and LandingView.supported(owner.library,
		int(owner.game.system().faction), int(owner.game.session.ship.index))

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	app.world_root.add_child(scene)
	view = LandingView.new()
	var game = app.game
	view.setup_entry(app.library, app.catalogue, int(game.station().id), int(game.system().faction),
		int(game.session.ship.index), int(game.session.ship.faction))
	scene.add_child(view)
	LandingView.light_scene(scene)
	view.pose(0.0)
	view.camera.make_current()
	app.play_music("gof2_hangar")
	skip_button = UI.button(tr("Skip"), finish)
	skip_button.custom_minimum_size = Vector2(128, 52)
	skip_button.disabled = true
	var corner := MarginContainer.new()
	corner.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	corner.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	corner.grow_vertical = Control.GROW_DIRECTION_BEGIN
	corner.add_theme_constant_override("margin_right", 16)
	corner.add_theme_constant_override("margin_bottom", 16)
	add_child(corner)
	corner.add_child(skip_button)

func _process(delta: float) -> void:
	if finished: return
	elapsed += delta
	# Ignore the docking click/key still held as the new screen arrives.
	skip_button.disabled = elapsed < 0.3
	view.pose(elapsed)
	if elapsed >= LandingView.DURATION: finish()

func _unhandled_input(event: InputEvent) -> void:
	if elapsed < 0.3 or finished: return
	var skip := false
	if event is InputEventKey: skip = event.pressed and not event.echo
	elif event is InputEventJoypadButton: skip = event.pressed
	elif event is InputEventMouseButton: skip = event.pressed and event.button_index == MOUSE_BUTTON_LEFT
	elif event is InputEventScreenTouch: skip = event.pressed
	if skip:
		get_viewport().set_input_as_handled()
		finish()

func finish() -> void:
	if finished or app.screen != self: return
	finished = true
	# Finish the input batch before exposing station controls. Touch input
	# can also produce an emulated mouse click at the same screen position.
	_open_station.call_deferred()

func _open_station() -> void:
	if is_inside_tree() and app.screen == self: app.show_station()

func _exit_tree() -> void:
	if is_instance_valid(scene): scene.queue_free()
