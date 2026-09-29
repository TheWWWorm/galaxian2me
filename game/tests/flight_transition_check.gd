extends SceneTree
## Synthetic lifecycle probe, no content, saves or earned progression.
## Real Space._fly_player finishes a transition; spies expose forbidden work.
const Space := preload("res://src/flight/space.gd")
const Body := preload("res://src/flight/body.gd")
class SessionProbe extends RefCounted:
	var system_index := 19
	var stats := {}
	var flags := {} # Real sessions expose contract state, even with no crew.
	func ship_stats() -> Dictionary: return {"handling": 1, "steering": 0}
	func add_stat(key: String) -> void: stats[key] = int(stats.get(key, 0)) + 1
class GameProbe extends RefCounted:
	var cat = null
	var library = null
	var session := SessionProbe.new()
class Probe extends Space:
	var phases: Array = []
	var emitted := false
	var events: Array = []
	var late_reward := 0
	func _step_portal_arrival(_ms: int) -> void: pass
	func _step_wormhole(_ms: int) -> void: pass
	func _fly_player(delta: float, ms: int, input: Dictionary) -> void:
		if not emitted: super._fly_player(delta, ms, input)
	func _store_ship_state() -> void: pass
	func _player_weapons_step(_ms: int, _input: Dictionary) -> void: phases.append("weapons")
	func _targeting(_ms: int, _input: Dictionary) -> void: phases.append("targeting")
	func _regenerate(_ms: int) -> void: phases.append("regenerate")
	func _projectiles_step(_delta: float, _ms: int) -> void: phases.append("projectiles")
	func _collisions() -> void: phases.append("collision"); late_reward += 1
	func _cleanup(_ms: int) -> void: phases.append("cleanup")
	func _regenerate_voids(_ms: int) -> void: phases.append("traffic")
	func record(kind: String, data: Dictionary) -> void:
		emitted = true
		events.append({"kind": kind, "data": data.duplicate(true), "reward_at_boundary": late_reward})
var checks := 0
var failures := 0
func check(ok: bool, text: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", text)
func _init() -> void:
	for mode in ["dock", "gate", "star"]:
		var game := GameProbe.new()
		var space := Probe.new(game)
		space.player = Body.new()
		space.player.kind = Body.Kind.PLAYER
		space.station = Body.new()
		space.station.kind = Body.Kind.STATION
		space.station.station_id = 96
		space.bodies = [space.player, space.station]
		space.event.connect(space.record)
		if mode == "dock": space.docking = space.DOCKING_TIME
		elif mode == "gate": space.jumping = 2500; space.jump_destination = {"station": 95, "system": 19}
		else: space.travelling = space.TRAVEL_FLASH; space.travel_station = 96
		space.step(0.016, {})
		check(space.events.size() == 1 and space.events[0].kind == ("docked" if mode == "dock" else "jumped"),
			mode + ": native flight timer emits exactly its real transition")
		check(space.phases.is_empty() and space.late_reward == 0,
			mode + ": no old-world weapon, targeting, collision, salvage or RNG phase follows transition")
		var clock: int = space.clock
		var position: Vector3 = space.player.pos
		space.step(0.016, {"fire": true})
		check(space.clock == clock and space.player.pos == position and space.phases.is_empty() and space.events.size() == 1,
			mode + ": later calls cannot advance or reward an already retired world")
		check(int(game.session.stats.get("jumpgates", 0)) == (1 if mode == "gate" else 0),
			mode + ": only a genuine gate completion increments the gate counter once")
		space.dispose()
	print("FLIGHT TRANSITIONS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
