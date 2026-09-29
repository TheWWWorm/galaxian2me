extends RefCounted
## Read-only observer for flights without trading/jettisoning. Inventory
## gains must match consumed physical payloads AND native salvage statistics.
const Body := preload("res://src/flight/body.gd")
var previous := {}
var payloads: Array = []
var totals := {}
var events: Array = []
var errors: Array = []

func begin_world(space) -> void:
	previous = space.game.session.to_dict().duplicate(true)
	remember_payloads(space)

func remember_payloads(space) -> void:
	payloads.clear()
	for body in space.bodies:
		if not body.alive or body.cargo.size() < 2: continue
		if body.kind != Body.Kind.LOOT and not (body.is_ship() and (body.disabled or space.tractor.source == body)): continue
		payloads.append({"body": body, "item": int(body.cargo[0]), "count": int(body.cargo[1])})

func observe(space) -> void:
	# Space retires before the synchronous station listener settles deliveries.
	# That terminal step returns before collisions or pickups. The station's
	# inventory changes no longer belong to this flight; active gains and
	# losses must still reconcile with real payloads below.
	if space.completed_flight: return
	if previous.is_empty():
		begin_world(space)
		return
	var current: Dictionary = space.game.session.to_dict()
	var gains := {}
	for key in previous.cargo:
		if int(current.cargo.get(key, 0)) < int(previous.cargo[key]): errors.append("original cargo decreased: " + str(key))
	for key in current.cargo:
		var change := int(current.cargo[key]) - int(previous.cargo.get(key, 0))
		if change > 0: gains[str(key)] = change
	var removed := {}
	for row in payloads:
		var body: Body = row.body
		var left: int = int(body.cargo[1]) if body.cargo.size() >= 2 and int(body.cargo[0]) == row.item else 0
		var count: int = int(row.count) - left
		if count <= 0: continue
		if space.tractor.source == body:
			# The ship stays behind; collection occurs at the detached crate.
			# Observe the real settlement event, not the old carrier distance.
			if space.tractor.position.distance_to(space.player.pos) > space.tractor.CAPTURE_DISTANCE:
				errors.append("tractor payload consumed before physical arrival")
		else:
			var reach: float = space.PLAYER_RADIUS + space.LOOT_RADIUS + space._tractor_reach() if body.kind == Body.Kind.LOOT else 3000.0 + space._tractor_reach()
			if body.pos.distance_to(space.player.pos) >= reach:
				errors.append("payload consumed beyond native pickup reach")
		var key := str(row.item)
		removed[key] = int(removed.get(key, 0)) + count
	var salvaged := int(current.stats.get("cargo_salvaged", 0)) - int(previous.stats.get("cargo_salvaged", 0))
	var count := 0
	for value in gains.values(): count += int(value)
	if gains != removed or count != salvaged: errors.append("inventory/payload/salvage mismatch")
	if not gains.is_empty():
		events.append({"clock": space.clock, "items": gains.duplicate(), "consumed": removed, "salvaged": salvaged})
		for key in gains: totals[key] = int(totals.get(key, 0)) + int(gains[key])
	previous = current.duplicate(true)
	remember_payloads(space)

func reconciles(before: Dictionary, after: Dictionary, capacity: int) -> bool:
	if not errors.is_empty(): return false
	var expected: Dictionary = before.cargo.duplicate(true)
	var gained := 0
	for key in totals:
		expected[key] = int(expected.get(key, 0)) + int(totals[key])
		gained += int(totals[key])
	var used := 0
	for count in after.cargo.values(): used += int(count)
	return expected == after.cargo and used <= capacity and gained == int(after.stats.get("cargo_salvaged", 0)) - int(before.stats.get("cargo_salvaged", 0))
