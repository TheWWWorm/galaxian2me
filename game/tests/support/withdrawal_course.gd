extends RefCounted
## Read-only, rotation-stable escape selection shared by ordinary-input pilots.
const Body := preload("res://src/flight/body.gd")

static func choose(space, nearest: Body, previous: Vector3, viable := Callable()) -> Vector3:
	var origin: Vector3 = space.player.pos
	var threats: Array = []
	var closest: Body = nearest
	for b in space.bodies:
		if b == space.player or not b.is_ship() or not b.alive or not b.visible or not b.hostile or b.disabled: continue
		if b.pos.distance_to(origin) >= 60000.0: continue
		threats.append(b)
		if closest == null or b.pos.distance_to(origin) < closest.pos.distance_to(origin): closest = b
	if closest == null: return Vector3.ZERO
	var away: Vector3 = closest.pos.direction_to(origin)
	# Transport the previous transverse frame; world-UP would introduce a
	# pole that can rotate the requested course faster than native handling.
	var tangent: Vector3 = previous if not previous.is_zero_approx() else space.player.forward()
	var side: Vector3 = tangent - away * tangent.dot(away)
	if side.length_squared() < 0.01:
		side = space.player.basis.x - away * space.player.basis.x.dot(away)
	if side.length_squared() < 0.01:
		side = space.player.up() - away * space.player.up().dot(away)
	side = side.normalized()
	var up := side.cross(away).normalized()
	var options: Array = []
	if not previous.is_zero_approx(): options.append(previous)
	for outward in [0.35, 0.65]:
		for angle in 12:
			var phase := TAU * float(angle) / 12.0
			options.append((away * outward + (side * cos(phase) + up * sin(phase)) * sqrt(1.0 - outward * outward)).normalized())
	var best := -INF
	var chosen := Vector3.ZERO if viable.is_valid() else away
	for direction in options:
		if viable.is_valid() and not viable.call(direction): continue
		var clearance := 1.0
		var approach := 0.0
		for b in threats:
			var line: Vector3 = b.pos.direction_to(origin)
			clearance = minf(clearance, direction.cross(line).length())
			approach = minf(approach, direction.dot(line))
		var score: float = clearance + approach * 2.0 + direction.dot(away) * 0.12
		if not previous.is_zero_approx(): score += direction.dot(previous) * 0.18
		else: score += direction.dot(side) * 0.02
		if origin.length() > 360000.0: score -= maxf(0.0, direction.dot(origin.normalized())) * 4.0
		if score > best:
			best = score
			chosen = direction
	return chosen
