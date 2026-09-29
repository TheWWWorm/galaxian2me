extends SceneTree
## Small synthetic targeting fixtures: no content, campaign or player saves.
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
	space.station = Body.new()
	space.station.kind = Body.Kind.STATION
	space.station.pos = Vector3(1000, 0, 50000)
	var rock := Body.new()
	rock.kind = Body.Kind.ASTEROID
	rock.pos = Vector3(0, 0, 20000)
	var gate := Body.new()
	gate.kind = Body.Kind.GATE
	gate.pos = Vector3(20000, 0, 50000)
	space.bodies = [space.player, space.station, rock, gate]
	space.target = space.station
	space.locked = true
	space.autopilot = true
	space._targeting(16, {})
	check(space.target == space.station, "an intervening asteroid cannot redirect locked station autopilot")
	space.target = space.station
	space._targeting(16, {"next_target": true})
	check(space.target == gate, "explicit target cycling is not overwritten by crosshair selection in the same frame")
	space._targeting(16, {})
	check(space.target == gate, "new navigation target stays selected while autopilot is active")
	space.autopilot = false
	space._targeting(16, {})
	check(space.target == space.station, "the station near the crosshair is scanned ahead of an asteroid in front of it")
	space.station.pos = Vector3(-20000, 0, 50000)
	space._targeting(16, {})
	check(space.target == rock, "manual flight still acquires the object under the crosshair")
	space.locked = true
	space.station.pos = Vector3(1000, 0, 50000)
	space._targeting(16, {})
	check(space.target == rock, "a locked asteroid still under the crosshair is kept")
	rock.pos = Vector3(0, 20000, 20000)
	space._targeting(16, {})
	check(space.target == space.station, "once the crosshair leaves it, the distant station can be locked")
	rock.pos = Vector3(0, 0, 20000)
	space.target = rock
	space.locked = true
	space.autopilot = true
	rock.alive = false
	space._targeting(16, {})
	check(not space.autopilot, "a destroyed target disengages autopilot rather than silently following another body")
	# A ship passing near the station: the station held squarely under the
	# crosshair wins; aimed at more squarely, the ship does.
	rock.alive = true
	rock.pos = Vector3(0, 30000, 20000)
	space.autopilot = false
	space.locked = false
	space.station.pos = Vector3(0, 0, 50000)
	var passer := Body.new()
	passer.kind = Body.Kind.SHIP
	passer.pos = Vector3(4000, 0, 40000)
	space.bodies.append(passer)
	check(space._aimed_body() == space.station, "a station held under the crosshair wins over a ship passing near it")
	passer.pos = Vector3(0, 0, 40000)
	space.station.pos = Vector3(1500, 0, 50000)
	check(space._aimed_body() == passer, "a ship aimed at more squarely still comes first")
	# Clicks on a rock the guns are hitting keep shooting it.
	rock.ai["shot_at"] = space.clock
	check(space._being_shot(rock), "a rock just hit by the player's guns is being shot")
	space.clock += space.SHOOTING_GRACE + 1
	check(not space._being_shot(rock), "a while later a click on it mines again")
	# Double speed at any time; faster only on the autopilot.
	space.autopilot = false
	check(space.time_warp_allowed(2) and not space.time_warp_allowed(4), "double speed without the autopilot, no faster")
	space.dispose()
	print("NAVIGATION LOCK: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
