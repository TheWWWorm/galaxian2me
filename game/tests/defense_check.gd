extends SceneTree
## Explicit MEMORY-ONLY defense fixtures. Positions, seeds and lethal damage
## in this test are never applied to a native earned save or flight.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
const INPUT := "res://../../local/checks/earned-tractor-rendered-b-20260928/earned-tractor-completed45.json"
const SHA := "dc32e025b3f77d422c1e7b71eaa6f482ef73acdba49921e9d88861e585ca52ad"
const REWARD := 2600
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

func fixture(difficulty := 2, migrant := false):
	var game := Game.new(app.library, app.catalogue)
	check(game.session.from_dict(header).is_empty(), "memory defense fixture reads the immutable native schema")
	var local_race := int(app.catalogue.system(game.session.system_index).faction)
	var race := (local_race + 1) % 4 if migrant else local_race
	var offer := {"kind": 0, "name": "Memory-only defense client", "race": race, "face": [],
		"job": {"kind": 1, "client": "Memory-only defense client", "race": race, "face": [],
			"reward": REWARD, "station": 95, "difficulty": difficulty, "count": 0, "item": 0, "story": false}}
	var before := state(game)
	check(game.bar.accept(offer).is_empty(), "ordinary acceptance consumes the explicit memory defense offer")
	check(not offer.has("job") and int(offer.kind) == 1 and int(game.session.job.kind) == 1,
		"accepted defense retains its type and consumes only its offered contract")
	check(game.session.credits == int(before.credits) and game.session.cargo == before.cargo
		and game.session.flags == before.flags and game.session.stat("jobs") == int(before.stats.jobs),
		"accepting defense grants no money, cargo, paid crew time or completed job")
	return game

func world(difficulty := 2, seed_value := 17, migrant := false):
	var sim := Space.new(fixture(difficulty, migrant))
	sim.rng.seed = seed_value # Deterministic memory fixture only, never a live run.
	sim.build()
	return sim

func run() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		if args.size() != 1 or DisplayServer.get_name() == "headless" or DirAccess.dir_exists_absolute(args[0]):
			quit(2); return
		render_out = args[0]; DirAccess.make_dir_recursive_absolute(render_out)
	root.size = Vector2i(1280, 800)
	check(FileAccess.get_sha256(INPUT) == SHA, "canonical earned save is byte-identical before defense fixtures")
	if failures: quit(2); return
	header = JSON.parse_string(FileAccess.get_file_as_string(INPUT))
	app = Host.new(); root.add_child(app); await frames(2)
	check(app.activate(str(header.content)), "defense fixtures use the player's supplied content catalogue")
	if failures: app.queue_free(); await frames(2); quit(2); return
	check_scenes()
	check_allegiance()
	check_settlement()
	await check_journal()
	check(app.save_attempts.is_empty() and app.disk_saves.is_empty(), "all synthetic defense tests make zero save attempts")
	check(FileAccess.get_sha256(INPUT) == SHA, "defense fixtures leave the only accepted checkpoint unchanged")
	app.queue_free(); await frames(3)
	if not render_out.is_empty():
		var output := FileAccess.open(render_out.path_join("report.json"), FileAccess.WRITE)
		output.store_string(JSON.stringify({"kind": "memory-only", "checks": observations,
			"failures": failures, "input_sha256": SHA, "save_attempts": 0}, "\t"))
	print("DEFENSE: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)

func check_scenes() -> void:
	for difficulty in [0, 2, 10]:
		var sim = world(difficulty)
		var count := 3 + int(5.0 * difficulty / 10.0)
		var attackers: Array = sim.story.cast.slice(0, count)
		var defenders: Array = sim.story.cast.slice(count)
		check(attackers.size() == count and defenders.size() >= 2 and defenders.size() <= 7,
			"source defense counts scale attackers by difficulty and supply two through seven allies")
		check(attackers.all(func(b): return b.hostile and not b.friendly and b.combat_active),
			"defense attackers are active enemies rather than sleeping bounty actors")
		check(attackers.all(func(b): return (b.pos.x >= -20000 and b.pos.x < 20000
			and b.pos.y >= -20000 and b.pos.y < 20000 and b.pos.z >= -20000 and b.pos.z < 20000)),
			"source defense attackers scatter in the origin cube, not on a far plane")
		var side := signf(defenders[0].pos.z)
		check(defenders.all(func(b): return (b.pos.x >= -70000 and b.pos.x < 70000
			and b.pos.y >= -20000 and b.pos.y < 20000 and absf(b.pos.z) >= 30000 and absf(b.pos.z) < 120000
			and signf(b.pos.z) == side)), "defenders scatter around the three same-side source route points, never the origin")
		var hull := 20 + mini(int(sim.game.session.stat("rank")), 20) * 15 + 45 * 4
		check(sim.story.cast.all(func(b): return b.hull == hull and b.hull_max == hull),
			"defense scene preserves the ordinary source rank-scaled durability without buffs")
		check(sim.story.failure.is_empty() and sim.story.wingman_waypoint() == null,
			"defense invents neither a protect-all failure condition nor a player waypoint route")
		sim.dispose()
	var seen_non_pirate := false
	var local_rivals := true
	for seed_value in range(1, 49):
		var sim = world(2, seed_value, true)
		var faction := int(sim.story.cast[0].faction)
		if faction != 8:
			seen_non_pirate = true
			local_rivals = local_rivals and faction == sim._rival(int(sim.station.faction))
		sim.dispose()
	check(seen_non_pirate, "deterministic memory cases exercise the non-pirate defense branch")
	check(local_rivals, "migrant clients do not change which faction opposes the local system")

func check_allegiance() -> void:
	var sim = world()
	var count := 4
	var defenders: Array = sim.story.cast.slice(count)
	check(defenders.all(func(b): return b.friendly and not b.hostile and bool(b.ai.get("fixed_friendly", false))),
		"all defense support fighters have the source AlwaysFriend override")
	var defender = defenders[0]
	var hull: int = defender.hull
	sim._harm(defender, 1.0, 0.0, sim.player) # Explicit memory-only accidental hit.
	check(defender.hull == hull - 1, "fixed-friendly defense support still takes real damage")
	check(defender.friendly and not defender.hostile and defender.ai.get("target") != sim.player,
		"accidental fire cannot turn source fixed-friendly defenders against the player")
	for ally in defenders: sim._harm(ally, 100000.0, 0.0, sim.story.cast[0])
	sim._cleanup(2000); sim.story._check_objectives()
	check(not sim.story.failed and not sim.story.complete and not sim.game.session.job.is_empty(),
		"losing every support fighter is not an invented defense failure or success")
	sim.dispose()

func check_settlement() -> void:
	var sim = world()
	var game = sim.game
	var start := state(game)
	var reports: Array = []
	sim.event.connect(func(kind, data):
		if kind == "job_report": reports.append(data.duplicate(true)))
	var attackers: Array = sim.story.cast.slice(0, 4)
	var ally = sim.story.cast[4]
	for enemy in attackers: enemy.disabled = true
	sim.story._check_objectives()
	check(not sim.story.complete and state(game) == start, "disabling every attacker cannot complete defense")
	for enemy in attackers: enemy.disabled = false
	var unrelated = sim._spawn_ship(8, Vector3.ZERO, false)
	sim._harm(unrelated, 100000.0, 0.0, sim.player); sim._cleanup(2000); sim.story._check_objectives()
	check(not sim.story.complete and game.session.credits == int(start.credits), "unrelated settled kills cannot replace designated attackers")
	var personal_kills: int = sim.kills
	for enemy in attackers: sim._harm(enemy, 100000.0, 0.0, ally) # Memory-only NPC damage, not an earned battle.
	check(attackers.all(func(b): return not b.alive and b.dead_timer > 0.0), "lethal impacts enter the actual native dying interval")
	sim.story._check_objectives()
	check(not sim.story.complete and game.session.credits == int(start.credits) and reports.is_empty(),
		"defense reward waits for all designated deaths to settle rather than the last impact")
	var dying_ms := int(ceil(attackers[0].dead_timer * 1000.0))
	sim._cleanup(maxi(0, dying_ms - 1)); sim.story._check_objectives()
	check(not sim.story.complete and game.session.credits == int(start.credits), "the last dying millisecond is not an early defense payment")
	sim._cleanup(2); sim.story._check_objectives()
	check(sim.story.complete and not sim.story.failed and game.session.job.is_empty(), "all settled designated attackers complete and close defense")
	check(game.session.credits == int(start.credits) + REWARD and game.session.stat("jobs") == int(start.stats.jobs) + 1,
		"defense pays exactly its accepted reward and counts exactly one job")
	check(sim.kills == personal_kills and reports.size() == 1, "allied kills qualify without inventing personal kills or duplicate reports")
	check(game.session.equipment == start.equipment and game.session.flags == start.flags
		and game.session.blueprints == start.blueprints and game.session.cargo == start.cargo,
		"completion grants no cargo, ammunition, paid crew time or repeated production")
	var settled := state(game)
	for i in 3: sim.story._check_objectives(); game.settle_job(95)
	check(state(game) == settled and reports.size() == 1, "repeated objective and station checks cannot pay defense twice")
	var cold := Game.new(app.library, app.catalogue)
	check(cold.session.from_dict(settled).is_empty() and state(cold) == settled, "memory JSON roundtrip preserves every settled field")
	var next_area := Space.new(cold); next_area.build()
	check(next_area.story == null or next_area.story.job.is_empty(), "completed defense does not respawn on the next area construction")
	next_area.dispose(); sim.dispose()

func check_journal() -> void:
	app.game = fixture(); app.show_station(); await frames(3)
	app.screen.menu.get_child(3).pressed.emit(); await frames(3)
	var shown := labels(app.screen.current_panel)
	check(shown.contains("Memory-only defense client") and shown.contains(app.catalogue.station_name(95)),
		"native Missions identifies the accepted defense client and destination")
	var before := state(app.game)
	if not render_out.is_empty():
		await RenderingServer.frame_post_draw
		check(root.get_texture().get_image().save_png(render_out.path_join("defense_journal_memory_only.png")) == OK,
			"capture the actual rendered memory-only defense journal")
	check(state(app.game) == before, "reading the defense journal cannot settle its mission")
	app.game.cancel_job()
	check(app.game.session.job.is_empty() and app.game.session.credits == int(before.credits),
		"ordinary cancellation does not grant the defense reward")
