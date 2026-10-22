extends RefCounted
## The reference: articles about the player's own imported game. Nothing is
## bundled. Every name, figure and line of dialogue comes from the converted
## JAR, and what the pages say about shops, dealers, jobs and medals follows
## the simulation's own rules. Keys are language-independent navigation
## tokens ("station/12"); only imported names and engine text reach a page.
##
## The reference's own writing (WikiProse) explains the galaxy, the rules and
## the story around those facts in the reader's language; it names things
## only through link tokens, so the imported names appear in it.
##
## Pages are small, well-formed HTML fragments: h1, h2, p, ul, li, table (with
## data-columns), tr, th, td, strong, em, br, figure and wiki:// links. The
## in-game reader turns them into rich text and shows each page's picture
## (media) beside it; the web page export shows them as they are. Imported
## text is always escaped.
##
## Story pages stop at a step limit, so a player is not shown what lies ahead
## of their save: later steps, characters not yet met and their lines stay
## out of every page.
const Catalogue := preload("res://src/content/catalogue.gd")
const Medals := preload("res://src/simulation/medals.gd")
const Portrait := preload("res://src/presentation/portrait.gd")
const EngineLanguage := preload("res://src/presentation/engine_language.gd")
const WikiProse := preload("res://src/wiki/prose.gd")

const CATEGORIES := ["world", "story", "characters", "systems", "stations", "factions", "ships", "weapons", "equipment", "goods", "blueprints", "agents", "jobs", "medals", "guide"]
## The last story step; its record has no mission, only the closing reward.
const FINAL_STEP := 45
## Speakers with a page of their own: the named cast (texts 819+). The rest
## are roles (pirates, security, officers) and the game's narrator voices.
const CHARACTERS := [0, 1, 2, 3, 4, 5, 6, 7, 8, 20]
## Hulls ordinary dealers never offer (Market._dealer_hull); Vossk yards sell
## the first of the two faction ships, Void space the second.
const DEALER_EXCLUDED := [0, 8, 9, 10, 13, 14, 15]
const VOSSK_HULL := 9
const VOID_HULL := 8
## Story kinds the original shares with freelance jobs have their names in
## the game (texts 179+); the rest are the story's own.
const JOB_KINDS := 13
## Mido has no ship dealer before this story step (Market.generate_ships).
const MIDO := 15
const MIDO_DEALER_STEP := 16
## Freelance kinds a client offers before step 16, or in a build without the
## online part (Lounge.job_for).
const EARLY_JOBS := [11, 0, 7, 4, 12]
const JOB_SCENE_KINDS := {0: "item", 3: "item", 5: "item", 8: "item", 11: "count"}
## Lounge.BAR_EXCLUDED: stations jobs never send anyone to.
const BAR_EXCLUDED := [10, 22, 27, 29, 30, 48, 55, 56, 76, 79, 91, 98]
## Local spirits: one per system, stocked only at home (Market).
const SPIRITS_FIRST := 132
const SPIRITS_END := 154

var library
var cat: Catalogue
var entries := {}
var ordered: Array[String] = []
## The last story step shown: the save's own, or every step.
var limit := FINAL_STEP
var prose: WikiProse
## The language of the reference's own text; imported names stay the JAR's.
var language := "en"
var jar_language := "en"
var _dialogue := {}
var _journal := {}

func _init(owner_library, step_limit := -1, code := "") -> void:
	library = owner_library
	cat = Catalogue.new(library)
	language = code if code in EngineLanguage.codes() else EngineLanguage.current
	prose = WikiProse.new(language)
	jar_language = EngineLanguage.content_language(str(library.language), Array(library.strings))
	limit = FINAL_STEP if step_limit < 0 else clampi(step_limit, 0, FINAL_STEP)
	_find_dialogue()
	rebuild()

## Engine text in the reference's language, whatever the interface uses.
func translate(text: String) -> String: return EngineLanguage.text_in(language, text)

func all_sections() -> String: return translate("All sections")
func complete() -> bool: return limit >= FINAL_STEP

## Whether the JAR's own text is in the reference's language.
func jar_speaks() -> bool: return language == jar_language

# --- names ----------------------------------------------------------------

func text(index: int) -> String: return str(library.text(index))

static func named(value: String, fallback: String) -> String:
	return value.strip_edges() if not value.strip_edges().is_empty() and value.strip_edges() != "-" else fallback

func ship_name(id: int) -> String: return named(cat.ship_name(id), translate("Ship %d") % (id + 1))
func item_name(id: int) -> String: return named(cat.item_name(id), translate("Item %d") % (id + 1))
func station_name(id: int) -> String:
	if id == -1: return translate("Void space")
	return named(cat.station_name(id), translate("Station %d") % id)
func system_name(id: int) -> String: return named(cat.system_name(id), translate("System %d") % (id + 1))
func faction_name(race: int) -> String: return named(cat.faction_name(race), translate("Faction %d") % (race + 1))
func speaker_name(id: int) -> String: return named(text(Catalogue.STRING_SPEAKERS + id), translate("Speaker %d") % id)
func job_name(kind: int) -> String: return named(text(Catalogue.STRING_MISSION_TYPES + kind), translate("Job %d") % (kind + 1))
func medal_name(id: int) -> String: return named(Medals.name(library, id), translate("Medal %d") % (id + 1))
func safety_name(value: int) -> String: return named(text(Catalogue.STRING_SAFETY + value), str(value))
func agent_name(id: int) -> String: return named(str(cat.agent(id).get("name", "")), translate("Agent %d") % (id + 1))

func step_title(step: int) -> String:
	var own: Dictionary = prose.pages.get("step/%d" % step, {})
	if not str(own.get("title", "")).is_empty(): return str(own.title)
	if step >= FINAL_STEP: return translate("Epilogue")
	return translate("Step %d") % step

func category_name(category: String) -> String:
	match category:
		"world": return translate("Galaxy")
		"story": return translate("Story")
		"characters": return translate("Characters")
		"systems": return translate("Systems")
		"stations": return translate("Stations")
		"factions": return translate("Factions")
		"ships": return translate("Ships")
		"weapons": return translate("Weapons")
		"equipment": return translate("Equipment")
		"goods": return translate("Goods")
		"blueprints": return translate("Blueprints")
		"agents": return translate("Agents")
		"jobs": return translate("Jobs")
		"medals": return translate("Medals")
		"guide": return translate("Guide")
	return category

## Story objectives by mission kind, as Campaign.check evaluates them.
func objective_name(kind: int) -> String:
	match kind:
		0, 11: return translate("Dock at the station")
		4: return translate("Destroy the hostile ships")
		8: return translate("Buy the goods and bring them")
		12: return translate("Win the race")
		13: return translate("Complete freelance jobs")
		14: return translate("Destroy ships")
		15, 21, 23: return translate("Fit the equipment")
		16: return translate("Visit stations")
		18: return translate("Mine ore until the hold is full")
		19: return translate("Produce from blueprints")
		20: return translate("Reach the place and wait there")
		22: return translate("Arm the ship with a weapon and armour")
		24: return translate("Get away")
		25: return translate("Escort the convoy")
	return translate("Objective")

# --- registry -------------------------------------------------------------

func add(key: String, title: String, category: String, subtitle := "") -> void:
	entries[key] = {"key": key, "title": title, "category": category, "subtitle": subtitle}
	ordered.append(key)

func rebuild() -> void:
	entries.clear(); ordered.clear()
	add("home", translate("Reference"), "")
	add("chart", translate("Galaxy map"), "world", translate("%d systems") % cat.system_count())
	for id in cat.system_count():
		add("system/%d" % id, system_name(id), "systems", "%s · %s" % [faction_name(int(cat.system(id).faction)), safety_name(int(cat.system(id).safety))])
	for s: Dictionary in library.data.stations:
		var id := int(s.id)
		add("station/%d" % id, station_name(id), "stations", translate("%s · tech %d") % [system_name(int(s.system)), int(s.tech)])
	for race in factions():
		add("faction/%d" % race, faction_name(race), "factions")
	for id in cat.ship_count():
		if is_ship(id): add("ship/%d" % id, ship_name(id), "ships", translate("Armour %d · cargo %d t") % [int(cat.ship(id).armor), int(cat.ship(id).cargo)])
	for id in cat.item_count():
		add("item/%d" % id, item_name(id), item_category(id), item_kind(id))
	for id in library.data.agents.size():
		add("agent/%d" % id, agent_name(id), "agents", "%s · %s" % [station_name(int(cat.agent(id).station)), faction_name(int(cat.agent(id).race))])
	for kind in JOB_KINDS:
		add("job/%d" % kind, job_name(kind), "jobs")
	for id in Medals.table(library).size():
		add("medal/%d" % id, medal_name(id), "medals")
	for step in range(0, limit + 1):
		if step_exists(step): add("step/%d" % step, step_title(step), "story", translate("Step %d") % step if step < FINAL_STEP else "")
	# A step's dialogue is its own page, linked from the step, so the step
	# page reads as a summary rather than a script.
	for step in range(0, limit + 1):
		if step_exists(step) and has_dialogue(step): add("dialogue/%d" % step, translate("Dialogue: %s") % step_title(step), "", translate("Step %d") % step)
	for speaker in CHARACTERS:
		if speaker == 0 or not appearances(speaker).is_empty(): add("character/%d" % speaker, speaker_name(speaker), "characters")
	for key: String in prose.pages:
		var info: Dictionary = prose.pages[key]
		if int(info.get("from", 0)) <= limit and not entries.has(key) and not key.begins_with("step/"):
			add(key, str(info.title), str(info.get("category", "guide")), str(info.get("subtitle", "")))
	add("guide/help", translate("Controls"), "guide")
	add("guide/tips", translate("Tips"), "guide")
	for category: String in CATEGORIES: add("section/" + category, category_name(category), "")

func page(key: String) -> String:
	if not entries.has(key): return h1(translate("Not found")) + p(esc(translate("There is no such page in this reference.")))
	var parts := key.split("/")
	var id := int(parts[1]) if parts.size() > 1 and parts[1].is_valid_int() else -1
	match parts[0]:
		"home": return home_page()
		"chart": return chart_page()
		"system": return system_page(id)
		"station": return station_page(id)
		"faction": return faction_page(id)
		"ship": return ship_page(id)
		"item": return item_page(id)
		"agent": return agent_page(id)
		"job": return job_page(id)
		"medal": return medal_page(id)
		"step": return step_page(id)
		"dialogue": return dialogue_page(id)
		"character": return character_page(id)
		"guide", "world":
			if parts[1] in ["help", "tips"]: return guide_page(parts[1])
			return h1(entries[key].title, entries[key].subtitle) + prose_html(key)
		"section": return section_page(parts[1])
	return ""

## The page's own words for search: its title and subtitle.
func search_text(key: String) -> String:
	var entry: Dictionary = entries[key]
	return "%s %s" % [entry.title, entry.subtitle]

# --- HTML -----------------------------------------------------------------

static func esc(value: String) -> String:
	return value.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("\n", "<br/>")

func a(key: String) -> String:
	return "<a href=\"wiki://%s\">%s</a>" % [key, esc(entries[key].title)] if entries.has(key) else ""

func step_link(step: int) -> String:
	return a("step/%d" % step) if step <= limit and entries.has("step/%d" % step) else esc(translate("a later step"))

func station_link(id: int) -> String:
	var html := a("station/%d" % id)
	return html if not html.is_empty() else esc(station_name(id))

func h1(title: String, subtitle := "") -> String:
	return "<h1>%s</h1>" % esc(title) + (p("<em>%s</em>" % esc(subtitle)) if not subtitle.is_empty() else "")

func h2(title: String) -> String: return "<h2>%s</h2>" % esc(title)
func p(html: String) -> String: return "<p>%s</p>" % html
func bullets(items: Array) -> String: return "<ul><li>" + "</li><li>".join(items) + "</li></ul>" if not items.is_empty() else ""

## Rows of [label, html] as a two-column table.
func facts(rows: Array) -> String:
	var out := "<table data-columns=\"2\">"
	for row: Array in rows: out += "<tr><th>%s</th><td>%s</td></tr>" % [esc(row[0]), row[1]]
	return out + "</table>"

## A table with a header row; cells are already HTML.
func grid(header: Array, rows: Array) -> String:
	if rows.is_empty(): return ""
	var out := "<table data-columns=\"%d\"><tr>" % header.size()
	for cell in header: out += "<th>%s</th>" % esc(cell)
	out += "</tr>"
	for row: Array in rows:
		out += "<tr>"
		for cell in row: out += "<td>%s</td>" % str(cell)
		out += "</tr>"
	return out + "</table>"

func links(keys: Array) -> String:
	var parts := PackedStringArray()
	for key in keys:
		var html := a(key)
		if not html.is_empty(): parts.append(html)
	return ", ".join(parts) if not parts.is_empty() else esc(translate("None"))

func money(value: int) -> String: return esc(translate("%s cr") % thousands(value))

static func thousands(value: int) -> String:
	var digits := str(absi(value))
	var out := ""
	while digits.length() > 3:
		out = "," + digits.right(3) + out; digits = digits.left(digits.length() - 3)
	return ("-" if value < 0 else "") + digits + out

## The page's own prose a save at this step may read, as HTML.
func prose_html(key: String) -> String:
	var out := ""
	var items: Array = []
	# Like any wiki, a name is a link where it first appears, plain text after.
	var named_ := {key: true}
	for block: Array in prose.visible(key, limit):
		var heading := str(block[1])
		if (not block[3] or not heading.is_empty()) and not items.is_empty():
			out += bullets(items); items = []
		if not heading.is_empty(): out += h2(heading)
		if block[3]: items.append(linked(str(block[2]), named_))
		else: out += p(linked(str(block[2]), named_))
	return out + bullets(items)

## Prose text with its [[key]] tokens as links. A page the save may not see
## yet keeps the token's own words, or is left unnamed.
func linked(value: String, named_ := {}) -> String:
	var out := ""
	var at := 0
	for found in WikiProse.pattern().search_all(value):
		out += esc(value.substr(at, found.get_start() - at))
		var key := found.get_string(1)
		var words := found.get_string(2)
		if entries.has(key):
			# Prose names a story step by its number.
			var title := str(entries[key].title)
			if key.begins_with("step/"): title = translate("Step %d") % int(key.get_slice("/", 1))
			var shown := esc(words if not words.is_empty() else title)
			out += shown if named_.has(key) else "<a href=\"wiki://%s\">%s</a>" % [key, shown]
			named_[key] = true
		elif not words.is_empty(): out += esc(words)
		elif key.begins_with("step/"): out += esc(translate("a later step"))
		at = found.get_end()
	return out + esc(value.substr(at))

## One section's pages in a table, after its introduction.
func section_page(category: String) -> String:
	var out := h1(category_name(category), translate("Section"))
	out += prose_html("intro/" + category)
	var keys: Array = ordered.filter(func(key): return entries[key].category == category)
	if category != "story": keys.sort_custom(func(x, y): return str(entries[x].title).naturalnocasecmp_to(entries[y].title) < 0)
	return out + grid([translate("Page"), translate("Details")], keys.map(func(key): return [a(key), esc(str(entries[key].subtitle))]))

## Where the web page export draws the galaxy map. The page only marks the
## spot; the export's reader draws every system from one shared list, and the
## in-game reader shows it as the page's picture.
func chart(highlight: int, stations: Array = []) -> String:
	return "<figure class=\"chart\" data-highlight=\"%d\" data-marked=\"%s\"></figure>" % [highlight, ",".join(stations.map(func(id): return str(int(id))))]

# --- rules ----------------------------------------------------------------

## Races that hold a system or have people in the game: every faction the
## game names, up to the Void.
func factions() -> Array:
	var out: Array = []
	for race in 10:
		if not text(Catalogue.STRING_RACES + race).strip_edges().is_empty(): out.append(race)
	return out

func is_ship(id: int) -> bool: return named(cat.ship_name(id), "") != ""

func item_category(id: int) -> String:
	if cat.is_blueprint_product(id): return "blueprints"
	match cat.category(id):
		Catalogue.Category.PRIMARY, Catalogue.Category.SECONDARY, Catalogue.Category.TURRET: return "weapons"
		Catalogue.Category.EQUIPMENT: return "equipment"
	return "goods"

func item_kind(id: int) -> String: return named(cat.type_name(cat.type(id)), translate("Item"))

func stations_of(system: int) -> Array: return cat.system(system).get("stations", []).map(func(s): return int(s))

## Systems a player can reach through jump gates from the start, and the
## hidden ones that must be bought from an agent or found in the story.
func hidden(system: int) -> bool: return not bool(cat.system(system).get("visible", false))

## Agents in a station's lounge (named ones, Lounge.generate).
func agents_at(station: int) -> Array:
	return range(library.data.agents.size()).filter(func(i): return int(cat.agent(i).station) == station)

## Whether an ordinary shelf at a station can stock an item (Market.generate_stock).
func shelf_can_stock(id: int, station: int) -> bool:
	var st: Dictionary = cat.station(station)
	if st.is_empty(): return false
	if station == cat.attr(id, Catalogue.A_HOME_STATION, -1): return true
	var tech := int(st.tech)
	var min_tech := 1 if tech < 4 else tech / 2
	var t := cat.tech(id)
	if cat.is_blueprint_product(id) or id in [164, 175] or cat.attr(id, Catalogue.A_OCCURRENCE) == 0 or cat.price_mid(id) == 0: return false
	if cat.attr(id, Catalogue.A_VOSSK_ONLY) == 1 and int(cat.system(int(st.system)).faction) != 1: return false
	if id >= SPIRITS_FIRST and id < SPIRITS_END: return id == SPIRITS_FIRST + int(st.system) and t <= tech
	return t <= tech and t >= min_tech

func recipes_using(id: int) -> Array:
	return range(cat.item_count()).filter(func(other): return id in cat.item(other).get("ingredients", []).map(func(v): return int(v)))

## Agents who sell a blueprint or a hidden system's coordinates.
func agents_selling(blueprint := -1, system := -1) -> Array:
	var out: Array = []
	for i in library.data.agents.size():
		var offer := Catalogue.agent_offer(cat.agent(i))
		if (blueprint >= 0 and int(offer.blueprint) == blueprint) or (system >= 0 and int(offer.system) == system): out.append("agent/%d" % i)
	return out

# --- story ----------------------------------------------------------------

## The two dialogue tables (Campaign._find_dialogue_tables): per story step,
## pairs of speaker and line for the briefing and the debriefing.
func _find_dialogue() -> void:
	var found := {}
	for key: String in library.data.constants:
		if not key.ends_with(":[[S"): continue
		var v = library.data.constants[key]
		if not (v is Array) or v.size() < 40: continue
		var ok := true
		for row in v:
			if not (row is Array) or row.size() % 2 != 0: ok = false; break
			for i in range(0, row.size(), 2):
				if row[i + 1] != 0 and (row[i] < 0 or row[i] > 40 or row[i + 1] < 600 or row[i + 1] >= library.strings.size()):
					ok = false; break
			if not ok: break
		if ok:
			var owner := key.substr(0, key.find("."))
			if not found.has(owner): found[owner] = []
			found[owner].append(key)
	for owner in found:
		var keys: Array = found[owner]
		if keys.size() == 2:
			keys.sort()
			_dialogue = {0: library.data.constants[keys[0]], 1: library.data.constants[keys[1]]}
			return

func campaign() -> Dictionary: return library.data.get("campaign", {})

func step_exists(step: int) -> bool:
	return step == 0 and not campaign().get("start", {}).is_empty() or not step_record(step).is_empty()

func step_record(step: int) -> Dictionary:
	for r: Dictionary in campaign().get("steps", []):
		if int(r.step) == step: return r
	return {}

## The step's story mission: {kind, reward, station}, station -1 for Void
## space, or {} for none (the closing record), or a station only the online
## part of the game names ({"online": true}).
func mission(step: int) -> Dictionary:
	var args: Array = campaign().get("start", {}).get("mission", []) if step == 0 else []
	for m in step_record(step).get("missions", []): args = m
	if args.size() < 3: return {}
	if args[2] is Dictionary: return {"kind": int(args[0]), "reward": int(args[1]), "online": true}
	return {"kind": int(args[0]), "reward": int(args[1]), "station": int(args[2])}

func lines(step: int, phase: int) -> Array:
	var table: Array = _dialogue.get(phase, [])
	var out: Array = []
	if step < 0 or step >= table.size(): return out
	var row: Array = table[step]
	for i in range(0, row.size() - 1, 2):
		if int(row[i + 1]) != 0: out.append({"speaker": int(row[i]), "text_id": int(row[i + 1])})
	return out

func radio(step: int) -> Array:
	return campaign().get("radio", {}).get(str(step), []).map(func(r): return {"speaker": int(r[1]), "text_id": int(r[0])})

func has_dialogue(step: int) -> bool:
	return not (lines(step, 0).is_empty() and lines(step, 1).is_empty() and radio(step).is_empty())

## A step's debriefing comes once it is done: behind the save's step.
func finished(step: int) -> bool: return step < limit or complete()

## Visible steps in which a speaker has lines.
func appearances(speaker: int) -> Array:
	var out: Array = []
	for step in range(0, limit + 1):
		var said: Array = lines(step, 0) + radio(step)
		if finished(step): said += lines(step, 1)
		if said.any(func(line): return int(line.speaker) == speaker): out.append(step)
	return out

func step_speakers(step: int) -> Array:
	var said: Array = lines(step, 0) + radio(step)
	if finished(step): said += lines(step, 1)
	var out: Array = []
	for line in said:
		var speaker := int(line.speaker)
		if not speaker in out and entries.has("character/%d" % speaker): out.append(speaker)
	return out

func steps_where(test: Callable) -> Array:
	var out: Array = []
	for step in range(0, limit + 1):
		var m := mission(step)
		if not m.is_empty() and test.call(m): out.append("step/%d" % step)
	return out

func line_text(text_id: int) -> String: return text(text_id)

func speaker_link(speaker: int) -> String:
	var html := a("character/%d" % speaker)
	return html if not html.is_empty() else esc(speaker_name(speaker))

func dialogue(said: Array) -> String:
	var out := "<table data-columns=\"2\">"
	for line: Dictionary in said:
		out += "<tr><th>%s</th><td>%s</td></tr>" % [speaker_link(line.speaker), esc(line_text(line.text_id))]
	return out + "</table>"

func objective(step: int) -> String:
	var m := mission(step)
	if m.is_empty(): return esc(translate("The story is complete."))
	var out := esc(objective_name(int(m.kind)))
	if m.get("online", false): return out + " · " + esc(translate("a station from the online part of the game"))
	var where := int(m.station)
	if where == -1: out += ": " + esc(translate("Void space"))
	elif int(m.kind) != 13: out += ": " + station_link(where)
	return out

# --- pages ----------------------------------------------------------------

func home_page() -> String:
	var out := h1(translate("Reference"), translate("Compiled from your imported game"))
	out += prose_html("home")
	out += p("<em>%s</em>" % esc(translate("Names, figures and dialogue come from the Galaxy on Fire 2 JAR you imported; shops, jobs and medals follow the engine's rules.")))
	if not complete(): out += p("<em>%s</em>" % esc(translate("Story pages end at step %d, where your latest save is. Later steps appear as you reach them.") % limit))
	var start: Array = ["step/%d" % limit, "world/galaxy", "world/history", "guide/basics", "chart"].filter(func(key): return entries.has(key))
	out += h2(translate("Start here")) + bullets(start.map(func(key): return a(key) + ("  ·  " + esc(entries[key].subtitle) if not str(entries[key].subtitle).is_empty() else "")))
	for category: String in CATEGORIES:
		var count := ordered.filter(func(key): return entries[key].category == category).size()
		if count == 0: continue
		out += h2(category_name(category))
		var intro: Array = prose.visible("intro/" + category, limit)
		if not intro.is_empty(): out += p(linked(str(intro[0][2])))
		out += p("<a href=\"wiki://section/%s\">%s</a>" % [category, esc(translate("All %d pages") % count)])
	return out

func chart_page() -> String:
	var out := h1(translate("Galaxy map"), translate("%d systems") % cat.system_count())
	out += prose_html("chart")
	out += chart(-1)
	var ids := range(cat.system_count())
	ids.sort_custom(func(x, y): return system_name(x).naturalnocasecmp_to(system_name(y)) < 0)
	var rows: Array = ids.map(func(id):
		var s: Dictionary = cat.system(id)
		return [a("system/%d" % id), a("faction/%d" % int(s.faction)), esc(safety_name(int(s.safety))), str(stations_of(id).size()), "%d, %d" % [int(s.x), int(s.y)]])
	return out + grid([translate("System"), translate("Faction"), translate("Safety"), translate("Stations"), translate("Map")], rows)

func system_page(id: int) -> String:
	var s: Dictionary = cat.system(id)
	var out := h1(system_name(id), translate("System"))
	out += chart(id)
	var rows: Array = [[translate("Faction"), a("faction/%d" % int(s.faction))], [translate("Safety"), esc(safety_name(int(s.safety)))],
		[translate("Map position"), "%d, %d, %d" % [int(s.x), int(s.y), int(s.z)]]]
	var gate := int(s.get("jumpgate_station", -1))
	if gate >= 0 and not s.get("links", []).is_empty(): rows.append([translate("Jump gate"), station_link(gate)])
	rows.append([translate("Jump gate links"), links(s.get("links", []).map(func(l): return "system/%d" % int(l)))])
	if hidden(id):
		var sellers := agents_selling(-1, id)
		rows.append([translate("On the map"), esc(translate("Hidden until you learn its coordinates")) + ((": " + links(sellers)) if not sellers.is_empty() else "")])
	if id + SPIRITS_FIRST < SPIRITS_END: rows.append([translate("Local spirit"), a("item/%d" % (SPIRITS_FIRST + id))])
	out += facts(rows)
	out += prose_html("system/%d" % id)
	out += h2(translate("Stations")) + grid([translate("Station"), translate("Tech level"), translate("Agents")], stations_of(id).map(func(st):
		return [station_link(st), str(int(cat.station(st).get("tech", 0))), links(agents_at(st).map(func(i): return "agent/%d" % i))]))
	var story := steps_where(func(m): return int(m.kind) != 13 and int(m.get("station", -2)) in stations_of(id))
	if not story.is_empty(): out += h2(translate("In the story")) + p(links(story))
	var near := range(cat.system_count()).filter(func(other): return other != id)
	near.sort_custom(func(x, y): return cat.travel_distance(id, x) < cat.travel_distance(id, y))
	out += h2(translate("Nearest systems")) + grid([translate("System"), translate("Distance"), translate("Faction")], near.slice(0, 5).map(func(other):
		return [a("system/%d" % other), esc(translate("%s km") % thousands(int(cat.travel_distance(id, other)))), a("faction/%d" % int(cat.system(other).faction))]))
	return out

func station_page(id: int) -> String:
	var st: Dictionary = cat.station(id)
	var system := int(st.system)
	var out := h1(station_name(id), translate("Station"))
	out += chart(system, [id])
	out += facts([[translate("System"), a("system/%d" % system)], [translate("Faction"), a("faction/%d" % int(cat.system(system).faction))],
		[translate("Tech level"), str(int(st.tech))], [translate("Safety"), esc(safety_name(int(cat.system(system).safety)))]])
	out += prose_html("station/%d" % id)
	var people := agents_at(id)
	if not people.is_empty(): out += h2(translate("Agents in the lounge")) + p(links(people.map(func(i): return "agent/%d" % i)))
	var homes := range(cat.item_count()).filter(func(item): return cat.attr(item, Catalogue.A_HOME_STATION, -1) == id)
	if not homes.is_empty(): out += h2(translate("Always on the shelf")) + p(links(homes.map(func(item): return "item/%d" % item)))
	var shelf := range(cat.item_count()).filter(func(item): return shelf_can_stock(item, id) and not item in homes)
	var notes: Array = [esc(translate("The shop can stock %d kinds of goods and equipment of tech level %d to %d; each visit's shelf is drawn from them.") % [shelf.size(), 1 if int(st.tech) < 4 else int(st.tech) / 2, int(st.tech)])]
	notes.append(esc(translate("Ship dealers take %d%% off the list price here.") % int(st.tech)))
	if system == MIDO: notes.append(esc(translate("The dealers of this system open at story step %d.") % MIDO_DEALER_STEP))
	if id in BAR_EXCLUDED: notes.append(esc(translate("Freelance jobs never send you here.")))
	out += h2(translate("Trade")) + bullets(notes)
	var weapons := shelf.filter(func(item): return item_category(item) in ["weapons", "equipment"])
	if not weapons.is_empty(): out += p(esc(translate("Weapons and equipment that can be on sale:")) + " " + links(weapons.map(func(item): return "item/%d" % item)))
	var story := steps_where(func(m): return int(m.kind) != 13 and int(m.get("station", -2)) == id)
	if not story.is_empty(): out += h2(translate("In the story")) + p(links(story))
	var others: Array = stations_of(system).filter(func(other): return other != id)
	if not others.is_empty(): out += h2(translate("Other stations in the system")) + p(links(others.map(func(other): return "station/%d" % other)))
	return out

func faction_page(race: int) -> String:
	var out := h1(faction_name(race), translate("Faction"))
	out += prose_html("faction/%d" % race)
	var held := range(cat.system_count()).filter(func(s): return int(cat.system(s).faction) == race)
	var rows: Array = []
	if not held.is_empty():
		rows.append([translate("Systems"), links(held.map(func(s): return "system/%d" % s))])
		var count := 0
		for s in held: count += stations_of(s).size()
		rows.append([translate("Stations"), str(count)])
	var people := range(library.data.agents.size()).filter(func(i): return int(cat.agent(i).race) == race)
	if not people.is_empty(): rows.append([translate("Agents"), links(people.map(func(i): return "agent/%d" % i))])
	if race == 1: rows.append([translate("Dealers sell"), a("ship/%d" % VOSSK_HULL)])
	elif race == 9: rows.append([translate("Ship"), a("ship/%d" % VOID_HULL)])
	if race == 1:
		var only := range(cat.item_count()).filter(func(item): return cat.attr(item, Catalogue.A_VOSSK_ONLY) == 1)
		if not only.is_empty(): rows.append([translate("Sold only in Vossk systems"), links(only.map(func(item): return "item/%d" % item))])
	if not rows.is_empty(): out += h2(translate("In the game")) + facts(rows)
	if not held.is_empty(): out += chart(-1)
	return out

func ship_page(id: int) -> String:
	var s: Dictionary = cat.ship(id)
	var out := h1(ship_name(id), translate("Ship"))
	out += prose_html("ship/%d" % id)
	var slots := cat.ship_slots(id)
	out += h2(translate("Specifications")) + facts([[translate("Armour"), str(int(s.armor))], [translate("Cargo"), esc(translate("%d t") % int(s.cargo))],
		[translate("Primary weapons"), str(slots[0])], [translate("Secondary weapons"), str(slots[1])], [translate("Turrets"), str(slots[2])],
		[translate("Equipment"), str(slots[3])], [translate("Handling"), str(int(s.handling))], [translate("List price"), money(int(s.price))]])
	var notes: Array = []
	if id == VOSSK_HULL: notes.append(esc(translate("Sold only by dealers in Vossk systems, which offer nothing else.")) + " " + a("faction/1"))
	elif id == VOID_HULL: notes.append(esc(translate("Offered only as a prototype at %s, once every medal is gold.") % station_name(10)))
	elif id in DEALER_EXCLUDED: notes.append(esc(translate("Ordinary dealers never offer it.")))
	else: notes.append(esc(translate("Any dealer outside Vossk systems may offer it; up to five hulls are on offer at a visit.")))
	notes.append(esc(translate("A dealer takes its station's tech level in percent off the list price, and allows four fifths of the list price for your own hull.")))
	if id == 0: notes.append(esc(translate("Gunant lends you one for mining at the start of the story.")) + " " + step_link(1))
	out += h2(translate("Availability")) + bullets(notes)
	var rows: Array = range(cat.ship_count()).filter(is_ship).map(func(other):
		var hull: Dictionary = cat.ship(other)
		var their := cat.ship_slots(other)
		return ["<strong>%s</strong>" % esc(ship_name(other)) if other == id else a("ship/%d" % other), str(int(hull.armor)), str(int(hull.cargo)), "%d/%d/%d/%d" % their, money(int(hull.price))])
	return out + h2(translate("Compare")) + grid([translate("Ship"), translate("Armour"), translate("Cargo"), translate("Slots"), translate("Price")], rows)

func item_page(id: int) -> String:
	var out := h1(item_name(id), item_kind(id))
	out += prose_html("item/%d" % id)
	var rows: Array = [[translate("Kind"), esc(item_kind(id))], [translate("Tech level"), str(cat.tech(id))]]
	for fact: Array in preload("res://src/screens/station/common.gd").item_facts(library, cat, id):
		rows.append([str(fact[0]), esc(str(fact[1]))])
	if cat.price_mid(id) > 0: rows.append([translate("Price range"), "%s – %s" % [money(cat.price_min(id)), money(cat.price_max(id))]])
	var origin := cat.attr(id, Catalogue.A_ORIGIN, -1)
	if origin >= 0 and origin < cat.system_count() and cat.price_mid(id) > 0: rows.append([translate("Cheapest in"), a("system/%d" % origin)])
	var reference := cat.attr(id, Catalogue.A_REFERENCE, -1)
	if reference >= 0 and reference < cat.system_count() and cat.price_mid(id) > 0 and reference != origin: rows.append([translate("Dearest towards"), a("system/%d" % reference)])
	if cat.attr(id, Catalogue.A_OCCURRENCE) > 0 and not cat.is_blueprint_product(id): rows.append([translate("Shop chance"), "%d%%" % cat.attr(id, Catalogue.A_OCCURRENCE)])
	var home := cat.attr(id, Catalogue.A_HOME_STATION, -1)
	if cat.has_attr(id, Catalogue.A_HOME_STATION) and not cat.station(home).is_empty(): rows.append([translate("Always on the shelf at"), station_link(home)])
	if cat.attr(id, Catalogue.A_VOSSK_ONLY) == 1: rows.append([translate("Sold"), esc(translate("Only in Vossk systems")) + " · " + a("faction/1")])
	rows.append([translate("Stacks"), esc(translate("Yes") if cat.stackable(id) else translate("No, one per slot"))])
	out += h2(translate("Specifications")) + facts(rows)
	if cat.is_blueprint_product(id):
		var recipe: Dictionary = cat.item(id)
		var parts: Array = []
		for i in recipe.ingredients.size():
			parts.append([a("item/%d" % int(recipe.ingredients[i])), str(int(recipe.amounts[i]))])
		out += h2(translate("Blueprint")) + p(esc(translate("Never sold in shops: buy the blueprint, then hand over the ingredients at any station. Production is paid per batch, and goods sent from another station cost %d cr a tonne.") % 10))
		out += grid([translate("Ingredient"), translate("Amount")], parts)
		var sellers := agents_selling(id)
		if not sellers.is_empty(): out += p(esc(translate("Blueprint sold by:")) + " " + links(sellers))
	var uses := recipes_using(id)
	if not uses.is_empty(): out += h2(translate("Ingredient of")) + p(links(uses.map(func(other): return "item/%d" % other)))
	var same := range(cat.item_count()).filter(func(other): return other != id and cat.type(other) == cat.type(id))
	if not same.is_empty() and same.size() < 40: out += h2(translate("Same kind")) + p(links(same.map(func(other): return "item/%d" % other)))
	return out

func agent_page(id: int) -> String:
	var agent: Dictionary = cat.agent(id)
	var out := h1(agent_name(id), translate("Agent"))
	var offer := Catalogue.agent_offer(agent)
	var rows: Array = [[translate("Race"), a("faction/%d" % int(agent.race))], [translate("Lounge"), station_link(int(agent.station))], [translate("System"), a("system/%d" % cat.system_of_station(int(agent.station)))]]
	if int(offer.blueprint) >= 0: rows.append([translate("Sells"), esc(translate("Blueprint:")) + " " + a("item/%d" % int(offer.blueprint))])
	if int(offer.system) >= 0: rows.append([translate("Sells"), esc(translate("Coordinates of")) + " " + a("system/%d" % int(offer.system))])
	rows.append([translate("Price"), money(int(agent.get("price", 0)))])
	out += facts(rows)
	out += prose_html("agent/%d" % id)
	return out

func job_page(kind: int) -> String:
	var out := h1(job_name(kind), translate("Freelance job"))
	out += prose_html("job/%d" % kind)
	var notes: Array = []
	if kind in EARLY_JOBS: notes.append(esc(translate("Offered from the start.")))
	elif kind == 8: notes.append(esc(translate("Offered by buyers in the lounge, who want goods brought to them.")))
	else: notes.append(esc(translate("Offered from story step %d, in a build that carries the full campaign.") % MIDO_DEALER_STEP))
	match kind:
		7: notes.append(esc(translate("Pays less than most jobs.")))
		9: notes.append(esc(translate("Pays a fifth more than most jobs.")))
		3, 5: notes.append(esc(translate("Pays double.")))
		11: notes.append(esc(translate("Pays per passenger carried.")))
	notes.append(esc(translate("Rewards grow with the difficulty, the distance to the destination and your rank.")))
	out += h2(translate("Offers")) + bullets(notes)
	var story := steps_where(func(m): return int(m.kind) == kind and kind < JOB_KINDS and not kind in [0, 11])
	if not story.is_empty(): out += h2(translate("Story steps of this kind")) + p(links(story))
	return out

func medal_page(id: int) -> String:
	var out := h1(medal_name(id), translate("Medal")) + prose_html("medal/%d" % id)
	var thresholds: Array = Medals.table(library)[id] if id < Medals.table(library).size() else []
	var tiers := [translate("Gold"), translate("Silver"), translate("Bronze")]
	var rows: Array = []
	for tier in thresholds.size():
		if jar_speaks(): rows.append([tiers[tier] if thresholds.size() > 1 else translate("Award"), esc(Medals.description(library, id, tier + 1))])
		else: rows.append([tiers[tier] if thresholds.size() > 1 else translate("Award"), str(int(thresholds[tier]))])
	if rows.is_empty() and jar_speaks(): out += p(esc(text(Medals.DESCRIPTION_TEXT + id)))
	out += facts(rows)
	if id == Medals.table(library).size() - 1: out += p(esc(translate("Awarded for holding every other medal.")))
	return out

func step_page(step: int) -> String:
	var m := mission(step)
	var out := h1(step_title(step), translate("Story step %d of %d") % [step, FINAL_STEP] if step < FINAL_STEP else translate("Epilogue"))
	var around := PackedStringArray()
	if step > 0 and entries.has("step/%d" % (step - 1)): around.append("← " + a("step/%d" % (step - 1)))
	if step < limit and entries.has("step/%d" % (step + 1)): around.append(a("step/%d" % (step + 1)) + " →")
	if not around.is_empty(): out += p(" · ".join(around))
	var rows: Array = [[translate("Objective"), objective(step)]]
	if int(m.get("reward", 0)) > 0: rows.append([translate("Reward"), money(int(m.reward))])
	var speakers := step_speakers(step)
	if not speakers.is_empty(): rows.append([translate("Characters"), links(speakers.map(func(s): return "character/%d" % s))])
	if entries.has("dialogue/%d" % step): rows.append([translate("Dialogue"), "<a href=\"wiki://dialogue/%d\">%s</a>" % [step, esc(translate("Briefing, radio and debriefing"))]])
	out += facts(rows)
	out += prose_html("step/%d" % step)
	var where := int(m.get("station", -2)) if int(m.get("kind", -1)) != 13 else -2
	if where >= 0: out += chart(cat.system_of_station(where), [where])
	return out

func dialogue_page(step: int) -> String:
	var out := h1(translate("Dialogue: %s") % step_title(step), translate("Step %d") % step)
	out += p("← " + a("step/%d" % step))
	if not jar_speaks(): out += p("<em>%s</em>" % esc(translate("The dialogue is shown as written in your imported game.")))
	var briefing := lines(step, 0)
	if not briefing.is_empty(): out += h2(translate("Briefing")) + dialogue(briefing)
	var calls := radio(step)
	if not calls.is_empty(): out += h2(translate("Radio")) + dialogue(calls)
	var debriefing := lines(step, 1)
	if not debriefing.is_empty():
		if finished(step): out += h2(translate("Debriefing")) + dialogue(debriefing)
		else: out += h2(translate("Debriefing")) + p("<em>%s</em>" % esc(translate("Shown once you finish this step.")))
	return out

func character_page(id: int) -> String:
	var out := h1(speaker_name(id), translate("Character"))
	var seen := appearances(id)
	var rows: Array = []
	if not seen.is_empty():
		rows.append([translate("First appearance"), "<a href=\"wiki://step/%d\">%s</a>" % [seen[0], esc(translate("Step %d") % seen[0])]])
		rows.append([translate("Steps"), str(seen.size())])
	if not rows.is_empty(): out += facts(rows)
	out += prose_html("character/%d" % id)
	if not seen.is_empty():
		out += h2(translate("Appearances")) + p(", ".join(seen.map(func(step): return "<a href=\"wiki://step/%d\">%d</a>" % [step, step])))
	return out

## The reference's own guide to the controls, or its tips; the game's own
## help and loading tips follow when the imported game speaks the reader's
## language.
const HELP_TITLES := [112, 296, 275, 79, 130, 218, 72, 146, 297, 63, 298]
const HELP_TEXTS := [306, 307, 308, 309, 312, 314, 315, 320, 321, 323, 324]
const TIPS := [165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177]
func guide_page(which: String) -> String:
	var out := h1(entries["guide/" + which].title, translate("Guide")) + prose_html("guide/" + which)
	if not jar_speaks(): return out
	if which == "tips":
		var seen := {}
		var tips: Array = []
		for id in TIPS:
			var tip := text(id)
			if tip.strip_edges().is_empty() or seen.has(tip): continue
			seen[tip] = true; tips.append(esc(tip))
		return out + (h2(translate("Loading tips")) + bullets(tips) if not tips.is_empty() else "")
	out += h2(translate("In-game help"))
	for i in HELP_TITLES.size():
		var body := text(HELP_TEXTS[i])
		# The original heads each help text with its title in capitals.
		var lines_ := body.split("\n", true, 1)
		if lines_.size() > 1 and lines_[0].strip_edges() == lines_[0].strip_edges().to_upper(): body = lines_[1]
		out += p("<strong>%s</strong><br/>%s" % [esc(text(HELP_TITLES[i])), esc(body.strip_edges())])
	return out

# --- pictures -------------------------------------------------------------

## What the reader shows beside a page: {"ship": hull, "faction"}, {"station":
## id}, {"item": id}, {"portrait": face}, {"image": name}, {"map": {highlight,
## marked}} or {"glyph": icon}. Pictures come from the player's imported
## art, as the game itself shows them.
func media(key: String) -> Dictionary:
	var parts := key.split("/")
	var id := int(parts[1]) if parts.size() > 1 and parts[1].is_valid_int() else -1
	match parts[0]:
		"ship": return {"ship": id, "faction": VOSSK_HULL_FACTION if id == VOSSK_HULL else 0}
		"station": return {"station": id, "map": {"highlight": cat.system_of_station(id), "marked": [id]}}
		"item": return {"item": id}
		"agent": return {"portrait": cat.agent(id).get("face", []), "speaker": -1}
		"character": return portrait(id)
		"system": return {"map": {"highlight": id, "marked": []}}
		"faction":
			if id >= 0 and id < 4: return {"image": "logo_%d" % id, "map": {"highlight": -1, "marked": [], "faction": id}}
			return {"glyph": "status"}
		"chart", "home": return {"map": {"highlight": -1, "marked": []}}
		"medal": return {"medal": 1}
		"job": return {"glyph": "missions"}
		"dialogue": return media("step/%d" % id)
		"step":
			var m := mission(id)
			if int(m.get("station", -1)) >= 0: return {"map": {"highlight": cat.system_of_station(int(m.station)), "marked": [int(m.station)]}}
			for line in lines(id, 0) + radio(id):
				if entries.has("character/%d" % line.speaker): return portrait(line.speaker)
			return {"glyph": "missions"}
		"world": return {"map": {"highlight": -1, "marked": []}} if parts[1] in ["galaxy", "history"] else {"glyph": "game"}
		"section": return {}
	return {"glyph": GUIDE_GLYPHS.get(parts[1] if parts.size() > 1 else "", "info")}

## Vossk ships wear their own colours (the dealer's faction).
const VOSSK_HULL_FACTION := 1
const GUIDE_GLYPHS := {"basics": "info", "flight": "hangar", "navigation": "map", "mining": "sell", "trading": "cart",
	"combat": "status", "fitting": "hangar", "jobs": "missions", "lounge": "chat", "blueprints": "info", "medals": "game", "help": "controls", "tips": "info"}

func portrait(speaker: int) -> Dictionary:
	var face := Portrait.speaker_face(library, speaker)
	return {"portrait": face, "speaker": speaker} if not face.is_empty() else {"glyph": "status"}

## The small picture beside a page's name in the lists.
func icon(key: String) -> Dictionary:
	var parts := key.split("/")
	match parts[0]:
		"ship", "item", "character", "agent", "medal": return media(key)
		"faction":
			var id := int(parts[1])
			return {"image": "logo_%d" % id} if id >= 0 and id < 4 else {"glyph": "status"}
		"system", "chart": return {"glyph": "map"}
		"station": return {"glyph": "hangar"}
		"step": return {"glyph": "missions"}
		"job": return {"glyph": "missions"}
		"world": return {"glyph": "game"}
	return media(key) if parts[0] == "guide" else {"glyph": "info"}
