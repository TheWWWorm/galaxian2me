extends RefCounted
## A looping camera path in the original's keyframe format: eight values per
## key (time in ms, position x/y/z, rotation x/y/z in 4096ths of a turn,
## field of view in 4096ths of a turn), interpolated with cubic Hermite
## segments whose end tangents are zero, like the original's path player.

const Assembly := preload("res://src/presentation/assembly.gd")

var keys: Array = []
var period := 1.0
var tangents: Array = []

func _init(flat: Array) -> void:
	for i in range(0, flat.size() - 7, 8):
		keys.append(flat.slice(i, i + 8))
	if keys.size() >= 2:
		period = float(keys[-1][0])
		for i in keys.size():
			var t: Array = []
			for k in range(1, 8):
				if i == 0 or i == keys.size() - 1: t.append(0.0)
				else: t.append((float(keys[i + 1][k]) - float(keys[i - 1][k])) * 0.5)
			tangents.append(t)

func valid() -> bool:
	return keys.size() >= 2 and period > 0.0

## {transform, fov} at `ms` milliseconds into the loop.
func sample(ms: float) -> Dictionary:
	var t := fmod(ms, period)
	var seg := 0
	for i in range(keys.size() - 1, -1, -1):
		if float(keys[i][0]) < t:
			seg = mini(i, keys.size() - 2); break
	var t0 := float(keys[seg][0]); var t1 := float(keys[seg + 1][0])
	var u := clampf((t - t0) / maxf(1.0, t1 - t0), 0.0, 1.0)
	var u2 := u * u; var u3 := u2 * u
	var h00 := 2.0 * u3 - 3.0 * u2 + 1.0
	var h10 := u3 - 2.0 * u2 + u
	var h01 := -2.0 * u3 + 3.0 * u2
	var h11 := u3 - u2
	var v: Array = []
	for k in 7:
		v.append(h00 * float(keys[seg][k + 1]) + h10 * tangents[seg][k] + h01 * float(keys[seg + 1][k + 1]) + h11 * tangents[seg + 1][k])
	var basis := Assembly.basis(int(v[3]), int(v[4]), int(v[5]))
	return {"transform": Transform3D(basis, Assembly.position([v[0], v[1], v[2]])),
		"fov": clampf(v[6] / 4096.0 * 360.0, 20.0, 120.0)}
