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
## Standing on two axes: Terran (+) / Vossk (−) and Midorian (+) / Nivelian (−).
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

# ------------------------------------------------------------------ markets

## Shelf of a station when it is still one of the last three visited.
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
		"playtime_ms": playtime_ms, "station": station_id, "system": system_index, "ship": ship,
		"equipment": equipment, "cargo": cargo, "visited_stations": visited_stations,
		"visited_systems": visited_systems, "unlocked_systems": unlocked_systems, "reputation": reputation,
		"stats": stats, "medals": medals, "story_mission": story_mission, "job": job, "markets": markets,
		"blueprints": blueprints, "flags": flags}

## Loads a saved dictionary; returns an error message or "".
func from_dict(d: Dictionary) -> String:
	if int(d.get("format", 0)) != SAVE_FORMAT: return "This save was written by an incompatible version."
	if str(d.get("content", "")) != content_id: return "This save belongs to a different game file."
	credits = int(d.credits)
	story_step = int(d.story_step)
	playtime_ms = int(d.playtime_ms)
	station_id = int(d.station)
	system_index = int(d.system)
	ship = d.ship
	equipment = d.equipment
	cargo = d.cargo
	visited_stations = d.visited_stations
	visited_systems = d.visited_systems
	unlocked_systems = d.get("unlocked_systems", {})
	reputation = d.reputation
	stats = d.stats
	medals = d.medals
	story_mission = d.story_mission
	job = d.job
	markets = d.markets
	blueprints = d.get("blueprints", {})
	flags = d.get("flags", {})
	if cat.station(station_id).is_empty() or cat.ship(int(ship.index)).is_empty():
		return "The save refers to content this game file does not have."
	fit_slots()
	return ""
