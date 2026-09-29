extends RefCounted
## Read-only input-policy safety. Native weapons, damage and AI are untouched.
## Inspect each fitted gun's real muzzle and entire projectile lifetime.

static func clear_at(space, position: Vector3, orientation: Basis, protect_neutral := false) -> bool:
	for body in space.bodies:
		if body == space.player or not body.alive or not body.is_ship(): continue
		if not body.friendly and not (protect_neutral and not body.hostile): continue
		for weapon in space.player.weapons:
			if weapon.kind != "gun": continue
			var origin: Vector3 = position + orientation * weapon.get("offset", Vector3.ZERO) + orientation.z * 400.0
			var velocity: Vector3 = orientation.z * (float(weapon.speed) + space.player.speed)
			var relative: Vector3 = body.pos - origin
			# Held zero-speed ships use the native axis-aligned body box,
			# expanded only for the next tick's player movement/steering.
			if body.ai.get("mode", "") == "hold" and is_zero_approx(body.speed):
				var half: Vector3 = Vector3.ONE * (body.radius + 1200.0)
				if AABB(body.pos - half, half * 2.0).intersects_segment(origin, origin + velocity * float(weapon.life)) != null:
					return false
				continue
			# Moving traffic may turn while the projectile is still alive.
			# Bound reachable positions rather than extrapolating one heading.
			var radius: float = body.radius * sqrt(3.0) + 1200.0
			var pace: float = body.speed
			var time := clampf((relative.dot(velocity) + radius * pace)
				/ maxf(1.0, velocity.length_squared() - pace * pace), 0.0, float(weapon.life))
			if (relative - velocity * time).length() <= radius + pace * time: return false
	return true
