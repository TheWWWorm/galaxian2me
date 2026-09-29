extends "res://src/flight/body.gd"
## Native portal lifecycle. Timings, relocation bounds and collision radii
## follow the supplied game's c/dr behaviour; artwork stays in its content.

const OPEN_MS := 40000
const FADE_MS := 3000
const PULL_RADIUS := 40000.0
const CROSS_RADIUS := 4096.0
var elapsed := 0
var opening_scale := 1.0

func _init() -> void:
	kind = Kind.WORMHOLE
	radius = PULL_RADIUS
	solid = false
	visible = false

func reveal() -> void:
	elapsed = 0
	opening_scale = 1.0
	visible = true

## The portal just used is already closing behind the arriving ship.
## c.a(true) starts at 39000, not at a fresh forty-second lifetime.
func arrive_behind(position: Vector3) -> void:
	reveal()
	pos = position
	elapsed = OPEN_MS - 1000

func usable() -> bool:
	return visible and elapsed <= OPEN_MS

## Returns true when relocation invalidates the old autopilot course.
func tick(ms: int, recurring: bool, story_step: int, player_position: Vector3, random: RandomNumberGenerator) -> bool:
	if not visible: return false
	elapsed += ms
	if story_step in [40, 42] and elapsed > OPEN_MS: elapsed = OPEN_MS
	if elapsed > OPEN_MS + FADE_MS:
		if not recurring:
			visible = false
			opening_scale = 0.0
			return true
		elapsed = -FADE_MS
		pos = Vector3(_coordinate(random), _coordinate(random), _coordinate(random))
		if story_step in [29, 41]: pos = player_position + pos * 4.0
		opening_scale = 0.0
		return true
	opening_scale = clampf(1.0 + float(elapsed) / FADE_MS, 0.0, 1.0) if elapsed < 0 else clampf(1.0 - float(elapsed - OPEN_MS) / FADE_MS, 0.0, 1.0)
	return false

static func _coordinate(random: RandomNumberGenerator) -> float:
	return float(random.randi_range(20000, 59999)) * (1.0 if random.randi_range(0, 1) == 0 else -1.0)
