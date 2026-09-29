extends SceneTree
## MEMORY-ONLY bounty boundaries. Offers, rank, positions and lethal damage
## below are explicit fixtures. Nothing here is an earned contract or save.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
const AI := preload("res://src/flight/ai.gd")
const INPUT := "res://../../local/checks/earned-tractor-rendered-b-20260928/earned-tractor-completed45.json"
const SHA := "dc32e025b3f77d422c1e7b71eaa6f482ef73acdba49921e9d88861e585ca52ad"
const TARGET := "Memory-only bounty target"
const REWARD := 4500
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

func fixture(rank_value := -1):
	var game := Game.new(app.library, app.catalogue)
	check(game.session.from_dict(header).is_empty(), "memory bounty fixture reads the immutable native schema")
	if rank_value >= 0: game.session.stats["rank"] = rank_value
	# Explicit synthetic offer passed through the ordinary acceptance rule.
	var offer := {"kind": 0, "name": "Memory-only client", "race": 0, "face": [],
		"job": {"kind": 6, "client": "Memory-only client", "race": 0, "face": [],
			"wanted": TARGET, "reward": REWARD, "station": 95, "difficulty": 6,
			"count": 0, "item": 0, "story": false}}
	var before := state(game)
	check(game.bar.accept(offer).is_empty(), "native acceptance accepts the declared memory bounty")
	check(game.session.credits == int(before.credits) and game.session.stat("jobs") == int(before.stats.jobs),
		"bounty acceptance grants neither money nor a completion")
	check(not offer.has("job") and int(offer.kind) == 1 and str(game.session.job.wanted) == TARGET,
		"acceptance consumes only its offer while retaining the named target")
	return game

func world(rank_value := -1):
	var sim := Space.new(fixture(rank_value))
	sim.build()
	return sim

func capture(name: String) -> void:
	if render_out.is_empty(): return
	await RenderingServer.frame_post_draw
	check(root.get_texture().get_image().save_png(render_out.path_join(name + ".png")) == OK,
		"capture actual rendered memory boundary: " + name)

func run() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		if args.size() != 1 or DisplayServer.get_name() == "headless" or DirAccess.dir_exists_absolute(args[0]):
			quit(2); return
		render_out = args[0]
		DirAccess.make_dir_recursive_absolute(render_out)
	root.size = Vector2i(1280, 800)
	check(FileAccess.get_sha256(INPUT) == SHA, "accepted recovery checkpoint remains byte-identical before bounty fixtures")
	if failures: quit(2); return
	header = JSON.parse_string(FileAccess.get_file_as_string(INPUT))
	app = Host.new(); root.add_child(app); await frames(2)
	check(app.activate(str(header.content)), "bounty boundaries use the player's supplied content catalogue")
	if failures: app.queue_free(); await frames(2); quit(2); return
	check_scene()
	check_wait()
	check_completion()
	await check_missions()
	check(app.save_attempts.is_empty() and app.disk_saves.is_empty(), "all synthetic bounty boundaries make zero save attempts")
	check(FileAccess.get_sha256(INPUT) == SHA, "bounty fixtures never modify the accepted native checkpoint")
	app.queue_free(); await frames(3)
	if not render_out.is_empty():
		var output := FileAccess.open(render_out.path_join("report.json"), FileAccess.WRITE)
		output.store_string(JSON.stringify({"kind": "memory-only", "checks": observations,
			"failures": failures, "input_sha256": SHA, "save_attempts": 0}, "\t"))
	print("BOUNTY: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)

func check_scene() -> void:
	for rank_value in [0, 5, 20, 31]:
		var sim = world(rank_value)
		check(sim.story.cast.size() == 1 and int(sim.story.job.kind) == 6, "source bounty scene contains exactly its one designated fighter")
		var boss = sim.story.cast[0]
		check(boss.name == TARGET and boss.faction == 8 and boss.hostile and not boss.friendly,
			"bounty fighter exposes the accepted name and pirate allegiance")
		check(boss.hull == 300 + 6 * mini(rank_value, 20) and boss.hull_max == boss.hull,
			"bounty durability follows difficulty times rank capped at twenty, plus three hundred")
		check(absf(boss.pos.x) >= 60000 and absf(boss.pos.x) < 140000 and boss.pos.y == 0
			and absf(boss.pos.z) >= 60000 and absf(boss.pos.z) < 140000,
			"bounty route remains inside the supplied signed coordinate bounds")
		check(sim.story.wingman_waypoint() == boss.pos, "secure-waypoint route points at the original bounty encounter location")
		check(str(boss.ai.mode) == "encounter_wait" and not boss.combat_active,
			"bounty starts visibly asleep and inactive, not already roaming in combat")
		sim.dispose()

func check_wait() -> void:
	var sim = world()
	var boss = sim.story.cast[0]
	var origin: Vector3 = boss.pos
	sim.player.pos = origin + Vector3(100000, 0, 0) # Memory-only approach boundary.
	var before := state(sim.game)
	AI.step(sim, boss, 1.0, 1000)
	check(boss.pos == origin and not boss.combat_active, "distant bounty remains at its route point rather than patrolling")
	for offset in [Vector3(50000, 0, 0), Vector3(0, -50000, 0), Vector3(0, 0, 50000)]:
		sim.player.pos = origin + offset
		AI.step(sim, boss, 0.016, 16)
		check(boss.pos == origin and not boss.combat_active, "exact fifty-thousand sight boundary remains asleep on each axis")
	sim.player.pos = origin + Vector3(49999, 49999, 49999)
	sim.cloak = 1000
	AI.step(sim, boss, 0.016, 16)
	check(boss.pos == origin and not boss.combat_active, "cloaked player does not wake the bounty encounter")
	sim.cloak = 0; sim.player.alive = false
	AI.step(sim, boss, 0.016, 16)
	check(boss.pos == origin and not boss.combat_active, "destroyed player does not wake the bounty encounter")
	sim.player.alive = true
	AI.step(sim, boss, 0.016, 16)
	check(boss.combat_active and str(boss.ai.mode) == "patrol" and boss.pos == origin,
		"living uncloaked diagonal approach wakes the source per-axis sight box without teleporting")
	AI.step(sim, boss, 0.016, 16)
	check(boss.pos != origin, "activated bounty resumes ordinary native movement")
	check(state(sim.game) == before, "encounter activation grants no reward, cargo, ammunition or paid crew time")
	sim.dispose()

func check_completion() -> void:
	var sim = world()
	var game = sim.game
	var boss = sim.story.cast[0]
	var start := state(game)
	var reports: Array = []
	sim.event.connect(func(kind, data):
		if kind == "job_report": reports.append(data.duplicate(true)))
	sim.player.pos = boss.pos + Vector3(49999, 0, 0) # Memory-only activation.
	AI.step(sim, boss, 0.016, 16)
	boss.disabled = true # EMP alone is not a death objective.
	sim.story._check_objectives()
	check(not sim.story.complete and state(game) == start, "disabling the designated bounty target cannot complete or pay it")
	boss.disabled = false
	var unrelated = sim._spawn_ship(8, Vector3.ZERO, false)
	sim._harm(unrelated, 100000.0, 0.0, sim.player) # Explicit lethal fixture, not an earned kill.
	sim._cleanup(2000); sim.story._check_objectives()
	check(not sim.story.complete and game.session.credits == int(start.credits) and not game.session.job.is_empty(),
		"another pirate's settled death cannot stand in for the named bounty target")
	var cargo: Dictionary = game.session.cargo.duplicate(true)
	sim._harm(boss, 100000.0, 0.0, sim.player) # Explicit lethal fixture.
	check(not boss.alive and boss.dead_timer > 0.0, "lethal impact enters the real native dying interval")
	sim.story._check_objectives()
	check(not sim.story.complete and game.session.credits == int(start.credits) and reports.is_empty(),
		"bounty reward and client report wait for the designated death to settle")
	var dying_ms := int(ceil(boss.dead_timer * 1000.0))
	sim._cleanup(maxi(0, dying_ms - 1)); sim.story._check_objectives()
	check(not sim.story.complete and game.session.credits == int(start.credits), "the last dying millisecond is not an early bounty payment")
	# The two pirate kills already moved standing the original's way; the
	# reward's own improvement is measured from there.
	var settled_standing := int(game.session.reputation[0])
	sim._cleanup(2); sim.story._check_objectives()
	check(sim.story.complete and not sim.story.failed and game.session.job.is_empty(), "settled designated death completes and closes the bounty")
	check(game.session.credits == int(start.credits) + REWARD and game.session.stat("jobs") == int(start.stats.jobs) + 1,
		"settlement pays exactly the accepted reward and counts one job")
	check(reports.size() == 1 and game.session.cargo == cargo, "one client report accompanies completion without granting dropped cargo")
	check(int(game.session.reputation[0]) == clampi(settled_standing + 2, -100, 100),
		"completed bounty applies the source client-standing improvement")
	check(game.session.story_step == 45 and game.session.story_mission.is_empty()
		and game.session.equipment == start.equipment and game.session.flags == start.flags
		and game.session.blueprints == start.blueprints, "bounty settlement cannot reset the ending, finite gear, crew contract or production")
	var settled := state(game)
	for i in 3: sim.story._check_objectives(); game.settle_job(95)
	check(state(game) == settled and reports.size() == 1, "repeated objective and station settlement cannot pay the bounty twice")
	var cold := Game.new(app.library, app.catalogue)
	check(cold.session.from_dict(settled).is_empty() and state(cold) == settled, "memory JSON reload preserves the settled bounty and every finite resource")
	var next_area := Space.new(cold); next_area.build()
	check(next_area.story == null or (next_area.story.job.is_empty() and next_area.story.cast.is_empty()), "completed bounty does not respawn on the next flight-area construction")
	next_area.dispose(); sim.dispose()

func check_missions() -> void:
	var game = fixture()
	app.game = game; app.show_station(); await frames(3)
	app.screen.menu.get_child(3).pressed.emit(); await frames(3)
	var brief: String = app.library.text(431).replace("#N", TARGET).replace("#S", app.catalogue.station_name(95))
	var shown := labels(app.screen.current_panel)
	check(shown.contains(TARGET) and shown.contains(brief), "Missions retains the supplied Wanted briefing and target name after acceptance")
	check(not shown.contains("#N") and not shown.contains("#S"), "bounty journal resolves supplied name and destination tokens")
	var before := state(game)
	await capture("bounty_missions_memory_only")
	check(state(game) == before, "reading the bounty journal does not settle the contract")
	game.cancel_job(); await frames(3)
	app.screen.menu.get_child(3).pressed.emit(); await frames(3)
	check(game.session.job.is_empty() and game.session.credits == int(before.credits)
		and not labels(app.screen.current_panel).contains(TARGET), "canceling removes the bounty briefing without paying a reward")
	await capture("bounty_canceled_memory_only")
