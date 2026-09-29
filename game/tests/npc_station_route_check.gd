extends SceneTree
## Memory-only navigation fixtures. Recorded positions are not campaign saves.
const Host := preload("res://tests/support/isolated_app.gd")
const Game := preload("res://src/simulation/game.gd")
const Space := preload("res://src/flight/space.gd")
const Body := preload("res://src/flight/body.gd")
const AI := preload("res://src/flight/ai.gd")
const STARTS := [Vector3(-14852, -10187, 19693), Vector3(1534, 17780, -17049),
	Vector3(-300, 19202, 1179), Vector3(34, 1377, 13417)]
const FIRST := Vector3(-20000, -3000, 65000)
const LAST := Vector3(-20000, -3000, 200000)
var checks := 0
var failures := 0

func _init() -> void:
	run.call_deferred()

func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1
	print("PASS: " if ok else "FAIL: ", label)

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	var game := Game.new(app.library, app.catalogue)
	game.new_game()
	game.session.story_step = 40
	game.session.story_mission = game.campaign.mission_from(game.campaign.step_record(40).missions[0])
	game.session.station_id = 91
	game.session.system_index = 18
	game.session.flags.wormhole_station = 91
	game.session.flags.wormhole_system = 18
	var space := Space.new(game)
	space.build()
	var boxes: Array = space.station_boxes.duplicate(true)
	var state := JSON.stringify(game.session.to_dict())
	check(not boxes.is_empty(), "uses the supplied portal-station module geometry")
	var table = app.library.constant("cw#b:[I")
	var entry: Dictionary = app.library.data.station_parts["91"]
	var model_ids: Array = [entry.root]
	for part in entry.parts: model_ids.append(part.model)
	var dimensions_match := boxes.size() == model_ids.size()
	for index in mini(boxes.size(), model_ids.size()):
		var at := (int(model_ids[index]) - 3301) * 6
		var expected := Vector3((int(table[at + 3]) + 5000) >> 1,
			(int(table[at + 4]) + 5000) >> 1, (int(table[at + 5]) + 5000) >> 1)
		dimensions_match = dimensions_match and boxes[index].half == expected
	check(dimensions_match, "source station dimensions are halved by the bounding-box constructor")
	var all_dimensions := true
	var all_boundaries := true
	var modules := 0
	for key in app.library.data.station_parts:
		space.station_boxes = []
		space._station_boxes(int(key), 1 if str(key) == "100" else 0)
		var station_entry: Dictionary = app.library.data.station_parts[key]
		var ids: Array = [station_entry.root]
		for part in station_entry.parts: ids.append(part.model)
		var generated: Array = space.station_boxes.duplicate()
		all_dimensions = all_dimensions and generated.size() == ids.size()
		for index in mini(generated.size(), ids.size()):
			var box: Dictionary = generated[index]
			var at := (int(ids[index]) - 3301) * 6
			var expected := Vector3((int(table[at + 3]) + 5000) >> 1,
				(int(table[at + 4]) + 5000) >> 1, (int(table[at + 5]) + 5000) >> 1)
			all_dimensions = all_dimensions and box.half == expected
			# Isolate one supplied module only for the boundary query: another
			# overlapping module must not turn an outside point into a false FAIL.
			space.station_boxes = [box]
			for axis in 3:
				for side in [-1.0, 1.0]:
					var near := Vector3.ZERO
					near[axis] = (expected[axis] - 2.0) * side
					var far := Vector3.ZERO
					far[axis] = (expected[axis] + 2.0) * side
					all_boundaries = all_boundaries and space._inside_station(box.origin + box.basis * (box.centre + near))
					all_boundaries = all_boundaries and not space._inside_station(box.origin + box.basis * (box.centre + far))
			modules += 1
	check(all_dimensions and modules > 100, "every supplied station assembly uses original full-dimension conversion")
	check(all_boundaries, "all six transformed faces of each supplied module retain real inside/outside collisions")
	print("SOURCE STATION MODULES ", modules)
	space.station_boxes = boxes
	var inside: Array = STARTS.map(func(at): return space._inside_station(at, -2000.0))
	print("RECORDED SPAWN INSIDE STATION ", inside)
	# The original RED logged [false,true,true,true] with doubled extents.
	# Correct source extents may change this diagnostic; arrival is the oracle.
	# No orientation was retained in the old ledger. Exercise four declared
	# headings rather than claiming an exact full-state replay of that run.
	for geometry in [false, true]:
		space.station_boxes = boxes if geometry else []
		for heading in 4:
			var group: Array = []
			for at in STARTS:
				var b := Body.new()
				b.kind = Body.Kind.SHIP
				b.faction = 0
				b.friendly = true
				b.pos = at
				b.basis = Basis(Vector3.UP, float(heading) * PI / 2.0)
				b.speed = 2.0
				b.ai = {"mode": "patrol", "route": [FIRST, LAST], "leg": 0, "timer": 0}
				group.append(b)
			space.bodies.assign(group)
			var arrival := [-1, -1, -1, -1]
			var max_move := 0.0
			for tick in 4800:
				for i in group.size():
					var b: Body = group[i]
					var before: Vector3 = b.pos
					AI.step(space, b, 0.016, 16)
					max_move = maxf(max_move, before.distance_to(b.pos))
					if arrival[i] < 0 and int(b.ai.leg) > 0: arrival[i] = (tick + 1) * 16
			print("TRAJECTORY ", JSON.stringify({"geometry": geometry, "heading": heading,
				"arrival_ms": arrival, "end": group.map(func(b): return str(b.pos)), "max_frame_move": max_move}))
			check(arrival.all(func(time): return time > 0),
				"all four route ships reach first waypoint within 76.8s; geometry=%s heading=%d" % [geometry, heading])
			check(max_move <= 48.1, "collision response uses bounded forward movement (boost at most), never teleports a ship")
	# A ship fighting on its way still counts a route point it flies through.
	var fighter := Body.new()
	fighter.kind = Body.Kind.SHIP
	fighter.faction = 0
	fighter.friendly = true
	fighter.pos = FIRST + Vector3(0, 0, -3000)
	fighter.speed = 2.0
	var foe := Body.new()
	foe.kind = Body.Kind.SHIP
	foe.faction = 9
	foe.hostile = true
	foe.combat_active = true
	foe.pos = FIRST + Vector3(0, 0, 30000)
	foe.speed = 0.0
	foe.ai = {"mode": "hold"}
	fighter.ai = {"mode": "patrol", "route": [FIRST, LAST], "leg": 0, "timer": 0, "target": foe}
	space.station_boxes = []
	space.bodies.assign([fighter, foe])
	AI.step(space, fighter, 0.016, 16)
	check(fighter.ai.get("target") == foe and int(fighter.ai.leg) == 1, "a route point passed mid-fight counts")
	check(state == JSON.stringify(game.session.to_dict()) and app.save_attempts.is_empty(),
		"trajectory fixtures change no session/resource and attempt no save")
	space.dispose()
	app.queue_free()
	await process_frame
	await process_frame
	print("NPC STATION ROUTE: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
