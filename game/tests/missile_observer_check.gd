extends "res://tests/transit_pilot_check.gd"
## Synthetic no-save native projectile checks, never earned campaign proof.
const Observer := preload("res://tests/support/missile_observer.gd")

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
		var intended := Body.new()
		intended.pos = Vector3(0, 0, 8000)
		intended.hull = 164
		intended.emp = 40
		intended.emp_max = 40
		var intervening := Body.new()
		intervening.pos = Vector3(0, 0, 4000)
		intervening.hull = 164
		intervening.emp = 40
		intervening.emp_max = 40
		space.bodies = [space.player, intended, intervening]
		space.target = intended
		var w := space.weapon(35)
		w.count = 7
		space.player.weapons = [w]
		var observer := Observer.new()
		var cast := [space.player, intended, intervening]
		var listener := func(kind, data): observer.observe_event(kind, data, space, cast)
		space.event.connect(listener)
		space._player_weapons_step(0, {"secondary": true})
		check(observer.launches.size() == 1 and observer.outcomes.is_empty() and not intended.disabled,
			"native launch alone does not assert any impact or disable")
		var before := world_state(space)
		observer.sample(space, cast)
		check(world_state(space) == before, "projectile observation leaves world, resources and RNG untouched")
		for i in 50:
			space.clock += 16
			space._projectiles_step(0.016, 16)
			observer.sample(space, cast)
		check(observer.outcomes.size() == 1, "one resolved missile produces exactly one actual terminal observation")
		if observer.outcomes.size() == 1:
			var hit: Dictionary = observer.outcomes[0]
			check(hit.event == "missile_impact" and hit.target == 1 and hit.hit == 2,
				"native sweep reports the intervening pirate rather than falsely claiming the selected target")
			check(hit.before.emp == 40 and hit.after.emp == intervening.emp and hit.after.disabled == intervening.disabled,
				"impact evidence records the actual before and after EMP state")
		check(not intended.disabled and intended.emp == 40 and intervening.disabled,
			"only the actually hit pirate is disabled by the unchanged native weapon")
		space.target = null
		space.player.basis = Body.facing(Vector3.RIGHT)
		space._player_weapons_step(int(w.reload), {"secondary": true})
		for i in 100:
			space.clock += 16
			space._projectiles_step(0.016, 16)
			observer.sample(space, cast)
		check(observer.outcomes.size() == 2 and observer.outcomes.back().event == "missile_expired"
			and observer.outcomes.back().life <= 0 and not observer.outcomes.back().has("hit"),
			"a naturally expired missile is never counted as an impact")
		check(observer.active.is_empty() and w.count == 5 and space.shots_fired == 2,
			"both finite launches resolve without duplicate events, ammunition refill or leaked tracking")
		check(app.save_attempts.is_empty(), "synthetic missile checks create no earned save")
		space.event.disconnect(listener)
		space.dispose()
	app.queue_free()
	await process_frame
	print("%d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
