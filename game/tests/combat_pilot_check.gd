extends "res://tests/transit_pilot_check.gd"
## Synthetic no-save combat policy tests, never earned campaign evidence.
const Combat := preload("res://tests/support/combat_pilot.gd")
func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		check(false, "supplied content available")
	else:
		var game := Game.new(app.library, app.catalogue)
		game.new_game()
		var space := Space.new(game)
		space.player = Body.new()
		space.player.kind = Body.Kind.PLAYER
		space.player.faction = 0
		space.player.shield_max = 80
		space.player.shield = 80.0
		space.player.hull = 170
		space.player.armor = 80
		space.player.weapons = [{"kind": "gun", "speed": 16.0, "life": 3000, "cooldown": 0}]
		var pirate := Body.new()
		pirate.pos = Vector3(0, 0, 20000)
		pirate.hostile = true
		pirate.hull = 164
		var rival := Body.new()
		rival.pos = Vector3(30000, 0, 0)
		rival.faction = 1
		rival.friendly = true
		rival.hull = 9999999
		space.bodies = [space.player, pirate, rival]
		space.clock = 1000
		var pilot := Combat.new()
		var before := world_state(space)
		var controls := pilot.input(space, [pirate, rival])
		check(pilot.mode == "attack" and controls.fire, "charged player aims and fires native primaries at a hostile")
		check(pilot.opponent.get_ref() == pirate, "friendly rival is never selected as an opponent")
		check(world_state(space) == before, "attack evaluation leaves body/session/RNG state untouched")
		space.player.shield = 40.0
		controls = pilot.input(space, [pirate, rival])
		check(pilot.mode == "recover" and pilot.recovery_started == 1000, "low shield starts an ordinary defensive breakaway")
		check(pilot.desired.z < 0 and not is_zero_approx(pilot.desired.x), "recovery flies away obliquely, not head-on at the pirate")
		check(controls.boost and not controls.get("secondary", false), "breakaway requests only the fitted booster, never finite ammunition")
		var first_direction := pilot.desired.normalized()
		space.clock = 3000
		pilot.input(space, [pirate, rival])
		check(first_direction.dot(pilot.desired.normalized()) > 0.8, "withdrawal sustains transverse motion across projectile travel time instead of tiny reversing zigzags")
		space.clock = 7000
		space.player.shield = 60.0
		pilot.input(space, [pirate])
		check(pilot.mode == "recover", "hysteresis holds withdrawal until shields have substantially recharged")
		space.player.shield = 80.0
		pilot.input(space, [pirate])
		check(pilot.mode == "attack" and pilot.recovery_started < 0, "naturally restored shield observation permits another attack pass")
		pirate.pos = Vector3(0, 0, 4000)
		controls = pilot.input(space, [pirate])
		check(pilot.mode == "break_pass" and pilot.pass_until > space.clock, "close head-on pass breaks off rather than colliding")
		pirate.pos = Vector3(0, 0, 20000)
		before = world_state(space)
		for i in 100:
			controls = pilot.input(space, [pirate, rival])
			if i == 0:
				for key in controls:
					check(key in ["yaw", "pitch", "boost", "autopilot", "fire"], "only ordinary input keys are returned")
		check(world_state(space) == before, "100 combat decisions cannot heal, move, damage, retarget, rescore or reroll the world")
		check(absf(controls.yaw) <= 1.0 and absf(controls.pitch) <= 1.0, "steering stays within native stick limits")
		pirate.alive = false
		check(pilot.input(space, [pirate, rival]).is_empty() and pilot.mode == "settling", "dead pirates and friendly rival leave native death settlement untouched")
		pirate.alive = true
		space.player.alive = false
		check(pilot.input(space, [pirate]).is_empty(), "defeat produces no input or fabricated recovery")
		space.player.alive = true
		space.jumping = 0
		check(pilot.input(space, [pirate]).is_empty(), "scripted native travel is not interrupted")
		space.jumping = -1
		space.clock = 12000
		space.player.shield = 80
		pirate.pos = Vector3(0, 0, 16000)
		space.target = pirate
		var rocket := {"kind": "missile", "emp": 60, "speed": 20.0, "life": 1000, "count": 7, "cooldown": 0}
		space.player.weapons.append(rocket)
		pilot = Combat.new()
		before = world_state(space)
		controls = pilot.input(space, [pirate, rival])
		check(controls.get("secondary", false), "one fitted finite EMP rocket may be requested against the actual close hostile target")
		check(rocket.count == 7 and world_state(space) == before, "requesting secondary neither consumes ammunition nor disables the hostile itself")
		space.projectiles = [{"owner": space.player, "target": pirate, "weapon": rocket}]
		check(not pilot.input(space, [pirate, rival]).get("secondary", false), "an EMP rocket already in flight suppresses duplicate expenditure")
		space.projectiles = []
		pirate.disabled = true
		check(not pilot.input(space, [pirate, rival]).get("secondary", false), "already disabled opponent receives no wasted EMP rocket")
		pirate.disabled = false
		space.target = rival
		check(not pilot.input(space, [pirate, rival]).get("secondary", false), "native friendly targeting cannot fire a rocket at Errkt")
		space.target = pirate
		rocket.count = 0
		check(not pilot.input(space, [pirate, rival]).get("secondary", false), "empty launcher never requests or invents ammunition")
		pirate.pos = Vector3(0, 0, 20000)
		rival.pos = Vector3(0, 0, 30000)
		pilot = Combat.new()
		check(not pilot.input(space, [pirate]).get("fire", false), "a friendly BEYOND a nearly defeated pirate blocks stray continuing primary shots")
		rival.pos = Vector3(4000, 0, 30000)
		rival.basis = Body.facing(Vector3.LEFT)
		check(not pilot.input(space, [pirate]).get("fire", false), "a friendly moving into the projectile corridor blocks primary fire")
		rival.pos = Vector3(30000, 0, 0)
		check(pilot.input(space, [pirate]).get("fire", false), "a distant off-axis friendly does not prevent a clear hostile shot")
		rival.pos = Vector3(6500, 0, 32000)
		rival.basis = Body.facing(Vector3.RIGHT)
		before = world_state(space)
		check(not pilot.friendly_corridor_clear(space),
			"friendly safety includes a reachable turn during projectile flight, not just its current straight heading")
		check(world_state(space) == before, "conservative friendly safety never redirects or protects the rival itself")
		controls = pilot.input(space, [pirate])
		check(pilot.mode == "reposition" and not controls.get("fire", false),
			"a friendly-blocked firing lane starts an ordinary flank instead of endlessly approaching without firing")
		check(pilot.desired.distance_to(pirate.pos) >= 12000.0,
			"the blocked-lane waypoint maintains a firing standoff rather than closing into a tight non-firing orbit")
		check(pilot.friendly_corridor_clear_at(space, pilot.desired, Body.facing(pirate.pos - pilot.desired)),
			"the proposed flank offers a clear full-lifetime friendly envelope from its hypothetical firing pose")
		check(not pilot.friendly_corridor_clear(space),
			"a clear hypothetical flank never makes the still-blocked ACTUAL firing pose safe")
		var flank_point := pilot.desired
		for decision in 20: pilot.input(space, [pirate])
		check(pilot.desired == flank_point,
			"repeated observations keep a stable flank instead of flipping direction every frame")
		check(world_state(space) == before,
			"flank planning never changes a ship, target, projectile, resource or RNG state")
		# No-save reproduction: a friendly overlaps the nearest hostile.
		# Every firing flank is unsafe, but another hostile is clear.
		pirate.pos = Vector3(0, 0, 20000)
		rival.pos = pirate.pos
		var alternative := Body.new()
		alternative.hostile = true
		alternative.pos = Vector3(30000, 0, 0)
		space.bodies.append(alternative)
		pilot = Combat.new()
		before = world_state(space)
		var no_flank := pilot.flanking_point(space, pirate)
		check(not pilot.friendly_corridor_clear_at(space, no_flank, Body.facing(pirate.pos - no_flank)),
			"overlapping friendly leaves the nearest pirate without any safe firing flank")
		controls = pilot.input(space, [pirate, alternative])
		check(pilot.opponent.get_ref() == alternative,
			"unshootable nearest pirate yields to a clear alternative instead of starving target selection")
		check(controls.yaw < -0.5 and not controls.get("fire", false) and not controls.get("secondary", false),
			"alternate choice requests a real turn but never fires along the still-blocked actual heading")
		for decision in 20: pilot.input(space, [pirate, alternative])
		check(pilot.opponent.get_ref() == alternative,
			"repeated observations do not snap back to an unshootable nearest pirate")
		check(world_state(space) == before,
			"alternate target planning leaves all native bodies, targeting, ammunition, score and RNG untouched")
		rocket.count = 7
		pilot = Combat.new()
		before = world_state(space)
		controls = pilot.input(space, [pirate, alternative])
		check(pilot.opponent.get_ref() == alternative and not controls.get("secondary", false),
			"EMP suppression cannot override safe alternative selection with an unshootable threat")
		check(world_state(space) == before, "safe suppression planning cannot spend or grant a rocket itself")
		alternative.alive = false
		pilot = Combat.new()
		controls = pilot.input(space, [pirate, alternative])
		check(pilot.opponent.get_ref() == pirate and not controls.get("fire", false) and not controls.get("secondary", false),
			"no feasible alternative keeps safety intact rather than inventing a safe shot or victory")
		# Separate distant geometry: an expired projectile is harmless, but
		# cannot make an overlapping hostile/friendly cluster shootable.
		alternative.alive = true
		alternative.pos = Vector3(-150000, 0, 0)
		# This older fixture gun lives3000ms, unlike C's2200ms primary.
		# Its full friendly-reach envelope extends slightly beyond65k.
		pirate.pos = Vector3(0, 0, 70000)
		rival.pos = pirate.pos
		pilot = Combat.new()
		before = world_state(space)
		check(pilot.friendly_corridor_clear(space),
			"actual distant shot expires before reaching either overlapped ship")
		check(pilot.find_flank_offset(space, pirate).is_zero_approx(),
			"distant overlapping ships still leave no safe close firing flank")
		check(not pilot.engagement_available(space, pirate),
			"an out-of-range harmless shot is not a feasible engagement")
		pilot.input(space, [pirate, alternative])
		check(pilot.opponent.get_ref() == alternative,
			"clear distant opponent wins over an unreachable and unshootable nearest cluster")
		check(world_state(space) == before,
			"range-aware selection does not spend ammunition or alter world and RNG state")
		var coherent := true
		for observed_z in [0, 10000, -1000, 11000, -2000, 12000]:
			space.player.pos = Vector3(0, 0, observed_z)
			before = world_state(space)
			pilot.input(space, [pirate, alternative])
			coherent = coherent and pilot.opponent.get_ref() == alternative and world_state(space) == before
		check(coherent,
			"approach and withdrawal observations cannot toggle back at an unshootable cluster's range boundary")
		space.player.pos = Vector3.ZERO
		space.bodies.erase(alternative)
		rocket.count = 0
		rival.pos = Vector3(30000, 0, 0)
		# Two pursuers can cancel the aggregate lateral vector. Keep a safe
		# course relative to EACH nearby firing line, without changing them.
		var flank := Body.new()
		flank.hostile = true
		flank.pos = Vector3(-14900, 0, -1700)
		pirate.pos = Vector3(0, 0, 20000)
		space.bodies.append(flank)
		space.player.shield = 20.0
		pilot = Combat.new()
		before = world_state(space)
		pilot.input(space, [pirate, flank])
		var course := space.player.pos.direction_to(pilot.desired)
		check(course.cross(flank.pos.direction_to(space.player.pos)).length() > 0.65
			and course.cross(pirate.pos.direction_to(space.player.pos)).length() > 0.65,
			"withdrawal cannot cancel transverse motion against one of two individual pursuers")
		check(world_state(space) == before, "withdrawal geometry remains a read-only control decision")
		space.bodies.erase(flank)
		space.player.shield = 80.0
		# Separate no-save fixture: exercise the native finite launcher and
		# its empty-slot serialization, not an earned campaign boundary.
		var finite := space.weapon(35)
		finite.slot = [1, 0]
		finite.count = 7
		space.player.weapons = [finite]
		game.session.equipment[1] = [{"id": 35, "count": 7}]
		space.projectiles = []
		space._player_weapons_step(0, {"secondary": true})
		space._store_ship_state()
		check(finite.count == 6 and game.session.equipment[1][0].count == 6 and space.shots_fired == 1,
			"native secondary input spends and stores exactly one real fixture rocket")
		for i in 6: space._player_weapons_step(int(finite.reload), {"secondary": true})
		space._store_ship_state()
		check(finite.count == 0 and game.session.equipment[1][0] == null and space.shots_fired == 7,
			"spending the seventh rocket natively serializes an empty slot, not a count-zero item")
		space._player_weapons_step(int(finite.reload), {"secondary": true})
		check(finite.count == 0 and space.shots_fired == 7,
			"continued native trigger input cannot refill or fire an exhausted launcher")
		finite.count = 7
		finite.cooldown = 0
		space.player.weapons = [{"kind": "gun", "speed": 16.0, "life": 3000, "cooldown": 0}, finite]
		space.projectiles = []
		space.player.shield = 60.0
		pirate.pos = Vector3(0, 0, 26000)
		space.target = pirate
		pilot = Combat.new()
		controls = pilot.input(space, [pirate])
		check(pilot.mode == "suppress" and controls.boost and not controls.get("secondary", false),
			"finite EMP approach boosts into real launch range instead of turning away too early or firing out of range")
		var second := Body.new()
		second.hostile = true
		second.pos = Vector3(4000, 0, 15000)
		space.bodies.append(second)
		pirate.disabled = true
		pilot.input(space, [pirate, second])
		check(pilot.opponent.get_ref() == second and finite.count == 7,
			"a disabled pirate yields suppression priority to the next real active threat without granting EMP or ammunition")
		space.player.shield = 2.0
		pilot.input(space, [pirate, second])
		space.player.shield = 10.0
		pilot.input(space, [pirate, second])
		check(pilot.mode == "recover", "a recovering pilot must not reverse into gunfire as soon as shield crosses ten percent")
		space.clock += 5000
		space.player.shield = 80.0
		pilot.input(space, [pirate, second])
		pilot.input(space, [pirate, second])
		check(pilot.mode == "suppress" and finite.count == 7,
			"observing full native shield recovery permits the next finite EMP approach without inventing a launch")
		check(app.save_attempts.is_empty(), "synthetic policy checks create no saved progress")
		space.dispose()
	app.queue_free()
	await process_frame
	print("%d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
