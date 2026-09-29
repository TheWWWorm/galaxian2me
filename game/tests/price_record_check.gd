extends SceneTree
## The original's price record: the lowest and highest price seen for an
## item and where, kept through saving and loading; a broken record is
## refused like any other invalid save.
const Host := preload("res://tests/support/isolated_app.gd")
var checks := 0
var failures := 0

func _init() -> void:
	run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	print("PASS: " if ok else "FAIL: ", label)
	if not ok: failures += 1

func run() -> void:
	var app := Host.new()
	root.add_child(app)
	await process_frame
	await process_frame
	if app.library == null:
		print("SKIP: supplied content is not installed")
		quit(0)
		return
	var g = app._make_game()
	g.new_game()
	var s = g.session
	check(s.price_record(1).is_empty(), "nothing is recorded before a hangar is seen")
	s.record_price(1, 500, 3)
	s.record_price(1, 400, 5)
	s.record_price(1, 650, 7)
	s.record_price(1, 0, 9)
	check(s.price_record(1) == [400, 5, 650, 7], "lowest and highest prices keep their systems")
	var saved: Dictionary = JSON.parse_string(JSON.stringify(s.to_dict()))
	var h = app._make_game()
	h.new_game()
	var err: String = h.session.from_dict(saved)
	check(err.is_empty() and h.session.price_record(1).map(func(v): return int(v)) == [400, 5, 650, 7], "the record survives a save")
	saved.flags.prices["1"] = [1, 2, 3]
	check(not h.session.from_dict(saved).is_empty(), "a malformed record is refused")
	print("%d checks, %d failures" % [checks, failures])
	quit(1 if failures > 0 else 0)
