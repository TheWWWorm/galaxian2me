extends SceneTree
## MEMORY-ONLY encounter construction and approach boundaries. Native saved
## input is read, never rewritten; seeded worlds and positions are fixtures.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
const AI := preload("res://src/flight/ai.gd")
const INPUT := "res://../../local/checks/earned-bomb-ignition-rendered-b-20260928/earned-bomb-ignition45.json"
const SHA := "3708119974401f1bbf17522d1ad715125709434a5f6d0dbf9f699a325d87f696"
var app
var header := {}
var checks := 0
var failures := 0
var observations: Array = []
var render_out := ""

func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	observations.append({"passed": ok, "label": label})
	print("PASS: " if ok else "FAIL: ", label)
func frames(count: int) -> void:
	for i in count: await process_frame
func normalized(value): return JSON.parse_string(JSON.stringify(value))
func state(game) -> Dictionary: return normalized(game.session.to_dict())
func labels(node: Node) -> String:
	var text: String = node.text + "\n" if node is Label else ""
	for child in node.get_children(): text += labels(child)
	return text

func fixture(kind: int):
	var game := Game.new(app.library, app.catalogue)
	check(game.session.from_dict(header).is_empty(), "memory scene loads the byte-verified native schema")
	var index := -1
	for i in game.lounge().size():
		if str(game.lounge()[i].name) == "Claire Barad": index = i
	check(index >= 0 and int(game.lounge()[index].job.kind) == 5, "retained Claire offer exists without generating a new lounge")
	if kind == 5:
		check(game.accept_job(index).is_empty(), "memory fixture accepts the actual stored hostage offer")
	else:
		# This comparison is explicitly synthetic, not an earned kind-three job.
		var person: Dictionary = game.lounge()[index].duplicate(true)
		person.name = "Memory-only recovery comparison"
		person.job.client = person.name
		person.job.kind = 3
		person.job.item = 116
		check(game.bar.accept(person).is_empty(), "native acceptance accepts the explicit memory-only recovery comparison")
	check(int(game.session.job.count) == 6 and int(game.session.job.return_station) == 99
		and game.session.credits == int(header.credits), "acceptance retains count, client origin and finite credits")
	return game

func world(kind: int, seed_value: int):
	var game = fixture(kind)
	var target := int(game.session.job.station)
	game.jump_arrive(app.catalogue.system_of_station(target), target)
	var sim := Space.new(game)
	sim.rng.seed = seed_value # Explicit repeatable memory geometry, never a native continuation.
	sim.build()
	return sim

func check_scene(kind: int, seed_value: int) -> void:
	var sim = world(kind, seed_value)
	var scene = sim.story
	check(scene != null and scene.cast.size() == 6, "each variant constructs exactly the accepted six mission fighters")
	var route: Vector3 = scene.wingman_waypoint()
	check(absf(route.x) >= 40000 and absf(route.x) < 120000 and route.y == 0
		and absf(route.z) >= 40000 and absf(route.z) < 120000, "recovery route stays inside the supplied signed coordinate bounds")
	var positions := {}
	for body in scene.cast:
		var offset: Vector3 = body.pos - route
		positions[str(body.pos)] = true
		check(offset.x >= -20000 and offset.x < 20000 and offset.y >= -20000 and offset.y < 20000
			and offset.z >= -20000 and offset.z < 20000, "fighter lies inside the source constructor's half-open scatter cube")
		check(body.alive and body.visible and body.hostile and not body.friendly and body.faction == 8,
			"waiting mission fighter remains visible, living and pirate-aligned")
		check(str(body.ai.mode) == "encounter_wait" and not body.combat_active,
			"each rescue fighter starts asleep and combat-inactive rather than roaming")
	check(positions.size() > 1 and not positions.has(str(route)), "seeded constructor scatters ships instead of stacking them on the route point")
	var carrier = scene.cast.back()
	check(carrier.name == app.library.text(833) and bool(carrier.ai.get("recovery_container", false))
		and bool(carrier.ai.get("no_drop", false)), "only the designated last fighter owns the mission-container role")
	check(scene.cast.slice(0, 5).all(func(b): return not bool(b.ai.get("recovery_container", false))),
		"escorts cannot substitute their cargo for the designated carrier")
	check(scene.objective == {"kind": "recovery_transferred", "index": 5}
		and scene.failure == {"kind": "recovery_lost", "index": 5}, "source transfer and loss objectives track the last carrier, not a kill-all quota")
	var before := state(sim.game)
	scene._check_objectives()
	check(not scene.complete and not scene.failed and state(sim.game) == before, "sleeping scene construction cannot complete, fail or pay the contract")
	sim.dispose()

func check_approach(kind: int) -> void:
	var sim = world(kind, 57)
	var carrier = sim.story.cast.back()
	var origin: Vector3 = carrier.pos
	var before := state(sim.game)
	sim.player.pos = origin + Vector3(200000, 200000, 200000)
	var initial: Array = sim.story.cast.map(func(b): return b.pos)
	for body in sim.story.cast: AI.step(sim, body, 1.0, 1000)
	check(sim.story.cast.map(func(b): return b.pos) == initial
		and sim.story.cast.all(func(b): return not b.combat_active), "distant player leaves every recovery fighter at its own spawn point")
	for offset in [Vector3(50000, 0, 0), Vector3(-50000, 0, 0), Vector3(0, 50000, 0),
		Vector3(0, -50000, 0), Vector3(0, 0, 50000), Vector3(0, 0, -50000)]:
		sim.player.pos = origin + offset
		AI.step(sim, carrier, 0.016, 16)
		check(carrier.pos == origin and not carrier.combat_active, "exact positive or negative sight boundary remains asleep on each axis")
	sim.player.pos = origin + Vector3(49999, 49999, 49999)
	sim.cloak = 1000
	AI.step(sim, carrier, 0.016, 16)
	check(not carrier.combat_active and carrier.pos == origin, "cloaked diagonal approach does not wake the carrier")
	sim.cloak = 0; sim.player.alive = false
	AI.step(sim, carrier, 0.016, 16)
	check(not carrier.combat_active and carrier.pos == origin, "destroyed player does not wake the carrier")
	sim.player.alive = true; carrier.disabled = true
	AI.step(sim, carrier, 0.016, 16)
	check(not carrier.combat_active and carrier.pos == origin, "EMP-disabled carrier cannot acquire propulsion during approach")
	carrier.disabled = false
	AI.step(sim, carrier, 0.016, 16)
	check(carrier.combat_active and str(carrier.ai.mode) == "patrol" and carrier.pos == origin,
		"uncloaked living approach wakes the per-axis sight box without moving the carrier on its wake tick")
	check(sim.story.cast.slice(0, 5).all(func(b): return not b.combat_active), "waking one carrier does not globally activate unobserved escorts")
	AI.step(sim, carrier, 0.016, 16)
	check(carrier.pos != origin, "awake carrier resumes ordinary native movement on the next tick")
	sim.story._check_objectives()
	check(state(sim.game) == before and not sim.story.complete and not sim.story.failed and sim.projectiles.is_empty(),
		"approach and activation grant no money, cargo, ammunition, reward, crew time or synthetic shots")
	sim.dispose()

func capture(name: String) -> void:
	if render_out.is_empty(): return
	await RenderingServer.frame_post_draw
	check(root.get_texture().get_image().save_png(render_out.path_join(name + ".png")) == OK,
		"capture actual rendered MEMORY-ONLY panel: " + name)

func check_journal() -> void:
	var game = fixture(5)
	app.game = game; app.show_station(); await frames(3)
	app.screen.menu.get_child(3).pressed.emit(); await frames(3)
	var before := state(game)
	var text := labels(app.screen.current_panel)
	check(text.contains("Claire Barad") and text.contains(app.catalogue.station_name(96))
		and text.contains(app.library.text(438)), "memory hostage journal shows actual client, destination and supplied recovery instructions")
	await capture("hostage_journal_memory_only")
	check(state(game) == before, "reading the memory journal does not settle the pending rescue")

func run() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		if args.size() != 1 or DisplayServer.get_name() == "headless" or DirAccess.dir_exists_absolute(args[0]): quit(2); return
		render_out = args[0]; DirAccess.make_dir_recursive_absolute(render_out)
	root.size = Vector2i(1280, 800)
	check(FileAccess.get_sha256(INPUT) == SHA, "sole accepted native checkpoint is byte-identical before memory fixtures")
	if failures: quit(2); return
	header = JSON.parse_string(FileAccess.get_file_as_string(INPUT))
	app = Host.new(); root.add_child(app); await frames(2)
	check(app.activate(str(header.content)), "memory fixtures read the player's supplied content without importing new data")
	if failures: app.queue_free(); await frames(2); quit(2); return
	for id in [116, 117]: print("RECOVERY ITEM ", id, " ", app.catalogue.item_name(id))
	for id in [428, 430, 438]: print("RECOVERY BRIEF ", id, " ", app.library.text(id))
	for kind in [3, 5]:
		for seed_value in [19, 57]: check_scene(kind, seed_value)
		check_approach(kind)
	await check_journal()
	check(app.save_attempts.is_empty() and app.disk_saves.is_empty(), "memory fixtures make zero save attempts and never become continuation input")
	check(FileAccess.get_sha256(INPUT) == SHA, "scene fixtures leave the accepted native checkpoint byte-identical")
	app.queue_free(); await frames(3)
	if not render_out.is_empty():
		var file := FileAccess.open(render_out.path_join("report.json"), FileAccess.WRITE)
		file.store_string(JSON.stringify({"kind": "memory-only", "checks": observations, "failures": failures,
			"input_sha256": SHA, "save_attempts": 0}, "\t"))
	print("RECOVERY SCENE: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
