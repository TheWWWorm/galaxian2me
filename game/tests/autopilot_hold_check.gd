extends SceneTree
## Options → Controls → Hold autopilot for the list: off, the key acts the
## moment it is pressed; on, a tap acts on release and a half-second hold
## opens the autopilot list once, with no tap on release.
const Controls := preload("res://src/flight/controls.gd")
var checks := 0
var failures := 0
var settings := {}

class FakeApp:
	var values := {}
	func setting(section, key, fallback): return values.get(section + "/" + key, fallback)

func _init() -> void:
	run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	print("PASS: " if ok else "FAIL: ", label)
	if not ok: failures += 1

func frames(n: int) -> void:
	for i in n: await process_frame

func run() -> void:
	if not InputMap.has_action("autopilot"): InputMap.add_action("autopilot")
	var c = Controls.new()
	var app := FakeApp.new()
	c.app = app
	await process_frame
	Input.action_press("autopilot")
	check(c._autopilot_key() == [true, false], "off: the press acts at once")
	Input.action_release("autopilot")
	await process_frame
	check(c._autopilot_key() == [false, false], "off: release does nothing")
	app.values["controls/autopilot_hold"] = true
	Input.action_press("autopilot")
	check(c._autopilot_key() == [false, false], "on: the press waits")
	Input.action_release("autopilot")
	await process_frame
	check(c._autopilot_key() == [true, false], "on: a quick release is a tap")
	Input.action_press("autopilot")
	c._autopilot_key()
	await create_timer(0.5).timeout
	check(c._autopilot_key() == [false, true], "on: holding opens the list")
	check(c._autopilot_key() == [false, false], "on: the list opens once")
	Input.action_release("autopilot")
	await process_frame
	check(c._autopilot_key() == [false, false], "on: no tap after a hold")
	print("%d checks, %d failures" % [checks, failures])
	quit(1 if failures > 0 else 0)
