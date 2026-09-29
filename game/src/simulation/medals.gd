extends RefCounted
## Medals, as the original awards them: a table of thresholds per medal
## (recovered from the supplied game), tier 1 gold, 2 silver, 3 bronze, 0
## none. The pilot's record is checked on the way into a station and the
## improved medals are awarded once docked, where they are announced. Names
## are strings 745+, descriptions 782+ (# stands for the reached threshold).

const Catalogue := preload("res://src/content/catalogue.gd")

const NAME_TEXT := 745
const DESCRIPTION_TEXT := 782
const POPUP_TITLE := 178
## Ore, core and drink item ranges the collection medals count.
const ORE_FIRST := 154
const CORE_FIRST := 165
const DRINK_FIRST := 132
const DRINK_LAST := 153

static func table(lib) -> Array:
	var t = lib.constant("br.a:[[I")
	return t if t is Array else []

static func tier(session, index: int) -> int:
	return int(session.medals.get(str(index), 0))

static func name(lib, index: int) -> String:
	return lib.text(NAME_TEXT + index)

static func description(lib, index: int, medal_tier: int) -> String:
	var t := table(lib)
	var text: String = lib.text(DESCRIPTION_TEXT + index)
	if index < t.size() and medal_tier >= 1 and medal_tier <= (t[index] as Array).size():
		text = text.replace("#", str(int(t[index][medal_tier - 1])))
	return text

## Sets a bit in an integer statistic (collections of kinds).
static func mark(session, key: String, bit: int) -> void:
	if bit < 0 or bit > 62: return
	session.stats[key] = session.stat(key) | (1 << bit)

static func bits(value: int) -> int:
	var n := 0
	while value != 0:
		n += value & 1
		value >>= 1
	return n

## Record-keeping that the original updates continuously.
static func track(session) -> void:
	if session.credits > session.stat("max_credits"): session.stats["max_credits"] = session.credits
	var free: int = session.cargo_free()
	if free > session.stat("max_free_cargo"): session.stats["max_free_cargo"] = free

## Checks the whole record on the way into a station. `hull_percent` is the
## ship's remaining hull before the dock's repair. Returns {index: tier} for
## medals that improve on those already held.
static func check(session, cat, lib, hull_percent: int) -> Dictionary:
	track(session)
	var t := table(lib)
	var found := {}
	var primaries := 0
	var weapons := 0
	var equipment := 0
	# Achievements.checkForNewMedal looks at the fitted equipment only once
	# the campaign is past its seventh mission (the tutorial ship's guns do
	# not count); before that the pilot counts as armed.
	for c in (session.equipment.size() if session.story_step > 7 else 0):
		for e in session.equipment[c]:
			if e == null: continue
			if c == 0: primaries += 1
			if c == 3: equipment += 1
			else: weapons += 1
	var armed: bool = session.story_step <= 7 or (weapons > 0 and equipment > 0)
	var produced := 0
	for key in session.blueprints:
		if int(session.blueprints[key].get("produced", 0)) > 0: produced += 1
	var rep: Array = session.reputation
	for i in t.size():
		var row: Array = t[i]
		var reached := 0
		for j in row.size():
			var v := int(row[j])
			var ok := false
			match i:
				0: ok = true
				1: ok = hull_percent >= 0 and hull_percent <= v
				2: ok = bits(session.stat("ore_types")) >= v
				3: ok = bits(session.stat("core_types")) >= v
				4: ok = session.stat("kills") >= v
				5: ok = session.stat("goods_conveyed") > v
				6: ok = session.stat("ore_mined") > v
				7: ok = session.stat("cores_mined") > v
				8: ok = session.stat("booze_bought") > v
				9: ok = bits(session.stat("drink_types")) >= v
				10: ok = session.stat("junk_destroyed") > v
				11: ok = session.visited_stations.size() >= v
				12: ok = session.visited_systems.size() >= v
				13: ok = session.blueprints.size() >= v
				14: ok = produced >= v
				15: ok = session.playtime_ms > v * 3600000
				16: ok = session.stat("jobs") > v
				17: ok = session.stat("jumpgates") >= v
				18: ok = session.stat("passengers") > v
				19: ok = session.stat("cloaked_ms") / 60000 >= v
				20: ok = session.stat("bombs_used") > v
				21: ok = session.stat("alien_junk") > v
				22: ok = not armed
				23: ok = primaries >= v
				24: ok = session.stat("cargo_salvaged") >= v
				25: ok = session.stat("max_credits") >= v
				26: ok = session.stat("bar_talks") > v
				27: ok = session.stat("commanded_wingmen") > v
				28: ok = absi(int(rep[0])) > 60 or absi(int(rep[1])) > 60
				29: ok = session.stat("asteroids_destroyed") > v
				30: ok = session.story_step > 44 or bool(session.flags.get("game_won", false))
				31: ok = session.stat("max_free_cargo") > v
				32: ok = session.stat("rejected") > v
				33: ok = session.stat("asked_repeat") > v
				34: ok = session.stat("accepted_unasked_difficulty") > v
				35: ok = session.stat("accepted_unasked_location") > v
				_: ok = false
			if ok:
				reached = j + 1
				break
		var held := tier(session, i)
		if reached > 0 and (held == 0 or reached < held): found[i] = reached
	return found

## Awards medals found by `check` and, when every other medal is held, the
## final one. Returns the awarded medals in order, for announcement.
static func award(session, lib, found: Dictionary) -> Array:
	var out: Array = []
	var keys := found.keys()
	keys.sort()
	for i in keys:
		session.medals[str(i)] = int(found[i])
		out.append([int(i), int(found[i])])
	var count := table(lib).size()
	if count > 0 and tier(session, count - 1) == 0:
		var all := true
		for i in count - 1:
			if tier(session, i) == 0: all = false
		if all:
			session.medals[str(count - 1)] = 1
			out.append([count - 1, 1])
	if count > 0 and held_count(session, lib) == count: session.flags["all_medals"] = true
	var gold := count > 0
	for i in count:
		if tier(session, i) != 1: gold = false
	if gold: session.flags["all_gold"] = true
	return out

static func held_count(session, lib) -> int:
	var n := 0
	for i in table(lib).size():
		if tier(session, i) > 0: n += 1
	return n
