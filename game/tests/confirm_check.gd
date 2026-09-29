extends SceneTree
## Irreversible actions ask first: overwriting a used save slot, loading over
## the current game, leaving for the title and abandoning a contract. No is
## the default and Esc answers No. Memory-only.
const Host := preload("res://tests/support/isolated_app.gd")
const UI := preload("res://src/presentation/ui.gd")
var checks := 0
var failures := 0
var app

func _init() -> void:
	run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	print("PASS: " if ok else "FAIL: ", label)
	if not ok: failures += 1
func frames(n: int) -> void:
	for i in n: await process_frame

func question(under: Node):
	for layer in under.get_children():
		if layer is CanvasLayer and not layer.is_queued_for_deletion() and layer.get_child_count() > 0 \
				and layer.get_child(0) is UI.Question and not layer.get_child(0).is_queued_for_deletion():
			return layer.get_child(0)
	return null

func run() -> void:
	app = Host.new()
	root.add_child(app)
	await frames(2)
	if app.library == null:
		check(false, "supplied content installed")
		print("CONFIRM: %d checks, %d failures" % [checks, failures])
		quit(1)
		return
	# The question itself, inside a container that must keep its layout.
	var holder := VBoxContainer.new()
	root.add_child(holder)
	var answers: Array = []
	UI.ask(holder, "Overwrite?", func(): answers.append("yes"), func(): answers.append("no"))
	await frames(2)
	var q = question(holder)
	check(q != null and holder.get_children().filter(func(c): return c is Control).is_empty(), "the question does not join the container's layout")
	check(q != null and q.no_button.has_focus(), "No holds the highlight")
	var esc := InputEventAction.new()
	esc.action = "ui_cancel"; esc.pressed = true
	root.push_input(esc)
	await frames(2)
	check(answers == ["no"] and question(holder) == null, "Esc answers No and closes the question")
	UI.ask(holder, "Overwrite?", func(): answers.append("yes"))
	await frames(1)
	question(holder)._answer(true)
	await frames(2)
	check(answers == ["no", "yes"], "Yes runs the action")
	holder.queue_free()

	# Station Game menu: save, load, main menu.
	var g = app._make_game()
	g.new_game()
	app.game = g
	app.show_station()
	await frames(3)
	var station = app.screen
	station._open_section(5)
	await frames(2)
	var panel = station.current_panel
	panel._save()
	await frames(2)
	panel.box.get_child(0).pressed.emit()
	await frames(2)
	check(app.save_attempts.size() == 1 and question(panel) == null, "an empty slot saves without asking")
	panel._save()
	await frames(2)
	panel.box.get_child(0).pressed.emit()
	await frames(2)
	q = question(panel)
	check(q != null and app.save_attempts.size() == 1, "a used slot asks before it is overwritten")
	check(q != null and q.get_node("..").get_child(0).find_children("*", "Label", true, false).any(func(l): return l.text == app.library.text(27)),
		"the question is the game's own overwrite text")
	q._answer(false)
	await frames(2)
	check(app.save_attempts.size() == 1, "No keeps the old save")
	panel._save()
	await frames(2)
	panel.box.get_child(0).pressed.emit()
	await frames(2)
	question(panel)._answer(true)
	await frames(2)
	check(app.save_attempts.size() == 2, "Yes overwrites it")
	panel._load()
	await frames(2)
	var game_before = app.game
	panel.box.get_child(0).pressed.emit()
	await frames(2)
	check(question(panel) != null and app.game == game_before and app.screen == station, "loading asks before discarding the current game")
	question(panel)._answer(false)
	await frames(2)
	panel._main()
	await frames(2)
	var leave: Button = null
	for b in panel.box.get_children():
		if b is Button and b.text == app.library.text(67): leave = b
	leave.pressed.emit()
	await frames(2)
	check(question(panel) != null and app.screen == station, "leaving for the title asks first")
	question(panel)._answer(false)
	await frames(2)
	check(app.screen == station and leave.has_focus(), "No stays and returns the highlight to the row")

	print("CONFIRM: %d checks, %d failures" % [checks, failures])
	app.queue_free()
	quit(1 if failures else 0)
