extends RefCounted
## java.util.Random's documented 48-bit linear congruential generator. Where
## the original seeds its generator with a fixed value (per-station price
## variation, for instance) this reproduces the same sequence.

const MULTIPLIER := 0x5DEECE66D
const MASK := (1 << 48) - 1

var seed := 0

func _init(value := 0) -> void:
	set_seed(value)

func set_seed(value: int) -> void:
	seed = (value ^ MULTIPLIER) & MASK

func _next(bits: int) -> int:
	seed = (seed * MULTIPLIER + 0xB) & MASK
	var v := seed >> (48 - bits)
	# Signed 32-bit result, as Java's int cast yields.
	if bits == 32 and v >= 2147483648: v -= 4294967296
	return v

func next_int(bound: int) -> int:
	if bound <= 0: return 0
	if (bound & -bound) == bound:
		return (bound * _next(31)) >> 31
	var bits := _next(31)
	var value := bits % bound
	while bits - value + (bound - 1) >= 2147483648:
		bits = _next(31)
		value = bits % bound
	return value
