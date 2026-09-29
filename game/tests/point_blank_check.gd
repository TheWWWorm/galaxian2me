extends SceneTree
## Synthetic shooting fixtures: no content, campaign or player saves.
const Space := preload("res://src/flight/space.gd")
const Body := preload("res://src/flight/body.gd")
var failures := 0
var checks := 0

func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)

func _init() -> void:
	var space := Space.new({"cat": null, "library": null, "destination": {}})
	space.player = Body.new()
	space.player.kind = Body.Kind.PLAYER
	var rock := Body.new()
	rock.kind = Body.Kind.ASTEROID
	rock.radius = 150.0
	rock.pos = Vector3(0, 0, 300)
	space.bodies = [space.player, rock]
	# A laser round leaves 800 units ahead of its mount; a rock closer than
	# that is still hit, not shot through.
	var w := {"kind": "gun", "type": 1, "offset": Vector3.ZERO, "speed": 16.0, "life": 3000, "reload": 200, "damage": 1.0}
	var p := {"pos": Vector3(0, 0, 800), "muzzle": Vector3(0, 0, 800), "from": Vector3.ZERO,
		"vel": Vector3(0, 0, 16), "life": 3000, "owner": space.player, "weapon": w}
	var start: Vector3 = p["from"]
	var to: Vector3 = p.pos + p.vel * 16
	p.pos = start
	check(space._sweep(p, to - start) == rock, "the first step is swept from the mount")
	check(absf((p.hit_at as Vector3).z - 300.0) < 1.0, "the hit lands where the line passes the rock")
	# A wide hit box registers short of the hull; the spent round flies on
	# and bursts at the hull.
	rock.radius = 2000.0
	rock.pos = Vector3(0, 0, 2500)
	var q := {"pos": Vector3(0, 0, 800), "muzzle": Vector3(0, 0, 800), "vel": Vector3(0, 0, 16), "owner": space.player, "weapon": w}
	check(space._sweep(q, q.vel * 16) == rock, "the hit box registers the round early")
	q.pos += q.vel * 16
	space.spent.append({"pos": q.pos, "vel": q.vel, "muzzle": q.muzzle, "weapon": w, "hit_at": q.hit_at})
	var frames := 0
	while not space.spent.is_empty() and frames < 400:
		space._projectiles_step(0.016, 16)
		frames += 1
	var sparks := space.effects.filter(func(e): return e.kind == "spark")
	check(sparks.size() == 1 and absf((sparks[0].pos as Vector3).z - 2500.0) < 1.0, "the spent round bursts at the hull")
	space.dispose()
	print("POINT BLANK: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
