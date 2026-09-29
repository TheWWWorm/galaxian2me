extends SceneTree
## Prints the story as the engine reads it: each step's mission kind,
## station, goal, dialogue and radio counts, and whether a scene is scripted.
## godot --headless --path game -s res://tests/story_table.gd

const Library := preload("res://src/content/library.gd")
const Catalogue := preload("res://src/content/catalogue.gd")
const Game := preload("res://src/simulation/game.gd")
const Story := preload("res://src/flight/story.gd")

func _init() -> void:
	var lib := Library.new()
	if not lib.open(Library.installed()[0]):
		quit(1); return
	var cat := Catalogue.new(lib)
	var game := Game.new(lib, cat)
	game.new_game()
	var radio: Dictionary = lib.data.campaign.get("radio", {})
	var problems := 0
	for step in range(0, 46):
		var m: Dictionary = game.session.story_mission
		var kind := int(m.get("kind", -1))
		var station := int(m.get("station", -99))
		var station_name: String = cat.station_name(station) if station >= 0 else ("void" if station == -1 else "-")
		var brief: int = game.campaign.dialogue(step, 0).size()
		var debrief: int = game.campaign.dialogue(step, 1).size()
		var scripted: bool = step in Story.STORY_SCENES
		var line := "%2d kind %2d %-14s target %-6s brief %2d debrief %2d radio %2d %s %s" % [step, kind, station_name,
			str(m.get("target", "")), brief, debrief, radio.get(str(step), []).size(), "scene" if scripted else "", game.campaign.journal().left(60)]
		print(line)
		if m.is_empty() and step < 45:
			print("   !! no mission")
			problems += 1
		if not game.campaign.step_supported(step + 1): print("   !! next step unsupported")
		game.campaign.advance()
	print("problems: ", problems)
	quit(0)
