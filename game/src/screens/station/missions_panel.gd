extends HBoxContainer
## Missions: the current story mission and the accepted freelance job.

const UI := preload("res://src/presentation/ui.gd")
const Catalogue := preload("res://src/content/catalogue.gd")
const Navigation := preload("res://src/simulation/navigation.gd")

var station
var app
var game

func _ready() -> void:
	app = station.app
	game = station.game
	add_theme_constant_override("separation", 10)
	var lib = app.library
	var story := UI.Frame.new(lib.text(278))
	story.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(story)
	var sbox := VBoxContainer.new()
	story.add_child(sbox)
	var m: Dictionary = game.session.story_mission
	var journal: String = game.campaign.journal()
	if not journal.is_empty():
		var t := UI.paragraph(journal)
		sbox.add_child(t)
	if not m.is_empty() and int(m.get("station", -1)) >= 0:
		sbox.add_child(_destination(int(m.station)))
	if not game.campaign.step_supported(game.session.story_step + 1) and not m.is_empty():
		sbox.add_child(UI.paragraph("The next part of the story needs data this build of the game does not contain.", 14, UI.TEXT_WARN))
	var free := UI.Frame.new(lib.text(279))
	free.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(free)
	var fbox := VBoxContainer.new()
	free.add_child(fbox)
	var job: Dictionary = game.session.job
	if job.is_empty():
		fbox.add_child(UI.label(lib.text(141), 15, UI.TEXT_DIM))
	else:
		var returning := bool(job.get("recovered", false))
		fbox.add_child(UI.label(lib.text(Catalogue.STRING_MISSION_TYPES + (11 if returning else int(job.kind))), 17))
		fbox.add_child(UI.label(str(job.get("client", "")), 15, UI.TEXT_DIM))
		if int(job.kind) == 6:
			# The consumed lounge offer must not take the wanted identity
			# with it. Keep the supplied bounty briefing in the journal.
			fbox.add_child(UI.paragraph(lib.text(431).replace("#N", str(job.get("wanted", "")))
				.replace("#S", app.catalogue.station_name(int(job.station))), 14))
		if int(job.kind) in [3, 5]:
			fbox.add_child(UI.label("1 × %s" % app.catalogue.item_name(int(job.item)), 16))
			fbox.add_child(UI.paragraph(lib.text(439).replace("#S", app.catalogue.station_name(int(job.station))) if returning else lib.text(438), 14))
		if int(job.kind) == 8:
			# Keep the supplied purchase terms visible after the lounge offer is
			# consumed; a destination and reward alone cannot identify the goods.
			fbox.add_child(UI.label("%d × %s" % [int(job.count), app.catalogue.item_name(int(job.item))], 16))
		fbox.add_child(_destination(int(job.station)))
		fbox.add_child(UI.label(UI.money(int(job.reward)), 16, UI.TEXT_GOOD))
		var abandon := UI.button(lib.text(244), func(): pass)
		abandon.pressed.connect(func():
			UI.ask(self, lib.text(240), func():
				game.cancel_job()
				station.close_panel(), func(): abandon.grab_focus(), lib.text(244)))
		fbox.add_child(abandon)

## A destination card: the owner's emblem, the station and its system, how
## far it is along the known gate links, and a way to the map.
func _destination(station_id: int) -> Control:
	var cat = app.catalogue
	var lib = app.library
	var system: int = cat.system_of_station(station_id)
	var card := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.02, 0.06, 0.12, 0.7)
	style.border_color = UI.BORDER
	style.set_border_width_all(1)
	style.set_content_margin_all(8)
	card.add_theme_stylebox_override("panel", style)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	card.add_child(row)
	var logo: Texture2D = lib.texture("logo_%d" % int(cat.system(system).get("faction", 0))) if system >= 0 else null
	if logo != null:
		var icon := TextureRect.new()
		icon.texture = logo
		icon.custom_minimum_size = Vector2(40, 40)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		row.add_child(icon)
	var text := VBoxContainer.new()
	text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(text)
	text.add_child(UI.label("%s: %s" % [lib.text(295), cat.station_name(station_id)], 16, UI.TEXT_GOOD))
	var where: String = cat.system_name(system) if system >= 0 else ""
	var jumps := jumps_to(system)
	if station_id == game.session.station_id: where += "  ·  you are here"
	elif system == game.session.system_index: where += "  ·  in this system"
	elif jumps > 0: where += "  ·  %d jump%s away" % [jumps, "" if jumps == 1 else "s"]
	text.add_child(UI.label(where, 14, UI.TEXT_DIM))
	if system >= 0 and station_id != game.session.station_id and Navigation.known(game.session, cat, system):
		row.add_child(UI.button(lib.text(72), func(): _show_on_map(system)))
	return card

## Gate jumps from here to `system` through known systems, or -1.
func jumps_to(system: int) -> int:
	var cat = app.catalogue
	var from: int = game.session.system_index
	if system < 0 or from < 0: return -1
	var seen := {from: 0}
	var queue := [from]
	while not queue.is_empty():
		var at: int = queue.pop_front()
		if at == system: return int(seen[at])
		for link in cat.system(at).get("links", []):
			var next := int(link)
			if seen.has(next) or not Navigation.known(game.session, cat, next): continue
			seen[next] = int(seen[at]) + 1
			queue.append(next)
	return -1

func _show_on_map(system: int) -> void:
	station._open_section(2)
	var map = station.current_panel
	if map == null or map.get("selected_system") == null: return
	map.selected_system = system
	map.canvas.queue_redraw()
	map._fill_side()
