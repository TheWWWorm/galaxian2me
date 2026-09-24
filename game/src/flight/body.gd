extends RefCounted
## Something in space: the player, a ship, a station, a gate, an asteroid, a
## floating container. Positions are in the original's units and axes (which
## match Godot's); the view scales them down.

enum Kind { PLAYER, SHIP, FREIGHTER, STATION, GATE, ARRIVAL, WORMHOLE, ASTEROID, LOOT, STAR }

var kind := Kind.SHIP
var name := ""
var pos := Vector3.ZERO
var basis := Basis.IDENTITY
var velocity := Vector3.ZERO
## Collision/hit half-extent, as the original's box tests use.
var radius := 2000.0
var faction := 8
var alive := true
var visible := true
## Distance-limited targets (stations of other planets) are not collidable.
var solid := true

# Combat figures, as the original keeps them per ship.
var hull := 1
var hull_max := 1
var shield := 0.0
var shield_max := 0
var shield_recharge := 0
var armor := 0
var armor_max := 0
var emp := 0
var emp_max := 0
var emp_regen := 15000
var emp_timer := 0
var disabled := false
var speed := 2.0

# Appearance.
var model := ""
var ship_index := -1
var pattern_frame := 0
var scale := Vector3.ONE

# Behaviour.
var hostile := false
var friendly := false
var weapons: Array = []
var ai := {}
var cargo: Array = []
var waypoints: Array = []
var station_id := -1
var ore := -1
var ore_class := 0
var size := 0
var boosting := false
var anim_time := 0.0
var dead_timer := 0.0
var wreck := ""

## Ships' noses point along their +z axis, as the original models them.
func forward() -> Vector3:
	return basis.z

## A basis whose nose (+z) points along `dir`.
static func facing(dir: Vector3, up := Vector3.UP) -> Basis:
	if dir.length_squared() < 0.0001: return Basis.IDENTITY
	if absf(dir.normalized().dot(up)) > 0.99: up = Vector3.RIGHT
	return Basis.looking_at(-dir, up)

func up() -> Vector3:
	return basis.y

func is_ship() -> bool:
	return kind == Kind.SHIP or kind == Kind.FREIGHTER or kind == Kind.PLAYER

func damage(amount: float, emp_amount := 0.0) -> void:
	if not alive: return
	if emp_amount > 0.0 and emp_max > 0:
		emp = maxi(0, emp - int(emp_amount))
		if emp == 0 and not disabled:
			disabled = true
			emp_timer = 0
	var rest := amount
	if shield > 0.0:
		var take := minf(shield, rest)
		shield -= take
		rest -= take
	if rest > 0.0 and armor > 0:
		var take2 := mini(armor, int(ceil(rest)))
		armor -= take2
		rest -= take2
	if rest > 0.0:
		hull -= int(ceil(rest))
		if hull <= 0:
			hull = 0
			alive = false

## Recovers EMP energy after being disabled, over the regeneration time.
func recover(ms: int) -> void:
	if not disabled: return
	emp_timer += ms
	emp = int(float(emp_timer) / float(maxi(1, emp_regen)) * emp_max)
	if emp >= emp_max:
		emp = emp_max
		disabled = false
		emp_timer = 0
