extends "res://src/presentation/hangar_view.gd"
## The supplied landing camera track, aligned with the native hangar.
## The release retains the camera constants, not a working landing scene.
## Ship approach, pad alignment and the transition are native choreography.

const CameraPath := preload("res://src/presentation/camera_path.gd")
const Backdrop := preload("res://src/presentation/backdrop.gd")
## The original scene stops updating a non-menu camera after ten seconds.
## Its final key at 20,000,000 ms is a hold, not the length of a cutscene.
const DURATION := 10.0

var path: CameraPath
var parked := Vector3.ZERO
var backdrop: Backdrop

static func landing_path(lib) -> CameraPath:
	var tracks = lib.constant("co#a:[[I")
	if not tracks is Array or tracks.size() < 2 or not tracks[1] is Array: return null
	var candidate := CameraPath.new(tracks[1], true)
	return candidate if candidate.valid() else null

static func supported(lib, faction: int, ship_index: int) -> bool:
	if landing_path(lib) == null: return false
	var style := 2 if faction == 1 else (0 if faction == 0 else 1)
	var segments = lib.constant("an.b:[[S")
	var offsets = lib.constant("df.b:[S")
	if not segments is Array or style >= segments.size() or not segments[style] is Array: return false
	if segments[style].size() < 4: return false
	if not offsets is Array or ship_index < 0 or ship_index >= offsets.size(): return false
	for id in segments[style]:
		if lib.model_data(lib.model_name(int(id))).is_empty(): return false
	var parts: Array = lib.data.ship_parts.get(str(ship_index), [])
	if parts.is_empty(): return false
	for part in parts:
		if lib.model_data(lib.model_name(int(part.model))).is_empty(): return false
	return true

func setup_entry(lib, catalogue, station_id: int, faction: int, ship_index: int, ship_faction: int) -> void:
	super.setup(lib, station_id, faction, ship_index, ship_faction)
	path = landing_path(lib)
	parked = ship_node.position
	pivot.transform = Transform3D.IDENTITY
	backdrop = Backdrop.new()
	backdrop.setup(lib, station_id, catalogue)
	add_child(backdrop)
	camera.far = 6000.0
	# Use the same horizontal FOV convention as the shared parked view.
	camera.keep_aspect = Camera3D.KEEP_WIDTH

func pose(seconds: float) -> void:
	if path == null: return
	var sample := path.sample(clampf(seconds, 0.0, DURATION) * 1000.0, false)
	var shot: Transform3D = sample.transform
	# Register the retained camera keys against the native hangar's pad.
	# This alignment is native layout, not a recovered scene transform.
	shot.origin += Vector3(0.0, parked.y, 10240.0 * Assembly.UNIT)
	camera.transform = shot
	camera.fov = float(sample.fov)
	# Glide from the open end of the hangar to the same pose used by the
	# parked view. Ease to a stop, then let the engines extinguish.
	var u := clampf(seconds / 8.5, 0.0, 1.0)
	var remaining := pow(1.0 - u, 2.0)
	ship_node.position = parked + Vector3(0.0, 3.0 * remaining, 150.0 * remaining)
	var boosters := ship_node.get_node("Boosters") as Node3D
	boosters.visible = seconds < 8.5
	Assembly.stretch_boosters(boosters, 0.0, remaining * 0.6)
	backdrop.follow(camera)

func _process(_delta: float) -> void:
	# The screen drives a finite timeline. Do not run the parked-view orbit.
	pass
