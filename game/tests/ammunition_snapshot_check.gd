extends SceneTree
## Test the earned harness's exact quantity oracle at its JSON boundary.
const Harness := preload("res://tests/earned_challenge_run.gd")
var checks := 0
var failures := 0

func check(value: bool, message: String) -> void:
	checks += 1
	if not value: failures += 1
	print(("PASS: " if value else "FAIL: ") + message)

func _init() -> void:
	var equipment: Array = JSON.parse_string('[[{"id":8,"count":1},{"id":2,"count":1}],[{"id":35,"count":7}],[],[{"id":52,"count":1},{"id":71,"count":1},{"id":56,"count":1},{"id":77,"count":1}]]')
	var before := var_to_str(equipment)
	for spent in 8:
		var native: Array = equipment.duplicate(true)
		if spent == 7: native[1][0] = null
		else: native[1][0].count = 7 - spent
		var actual: Array = JSON.parse_string(JSON.stringify(native))
		var expected := Harness.expected_continuation_equipment(equipment, spent)
		check(actual == expected, "exact serialized equipment accepts %d genuinely remaining rockets" % (7 - spent))
		check(var_to_str(equipment) == before, "expected-state calculation never spends or changes source equipment")
		var wrong: Array = actual.duplicate(true)
		wrong[1][0] = {"id": 35.0, "count": float(8 - spent)}
		check(wrong != expected, "one invented rocket is rejected, including the exhausted-slot boundary")
	var partial := Harness.expected_continuation_equipment(equipment, 3)
	var legacy: Array = equipment.duplicate(true)
	legacy[1][0].count = 4
	check(legacy[1][0].count == partial[1][0].count and legacy != partial,
		"reproduce the old equal-number but unequal-nested-representation oracle failure")
	for corrupt in ["4", 4.5]:
		var wrong: Array = partial.duplicate(true)
		wrong[1][0].count = corrupt
		check(wrong != partial, "string and fractional ammunition counts are not normalized into valid resources")
	var wrong_gear: Array = partial.duplicate(true)
	wrong_gear[3][0].id = 77.0
	check(wrong_gear != partial, "a changed equipped item remains a hard mismatch")
	print("%d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
