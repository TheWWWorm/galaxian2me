extends "res://tests/transit_pilot_check.gd"
## No-save geometry regression, not an earned campaign replay.
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
		space.station = Body.new()
		space.station.kind = Body.Kind.STATION
		space.player = Body.new()
		space.player.kind = Body.Kind.PLAYER
		space.bodies = [space.player, space.station]
		space._station_boxes(27, int(app.catalogue.system(5).faction))
		check(space.station_boxes.size() > 1, "supplied B'akka station has multiple native module boxes")
		var pilot := Pilot.new()
		var desired := Vector3(-105233.4, 11554.12, -78218.38)
		space.player.pos = Vector3(61311.49, 22710.24, -38619.84)
		check(pilot.safe_point(space, desired, false) == desired,
			"source-sized B'akka geometry does not obstruct the formerly oversized recorded lane")
		# Retain the old adversarial overlap test as an EXPLICIT synthetic
		# stress volume. Production station dimensions are not enlarged.
		for box in space.station_boxes: box.half *= 2.0
		var previous := Vector3.ZERO
		var highest := -INF
		for box in space.station_boxes:
			for x in [-1, 1]:
				for y in [-1, 1]:
					for z in [-1, 1]:
						var corner: Vector3 = box.origin + box.basis * (box.centre + (box.half + Vector3.ONE * 8000.0) * Vector3(x, y, z))
						highest = maxf(highest, corner.y)
		var consistent := true
		var unchanged := true
		var legs_clear := true
		for height in [22710.24, 32710.24, 36710.24, 40710.24, 44710.24, 50710.24, 60710.24]:
			# Historical pose with declared enlarged stress geometry: lower
			# and upper modules must not request opposite vertical turns.
			space.player.pos = Vector3(61311.49, height, -38619.84)
			var before := world_state(space)
			var at := pilot.safe_point(space, desired, false)
			var direction := space.player.pos.direction_to(at)
			consistent = consistent and direction.y > 0.9 and (previous.is_zero_approx() or direction.dot(previous) > 0.9)
			previous = direction
			unchanged = unchanged and before == world_state(space)
			for box in space.station_boxes:
				var start: Vector3 = box.basis.inverse() * (space.player.pos - box.origin) - box.centre
				var end: Vector3 = box.basis.inverse() * (at - box.origin) - box.centre
				var half: Vector3 = box.half + Vector3.ONE * 8000.0
				legs_clear = legs_clear and not AABB(-half, half * 2.0).intersects_segment(start, end)
			if height == 22710.24:
				check(at.y >= highest + 11999.0, "initial bypass clears the whole station, not just the first intersected module")
		check(consistent, "overlapping station modules cannot reverse the requested bypass as the player climbs")
		check(legs_clear, "each proposed vertical flight leg clears every expanded synthetic stress module")
		check(unchanged, "station detour decisions preserve bodies, session, target and RNG")
		space.player.pos = Vector3(61311.49, 22710.24, -38619.84)
		var controls := pilot.steer(space, desired, true, false)
		check(pilot.avoided and not controls.boost, "station clearance remains an ordinary unboosted steering detour")
		check(pilot.safe_point(space, desired, true) == desired, "explicit station docking still permits the intended approach")
		space.player.pos = Vector3(61311.49, highest + 30000.0, -38619.84)
		check(pilot.safe_point(space, desired, false) == desired, "cleared station geometry releases the direct course")
		check(app.save_attempts.is_empty(), "station bypass fixture creates no player or earned saves")
		space.dispose()
	app.queue_free()
	await process_frame
	print("%d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
