extends Control
## In flight: owns the space simulation, its 3D view and the HUD.

const SafeMargins := preload("res://src/presentation/safe_margins.gd")
const UI := preload("res://src/presentation/ui.gd")
const Space := preload("res://src/flight/space.gd")
const SpaceView := preload("res://src/flight/space_view.gd")
const Hud := preload("res://src/flight/hud.gd")
const Controls := preload("res://src/flight/controls.gd")
const TouchControls := preload("res://src/flight/touch_controls.gd")
const MapPanel := preload("res://src/screens/station/map_panel.gd")
const Wingmen := preload("res://src/flight/wingmen.gd")

var app
var game
var space: Space
var view: SpaceView
var hud: Hud
var controls: Controls
var paused := false
var menu_paused := false
var defeated := false
var conversation: Control
var touch: TouchControls
var navigation_layer: Control
var navigation_panel: Control
var wingmen_expiry_shown := false

func _ready() -> void:
	game = app.game
	# A controller dropping out mid-flight pauses the game.
	Input.joy_connection_changed.connect(_on_joy_connection)
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	space = Space.new(game)
	space.start_sequence = bool(app.setting("interface", "launch_sequence", true))
	space.build()
	view = SpaceView.new()
	view.setup(app, space)
	app.world_root.add_child(view)
	controls = Controls.new()
	controls.app = app
	add_child(controls)
	var flare := preload("res://src/flight/lens_flare.gd").new()
	flare.app = app
	flare.view = view
	add_child(flare)
	hud = Hud.new()
	hud.app = app
	hud.space = space
	hud.view = view
	add_child(hud)
	if TouchControls.wanted(app):
		touch = TouchControls.new()
		touch.app = app
		touch.pause_requested.connect(func(): set_paused(true))
		touch.radio_requested.connect(_next_radio)
		add_child(touch)
		controls.touch = touch
		hud.touch_layout = true
		hud.touch = touch
		_update_touch_context()
		_inset_touch()
		get_viewport().size_changed.connect(_inset_touch)
	space.event.connect(_on_event)
	app.play_music("gof2_gneutral" if randi() % 2 == 0 else "gof2_gaction")
	# The story step's briefing plays when the flight begins, as a paused
	# conversation like the original's.
	# Ordinary goals (including the first mining tutorial) have no scripted
	# Story scene, but still carry an imported campaign briefing.
	var mission: Dictionary = game.session.story_mission
	var story_here: bool = not mission.is_empty() and int(mission.get("station", -2)) == game.session.location_id()
	var job_scene: bool = space.story != null and not space.story.job.is_empty()
	var lines: Array = game.campaign.take_briefing() if story_here and not job_scene else []
	if not lines.is_empty():
		# The opening's briefing comes at the original's first five-second
		# check, over the scene's silent start, not before it.
		if int(game.session.story_step) == 0:
			get_tree().create_timer(5.0).timeout.connect(func():
				if is_inside_tree() and app.screen == self and not defeated: _conversation(lines, Callable(), true))
		else: _conversation(lines, Callable(), true)
	if bool(game.destination.get("drive", false)): _start_programmed_drive.call_deferred()

func _start_programmed_drive() -> void:
	if app.screen != self or conversation != null or defeated: return
	if not space.jump_to(int(game.destination.get("station", -2))): hud.message(space.drive_error())

## A conversation box over the paused flight.
func _conversation(lines: Array, after := Callable(), chime := false) -> void:
	var d := preload("res://src/screens/dialogue_panel.gd").new()
	d.app = app
	d.chime = chime
	d.lines = lines
	conversation = d
	_sync_pause()
	d.finished.connect(func():
		d.queue_free()
		if conversation == d: conversation = null
		_sync_pause()
		if after.is_valid() and app.screen == self and not defeated: after.call())
	add_child(d)

## A menu pause must not release a briefing or defeat lock.
func set_paused(on: bool) -> void:
	menu_paused = on
	hud.set_paused(on)
	_sync_pause()

func _sync_pause() -> void:
	paused = menu_paused or conversation != null or defeated or navigation_layer != null or photo
	# Enter answers a conversation box, so the scene's skip hint stands down.
	hud.skip_hint = not paused
	controls.reset()
	_apply_touch()

## Touch set to Auto: a key, a mouse or a pad puts the on-screen controls
## away (and the HUD back in its desktop layout) until the screen is
## touched again. Mouse events a touch generates, and stick drift, do not
## count.
var touch_idle := false

func _apply_touch() -> void:
	if touch == null: return
	touch.visible = not paused and not touch_idle
	hud.touch_layout = not touch_idle
	hud.touch = null if touch_idle else touch
	# The mouse steers again while the touch controls are put away.
	controls.mouse_steer = touch_idle and bool(app.setting("controls", "mouse", true)) and not OS.has_feature("mobile")
	_update_touch_context()

func _input(event: InputEvent) -> void:
	if touch == null or str(app.setting("controls", "touch", "auto")) != "auto": return
	var other := false
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if touch_idle:
			touch_idle = false
			_apply_touch()
		return
	if event is InputEventKey: other = event.pressed and not event.echo
	elif event is InputEventJoypadButton: other = event.pressed
	elif event is InputEventJoypadMotion: other = absf(event.axis_value) > 0.5
	elif event is InputEventMouseButton: other = event.pressed and event.device != InputEvent.DEVICE_ID_EMULATION
	elif event is InputEventMouseMotion: other = event.device != InputEvent.DEVICE_ID_EMULATION and event.relative.length() > 3.0
	if other and not touch_idle:
		touch_idle = true
		_apply_touch()

## The touch controls keep clear of a notch; the HUD insets its own panels.
var own_safe_margins := true

func _inset_touch() -> void:
	if touch == null or not is_inside_tree(): return
	var m := SafeMargins.margins(get_viewport_rect().size, true)
	touch.offset_left = m.side
	touch.offset_right = -m.side
	touch.offset_top = m.top
	touch.offset_bottom = -m.bottom

func _update_touch_context() -> void:
	if touch == null: return
	var story = space.story
	var skip: bool = story != null and story.message().is_empty() and story.can_skip_wait()
	touch.radio_label = "Skip" if skip else ""
	# As in Deep, buttons for missing equipment stay away until it is fitted.
	touch.set_fitted({"boost": int(game.session.ship_stats().get("boost_length", 0)) > 0,
		"secondary": not space.secondary_launchers().is_empty()})
	touch.set_context(not paused and not space.navigation_locked(),
		not paused and not space.portal_arriving() and story != null and (not story.message().is_empty() or skip))

func _next_radio() -> void:
	if not paused and not space.portal_arriving() and space.story != null:
		if space.story.message().is_empty(): space.story.skip_wait()
		else: space.story.skip_message()
		_update_touch_context()

func _on_joy_connection(_pad: int, connected: bool) -> void:
	if not connected and is_inside_tree() and not paused: set_paused(true)

func _notification(what: int) -> void:
	if not is_node_ready(): return
	# Switching windows (a screenshot tool, say) only lets go of held keys;
	# pausing then is an option. A phone putting the game away always pauses.
	if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		controls.reset()
		if bool(app.setting("controls", "pause_on_focus_loss", false)): set_paused(true)
	elif what == NOTIFICATION_APPLICATION_PAUSED:
		set_paused(true)

var story_poll := 0.0
var tip_poll := 0.0
const Tips := preload("res://src/presentation/tips.gd")
var flight_ms := 0
var ms_carry := 0.0

func _physics_process(delta: float) -> void:
	if paused: return
	var input: Dictionary = controls.state(view)
	if bool(input.get("auto_fire_toggled", false)):
		# The original's "Auto fire On" / "Auto fire Off".
		hud.message(app.library.text(13) + " " + app.library.text(15 if bool(input.get("auto_fire", false)) else 16))
	if bool(input.get("action_menu", false)): open_actions()
	elif bool(input.get("map", false)): open_navigation("route")
	if paused: return
	# Docking can synchronously create the checkpoint inside space.step().
	# Account for this frame before that boundary, never mutate the session
	# from a flight screen that has already been replaced by the station.
	if bool(input.get("time_warp", false)):
		if space.time_warp_allowed():
			var at: int = space.TIME_SCALES.find(space.time_scale)
			space.time_scale = space.TIME_SCALES[(at + 1) % space.TIME_SCALES.size()]
		else:
			space.event.emit("message", {"text": "Time speed-up needs the autopilot and no enemies near"})
	# Accelerated time runs several ordinary steps per frame and stops the
	# moment anything needs the pilot.
	var steps := 1
	if space.time_scale > 1:
		if space.time_warp_allowed() and conversation == null: steps = space.time_scale
		else: space.time_scale = 1
	# The view draws between the poses before and after this tick.
	space.restore_poses()
	for b in space.bodies:
		b.prev_pos = b.pos
		b.prev_basis = b.basis
	# The simulation counts whole milliseconds; carry the fraction over so
	# game time keeps pace with real time (60 Hz is 16.67 ms, not 16).
	ms_carry += delta * 1000.0
	var tick := int(ms_carry)
	ms_carry -= tick
	var step_delta := (float(tick) + 0.01) / 1000.0
	for i in steps:
		game.session.playtime_ms += tick
		flight_ms += tick
		space.step(step_delta, input if i == 0 else {"yaw": 0.0, "pitch": 0.0})
		if app.screen != self or is_queued_for_deletion() or defeated or paused: return
		if i > 0 and not space.time_warp_allowed():
			space.time_scale = 1
			break
	if app.screen != self or is_queued_for_deletion() or defeated: return
	if touch != null:
		touch.set_warp("Time ×%d" % space.time_scale if space.time_scale > 1 else ("Faster" if space.time_warp_allowed() else ""))
	if space.portal_arriving() or space.using_jump_drive: return
	# Main/o announces elapsed contracts once in the current area. The
	# original level builder removes their roster on the next area entry.
	var crew: Array = game.session.flags.get("wingmen", [])
	if not wingmen_expiry_shown and not crew.is_empty() and int(game.session.flags.get("wingmen_remaining_ms", 0)) <= 0:
		wingmen_expiry_shown = true
		_conversation([{"text": app.library.text(153), "name": str(crew[0]), "face": game.session.flags.get("wingmen_face", [])}])
		return
	# First-time help, from five seconds into a flight (Main/o).
	tip_poll += delta
	if tip_poll > 1.0 and flight_ms > 5000 and conversation == null and not space.navigation_locked() and (space.story == null or space.story.step > 1):
		tip_poll = 0.0
		var tip := Tips.flight_tip(app, space)
		if not tip.is_empty():
			_conversation([tip])
			return
	# The original checks story goals every few seconds in flight.
	story_poll += delta
	if story_poll > 1.0 and (space.story == null or space.story.step > 1):
		story_poll = 0.0
		if game.campaign.check(false, game.session.location_id(), flight_ms):
			var before: int = game.session.story_step
			if before == 41 and game.session.in_void:
				var result_lines: Array = game.campaign.dialogue(before, 1)
				if not result_lines.is_empty(): _conversation(result_lines, _finish_final_delivery, true)
				else: _finish_final_delivery()
				return
			if before == 42 and not game.session.in_void:
				var result_lines: Array = game.campaign.dialogue(before, 1)
				if not result_lines.is_empty(): _conversation(result_lines, _finish_final_return, true)
				else: _finish_final_return()
				return
			if before == 29 and game.session.in_void:
				var result_lines: Array = game.campaign.dialogue(before, 1)
				if not result_lines.is_empty(): _conversation(result_lines, _finish_void_probe, true)
				else: _finish_void_probe()
				return
			if before == 25 and game.session.in_void:
				var result_lines: Array = game.campaign.dialogue(before, 1)
				if not result_lines.is_empty(): _conversation(result_lines, _finish_void_arrival, true)
				else: _finish_void_arrival()
				return
			if before in [14, 21]:
				# The convoy moves Keith out of gate-less Mido; the EMP rescue
				# returns him to the current station. Both supplied transitions
				# occur only AFTER the player closes the success dialogue.
				var result_lines: Array = game.campaign.dialogue(before, 2)
				var transfer := _finish_story_station_transfer.bind(before)
				if not result_lines.is_empty(): _conversation(result_lines, transfer, true)
				else: transfer.call()
				return
			var lines: Array = game.campaign.conclude()
			game.pending_dialogue = []
			if space.story != null: space.story.step_changed(before + 1)
			if not lines.is_empty(): _conversation(lines, Callable(), true)

## Delivery is not yet escape. Keep the result at step41 while it is read,
## then arm the source deadline in this same world with its actual damage.
func _finish_final_delivery() -> void:
	if app.screen != self or defeated or game.session.story_step != 41 or not game.session.in_void: return
	if space.story == null or space.story.step != 41 or space.story.failed or not space.story.complete: return
	if space.story.cast.is_empty() or not space.story.cast[0].alive or space.story.cast[0].speed != 0.0: return
	if not game.campaign.check(false, -1, flight_ms): return
	space._store_ship_state()
	game.campaign.conclude()
	game.pending_dialogue = []
	space.story.begin_final_escape()

## Crossing itself leaves step42 active. Ten seconds in the normal world
## earns Brent's result, and only closing it requests the Alioth epilogue.
func _finish_final_return() -> void:
	if app.screen != self or defeated or game.session.story_step != 42 or game.session.in_void: return
	if not game.campaign.check(false, game.session.location_id(), flight_ms): return
	space._store_ship_state()
	game.campaign.conclude()
	game.pending_dialogue = []
	if space.story != null: space.story.step_changed(game.session.story_step)

## Main/o.java's results at 14 and 21 advance to 15 and 22, then enter the
## station module. Only the convoy changes station; EMP returns where it began.
## Keep normal docking settlement, service and autosave as one transaction.
func _finish_story_station_transfer(before: int) -> void:
	if before not in [14, 21] or app.screen != self or defeated or game.session.story_step != before: return
	if not game.campaign.check(false, game.session.station_id, flight_ms): return
	var origin: int = game.session.station_id
	game.campaign.conclude()
	game.pending_dialogue = []
	var destination: int = origin if before == 21 else int(game.session.story_mission.get("station", -1))
	if destination < 0 or app.catalogue.station(destination).is_empty(): return
	space._store_ship_state()
	game.dock(destination)
	app.show_station()

## An earned flight boundary, not a docking shortcut. Preserve durability,
## cargo and the Void return address before writing the native checkpoint.
func _finish_void_arrival() -> void:
	if app.screen != self or defeated or game.session.story_step != 25 or not game.session.in_void: return
	if not game.campaign.check(false, -1, flight_ms): return
	space._store_ship_state()
	game.campaign.conclude()
	game.pending_dialogue = []
	if space.story != null: space.story.step_changed(game.session.story_step)
	app.save_game(app.AUTOSAVE_SLOT)

func _process(delta: float) -> void:
	if photo:
		# Pads orbit with the right (or left) stick and zoom with the triggers.
		for pad in Input.get_connected_joypads():
			var stick := Vector2(Input.get_joy_axis(pad, JOY_AXIS_RIGHT_X), Input.get_joy_axis(pad, JOY_AXIS_RIGHT_Y))
			if stick.length() < 0.2: stick = Vector2(Input.get_joy_axis(pad, JOY_AXIS_LEFT_X), Input.get_joy_axis(pad, JOY_AXIS_LEFT_Y))
			if stick.length() > 0.2:
				view.photo_yaw -= stick.x * delta * 2.0
				view.photo_pitch = clampf(view.photo_pitch + stick.y * delta * 1.5, -1.45, 1.45)
			var z := Input.get_joy_axis(pad, JOY_AXIS_TRIGGER_RIGHT) - Input.get_joy_axis(pad, JOY_AXIS_TRIGGER_LEFT)
			if absf(z) > 0.1: view.photo_distance = clampf(view.photo_distance * (1.0 - z * delta), 900.0, 40000.0)
	view.sync(delta)
	_update_touch_context()
	_sync_mouse_capture()

## Flying with the mouse keeps the pointer captured the whole flight, scenes
## included (Deep's flight); a menu, pause, conversation or lost focus hands
## it back.
func _sync_mouse_capture() -> void:
	var want: bool = controls.mouse_steer and not paused and DisplayServer.get_name() != "headless" \
		and DisplayServer.window_is_focused() and bool(app.setting("controls", "capture_mouse", true))
	var mode := Input.MOUSE_MODE_CAPTURED if want else Input.MOUSE_MODE_VISIBLE
	if Input.mouse_mode != mode: Input.mouse_mode = mode
	var now := Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	if now != controls.captured:
		controls.captured = now
		controls.mouse_turn = Vector2.ZERO

## Preserve the completed scan only after its actual result is acknowledged.
## It remains a Void flight; this transaction never docks or repairs the ship.
func _finish_void_probe() -> void:
	if app.screen != self or defeated or game.session.story_step != 29 or not game.session.in_void: return
	if not game.campaign.check(false, -1, flight_ms): return
	space._store_ship_state()
	game.campaign.conclude()
	game.pending_dialogue = []
	if space.story != null: space.story.step_changed(game.session.story_step)
	app.save_game(app.AUTOSAVE_SLOT)

func _on_event(kind: String, data: Dictionary) -> void:
	match kind:
		"docked":
			game.dock(int(data.station))
			app.show_station()
		"jumped":
			game.jump_arrive(int(data.system), int(data.station))
			app.show_flight()
		"drive_arrived":
			if game.drive_arrive(data): app.show_flight()
		"gate_menu":
			open_navigation("gate")
		"autopilot_list":
			open_autopilot.call_deferred()
		"wormhole_crossed":
			var escort_crossing: bool = game.session.story_step == 40 and space.story != null and space.story.active()
			if escort_crossing:
				if not space.story.finish_portal_escort(): return
			# Crossing during the original salvage cinematic advances 24 to
			# 25. Fast radio acknowledgement may already have concluded 24;
			# do not advance twice and bypass the genuine Void arrival goal.
			if game.session.story_step == 24 and space.story != null and space.story.stage >= 2:
				game.campaign.advance()
				game.pending_dialogue = []
			elif game.session.story_step == 28 and space.story != null and space.story.active():
				game.campaign.advance()
				game.pending_dialogue = []
			game.cross_wormhole()
			app.show_flight()
			# A real escort crossing is a flight checkpoint, not a station
			# visit: persist damaged ships and the uncompleted next objective.
			if escort_crossing: app.save_game(app.AUTOSAVE_SLOT)
		"destroyed":
			hud.message(app.library.text(156), 6.0)
			defeated = true
			_sync_pause()
			# The wreck burns out first, then the way on is offered.
			await get_tree().create_timer(3.0).timeout
			if app.screen != self or not is_inside_tree(): return
			var checkpoint: Dictionary = app.slot_summary(app.AUTOSAVE_SLOT)
			var label := "Start again"
			if not checkpoint.is_empty():
				label = "Continue from %s" % app.catalogue.station_name(int(checkpoint.get("station", -1)))
			hud.game_over(label, app.recover_from_defeat, app.show_title)
		"final_escape_failed":
			# A timed mission loss is not a projectile hit or a successful
			# conclusion. Acknowledge the supplied failure message, then use
			# normal checkpoint recovery; never save this failed world.
			_conversation([{"speaker": -1, "name": "", "text": app.library.text(213)}], app.recover_from_defeat)
		"message":
			hud.message(str(data.text), float(data.get("time", 3.0)))
		"sound":
			app.play_sound(str(data.name), float(data.get("volume", 1.0)))
		"music":
			app.play_music(str(data.name))
		"job_report":
			_conversation([{"speaker": -1, "name": str(data.name), "face": data.get("face", []), "text": str(data.text)}])
		"story_next":
			# The scripted scene is over: the story moves on, either into the
			# next scene in space or to the station it continues at.
			if str(data.get("to", "")) == "station":
				game.dock(game.session.station_id)
				app.show_station()
			else:
				game.campaign.advance()
				app.show_flight()

## Photo mode: freezes the flight, hides the interface and lets the camera
## orbit the ship (drag or arrow keys to turn, wheel or +/- to zoom).
var photo := false
var photo_caption: Control

## Photo mode's Save picture: the frame without the bar.
func _photo_picture() -> void:
	if photo_caption == null: return
	photo_caption.visible = false
	await app.save_picture()
	if photo_caption != null: photo_caption.visible = true

func set_photo(on: bool) -> void:
	if on == photo: return
	photo = on
	view.photo = on
	hud.visible = not on
	if on:
		view.photo_yaw = atan2(-space.player.forward().x, -space.player.forward().z) + PI
		# A bar with every action, so photo mode needs no keyboard.
		var bar := VBoxContainer.new()
		bar.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
		bar.grow_horizontal = Control.GROW_DIRECTION_BOTH
		bar.grow_vertical = Control.GROW_DIRECTION_BEGIN
		bar.offset_bottom = -16
		var caption := UI.label("PHOTO MODE  ·  drag, arrows or right stick to orbit  ·  wheel, +/- or triggers to zoom  ·  F12 saves a picture  ·  %s or Esc to return" %
			preload("res://src/presentation/preferences.gd").key_name("photo"), 13, UI.TEXT_DIM)
		caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		bar.add_child(caption)
		var row := HBoxContainer.new()
		row.alignment = BoxContainer.ALIGNMENT_CENTER
		row.add_theme_constant_override("separation", 8)
		bar.add_child(row)
		var zoom := func(f: float): view.photo_distance = clampf(view.photo_distance * f, 900.0, 40000.0)
		for spec in [["Zoom in", zoom.bind(0.8)], ["Zoom out", zoom.bind(1.25)],
				["Save picture", _photo_picture], ["Hide bar", func(): photo_caption.visible = false],
				["Back to flight", func(): set_photo(false)]]:
			var b := UI.button(spec[0], spec[1])
			b.alignment = HORIZONTAL_ALIGNMENT_CENTER
			b.custom_minimum_size = Vector2(120, 44)
			row.add_child(b)
		photo_caption = bar
		add_child(bar)
	elif photo_caption != null:
		photo_caption.queue_free()
		photo_caption = null
	_sync_pause()

func _photo_input(event: InputEvent) -> bool:
	# A hidden bar comes back with the next click or tap.
	if photo_caption != null and not photo_caption.visible and ((event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT) or (event is InputEventScreenTouch and event.pressed)):
		photo_caption.visible = true
		return true
	if event is InputEventMouseMotion and event.button_mask != 0:
		view.photo_yaw -= event.relative.x * 0.008
		view.photo_pitch = clampf(view.photo_pitch + event.relative.y * 0.006, -1.45, 1.45)
		return true
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP: view.photo_distance = maxf(900.0, view.photo_distance * 0.9); return true
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN: view.photo_distance = minf(40000.0, view.photo_distance * 1.1); return true
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_LEFT, KEY_A: view.photo_yaw += 0.08; return true
			KEY_RIGHT, KEY_D: view.photo_yaw -= 0.08; return true
			KEY_UP, KEY_W: view.photo_pitch = clampf(view.photo_pitch + 0.06, -1.45, 1.45); return true
			KEY_DOWN, KEY_S: view.photo_pitch = clampf(view.photo_pitch - 0.06, -1.45, 1.45); return true
			KEY_EQUAL, KEY_KP_ADD: view.photo_distance = maxf(900.0, view.photo_distance * 0.9); return true
			KEY_MINUS, KEY_KP_SUBTRACT: view.photo_distance = minf(40000.0, view.photo_distance * 1.1); return true
	return false

func _unhandled_input(event: InputEvent) -> void:
	if photo:
		if event.is_action_pressed("photo") or event.is_action_pressed("ui_cancel") or event.is_action_pressed("pause"):
			set_photo(false)
			get_viewport().set_input_as_handled()
		elif _photo_input(event):
			get_viewport().set_input_as_handled()
		return
	if event.is_echo(): return
	if conversation != null or defeated: return
	if event.is_action_pressed("photo") and navigation_layer == null and not menu_paused and not space.navigation_locked():
		set_photo(true)
		get_viewport().set_input_as_handled()
		return
	if navigation_layer != null:
		if event.is_action_pressed("ui_cancel") or event.is_action_pressed("pause"):
			close_navigation()
			get_viewport().set_input_as_handled()
		return
	var click: bool = event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT
	var tap: bool = event is InputEventScreenTouch and event.pressed
	if space.starting() and not paused and (event.is_action_pressed("ui_accept") or click or tap):
		space.skip_start()
		get_viewport().set_input_as_handled()
		return
	var cinematic: bool = space.story != null and space.story.controls_locked
	if (event.is_action_pressed("ui_accept") or click and cinematic) and not paused and space.story != null:
		_next_radio()
		get_viewport().set_input_as_handled()
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("pause"):
		set_paused(not menu_paused)
		get_viewport().set_input_as_handled()

## Modal flight controls use the same pause ownership as briefings. Closing
## a map never releases a focus-loss pause, defeat or active conversation.
func _navigation_box(title: String) -> VBoxContainer:
	close_navigation()
	navigation_layer = Control.new()
	navigation_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	navigation_layer.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(navigation_layer)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	navigation_layer.add_child(center)
	var frame := UI.Frame.new(title)
	frame.custom_minimum_size.x = 440
	center.add_child(frame)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	frame.add_child(box)
	navigation_panel = box
	_sync_pause()
	return box

func open_actions() -> void:
	if conversation != null or defeated or menu_paused or space.navigation_locked(): return
	# The original clicks as its action menu and weapon submenu open.
	app.play_sound("fx_menu_04")
	var box := _navigation_box(app.library.text(136))
	var tip := Tips.station_tip(app, "action_menu")
	if not tip.is_empty(): box.add_child(UI.paragraph(str(tip.text), 13, UI.TEXT_DIM))
	box.add_child(_quick_icon(UI.button(app.catalogue.item_name(85), open_drive,
		game.session.has_equipped_type(app.catalogue.Type.JUMP_DRIVE)), 6))
	if space.has_cloak():
		var device: Dictionary = game.session.equipped_of_type(app.catalogue.Type.CLOAK)
		box.add_child(_quick_icon(UI.button(app.catalogue.item_name(int(device.id)), func():
			close_navigation()
			space.toggle_cloak(), space.cloak > 0 or space.cloak_ready()), 4))
	# 124: "Secondary weapons", the original quick menu's launcher choice.
	box.add_child(_quick_icon(UI.button(app.library.text(124), open_secondaries, not space.secondary_launchers().is_empty()), 3))
	box.add_child(_quick_icon(UI.button(app.library.text(72), open_navigation.bind("route")), -1))
	# 292: "Autopilot", the original's list of places to fly to.
	box.add_child(_quick_icon(UI.button(app.library.text(292), open_autopilot, not space.autopilot_choices().is_empty()), -1))
	box.add_child(_quick_icon(UI.button(app.library.text(146), open_wingmen, not Wingmen.living(space).is_empty()), 5))
	box.add_child(_quick_icon(UI.button("Back to flight", close_navigation), -1))
	for b in box.get_children():
		if b is Button and b.disabled: b.focus_mode = Control.FOCUS_NONE
	for b in box.get_children():
		if b is Button and not b.disabled:
			b.grab_focus.call_deferred()
			break

## The original quick menu's picture for an action (a quickmenu.png frame:
## 3 secondary weapons, 4 cloak, 5 wingmen, 6 drive, 7-10 wingman orders);
## -1 keeps the row aligned with an empty square.
func _quick_icon(b: Button, frame: int) -> Button:
	var sheet: Texture2D = app.library.texture("quickmenu")
	if sheet == null: return b
	var h := sheet.get_height()
	if frame >= 0:
		var a := AtlasTexture.new()
		a.atlas = sheet
		a.region = Rect2(frame * h, 0, h, h)
		b.icon = a
	else:
		var blank := Image.create(h, h, false, Image.FORMAT_RGBA8)
		b.icon = ImageTexture.create_from_image(blank)
	b.add_theme_constant_override("icon_max_width", 30)
	if b.disabled: b.modulate = Color(1, 1, 1, 0.6)
	return b

## The original's autopilot list: destination, gate, station, asteroid
## field and mission waypoint, as far as they exist here.
func open_autopilot() -> void:
	if app.screen != self or conversation != null or defeated or menu_paused or space.navigation_locked(): return
	var box := _navigation_box(app.library.text(292))
	for choice in space.autopilot_choices():
		box.add_child(_quick_icon(UI.button(str(choice.label), func():
			close_navigation()
			space.autopilot_to(str(choice.key))), 9 if choice.key == "waypoint" else -1))
	box.add_child(_quick_icon(UI.button("Back to flight", close_navigation), -1))
	(box.get_child(0) as Control).grab_focus.call_deferred()

## Chooses which launcher the secondary button fires.
func open_secondaries() -> void:
	if app.screen != self or conversation != null or defeated or menu_paused or space.navigation_locked(): return
	app.play_sound("fx_menu_04")
	var box := _navigation_box(app.library.text(124))
	var current := space.current_secondary()
	var first: Button = null
	for w in space.secondary_launchers():
		var marked := "▸ " if is_same(w, current) else "   "
		var b := UI.button("%s%s  ×%d" % [marked, app.catalogue.item_name(int(w.id)), int(w.count)], func():
			space.choose_secondary(int(w.id))
			close_navigation()
			hud.message(app.catalogue.item_name(int(w.id))), int(w.count) > 0)
		if b.disabled: b.focus_mode = Control.FOCUS_NONE
		elif first == null or is_same(w, current): first = b
		box.add_child(b)
	box.add_child(UI.button("Back to flight", close_navigation))
	(first if first != null else box.get_child(box.get_child_count() - 1)).grab_focus.call_deferred()

func open_wingmen() -> void:
	if app.screen != self or conversation != null or defeated or menu_paused or space.navigation_locked(): return
	var pilots := Wingmen.living(space)
	if pilots.is_empty(): return
	var box := _navigation_box(app.library.text(146))
	box.add_child(UI.paragraph(" · ".join(pilots.map(func(b): return b.name))))
	for row in [[147, Wingmen.FIRE_AT_WILL], [148, Wingmen.ATTACK_TARGET], [149, Wingmen.SECURE_WAYPOINT],
		[Wingmen.switch_label(space), Wingmen.SWITCH_GUN]]:
		var action := _quick_icon(UI.button(app.library.text(int(row[0])), _wingman_order.bind(int(row[1])), Wingmen.available(space, int(row[1]))),
			{Wingmen.FIRE_AT_WILL: 7, Wingmen.ATTACK_TARGET: 8, Wingmen.SECURE_WAYPOINT: 9, Wingmen.SWITCH_GUN: 10}.get(int(row[1]), -1))
		# UI.button normally remains focusable even when disabled. Tactical
		# keyboard navigation must not stop on an unavailable target/route.
		if action.disabled: action.focus_mode = Control.FOCUS_NONE
		box.add_child(action)
	if Wingmen.mission_waypoint(space) == null:
		box.add_child(UI.paragraph("No mission waypoint in this area." if space.story == null
			else "No supported unvisited mission waypoint in this area."))
	box.add_child(UI.button("Back to flight", close_navigation))
	(box.get_child(1) as Control).grab_focus.call_deferred()

func _wingman_order(command: int) -> void:
	if app.screen != self or conversation != null or defeated or menu_paused or navigation_layer == null: return
	var label: int = Wingmen.switch_label(space) if command == Wingmen.SWITCH_GUN else {2: 147, 3: 149, 4: 148}.get(command, 146)
	if Wingmen.issue(space, command):
		close_navigation()
		hud.message(app.library.text(label))

func open_drive() -> void:
	if conversation != null or defeated or menu_paused: return
	var error := space.drive_error()
	if not error.is_empty(): hud.message(error); close_navigation(); return
	if game.session.in_void:
		confirm_navigation({"station": game.session.station_id}, "drive")
		return
	var box := _navigation_box(app.catalogue.item_name(85))
	box.add_child(UI.paragraph(app.library.text(243)))
	box.add_child(UI.button(app.library.text(38), confirm_navigation.bind({"station": -1}, "drive")))
	box.add_child(UI.button(app.library.text(39), open_navigation.bind("drive")))
	box.add_child(UI.button("Back to flight", close_navigation))
	(box.get_child(2) as Control).grab_focus.call_deferred()

func open_navigation(mode: String) -> void:
	if mode not in ["route", "drive", "gate"] or conversation != null or defeated or menu_paused or space.navigation_locked(): return
	if mode == "drive" and not space.drive_error().is_empty(): return
	if game.session.in_void:
		if mode != "gate": open_drive()
		return
	if mode == "gate" and (space.gate == null or space.target != space.gate
		or space.player.pos.distance_to(space.gate.pos) >= space.GATE_ZONE): return
	close_navigation()
	navigation_layer = PanelContainer.new()
	navigation_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	navigation_layer.offset_left = 16; navigation_layer.offset_top = 32
	navigation_layer.offset_right = -16; navigation_layer.offset_bottom = -32
	var map := MapPanel.new()
	map.flight = self
	map.flight_mode = mode
	navigation_layer.add_child(map)
	navigation_panel = map
	add_child(navigation_layer)
	_sync_pause()

func confirm_navigation(destination: Dictionary, mode: String) -> void:
	if app.screen != self or conversation != null or defeated or menu_paused or space.navigation_locked(): return
	var sid := int(destination.get("station", -2))
	if mode == "drive":
		if space.jump_to(sid): close_navigation()
		else: hud.message(space.drive_error())
	elif mode == "gate":
		if not space.Navigation.gate_destination(game.session, app.catalogue, sid): return
		if space.gate == null or space.target != space.gate or space.player.pos.distance_to(space.gate.pos) >= space.GATE_ZONE: return
		game.destination = {"station": sid}
		close_navigation()
		space._use_gate()
	elif mode == "route":
		var system: int = app.catalogue.system_of_station(sid)
		if not space.Navigation.known(game.session, app.catalogue, system) or sid == game.session.station_id: return
		if (system != game.session.system_index and not game.session.ship_stats().jump_drive
			and not space.Navigation.linked(game.session, app.catalogue, system)): return
		game.destination = {"station": sid}
		close_navigation()

func close_navigation() -> void:
	if navigation_layer != null: navigation_layer.queue_free()
	navigation_layer = null
	navigation_panel = null
	if controls != null: _sync_pause()

func _exit_tree() -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED: Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if controls != null: controls.reset()
	if view != null: view.queue_free()
	if space != null: space.dispose()
