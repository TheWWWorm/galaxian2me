extends RefCounted
## Everything a saved game holds. Plain data only, so it serialises to JSON
## and can be validated on load. Game rules that change this state live in
## the owning systems (market, campaign, flight); this class keeps the
## player's ship consistent and derives its figures.

const Catalogue := preload("res://src/content/catalogue.gd")
const SAVE_FORMAT := 1

var content_id := ""
var credits := 0
var story_step := 0
var playtime_ms := 0
var station_id := 0
var system_index := 0
## Void space has no catalogue station. Retain the real station/system as
## the return address; never insert the sentinel -1 into markets or visits.
var in_void := false
## Hull index, the livery it was bought in, and its armour right now.
var ship := {"index": 0, "faction": 0, "hull": 0}
## One array per category (primary, secondary, turret, equipment); each slot
## is null or {"id": int, "count": int}.
var equipment: Array = [[], [], [], []]
## Cargo hold: {item id (string): count}
var cargo := {}
var visited_stations := {}
var visited_systems := {}
## Systems whose gates the story has opened for travel.
var unlocked_systems := {}
## Standing on the original's two axes, each −100..100: a positive first
## axis favours the Terrans over the Vossk, a positive second axis the
## Nivelians over the Midorians (above 60 the other race turns hostile).
var reputation := [30, 0]
var stats := {}
var medals := {}
var story_mission := {}
var job := {}
## Shelves of the most recently visited stations, newest first.
var markets: Array = []
var blueprints := {}
var flags := {}

var cat

func _init(catalogue = null) -> void:
	cat = catalogue

## Actual entrusted cargo, separate from the offer's presentation identity.
## Pre-metadata saves already used the offered ID; preserve that contract
## without rewriting its cargo, changing its pending return, or adding goods.
func recovery_cargo_item() -> int:
	if not int(job.get("kind", -1)) in [3, 5]: return -1
	return int(job.get("recovery_item", job.get("item", -1)))

# ------------------------------------------------------------------ ship

func ship_record() -> Dictionary:
	return cat.ship(int(ship.index))

func slot_counts() -> Array:
	return cat.ship_slots(int(ship.index))

## Rebuilds the slot arrays for the current hull, keeping what still fits.
func fit_slots() -> void:
	var counts := slot_counts()
	for c in 4:
		var old: Array = equipment[c] if c < equipment.size() else []
		var slots: Array = []
		for i in counts[c]:
			slots.append(old[i] if i < old.size() else null)
		equipment[c] = slots

func equipped_items() -> Array:
	var out: Array = []
	for c in 4:
		for e in equipment[c]:
			if e != null: out.append(e)
	return out

func has_equipped_type(t: int) -> bool:
	for e in equipped_items():
		if cat.type(int(e.id)) == t: return true
	return false

func equipped_of_type(t: int) -> Dictionary:
	for e in equipped_items():
		if cat.type(int(e.id)) == t: return e
	return {}

## The figures the original derives from hull and equipment.
func ship_stats() -> Dictionary:
	var rec := ship_record()
	var s := {"armor": int(rec.get("armor", 0)), "cargo": int(rec.get("cargo", 0)),
		"handling": float(rec.get("handling", 100)) / 100.0, "damage": 0, "shield": 0,
		"shield_recharge": 0, "armor_plate": 0, "compression": 0, "boost_speed": 0,
		"boost_length": 0, "boost_reload": 0, "steering": 0, "repair": false, "jump_drive": false,
		"cloak": false, "cabins": 0}
	for e in equipped_items():
		var id := int(e.id)
		match cat.type(id):
			Catalogue.Type.LASER, Catalogue.Type.BLASTER, Catalogue.Type.AUTOCANNON, Catalogue.Type.THERMO, Catalogue.Type.TURRET:
				s.damage += cat.attr(id, Catalogue.A_DAMAGE)
			Catalogue.Type.SHIELD:
				s.shield = cat.attr(id, Catalogue.A_SHIELD)
				s.shield_recharge = cat.attr(id, Catalogue.A_SHIELD_RECHARGE)
			Catalogue.Type.COMPRESSION:
				s.compression += cat.attr(id, Catalogue.A_COMPRESSION)
			Catalogue.Type.BOOSTER:
				s.boost_speed = cat.attr(id, Catalogue.A_BOOST_SPEED)
				s.boost_length = cat.attr(id, Catalogue.A_BOOST_LENGTH)
				s.boost_reload = cat.attr(id, Catalogue.A_BOOST_RELOAD)
			Catalogue.Type.STEERING:
				s.steering = cat.attr(id, Catalogue.A_HANDLING)
			Catalogue.Type.ARMOR:
				s.armor_plate = cat.attr(id, Catalogue.A_ARMOR)
			Catalogue.Type.REPAIR_BOT: s.repair = true
			Catalogue.Type.JUMP_DRIVE: s.jump_drive = true
			Catalogue.Type.CLOAK: s.cloak = true
			Catalogue.Type.CABIN: s.cabins += cat.attr(id, Catalogue.A_CABIN)
	# Compression enlarges the hold by a percentage of the hull's capacity.
	s.cargo_capacity = s.cargo + int(float(s.cargo) * s.compression / 100.0)
	s.max_hull = s.armor + s.armor_plate
	return s

func cargo_used() -> int:
	var n := 0
	for k in cargo: n += int(cargo[k])
	return n

func cargo_free() -> int:
	return int(ship_stats().cargo_capacity) - cargo_used()

func cargo_count(id: int) -> int:
	return int(cargo.get(str(id), 0))

func add_cargo(id: int, count: int) -> void:
	var n := cargo_count(id) + count
	if n <= 0: cargo.erase(str(id))
	else: cargo[str(id)] = n

# ------------------------------------------------------------------ stats

func stat(key: String) -> int:
	return int(stats.get(key, 0))

func add_stat(key: String, amount := 1) -> void:
	stats[key] = stat(key) + amount

## The pilot's level (the original's Status.level, kept as the "rank"
## stat): 1 for a new pilot. It raises enemy strength, rewards and hired
## pilots' fees.
func level() -> int:
	return int(stats.get("rank", 1))

## Status.checkForLevelUp: experience from kills, half the wingmen ever
## commanded, a fiftieth of the ore mined, cores mined and twice the
## freelance missions done. Each time it passes 1.3 times the mark the last
## level was reached at (15 for a new pilot), the level rises by one.
func check_level_up() -> void:
	if not stats.has("rank"): stats["rank"] = 1
	var xp := stat("kills") + stat("commanded_wingmen") / 2 + stat("ore_mined") / 50 + stat("cores_mined") + 2 * stat("jobs")
	var mark := int(stats.get("last_xp", 15))
	if mark * 1.3 < xp:
		stats["last_xp"] = xp
		stats["rank"] = stat("rank") + 1

# ------------------------------------------------------------------ markets

## Shelf of a station when it is still one of the last three visited.
## The original's price record: the lowest and highest price seen for each
## item and in which system, kept each time a hangar opens.
func record_price(id: int, price: int, system: int) -> void:
	if price <= 0: return
	var all: Dictionary = flags.get("prices", {})
	var rec: Array = all.get(str(id), [0, 0, 0, 0])
	if int(rec[0]) == 0 or price < int(rec[0]): rec[0] = price; rec[1] = system
	if int(rec[2]) == 0 or price > int(rec[2]): rec[2] = price; rec[3] = system
	all[str(id)] = rec
	flags["prices"] = all

## [lowest, its system, highest, its system], or [] when never seen.
func price_record(id: int) -> Array:
	return (flags.get("prices", {}) as Dictionary).get(str(id), [])

func market_for(id: int) -> Dictionary:
	for m in markets:
		if int(m.station) == id: return m
	return {}

func remember_market(m: Dictionary) -> void:
	for i in range(markets.size() - 1, -1, -1):
		if int(markets[i].station) == int(m.station): markets.remove_at(i)
	markets.push_front(m)
	while markets.size() > 3: markets.pop_back()

# ------------------------------------------------------------------ save

func to_dict() -> Dictionary:
	return {"format": SAVE_FORMAT, "content": content_id, "credits": credits, "story_step": story_step,
		"playtime_ms": playtime_ms, "station": station_id, "system": system_index, "in_void": in_void, "ship": ship,
		"equipment": equipment, "cargo": cargo, "visited_stations": visited_stations,
		"visited_systems": visited_systems, "unlocked_systems": unlocked_systems, "reputation": reputation,
		"reputation_axes": 2, "stats": stats, "medals": medals, "story_mission": story_mission, "job": job, "markets": markets,
		"blueprints": blueprints, "flags": flags}

func location_id() -> int:
	return -1 if in_void else station_id

## Loads a saved dictionary; returns an error message or "".
func from_dict(d: Dictionary) -> String:
	d = _repair_agent_deals(d)
	var error := _validate_save(d)
	if not error.is_empty(): return error
	# Validate the entire snapshot before changing any field. Own the loaded
	# containers as well, so a caller cannot mutate a session through its input.
	d = d.duplicate(true)
	credits = int(d.credits)
	story_step = int(d.story_step)
	playtime_ms = int(d.playtime_ms)
	station_id = int(d.station)
	system_index = int(d.system)
	in_void = bool(d.get("in_void", false))
	ship = d.ship
	equipment = d.equipment
	cargo = d.cargo
	visited_stations = d.visited_stations
	visited_systems = d.visited_systems
	unlocked_systems = d.get("unlocked_systems", {})
	reputation = d.reputation.duplicate()
	# Saves written before the second axis took the original's sign had it
	# the other way round (Midorians favoured by +).
	if int(d.get("reputation_axes", 1)) < 2: reputation[1] = -int(reputation[1])
	stats = d.stats
	medals = d.medals
	story_mission = d.story_mission
	job = d.job
	markets = d.markets
	blueprints = d.get("blueprints", {})
	flags = d.get("flags", {})
	fit_slots()
	return ""

## Earlier builds read agents.bin's secret-system and blueprint fields the
## wrong way round: a bought blueprint arrived as a cargo item and bought
## coordinates as a blueprint keyed by the system's number. For each named
## agent the save marks as dealt with, grant what was paid for and drop the
## misplaced blueprint entry. The cargo item already received is kept.
func _repair_agent_deals(d: Dictionary) -> Dictionary:
	if cat == null or not d.get("flags") is Dictionary: return d
	var agents = cat.data.get("agents", []) if cat.data is Dictionary else []
	if not agents is Array or agents.is_empty(): return d
	var sold := {}
	for a in agents:
		var offer: Dictionary = Catalogue.agent_offer(a)
		if int(offer.blueprint) >= 0: sold[str(int(offer.blueprint))] = true
	var out := d
	for a in agents:
		if not d.flags.has("agent_done_%d" % int(a.get("id", -1))): continue
		var offer: Dictionary = Catalogue.agent_offer(a)
		if out == d: out = d.duplicate(true)
		if not out.get("blueprints") is Dictionary: out["blueprints"] = {}
		if not out.get("unlocked_systems") is Dictionary: out["unlocked_systems"] = {}
		var system := int(offer.system)
		if system >= 0 and not cat.system(system).is_empty():
			out.unlocked_systems[str(system)] = true
			var wrong = out.blueprints.get(str(system))
			var progress = wrong.get("progress", {}) if wrong is Dictionary else null
			if progress is Dictionary and progress.is_empty() and not sold.has(str(system)):
				out.blueprints.erase(str(system))
		var blueprint := int(offer.blueprint)
		if blueprint >= 0 and not cat.item(blueprint).is_empty() and not out.blueprints.has(str(blueprint)):
			out.blueprints[str(blueprint)] = {"progress": {}}
	return out

## JSON represents numbers as floats. Accept integral finite values, but
## never silently truncate fractions, parse strings or coerce booleans.
static func _whole(value, minimum := 0, maximum := 9007199254740991) -> bool:
	if not (value is int or value is float): return false
	return is_finite(float(value)) and value >= minimum and value <= maximum and float(value) == floor(float(value))

static func _numeric_key(key) -> bool:
	return key is String and key.is_valid_int() and str(int(key)) == key and int(key) >= 0

func _item_stack(entry, category := -1) -> bool:
	if not entry is Dictionary: return false
	if not _whole(entry.get("id")) or not _whole(entry.get("count"), 0): return false
	var id := int(entry.id)
	return not cat.item(id).is_empty() and (category < 0 or cat.category(id) == category)

const BlueprintRules := preload("res://src/simulation/blueprints.gd")

func _validate_save(d: Dictionary) -> String:
	if not _whole(d.get("format")) or int(d.format) != SAVE_FORMAT:
		return "This save was written by an incompatible version."
	if not d.get("content") is String or d.content != content_id:
		return "This save belongs to a different game file."
	var invalid := "The save is incomplete or contains invalid state."
	if d.has("in_void") and not d.in_void is bool: return invalid
	for key in ["credits", "story_step", "playtime_ms", "station", "system"]:
		if not _whole(d.get(key)): return invalid
	for key in ["ship", "cargo", "visited_stations", "visited_systems", "stats", "medals", "story_mission", "job"]:
		if not d.get(key) is Dictionary: return invalid
	for key in ["unlocked_systems", "blueprints", "flags"]:
		if d.has(key) and not d[key] is Dictionary: return invalid
	var saved_flags: Dictionary = d.get("flags", {})
	if saved_flags.has("wingmen"):
		if not saved_flags.wingmen is Array or saved_flags.wingmen.size() > 3: return invalid
		for pilot in saved_flags.wingmen:
			if not pilot is String or pilot.is_empty(): return invalid
	if saved_flags.has("wingmen_race") and not _whole(saved_flags.wingmen_race, 0, 9): return invalid
	if saved_flags.has("wingmen_remaining_ms") and not _whole(saved_flags.wingmen_remaining_ms, 0, 600000): return invalid
	if saved_flags.has("wingmen_face"):
		if not saved_flags.wingmen_face is Array: return invalid
		for part in saved_flags.wingmen_face:
			if not _whole(part, 0, 255): return invalid
	if saved_flags.has("final_escort_hull") and not _whole(saved_flags.final_escort_hull, 1): return invalid
	if int(d.story_step) == 41 and bool(d.get("in_void", false)) and not saved_flags.has("final_escort_hull"): return invalid
	for key in ["wormhole_station", "wormhole_system"]:
		if saved_flags.has(key) and not _whole(saved_flags[key], -1): return invalid
	if saved_flags.has("recent_systems"):
		if not saved_flags.recent_systems is Array or saved_flags.recent_systems.size() > 6: return invalid
		for sys in saved_flags.recent_systems:
			if not _whole(sys, 0, (cat.system_count() - 1) if cat != null else 1000): return invalid
	if saved_flags.has("prices"):
		if not saved_flags.prices is Dictionary: return invalid
		for key in saved_flags.prices:
			var rec = saved_flags.prices[key]
			if not _numeric_key(key) or not rec is Array or rec.size() != 4: return invalid
			for v in rec:
				if not _whole(v): return invalid
	if saved_flags.has("unsaleable_cargo"):
		if not saved_flags.unsaleable_cargo is Dictionary: return invalid
		for key in saved_flags.unsaleable_cargo:
			if not _numeric_key(key) or cat == null or cat.item(int(key)).is_empty() or not saved_flags.unsaleable_cargo[key] is bool: return invalid
	for key in ["equipment", "reputation", "markets"]:
		if not d.get(key) is Array: return invalid
	for key in ["index", "faction", "hull"]:
		if not _whole(d.ship.get(key)): return invalid
	if d.ship.has("armor") and not _whole(d.ship.armor): return invalid
	if d.ship.has("shield"):
		var shield_value = d.ship.shield
		if not (shield_value is int or shield_value is float): return invalid
		if not is_finite(float(shield_value)) or shield_value < 0: return invalid
	if cat == null or cat.station(int(d.station)).is_empty() or cat.ship(int(d.ship.index)).is_empty() or cat.system(int(d.system)).is_empty():
		return "The save refers to content this game file does not have."
	if cat.system_of_station(int(d.station)) != int(d.system): return invalid
	if not BlueprintRules.valid_saved(d.get("blueprints", {}), cat): return invalid
	if d.equipment.size() != 4 or d.reputation.size() != 2 or d.markets.size() > 3: return invalid
	var slots: Array = cat.ship_slots(int(d.ship.index))
	for category in 4:
		if not d.equipment[category] is Array: return invalid
		if d.equipment[category].size() > slots[category]: return invalid
		for entry in d.equipment[category]:
			if entry == null: continue
			if not _item_stack(entry, category) or int(entry.count) <= 0: return invalid
	for value in d.reputation:
		if not _whole(value, -100, 100): return invalid
	for key in d.cargo:
		if not _numeric_key(key) or cat.item(int(key)).is_empty() or not _whole(d.cargo[key], 1): return invalid
	for key in d.stats:
		if not key is String or not _whole(d.stats[key]): return invalid
	for field in ["visited_stations", "visited_systems", "unlocked_systems"]:
		for key in d.get(field, {}):
			if not _numeric_key(key) or not d[field][key] is bool: return invalid
			if field == "visited_stations" and cat.station(int(key)).is_empty(): return invalid
			if field != "visited_stations" and cat.system(int(key)).is_empty(): return invalid
	for m in [d.story_mission, d.job]:
		if m.is_empty(): continue
		if not _whole(m.get("kind")) or not _whole(m.get("station"), -1) or not _whole(m.get("reward")): return invalid
		if int(m.station) >= 0 and cat.station(int(m.station)).is_empty(): return invalid
		for key in ["count", "amount", "progress", "step", "target", "jobs_at_start"]:
			if m.has(key) and not _whole(m[key]): return invalid
		if m.has("item") and not _whole(m.item, -1): return invalid
		if m.has("return_station"):
			if not _whole(m.return_station) or cat.station(int(m.return_station)).is_empty() or not int(m.kind) in [3, 5]: return invalid
		if m.has("recovery_item"):
			if not int(m.kind) in [3, 5] or not _whole(m.recovery_item) or not m.has("return_station"): return invalid
			if int(m.recovery_item) != (116 if int(m.kind) == 5 else 117): return invalid
			if int(m.get("item", -1)) != (116 if int(m.kind) == 3 else 117): return invalid
		if m.has("recovered"):
			if not m.recovered is bool or not int(m.kind) in [3, 5]: return invalid
			if m.recovered:
				if not m.has("return_station") or int(m.station) != int(m.return_station): return invalid
				var offered_item := 116 if int(m.kind) == 3 else 117
				var mission_item := int(m.get("recovery_item", offered_item))
				if int(m.get("item", -1)) != offered_item or int(d.cargo.get(str(mission_item), 0)) < 1: return invalid
		for key in ["client", "wanted"]:
			if m.has(key) and not m[key] is String: return invalid
	var stations := {}
	for market in d.markets:
		if not market is Dictionary or not _whole(market.get("station")): return invalid
		if cat.station(int(market.station)).is_empty() or stations.has(int(market.station)): return invalid
		stations[int(market.station)] = true
		if not market.get("items") is Array or not market.get("ships") is Array: return invalid
		for item in market.items:
			if not _item_stack(item) or not _whole(item.get("price")): return invalid
		for offer in market.ships:
			if not offer is Dictionary: return invalid
			for key in ["index", "faction", "price"]:
				if not _whole(offer.get(key)): return invalid
			if cat.ship(int(offer.index)).is_empty(): return invalid
		if market.has("lounge"):
			if not market.lounge is Array: return invalid
			for person in market.lounge:
				if not person is Dictionary: return invalid
				if not _whole(person.get("kind")) or not person.get("name") is String: return invalid
	return ""
