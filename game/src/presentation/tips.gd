extends RefCounted
## The original's first-time help: a short explanation the first time the
## player meets a feature (strings 300-324). Each is shown once per
## installation, like the phone game's global help flags; players can turn
## them off or show them again from Options → Interface.

const FLIGHT := [
	# [key, text, condition name] checked in order after five seconds of flight.
	["booster", 306], ["jump_drive", 304], ["cloak", 305], ["interplanet", 300],
	["wingmen", 320], ["reputation", 324], ["mining", 307], ["asteroid", 308], ["cargo_full", 319]]
const STATION := {"shop": 309, "ship": 310, "actions": 311, "blueprints": 312, "blueprint_info": 313,
	"lounge": 314, "galaxy_map": 315, "system_map": 316, "missions": 318, "status": 322, "medals": 323,
	"buying": 302, "mounting": 303, "action_menu": 321}

static func enabled(app) -> bool:
	return bool(app.setting("interface", "help_popups", true))

## True once for each key: the caller shows the text and it is remembered.
static func take(app, key: String) -> bool:
	if app == null or not enabled(app) or bool(app.setting("help_shown", key, false)): return false
	app.set_setting("help_shown", key, true)
	return true

static func reset(app) -> void:
	if app.settings.has_section("help_shown"): app.settings.erase_section("help_shown")
	app.set_setting("interface", "help_popups", true)

## The original's help texts open with their title in brackets on its own
## line ("[SHOP]\n..."): [title, body], the title empty when there is none.
static func split(text: String) -> Array:
	if text.begins_with("["):
		var close := text.find("]")
		if close > 0 and (close + 1 >= text.length() or text[close + 1] == "\n"):
			return [text.substr(1, close - 1).strip_edges(), text.substr(close + 1).strip_edges()]
	return ["", text]

## A conversation line for the help text, titled with its heading.
static func line(app, text_id: int) -> Dictionary:
	var parts := split(app.library.text(text_id))
	var title: String = parts[0].capitalize() if not parts[0].is_empty() else app.library.text(4)
	return {"speaker": -1, "name": title, "face": [], "text": parts[1]}

## The next in-flight tip that applies, or {}.
static func flight_tip(app, space) -> Dictionary:
	var s = space.game.session
	for entry in FLIGHT:
		var ok := false
		match entry[0]:
			"booster": ok = int(s.ship_stats().boost_length) > 0
			"jump_drive": ok = s.has_equipped_type(preload("res://src/content/catalogue.gd").Type.JUMP_DRIVE)
			"cloak": ok = space.has_cloak()
			"interplanet": ok = not space.autopilot and int(s.story_step) > 9
			"wingmen": ok = not s.flags.get("wingmen", []).is_empty()
			"reputation": ok = absi(int(s.reputation[0])) > 60 or absi(int(s.reputation[1])) > 60
			"mining": ok = space.mining != null
			"asteroid": ok = space.mining != null and int(s.story_step) > 3
			"cargo_full": ok = s.cargo_free() <= 0 and int(s.story_step) > 6
		if ok and take(app, str(entry[0])): return line(app, int(entry[1]))
	return {}

## The station tip for `key`, once.
static func station_tip(app, key: String) -> Dictionary:
	if not STATION.has(key) or not take(app, key): return {}
	return line(app, int(STATION[key]))
