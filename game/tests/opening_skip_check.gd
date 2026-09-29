extends SceneTree
## The opening's silent rise over the field can be skipped to its first
## radio line; lines and scenes waiting on events cannot. Memory-only.
const Host := preload("res://tests/support/isolated_app.gd")
const Space := preload("res://src/flight/space.gd")
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
	if app.library == null:
		check(false, "supplied content installed")
	else:
		var g = app._make_game()
		g.new_game()
		var sim := Space.new(g)
		sim.build()
		var st = sim.story
		check(st != null and g.session.story_step == 0 and st.can_skip_wait(), "the opening's wait can be skipped")
		check(st.skip_wait() and st.clock == 15000, "skipping brings the clock to the first line's time")
		st.step_scene(16)
		check(st.current == 0 and not st.can_skip_wait(), "the first line then plays and cannot be skipped as a wait")
		st.clock += 20000
		st.step_scene(16)
		st.step_scene(600)
		check(st.current == 1 and not st.can_skip_wait(), "a line waiting on the previous one is not a timed wait")
		sim.dispose()
		var g2 = app._make_game()
		g2.new_game()
		g2.session.story_step = maxi(g2.session.story_step, 20)
		var free := Space.new(g2)
		free.build()
		check(free.story == null or not free.story.can_skip_wait(), "ordinary flight has nothing to skip")
		free.dispose()
	print("OPENING SKIP: %d checks, %d failures" % [checks, failures])
	app.queue_free()
	quit(1 if failures else 0)
