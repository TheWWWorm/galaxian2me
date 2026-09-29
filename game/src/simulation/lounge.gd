extends RefCounted
## The Space Lounge: who sits in a station's bar and what they want, by the
## original's rules. Story agents appear at their stations once the story has
## reached them; the rest are generated: job givers, talkers, sellers,
## buyers, pilots for hire and, when the player's standing is bad, a
## faction's agent offering to smooth things over. Speech is assembled from
## the game's own phrases; jobs use the original's reward formula.

const Catalogue := preload("res://src/content/catalogue.gd")
const Portrait := preload("res://src/presentation/portrait.gd")

enum Kind { JOB, TALK, SELLER, ITEM_AGENT, BLUEPRINT_AGENT, BUYER, WINGMEN, FACTION }

## Stations whose lounges never hand out jobs as destinations.
const BAR_EXCLUDED := [10, 22, 27, 29, 30, 48, 55, 56, 76, 79, 91, 98]
## Percent chance, by item category, that a trader picks up an item.
const TRADER_CATEGORY := [5, 20, 2, 5, 100]
## Courier jobs load this many secure containers (the original's item 116)
## into the hold; they cannot be sold and are handed over on arrival.
const COURIER_FREIGHT := 116

## Game owns the lounge, not the other way around.
var _owner: WeakRef
var game:
	get: return _owner.get_ref()
var cat
var lib
var rng := RandomNumberGenerator.new()

func _init(owner) -> void:
	_owner = weakref(owner)
	cat = owner.cat
	lib = owner.library
	rng.randomize()

func full_edition() -> bool:
	return lib.data.get("online", {}).has("story_stations")

# ------------------------------------------------------------------ names

func random_name(race: int, male: bool) -> String:
	var files := _name_files(race, male)
	var first: Array = lib.data.names.get(files[0], []) if not files[0].is_empty() else []
	var last: Array = lib.data.names.get(files[1], []) if not files[1].is_empty() else []
	var a: String = first[rng.randi_range(0, first.size() - 1)] if not first.is_empty() else ""
	var b: String = last[rng.randi_range(0, last.size() - 1)] if not last.is_empty() else ""
	return (a + " " + b).strip_edges()

func _name_files(race: int, male: bool) -> Array:
	match race:
		0: return ["names_terran_0_m" if male else "names_terran_0_w", "names_terran_1"]
		1: return ["names_vossk_0", "names_vossk_1"]
		2: return ["names_nivelian_0", "names_nivelian_1"]
		3, 8:
			var terran := rng.randi_range(0, 1) == 0
			return ["names_terran_0_m" if terran else "names_nivelian_0", "names_terran_1" if rng.randi_range(0, 1) == 0 else "names_nivelian_1"]
		4: return ["names_multipod_0", "names_multipod_1"]
		5: return ["names_cyborg_0", ""]
		6: return ["names_bobolan_0", "names_bobolan_1"]
		7: return ["names_grey_0", ""]
	return ["", ""]

# ------------------------------------------------------------------ lounge

## The people in a station's lounge.
func generate(station_id: int) -> Array:
	var s = game.session
	var sys: Dictionary = cat.system(cat.system_of_station(station_id))
	var out: Array = []
	var story_open: bool = int(s.story_step) > 16
	for a in lib.data.agents:
		if int(a.station) == station_id and story_open and not s.flags.has("agent_done_%d" % int(a.id)):
			var person := {"name": a.name, "race": int(a.race), "male": bool(a.male), "face": a.face, "agent": int(a.id)}
			if int(a.blueprint) >= 0:
				person.kind = Kind.BLUEPRINT_AGENT
				person.blueprint = int(a.blueprint)
			elif int(a.item) >= 0:
				person.kind = Kind.ITEM_AGENT
				person.item = int(a.item)
			else:
				person.kind = Kind.TALK
			person.price = int(a.price)
			person.speech = _agent_speech(person)
			out.append(person)
	var total := mini(5, out.size() + 3 + rng.randi_range(0, 1))
	var wingmen_offered := false
	while out.size() < total:
		var race: int = int(sys.faction)
		if rng.randi_range(0, 99) < 20: race = rng.randi_range(0, 7)
		var kind := 0
		while true:
			kind = rng.randi_range(0, 6)
			if not ((race == 1 and kind == 6) or kind == 4 or kind == 3): break
		if rng.randi_range(0, 99) < 33 or ((kind == 5 or kind == 6) and int(s.story_step) < 16): kind = 0
		var male: bool = kind == 6 or race != 0 or rng.randi_range(0, 99) < 60
		var person := {"name": random_name(race, male), "race": race, "male": male, "kind": kind,
			"face": Portrait.random_face(lib, male, race, rng)}
		match kind:
			Kind.WINGMEN:
				if wingmen_offered:
					person.kind = Kind.TALK
				else:
					wingmen_offered = true
					var extra := rng.randi_range(0, 2)
					person.pilots = [person.name]
					for _i in extra: person.pilots.append(random_name(race, true))
					person.price = (extra + 1) * (700 + rng.randi_range(0, 1299))
			Kind.SELLER:
				_stock_seller(person, station_id)
			Kind.BUYER:
				person.job = job_for(person, station_id)
			Kind.JOB:
				person.job = job_for(person, station_id)
		person.speech = speech(person)
		out.append(person)
	# Bad standing brings a faction's agent to the bar.
	for faction in [2, 3, 0, 1]:
		if not _hostile_to(faction): continue
		for i in out.size():
			if out[i].has("agent") or int(out[i].kind) == Kind.FACTION: continue
			var agent := {"name": random_name(faction, true), "race": faction, "male": true, "kind": Kind.FACTION,
				"face": Portrait.random_face(lib, true, faction, rng)}
			agent.speech = speech(agent)
			out[i] = agent
			break
	return out

func _hostile_to(faction: int) -> bool:
	var rep: Array = game.session.reputation
	match faction:
		0: return int(rep[0]) < -60
		1: return int(rep[0]) > 60
		2: return int(rep[1]) < -60
		3: return int(rep[1]) > 60
	return false

## A trader's goods: something ordinary, a handful of commodities or a single
## piece of kit, at 40–160% of its usual price.
func _stock_seller(person: Dictionary, station_id: int) -> void:
	var tech_cap := 7 if full_edition() else 3
	var id := -1
	var category := 4
	for _t in 100:
		var n := rng.randi_range(0, cat.item_count() - 1)
		category = cat.category(n)
		if cat.is_blueprint_product(n) or rng.randi_range(0, 99) >= TRADER_CATEGORY[category]: continue
		if rng.randi_range(0, 99) >= cat.attr(n, Catalogue.A_OCCURRENCE) or cat.price_mid(n) <= 0: continue
		if n == 175 or n == 164: continue
		if category != Catalogue.Category.COMMODITY and cat.tech(n) > tech_cap: continue
		id = n
		break
	if id < 0:
		id = 154 + rng.randi_range(0, 9)
		category = Catalogue.Category.COMMODITY
	var count := 1 + rng.randi_range(0, 8) if category == Catalogue.Category.COMMODITY else 1
	var unit := int((40 + rng.randi_range(0, 119)) / 100.0 * cat.price_mid(id))
	person.item = id
	person.count = count
	person.price = count * unit

# ------------------------------------------------------------------ jobs

## A freelance job offered by a client, with the original's choice of kind,
## destination, difficulty and reward.
func job_for(person: Dictionary, station_id: int) -> Dictionary:
	var s = game.session
	var here: int = cat.system_of_station(station_id)
	var dest := _destination(station_id)
	var kind := 0
	while true:
		kind = rng.randi_range(0, 12)
		if kind != 8: break
	if int(s.story_step) < 16 or not full_edition():
		kind = [11, 0, 7, 4, 12][rng.randi_range(0, 4)]
	if kind == 12: dest = station_id
	if int(person.kind) == Kind.BUYER:
		kind = 8
		dest = station_id
	if kind == 11 or kind == 0:
		for _t in 50:
			if dest != station_id: break
			dest = _destination(station_id)
	var difficulty := 1 + rng.randi_range(0, 1) if int(s.story_step) < 16 else 1 + rng.randi_range(0, 8)
	var count := 0
	var item := 0
	match kind:
		8:
			for _t in 200:
				item = 97 + rng.randi_range(0, cat.item_count() - 98)
				if cat.price_mid(item) > 0 and item != 175 and item != 164 and item != 131: break
			count = 5 + rng.randi_range(0, 14)
			difficulty = cat.tech(item)
		3, 5:
			count = 2 + int(8.0 * difficulty / 10.0)
			item = 116 if kind == 3 else 117
		0:
			count = 5 + int(95.0 * difficulty / 10.0)
			item = rng.randi_range(0, 6)
		11:
			count = 2 + int(18.0 * difficulty / 10.0)
		2:
			count = 2 + rng.randi_range(0, 3)
	difficulty = mini(10, difficulty)
	var distance_factor: float = 1.0 + cat.travel_distance(here, cat.system_of_station(dest)) / 1200.0
	var reward := 1500.0 + difficulty / 10.0 * 5500.0
	reward *= distance_factor
	reward += int(s.stat("rank")) * 200
	match kind:
		7: reward *= 0.7
		9: reward *= 1.2
		8: reward = reward / 2.0 + count * cat.price_mid(item) * 3
		11:
			reward *= 0.6
			reward += count * (reward / 5.0)
		5, 3: reward *= 2.0
	var r := _round50(int(reward))
	var job := {"kind": kind, "client": person.name, "race": person.race, "face": person.face, "reward": r,
		"station": dest, "difficulty": difficulty, "item": item, "count": count, "story": false}
	if kind == 6: job.wanted = random_name(0, true)
	return job

func _round50(v: int) -> int:
	var rest := v % 50
	return v + rest if (v + rest) % 50 == 0 else v - rest

## Where a job leads: often this system, sometimes anywhere the player has
## been; never a story station, never a system without a way in.
func _destination(station_id: int) -> int:
	var here: int = cat.system_of_station(station_id)
	var s = game.session
	for _t in 200:
		var pick := 0
		if rng.randi_range(0, 99) < 20:
			pick = station_id
		elif rng.randi_range(0, 99) < 40:
			var list: Array = cat.system(here).get("stations", [])
			pick = int(list[rng.randi_range(0, list.size() - 1)])
		else:
			pick = rng.randi_range(0, lib.data.stations.size() - 1)
		if here == 15:
			var mido: Array = cat.system(here).get("stations", [])
			pick = int(mido[rng.randi_range(0, mido.size() - 1)])
		if pick in BAR_EXCLUDED: continue
		var sys_index: int = cat.system_of_station(pick)
		if not s.visited_systems.has(str(sys_index)) and not bool(cat.system(sys_index).get("visible", false)): continue
		if cat.system(sys_index).get("links", []).is_empty() and sys_index != here: continue
		return pick
	return station_id

# ------------------------------------------------------------------ speech

func _pick(first: int, count: int) -> String:
	return lib.text(first + rng.randi_range(0, count - 1))

func _money(v: int) -> String:
	return preload("res://src/presentation/ui.gd").money(v)

func speech(p: Dictionary) -> String:
	var kind := int(p.kind)
	var greet := kind != Kind.TALK and kind != Kind.FACTION
	var ask := kind == Kind.JOB or kind == Kind.BUYER
	var hello := _pick(390, 6) if greet else ""
	var intro := _pick(396, 2).replace("#N", str(p.name)) if greet else ""
	var plea := _pick(398, 6) if ask else ""
	var body := ""
	match kind:
		Kind.FACTION:
			var race := int(p.race)
			var rep: Array = game.session.reputation
			var axis := 1 if race == 2 or race == 3 else 0
			var amount := int(absf(float(rep[axis])) / 100.0 * 16000.0)
			p.price = amount
			body = lib.text(509 if race == 2 else (510 if race == 3 else (511 if race == 0 else 512))).replace("#C", _money(amount))
			return body
		Kind.BUYER:
			var job: Dictionary = p.job
			body = _pick(416, 2).replace("#Q", str(job.count)).replace("#P", cat.item_name(int(job.item))).replace("#C", _money(int(job.reward)))
		Kind.TALK:
			var n := rng.randi_range(0, 19)
			if int(p.race) != 0 and n == 16: n = 4
			body = lib.text(455 + n).replace("#S", _random_station_name()).replace("#N", str(p.name)).replace("#ORE", _pick(723, 10))
			return body
		Kind.JOB:
			var job: Dictionary = p.job
			if int(job.kind) == 12:
				return lib.text(437).replace("#C", _money(int(job.reward))) + "\n" + _pick(475, 3)
			body = lib.text(425 + int(job.kind))
			if int(job.kind) == 5 or int(job.kind) == 3: body += " " + lib.text(438)
			body = body.replace("#P", lib.text(448 + int(job.item))).replace("#Q", str(job.count))
			body = body.replace("#S", cat.station_name(int(job.station))).replace("#N", str(job.get("wanted", "")))
			body += "\n" + _pick(404, 3).replace("#C", _money(int(job.reward)))
		Kind.SELLER:
			body = _pick(407, 4) + "\n" + _pick(412, 2)
			body = body.replace("#Q", str(p.count)).replace("#P", cat.item_name(int(p.item))).replace("#C", _money(int(p.price)))
			if int(p.count) > 1: body += " " + lib.text(414).replace("#C", _money(int(p.price) / int(p.count)))
		Kind.WINGMEN:
			var extra: int = p.pilots.size() - 1
			var fans := bool(game.session.flags.get("all_medals", false))
			body = lib.text((421 if fans else 418) + extra).replace("#C", _money(int(p.price)))
			if extra > 0: body = body.replace("#W", str(p.pilots[1]))
	return (hello + " " + intro + " " + plea).strip_edges() + "\n" + body + "\n" + _pick(475, 3)

func _agent_speech(p: Dictionary) -> String:
	var text: String = _pick(505, 2) + " " + lib.text(516 + int(p.agent))
	if int(p.kind) == Kind.BLUEPRINT_AGENT:
		text += " " + lib.text(508)
		text = text.replace("#S", cat.system_name(int(lib.data.agents[int(p.agent)].system)))
	elif int(p.kind) == Kind.ITEM_AGENT:
		text += " " + lib.text(507)
		text = text.replace("#N", cat.item_name(int(p.item)))
	return text.replace("#C", _money(int(p.price))) + "\n" + _pick(475, 3)

func _random_station_name() -> String:
	var stations: Array = lib.data.stations
	return str(stations[rng.randi_range(0, stations.size() - 1)].name)

# ------------------------------------------------------------------ deals

## Accepting a person's offer. Returns "" or the reason it cannot be done.
func accept(person: Dictionary) -> String:
	var s = game.session
	match int(person.kind):
		Kind.JOB, Kind.BUYER:
			var job: Dictionary = person.job
			if not s.job.is_empty(): return lib.text(254)
			if int(job.kind) == 0 and s.cargo_free() < int(job.count):
				return lib.text(162).replace("#Q", str(job.count))
			if int(job.kind) == 11 and int(s.ship_stats().cabins) < int(job.count):
				return lib.text(163).replace("#Q", str(int(job.count)))
			s.job = job.duplicate(true)
			if int(job.get("station", -1)) != s.station_id:
				if not bool(person.get("asked_difficulty", false)): s.add_stat("accepted_unasked_difficulty")
				if not bool(person.get("asked_location", false)): s.add_stat("accepted_unasked_location")
			# Main/o changes recovery into a return to the accepting agent's
			# station. Record that real address before consuming the offer.
			if int(job.kind) in [3, 5]:
				s.job["return_station"] = s.station_id
				# The source carrier uses the opposite ID from the offer/HUD:
				# hostage -> 116, recovery -> 117. Keep presentation unchanged.
				# Explicit metadata distinguishes new contracts from old saves.
				s.job["recovery_item"] = 116 if int(job.kind) == 5 else 117
			if int(job.kind) == 0:
				s.add_cargo(COURIER_FREIGHT, int(job.count))
			elif int(job.kind) == 11:
				s.flags["passengers"] = int(job.count)
			person.erase("job")
			person.kind = Kind.TALK
			# "See you outside, Mr. Maxwell."
			person.speech = lib.text(493)
			return ""
		Kind.SELLER, Kind.ITEM_AGENT:
			if s.credits < int(person.price): return lib.text(83).replace("#C", _money(int(person.price) - s.credits))
			var count := int(person.get("count", 1))
			if s.cargo_free() < count: return lib.text(159)
			s.credits -= int(person.price)
			s.add_cargo(int(person.item), count)
			if int(person.item) >= 132 and int(person.item) <= 153:
				preload("res://src/simulation/medals.gd").mark(s, "drink_types", int(person.item) - 132)
			if person.has("agent"): s.flags["agent_done_%d" % int(person.agent)] = true
			person.kind = Kind.TALK
			person.speech = lib.text(492)
			return ""
		Kind.BLUEPRINT_AGENT:
			if s.credits < int(person.price): return lib.text(83).replace("#C", _money(int(person.price) - s.credits))
			s.credits -= int(person.price)
			s.blueprints[str(person.blueprint)] = {"progress": {}}
			s.flags["agent_done_%d" % int(person.agent)] = true
			person.kind = Kind.TALK
			person.speech = lib.text(492)
			return ""
		Kind.WINGMEN:
			# With every medal, admirers pay to fly along instead.
			var fans := bool(s.flags.get("all_medals", false))
			if not fans and s.credits < int(person.price): return lib.text(83).replace("#C", _money(int(person.price) - s.credits))
			if not s.flags.get("wingmen", []).is_empty(): return lib.text(424)
			s.credits += int(person.price) if fans else -int(person.price)
			s.flags["wingmen"] = person.pilots.duplicate()
			s.flags["wingmen_race"] = int(person.race)
			s.flags["wingmen_remaining_ms"] = 600000
			s.flags["wingmen_face"] = person.get("face", []).duplicate()
			s.add_stat("commanded_wingmen", person.pilots.size())
			person.kind = Kind.TALK
			person.speech = lib.text(492)
			return ""
		Kind.FACTION:
			if s.credits < int(person.price): return lib.text(83).replace("#C", _money(int(person.price) - s.credits))
			s.credits -= int(person.price)
			var race := int(person.race)
			var axis := 1 if race == 2 or race == 3 else 0
			s.reputation[axis] = 0
			person.kind = Kind.TALK
			person.speech = lib.text(515).replace("#C", _money(int(person.price)))
			return ""
	return ""

func offer_label(person: Dictionary) -> String:
	match int(person.kind):
		Kind.JOB, Kind.BUYER: return lib.text(Catalogue.STRING_MISSION_TYPES + int(person.job.kind)) if person.has("job") else ""
		Kind.SELLER, Kind.ITEM_AGENT: return cat.item_name(int(person.item))
		Kind.BLUEPRINT_AGENT: return lib.text(129)
		Kind.WINGMEN: return lib.text(146)
		Kind.FACTION: return lib.text(298)
	return ""
