extends "res://src/presentation/ui.gd".Frame
## The original's manual: its help topics (titles and texts from the game),
## the loading-screen tips, and this engine's controls. Opened from the
## title, the pause menu and the station's Game Options.

const UI := preload("res://src/presentation/ui.gd")
const Prefs := preload("res://src/presentation/preferences.gd")
const Tips := preload("res://src/presentation/tips.gd")
const EngineLanguage := preload("res://src/presentation/engine_language.gd")

const HELP_TITLES := [112, 296, 275, 79, 130, 218, 72, 146, 297, 63, 298]
const HELP_TEXTS := [306, 307, 308, 309, 312, 314, 315, 320, 321, 323, 324]
const TIPS := [165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177]

signal closed

var app

func _init() -> void:
	super._init("")

func _ready() -> void:
	var lib = app.library
	title = lib.text(4)
	custom_minimum_size = Vector2(820, 500)
	var outer := VBoxContainer.new()
	add_child(outer)
	var row := HBoxContainer.new()
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 12)
	outer.add_child(row)
	var topics := VBoxContainer.new()
	topics.custom_minimum_size.x = 230
	row.add_child(topics)
	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.custom_minimum_size = Vector2(540, 420)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	row.add_child(scroll)
	var body := UI.paragraph("", 15)
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(body)
	var pages := pages(app)
	var first: Button = null
	for page in pages:
		var b := UI.button(str(page[0]), func():
			body.text = str(page[1])
			scroll.scroll_vertical = 0)
		topics.add_child(b)
		if first == null: first = b
	body.text = str(pages[0][1])
	var back := UI.button(lib.text(65), func():
		closed.emit()
		queue_free())
	back.alignment = HORIZONTAL_ALIGNMENT_CENTER
	outer.add_child(back)
	first.grab_focus.call_deferred()

static func pages(app) -> Array:
	var lib = app.library
	var out: Array = []
	for i in HELP_TITLES.size():
		out.append([lib.text(HELP_TITLES[i]), Tips.split(lib.text(HELP_TEXTS[i]))[1]])
	var tips: Array = []
	for id in TIPS:
		var t: String = lib.text(id)
		if not t.is_empty() and not tips.has(t): tips.append("• " + t)
	out.append([EngineLanguage.translate("Tips"), "\n\n".join(tips)])
	var keys: Array = []
	for action in Prefs.BINDABLE: keys.append("%s  —  %s" % [Prefs.action_name(action), Prefs.key_name(action)])
	keys.append(EngineLanguage.translate("Mouse: steer by pointing, left button fires, right button launches the secondary weapon; hold Alt to look around."))
	keys.append(EngineLanguage.translate("Gamepad: left stick steers, right stick looks around, RT/RB fire, LB secondary, A boost, Y autopilot, X next target, Back actions, Start pause."))
	keys.append(EngineLanguage.translate("The texts above name the phone's keys; the keys here are shown in Options → Controls."))
	out.append([lib.text(20), "\n".join(keys)])
	out.append([EngineLanguage.translate("Phone keys"), phone_keys(app)])
	return out

## The phone's keys the game's own texts speak of, and what does their
## work here, with the player's current bindings.
static func phone_keys(app) -> String:
	var k := func(action: String) -> String: return Prefs.key_name(action)
	var rows := [
		[EngineLanguage.translate("2, 4, 6, 8 / directional keys"), EngineLanguage.translate("%s, %s, %s, %s · mouse · left stick") % [k.call("steer_up"), k.call("steer_left"), k.call("steer_down"), k.call("steer_right")]],
		[EngineLanguage.translate("5 / Fire / Select"), EngineLanguage.translate("%s · left mouse button · RT") % k.call("fire")],
		[EngineLanguage.translate("'Left' and 'Right' in menus"), EngineLanguage.translate("arrow keys · D-pad")],
		[EngineLanguage.translate("9: autopilot"), EngineLanguage.translate("%s · Y") % k.call("autopilot")],
		[EngineLanguage.translate("Hold 9: autopilot list"), "%s" % k.call("autopilot_menu")],
		[EngineLanguage.translate("7: auto fire"), "%s" % k.call("auto_fire")],
		[EngineLanguage.translate("3: booster"), EngineLanguage.translate("%s · A") % k.call("boost")],
		[EngineLanguage.translate("0: rear view / turret"), EngineLanguage.translate("%s · right stick click") % k.call("rear_view")],
		[EngineLanguage.translate("Right softkey: action menu"), EngineLanguage.translate("%s · Back") % k.call("action_menu")],
		[EngineLanguage.translate("Left softkey: menu / back"), EngineLanguage.translate("Escape · Start / B")],
	]
	var lines: Array = []
	var original: String = app.library.text(22)
	if not original.is_empty(): lines.append(original.replace("\n\n", "\n") + "\n")
	for r in rows: lines.append("%s  →  %s" % [r[0], r[1]])
	return "\n".join(lines)

## The game's own lines name the phone's keys ('Fire', '9', the softbuttons).
## For a line that does, a short note of what to press here instead: the
## player's bindings and pad buttons, or the on-screen buttons on touch.
## Empty when the line names no keys.
static func key_note(app, text: String) -> String:
	var touch: bool = preload("res://src/flight/touch_controls.gd").wanted(app)
	var k := func(action: String) -> String: return Prefs.key_name(action)
	var quoted := func(what: String) -> bool:
		for q in [["'", "'"], ["‘", "’"], ["’", "’"], ["\"", "\""]]:
			if text.contains(q[0] + what + q[1]): return true
		return false
	var parts: Array = []
	if text.contains("directional keys") or text.contains("2, 4, 6 and 8"):
		var four := "%s %s %s %s" % [k.call("steer_up"), k.call("steer_left"), k.call("steer_down"), k.call("steer_right")]
		if four == "Up Left Down Right": four = EngineLanguage.translate("arrow keys")
		parts.append(EngineLanguage.translate("steer: the stick") if touch else EngineLanguage.translate("steer: %s · mouse · left stick") % four)
	if quoted.call("Fire") or quoted.call("5"):
		parts.append(EngineLanguage.translate("'Fire': Fire / use, or tap") if touch else EngineLanguage.translate("'Fire': %s · left click · RT (menus: Enter · A)") % k.call("fire"))
	if quoted.call("Left") or quoted.call("Right") or quoted.call("Up") or quoted.call("Down"):
		parts.append(EngineLanguage.translate("'Left' / 'Right': tap the tab or row") if touch else EngineLanguage.translate("'Left' / 'Right': click · arrow keys · D-pad"))
	if quoted.call("9"): parts.append(EngineLanguage.translate("'9': Autopilot") if touch else EngineLanguage.translate("'9': %s · Y") % k.call("autopilot"))
	if quoted.call("7"): parts.append(EngineLanguage.translate("'7': Auto fire") if touch else EngineLanguage.translate("'7': %s") % k.call("auto_fire"))
	if quoted.call("3") or text.contains("key 3"): parts.append(EngineLanguage.translate("'3': Boost") if touch else EngineLanguage.translate("'3': %s · A") % k.call("boost"))
	if quoted.call("0"): parts.append(EngineLanguage.translate("'0': Rear view") if touch else EngineLanguage.translate("'0': %s") % k.call("rear_view"))
	if quoted.call("1"): parts.append(EngineLanguage.translate("'1': Secondary") if touch else EngineLanguage.translate("'1': %s") % k.call("secondary"))
	if text.contains("right softbutton") or text.contains("oftkey right"):
		parts.append(EngineLanguage.translate("right softbutton: Actions") if touch else EngineLanguage.translate("right softbutton: %s · Back") % k.call("action_menu"))
	if text.contains("left softbutton"):
		parts.append(EngineLanguage.translate("left softbutton: the buttons on screen") if touch else EngineLanguage.translate("left softbutton: the buttons on screen (click · Enter · A)"))
	if parts.is_empty(): return ""
	# An action with no key bound keeps only its mouse and pad names.
	return EngineLanguage.translate("Here — %s") % "; ".join(parts).replace(": — · ", ": ").replace(": —;", ":;")

func _unhandled_input(event: InputEvent) -> void:
	if is_visible_in_tree() and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		closed.emit()
		queue_free()
