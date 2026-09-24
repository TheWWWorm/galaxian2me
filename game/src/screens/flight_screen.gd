extends Control
## In flight: owns the space simulation, its 3D view and the HUD.

const UI := preload("res://src/presentation/ui.gd")
const Space := preload("res://src/flight/space.gd")
const SpaceView := preload("res://src/flight/space_view.gd")
const Hud := preload("res://src/flight/hud.gd")
const Controls := preload("res://src/flight/controls.gd")

var app
var game
var space: Space
var view: SpaceView
var hud: Hud
var controls: Controls
var paused := false

func _ready() -> void:
	game = app.game
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	space = Space.new(game)
	space.build()
	view = SpaceView.new()
	view.setup(app, space)
	app.world_root.add_child(view)
	controls = Controls.new()
	controls.app = app
	add_child(controls)
	hud = Hud.new()
	hud.app = app
	hud.space = space
	hud.view = view
	add_child(hud)
	space.event.connect(_on_event)
	app.play_music("gof2_gneutral" if randi() % 2 == 0 else "gof2_gaction")
	# The story step's briefing plays when the flight begins, as a paused
	# conversation like the original's.
	var lines: Array = game.campaign.take_briefing() if space.story != null and space.story.job.is_empty() else []
	if not lines.is_empty(): _conversation(lines)

## A conversation box over the paused flight.
func _conversation(lines: Array) -> void:
	paused = true
	var d := preload("res://src/screens/dialogue_panel.gd").new()
	d.app = app
	d.lines = lines
	d.finished.connect(func():
		d.queue_free()
		paused = false)
	add_child(d)

var story_poll := 0.0
var flight_ms := 0

func _physics_process(delta: float) -> void:
	if paused: return
	space.step(delta, controls.state(view))
	game.session.playtime_ms += int(delta * 1000.0)
	flight_ms += int(delta * 1000.0)
	# The original checks story goals every few seconds in flight.
	story_poll += delta
	if story_poll > 1.0 and (space.story == null or space.story.step > 1):
		story_poll = 0.0
		if game.campaign.check(false, game.session.station_id, flight_ms):
			var before: int = game.session.story_step
			var lines: Array = game.campaign.conclude()
			game.pending_dialogue = []
			if space.story != null: space.story.step_changed(before + 1)
			if not lines.is_empty(): _conversation(lines)

func _process(delta: float) -> void:
	view.sync(delta)

func _on_event(kind: String, data: Dictionary) -> void:
	match kind:
		"docked":
			game.dock(int(data.station))
			app.show_station()
		"jumped":
			game.jump_arrive(int(data.system), int(data.station))
			app.show_flight()
		"destroyed":
			hud.message(app.library.text(156), 6.0)
			paused = true
			await get_tree().create_timer(3.0).timeout
			game.defeat()
			app.show_station()
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

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and space.story != null:
		space.story.skip_message()
	if event.is_action_pressed("ui_cancel"):
		paused = not paused
		hud.set_paused(paused)
		get_viewport().set_input_as_handled()

func _exit_tree() -> void:
	if view != null: view.queue_free()
