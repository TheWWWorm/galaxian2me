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
		if e.desc == "(I)V" and e.args.size() == 1: m.target = _value(e.args[0])
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
	var m: Dictionary = game.session.story_mission
	if m.is_empty() or int(m.get("station", -2)) != station_id: return
	if not complete(m): return
	var step: int = game.session.story_step
	game.pending_dialogue.append_array(dialogue(step, 1))
	game.session.credits += int(m.get("reward", 0))
	if not step_supported(step + 1):
		game.session.flags["story_halted"] = true
		return
	advance()

## Whether a story mission's goal is met, by its kind.
func complete(m: Dictionary) -> bool:
	match int(m.get("kind", -1)):
		KIND_DOCK:
			return true
		KIND_MINING:
			var ore := 0
			for id in range(154, 176):
				ore += game.session.cargo_count(id)
			return ore >= int(m.get("target", 0)) or (int(m.get("target", 0)) >= 25 and game.session.cargo_free() <= 0)
		KIND_EQUIP:
			return _equipped_for_combat()
		KIND_BUY:
			return game.session.cargo_count(int(m.get("item", -1))) >= int(m.get("amount", 0))
	return bool(m.get("done", false))

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
