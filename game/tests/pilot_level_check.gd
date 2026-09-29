extends SceneTree
## The original's pilot level: 1 for a new pilot, raised by one whenever the
## experience from kills, wingmen, ore, cores and freelance missions passes
## 1.3 times the mark of the last level; checked on docking. Older saves
## without a level count as level 1.
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
	check(s.level() == 1 and s.stat("rank") == 1, "a new pilot is level 1")
	s.add_stat("kills", 19)
	s.check_level_up()
	check(s.level() == 1, "19 experience does not pass 1.3 x 15")
	s.add_stat("kills", 1)
	s.check_level_up()
	check(s.level() == 2 and s.stat("last_xp") == 20, "20 experience reaches level 2")
	s.check_level_up()
	check(s.level() == 2, "one level per mark, not per check")
	s.add_stat("jobs", 3)
	s.add_stat("ore_mined", 100)
	s.check_level_up()
	check(s.level() == 3, "missions count twice and ore by the fifty tons")
	s.stats.erase("rank"); s.stats.erase("last_xp")
	check(s.level() == 1, "a save without a level reads as level 1")
	print("%d checks, %d failures" % [checks, failures])
	quit(1 if failures > 0 else 0)
