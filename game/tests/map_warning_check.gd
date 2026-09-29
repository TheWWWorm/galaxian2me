extends SceneTree
## Explicit memory-only map fixtures; never earned campaign evidence.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Map := preload("res://src/screens/station/map_panel.gd")
var failures := 0
var checks := 0
func _init() -> void:
	run.call_deferred()
func check(ok: bool, text: String) -> void:
	checks += 1
	print("PASS: " if ok else "FAIL: ", text)
	if not ok: failures += 1
func button(node: Node, prefix: String) -> Button:
	for child in node.get_children():
		if child.is_queued_for_deletion(): continue
		if child is Button and prefix in child.text: return child
		var found := button(child, prefix)
		if found != null: return found
	return null
## Where station `sid` sits in system `sys`'s planet order.
func planet_index(app, sys: int, sid: int) -> int:
	var stations: Array = app.catalogue.system(sys).get("stations", [])
	for i in stations.size():
		if int(stations[i]) == sid: return i
	return 0

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	if app.library == null:
		check(false, "supplied content is installed")
	else:
		var game := Game.new(app.library, app.catalogue)
		game.new_game()
		game.session.story_step = 32
		game.session.system_index = 19
		game.session.station_id = 98
		game.session.flags.wormhole_station = 91.0
		game.session.flags.wormhole_system = 18.0
		game.session.story_mission = {"station": 10, "kind": 11}
		var map := Map.new()
		map.station = {"app": app, "game": game}
		root.add_child(map)
		await process_frame
		var before := JSON.stringify(game.session.to_dict())
		check(map.wormhole_address() == {"station": 91, "system": 18}, "post-report warning accepts saved JSON numeric address")
		check(map.story_address() == {"station": 10, "system": 6}, "mission32 still points to Thynome, not the portal")
		check(not map._reachable(18), "warning does not grant an unlinked jump route")
		check(map.portal_view != null and map.portal_view.portal.layers.size() == 1, "map renders only the supplied portal, without flight dust")
		var layer: Dictionary = map.portal_view.portal.layers[0]
		check(int(layer.interval) == 30 and layer.action.poses.size() > 1, "marker uses the supplied action with the original thirty-ms frame interval")
		check(map.portal_view.own_world_3d and map.portal_view.transparent_bg, "marker lives in an isolated transparent rendering world")
		map.open_system(18)
		map._set_planet(planet_index(app, 18, 91))
		await process_frame
		var dima := button(map.side, app.catalogue.station_name(91))
		check(dima != null and dima.has_meta("wormhole_station") and dima.disabled, "Dima's card marks the portal without enabling unreachable travel")
		check(dima != null and not dima.has_meta("story_station"), "mission32 destination and portal station stay distinct")
		map.open_system(6)
		map._set_planet(planet_index(app, 6, 10))
		await process_frame
		var thynome := button(map.side, app.catalogue.station_name(10))
		check(thynome != null and thynome.has_meta("story_station") and not thynome.has_meta("wormhole_station"), "Thynome's card retains the actual mission marker")
		check(JSON.stringify(game.session.to_dict()) == before, "opening and selecting map views changes no gameplay state")
		game.session.story_step = 31
		check(map.wormhole_address().is_empty(), "warning is absent before the earned report boundary")
		game.session.story_step = 32
		game.session.story_mission.station = -1
		check(map.story_address().is_empty(), "Void mission fallback is not enabled at exactly cursor32")
		game.session.story_step = 33
		check(map.story_address() == {"station": 91, "system": 18}, "post32 Void mission fallback uses the saved portal address")
		game.session.story_step = 40
		check(map.story_address() == {"station": 91, "system": 18} and game.session.story_mission.station == -1,
			"escort40 Map resolves the saved portal without rewriting its supplied Void mission address")
		game.session.story_mission.visible = false
		check(map.story_address().is_empty(), "hidden story mission does not acquire a visible marker")
		game.session.story_mission.erase("visible")
		game.session.flags.wormhole_system = 19
		check(map.wormhole_address().is_empty() and map.story_address().is_empty(), "mismatched system/station pair cannot create a warning or fallback")
		game.session.flags.wormhole_system = 18
		for invalid in [-1, -10, 9999, 91.5, "91"]:
			game.session.flags.wormhole_station = invalid
			check(map.wormhole_address().is_empty(), "invalid or cleared portal address is suppressed: %s" % str(invalid))
		game.session.flags.erase("wormhole_station")
		check(map.wormhole_address().is_empty(), "absent address cannot invent a portal")
		check(app.save_attempts.is_empty(), "map fixtures never write player or test saves")
		map.queue_free()
	app.queue_free()
	await process_frame
	await process_frame
	print("MAP WARNING: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
