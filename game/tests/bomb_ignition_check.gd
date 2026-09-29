extends SceneTree
## MEMORY ONLY: supplied weapon data, synthetic geometry, zero save attempts.
## Secondary is an edge from Controls, not a held simulation trigger.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
const Body := preload("res://src/flight/body.gd")
const Controls := preload("res://src/flight/controls.gd")
const Touch := preload("res://src/flight/touch_controls.gd")
const INPUT := "res://../../local/checks/earned-defense-rendered-d-20260928/earned-defense-completed45.json"
const SHA := "c078dd42f73bfa217e3e0e46c42030dbb35291c156f730cc251ac00004dbf11f"
var app
var checks := 0
var failures := 0

func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)

func fixture(id := 41, count := 2):
	var game := Game.new(app.library, app.catalogue)
	check(game.session.from_dict(JSON.parse_string(FileAccess.get_file_as_string(INPUT))).is_empty(),
		"memory fixture reads the genuine completed schema")
	var sim := Space.new(game)
	sim.player = Body.new(); sim.player.kind = Body.Kind.PLAYER
	sim.player.pos = Vector3.ZERO; sim.player.speed = 0
	sim.player.hull = 170; sim.player.hull_max = 170
	sim.player.emp = 100; sim.player.emp_max = 100
	var w: Dictionary = sim.weapon(id); w.count = count; w.slot = [1, 0]
	sim.player.weapons = [w]; sim.bodies = [sim.player]
	return sim

func blasts(sim) -> int:
	return sim.effects.filter(func(e): return e.kind == "blast").size()

func target_at(sim, pos: Vector3, friendly := false):
	var b := Body.new(); b.pos = pos; b.speed = 0
	b.hull = 100000; b.hull_max = 100000
	b.emp = 100; b.emp_max = 100; b.faction = -1
	b.friendly = friendly; b.ai.fixed_friendly = friendly
	sim.bodies.append(b)
	return b

func finger(touch, down: bool) -> void:
	var e := InputEventScreenTouch.new(); e.index = 7; e.pressed = down
	e.position = touch.buttons.secondary.get_center()
	check(touch.handle_touch(e), "secondary finger accepted: " + str(down))

func device_edge(controls, touch, device: String, down: bool) -> void:
	if device == "touch": finger(touch, down); return
	var e: InputEvent
	if device == "keyboard":
		e = InputEventKey.new(); e.physical_keycode = KEY_E; e.keycode = KEY_E; e.pressed = down
	else:
		e = InputEventJoypadButton.new(); e.button_index = JOY_BUTTON_LEFT_SHOULDER; e.pressed = down
	Input.parse_input_event(e); Input.flush_buffered_events()

func run() -> void:
	check(FileAccess.get_sha256(INPUT) == SHA, "accepted completed input is immutable before memory tests")
	app = Host.new(); root.add_child(app); await process_frame; await process_frame
	check(app.library != null, "supplied content is available")
	if failures: app.queue_free(); await process_frame; quit(1); return
	var nuke_id := -1
	for id in app.library.data.items.size():
		if app.catalogue.type(id) == app.catalogue.Type.NUKE: nuke_id = id; break
	check(nuke_id >= 0, "a nuke comes from supplied catalogue, not invented parameters")
	for id in [41, nuke_id]:
		var sim = fixture(id)
		var w: Dictionary = sim.player.weapons[0]
		check(w.kind in ["emp", "nuke"] and w.blast > 0, "supplied area weapon parameters")
		sim._player_weapons_step(0, {"secondary": true})
		check(w.count == 1 and sim.shots_fired == 1 and sim.projectiles.size() == 1,
			"first secondary edge launches exactly one finite projectile")
		# Move only fixture geometry. Actual rendered acceptance may not do this.
		var p: Dictionary = sim.projectiles[0]; p.pos = Vector3(0, 0, 100000)
		var near = target_at(sim, p.pos)
		var ally = target_at(sim, p.pos + Vector3(float(w.blast) * 0.5, 0, 0), true)
		var outside = target_at(sim, p.pos + Vector3(float(w.blast), 0, 0))
		var cooldown: int = w.cooldown
		sim._player_weapons_step(0, {"secondary": true})
		check(sim.projectiles.is_empty() and blasts(sim) == 1,
			"second edge manually ignites active bomb during reload")
		check(w.count == 1 and sim.shots_fired == 1 and w.cooldown == cooldown,
			"ignition spends no additional ammunition, launch or cooldown")
		if w.kind == "emp":
			check(near.emp == maxi(0, 100 - int(w.emp)) and near.hull == 100000,
				"manual EMP uses supplied center strength without hull damage")
			check(ally.emp == maxi(0, 100 - int(w.emp * 0.5)) and ally.hull == 100000,
				"manual EMP retains friendly area effects and distance falloff")
		else:
			check(near.hull == 100000 - int(w.damage), "manual nuke uses supplied center hull damage")
			check(ally.hull == 100000 - int(ceil(w.damage * 0.5)), "manual nuke retains friendly distance falloff")
		check(outside.hull == 100000 and outside.emp == 100 and sim.player.hull == 170 and sim.player.emp == 100,
			"exact blast boundary and distant player receive no effect")
		sim._player_weapons_step(0, {"secondary": true})
		sim._projectiles_step(10.0, 10000)
		check(blasts(sim) == 1 and w.count == 1 and sim.shots_fired == 1,
			"consumed bomb cannot ignite again or expire into a second blast")
		sim.dispose()
	# An exhausted launcher still retains control of its airborne bomb.
	var sim = fixture(41, 1); var w: Dictionary = sim.player.weapons[0]
	sim._player_weapons_step(0, {"secondary": true})
	sim.projectiles[0].pos = Vector3(0, 0, 100000)
	sim._store_ship_state()
	check(sim.game.session.equipment[1][0] == null and w.count == 0, "native snapshot clears the exhausted fitting slot")
	sim._player_weapons_step(0, {"secondary": true})
	check(sim.projectiles.is_empty() and blasts(sim) == 1 and w.count == 0, "empty-stack active bomb still ignites")
	sim._player_weapons_step(int(w.reload), {"secondary": true})
	check(sim.projectiles.is_empty() and sim.shots_fired == 1, "empty launcher cannot fire after reload")
	sim.dispose()
	# Reload completion must not replace an active bomb with a second launch.
	sim = fixture(); w = sim.player.weapons[0]
	sim._player_weapons_step(0, {"secondary": true}); sim.projectiles[0].pos = Vector3(0, 0, 100000)
	sim._player_weapons_step(int(w.reload), {"secondary": true})
	check(w.count == 1 and sim.projectiles.is_empty() and sim.shots_fired == 1,
		"active bomb wins over a ready same-launcher shot")
	sim._player_weapons_step(0, {"secondary": true})
	check(w.count == 0 and sim.projectiles.size() == 1 and sim.shots_fired == 2,
		"a later independent press launches normally after ignition and reload")
	sim.dispose()
	for lock in ["docking", "jumping", "travelling"]:
		sim = fixture(); w = sim.player.weapons[0]
		sim._player_weapons_step(0, {"secondary": true})
		sim.set(lock, 0)
		sim._player_weapons_step(0, {"secondary": true})
		check(blasts(sim) == 0 and sim.projectiles.size() == 1 and w.count == 1,
			"navigation lock blocks manual ignition: " + lock)
		sim.dispose()
	# Ownership and weapon identity matter, even for equal dictionaries.
	sim = fixture(41, 0); w = sim.player.weapons[0]
	var foreign = target_at(sim, Vector3(100000, 0, 0))
	var other: Dictionary = w.duplicate(true)
	sim._fire(foreign, w); sim._fire(sim.player, other)
	sim._player_weapons_step(0, {"secondary": true})
	check(sim.projectiles.size() == 2 and blasts(sim) == 0,
		"foreign-owner and equal-but-different-launcher projectiles cannot be ignited")
	sim.dispose()
	# Dictionary equality is not projectile identity: both rounds can occupy
	# the same position with equal-valued but distinct launcher dictionaries.
	sim = fixture(41, 0); w = sim.player.weapons[0]
	other = w.duplicate(true)
	sim._fire(sim.player, other); sim._fire(sim.player, w)
	var other_round: Dictionary = sim.projectiles[0]
	sim._player_weapons_step(0, {"secondary": true})
	check(sim.projectiles.size() == 1 and is_same(sim.projectiles[0], other_round) and blasts(sim) == 1,
		"retirement preserves the exact unrelated projectile, not an equal dictionary")
	sim._player_weapons_step(0, {"secondary": true})
	check(blasts(sim) == 1 and sim.projectiles.size() == 1,
		"equal-valued unrelated round cannot cause repeated ignition")
	sim.dispose()
	for lifetime in [0, -1]:
		sim = fixture(41, 0); w = sim.player.weapons[0]
		sim._fire(sim.player, w); sim.projectiles[0].life = lifetime
		sim._player_weapons_step(0, {"secondary": true})
		check(blasts(sim) == (1 if lifetime == 0 else 0),
			"manual active boundary follows supplied nonnegative lifetime: " + str(lifetime))
		sim.dispose()
	# Preserve supplied per-launcher ordering: ignition continues to later slots.
	sim = fixture(); w = sim.player.weapons[0]
	sim._player_weapons_step(0, {"secondary": true}); sim.projectiles[0].pos = Vector3(0, 0, 100000)
	var rocket: Dictionary = sim.weapon(35); rocket.count = 2
	sim.player.weapons.append(rocket)
	sim._player_weapons_step(0, {"secondary": true})
	check(blasts(sim) == 1 and w.count == 1 and rocket.count == 1 and sim.projectiles.size() == 1
		and is_same(sim.projectiles[0].weapon, rocket), "ignition continues to a later ready launcher with its own finite cost")
	sim.dispose()
	# Actual Controls: launch on press, not hold; re-press ignites once.
	var touch := Touch.new(); root.add_child(touch)
	var controls := Controls.new(); controls.app = app; controls.touch = touch; root.add_child(controls)
	await process_frame
	for device in ["touch", "keyboard", "gamepad"]:
		sim = fixture(); w = sim.player.weapons[0]; controls.reset()
		device_edge(controls, touch, device, true)
		var input: Dictionary = controls.state(null)
		check(input.secondary, device + " produces a launch edge")
		sim._player_weapons_step(0, input)
		for tick in 5:
			await process_frame
			sim._player_weapons_step(0, controls.state(null))
		check(w.count == 1 and sim.projectiles.size() == 1 and blasts(sim) == 0,
			device + " hold cannot detonate or repeatedly fire")
		device_edge(controls, touch, device, false); await process_frame
		check(not controls.state(null).secondary, device + " release is not a trigger")
		device_edge(controls, touch, device, true)
		sim._player_weapons_step(0, controls.state(null))
		check(w.count == 1 and sim.projectiles.is_empty() and blasts(sim) == 1,
			device + " second press ignites exactly once")
		device_edge(controls, touch, device, false); await process_frame
		sim.dispose()
	controls.queue_free(); touch.queue_free()
	check(app.save_attempts.is_empty() and app.disk_saves.is_empty(), "memory ignition fixtures never save or modify settings on disk")
	check(FileAccess.get_sha256(INPUT) == SHA, "accepted completed input is byte-identical after fixtures")
	app.queue_free(); await process_frame; await process_frame
	print("BOMB IGNITION: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
