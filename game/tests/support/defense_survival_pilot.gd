extends "res://tests/support/combat_pilot.gd"
## Read-only area-EMP policy. Predictions use current headings, not future
## RNG or live simulation steps. Actual firing, impacts and losses are native.
## Reachable envelopes conservatively protect nearby friendly/neutral ships.
var secondary_requests: Array = []
var last_request := -10000

func retreat_required(space) -> bool:
	return space.player.hull <= maxi(1, int(space.player.hull_max * 0.7)) \
		and space.player.shield < space.player.shield_max * 0.25

func input(space, candidates: Array) -> Dictionary:
	var result: Dictionary = super.input(space, candidates)
	if result.is_empty() or not space.player.alive: return result
	var bomb := ready_bomb(space)
	if bomb.is_empty() or space.clock - last_request < 1000: return result
	var enemy: Body
	for body in candidates:
		if not active_threat(body): continue
		var gap: float = body.pos.distance_to(space.player.pos)
		if gap < 24000.0 or gap > 80000.0: continue
		if enemy == null or gap < enemy.pos.distance_to(space.player.pos): enemy = body
	if enemy == null: return result
	var aim := intercept(space, enemy, bomb)
	if aim.is_zero_approx(): return result
	var direction: Vector3 = space.player.pos.direction_to(aim)
	var proposed := forecast(space, bomb, direction)
	if not safe_useful(space, bomb, proposed, candidates): return result
	desired = aim; mode = "emp_aim"
	result = navigation.steer(space, aim, false, false)
	result.fire = navigation.clear_primary(space, enemy.pos.distance_to(space.player.pos)) and friendly_corridor_clear(space)
	if direction.dot(space.player.forward()) < 0.998 or navigation.avoided: return result
	var actual := forecast(space, bomb, space.player.forward())
	if safe_useful(space, bomb, actual, candidates):
		result.secondary = true
		last_request = space.clock
		secondary_requests.append({"clock": space.clock, "item": bomb.id, "ammo_before": bomb.count,
			"predicted_ms": actual.ms, "predicted_blast": str(actual.position), "target": enemy.get_instance_id()})
	return result

func ready_bomb(space) -> Dictionary:
	for projectile in space.projectiles:
		if projectile.owner == space.player and projectile.weapon.kind == "emp": return {}
	# Match native secondary selection order; never request a different ready
	# launcher merely because an EMP exists later in the equipment array.
	for weapon in space.player.weapons:
		if weapon.kind in ["gun", "turret"] or int(weapon.cooldown) != 0 or int(weapon.count) <= 0: continue
		return weapon if weapon.kind == "emp" else {}
	return {}

func active_threat(body: Body) -> bool:
	return body.alive and body.visible and body.combat_active and body.is_ship() \
		and body.hostile and not body.friendly and not body.disabled and not body.weapons.is_empty()

func intercept(space, enemy: Body, weapon: Dictionary) -> Vector3:
	var speed: float = float(weapon.speed) + space.player.speed
	var relative: Vector3 = enemy.pos - space.player.pos
	var velocity: Vector3 = enemy.forward() * enemy.speed
	var a: float = velocity.length_squared() - speed * speed
	var b: float = 2.0 * relative.dot(velocity)
	var c: float = relative.length_squared()
	var determinant: float = b * b - 4.0 * a * c
	if determinant < 0.0 or absf(a) < 0.001: return Vector3.ZERO
	var t: float = (-b - sqrt(determinant)) / (2.0 * a)
	if t <= 0.0 or t > float(weapon.life): return Vector3.ZERO
	return enemy.pos + velocity * t

func forecast(space, weapon: Dictionary, direction: Vector3) -> Dictionary:
	var position: Vector3 = space.player.pos + Body.facing(direction) * weapon.get("offset", Vector3.ZERO) + direction * 400.0
	var velocity: Vector3 = direction * (float(weapon.speed) + space.player.speed)
	var elapsed := 0
	while elapsed < int(weapon.life):
		var ms := mini(16, int(weapon.life) - elapsed)
		elapsed += ms
		var step: Vector3 = velocity * ms
		var hit := false
		for body in space.bodies:
			if body == space.player or not body.alive or not body.solid or body.kind in [Body.Kind.STAR, Body.Kind.ARRIVAL]: continue
			if body.kind == Body.Kind.STATION:
				if space._inside_station(position + step): hit = true
				continue
			if body.kind == Body.Kind.MOTHERSHIP:
				if space._inside_mothership(position + step): hit = true
				continue
			var predicted: Vector3 = body.pos
			if body.is_ship() and not body.disabled: predicted += body.forward() * body.speed * elapsed
			var relative: Vector3 = predicted - position
			var t: float = clampf(relative.dot(step) / maxf(1.0, step.length_squared()), 0.0, 1.0)
			var distance: Vector3 = position + step * t - predicted
			if distance.abs().max_axis_index() >= 0 and maxf(absf(distance.x), maxf(absf(distance.y), absf(distance.z))) < body.radius:
				hit = true
		position += step
		if hit: break
	return {"position": position, "ms": elapsed}

func safe_useful(space, weapon: Dictionary, prediction: Dictionary, candidates: Array) -> bool:
	var at: Vector3 = prediction.position
	var time: float = prediction.ms
	var radius: float = float(weapon.blast)
	if radius <= 0.0 or int(weapon.emp) <= 0: return false
	var stats: Dictionary = space.game.session.ship_stats()
	var maximum_player_speed: float = maxf(space.player.speed, 2.0 + float(stats.boost_speed) / 100.0 * 2.0)
	if space.player.pos.distance_to(at) <= radius + maximum_player_speed * time + 1500.0: return false
	for body in space.bodies:
		if body == space.player or not body.alive or not body.is_ship(): continue
		if body.friendly or not body.hostile:
			if body.pos.distance_to(at) <= radius + body.speed * time + 1500.0: return false
	for body in candidates:
		if not active_threat(body) or body.emp_max <= 0: continue
		var predicted: Vector3 = body.pos + body.forward() * body.speed * time
		var force: int = int(float(weapon.emp) * clampf(1.0 - predicted.distance_to(at) / radius, 0.0, 1.0))
		if force >= maxi(1, body.emp): return true
	return false
