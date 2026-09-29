extends RefCounted
## Native disabled-ship tractor. The equipment table supplies charge time;
## the source radar delays its ring by 500 ms, then pulls a detached crate
## at ten original units/ms and captures only within 400 units. Navigation
## locks and scanner locks are not authorization to grant an inventory item.
##
## Wreck crates (loot bodies) are the beam's other work. The original's radar
## hands a crate over at once when the model is automatic, or after it has
## sat under the crosshair for the beam's charge time; the crate then flies
## in at the same speed. Without a beam, aiming at a crate only reports that
## none is fitted: crates are never collected by flying into them.
const Body := preload("res://src/flight/body.gd")
const Catalogue := preload("res://src/content/catalogue.gd")
const RING_DELAY := 500
const PULL_SPEED := 10.0
const CAPTURE_DISTANCE := 400.0

var candidate: Body
var source: Body
var position := Vector3.ZERO
var elapsed_ms := 0
var required_ms := 0
var equipment_id := -1
var initial_distance := 0.0
var remaining_distance := 0.0
var _payload: Array = []
var _settling := false

## Crates within this box distance can be taken; an automatic beam takes one
## anywhere in the forward view, a manual beam the one under the crosshair.
const CRATE_REACH := 30000.0
const CRATE_VIEW := 0.8
const CRATE_AIM := 0.985
var crate: Body
var crate_pulling := false
var crate_ms := 0
var crate_required := 0
var crate_start := 0.0
var crate_remaining := 0.0
var crate_equipment := -1
var _warned: Body

func reset_crate() -> void:
	crate = null
	crate_pulling = false
	crate_ms = 0
	crate_required = 0
	crate_start = 0.0
	crate_remaining = 0.0
	crate_equipment = -1

func reset() -> void:
	candidate = null
	source = null
	position = Vector3.ZERO
	elapsed_ms = 0
	required_ms = 0
	equipment_id = -1
	initial_distance = 0.0
	remaining_distance = 0.0
	_payload.clear()
	_settling = false

func _live_body(space, body: Body) -> bool:
	return body != null and body != space.player and body.is_ship() and body.alive and body.visible \
		and space.bodies.has(body) and body.cargo.size() >= 2 and int(body.cargo[1]) > 0

func step(space, ms: int) -> void:
	if space.game == null or space.player == null or space.navigation_locked():
		reset()
		reset_crate()
		return
	var gear: Dictionary = space.game.session.equipped_of_type(Catalogue.Type.TRACTOR_BEAM)
	if gear.is_empty():
		reset()
		reset_crate()
		var aimed := _aimed_crate(space, CRATE_AIM)
		if aimed != null and aimed != _warned and not space.autopilot:
			space.event.emit("message", {"text": space.lib.text(264)})
		_warned = aimed
		return
	if crate_pulling:
		_crate_step(space, gear, ms)
		return
	if source != null:
		# Once the crate is detached it keeps moving, even if the pilot looks
		# away or the carrier recovers from EMP. Its actor/cargo must still
		# exist; destroying the entrusted carrier is not a successful rescue.
		if not _live_body(space, source) or source.cargo != _payload or int(gear.id) != equipment_id:
			reset()
			return
		remaining_distance = position.distance_to(space.player.pos)
		if remaining_distance <= CAPTURE_DISTANCE:
			var body := source
			var item := int(_payload[0])
			var before: int = space.game.session.cargo_count(item)
			_settling = true
			space._loot(body)
			_settling = false
			space.event.emit("tractor_finished", {"body": body, "item": item,
				"count": space.game.session.cargo_count(item) - before, "distance": remaining_distance})
			reset()
			return
		var advance := minf(PULL_SPEED * maxi(ms, 0), remaining_distance - CAPTURE_DISTANCE)
		position = position.move_toward(space.player.pos, advance)
		remaining_distance = position.distance_to(space.player.pos)
		return
	var body: Body = space.target
	# Keep native close-range reach explicit; do not use a sticky target or
	# a TAB selection to accumulate charge while looking somewhere else.
	if space.autopilot or not _live_body(space, body) or not body.disabled \
		or space.player.pos.distance_to(body.pos) >= 3000.0 + space._tractor_reach() \
		or space._aimed_body() != body:
		reset()
		_crate_step(space, gear, ms)
		return
	reset_crate()
	if candidate != body or equipment_id != int(gear.id):
		reset()
		candidate = body
		equipment_id = int(gear.id)
		required_ms = maxi(0, space.cat.attr(equipment_id, Catalogue.A_TRACTOR_SPEED))
	elapsed_ms += maxi(0, ms)
	# Even the automatic model charges against a living disabled ship.
	# Its automatic shortcut in the original radar applies to wreck cargo.
	if elapsed_ms > required_ms:
		source = candidate
		position = source.pos
		_payload = source.cargo.duplicate()
		initial_distance = position.distance_to(space.player.pos)
		remaining_distance = initial_distance
		space.event.emit("tractor_started", {"body": source, "equipment": equipment_id,
			"elapsed_ms": elapsed_ms, "required_ms": required_ms, "distance": initial_distance})

func _crate_ok(space, b: Body) -> bool:
	return b != null and b.kind == Body.Kind.LOOT and b.alive and b.visible and space.bodies.has(b) and b.cargo.size() >= 2

func _aimed_crate(space, threshold: float) -> Body:
	var best: Body = null
	var best_dot := threshold
	var fwd: Vector3 = space.player.forward()
	for b in space.bodies:
		if b.kind != Body.Kind.LOOT or not b.alive or not b.visible: continue
		var to: Vector3 = b.pos - space.player.pos
		var gap := to.length()
		if gap < 1.0 or maxf(absf(to.x), maxf(absf(to.y), absf(to.z))) > CRATE_REACH: continue
		var d := fwd.dot(to / gap)
		if d > best_dot:
			best_dot = d
			best = b
	return best

func _crate_step(space, gear: Dictionary, ms: int) -> void:
	if crate_pulling:
		if not _crate_ok(space, crate) or int(gear.id) != crate_equipment:
			reset_crate()
			return
		var gap: float = crate.pos.distance_to(space.player.pos)
		if gap <= CAPTURE_DISTANCE:
			var box := crate
			reset_crate()
			space._capture_crate(box)
			return
		crate.pos = crate.pos.move_toward(space.player.pos, minf(PULL_SPEED * maxi(ms, 0), gap - CAPTURE_DISTANCE))
		crate_remaining = crate.pos.distance_to(space.player.pos)
		return
	var automatic: bool = space.cat.attr(int(gear.id), Catalogue.A_TRACTOR_AUTO) == 1
	var aimed := _aimed_crate(space, CRATE_VIEW if automatic else CRATE_AIM) if not space.autopilot else null
	if aimed == null:
		reset_crate()
		return
	if aimed != crate or int(gear.id) != crate_equipment:
		reset_crate()
		crate = aimed
		crate_equipment = int(gear.id)
		crate_required = 0 if automatic else maxi(0, space.cat.attr(crate_equipment, Catalogue.A_TRACTOR_SPEED))
	crate_ms += maxi(0, ms)
	if crate_ms > crate_required:
		crate_pulling = true
		crate_start = crate.pos.distance_to(space.player.pos)
		crate_remaining = crate_start

func authorizes(space, body: Body) -> bool:
	return _settling and source == body and _live_body(space, body) and body.cargo == _payload \
		and not space.navigation_locked() and position.distance_to(space.player.pos) <= CAPTURE_DISTANCE

## Detached HUD observation; neither the cargo contents nor writable state
## are exposed before the cargo scanner has actually identified a carrier.
func status() -> Dictionary:
	if crate != null:
		var pull_progress := 0.0
		if crate_pulling:
			pull_progress = 1.0 - maxf(0.0, crate_remaining - CAPTURE_DISTANCE) / maxf(1.0, crate_start - CAPTURE_DISTANCE)
		var charge := float(crate_ms - RING_DELAY) / maxi(1, crate_required - RING_DELAY)
		return {"phase": "pulling" if crate_pulling else "charging", "elapsed_ms": crate_ms,
			"required_ms": crate_required, "equipment": crate_equipment,
			"progress": clampf(pull_progress if crate_pulling else charge, 0.0, 1.0)}
	if candidate == null: return {}
	var pulling := source != null
	var progress := (1.0 - maxf(0.0, remaining_distance - CAPTURE_DISTANCE) / maxf(1.0, initial_distance - CAPTURE_DISTANCE)) \
		if pulling else float(elapsed_ms - RING_DELAY) / maxi(1, required_ms - RING_DELAY)
	return {"phase": "pulling" if pulling else "charging", "elapsed_ms": elapsed_ms,
		"required_ms": required_ms, "equipment": equipment_id, "progress": clampf(progress, 0.0, 1.0)}
