extends SceneTree
## MEMORY-ONLY contract/lifecycle boundaries. Synthetic funds, mission and
## timer values below never become earned saves or touch player storage.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
const AI := preload("res://src/flight/ai.gd")
const Body := preload("res://src/flight/body.gd")
const Wingmen := preload("res://src/flight/wingmen.gd")
const INPUT := "res://../../local/checks/earned-buyer-rendered-b-20260928/earned-buyer-completed45.json"
const INPUT_SHA := "0c9c85d42e2639cd67adc7874681a9fedd091e80b3743321af263b14f953668e"
var app
var header := {}
var checks := 0
var failures := 0

func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)
func frames(count: int) -> void:
	for i in count: await process_frame
func normalized(value): return JSON.parse_string(JSON.stringify(value))
func state(game) -> Dictionary: return normalized(game.session.to_dict())
func fixture():
	var game := Game.new(app.library, app.catalogue)
	check(game.session.from_dict(header).is_empty(), "memory fixture loads the immutable earned schema")
	return game
func pilots(space) -> Array:
	return space.bodies.filter(func(b): return bool(b.ai.get("wingman", false)))

func run() -> void:
	check(FileAccess.get_sha256(INPUT) == INPUT_SHA, "wingman input is the accepted unchanged buyer checkpoint")
	if failures > 0: quit(2); return
	header = JSON.parse_string(FileAccess.get_file_as_string(INPUT))
	app = Host.new(); root.add_child(app); await frames(2)
	check(app.activate(str(header.content)), "wingmen use the player's supplied content catalogue")
	if failures > 0: app.queue_free(); await frames(2); quit(2); return
	var game = fixture()
	var offer: Dictionary = normalized(game.lounge()[0])
	check(int(offer.kind) == 6 and int(offer.price) == 1542 and offer.pilots == ["Stu Adlam", "Cody Hamilton"],
		"retained offer contains exactly the actual two pilots and finite price")
	game.session.credits = 1541 # Explicit insufficient-funds memory fixture.
	var before := state(game)
	check(not game.accept_job(0).is_empty() and state(game) == before, "unaffordable hiring changes no state")
	game = fixture(); before = state(game)
	check(game.accept_job(0).is_empty(), "actual affordable retained contract can be hired")
	var expected := before.duplicate(true)
	expected.credits = int(expected.credits) - 1542
	expected.flags.wingmen = offer.pilots.duplicate()
	expected.flags.wingmen_race = int(offer.race)
	expected.flags.wingmen_remaining_ms = 600000
	expected.flags.wingmen_face = offer.face.duplicate()
	expected.stats.commanded_wingmen = int(expected.stats.get("commanded_wingmen", 0)) + 2
	expected.markets[0].lounge[0].kind = 1
	expected.markets[0].lounge[0].speech = app.library.text(492)
	check(state(game) == normalized(expected), "hiring pays once, records two hires, face and exactly ten minutes")
	before = state(game); game.accept_job(0)
	check(state(game) == before, "consumed offer cannot debit or count the crew twice")
	var another: Dictionary = offer.duplicate(true)
	check(not game.bar.accept(another).is_empty() and state(game) == before, "an existing roster blocks another hire without payment")
	var sim := Space.new(game); sim.build()
	var crew := pilots(sim)
	check(crew.size() == 2, "native flight builds both paid pilots rather than only storing their names")
	if crew.size() == 2:
		check(crew.map(func(b): return b.name) == offer.pilots, "spawned ships retain the actual hired names")
		check(crew.all(func(b): return b.hull == 600 and b.hull_max == 600 and b.friendly and not b.hostile and b.ai.get("fixed_friendly", false)),
			"both damageable 600-hull pilots are fixed friends")
		check(crew.all(func(b): return b.faction == int(offer.race) and b.ai.mode == "escort" and not b.weapons.is_empty()),
			"crew uses its saved race, default formation and ordinary guns")
		var friendly := Body.new(); friendly.faction = 9; friendly.friendly = true
		var enemy := Body.new(); enemy.faction = int(offer.race); enemy.hostile = true
		check(not AI._enemies(crew[0], friendly) and AI._enemies(crew[0], enemy), "paid pilots target player enemies, not faction-based friendly ships")
		var hp: int = crew[0].hull
		sim._harm(crew[0], 1.0, 0.0, sim.player)
		check(crew[0].hull == hp - 1 and crew[0].friendly and not crew[0].hostile,
			"friendly fire damages a hired pilot without changing its allegiance")
	var timer := int(game.session.flags.get("wingmen_remaining_ms", -1))
	sim.step(0.016, {})
	check(int(game.session.flags.get("wingmen_remaining_ms", -1)) == timer - 16,
		"only actual native flight frames spend contract time")
	timer = int(game.session.flags.get("wingmen_remaining_ms", -1))
	sim.completed_flight = true # Explicit retired-world fixture.
	sim.step(0.016, {})
	check(int(game.session.flags.get("wingmen_remaining_ms", -1)) == timer,
		"a retired world cannot spend the replacement world's contract time")
	sim.dispose()
	before = state(game)
	sim = Space.new(game); sim.build()
	check(pilots(sim).size() == 2 and state(game) == before, "a new area respawns survivors without recharging time or charging credits")
	crew = pilots(sim)
	if crew.size() == 2:
		sim._harm(crew[0], 10000.0, 0.0, null)
		check(game.session.flags.wingmen == ["Cody Hamilton"], "first pilot death removes only its own persisted roster entry")
		sim._harm(crew[0], 10000.0, 0.0, null)
		check(game.session.flags.wingmen == ["Cody Hamilton"], "a repeated dead-body hit cannot remove another pilot")
		sim._harm(crew[1], 10000.0, 0.0, null)
		check(game.session.flags.get("wingmen", []).is_empty() and not game.session.flags.has("wingmen_face"),
			"last pilot death clears the remaining roster and portrait")
	sim.dispose()
	game = fixture(); game.accept_job(0)
	game.session.flags.wingmen_remaining_ms = 0 # Explicit expiry at entry.
	before = state(game)
	sim = Space.new(game); sim.build()
	check(pilots(sim).is_empty() and game.session.flags.get("wingmen", []).is_empty()
		and not game.session.flags.has("wingmen_face"), "expired contract is cleared at new-area construction")
	check(game.session.credits == int(before.credits) and state(game).stats == before.stats,
		"expiry grants no refund, replacement hire or statistical credit")
	sim.dispose()
	game = fixture(); game.accept_job(0)
	game.session.flags.erase("wingmen_remaining_ms") # Old stub-save fixture.
	sim = Space.new(game); sim.build()
	check(pilots(sim).is_empty() and game.session.flags.get("wingmen", []).is_empty(),
		"legacy roster with no earned timer cannot silently gain a free ten-minute contract")
	sim.dispose()
	check_persistence()
	check_special_flights()
	check_combat()
	await check_expiry_screen()
	check(app.save_attempts.is_empty() and app.disk_saves.is_empty(), "all synthetic boundary states remain memory-only with zero save attempts")
	check(FileAccess.get_sha256(INPUT) == INPUT_SHA, "boundary checks leave the accepted native save untouched")
	app.queue_free(); await frames(3)
	print("%d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)

func check_persistence() -> void:
	var game = fixture(); game.accept_job(0)
	var saved := state(game)
	var restored = fixture()
	check(restored.session.from_dict(saved).is_empty() and state(restored) == saved,
		"JSON load preserves every paid contract field without a free timer reset")
	for sample in [["wingmen", "pilot"], ["wingmen", [""]], ["wingmen", ["A", "B", "C", "D"]],
		["wingmen_remaining_ms", -1], ["wingmen_remaining_ms", 600001], ["wingmen_remaining_ms", 0.5],
		["wingmen_remaining_ms", "600000"], ["wingmen_race", 10], ["wingmen_face", "face"], ["wingmen_face", [0, -1]]]:
		var bad := saved.duplicate(true); bad.flags[str(sample[0])] = sample[1]
		check(not restored.session.from_dict(bad).is_empty() and state(restored) == saved,
			"malformed crew save is rejected atomically: " + JSON.stringify(sample))
	check(Wingmen.fighter_index("Stu Adlam", 1, 37) == 9 and Wingmen.fighter_index("Cody Hamilton", 9, 37) == 8
		and Wingmen.fighter_index("A", 0, 1) == -1, "source special-race hulls and missing-content boundary are explicit")
	print("WINGMEN STATIC HULLS ", JSON.stringify({"count": app.catalogue.ship_count(), "names": saved.flags.wingmen,
		"race": saved.flags.wingmen_race, "indices": saved.flags.wingmen.map(func(n): return Wingmen.fighter_index(n, int(saved.flags.wingmen_race), app.catalogue.ship_count()))}))

func check_special_flights() -> void:
	var game = fixture()
	var before: Dictionary = state(game).flags
	var sim := Space.new(game); sim.build(); sim.step(0.016, {})
	check(pilots(sim).is_empty() and state(game).flags == before, "ordinary no-crew flight does not manufacture contract flags")
	sim.dispose()
	game = fixture(); game.accept_job(0)
	sim = Space.new(game); sim.build()
	var hulls: Array = pilots(sim).map(func(b): return b.ship_index)
	check(sim.jump_to(95), "actual fitted native drive can begin in the memory-only crew fixture")
	sim.step(0.016, {})
	check(int(game.session.flags.wingmen_remaining_ms) == 599984, "drive cinematic spends the same actual sixteen contract milliseconds")
	sim.dispose()
	game.arrival_mode = "drive" # Explicit arrival-layout fixture, never earned travel.
	before = state(game)
	sim = Space.new(game); sim.build()
	check(pilots(sim).map(func(b): return b.ship_index) == hulls and state(game) == before,
		"source name-seeded fighter identities are stable on rebuilt flight areas")
	check(pilots(sim).all(func(b): return b.pos == sim.arrival.pos + Vector3(-3000, 1000, 5000)),
		"stream arrivals use the supplied crew offset rather than station-launch coordinates")
	sim.dispose()
	game = fixture(); game.accept_job(0)
	game.session.job = game.lounge()[2].job.duplicate(true)
	game.session.job.kind = 12; game.session.job.station = 96 # Explicit local contest fixture.
	sim = Space.new(game); sim.build()
	check(sim.story != null and pilots(sim).size() == 2 and pilots(sim).all(func(b): return b.weapons.is_empty()),
		"source type-twelve contest keeps the paid crew present but unarmed")
	sim.dispose()
	game.session.job.station = 95 # Explicit remote contest fixture.
	sim = Space.new(game); sim.build()
	check(pilots(sim).all(func(b): return not b.weapons.is_empty()), "a remote contest does not disarm unrelated ordinary flight")
	sim.dispose()
	game = fixture(); game.accept_job(0)
	game.session.flags.wingmen_remaining_ms = 16 # Explicit deadline fixture.
	sim = Space.new(game); sim.build(); sim.step(0.016, {})
	check(int(game.session.flags.wingmen_remaining_ms) == 0 and pilots(sim).size() == 2
		and game.session.flags.wingmen.size() == 2, "deadline reaches zero without inventing an immediate in-world despawn")
	sim.step(0.016, {})
	check(int(game.session.flags.wingmen_remaining_ms) == 0, "elapsed native contract stays at zero without underflow or recharge")
	sim.dispose()
	sim = Space.new(game); sim.build()
	check(pilots(sim).is_empty() and game.session.flags.get("wingmen", []).is_empty(),
		"only the next native area build retires the expired roster")
	sim.dispose()

func check_combat() -> void:
	var game = fixture(); game.accept_job(0)
	var sim := Space.new(game); sim.build()
	var pilot = pilots(sim)[0]
	# Explicit synthetic combat geometry isolates actual native AI/guns.
	for other in sim.bodies:
		if other != pilot and other != sim.player and other.is_ship(): other.alive = false
	var enemy = sim._spawn_ship(8, Vector3.ZERO, false)
	pilot.pos = Vector3(0, 0, 60000); pilot.basis = Basis.IDENTITY
	enemy.pos = Vector3(0, 0, 70000); sim.player.pos = Vector3(0, 0, 59000)
	pilot.ai.timer = AI.RETARGET_MS
	var selected := false; var fired := false
	for tick in 600:
		AI.step(sim, pilot, 1.0 / 60.0, 16)
		selected = selected or pilot.ai.get("target") == enemy
		fired = fired or sim.projectiles.any(func(p): return p.owner == pilot)
		if fired: break
	check(selected and fired, "hired formation acquires a real enemy and fires native projectiles, not scripted damage")
	sim.dispose()

func check_expiry_screen() -> void:
	app.game = fixture(); app.game.accept_job(0)
	app.game.session.flags.wingmen_remaining_ms = 32 # Explicit short-time UI fixture.
	app.show_flight()
	var flight = app.screen
	# Call the native screen's physics boundary with exact fixture deltas;
	# engine scheduling is disabled only for this labelled memory-only test.
	flight.set_physics_process(false)
	await frames(3)
	flight.set_paused(true)
	var before := state(app.game)
	flight._physics_process(1.0)
	check(state(app.game) == before and flight.space.clock == 0, "native paused flight screen spends neither playtime nor contract time")
	flight.set_paused(false)
	flight._physics_process(0.016); flight._physics_process(0.016)
	check(flight.paused and flight.conversation != null and flight.wingmen_expiry_shown
		and flight.conversation.lines[0].text == app.library.text(153)
		and flight.conversation.lines[0].name == "Stu Adlam", "actual deadline opens the supplied leader's expiry dialogue and pauses flight")
	before = state(app.game); flight._physics_process(1.0)
	check(state(app.game) == before and flight.hud.wingmen_remaining_ms() == 0, "expiry dialogue freezes the physical world and shows no renewed contract")
	flight.conversation.next_button.pressed.emit()
	flight._physics_process(0.016)
	check(not flight.paused and flight.conversation == null and pilots(flight.space).size() == 2,
		"acknowledging expiry resumes once without deleting current-area ships or reopening the notice")
