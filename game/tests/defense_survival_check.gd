extends SceneTree
## Explicit MEMORY-ONLY control fixtures. No synthetic state is saved.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
const Body := preload("res://src/flight/body.gd")
const Pilot := preload("res://tests/support/defense_survival_pilot.gd")
const Observation := preload("res://tests/support/simulation_snapshot.gd")
const INPUT := "res://../../local/checks/earned-defense-rendered-a-20260928/earned-defense-prepared45.json"
const SHA := "3662b31111b09589a5ec82e83b868d983e250df028fe60d9dcd6c20cf1417e9a"
var checks := 0
var failures := 0
var app
func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)

func fixture():
	var game := Game.new(app.library, app.catalogue)
	var header: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(INPUT))
	check(game.session.from_dict(header).is_empty(), "memory fixture reads accepted schema without writing it")
	var sim := Space.new(game)
	sim.player = Body.new(); sim.player.kind = Body.Kind.PLAYER
	sim.player.faction = 0; sim.player.hull = 170; sim.player.hull_max = 170
	sim.player.shield = 120; sim.player.shield_max = 120; sim.player.armor = 80
	sim.player.emp = 100; sim.player.emp_max = 100
	sim.player.weapons = [sim.weapon(8), sim.weapon(2), sim.weapon(41)]
	sim.player.weapons[2].slot = [1, 0]; sim.player.weapons[2].count = 5
	sim.station = Body.new(); sim.station.kind = Body.Kind.STATION
	sim.station.pos = Vector3(-200000, 0, 0)
	var enemy := Body.new(); enemy.pos = Vector3(0, 0, 42000)
	enemy.speed = 0; enemy.hostile = true; enemy.hull = 500; enemy.hull_max = 500
	enemy.emp = 60; enemy.emp_max = 60; enemy.weapons = [sim.weapon(18)]
	sim.bodies = [sim.player, enemy]; sim.clock = 1000
	return sim

func run() -> void:
	check(FileAccess.get_sha256(INPUT) == SHA, "accepted pending checkpoint is immutable before fixtures")
	app = Host.new(); root.add_child(app); await process_frame; await process_frame
	check(app.library != null, "supplied content is available")
	if failures: app.queue_free(); await process_frame; quit(1); return
	var sim = fixture()
	var enemy = sim.bodies[1]
	var bomb: Dictionary = sim.player.weapons[2]
	check(bomb.kind == "emp" and bomb.blast == 22000 and bomb.life == 6000 and bomb.emp == 80,
		"EMP41 parameters come from the supplied catalogue, not tactical grants")
	var before := Observation.capture(sim)
	var pilot := Pilot.new()
	var controls: Dictionary = pilot.input(sim, [enemy])
	check(controls.get("secondary", false), "a clear distant hostile requests the fitted area EMP bomb")
	check(Observation.capture(sim) == before and bomb.count == 5, "planning changes no body, ammunition, session or RNG")
	sim.player.hull = 115; sim.player.shield = 20
	before = Observation.capture(sim)
	check(pilot.retreat_required(sim), "low reserves request escape before the old seventy-hull boundary")
	check(Observation.capture(sim) == before, "early retreat observes rather than repairs the player")
	sim.player.hull = 170; sim.player.shield = 120
	for condition in ["empty", "cooldown", "disabled", "friendly", "inactive", "hidden", "inflight", "near", "far", "behind", "ally_blast", "neutral_blast", "other_secondary"]:
		bomb.count = 5; bomb.cooldown = 0; enemy.disabled = false; enemy.hostile = true
		enemy.friendly = false; enemy.combat_active = true; enemy.visible = true
		enemy.pos = Vector3(0, 0, 42000); sim.projectiles = []
		var ally := Body.new(); ally.friendly = true; ally.speed = 0
		ally.pos = Vector3(100000, 0, 0); sim.bodies = [sim.player, enemy, ally]
		match condition:
			"empty": bomb.count = 0
			"cooldown": bomb.cooldown = 1000
			"disabled": enemy.disabled = true
			"friendly": enemy.friendly = true
			"inactive": enemy.combat_active = false
			"hidden": enemy.visible = false
			"inflight": sim.projectiles = [{"owner": sim.player, "target": enemy, "weapon": bomb}]
			"near": enemy.pos.z = 6000
			"far": enemy.pos.z = 150000
			"behind": enemy.pos.z = -42000
			"ally_blast": ally.pos = enemy.pos + Vector3(15000, 0, 0)
			"neutral_blast": ally.pos = enemy.pos; ally.friendly = false; ally.hostile = false
			"other_secondary":
				var rocket: Dictionary = sim.weapon(35); rocket.count = 1
				sim.player.weapons.insert(2, rocket)
		before = Observation.capture(sim)
		controls = Pilot.new().input(sim, [enemy])
		check(not controls.get("secondary", false), "area EMP is withheld for " + condition)
		check(Observation.capture(sim) == before, "unsafe-case planning remains read-only: " + condition)
		if condition == "other_secondary": sim.player.weapons.remove_at(2)
	sim.dispose()
	# Exercise the real finite secondary firing/flight path in fresh memory.
	sim = fixture(); enemy = sim.bodies[1]; bomb = sim.player.weapons[2]
	controls = Pilot.new().input(sim, [enemy]); controls.fire = false
	sim._player_weapons_step(0, controls)
	check(bomb.count == 4 and sim.projectiles.size() == 1, "ordinary secondary input consumes exactly one fitted bomb")
	for tick in 400: sim._projectiles_step(0.016, 16)
	check(enemy.disabled and enemy.alive and enemy.hull == 500, "native bomb impact disables without manufacturing a lethal kill")
	check(not sim.player.disabled and sim.player.hull == 170, "the tested distant blast leaves the player outside its effect")
	sim._store_ship_state()
	check(sim.game.session.equipment[1][0].count == 4, "native ship snapshot stores the actually consumed finite ammunition")
	check(sim.game.session.credits == 22555 and sim.game.session.stat("jobs") == 5,
		"memory secondary use cannot pay or complete the pending defense")
	sim.dispose()
	check(app.save_attempts.is_empty() and app.disk_saves.is_empty(), "all survival fixtures make zero save attempts")
	check(FileAccess.get_sha256(INPUT) == SHA, "accepted checkpoint remains byte-identical after fixtures")
	app.queue_free(); await process_frame; await process_frame
	print("DEFENSE SURVIVAL: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
