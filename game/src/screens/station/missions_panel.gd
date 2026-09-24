extends HBoxContainer
## Missions: the current story mission and the accepted freelance job.

const UI := preload("res://src/presentation/ui.gd")
const Catalogue := preload("res://src/content/catalogue.gd")

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
		sbox.add_child(UI.label("%s: %s (%s)" % [lib.text(295), app.catalogue.station_name(int(m.station)), app.catalogue.system_name(app.catalogue.system_of_station(int(m.station)))], 15, UI.TEXT_GOOD))
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
		fbox.add_child(UI.label(lib.text(Catalogue.STRING_MISSION_TYPES + int(job.kind)), 17))
		fbox.add_child(UI.label(str(job.get("client", "")), 15, UI.TEXT_DIM))
		fbox.add_child(UI.label("%s: %s" % [lib.text(295), app.catalogue.station_name(int(job.station))], 15))
		fbox.add_child(UI.label(UI.money(int(job.reward)), 16, UI.TEXT_GOOD))
		fbox.add_child(UI.button(lib.text(244), func():
			game.cancel_job()
			station.close_panel()))
