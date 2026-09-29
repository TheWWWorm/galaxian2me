extends "res://tests/earned_challenge_run.gd"
## No-content/no-save callback lifecycle fixture, not a campaign replay.
class ClosingFlight extends RefCounted:
	var space := {"story": null, "docking": -1, "jumping": -1,
		"travelling": -1, "station": null}

func _init() -> void:
	started = true
	verify_teardown.call_deferred()

func _run() -> void:
	pass

func verify_teardown() -> void:
	var flight := ClosingFlight.new()
	var reference: WeakRef = weakref(flight)
	check(app == null, "lifecycle fixture starts without a live application or save storage")
	var released: Variant = pilot(reference)
	check(released is Dictionary and released.is_empty(),
		"a live flight callback after host release returns no input without dereferencing the host")
	app = TestApp.new()
	# _ready is deliberately not called, so explicitly parent the three
	# preallocated nodes it would normally own. No content is activated.
	app.add_child(app.ui_layer)
	app.add_child(app.world_root)
	app.add_child(app.music)
	app.queue_free()
	var closing: Variant = pilot(reference)
	check(closing is Dictionary and closing.is_empty(),
		"a queued-for-deletion host also cannot receive a late flight decision")
	check(app.save_attempts.is_empty(), "late callback checks neither activate content nor save progress")
	app.free()
	app = null
	await frames(3)
	print("%d checks, %d failures" % [checks.size(), failures])
	quit(1 if failures else 0)
