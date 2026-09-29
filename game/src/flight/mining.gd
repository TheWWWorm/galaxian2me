extends RefCounted
## The mining game, with the original's figures: one rock layer per asteroid
## class (up to seven, narrower each time), a drill that drifts one way or
## the other and is steered back with left/right, time in the red zone that
## wrecks the asteroid after 2.5 s, ore that accrues faster in deeper layers,
## and a core for getting through all seven layers of a class A asteroid.
## The mining laser's yield and speed set drift, steering and ore rate.

const Catalogue := preload("res://src/content/catalogue.gd")

## Layer widths (pixels on the original's gauge), outermost first.
const WIDTHS := [44, 39, 34, 29, 23, 18, 13]
const MARGIN := 2
const RED_LIMIT := 2500.0

var layers := 2
var ore := 154
var layer := 0
var layer_time := 0
var layer_needed := 6000
var drift_time := 0
var drift_period := -1
var drift_dir := 1.0
var drift_speed := 0.0
var steer := 0.0
var drill := 0.0
var red := 0.0
var tons := 0.0
var speed_div := 25.0
var steer_div := 50.0
var rate := 1.0
var finished := false
var success := false
var rng := RandomNumberGenerator.new()

func _init(asteroid_class: int, ore_id: int, laser_id: int, cat) -> void:
	rng.randomize()
	layers = clampi(asteroid_class, 1, 7)
	ore = ore_id
	var yield_pct := float(cat.attr(laser_id, Catalogue.A_MINING_YIELD)) / 100.0
	speed_div = 25.0 + yield_pct * 55.0
	steer_div = 50.0 + yield_pct * 200.0
	rate = float(cat.attr(laser_id, Catalogue.A_MINING_SPEED)) / 100.0

func half_width() -> float:
	# aw.java clamps to an integer pixel, including odd-width layers.
	return float(int((2 * MARGIN + 3 * WIDTHS[layer]) / 2.0))

## Advances by `ms`; `left`/`right` steer the drill. Returns false when over.
func step(ms: int, left: bool, right: bool) -> bool:
	if finished: return false
	drift_time += ms
	# The phone tests abs((int)drill) against integer width/2, not the
	# subpixel coordinate. Fractional positions at the edge remain green.
	if absi(int(drill)) > int(WIDTHS[layer] / 2.0):
		red += ms
		if red > RED_LIMIT:
			red = RED_LIMIT
			tons = 0.0
			finished = true
			return false
	else:
		layer_time += ms
		tons += (0.15 + (layer + 1) / 7.0 * 2.35) * rate / 1000.0 * ms
	if layer_time > layer_needed:
		layer_time = 0
		layer += 1
		layer_needed = int(layer_needed * 0.83)
		if layer >= layers:
			layer = layers - 1
			finished = true
			success = true
			return false
		drift_time = drift_period + 1
		drill *= 0.88
	if drift_time > drift_period:
		drift_time = 0
		drift_period = 500 + int(rng.randi_range(0, 99) / 100.0 * 2000.0)
		drift_dir = -1.0 if rng.randi_range(0, 1) == 0 else 1.0
		steer /= 2.0
	drift_speed = ms / speed_div * drift_dir
	if right: steer -= ms / steer_div
	elif left: steer += ms / steer_div
	else: steer = 0.0
	drill = clampf(drill + drift_speed - steer, -half_width(), half_width())
	return true

## Whether the drill got through every layer of a class A asteroid.
func core_found() -> bool:
	return success and layers == 7
