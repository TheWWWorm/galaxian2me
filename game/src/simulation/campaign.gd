extends RefCounted
## The story: which step the player is on, the story mission of that step and
## its dialogue. Steps, missions and lines are the imported progression and
## dialogue tables; this class only reads and advances them.

const Catalogue := preload("res://src/content/catalogue.gd")

## Story mission kinds shared with freelance jobs (string 179 + kind names
## the freelance ones). Story-only kinds are handled by the flight scripts.
const KIND_PIRATES := 4
const KIND_BUY := 8
const KIND_DOCK := 11
const KIND_CHALLENGE := 12
const KIND_MINING := 18
const KIND_EQUIP := 22

var game
var library
var steps: Array = []
var start := {}
var briefings: Array = []
var debriefings: Array = []
## Journal line per story step (the pilot's own summary of what to do).
var journal_lines: Array = []

func _init(owner) -> void:
	game = owner
	library = owner.library
	var table: Dictionary = library.data.get("campaign", {})
	steps = table.get("steps", [])
	start = table.get("start", {})
	_find_dialogue_tables()
	_find_journal()

## The two dialogue tables: per story step, pairs of (speaker, line). They are
## the only nested short arrays of that shape among the recovered constants.
func _find_dialogue_tables() -> void:
	var found := {}
	for key in library.data.constants:
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
			var owner: String = key.substr(0, key.find("."))
			if not found.has(owner): found[owner] = []
			found[owner].append(key)
	for owner in found:
		var keys: Array = found[owner]
		if keys.size() == 2:
			keys.sort()
			briefings = library.data.constants[keys[0]]
			debriefings = library.data.constants[keys[1]]
			return

## The journal table: one string index per step, all within the story's
## journal block of the string table.
func _find_journal() -> void:
	var want := steps.size() + 1
	for key in library.data.constants:
		if not key.ends_with(":[S"): continue
		var v = library.data.constants[key]
		if v is Array and v.size() >= want and v.size() <= want + 4 and v.all(func(x): return x is int and x >= 300 and x < 450):
			journal_lines = v
			return

func journal() -> String:
	var step: int = game.session.story_step
	if step < 0 or step >= journal_lines.size(): return ""
	var text: String = library.text(int(journal_lines[step]))
	var m: Dictionary = game.session.story_mission
	if text.contains("#") and not m.is_empty():
		var st: Dictionary = game.cat.station(int(m.get("station", -1)))
		text = text.replace("#", str(st.get("name", "?")))
	return text

func available() -> bool:
	return not steps.is_empty() and not start.is_empty()

## Steps whose station depends on data this build does not carry.
func step_supported(step: int) -> bool:
	var rec := step_record(step)
	if rec.is_empty(): return step == 0
	for m in rec.get("missions", []):
		if m.size() >= 3 and m[2] is Dictionary: return false
	return true

func step_record(step: int) -> Dictionary:
	for r in steps:
		if int(r.step) == step: return r
	return {}

func mission_from(args: Array) -> Dictionary:
	if args.size() < 3: return {}
	return {"story": true, "kind": int(args[0]), "reward": int(args[1]), "station": int(args[2]),
		"step": game.session.story_step, "target": 0, "item": -1, "amount": 0, "progress": 0}

func begin() -> void:
	game.session.story_step = 0
	game.session.story_mission = mission_from(start.get("mission", [])) if available() else {}

func current() -> Dictionary:
	return game.session.story_mission

## Advances to the next step and builds its story mission.
func advance() -> void:
	var s = game.session
	s.story_step += 1
	var rec := step_record(s.story_step)
	s.story_mission = {}
	for m in rec.get("missions", []):
		s.story_mission = mission_from(m)
	for e in rec.get("effects", []):
		_apply_effect(e)
	for key in rec.get("statics", {}):
		_apply_static(key, rec.statics[key])

## Settings the progression applies to the mission it just built.
func _apply_effect(e: Dictionary) -> void:
	var m: Dictionary = game.session.story_mission
	if e.owner == _mission_class():
		if e.desc == "(I)V" and e.args.size() == 1:
			m.target = _value(e.args[0])
			if e.args[0] is Dictionary:
				m.target_expr = e.args[0]
				m.jobs_at_start = game.session.stat("jobs")
		elif e.desc == "(II)V" and e.args.size() == 2:
			m.item = int(e.args[0]); m.amount = int(e.args[1])
		elif e.desc == "(Z)V" and e.args.size() == 1: m.visible = bool(e.args[0])

func _apply_static(_key: String, _value) -> void:
	pass

func _mission_class() -> String:
	var rec := step_record(1)
	for e in rec.get("effects", []):
		if e.method == "<init>" and e.desc == "(III)V": return e.owner
	# The mission record type is the parameter of the assignment call.
	for e in rec.get("effects", []):
		if e.desc.begins_with("(L") and e.desc.ends_with(";)V"): return e.desc.substr(2, e.desc.length() - 5)
	return ""

func _value(v) -> int:
	if v is int: return v
	if v is float: return int(v)
	return 0

## Docking: a story mission whose goal is met reports here. The debriefing
## plays, the reward is paid and the story moves on.
func on_dock(station_id: int) -> void:
	_station_events(station_id)
	# Several steps can conclude in a row at one station, as in the original
	# where the docked check runs again after each debriefing.
	for _i in 4:
		if not check(true, station_id): break
		conclude()
		_station_events(station_id)

## The current story mission is done: its debriefing plays, its reward is
## paid, and the next step begins. Returns the debriefing lines.
func conclude() -> Array:
	var m: Dictionary = game.session.story_mission
	var step: int = game.session.story_step
	var lines := dialogue(step, 1)
	game.pending_dialogue.append_array(lines)
	game.session.credits += int(m.get("reward", 0))
	if not step_supported(step + 1):
		game.session.flags["story_halted"] = true
		game.session.story_mission = {}
		return lines
	advance()
	return lines

## What the original does on entering a station at particular story steps.
## Step 1: Gunant's mining ship (hull 0 in his colours, a mining laser and a
## scanner, no guns). Step 20: ten free EMP bombs wait on the story
## station's shelf. Step 27: the alien remains leave the hold.
const STEP1_SHIP := 0
const STEP1_LIVERY := 8
const STEP1_EQUIPMENT := [90, 81]
const STEP20_BOMBS := 41
const STEP27_REMAINS := 131

func _station_events(station_id: int) -> void:
	var s = game.session
	var m: Dictionary = s.story_mission
	match int(s.story_step):
		1:
			if bool(s.flags.get("step1_ship", false)): return
			s.flags["step1_ship"] = true
			s.ship = {"index": STEP1_SHIP, "faction": STEP1_LIVERY, "hull": 0}
			s.equipment = [[], [], [], []]
			s.fit_slots()
			for i in STEP1_EQUIPMENT.size():
				if i < s.equipment[3].size(): s.equipment[3][i] = {"id": STEP1_EQUIPMENT[i], "count": 1}
			s.ship.hull = int(s.ship_stats().max_hull)
		20:
			if int(m.get("station", -1)) == station_id:
				var shelf: Array = game.shelf()
				shelf = shelf.filter(func(e): return int(e.id) != STEP20_BOMBS)
				shelf.append({"id": STEP20_BOMBS, "count": 10, "price": 0})
				game.session.market_for(station_id).items = shelf
		27:
			if int(m.get("station", -1)) == station_id:
				s.add_cargo(STEP27_REMAINS, -s.cargo_count(STEP27_REMAINS))

## Whether a story mission's goal is met, by its kind, as the original checks
## it both while docked and in flight. `flight_ms` is the time spent in space
## at the current station (arrival goals need ten seconds there).
func check(docked: bool, station_id: int, flight_ms := 0) -> bool:
	var m: Dictionary = game.session.story_mission
	if m.is_empty(): return false
	var s = game.session
	var here: bool = int(m.get("station", -2)) == station_id
	var target: int = _value(m.get("target", 0))
	match int(m.get("kind", -1)):
		20: return not docked and here and flight_ms > 10000
		24: return docked or (not here and flight_ms > 10000)
		KIND_BUY: return docked and here and s.cargo_count(int(m.get("item", -1))) >= int(m.get("amount", 0))
		0, KIND_DOCK: return docked and here
		15:
			for e in s.equipped_items():
				if int(e.id) == target: return true
			return false
		21:
			for e in s.equipped_items():
				if game.cat.category(int(e.id)) == target: return true
			return false
		23:
			if not docked: return false
			for e in s.equipped_items():
				if game.cat.type(int(e.id)) == target: return true
			return false
		KIND_EQUIP: return _equipped_for_combat()
		19: return s.stat("produced") >= target
		14: return s.stat("kills") >= target
		13: return s.stat("jobs") >= _counter_target(m)
		16: return s.visited_stations.size() >= target
		KIND_MINING: return s.cargo_used() >= target
	return bool(m.get("done", false))

## Kind 13 counts freelance jobs from the moment the step began: the
## progression stored "jobs so far + N".
func _counter_target(m: Dictionary) -> int:
	var raw = m.get("target_expr", null)
	if raw is Dictionary and raw.has("expr"):
		var e: Array = raw.expr
		if int(e[0]) == 96 and e[2] is int: return int(m.get("jobs_at_start", 0)) + int(e[2])
	return _value(m.get("target", 0))

## Kept for callers that only ask about docking.
func complete(m: Dictionary) -> bool:
	return check(true, int(m.get("station", -1)))

func _equipped_for_combat() -> bool:
	var weapon := false
	for e in game.session.equipment[0]:
		if e != null: weapon = true
	return weapon and game.session.has_equipped_type(Catalogue.Type.ARMOR)

## Briefing lines of the current step that have not been shown yet.
func take_briefing() -> Array:
	var step: int = game.session.story_step
	if bool(game.session.flags.get("briefed_%d" % step, false)): return []
	game.session.flags["briefed_%d" % step] = true
	return dialogue(step, 0)

## Dialogue of a step: [{speaker, line}] for its briefing (mode 0) or
## debriefing (mode 1).
func dialogue(step: int, mode: int) -> Array:
	var table: Array = briefings if mode == 0 else debriefings
	if step < 0 or step >= table.size(): return []
	var row: Array = table[step]
	var out: Array = []
	for i in range(0, row.size(), 2):
		if int(row[i + 1]) == 0: continue
		out.append({"speaker": int(row[i]), "name": library.text(Catalogue.STRING_SPEAKERS + int(row[i])),
			"text": library.text(int(row[i + 1]))})
	return out
