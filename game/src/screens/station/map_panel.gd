extends BoxContainer
## The galaxy map: known systems at their map positions with the gate links
## between them, the systems' stations, and departure towards a chosen
## destination. Only systems linked to the current system's jump gate can be
## chosen, unless the ship carries a jump drive.

const Showroom := preload("res://src/presentation/ship_preview.gd")
const UI := preload("res://src/presentation/ui.gd")
const Common := preload("res://src/screens/station/common.gd")
const PortalView := preload("res://src/presentation/map_portal_view.gd")
const Navigation := preload("res://src/simulation/navigation.gd")
const JavaRandom := preload("res://src/simulation/java_random.gd")
const Assembly := preload("res://src/presentation/assembly.gd")
## The original's planet sizes on its system map, by planet picture.
## The original's orange for the chosen entry.
const CHOSEN := Color8(0xff, 0x9a, 0x2e)
const PLANET_SIZES := [320, 192, 256, 256, 192, 256, 192, 192, 320, 256, 192, 192, 320, 256, 320, 256, 256, 256, 320, 192]

var station
var app
var game
var canvas: Control
var side: VBoxContainer
var showroom
var selected_system := -1
var portal_view: PortalView
var flight = null
var flight_mode := "route"
var search: LineEdit
var frame: UI.Frame
## The system shown close up (the original's system map), or -1 on the chart.
var system_view := -1
## The station picked in the system view, by its place in the system's list.
var planet := 0
var _orbits := {}
## The chart's star sprites by star kind (see _star_sprite).
var _stars := {}
## StarMap's discovery scene after bought coordinates: the new system's star
## grows over DISCOVER_MS on the chart, and its gate links and details appear
## only once it has; until then only Back works.
const DISCOVER_MS := 4000.0
var discover := -1
var discover_ms := 0.0

## Wheel or pinch zooms about the pointer, a drag pans, and a click or tap
## that did not move picks the system under it.
class MapCanvas extends Control:
	const DRAG := 8.0
	var panel
	var press_at := Vector2.ZERO
	var pressed := false
	var dragged := false
	var touches := {}
	var pinch_span := 0.0
	var triggers := {}
	func _draw() -> void:
		panel._draw_map(self)
	func _gui_input(event: InputEvent) -> void:
		if event is InputEventScreenTouch:
			if event.pressed: touches[event.index] = event.position
			else: touches.erase(event.index)
			pinch_span = _span()
			if touches.size() > 1: dragged = true
		elif event is InputEventScreenDrag and touches.has(event.index):
			touches[event.index] = event.position
			if touches.size() > 1:
				var span := _span()
				if pinch_span > 0.0 and span > 0.0: panel.zoom_at(self, _middle(), span / pinch_span)
				pinch_span = span
				accept_event()
		elif event is InputEventMagnifyGesture:
			panel.zoom_at(self, event.position, event.factor)
			accept_event()
		elif event is InputEventMouseButton:
			if event.pressed and event.button_index in [MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_DOWN]:
				panel.zoom_at(self, event.position, 1.15 if event.button_index == MOUSE_BUTTON_WHEEL_UP else 1.0 / 1.15)
				accept_event()
			elif event.button_index in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_RIGHT, MOUSE_BUTTON_MIDDLE]:
				if event.pressed:
					pressed = true
					dragged = touches.size() > 1
					press_at = event.position
				elif pressed:
					pressed = false
					if not dragged and event.button_index == MOUSE_BUTTON_LEFT: panel._pick(self, event.position)
					elif not dragged and event.button_index == MOUSE_BUTTON_RIGHT and panel.system_view >= 0: panel.close_system()
				# A double click opens the system, or picks the station as a destination.
				if event.pressed and event.double_click and event.button_index == MOUSE_BUTTON_LEFT:
					panel._pick(self, event.position)
					panel._accept()
					accept_event()
		elif event is InputEventMouseMotion and pressed and touches.size() < 2:
			if event.position.distance_to(press_at) > DRAG: dragged = true
			if dragged: panel.pan_by(self, event.relative)
		# Keys and pads step to the nearest known system in a direction.
		for dir in [["ui_left", Vector2.LEFT], ["ui_right", Vector2.RIGHT], ["ui_up", Vector2.UP], ["ui_down", Vector2.DOWN]]:
			if event.is_action_pressed(dir[0]):
				panel._step_selection(self, dir[1])
				accept_event()
				return
		if event.is_action_pressed("ui_accept"):
			panel._accept()
			accept_event()
		if event.is_action_pressed("ui_cancel") and panel.system_view >= 0:
			panel.close_system()
			accept_event()
		# Pad triggers, or + and -, zoom the chart.
		if event is InputEventJoypadMotion and event.axis in [JOY_AXIS_TRIGGER_LEFT, JOY_AXIS_TRIGGER_RIGHT]:
			var pulled: bool = event.axis_value > 0.6
			if pulled and not triggers.get(event.axis, false):
				panel._gui_zoom_step(1.25 if event.axis == JOY_AXIS_TRIGGER_RIGHT else 0.8)
			triggers[event.axis] = pulled if pulled or event.axis_value < 0.3 else triggers.get(event.axis, false)
			accept_event()
		if event is InputEventKey and event.pressed and event.keycode in [KEY_EQUAL, KEY_PLUS, KEY_KP_ADD, KEY_MINUS, KEY_KP_SUBTRACT]:
			panel._gui_zoom_step(0.8 if event.keycode in [KEY_MINUS, KEY_KP_SUBTRACT] else 1.25)
			accept_event()
	func _span() -> float:
		if touches.size() < 2: return 0.0
		var p: Array = touches.values()
		return (p[0] as Vector2).distance_to(p[1])
	func _middle() -> Vector2:
		var p: Array = touches.values()
		return ((p[0] as Vector2) + (p[1] as Vector2)) / 2.0

func _ready() -> void:
	app = station.app if flight == null else flight.app
	game = station.game if flight == null else flight.game
	add_theme_constant_override("separation", 10)
	frame = UI.Frame.new(app.library.text(72))
	frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(frame)
	canvas = MapCanvas.new()
	canvas.panel = self
	canvas.custom_minimum_size = Vector2(420, 360)
	canvas.size_flags_vertical = Control.SIZE_EXPAND_FILL
	canvas.focus_mode = Control.FOCUS_ALL
	canvas.clip_contents = true
	frame.add_child(canvas)
	var info := UI.Frame.new(app.library.text(126))
	info.custom_minimum_size.x = 320
	add_child(info)
	var column := VBoxContainer.new()
	info.add_child(column)
	# The station under the pointer or highlight, turning in a showroom.
	showroom = Showroom.new()
	showroom.library = app.library
	showroom.custom_minimum_size = Vector2(280, 130)
	column.add_child(showroom)
	search = LineEdit.new()
	search.placeholder_text = "Search stations…"
	search.clear_button_enabled = true
	search.text_changed.connect(func(_t): _fill_side())
	column.add_child(search)
	var s := Common.scroll_list()
	s[0].size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.add_child(s[0])
	side = s[1]
	selected_system = game.session.system_index
	if not wormhole_address().is_empty():
		portal_view = PortalView.new()
		portal_view.library = app.library
		add_child(portal_view)
	_fill_side()
	# The map opens on the system you are in; choosing a jump gate's
	# destination opens on the galaxy.
	if flight_mode != "gate" and _known(game.session.system_index):
		open_system.call_deferred(game.session.system_index)

## Plays the discovery of a newly revealed system (see DISCOVER_MS).
func start_discovery(i: int) -> void:
	if app.catalogue.system(i).is_empty(): return
	discover = i
	discover_ms = 0.0
	if system_view >= 0: close_system()
	selected_system = i
	_reveal(canvas, i)
	_fill_side()

func _discovering() -> bool:
	return discover >= 0 and discover_ms < DISCOVER_MS

func _process(delta: float) -> void:
	if portal_view != null and canvas != null: canvas.queue_redraw()
	if _discovering():
		discover_ms += delta * 1000.0
		if canvas != null: canvas.queue_redraw()
		if not _discovering(): _fill_side()
	# The system view's camera eases over to the chosen planet.
	if system_view >= 0 and canvas != null and eye.distance_to(eye_goal) > 1.0:
		eye = eye.lerp(eye_goal, 1.0 - pow(0.002, delta))
		canvas.queue_redraw()

## Main/r's post-report warning follows the saved g/h address, not the
## current mission destination. Reject missing, cleared or mismatched pairs.
func wormhole_address() -> Dictionary:
	if game.session.story_step < 32: return {}
	var sid = game.session.flags.get("wormhole_station", -1)
	var sys = game.session.flags.get("wormhole_system", -1)
	if not game.session._whole(sid) or not game.session._whole(sys): return {}
	if app.catalogue.station(int(sid)).is_empty() or app.catalogue.system(int(sys)).is_empty(): return {}
	if app.catalogue.system_of_station(int(sid)) != int(sys): return {}
	return {"station": int(sid), "system": int(sys)}

## A later Void mission has station -1. The source map locates its story
## marker at the known portal only after step32; it remains a normal route.
func story_address() -> Dictionary:
	var mission: Dictionary = game.session.story_mission
	if mission.is_empty() or not bool(mission.get("visible", true)): return {}
	var sid := int(mission.get("station", -2))
	if sid == -1 and game.session.story_step > 32: return wormhole_address()
	var sys: int = app.catalogue.system_of_station(sid)
	return {"station": sid, "system": sys} if sys >= 0 else {}

func _marker(texture: Texture2D, extent: int) -> TextureRect:
	var icon := TextureRect.new()
	icon.texture = texture
	icon.custom_minimum_size = Vector2(extent, extent)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return icon

func _known(i: int) -> bool:
	return Navigation.known(game.session, app.catalogue, i)

func _reachable(i: int) -> bool:
	if i == game.session.system_index: return true
	if flight != null and flight_mode == "gate": return Navigation.linked(game.session, app.catalogue, i)
	if bool(game.session.ship_stats().jump_drive): return true
	var links: Array = app.catalogue.system(game.session.system_index).get("links", [])
	# Cached JSON numbers are floats; Array.has uses strict Variant types.
	# Compare system IDs numerically without changing the supplied graph.
	for link in links:
		if int(link) == i: return true
	return false

func _map_rect(c: Control) -> Rect2:
	return Rect2(Vector2(20, 20), c.size - Vector2(40, 40))

func _to_screen(c: Control, sys: Dictionary) -> Vector2:
	var r := _map_rect(c)
	var at := r.position + Vector2(float(sys.x) / 100.0 * r.size.x, float(sys.y) / 100.0 * r.size.y)
	return r.get_center() + (at - r.get_center()) * zoom + pan

## The chart's zoom (1 shows it whole) and how far it is panned.
var zoom := 1.0
var pan := Vector2.ZERO
const MAX_ZOOM := 4.0

## Zooms keeping the point under `at` where it is.
func zoom_at(c: Control, at: Vector2, factor: float) -> void:
	if system_view >= 0:
		_zoom_system(c, factor)
		return
	var z := clampf(zoom * factor, 1.0, MAX_ZOOM)
	var centre := _map_rect(c).get_center()
	pan = (at - centre) - (at - centre - pan) * (z / zoom)
	zoom = z
	_clamp_pan(c)

func pan_by(c: Control, delta: Vector2) -> void:
	if system_view >= 0:
		_pan_system(c, delta)
		return
	pan += delta
	_clamp_pan(c)

func _clamp_pan(c: Control) -> void:
	var reach := _map_rect(c).size * (zoom - 1.0) / 2.0
	pan = pan.clamp(-reach, reach)
	c.queue_redraw()

## Brings a system into view when the keys or pad step to it off the chart.
func _reveal(c: Control, i: int) -> void:
	var r := _map_rect(c).grow(-30)
	var p := _to_screen(c, app.catalogue.system(i))
	if r.has_point(p): return
	pan += r.get_center() - p
	_clamp_pan(c)

func _gui_zoom_step(factor: float) -> void:
	zoom_at(canvas, _map_rect(canvas).get_center(), factor)

func _draw_map(c: Control) -> void:
	if system_view >= 0:
		_draw_system(c)
		return
	var cat = app.catalogue
	var warning := wormhole_address()
	var story := story_address()
	c.draw_rect(Rect2(Vector2.ZERO, c.size), Color.BLACK)
	# The original's chart lies over its fog picture, tiled and following the pan.
	var fog: Texture2D = app.library.texture("fog")
	if fog != null:
		var step := fog.get_size() * 2.0
		var from := Vector2(fposmod(pan.x, step.x), fposmod(pan.y, step.y)) - step
		var y := from.y
		while y < c.size.y:
			var x := from.x
			while x < c.size.x:
				c.draw_texture_rect(fog, Rect2(Vector2(x, y), step), false)
				x += step.x
			y += step.y
	var here: int = game.session.system_index
	for i in cat.system_count():
		if not _known(i): continue
		var a := _to_screen(c, cat.system(i))
		for j in cat.system(i).get("links", []):
			if int(j) < i or not _known(int(j)): continue
			if _discovering() and (i == discover or int(j) == discover): continue
			var b := _to_screen(c, cat.system(int(j)))
			# The game's own map help: a dotted line marks the systems this
			# system's jump gate reaches.
			if i == here or int(j) == here: c.draw_dashed_line(a, b, Color(UI.TEXT, 0.85), 2.0, 3.0, true, true)
			else: c.draw_line(a, b, UI.BORDER, 1.5)
	# The last trips, as a fading gold line ending where you are.
	var trail: Array = (game.session.flags.get("recent_systems", []) as Array).duplicate()
	if trail.is_empty() or int(trail.back()) != here: trail.append(here)
	for n in range(1, trail.size()):
		var a0 := int(trail[n - 1])
		var a1 := int(trail[n])
		if a0 == a1 or not _known(a0) or not _known(a1): continue
		var fade := float(n) / float(trail.size() - 1)
		c.draw_line(_to_screen(c, cat.system(a0)), _to_screen(c, cat.system(a1)), Color(0.95, 0.76, 0.3, 0.2 + 0.6 * fade), 3.0, true)
	# The way to the story's and the job's destinations over known gates,
	# dashed in the colour of their markers.
	var job_system: int = cat.system_of_station(int(game.session.job.get("station", -2))) if not game.session.job.is_empty() else -1
	for goal in [[int(story.get("system", -1)), Color(0.98, 0.78, 0.2, 0.85)], [job_system, Color(0.45, 0.8, 1.0, 0.85)]]:
		var path := route(here, int(goal[0]))
		for n in range(1, path.size()):
			c.draw_dashed_line(_to_screen(c, cat.system(path[n - 1])), _to_screen(c, cat.system(path[n])), goal[1], 2.0, 7.0, true, true)
	var glow: Texture2D = app.library.texture("map_sun_glow")
	for i in cat.system_count():
		if not _known(i): continue
		var sys: Dictionary = cat.system(i)
		var p := _to_screen(c, sys)
		if glow != null and not (_discovering() and i == discover):
			c.draw_texture_rect(glow, Rect2(p - Vector2(14, 14), Vector2(28, 28)), false, Color(1, 1, 1, 0.8))
		var col := UI.TEXT if _reachable(i) else UI.TEXT_DIM
		if i == here: col = UI.TEXT_GOOD
		var star := _star_sprite(int(sys.get("star", 0)))
		var growing: bool = _discovering() and i == discover
		if growing:
			# Only the growing star: no glow, ring or name until it has formed.
			var g := 15.0 * discover_ms / DISCOVER_MS
			if star != null: c.draw_texture_rect(star, Rect2(p - Vector2(g, g), Vector2(g, g) * 2.0), false)
			else: c.draw_circle(p, maxf(6.0 * discover_ms / DISCOVER_MS, 0.5), col)
			continue
		if star != null:
			var r := 12.0 if i != selected_system else 15.0
			c.draw_texture_rect(star, Rect2(p - Vector2(r, r), Vector2(r, r) * 2.0), false, Color.WHITE if _reachable(i) else Color(1, 1, 1, 0.55))
		else:
			c.draw_circle(p, 4.0 if i != selected_system else 6.0, col)
		if i == selected_system: c.draw_arc(p, 10.0, 0, TAU, 24, UI.GREEN, 2.0)
		var has_portal: bool = int(warning.get("system", -1)) == i
		if has_portal and portal_view != null:
			c.draw_texture_rect(portal_view.get_texture(), Rect2(p - Vector2(24, 24), Vector2(48, 48)), false)
		var font := c.get_theme_default_font()
		c.draw_string(font, p + Vector2(28 if has_portal else 8, -6), str(sys.name), HORIZONTAL_ALIGNMENT_LEFT, -1, 13, col)
		if int(story.get("system", -1)) == i:
			var mark: Texture2D = app.library.texture("menu_map_mainmission")
			if mark: c.draw_texture_rect(mark, Rect2(p + Vector2(-18, -18), mark.get_size()), false)
		var job: Dictionary = game.session.job
		if not job.is_empty() and cat.system_of_station(int(job.get("station", -2))) == i:
			var mark2: Texture2D = app.library.texture("menu_map_sidemission")
			if mark2: c.draw_texture_rect(mark2, Rect2(p + Vector2(6, -18), mark2.get_size()), false)

## The original's chart star: its map_3d_sun sprite, a diamond of four
## triangles from the space texture, posed at the frame of the system's star
## kind and drawn additively. Built once per kind as a picture whose black
## is see-through, which looks the same over the dark chart.
func _star_sprite(kind: int) -> Texture2D:
	if _stars.has(kind): return _stars[kind]
	var lib = app.library
	var model: Dictionary = lib.model_data("map_3d_sun")
	var tex: Texture2D = lib.atlas_texture("space")
	_stars[kind] = null
	if model.is_empty() or tex == null: return null
	var src: Image = tex.get_image()
	if src.is_compressed(): return null
	var mask := Assembly.frame_pattern(lib.animation("map_3d_sun"), kind)
	var verts: Array = model.vertices
	var n := 32
	var tris: Array = []
	for poly: Dictionary in model.polygons:
		var pat := int(poly.pattern)
		if pat != 0 and (pat & mask) == 0: continue
		var pts: Array = []
		var uvs: Array = []
		for j in 3:
			var v := int(poly.indices[j]) * 3
			pts.append(Vector2(float(verts[v]), -float(verts[v + 1])) / 4096.0 * n + Vector2(n, n) / 2.0)
			uvs.append(Vector2(float(poly.attributes[j * 5]), float(poly.attributes[j * 5 + 1])))
		tris.append([pts, uvs])
	if tris.is_empty(): return null
	var img := Image.create(n, n, false, Image.FORMAT_RGBA8)
	for y in n:
		for x in n:
			var q := Vector2(x + 0.5, y + 0.5)
			for t in tris:
				var a: Vector2 = t[0][0]; var b: Vector2 = t[0][1]; var c: Vector2 = t[0][2]
				var d := (b - a).cross(c - a)
				if absf(d) < 0.001: continue
				var w1 := (q - a).cross(c - a) / d
				var w2 := (b - a).cross(q - a) / d
				var w0 := 1.0 - w1 - w2
				if w0 < -0.01 or w1 < -0.01 or w2 < -0.01: continue
				var uv: Vector2 = t[1][0] * w0 + t[1][1] * w1 + t[1][2] * w2
				var col := src.get_pixel(clampi(int(uv.x), 0, src.get_width() - 1), clampi(int(uv.y), 0, src.get_height() - 1))
				var lum := maxf(col.r, maxf(col.g, col.b))
				if lum > 0.0: img.set_pixel(x, y, Color(col.r / lum, col.g / lum, col.b / lum, lum))
				break
	_stars[kind] = ImageTexture.create_from_image(img)
	return _stars[kind]

## The fewest gate jumps from one system to another through known systems:
## the systems along the way, both ends included, or [] when there is none.
func route(from: int, to: int) -> Array:
	if from < 0 or to < 0 or from == to or not _known(to): return []
	var came := {from: -1}
	var queue := [from]
	while not queue.is_empty():
		var at: int = queue.pop_front()
		if at == to: break
		for link in app.catalogue.system(at).get("links", []):
			var next := int(link)
			if came.has(next) or not _known(next): continue
			came[next] = at
			queue.append(next)
	if not came.has(to): return []
	var path := [to]
	while int(path[0]) != from: path.push_front(came[path[0]])
	return path

func _pick(c: Control, at: Vector2) -> void:
	if _discovering(): return
	if system_view >= 0:
		_pick_planet(c, at)
		return
	var best := -1
	var best_d := 24.0
	for i in app.catalogue.system_count():
		if not _known(i): continue
		var d := at.distance_to(_to_screen(c, app.catalogue.system(i)))
		if d < best_d: best_d = d; best = i
	# One click opens the system's planets.
	if best >= 0: open_system(best)

## Moves the selection to the nearest known system roughly in `dir`.
func _step_selection(c: Control, dir: Vector2) -> void:
	if _discovering(): return
	if system_view >= 0:
		_step_planet(c, dir)
		return
	var from := _to_screen(c, app.catalogue.system(selected_system))
	var best := -1
	var best_score := INF
	for i in app.catalogue.system_count():
		if i == selected_system or not _known(i): continue
		var d := _to_screen(c, app.catalogue.system(i)) - from
		if d.length() < 1.0 or d.normalized().dot(dir) < 0.5: continue
		var score := d.length() * (2.0 - d.normalized().dot(dir))
		if score < best_score:
			best_score = score
			best = i
	if best >= 0:
		selected_system = best
		_reveal(c, best)
		c.queue_redraw()
		_fill_side()

func _focus_side() -> void:
	for ch in side.get_children():
		var b: Button = ch if ch is Button else (ch.get_child(0) if ch.get_child_count() > 0 and ch.get_child(0) is Button else null)
		if b != null and not b.disabled:
			b.grab_focus()
			return

func _fill_side() -> void:
	for ch in side.get_children(): ch.queue_free()
	var cat = app.catalogue
	if search != null and not search.text.strip_edges().is_empty():
		_fill_search(search.text.strip_edges().to_lower())
		return
	# The original shows the new system's details once its star has formed.
	if _discovering(): return
	var sys: Dictionary = cat.system(selected_system)
	side.add_child(UI.label(str(sys.name), 18))
	side.add_child(UI.label("%s: %s" % [app.library.text(219), cat.faction_name(int(sys.faction))], 14, UI.TEXT_DIM))
	side.add_child(UI.label("%s: %s" % [app.library.text(220), app.library.text(225 + int(sys.safety))], 14, UI.TEXT_DIM))
	if selected_system != game.session.system_index:
		side.add_child(UI.label("%.0f km" % cat.travel_distance(game.session.system_index, selected_system), 14, UI.TEXT_DIM))
	# The original's softkeys: Zoom into the chosen system, Back out of it.
	# In a system its planets are chosen on the map itself, not listed here.
	if system_view < 0:
		side.add_child(UI.button(app.library.text(221), func(): open_system(selected_system)))
	else:
		side.add_child(UI.button(app.library.text(65), close_system))
		# The original's Key: what the markers after a station's name mean.
		for key in [["menu_map_visited", 224], ["menu_map_mainmission", 278], ["menu_map_sidemission", 279], ["menu_map_jumpgate", 271]]:
			var line := HBoxContainer.new()
			line.add_child(_marker(app.library.texture(key[0]), 16))
			line.add_child(UI.label(app.library.text(key[1]), 13, UI.TEXT_DIM))
			side.add_child(line)
	var reachable := _reachable(selected_system)
	var warning := wormhole_address()
	var story := story_address()
	if not reachable:
		side.add_child(UI.paragraph(app.library.text(241), 14, UI.TEXT_WARN))
	if int(warning.get("system", -1)) == selected_system:
		side.add_child(UI.paragraph("%s: %s" % [app.library.text(269), cat.station_name(int(warning.station))], 14, UI.TEXT_WARN))
	# In a system the planets are chosen on the map itself; the card shows
	# the chosen one and flies there.
	if system_view >= 0:
		var stations: Array = sys.get("stations", [])
		if planet >= 0 and planet < stations.size():
			var sid := int(stations[planet])
			var st: Dictionary = cat.station(sid)
			side.add_child(HSeparator.new())
			var head := HBoxContainer.new()
			var title := UI.label(str(st.get("name", "?")), 18, CHOSEN)
			title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			head.add_child(title)
			if int(story.get("station", -1)) == sid:
				head.add_child(_marker(app.library.texture("menu_map_mainmission"), 24))
				title.set_meta("story_station", sid)
			if int(warning.get("station", -1)) == sid and portal_view != null:
				head.add_child(_marker(portal_view.get_texture(), 24))
				title.set_meta("wormhole_station", sid)
			side.add_child(head)
			side.add_child(UI.label("%s: %d" % [app.library.text(37), int(st.get("tech", 0))], 14, UI.TEXT_DIM))
			if sid == game.session.station_id:
				side.add_child(UI.label("◄ You are here", 14, UI.TEXT_DIM))
			else:
				var verb: String = "Fly to" if flight != null else app.library.text(239) + " →"
				var go := UI.button("%s %s" % [verb, st.get("name", "?")], _choose.bind(sid), reachable)
				go.set_meta("station", sid)
				for key in ["story_station", "wormhole_station"]:
					if title.has_meta(key): go.set_meta(key, sid)
				side.add_child(go)
			_show_station(sid)
	side.add_child(HSeparator.new())
	if flight != null:
		side.add_child(UI.button("Back to flight", flight.close_navigation))
	else:
		side.add_child(UI.button(app.library.text(239), func(): _confirm_depart({})))

## Stations of the known systems whose name or system matches the search.
func _fill_search(query: String) -> void:
	var cat = app.catalogue
	var found := 0
	for i in cat.system_count():
		if not _known(i): continue
		var sys: Dictionary = cat.system(i)
		for sid in sys.get("stations", []):
			var name: String = cat.station_name(int(sid))
			if not (query in name.to_lower() or query in str(sys.name).to_lower()): continue
			found += 1
			side.add_child(UI.button("%s  ·  %s" % [name, sys.name], func():
				selected_system = i
				search.text = ""
				canvas.queue_redraw()
				_fill_side()))
	if found == 0: side.add_child(UI.paragraph("No known station matches.", 14, UI.TEXT_DIM))

## Puts a station in the card's showroom.
func _show_station(station_id: int) -> void:
	if showroom == null or showroom.station_id == station_id: return
	var cat = app.catalogue
	var system: int = cat.system_of_station(station_id)
	if system < 0 or cat.station(station_id).is_empty(): return
	showroom.show_station(station_id, int(cat.system(system).faction))

func _choose(station_id: int) -> void:
	var system: int = app.catalogue.system_of_station(station_id)
	if station_id == game.session.station_id or not _known(system) or not _reachable(system): return
	var name: String = app.catalogue.station_name(station_id)
	_confirm_depart({"station": station_id}, "%s: %s\n%s" % [app.library.text(295), name, app.library.text(242)])

func _confirm_depart(destination: Dictionary, question := "") -> void:
	for ch in side.get_children(): ch.queue_free()
	side.add_child(UI.paragraph(question if not question.is_empty() else app.library.text(217)))
	var row := HBoxContainer.new()
	side.add_child(row)
	var yes := UI.button(app.library.text(38), _confirmed.bind(destination))
	row.add_child(yes)
	row.add_child(UI.button(app.library.text(39), _fill_side))
	yes.grab_focus.call_deferred()

func _confirmed(destination: Dictionary) -> void:
	if flight != null:
		flight.confirm_navigation(destination, flight_mode)
		return
	if not destination.is_empty():
		var sid := int(destination.get("station", -1))
		var system: int = app.catalogue.system_of_station(sid)
		if sid == game.session.station_id or not _known(system) or not _reachable(system): return
		if bool(game.session.ship_stats().jump_drive): destination = {"station": sid, "drive": true}
	station.depart(destination)

## Enter, the pad's A or a double click: on the chart this opens the chosen
## system; in a system it asks to fly to the chosen station.
func _accept() -> void:
	if _discovering(): return
	if system_view < 0:
		if _known(selected_system): open_system(selected_system)
		return
	var stations: Array = app.catalogue.system(system_view).get("stations", [])
	if planet >= 0 and planet < stations.size(): _choose(int(stations[planet]))

func open_system(i: int) -> void:
	if _discovering(): return
	system_view = i
	selected_system = i
	var stations: Array = app.catalogue.system(i).get("stations", [])
	planet = maxi(stations.find(float(game.session.station_id)), stations.find(game.session.station_id))
	planet = maxi(planet, 0)
	sys_focus = Vector3.ZERO
	sys_distance = -1.0
	_aim_eye(true)
	frame.title = "%s: %s %s" % [app.library.text(72), app.catalogue.system(i).name, app.library.text(41)]
	frame.queue_redraw()
	canvas.queue_redraw()
	_fill_side()
	if not stations.is_empty(): _show_station(int(stations[planet]))

func close_system() -> void:
	system_view = -1
	frame.title = app.library.text(72)
	frame.queue_redraw()
	canvas.queue_redraw()
	_fill_side()

## Where the original puts a system's planets: each station's planet on its
## own orbit, the orbits growing outwards and the planets spread over ten
## places around the sun, the same for every visit.
func _orbit_layout(i: int) -> Array:
	if _orbits.has(i): return _orbits[i]
	var out: Array = []
	var r := JavaRandom.new(i * 1000)
	var taken := {}
	var radius := 0
	var stations: Array = app.catalogue.system(i).get("stations", [])
	for n in stations.size():
		var slot := -1
		while slot < 0 and taken.size() < 10:
			var k := r.next_int(10)
			if not taken.has(k): taken[k] = true; slot = k
		radius = (512 if n == 0 else radius) + 128 + r.next_int(376)
		out.append({"station": int(stations[n]), "angle": TAU * float(maxi(slot, 0)) / 10.0, "radius": radius})
	_orbits[i] = out
	return out

# ------------------------------------------------------------ system view
# The original builds this view in 3D (StarMap.initStarSysMap): the planets
# on their orbits in one plane, the plane turned a sixteenth of a turn about
# two axes, and a camera with a 44° view held 4000 units in front of the
# chosen planet, easing over when the choice changes. The sun is a flat
# sprite over the system's colour. This draws the same arrangement with a
# perspective projection.

## The orbit plane's slant: a sixteenth of a turn about x and about z.
const PLANE_TURN := 22.5
const VIEW_ANGLE := 44.0
const VIEW_DISTANCE := 4000.0

var eye := Vector3.ZERO
var eye_goal := Vector3.ZERO
## A remake addition: the view first frames the whole system (the original's
## camera sat close in front of one planet) and can be dragged and zoomed.
var sys_focus := Vector3.ZERO
var sys_distance := -1.0
const SYS_NEAREST := 1500.0

static func _plane() -> Basis:
	return Basis(Vector3(0, 0, 1), deg_to_rad(PLANE_TURN)) * Basis(Vector3(1, 0, 0), deg_to_rad(-PLANE_TURN))

## Where an orbit position lies in the view's space.
static func _orbit_point(angle: float, radius: float) -> Vector3:
	return _plane() * Vector3(sin(angle) * radius, 0.0, cos(angle) * radius)

func _planet_world(o: Dictionary) -> Vector3:
	return _orbit_point(float(o.angle), float(o.radius))

## The camera's place for the chosen planet: straight in front of it.
func _aim_eye(snap: bool) -> void:
	if sys_distance < 0.0: sys_distance = _fit_distance()
	eye_goal = sys_focus + Vector3(0, 0, -sys_distance)
	if snap: eye = eye_goal

## How far back the camera stands to show every orbit.
func _fit_distance() -> float:
	var reach := 0.0
	for o in _orbit_layout(system_view): reach = maxf(reach, float(o.radius))
	if reach <= 0.0 or canvas == null or canvas.size.x <= 0.0: return VIEW_DISTANCE
	var fit := minf(canvas.size.x, canvas.size.y) * 0.42
	return maxf(VIEW_DISTANCE, reach * _focal(canvas) / fit + reach * 0.4)

func _zoom_system(c: Control, factor: float) -> void:
	var far := _fit_distance() * 1.6
	sys_distance = clampf(sys_distance / factor, SYS_NEAREST, far)
	_aim_eye(false)
	c.queue_redraw()

## A drag moves the system with the pointer.
func _pan_system(c: Control, delta: Vector2) -> void:
	var per_px := sys_distance / _focal(c)
	var reach := _fit_distance()
	sys_focus += Vector3(delta.x, delta.y, 0.0) * per_px
	sys_focus = Vector3(clampf(sys_focus.x, -reach, reach), clampf(sys_focus.y, -reach, reach), 0.0)
	_aim_eye(true)
	c.queue_redraw()

func _focal(c: Control) -> float:
	return (c.size.x / 2.0) / tan(deg_to_rad(VIEW_ANGLE / 2.0))

## Screen position and depth of a point (the camera looks along +z, so its
## right is −x); depth ≤ 0 means behind the camera.
func _project(c: Control, p: Vector3) -> Vector3:
	var d := p - eye
	if d.z < 60.0: return Vector3(0, 0, -1)
	var f := _focal(c)
	return Vector3(c.size.x / 2.0 - d.x * f / d.z, c.size.y / 2.0 - d.y * f / d.z, d.z)

func _planet_point(c: Control, o: Dictionary) -> Vector2:
	var s := _project(c, _planet_world(o))
	return Vector2(s.x, s.y)

func _draw_system(c: Control) -> void:
	var cat = app.catalogue
	var lib = app.library
	var sys: Dictionary = cat.system(system_view)
	var tint: Array = sys.get("color", [])
	# The system's own colour behind everything, as the original fills it.
	c.draw_rect(Rect2(Vector2.ZERO, c.size), Color8(int(tint[0]), int(tint[1]), int(tint[2])) if tint.size() >= 3 else Color.BLACK)
	# Faint points of light in the star's own colour scattered behind the
	# system, the same places for each visit.
	var speck := _star_sprite(int(sys.get("star", 0)))
	if speck != null:
		var r := JavaRandom.new(system_view * 1000 + 7)
		var count := int(clampf(c.size.x * c.size.y / 22000.0, 12, 40))
		for k in count:
			var p := Vector2(r.next_int(10000) / 10000.0 * c.size.x, r.next_int(10000) / 10000.0 * c.size.y)
			var s := c.size.x * (0.016 + r.next_int(10) / 1000.0)
			c.draw_texture_rect(speck, Rect2(p - Vector2(s, s), Vector2(s, s) * 2.0), false, Color(1, 1, 1, 0.55 + r.next_int(40) / 100.0))
	var f := _focal(c)
	var layout := _orbit_layout(system_view)
	# The orbits: thin dashed rings in the slanted plane.
	for o in layout:
		var r := float(o.radius)
		var steps := 120
		var last := _project(c, _orbit_point(0.0, r))
		for k in range(1, steps + 1):
			var now := _project(c, _orbit_point(TAU * k / steps, r))
			if k % 2 == 0 and last.z > 0.0 and now.z > 0.0:
				c.draw_line(Vector2(last.x, last.y), Vector2(now.x, now.y), Color(0.62, 0.68, 0.78, 0.55), 1.5, true)
			last = now
	# The sun: the original paints its quarter picture four times, mirrored.
	# It is drawn in depth order with the planets, so those beyond it are
	# covered by its glow.
	var sun_at := _project(c, Vector3.ZERO)
	var sun: Texture2D = lib.texture("sun_%d" % int(sys.get("star", 0)))
	var draw_sun := func() -> void:
		if sun == null or sun_at.z <= 0.0: return
		var centre := Vector2(sun_at.x, sun_at.y)
		var q := sun.get_size() * (c.size.x / 260.0) * clampf(VIEW_DISTANCE / sun_at.z, 0.5, 1.6)
		for m in [Vector2(1, 1), Vector2(-1, 1), Vector2(1, -1), Vector2(-1, -1)]:
			c.draw_set_transform(centre, 0.0, m)
			c.draw_texture_rect(sun, Rect2(-q, q), false)
		c.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	var sun_drawn := false
	var font := c.get_theme_default_font()
	var story := story_address()
	var warning := wormhole_address()
	var job_station := int(game.session.job.get("station", -2)) if not game.session.job.is_empty() else -2
	# Far to near, so nearer planets cover those behind.
	var order := range(layout.size())
	var depth := func(n): return (_planet_world(layout[n]) - eye).z
	order.sort_custom(func(a, b): return depth.call(a) > depth.call(b))
	var labels: Array = []
	for n in order:
		var o: Dictionary = layout[n]
		var s := _project(c, _planet_world(o))
		if s.z <= 0.0: continue
		if not sun_drawn and s.z < sun_at.z:
			draw_sun.call()
			sun_drawn = true
		var at := Vector2(s.x, s.y)
		var sid := int(o.station)
		var st: Dictionary = cat.station(sid)
		var picture := int(st.get("planet", 0))
		var tex: Texture2D = lib.texture("planet_%d" % picture)
		# The planet's size in the scene, seen at its distance.
		var d := float(PLANET_SIZES[picture % PLANET_SIZES.size()]) * 1.2 * f / s.z
		if tex != null: c.draw_texture_rect(tex, Rect2(at - Vector2(d, d) / 2.0, Vector2(d, d)), false)
		else: c.draw_circle(at, d / 2.0, UI.TEXT_DIM)
		labels.append([n, at, d, sid, st])
	if not sun_drawn: draw_sun.call()
	# Names last, over every planet.
	for entry in labels:
		var n: int = entry[0]
		var at: Vector2 = entry[1]
		var d: float = entry[2]
		var sid: int = entry[3]
		var st: Dictionary = entry[4]
		if sid == game.session.station_id:
			# The original's red arrow beside the planet you are docked at.
			var tip := at + Vector2(-d / 2.0 - 4, 0)
			c.draw_colored_polygon(PackedVector2Array([tip, tip + Vector2(-16, -9), tip + Vector2(-11, 0), tip + Vector2(-16, 9)]), Color8(0xe0, 0x3a, 0x22))
		var chosen: bool = n == planet
		var visited: bool = game.session.visited_stations.has(str(sid)) or game.session.visited_stations.has(sid)
		var col: Color = CHOSEN if chosen else (UI.TEXT if visited else UI.TEXT_DIM)
		var x := at.x + d / 2.0 + 8
		var y := at.y + 4
		var name := str(st.get("name", "?"))
		var size := 18 if chosen else 16
		c.draw_string_outline(font, Vector2(x, y), name, HORIZONTAL_ALIGNMENT_LEFT, -1, size, 4, Color.BLACK)
		c.draw_string(font, Vector2(x, y), name, HORIZONTAL_ALIGNMENT_LEFT, -1, size, col)
		# The original's markers after the name: visited, story, job, gate.
		var icons: Array = []
		if visited: icons.append("menu_map_visited")
		if int(story.get("station", -1)) == sid or int(warning.get("station", -1)) == sid: icons.append("menu_map_mainmission")
		if job_station == sid: icons.append("menu_map_sidemission")
		if int(sys.get("jumpgate_station", -1)) == sid: icons.append("menu_map_jumpgate")
		var ix := x + font.get_string_size(name, HORIZONTAL_ALIGNMENT_LEFT, -1, size).x + 8
		for icon in icons:
			var t: Texture2D = lib.texture(icon)
			if t == null: continue
			var sz := t.get_size() * 2.0
			c.draw_texture_rect(t, Rect2(Vector2(ix, y - sz.y + 3), sz), false)
			ix += sz.x + 4
		if chosen:
			var tech := "%s: %d" % [lib.text(37), int(st.get("tech", 0))]
			c.draw_string_outline(font, Vector2(x, y + 22), tech, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, 4, Color.BLACK)
			c.draw_string(font, Vector2(x, y + 22), tech, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, UI.TEXT)

func _pick_planet(c: Control, at: Vector2) -> void:
	var layout := _orbit_layout(system_view)
	var best := -1
	var best_d := 40.0
	for n in layout.size():
		var d := at.distance_to(_planet_point(c, layout[n]))
		if d < best_d: best_d = d; best = n
	if best >= 0: _set_planet(best)

func _step_planet(c: Control, dir: Vector2) -> void:
	var layout := _orbit_layout(system_view)
	if layout.is_empty(): return
	var from := _planet_point(c, layout[planet])
	var best := -1
	var best_score := INF
	for n in layout.size():
		if n == planet: continue
		var d := _planet_point(c, layout[n]) - from
		if d.length() < 1.0 or d.normalized().dot(dir) < 0.3: continue
		var score := d.length() * (2.0 - d.normalized().dot(dir))
		if score < best_score: best_score = score; best = n
	if best >= 0: _set_planet(best)

func _set_planet(n: int) -> void:
	planet = n
	# The camera follows only when the choice would be out of sight.
	var layout0 := _orbit_layout(system_view)
	var seen := _project(canvas, _planet_world(layout0[n]))
	if seen.z <= 0.0 or not Rect2(Vector2.ZERO, canvas.size).grow(-60).has_point(Vector2(seen.x, seen.y)):
		var w := _planet_world(layout0[n])
		sys_focus = Vector3(w.x, w.y, 0.0)
	_aim_eye(false)
	canvas.queue_redraw()
	_fill_side()
