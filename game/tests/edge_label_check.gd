extends SceneTree
## Off-screen markers that lie the same way share an edge: their captions
## stack instead of printing over each other. Memory-only.
const Host := preload("res://tests/support/isolated_app.gd")
const Space := preload("res://src/flight/space.gd")
const View := preload("res://src/flight/space_view.gd")
const Hud := preload("res://src/flight/hud.gd")
var checks := 0
var failures := 0

func _init() -> void:
	run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	print("PASS: " if ok else "FAIL: ", label)
	if not ok: failures += 1

func run() -> void:
	root.size = Vector2i(1280, 800)
	var app := Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		check(false, "supplied content installed")
	else:
		var g = app._make_game()
		g.new_game()
		g.session.story_step = maxi(g.session.story_step, 20)
		g.session.job = {"kind": 10, "station": g.session.station_id, "difficulty": 5, "count": 2,
			"race": 0, "client": "Edge fixture", "item": 116, "reward": 0}
		var sim := Space.new(g)
		sim.build()
		app.game = g
		app.screen.queue_free(); app.screen = null
		var view := View.new()
		app.world_root.add_child(view)
		view.setup(app, sim)
		var hud := Hud.new()
		hud.app = app; hud.space = sim; hud.view = view
		app.ui_layer.add_child(hud)
		# A pirate locked off to the left, and the route's next point the same way.
		var p = sim.player
		var left: Vector3 = p.pos + p.basis * Vector3(-30000, 0, 2000)
		var pirate = sim._spawn_ship(8, left, false)
		pirate.pos = left
		sim.target = pirate
		sim.story.wingman_route = [left + p.basis * Vector3(0, 0, 3000)]
		sim.story.wingman_route_index = 0
		for i in 4:
			view.sync(0.016)
			hud.queue_redraw()
			await process_frame
		var boxes: Array = hud.edge_labels
		var apart := true
		for i in boxes.size():
			for j in range(i + 1, boxes.size()):
				apart = apart and not (boxes[i] as Rect2).intersects(boxes[j])
		check(boxes.size() >= 2, "both the target and the waypoint have edge captions (%d)" % boxes.size())
		check(apart, "their captions do not overlap")
		hud.queue_free(); view.queue_free()
		sim.dispose()
	print("EDGE LABELS: %d checks, %d failures" % [checks, failures])
	app.queue_free()
	quit(1 if failures else 0)
