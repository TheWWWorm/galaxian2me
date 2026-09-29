extends SceneTree
## Explicit MEMORY-ONLY boundaries. No fixture state is ever saved or earned.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
const AI := preload("res://src/flight/ai.gd")
const Wingmen := preload("res://src/flight/wingmen.gd")
const INPUT := "res://../../local/checks/earned-wingmen-rendered-a-20260928/earned-wingmen-travelled45.json"
const SHA := "0f112a4fcc3fffc987ef0eb940f0d3c19e7a067de38c023196d2da1525ec090f"
var app
var header := {}
var checks := 0
var failures := 0

func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)
func frames(n: int) -> void:
	for i in n: await process_frame
func normalized(value): return JSON.parse_string(JSON.stringify(value))
func state(game) -> Dictionary: return normalized(game.session.to_dict())
func fixture():
	var game := Game.new(app.library, app.catalogue)
	check(game.session.from_dict(header).is_empty(), "memory fixture reads the exact paid-crew schema")
	return game
func crew(sim) -> Array:
	return sim.bodies.filter(func(b): return bool(b.ai.get("wingman", false)))

func run() -> void:
	check(FileAccess.get_sha256(INPUT) == SHA, "accepted paid-crew input is byte-identical")
	if failures: quit(2); return
	header = JSON.parse_string(FileAccess.get_file_as_string(INPUT))
	app = Host.new(); root.add_child(app); await frames(2)
	check(app.activate(str(header.content)), "use the supplied game catalogue without creating content")
	if failures: app.queue_free(); await frames(2); quit(2); return
	app.game = fixture()
	app.show_flight()
	var flight = app.screen
	flight.set_physics_process(false)
	await frames(2)
	var pilots := crew(flight.space)
	check(pilots.size() == 2 and pilots.all(func(b): return b.weapons.size() == 2),
		"armed hired pilots have both the ordinary gun and source EMP gun")
	check(pilots.all(func(b): return int(b.ai.get("wingman_order", -1)) == 2 and int(b.ai.get("wingman_weapon", -1)) == 0),
		"new areas start at source order two with the ordinary gun selected")
	check(flight.has_method("open_wingmen"), "flight exposes a native paid-wingman Actions panel")
	if failures == 0:
		await check_menu(flight)
		check_targets(flight.space)
		check_gunnery()
		check_gunnery(true)
		check_routes()
		check_rebuild_and_unarmed()
	check(app.save_attempts.is_empty() and app.disk_saves.is_empty(), "memory boundaries never save a synthetic state")
	check(FileAccess.get_sha256(INPUT) == SHA, "orders test leaves the earned input unchanged")
	app.queue_free(); await frames(3)
	print("%d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)

func button(node: Node, text: String):
	if node is Button and node.text == text: return node
	for child in node.get_children():
		if child.is_queued_for_deletion(): continue
		var found = button(child, text)
		if found != null: return found
	return null

func check_menu(flight) -> void:
	flight.set_paused(false)
	var before := state(app.game)
	var clock: int = flight.space.clock
	flight.open_actions()
	var entry = button(flight.navigation_panel, app.library.text(146))
	check(entry != null and not entry.disabled and flight.paused, "Actions offers the actual paid crew")
	entry.pressed.emit()
	check(button(flight.navigation_panel, app.library.text(148)).disabled
		and button(flight.navigation_panel, app.library.text(149)).disabled,
		"no locked ship or mission route cannot fabricate an attack target or waypoint")
	check(button(flight.navigation_panel, app.library.text(148)).focus_mode == Control.FOCUS_NONE
		and button(flight.navigation_panel, app.library.text(149)).focus_mode == Control.FOCUS_NONE,
		"disabled tactical commands are excluded from the actual keyboard focus chain")
	flight._physics_process(1.0)
	check(state(app.game) == before and flight.space.clock == clock, "wingmen modal freezes the entire paid flight clock")
	var toggle = button(flight.navigation_panel, app.library.text(151))
	check(toggle != null and not toggle.disabled, "initial switch label is supplied Use EMP text")
	toggle.pressed.emit()
	check(not flight.paused and crew(flight.space).all(func(b): return b.ai.wingman_weapon == 1 and b.ai.wingman_order == 1),
		"the real native menu callback selects only EMP and source order one")
	check(state(app.game) == before, "orders spend no credits, cargo, hire count, ammunition or contract time")
	flight.open_wingmen()
	button(flight.navigation_panel, app.library.text(147)).pressed.emit()
	flight.open_wingmen()
	check(button(flight.navigation_panel, app.library.text(150)) != null and Wingmen.switch_label(flight.space) == 150,
		"Fire at will does not falsely toggle the weapon label as the old HUD did")
	flight.set_paused(true)
	var order: int = crew(flight.space)[0].ai.wingman_order
	flight._wingman_order(1)
	flight.close_navigation()
	check(flight.paused and crew(flight.space)[0].ai.wingman_order == order,
		"focus/menu pause owns the lock and blocks a stale order callback")
	flight.set_paused(false)
	flight.open_wingmen()
	button(flight.navigation_panel, app.library.text(150)).pressed.emit()
	check(crew(flight.space).all(func(b): return b.ai.wingman_weapon == 0), "native switch back selects the ordinary gun")
	check(state(app.game) == before, "all paused UI boundaries preserve every earned session field")
	flight.open_wingmen()
	await frames(3)
	var key := InputEventKey.new()
	key.keycode = KEY_DOWN; key.physical_keycode = KEY_DOWN; key.pressed = true
	Input.parse_input_event(key); Input.flush_buffered_events(); await frames(2)
	key = InputEventKey.new(); key.keycode = KEY_DOWN; key.physical_keycode = KEY_DOWN; key.pressed = false
	Input.parse_input_event(key); Input.flush_buffered_events(); await frames(2)
	check(root.gui_get_focus_owner() == button(flight.navigation_panel, app.library.text(151)),
		"actual Down key skips both disabled rows to the enabled weapon switch")
	flight.close_navigation()

func check_targets(sim) -> void:
	var pilot = crew(sim)[0]
	var neutral = sim._spawn_ship(0, Vector3.ZERO, false)
	# Explicit in-memory targeting geometry, never an earned world.
	neutral.hostile = false; neutral.friendly = false
	neutral.pos = pilot.pos + Vector3(0, 0, 10000)
	sim.target = neutral; sim.locked = true
	var before := state(sim.game)
	check(Wingmen.issue(sim, 4), "a real lock can explicitly command a neutral non-fixed-friendly ship")
	AI._choose_target(sim, pilot)
	check(pilot.ai.target == neutral, "focused order overrides ordinary hostility selection")
	neutral.pos = pilot.pos + Vector3(49000, 49000, 49000)
	check(Wingmen.focus_target(sim, pilot) == neutral, "source sight is an axis box, not a shorter sphere")
	AI.step(sim, pilot, 0.0, 0)
	check(pilot.ai.target == neutral, "native AI retains a commanded target inside all three source sight axes")
	neutral.pos = pilot.pos + Vector3(49999, 0, 0)
	AI._choose_target(sim, pilot)
	check(pilot.ai.target == neutral, "focused target is acquired immediately inside the strict sight boundary")
	neutral.pos = pilot.pos + Vector3(50000, 0, 0)
	AI.step(sim, pilot, 0.0, 0)
	check(pilot.ai.target != neutral, "exact sight boundary releases a stale focused target immediately")
	for kind in ["fixed friend", "dead", "hidden", "removed", "player", "crew", "station", "unlocked"]:
		neutral.alive = true; neutral.visible = true; neutral.ai.erase("fixed_friendly")
		if not sim.bodies.has(neutral): sim.bodies.append(neutral)
		neutral.pos = pilot.pos + Vector3(0, 0, 10000)
		sim.target = neutral; sim.locked = true
		match kind:
			"fixed friend": neutral.ai.fixed_friendly = true
			"dead": neutral.alive = false
			"hidden": neutral.visible = false
			"removed": sim.bodies.erase(neutral)
			"player": sim.target = sim.player
			"crew": sim.target = crew(sim)[1]
			"station": sim.target = sim.station
			"unlocked": sim.locked = false
		var old: int = pilot.ai.wingman_order
		check(not Wingmen.issue(sim, 4) and int(pilot.ai.wingman_order) == old, "invalid target is rejected atomically: " + kind)
	check(Wingmen.issue(sim, 2) and pilot.ai.wingman_target == null and pilot.ai.wingman_order == 2,
		"Fire at will clears explicit target authority and restores formation")
	check(not Wingmen.issue(sim, 0) and not Wingmen.issue(sim, 99), "unexposed order codes cannot mutate the crew")
	check(state(sim.game) == before, "target changes do not manufacture session progress or contract time")

func check_gunnery(same_faction := false) -> void:
	var game = fixture()
	var sim := Space.new(game); sim.build()
	var pilot = crew(sim)[0]
	var enemy = sim._spawn_ship(8, Vector3.ZERO, false)
	if same_faction:
		enemy.faction = pilot.faction
		enemy.hostile = false; enemy.friendly = false
	print("GUNNERY MEMORY CASE: ", "explicit neutral of the pilot's faction" if same_faction else "ordinary pirate")
	# Stationary memory-only test geometry isolates native AI/projectile hits.
	for body in sim.bodies:
		if body != sim.player and body != pilot and body != enemy: body.alive = false
	pilot.pos = Vector3(500000, 0, 500000); pilot.basis = Basis.IDENTITY; pilot.speed = 0
	enemy.pos = pilot.pos + Vector3(0, 0, 10000); enemy.speed = 0
	sim.player.pos = pilot.pos + Vector3(0, 0, -10000)
	sim.target = enemy; sim.locked = true
	var before := state(game)
	check(Wingmen.issue(sim, 1) and Wingmen.issue(sim, 4), "EMP selection and focused attack use native command dispatch")
	var weapon: Dictionary = pilot.weapons[1]
	check(weapon.id == 18 and weapon.damage == 0 and weapon.emp == app.catalogue.attr(18, app.catalogue.A_EMP_DAMAGE)
		and weapon.reload == 400 and weapon.life == 3000 and weapon.speed == 16.0,
		"EMP uses the supplied attribute and exact source NPC gun parameters")
	var defenses := [enemy.hull, enemy.armor, enemy.shield]
	var fired := false; var only_emp := true; var peak := 0
	for i in 2400:
		AI.step(sim, pilot, 1.0 / 60.0, 16)
		peak = maxi(peak, sim.projectiles.size())
		for projectile in sim.projectiles:
			fired = true; only_emp = only_emp and projectile.owner == pilot and int(projectile.weapon.id) == 18
		sim._projectiles_step(1.0 / 60.0, 16)
		if enemy.disabled: break
	check(fired and only_emp and peak <= 4, "only the selected wingman gun emits real native projectiles with four slots")
	check(enemy.disabled and [enemy.hull, enemy.armor, enemy.shield] == defenses,
		"actual native EMP projectile collisions disable the victim without hull, armor or shield damage")
	var in_air := sim.projectiles.size()
	check(Wingmen.issue(sim, 1) and sim.projectiles.size() == in_air and pilot.ai.wingman_target == null,
		"weapon switch clears command authority but does not erase already fired projectiles")
	Wingmen.issue(sim, 4)
	var ordinary := false
	for i in 600:
		AI.step(sim, pilot, 1.0 / 60.0, 16)
		ordinary = ordinary or sim.projectiles.any(func(p): return p.owner == pilot and int(p.weapon.id) == -1)
		sim._projectiles_step(1.0 / 60.0, 16)
		if enemy.hull < int(defenses[0]): break
	check(ordinary and enemy.hull < int(defenses[0]), "switching back fires native damaging shots instead of both banks together")
	check(state(game) == before, "wingman gunnery grants no player kills and consumes no player ammunition or money")
	if same_faction:
		# Synthetic swept segment isolates only same-side collision filtering.
		var bullet := {"owner": pilot, "pos": enemy.pos - Vector3(0, 0, 1000), "target": enemy}
		enemy.ai.fixed_friendly = true
		check(sim._sweep(bullet, Vector3(0, 0, 2000)) == null, "explicit shots still cannot hit a same-side fixed story ally")
		enemy.ai.erase("fixed_friendly")
		bullet.target = null
		check(sim._sweep(bullet, Vector3(0, 0, 2000)) == null, "untargeted friendly ships retain the ordinary NPC lane protection")
		bullet.target = enemy
		pilot.ai.erase("wingman")
		check(sim._sweep(bullet, Vector3(0, 0, 2000)) == null, "an ordinary same-side NPC does not gain wingman command authority")
	sim.dispose()

func check_routes() -> void:
	for kind in [3, 5, 6]:
		var game = fixture()
		game.session.job = {"kind": kind, "station": 95, "difficulty": 1, "count": 2,
			"race": 0, "client": "Memory fixture", "item": 116, "reward": 0}
		var sim := Space.new(game); sim.build()
		var pilot = crew(sim)[0]
		var goal = Wingmen.mission_waypoint(sim)
		check(goal != null and goal == sim.story.wingman_route[0], "source-backed native mission route exists for job " + str(kind))
		if kind in [3, 5]:
			# Recovery ships scatter around the mission point. A crew order
			# secures that route point, not the first pirate's moving body.
			check(absf(goal.x) >= 40000 and absf(goal.x) < 120000 and goal.y == 0
				and absf(goal.z) >= 40000 and absf(goal.z) < 120000, "recovery secure-waypoint uses the source route bounds")
			var inside_scatter := true
			for body in sim.story.cast:
				var offset: Vector3 = body.pos - goal
				inside_scatter = inside_scatter and (offset.x >= -20000 and offset.x < 20000
					and offset.y >= -20000 and offset.y < 20000 and offset.z >= -20000 and offset.z < 20000)
			check(inside_scatter, "all designated pirates remain inside their own mission-point scatter cube")
		else:
			check(goal == sim.story.cast[0].pos, "unchanged bounty waypoint retains its designated target location")
		check(Wingmen.issue(sim, 3) and pilot.ai.wingman_waypoint == goal, "Secure waypoint copies the real current mission point")
		sim.target = sim.station
		game.destination = {"station": 96} # Deliberately unrelated memory-only map target.
		check(Wingmen.secure_goal(pilot) == goal, "later station/lock selection cannot redirect an accepted mission waypoint")
		sim.player.pos = goal + Vector3(1999, 1999, 1999)
		sim.story.step_scene(16)
		check(sim.story.wingman_route_index == 1 and Wingmen.mission_waypoint(sim) == null
			and pilot.ai.wingman_waypoint == goal, "player route progress does not rewrite the wingman's independent copy")
		pilot.pos = goal + Vector3(2000, 0, 0)
		check(Wingmen.secure_goal(pilot) == goal, "source waypoint box excludes its exact boundary")
		pilot.pos = goal + Vector3(1999, 1999, 1999)
		check(Wingmen.secure_goal(pilot) == null and pilot.ai.wingman_order == 0
			and sim.story.wingman_route_index == 1, "arrival retires only that pilot's copied point into source order zero")
		check(crew(sim)[1].ai.wingman_order == 3, "one pilot's arrival cannot complete another pilot's route")
		sim.dispose()

func check_rebuild_and_unarmed() -> void:
	var game = fixture()
	var before := state(game)
	var sim := Space.new(game); sim.build()
	Wingmen.issue(sim, 1)
	sim.dispose()
	sim = Space.new(game); sim.build()
	check(crew(sim).all(func(b): return b.ai.wingman_weapon == 0 and b.ai.wingman_order == 2)
		and state(game) == before, "new-area reconstruction resets tactical state, never the paid timer or resources")
	sim.completed_flight = true
	check(not Wingmen.issue(sim, 1) and not Wingmen.issue(sim, 2), "retired flight worlds cannot command surviving roster data")
	sim.dispose()
	game = fixture()
	game.session.job = {"kind": 12, "station": 95, "difficulty": 1, "count": 3,
		"race": 0, "client": "Memory contest", "reward": 0}
	sim = Space.new(game); sim.build()
	check(crew(sim).all(func(b): return b.weapons.is_empty()) and not Wingmen.issue(sim, 1),
		"source unarmed contests cannot gain a free gun by using the EMP switch")
	check(Wingmen.issue(sim, 2) and crew(sim).all(func(b): return b.weapons.is_empty()),
		"an unarmed crew can receive formation orders without becoming armed")
	sim.dispose()
