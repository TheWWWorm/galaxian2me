extends SceneTree
## Explicit memory-only boundary fixtures. No fixture state becomes a disk save.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
const Body := preload("res://src/flight/body.gd")
const HUD := preload("res://src/flight/hud.gd")
const INPUT_SHA := "8d9e3826cfcf1b08f8ffeb9cb5f675e6b0be57e66c1c0319a11400437c14a3b4"
var app
var header := {}
var checks := 0
var failures := 0

func _init() -> void: run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)

func fixture() -> Space:
	var game := Game.new(app.library, app.catalogue)
	check(game.session.from_dict(header).is_empty(), "memory fixture accepts the unchanged native ending schema")
	check(game.accept_job(1).is_empty(), "actual saved lounge offer can be accepted after the ending")
	check(int(game.session.job.kind) == 7 and int(game.session.job.reward) == 3350,
		"fixture uses the saved cleanup offer, not a generated success mission")
	check(game.session.credits == 42337 and game.session.stat("jobs") == 2,
		"acceptance does not pay or count a completion")
	# Fixture location only. Actual travel is tested by the separate earned run.
	game.session.station_id = 96
	game.session.system_index = app.catalogue.system_of_station(96)
	game.arrival_mode = "travel"
	var space := Space.new(game)
	space.build()
	return space

func remaining(story) -> int:
	return int(story.call("job_remaining_ms")) if story.has_method("job_remaining_ms") else -2

func run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 1 or FileAccess.get_sha256(args[0]) != INPUT_SHA:
		push_error("Provide the unmodified native freeplay45 input for memory-only fixtures.")
		quit(2)
		return
	header = JSON.parse_string(FileAccess.get_file_as_string(args[0]))
	app = Host.new()
	root.add_child(app)
	await process_frame
	var space := fixture()
	var story = space.story
	check(story != null and not story.active() and not story.job.is_empty(),
		"a terminal campaign builds the freelance scene without restarting the story")
	check(story.cast.size() == 37 and int(story.objective.to) == 36 and int(story.failure.ms) == 121000,
		"difficulty six retains the source 36 junk, one pirate and 121000ms limit")
	var hud := HUD.new()
	var targets := true
	for i in 36:
		var junk: Body = story.cast[i]
		targets = targets and junk.model == "spacejunk" and junk.faction == -1 and junk.hull == 1 \
			and junk.hostile and not junk.friendly and junk.weapons.is_empty() and hud._standing(junk) == "enemy"
	check(targets, "all source cleanup junk are marked as unarmed enemy targets, not neutral traffic")
	hud.space = space
	check(hud.countdown_remaining_ms() == 121000, "the actual HUD uses the freelance timer, not just campaign timers")
	hud.free()
	check(remaining(story) == 121000, "cleanup exposes its actual initial countdown to the HUD")
	story.clock = 8000 # declared clock boundary, never a live run
	check(remaining(story) == 113000, "cleanup countdown follows the existing simulation clock")
	var before_kills: int = space.game.session.stat("kills")
	var before_cargo: Dictionary = space.game.session.cargo.duplicate(true)
	for i in 36: space._harm(story.cast[i], 1.0, 0.0, space.player)
	check(space.kills == 0 and space.game.session.stat("kills") == before_kills
		and space.game.session.stat("pirates") == int(header.stats.pirates),
		"destroying cleanup junk cannot inflate ship, pirate or contest kill counts")
	check(int(space.stats.get("junk_destroyed", 0)) == 36, "junk deaths have their own scene accounting")
	check(space.game.session.cargo == before_cargo, "destroyed junk grants no cargo without physical collection")
	story._check_objectives()
	check(not story.complete and space.game.session.credits == 42337,
		"cleanup waits for the source death-settlement boundary before payment")
	space._cleanup(1000)
	story._check_objectives()
	check(story.complete and not story.failed and story.cast[36].alive,
		"settled junk completes the job without requiring the separate pirate's death")
	check(space.game.session.credits == 45687 and space.game.session.stat("jobs") == 3
		and space.game.session.job.is_empty(), "cleanup pays the exact real offer once and clears the job")
	check(space.game.session.story_step == 45 and space.game.session.story_mission.is_empty(),
		"freelance success leaves the completed campaign at terminal45")
	# The recorded save predates the second axis taking the original's sign;
	# loading turns it round once (Session.from_dict), so expect it that way.
	var axis1 := int(header.reputation[1]) * (1 if int(header.get("reputation_axes", 1)) >= 2 else -1)
	check(int(space.game.session.reputation[0]) == -32 and int(space.game.session.reputation[1]) == axis1,
		"only the source client-standing improvement accompanies junk cleanup")
	check(remaining(story) == -1, "completed cleanup removes its countdown")
	for i in 3: story._check_objectives()
	space.game.dock(96)
	check(space.game.session.credits == 45687 and space.game.session.stat("jobs") == 3,
		"repeated objective checks and subsequent docking cannot pay twice")
	space.dispose()
	var expired := fixture()
	expired.story.clock = 120999
	expired.story._check_objectives()
	check(not expired.story.failed and remaining(expired.story) == 1, "last millisecond is still available")
	expired.story.clock = 121000
	expired.story._check_objectives()
	check(expired.story.failed and not expired.story.complete and expired.game.session.job.is_empty(),
		"native deadline fails an unfinished cleanup and clears the contract")
	check(expired.game.session.credits == 42337 and expired.game.session.stat("jobs") == 2
		and expired.game.session.stat("jobs_failed") == 1, "expired job grants no reward or completion")
	check(remaining(expired.story) == -1, "failed cleanup removes its countdown")
	expired.dispose()
	check_drop_rules()
	check(app.save_attempts.is_empty(), "all cleanup boundary fixtures make zero save attempts")
	check(FileAccess.get_sha256(args[0]) == INPUT_SHA, "accepted native continuation remains byte-identical")
	app.queue_free()
	await process_frame
	await process_frame
	print("CLEANUP CONTRACT: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)

func check_drop_rules() -> void:
	var space := fixture()
	var valid := true
	var drops := 0
	var misses := 0
	var initial: int = space.game.session.stat("kills")
	# Deterministic unit boundaries only, never seeded earned gameplay.
	for seed_value in 40:
		var oracle := RandomNumberGenerator.new()
		oracle.seed = seed_value
		var expected := oracle.randi_range(0, 99) < 10
		var quantity := oracle.randi_range(1, 10) if expected else 0
		space.rng.seed = seed_value
		var junk := Body.new()
		junk.model = "spacejunk"
		junk.faction = -1
		junk.hostile = true
		junk.ai = {"mode": "hold"}
		var start: int = space.bodies.size()
		space._harm(junk, 1.0, 0.0, space.player)
		var added: int = space.bodies.size() - start
		valid = valid and added == (1 if expected else 0)
		if expected:
			drops += 1
			if added == 1:
				var loot: Body = space.bodies.back()
				valid = valid and loot.kind == Body.Kind.LOOT and int(loot.cargo[0]) == 99 and int(loot.cargo[1]) == quantity
		else: misses += 1
		space._harm(junk, 1.0, 0.0, space.player)
		valid = valid and space.bodies.size() == start + added
	check(valid and drops > 0 and misses > 0, "source ten-percent scrap-only drops retain 1..10 units and cannot duplicate on a dead junk hit")
	check(space.game.session.stat("kills") == initial and space.kills == 0,
		"all drop branches keep junk separate from combat statistics")
	space._harm(space.story.cast[36], 999999.0, 0.0, space.player)
	check(space.game.session.stat("kills") == initial + 1 and space.kills == 1,
		"a genuine pirate kill still counts normally beside the junk")
	space.dispose()
