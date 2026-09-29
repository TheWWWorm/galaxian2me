extends RefCounted
## Read-only recovery pilot: ordinary steering and finite secondary fire.
## It never inspects a ship's cargo, mission-cast index, private crate flag,
## seed or future stock. Identification comes from the actual scanner HUD.
const Transit := preload("res://tests/support/transit_pilot.gd")
const Wingmen := preload("res://src/flight/wingmen.gd")
var steering := Transit.new()
var selected: WeakRef
var identified: WeakRef
var scanned := {}
var scan_target: WeakRef
var scan_started := -1
var last_bomb := -10000
var mode := "approach"
var scans := []
var secondary_requests := []

func input(space) -> Dictionary:
	if space.navigation_locked(): return {}
	var target = identified.get_ref() if identified != null else null
	if target == null and selected != null: target = selected.get_ref()
	if target == null or not target.alive or not target.visible or (identified == null and scanned.has(target.get_instance_id())):
		target = null
		for body in space.hostiles():
			if not body.visible or scanned.has(body.get_instance_id()): continue
			if target == null or body.pos.distance_to(space.player.pos) < target.pos.distance_to(space.player.pos): target = body
		selected = weakref(target) if target != null else null
	if target == null:
		mode = "mission_waypoint"
		var waypoint = Wingmen.mission_waypoint(space)
		return steering.steer(space, waypoint, false, false) if waypoint != null else {}
	var gap: float = target.pos.distance_to(space.player.pos)
	var to: Vector3 = (target.pos - space.player.pos).normalized()
	var aim: bool = space.target == target and space.player.forward().dot(to) > 0.985
	if aim:
		if scan_target == null or scan_target.get_ref() != target:
			scan_target = weakref(target); scan_started = space.clock
		# Do not exploit TAB's sticky navigation lock to skip scanner time.
		if space.clock - scan_started >= int(space.lock_needed):
			var readout: Dictionary = space.scanned_cargo()
			if not readout.is_empty() and not scanned.has(target.get_instance_id()):
				scanned[target.get_instance_id()] = readout.duplicate()
				scans.append({"clock": space.clock, "name": target.name, "body": target.get_instance_id(),
					"hud": readout.duplicate(), "aimed_ms": space.clock - scan_started, "distance": gap})
				print("RECOVERY REAL SCANNER ", JSON.stringify(scans.back()))
				if int(readout.item) == int(space.game.session.job.get("item", -1)) and int(readout.count) > 0:
					identified = weakref(target)
	else:
		scan_target = null; scan_started = -1
	mode = "identified_carrier" if identified != null else "scan_visible_ship"
	var result: Dictionary = steering.steer(space, target.pos, false, false)
	# Never fire hull-damaging guns into an unscanned recovery group.
	result.fire = false
	if not target.disabled and gap < 12500.0 and space.player.forward().dot(to) > 0.9 and space.clock - last_bomb >= 4000:
		for weapon in space.player.weapons:
			if weapon.kind == "emp" and int(weapon.count) > 0 and int(weapon.cooldown) == 0:
				result.secondary = true
				last_bomb = space.clock
				secondary_requests.append({"clock": space.clock, "name": target.name, "distance": gap, "ammo_before": weapon.count})
				break
	return result
