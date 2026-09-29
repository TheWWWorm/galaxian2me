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
	var space := Space.new({"cat": null, "library": null})
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
	check(space.target == rock, "manual flight still acquires the object under the crosshair")
	space.autopilot = true
	rock.alive = false
	space._targeting(16, {})
	check(not space.autopilot, "a destroyed target disengages autopilot rather than silently following another body")
	space.dispose()
	print("NAVIGATION LOCK: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
