extends "res://src/presentation/ui.gd".Frame
## Options: the original's sound settings plus the engine's display,
## graphics, controls, interface and accessibility settings, on tabs.

const UI := preload("res://src/presentation/ui.gd")
const Prefs := preload("res://src/presentation/preferences.gd")
const Controls := preload("res://src/flight/controls.gd")
const EngineLanguage := preload("res://src/presentation/engine_language.gd")

signal closed

var app
var tabs := TabContainer.new()
var page := 0
## The action waiting for its new key, if any.
var binding := ""
var box: VBoxContainer
var refocus_preset := false

func _init() -> void:
	super._init("")

const PAGE_ICONS := {"Audio": "audio", "Display": "display", "Controls": "controls", "Interface": "interface", "Game": "game"}

## The page picker on the left and the chosen page in a titled panel.
var content: UI.Frame
var nav: VBoxContainer
var nav_group := ButtonGroup.new()

func _ready() -> void:
	title = app.library.text(3)
	set_chrome(false)
	# Roomy on a desktop, never wider or taller than the window.
	var room := get_viewport_rect().size
	custom_minimum_size = Vector2(minf(880.0, room.x - 32.0), minf(620.0, room.y - 48.0))
	var outer := HBoxContainer.new()
	outer.add_theme_constant_override("separation", 14)
	add_child(outer)
	var side := UI.Frame.new("", false)
	side.custom_minimum_size.x = minf(210.0, room.x * 0.26)
	outer.add_child(side)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 6)
	side.add_child(column)
	nav = VBoxContainer.new()
	nav.add_theme_constant_override("separation", 6)
	nav.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.add_child(nav)
	var back := UI.icon_button(app.library.text(65), "back", func():
		closed.emit()
		queue_free())
	column.add_child(back)
	content = UI.Frame.new(app.library.text(3))
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	outer.add_child(content)
	tabs.size_flags_vertical = Control.SIZE_EXPAND_FILL
	tabs.tabs_visible = false
	# The pages sit straight in the titled panel, without a second frame.
	tabs.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	tabs.tab_changed.connect(func(i):
		page = i
		_sync_nav())
	content.add_child(tabs)
	_build()
	back.grab_focus.call_deferred()

## The picker's buttons follow the pages; the current one stays lit.
func _sync_nav() -> void:
	# Pages being rebuilt are briefly all gone.
	if nav == null or tabs.get_tab_count() == 0: return
	if nav.get_child_count() != tabs.get_tab_count():
		for c in nav.get_children(): c.queue_free()
		for i in tabs.get_tab_count():
			var key := String(tabs.get_tab_control(i).name)
			var b := UI.icon_button(tabs.get_tab_title(i), str(PAGE_ICONS.get(key, "info")), func(): tabs.current_tab = i)
			b.toggle_mode = true
			b.button_group = nav_group
			b.custom_minimum_size.y = 46
			UI.flat_entry(b)
			nav.add_child(b)
	for i in nav.get_child_count():
		(nav.get_child(i) as Button).set_pressed_no_signal(i == tabs.current_tab)
	content.title = tabs.get_tab_title(tabs.current_tab)
	content.icon = str(PAGE_ICONS.get(String(tabs.get_current_tab_control().name), ""))
	content.queue_redraw()

func _build() -> void:
	# A rebuild keeps the highlight on the row that had it (the n-th
	# focusable control of the page) and the page's scroll position, so a
	# pad or keyboard user never loses their place.
	var focus_index := -1
	var at := 0
	# Removing the pages fires tab_changed, which would reset `page`.
	var keep := page
	var old_page := tabs.get_current_tab_control() as ScrollContainer
	if old_page != null:
		at = old_page.scroll_vertical
		var owner := get_viewport().gui_get_focus_owner() if is_inside_tree() else null
		if owner != null and old_page.is_ancestor_of(owner): focus_index = _focusables(old_page).find(owner)
	for c in tabs.get_children():
		tabs.remove_child(c)
		c.queue_free()
	_audio_page()
	_display_page()
	_controls_page()
	_interface_page()
	_game_page()
	page = keep
	tabs.current_tab = clampi(page, 0, tabs.get_tab_count() - 1)
	var now := tabs.get_current_tab_control() as ScrollContainer
	if now != null and old_page != null:
		now.set_deferred("scroll_vertical", at)
		if focus_index >= 0: _refocus.call_deferred(now, focus_index)
	_sync_nav()

func _focusables(root_node: Node) -> Array:
	return root_node.find_children("*", "Control", true, false).filter(func(c): return c.focus_mode == Control.FOCUS_ALL and c.is_visible_in_tree())

func _refocus(page_node: Control, index: int) -> void:
	if not is_instance_valid(page_node) or not page_node.is_inside_tree(): return
	var list := _focusables(page_node)
	if list.is_empty(): return
	(list[mini(index, list.size() - 1)] as Control).grab_focus()

## Rebuilds the pages to show changed values, keeping the scroll position
## and focus on the graphics preset picker.
func _rebuild_keep() -> void:
	var scroll := tabs.get_current_tab_control() as ScrollContainer
	var at := scroll.scroll_vertical if scroll != null else 0
	refocus_preset = true
	_build()
	var now := tabs.get_current_tab_control() as ScrollContainer
	if now != null: now.set_deferred("scroll_vertical", at)

## A page named by its key (Audio, Display…), titled in the engine language.
func _new_page(name: String, caption: String) -> void:
	var scroll := ScrollContainer.new()
	scroll.name = name
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	box = VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 8)
	scroll.add_child(box)
	tabs.add_child(scroll)
	tabs.set_tab_title(tabs.get_tab_count() - 1, caption)

# ------------------------------------------------------------------ pages

func _audio_page() -> void:
	var lib = app.library
	_new_page("Audio", tr("Audio"))
	_group(lib.text(6))
	_toggle(lib.text(6), "audio", "music_on", true, func(on):
		if not on: app.stop_music())
	_slider(tr("Volume"), "audio", "music", 0.8, 0.0, 1.0, 0.05, true)
	_group(lib.text(7))
	_toggle(lib.text(7), "audio", "sound_on", true)
	_slider(tr("Volume"), "audio", "sound", 0.8, 0.0, 1.0, 0.05, true)

func _display_page() -> void:
	_new_page("Display", tr("Display"))
	_group(tr("Window"))
	if Prefs.orientation_available():
		_choice(tr("Screen orientation"), Prefs.orientation_names(), clampi(int(app.setting("display", "orientation", 0)), 0, 2),
			func(i): app.set_setting("display", "orientation", i))
		_note(tr("Auto turns with the device, whichever way up it is held."))
	if not OS.has_feature("web") and not OS.has_feature("mobile"):
		_toggle(tr("Fullscreen"), "display", "fullscreen", false)
		_note(tr("F11 toggles fullscreen at any time."))
	_toggle(tr("Vertical sync"), "display", "vsync", true, func(_on): Prefs.apply_display(app))
	_choice(tr("Frame rate limit"), Prefs.FPS_LIMITS.map(func(v): return tr("Unlimited") if v == 0 else "%d" % v),
		maxi(0, Prefs.FPS_LIMITS.find(int(app.setting("display", "max_fps", 0)))), func(i):
			app.set_setting("display", "max_fps", Prefs.FPS_LIMITS[i])
			Prefs.apply_display(app))
	_toggle(tr("Show frame rate"), "display", "show_fps", false)
	_choice(tr("Aspect ratio"), Prefs.aspect_names(), clampi(int(app.setting("display", "aspect", 0)), 0, Prefs.ASPECTS.size() - 1), func(i):
		app.set_setting("display", "aspect", i)
		Prefs.apply_display(app))
	_note(tr("Auto fills the window; a fixed shape adds black bars."))
	_group(tr("Graphics"))
	var preset := Prefs.graphics_preset(app)
	var recommended := int(app.setting("graphics", "recommended", -1))
	var names: Array = []
	var presets := Prefs.preset_names()
	for i in presets.size(): names.append(tr("%s (Recommended)") % presets[i] if i == recommended else presets[i])
	var preset_pick := _choice(tr("Preset"), names + [tr("Custom")], presets.size() if preset < 0 else preset, func(i):
		if i < presets.size():
			Prefs.set_graphics_preset(app, i)
			_rebuild_keep.call_deferred())
	var sync := func(_v = null):
		var now := Prefs.graphics_preset(app)
		preset_pick.selected = presets.size() if now < 0 else now
	if refocus_preset:
		refocus_preset = false
		preset_pick.grab_focus.call_deferred()
	_note(tr("Performance suits older phones; Quality turns on every effect."))
	_choice(tr("3D resolution"), Prefs.RENDER_SCALES.map(func(v): return "%d%%" % int(round(v * 100))),
		maxi(0, Prefs.RENDER_SCALES.find(float(app.setting("graphics", "render_scale", 1.0)))), func(i):
			app.set_setting("graphics", "render_scale", Prefs.RENDER_SCALES[i])
			Prefs.apply_display(app)
			sync.call())
	_note(tr("Draws the 3D view at a share of the window's resolution; the interface stays sharp."))
	_choice(tr("Antialiasing (MSAA)"), Prefs.msaa_names(), clampi(int(app.setting("graphics", "msaa", 1)), 0, 3), func(i):
		app.set_setting("graphics", "msaa", i)
		Prefs.apply_display(app)
		sync.call())
	_toggle(tr("Enhanced lighting"), "graphics", "enhanced_lighting", false, func(_on):
		Prefs.apply_display(app)
		sync.call())
	_note(tr("Off keeps the original's flat phone lighting. On, the system's sun, explosions and engines light the same models and textures, with glossy hulls, fine relief and glowing windows and lamps."))
	_toggle(tr("Shadows"), "graphics", "shadows", true, func(_on):
		Prefs.apply_display(app)
		sync.call())
	_note(tr("With enhanced lighting: ships, stations and asteroids cast shadows from the sun."))
	_toggle(tr("Metal reflections"), "graphics", "reflections", true, func(_on):
		Prefs.apply_display(app)
		sync.call())
	_note(tr("With enhanced lighting: bare hull plating is metal and reflects a soft sky; off, hulls are painted."))
	_choice(tr("Light sources"), Prefs.Lighting.source_names(), clampi(int(app.setting("graphics", "light_sources", 2)), 0, 2), func(i):
		app.set_setting("graphics", "light_sources", i)
		Prefs.apply_display(app)
		sync.call())
	_note(tr("With enhanced lighting: engines, weapon fire, explosions and the lamps of stations, gates, the hangar and the lounge light what is near them. Few keeps the brightest; Many costs the most on phones."))
	_toggle(tr("Glare"), "graphics", "glare", false, func(_on):
		Prefs.apply_display(app)
		sync.call())
	_note(tr("Light from the sun, engine flames, weapon fire, explosions and lamps spills softly around them. Two extra full-screen passes."))
	_slider(tr("Field of view"), "graphics", "fov", Prefs.CLASSIC_FOV, 45.0, 90.0, 1.0, false, "%d°")
	_note(tr("The original's view is about %d°.") % int(round(Prefs.CLASSIC_FOV)))
	_toggle(tr("Space dust"), "graphics", "dust", true, sync)
	_toggle(tr("Lens flare"), "graphics", "lens_flare", true, sync)
	_toggle(tr("Sharp stars"), "graphics", "sharp_stars", true, func(_on): Prefs.apply_display(app))
	_note(tr("Draws the starfield's stars as points at the screen's own resolution; off shows the original's star pictures."))
	_toggle(tr("Smooth ship textures"), "display", "smooth_textures", false, func(_on):
		app.activate(app.library.id))
	_toggle(tr("Smooth station textures"), "display", "smooth_station_textures", bool(app.setting("display", "smooth_textures", false)), func(_on):
		app.activate(app.library.id))
	_note(tr("Off keeps the original's crisp pixelated textures. Ships covers everything outside the stations: ships, asteroids, crates."))

func _controls_page() -> void:
	_new_page("Controls", tr("Controls"))
	_group(tr("Steering"))
	_toggle(app.library.text(14), "controls", "invert", false)
	_toggle(tr("Hold autopilot for the list"), "controls", "autopilot_hold", false)
	_note(tr("A tap works the autopilot as the original's key does; holding the key half a second opens the autopilot list. Off, the key acts the moment it is pressed."))
	var helms := ["direct", "smooth"]
	_choice(tr("Helm response"), [tr("Direct"), tr("Smooth")], maxi(0, helms.find(str(app.setting("controls", "helm", "direct")))),
		func(i): app.set_setting("controls", "helm", helms[i]))
	_note(tr("Direct turns at full rate the moment you steer, as the original; Smooth eases in and out."))
	if not OS.has_feature("mobile"):
		_toggle(tr("Mouse steering"), "controls", "mouse", true)
		_slider(tr("Mouse sensitivity"), "controls", "mouse_sensitivity", 1.0, 0.3, 3.0, 0.1)
		_toggle(tr("Capture the pointer in flight"), "controls", "capture_mouse", true)
		_note(tr("Moving the mouse turns the ship directly, as fast as it can turn; menus and pauses free the pointer."))
		_toggle(tr("Pause when the window loses focus"), "controls", "pause_on_focus_loss", false)
		var strafe_modes := ["auto", "always", "never"]
		_choice(tr("Left / right keys"), [tr("Strafe while the mouse steers"), tr("Always strafe"), tr("Always turn")],
			maxi(0, strafe_modes.find(str(app.setting("controls", "strafe", "auto")))),
			func(i): app.set_setting("controls", "strafe", strafe_modes[i]))
		_note(tr("Strafing slides the ship sideways while the mouse turns it, as in Deep."))
	_toggle(app.library.text(13), "controls", "auto_fire", false)
	if OS.has_feature("mobile"):
		_toggle(tr("Steer by tilting"), "controls", "tilt", false, func(on):
			if on: Prefs.calibrate_tilt(app))
		_slider(tr("Tilt sensitivity"), "controls", "tilt_sensitivity", 1.0, 0.4, 2.5, 0.1)
		box.add_child(UI.button(tr("Calibrate tilt (use the current grip)"), func(): Prefs.calibrate_tilt(app)))
		_note(tr("Tilt turns the ship alongside the stick; hold the device as you play and calibrate."))
	_group(tr("Gamepad"))
	_note(tr("Gamepad connected.") if not Input.get_connected_joypads().is_empty() else tr("No gamepad connected."))
	_slider(tr("Stick deadzone"), "controls", "deadzone", 0.2, 0.05, 0.5, 0.01, false, "%.2f", func(_v):
		Prefs.apply_bindings(app, Controls.ACTIONS))
	_toggle(tr("Vibration"), "controls", "vibration", true)
	_note(tr("A hit rumbles the gamepad and, on phones and tablets, the device itself."))
	_group(tr("Touch"))
	var modes := ["auto", "on", "off"]
	_choice(tr("Touch controls"), [tr("Automatic"), tr("On"), tr("Off")], maxi(0, modes.find(str(app.setting("controls", "touch", "auto")))),
		func(i): app.set_setting("controls", "touch", modes[i]))
	_slider(tr("Touch control size"), "controls", "touch_scale", 1.0, 0.7, 1.4, 0.05, true)
	_toggle(tr("Stick fixed in place"), "controls", "touch_fixed_stick", false)
	_note(tr("Off: the stick comes to your thumb wherever it lands on its side of the screen."))
	_toggle(tr("Steer from anywhere"), "controls", "touch_steer_anywhere", false)
	_note(tr("On: no resting stick; a finger on any free part of the screen steers from where it lands. Looking around by dragging is off while it is on."))
	_toggle(tr("Left-handed layout"), "controls", "touch_mirror", false)
	_note(tr("Puts the stick on the right and the buttons on the left."))
	_toggle(tr("Look around by dragging"), "controls", "touch_look", true)
	_slider(tr("Look sensitivity"), "controls", "touch_look_sensitivity", 1.0, 0.5, 2.0, 0.1, false, "%.1f×")
	_note(tr("A finger on free screen space swings the view round the ship; letting go looks ahead again."))
	var place := UI.button(tr("Adjust control placement…"), func(): pass)
	place.pressed.connect(func():
		var editor := preload("res://src/screens/touch_layout_editor.gd").new()
		editor.app = app
		editor.closed.connect(func():
			get_tree().call_group("touch_controls", "_layout")
			if is_instance_valid(place): place.grab_focus.call_deferred())
		app.add_child(editor))
	box.add_child(place)
	_group(tr("Keyboard"))
	if not binding.is_empty():
		_note(tr("Press a key for %s. Esc cancels.") % Prefs.action_name(binding), UI.TEXT_GOOD)
	else:
		_note(tr("Select an action, then press its new key."))
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 12)
	box.add_child(grid)
	for action in Prefs.BINDABLE:
		var l := UI.label(Prefs.action_name(action), 14, UI.TEXT_DIM)
		l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		grid.add_child(l)
		var b := UI.button("…" if binding == action else Prefs.key_name(action), func():
			binding = action
			_build())
		b.custom_minimum_size.x = 150
		b.alignment = HORIZONTAL_ALIGNMENT_CENTER
		grid.add_child(b)
	box.add_child(UI.button(tr("Restore default keys"), func():
		for action in Prefs.BINDABLE:
			if app.settings.has_section_key("keys", action): app.settings.erase_section_key("keys", action)
		for action in Prefs.BINDABLE:
			if InputMap.has_action(action): InputMap.erase_action(action)
		Controls.ensure_actions()
		Prefs.apply_bindings(app, Controls.ACTIONS)
		_build()))
	_group(tr("Reference"))
	for line in [tr("Mouse or stick steers · left mouse / RT fires · right mouse / LB secondary"),
		tr("Aim at a station, gate, star or asteroid until it locks, then fire to use it"),
		tr("Hold Alt and move the mouse, or use the right stick, to look around the ship"),
		tr("Gamepad: A boost · Y autopilot · X next target · Back actions · Start pause")]:
		_note(line)

func _interface_page() -> void:
	_new_page("Interface", tr("Interface"))
	_group(tr("Flight display"))
	var styles := ["original", "extended"]
	_choice(tr("Flight display"), [tr("Original"), tr("Extended")], maxi(0, styles.find(str(app.setting("interface", "hud_style", "original")))), func(i):
		app.set_setting("interface", "hud_style", styles[i]))
	_note(tr("Original: the game's own corner panels, icons and bars. Extended: plates with the location, figures for hull, armour and shield, the weapon bank, the target and a radar scope."))
	_slider(tr("HUD size"), "interface", "hud_scale", 1.0, 0.7, 1.6, 0.05, true)
	_slider(tr("HUD opacity"), "interface", "hud_opacity", 1.0, 0.35, 1.0, 0.05, true)
	_toggle(tr("Control hints"), "interface", "hints", true)
	_note(tr("A short reminder of the flight keys at the bottom of the screen."))
	_toggle(tr("Help pop-ups"), "interface", "help_popups", true)
	_note(tr("The original's short explanations the first time you meet a feature."))
	box.add_child(UI.button(tr("Show all help pop-ups again"), func():
		preload("res://src/presentation/tips.gd").reset(app)
		_build()))
	_toggle(tr("Launch sequence"), "interface", "launch_sequence", true)
	_note(tr("As in the original, each flight opens with a few seconds watching your ship leave, with the system's details and a tip. A key, click or tap skips it."))
	_toggle(tr("Radar scope"), "interface", "radar_scope", true)
	_note(tr("A round radar on the Extended flight display. Not part of the original, which marks ships only on screen and at its edges."))
	_toggle(tr("Object labels"), "interface", "labels", true)
	_note(tr("Names and distances beside stations, gates and the target."))
	_toggle(tr("Screen transitions"), "interface", "transitions", true)
	_note(tr("A short fade when launching, docking and jumping."))
	_group(tr("Menus"))
	_slider(tr("Text size"), "interface", "text_size", 16, 13, 24, 1, false, tr("%d px"), func(_v):
		app.set_ui_theme(UI.make_theme(Prefs.text_size(app))))
	_group(tr("Accessibility"))
	_toggle(tr("Colour-blind friendly colours"), "access", "colour_safe", false)
	_note(tr("Orange enemies and blue friends instead of red and green, in the HUD and radar."))
	_toggle(tr("Reduce flashing"), "access", "reduce_flashing", false)
	_note(tr("Softens full-screen flashes from story events and jumps."))
	_toggle(tr("Screen shake"), "access", "screen_shake", true)
	_slider(tr("Message time"), "access", "message_time", 1.0, 1.0, 3.0, 0.25, false, "%.2f×")
	_note(tr("How long flight messages stay on screen."))

func _game_page() -> void:
	var lib = app.library
	_new_page("Game", tr("Game"))
	var langs: Array = lib.data.languages.keys()
	if langs.size() > 1:
		_choice(lib.text(12), langs, langs.find(lib.language), func(i):
			app.set_setting("content", "language", langs[i])
			app.activate(app.library.id)
			_relabel())
	# The engine's own text: Auto follows the game's language.
	var codes := EngineLanguage.codes()
	var chosen := str(app.setting("interface", "language", EngineLanguage.AUTO))
	var automatic := EngineLanguage.resolve(EngineLanguage.AUTO, app.content_language)
	var language_names: Array = [tr("Auto · %s") % EngineLanguage.native_name(automatic)]
	for code in codes: language_names.append(EngineLanguage.native_name(code))
	_choice(tr("Engine language"), language_names, codes.find(chosen) + 1, func(i):
		app.set_setting("interface", "language", EngineLanguage.AUTO if i == 0 else codes[i - 1])
		_relabel())
	_note(tr("Menus, settings and messages this engine adds. Auto matches the game's language."))
	box.add_child(UI.button(tr("Import a different JAR…"), func(): app.show_import()))
	# The original lists its credits under Options.
	box.add_child(UI.button(lib.text(21), _open_over.bind(preload("res://src/screens/credits_panel.gd"))))
	box.add_child(UI.button(tr("Mods"), _open_over.bind(preload("res://src/screens/mods_panel.gd"))))

## Builds the pages again, and the page picker with them, after a language
## change: every caption is in the old language until it is redrawn.
func _relabel() -> void:
	title = app.library.text(3)
	content.title = app.library.text(3)
	for c in nav.get_children():
		nav.remove_child(c)
		c.queue_free()
	_build()

## Opens another page in place of Options, coming back here when it closes.
func _open_over(script) -> void:
	var p = script.new()
	p.app = app
	var holder := get_parent()
	visible = false
	p.closed.connect(func():
		if is_instance_valid(p) and not p.is_queued_for_deletion(): p.queue_free()
		visible = true
		_build())
	holder.add_child(p)

# ------------------------------------------------------------------ rows

func _unhandled_input(event: InputEvent) -> void:
	if not binding.is_empty() or not is_visible_in_tree(): return
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		closed.emit()
		queue_free()
	# Shoulder buttons switch tabs, as in most console menus.
	elif event is InputEventJoypadButton and event.pressed and event.button_index in [JOY_BUTTON_LEFT_SHOULDER, JOY_BUTTON_RIGHT_SHOULDER]:
		get_viewport().set_input_as_handled()
		var step := -1 if event.button_index == JOY_BUTTON_LEFT_SHOULDER else 1
		tabs.current_tab = posmod(tabs.current_tab + step, tabs.get_tab_count())

func _input(event: InputEvent) -> void:
	if binding.is_empty() or not (event is InputEventKey) or not event.pressed or event.echo: return
	get_viewport().set_input_as_handled()
	var code: int = event.physical_keycode if event.physical_keycode != 0 else event.keycode
	if code != KEY_ESCAPE:
		app.set_setting("keys", binding, code)
		Prefs.apply_bindings(app, Controls.ACTIONS)
	binding = ""
	_build()

func _group(text: String) -> void:
	var l := UI.label(text.to_upper(), 15, UI.ACCENT)
	if box.get_child_count() > 0:
		var gap := Control.new()
		gap.custom_minimum_size.y = 6
		box.add_child(gap)
	box.add_child(l)

func _note(text: String, color := UI.TEXT_DIM) -> void:
	box.add_child(UI.paragraph(text, 13, color))

func _toggle(text: String, section: String, key: String, fallback: bool, then := Callable()) -> void:
	# The label, then the switch and its On/Off word at the right.
	var row := HBoxContainer.new()
	var l := UI.label(text, 16)
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	l.mouse_filter = Control.MOUSE_FILTER_STOP
	row.add_child(l)
	var c := CheckButton.new()
	c.button_pressed = bool(app.setting(section, key, fallback))
	c.tooltip_text = text
	row.add_child(c)
	var state := UI.label("", 15, UI.TEXT_DIM)
	state.custom_minimum_size.x = 34
	var show := func(on: bool): state.text = tr("On") if on else tr("Off")
	show.call(c.button_pressed)
	row.add_child(state)
	l.gui_input.connect(func(e):
		if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT: c.button_pressed = not c.button_pressed)
	c.toggled.connect(func(on):
		show.call(on)
		app.set_setting(section, key, on)
		if then.is_valid(): then.call(on))
	box.add_child(row)

func _choice(text: String, names: Array, current: int, choose: Callable) -> OptionButton:
	var row := HBoxContainer.new()
	var l := UI.label(text, 16)
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(l)
	var pick := OptionButton.new()
	for n in names: pick.add_item(str(n))
	pick.selected = current
	pick.custom_minimum_size.x = 210
	pick.item_selected.connect(choose)
	row.add_child(pick)
	box.add_child(row)
	return pick

func _slider(text: String, section: String, key: String, fallback: float, low: float, high: float, step: float,
		percent := false, format := "%.1f", then := Callable()) -> void:
	var row := HBoxContainer.new()
	var l := UI.label(text, 16)
	l.custom_minimum_size.x = 200
	row.add_child(l)
	var s := HSlider.new()
	s.min_value = low
	s.max_value = high
	s.step = step
	s.value = float(app.setting(section, key, fallback))
	s.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	s.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var shown := UI.label("", 14, UI.TEXT_DIM)
	shown.custom_minimum_size.x = 64
	shown.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	var describe := func(v: float): shown.text = ("%d%%" % int(round(v * 100))) if percent else (format % v)
	describe.call(s.value)
	s.value_changed.connect(func(v):
		describe.call(v)
		app.set_setting(section, key, v)
		if then.is_valid(): then.call(v))
	row.add_child(s)
	row.add_child(shown)
	box.add_child(row)
