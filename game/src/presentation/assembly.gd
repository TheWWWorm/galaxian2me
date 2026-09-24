extends RefCounted
## Builds composite figures the way the original lays them out from its data
## tables: ships from shipparts.bin and stations from stationparts.bin. Part
## transforms use the original fixed-point convention: 4096 units per turn,
## rotation applied as Rx·Ry·Rz, scale 4096 = 1, positions in model units.

const Library := preload("res://src/content/library.gd")
const UNIT := Library.UNIT

## Original rotation (Rx·Ry·Rz, 4096 per turn). The original's axes match
## Godot's, so the matrix is used as it is.
static func basis(rx: int, ry: int, rz: int) -> Basis:
	var ax := rx * TAU / 4096.0
	var ay := ry * TAU / 4096.0
	var az := rz * TAU / 4096.0
	var sx := sin(ax); var cx := cos(ax)
	var sy := sin(ay); var cy := cos(ay)
	var sz := sin(az); var cz := cos(az)
	var c0 := Vector3(cy * cz, sx * sy * cz + cx * sz, -cx * sy * cz + sx * sz)
	var c1 := Vector3(-cy * sz, cx * cz - sx * sy * sz, sx * cz + cx * sy * sz)
	var c2 := Vector3(sy, -cy * sx, cx * cy)
	return Basis(c0, c1, c2)

static func position(p: Array) -> Vector3:
	return Vector3(p[0], p[1], p[2]) * UNIT

## Pattern mask selected by one frame of a figure's action: the phone game
## picks faction liveries and asteroid kinds this way.
static func frame_pattern(anim: Dictionary, frame: int) -> int:
	if anim.is_empty(): return 0
	var patterns: Dictionary = anim.actions[0].patterns
	var best := -1
	var mask := 0
	for key in patterns:
		var k := int(key)
		if k <= frame and k > best:
			best = k; mask = int(patterns[key])
	return mask

## A single model posed at one frame of its own (or a named) action.
static func figure(library, name: String, frame := 0, action_name := "") -> Node3D:
	var anim: Dictionary = library.animation(action_name if not action_name.is_empty() else name)
	var pattern := frame_pattern(anim, frame)
	var node: MeshInstance3D = library.instance(name, false, pattern)
	return node

## The faction livery frame the original selects for a ship.
static func ship_frame(faction: int) -> int:
	match faction:
		2: return 2
		3: return 3
		8: return 0
	return 1

## The livery frame for station modules, by the owning system's faction.
static func station_frame(faction: int) -> int:
	match faction:
		8: return 0
		0: return 1
		2: return 2
	return 3

static func is_booster(model_id: int) -> bool:
	return model_id >= 13064 and model_id <= 13071

## A ship assembled from its parts. Boosters are returned under "Boosters" so
## the caller can show them only while the engine is boosting.
static func ship(library, index: int, faction := 0) -> Node3D:
	var root := Node3D.new()
	root.name = "Ship%d" % index
	var parts: Array = library.data.ship_parts.get(str(index), [])
	var boosters := Node3D.new()
	boosters.name = "Boosters"
	root.add_child(boosters)
	var frame := ship_frame(faction)
	for part in parts:
		var model: int = part.model
		var name: String = library.model_name(model)
		if name.is_empty(): continue
		var node: Node3D
		if is_booster(model):
			node = figure(library, name, 0)
			boosters.add_child(node)
		else:
			node = figure(library, name, frame)
			root.add_child(node)
		var s: Array = part.scale
		node.transform = Transform3D(Basis.from_scale(Vector3(s[0], s[1], s[2]) / 4096.0) * basis(part.rotation[0], part.rotation[1], part.rotation[2]),
			position(part.position))
	return root

## A station laid out from its record, or null when the table has none.
static func station(library, station_id: int, faction: int) -> Node3D:
	var key := "100" if faction == 1 else str(station_id)
	var entry = library.data.station_parts.get(key)
	var root := Node3D.new()
	root.name = "Station%d" % station_id
	if entry == null or entry.parts.is_empty():
		var void_station := figure(library, library.model_name(3337))
		root.add_child(void_station)
		return root
	var frame := station_frame(faction)
	# The record's header names the hangar module, which sits at the origin
	# turned half a revolution about the vertical axis.
	var parts: Array = [{"model": entry.root, "position": [0, 0, 0], "rotation": [0, 2048, 0]}]
	parts.append_array(entry.parts)
	for part in parts:
		var name: String = library.model_name(part.model)
		if name.is_empty(): continue
		# Module liveries come from the shared station action table.
		var node := figure(library, name, frame, "stat_all")
		node.transform = Transform3D(basis(part.rotation[0], part.rotation[1], part.rotation[2]), position(part.position))
		root.add_child(node)
	return root
