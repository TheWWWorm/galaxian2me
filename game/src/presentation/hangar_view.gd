extends Node3D
## The docked view: the player's ship on its pad inside the station hangar,
## assembled from the imported hangar segments the way the original picks
## them (by the system's faction, seeded by the station), with the camera
## slowly orbiting the ship.

const Assembly := preload("res://src/presentation/assembly.gd")
const JavaRandom := preload("res://src/simulation/java_random.gd")

var camera := Camera3D.new()
var pivot := Node3D.new()
var ship_node: Node3D
var angle := 1536.0
var spin := 0.0
var library

func setup(lib, station_id: int, faction: int, ship_index: int, ship_faction: int) -> void:
	library = lib
	var style := 2 if faction == 1 else (0 if faction == 0 else 1)
	var segments = lib.constant("an.b:[[S")
	var offsets = lib.constant("df.b:[S")
	if segments is Array and style < segments.size():
		var list: Array = segments[style]
		var r := JavaRandom.new(station_id)
		for i in range(1, 6):
			var id: int = list[r.next_int(list.size() - 3)]
			if i == 5: id = list[list.size() - 2]
			elif i == 1: id = list[list.size() - 1]
			var seg := Assembly.figure(lib, lib.model_name(id), 0, "", true)
			seg.transform = Transform3D(Assembly.basis(0, 2048, 0), Assembly.position([0, 0, (i - 1) << 12]))
			add_child(seg)
		var end_id: int = list[list.size() - 3]
		var end := Assembly.figure(lib, lib.model_name(end_id), 0, "", true)
		end.transform = Transform3D(Assembly.basis(0, 2048, 0), Assembly.position([0, 0, 8192]))
		add_child(end)
	var lift := 0
	if offsets is Array and ship_index < offsets.size(): lift = int(offsets[ship_index])
	ship_node = Assembly.ship(lib, ship_index, ship_faction)
	# Parked on the pad the engines are out, as the original shows it.
	ship_node.get_node("Boosters").visible = false
	ship_node.transform = Transform3D(Assembly.basis(0, 2048, 0), Assembly.position([0, 1200, 10240 - lift + 100]))
	add_child(ship_node)
	# Camera rig: orbits the pad centre, as the original's hangar camera does.
	add_child(pivot)
	pivot.position = Assembly.position([0, 0, 10240])
	pivot.add_child(camera)
	camera.keep_aspect = Camera3D.KEEP_WIDTH
	camera.fov = 900.0 / 4096.0 * 360.0
	camera.near = 0.1
	camera.far = 600.0
	camera.transform = Transform3D(Assembly.basis(-256, 0, 0), Assembly.position([0, 1700, 1500]))
	# The hangar is lit from above rather than by a sun.
	RenderingServer.global_shader_parameter_set("gof_light_direction", Vector3(0.3, 0.9, 0.3).normalized())

func _process(delta: float) -> void:
	# The original turns the rig slowly by itself; left/right take over.
	angle += delta * 1000.0 / 6.0 + spin * delta * 1000.0
	spin *= pow(0.1, delta)
	pivot.transform.basis = Assembly.basis(0, int(angle) % 4096, 0)

func nudge(direction: float) -> void:
	spin = clampf(spin + direction * 2.0, -3.0, 3.0)

func replace_ship(ship_index: int, ship_faction: int) -> void:
	if ship_node != null: ship_node.queue_free()
	var offsets = library.constant("df.b:[S")
	var lift := int(offsets[ship_index]) if offsets is Array and ship_index < offsets.size() else 0
	ship_node = Assembly.ship(library, ship_index, ship_faction)
	ship_node.get_node("Boosters").visible = false
	ship_node.transform = Transform3D(Assembly.basis(0, 2048, 0), Assembly.position([0, 1200, 10240 - lift + 100]))
	add_child(ship_node)
