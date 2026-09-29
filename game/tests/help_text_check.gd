extends SceneTree
## The original's help texts carry their title in brackets; the tips, the
## help pages and the station info show it as a title, never as raw text.
const Host := preload("res://tests/support/isolated_app.gd")
const Tips := preload("res://src/presentation/tips.gd")
const Help := preload("res://src/screens/help_panel.gd")
const Prefs := preload("res://src/presentation/preferences.gd")
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
		check(Tips.split("[SHOP]\nBuy here.") == ["SHOP", "Buy here."], "a bracketed first line is the title")
		check(Tips.split("Plain text [not a title]") == ["", "Plain text [not a title]"], "text without one is left alone")
		var raw := 0
		for id in range(304, 325):
			var parts := Tips.split(app.library.text(id))
			if str(parts[1]).begins_with("["): raw += 1
		check(raw == 0, "no supplied help text keeps its bracketed title")
		var tip := Tips.line(app, 309)
		check(not str(tip.text).begins_with("[") and not str(tip.name).is_empty(), "a tip shows its title as the speaker")
		check(Help.pages(app).all(func(p): return not str(p[1]).begins_with("[")), "help pages show no bracketed titles")
		var phone: Array = Help.pages(app).filter(func(p): return p[0] == "Phone keys")
		check(phone.size() == 1 and str(phone[0][1]).contains(Prefs.key_name("fire")) and str(phone[0][1]).contains("5"),
			"a page says which keys here do the phone keys' work")
	print("HELP TEXT: %d checks, %d failures" % [checks, failures])
	app.queue_free()
	quit(1 if failures else 0)
