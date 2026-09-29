extends RefCounted
## Read-only, per-flight diagnostic. Identity links the actual launch to its
## native impact/expiry; no projectile dictionary or body is modified.
var launches: Array = []
var outcomes: Array = []
var tracks: Array = []
var active: Array = []
var sample_clock := -100

func observe_event(kind: String, data: Dictionary, space, cast: Array) -> void:
	if kind == "sound" and data.get("name", "") == "wpn_rocket_02":
		if space.projectiles.is_empty(): return
		var p: Dictionary = space.projectiles.back()
		if p.owner != space.player or p.weapon.kind != "missile": return
		var id := launches.size() + 1
		launches.append({"id": id, "clock": space.clock, "target": cast.find(p.target),
			"weapon": int(p.weapon.id), "life": p.life, "position": str(p.pos),
			"velocity": str(p.vel), "count_before": int(p.weapon.count)})
		active.append({"id": id, "projectile": p})
	elif kind in ["missile_impact", "missile_expired"]:
		var p: Dictionary = data.projectile
		if p.owner != space.player: return
		for index in range(active.size() - 1, -1, -1):
			if not is_same(active[index].projectile, p): continue
			var row := {"id": int(active[index].id), "clock": space.clock,
				"event": kind, "target": cast.find(p.target), "life": int(p.life),
				"position": str(p.pos), "velocity": str(p.vel),
				"target_gap": p.pos.distance_to(p.target.pos) if p.target != null else -1.0}
			if kind == "missile_impact":
				row.hit = cast.find(data.body)
				row.hit_kind = data.body.kind
				row.before = data.before.duplicate()
				row.after = data.after.duplicate()
			outcomes.append(row)
			active.remove_at(index)
			print("MISSILE RESOLVED ", JSON.stringify(row))
			break

func sample(space, cast: Array) -> void:
	if space.clock - sample_clock < 96: return
	sample_clock = space.clock
	for row in active:
		var p: Dictionary = row.projectile
		tracks.append({"id": int(row.id), "clock": space.clock, "life": int(p.life),
			"position": str(p.pos), "velocity": str(p.vel), "target": cast.find(p.target),
			"target_position": str(p.target.pos) if p.target != null else "",
			"target_emp": p.target.emp if p.target != null else -1,
			"target_disabled": p.target.disabled if p.target != null else false})

func report() -> Dictionary:
	return {"launches": launches, "outcomes": outcomes, "tracks": tracks,
		"unresolved": active.map(func(row): return int(row.id))}
