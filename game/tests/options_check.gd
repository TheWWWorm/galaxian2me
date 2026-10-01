extends SceneTree
## Options: graphics presets set their options together, the menu shows
## Custom once a single option differs, and the panel builds every tab.
const Host := preload("res://tests/support/isolated_app.gd")
const Prefs := preload("res://src/presentation/preferences.gd")
const Options := preload("res://src/screens/options_panel.gd")
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
		check(Prefs.graphics_preset(app) == 1, "the default settings are the Balanced preset")
		Prefs.set_graphics_preset(app, 0)
		check(Prefs.graphics_preset(app) == 0 and not bool(app.setting("graphics", "dust", true)), "Performance turns effects off")
		check(is_equal_approx(root.scaling_3d_scale, 0.67), "Performance lowers the 3D resolution")
		Prefs.set_graphics_preset(app, 2)
		check(Prefs.graphics_preset(app) == 2 and bool(app.setting("graphics", "enhanced_lighting", false)), "Quality turns enhanced lighting on")
		app.set_setting("graphics", "lens_flare", false)
		check(Prefs.graphics_preset(app) == -1, "changing one option makes the settings Custom")
		var panel := Options.new()
		panel.app = app
		app.add_child(panel)
		await process_frame
		check(panel.tabs.get_tab_count() >= 5, "the options panel builds its tabs")
		var picks := panel.find_children("*", "OptionButton", true, false)
		var preset_pick: OptionButton = null
		for p in picks:
			var row: Node = p.get_parent()
			if row.get_child(0) is Label and (row.get_child(0) as Label).text == "Preset": preset_pick = p
		check(preset_pick != null and preset_pick.selected == Prefs.preset_names().size(), "the preset picker shows Custom")
		if preset_pick != null:
			preset_pick.item_selected.emit(1)
			await process_frame
			await process_frame
			check(Prefs.graphics_preset(app) == 1, "choosing a preset in the menu applies it")
		# A rebuild (here: rebinding a key) keeps the highlight on its row.
		panel.page = 2
		panel.tabs.current_tab = 2
		await process_frame
		var page: Control = panel.tabs.get_current_tab_control()
		var rows: Array = panel._focusables(page)
		var restore: Button = null
		for b in rows:
			if b is Button and b.text == "Restore default keys": restore = b
		if restore != null:
			var index := rows.find(restore)
			restore.grab_focus()
			restore.pressed.emit()
			await process_frame
			await process_frame
			var owner := panel.get_viewport().gui_get_focus_owner()
			var now: Array = panel._focusables(panel.tabs.get_current_tab_control())
			check(owner != null and now.find(owner) == index and (owner as Button).text == "Restore default keys",
				"after a rebuild the highlight stays on the same row")
		else:
			check(false, "the controls page has Restore default keys")
		Prefs.set_graphics_preset(app, 1)
		panel.queue_free()
	app.queue_free()
	await process_frame
	await process_frame
	print("OPTIONS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
