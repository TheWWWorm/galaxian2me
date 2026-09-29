extends "res://tests/tractor_check.gd"
## Explicit visual MEMORY-ONLY fixture. The real native view/HUD renders the
## timer and imported crate; this is not an earned mission or saved flight.
const View := preload("res://src/flight/space_view.gd")
const Hud := preload("res://src/flight/hud.gd")
var render_out := ""
var render_view
var render_hud

func capture(name: String) -> void:
	await RenderingServer.frame_post_draw
	check(root.get_texture().get_image().save_png(render_out.path_join(name + ".png")) == OK,
		"capture actual native fixture: " + name)

func run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 1 or DirAccess.dir_exists_absolute(args[0]): quit(2); return
	render_out = args[0]
	DirAccess.make_dir_recursive_absolute(render_out)
	root.size = Vector2i(1280, 800)
	check(FileAccess.get_sha256(INPUT) == SHA, "visual fixture reads the immutable input")
	header = JSON.parse_string(FileAccess.get_file_as_string(INPUT))
	app = Host.new(); root.add_child(app)
	await process_frame; await process_frame
	check(app.activate(str(header.content)), "visual fixture uses the supplied catalogue and artwork")
	var sim = prepared()
	app.game = sim.game
	app.screen.queue_free(); app.screen = null
	await process_frame
	render_view = View.new(); app.world_root.add_child(render_view); render_view.setup(app, sim)
	render_hud = Hud.new(); render_hud.app = app; render_hud.space = sim; render_hud.view = render_view
	app.ui_layer.add_child(render_hud)
	var label := Label.new()
	label.text = "MEMORY-ONLY tractor boundary — NOT earned gameplay"
	label.position = Vector2(360, 150)
	app.ui_layer.add_child(label)
	var before := state(sim.game)
	for i in 230:
		sim._tractor_step(16)
		render_view.sync(0.016)
		await process_frame
		if i == 120: await capture("tractor_charging")
	check(state(sim.game) == before and sim.tractor_status().phase == "charging", "rendered charge never grants inventory")
	for i in 45:
		sim._tractor_step(16)
		render_view.sync(0.016)
		await process_frame
		if i == 35: await capture("tractor_pulling")
	check(sim.tractor_status().get("phase") == "pulling" and render_view.tractor_crate.visible
		and render_view.tractor_beam.visible and state(sim.game) == before,
		"actual renderer shows the imported moving crate and beam before capture")
	for i in 80:
		sim._tractor_step(16)
		render_view.sync(0.016)
		await process_frame
	sim.story._check_objectives()
	check(sim.game.session.cargo_count(117) == 1 and sim.tractor_status().is_empty()
		and not render_view.tractor_crate.visible and not render_view.tractor_beam.visible,
		"physical arrival grants one container and removes its transient visuals")
	await capture("tractor_captured")
	check(app.save_attempts.is_empty() and app.disk_saves.is_empty(), "visual fixture never creates gameplay saves")
	check(FileAccess.get_sha256(INPUT) == SHA, "visual fixture leaves accepted input unchanged")
	render_hud.queue_free(); render_view.queue_free(); label.queue_free()
	await process_frame; await process_frame
	sim.dispose()
	app.queue_free(); await process_frame; await process_frame
	var report := FileAccess.open(render_out.path_join("report.json"), FileAccess.WRITE)
	report.store_string(JSON.stringify({"kind": "memory-only", "checks": checks, "failures": failures}, "\t"))
	print("TRACTOR RENDER: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
