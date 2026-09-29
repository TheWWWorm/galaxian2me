extends RefCounted
## Meaning layered over the imported record tables. Field names follow what
## the original does with each value; the numbers themselves come only from
## the supplied JAR.

const STRING_ITEM_NAMES := 569
const STRING_SHIP_NAMES := 532
const STRING_ITEM_TYPES := 98
const STRING_MISSION_TYPES := 179
const STRING_RACES := 229
const STRING_SPEAKERS := 819
const STRING_SAFETY := 225

## Item categories (attribute 1).
enum Category { PRIMARY, SECONDARY, TURRET, EQUIPMENT, COMMODITY }

## Item types (attribute 2); the display name is string 98 + type.
enum Type { LASER, BLASTER, AUTOCANNON, THERMO, ROCKET, TORPEDO, EMP_BOMB, NUKE, TURRET, SHIELD,
	ARMOR, EMP_PROTECTION, COMPRESSION, TRACTOR_BEAM, BOOSTER, REPAIR_BOT, STEERING, SCANNER,
	JUMP_DRIVE, MINING_LASER, CABIN, CLOAK, COMMODITY, ORE, CORE }

## Attribute keys of items.bin.
const A_ID := 0
const A_CATEGORY := 1
const A_TYPE := 2
const A_TECH := 3
const A_ORIGIN := 4        # system where the item is made (cheapest)
const A_REFERENCE := 5     # system the price scale is measured towards
const A_OCCURRENCE := 6    # percent chance a qualifying station stocks it
const A_PRICE_MIN := 7
const A_PRICE_MAX := 8
const A_DAMAGE := 9
const A_EMP_DAMAGE := 10
const A_RELOAD := 11
const A_RANGE := 12
const A_SPEED := 13
const A_BLAST_RADIUS := 14
const A_TURRET_SPEED := 15
const A_SHIELD := 16
const A_SHIELD_RECHARGE := 17
const A_ARMOR := 18
const A_EMP_DEFENSE := 19
const A_COMPRESSION := 20
const A_TRACTOR_AUTO := 21
const A_TRACTOR_SPEED := 22
const A_BOOST_SPEED := 23
const A_BOOST_RELOAD := 24
const A_BOOST_LENGTH := 25
const A_HANDLING := 26
const A_SCAN_LOCK := 27
const A_SCAN_ASTEROIDS := 28
const A_SCAN_CARGO := 29
const A_MINING_YIELD := 30
const A_MINING_SPEED := 31
const A_CABIN := 32
const A_CLOAK_LENGTH := 33
const A_CLOAK_RELOAD := 34
const A_VOSSK_ONLY := 35
const A_HOME_STATION := 36

## Types the original counts in stacks (weapons, ammunition-like equipment,
## commodities); the rest occupy a slot one at a time.
const STACKABLE := [true, true, true, true, true, true, true, true, false, false, false, true, true,
	false, false, false, false, false, false, false, true, false, true, true, true]

var library
var data: Dictionary

func _init(lib) -> void:
	library = lib
	data = lib.data

# ------------------------------------------------------------------ items

func item_count() -> int:
	return data.items.size()

func item(id: int) -> Dictionary:
	return data.items[id] if id >= 0 and id < data.items.size() else {}

func attr(id: int, key: int, fallback := 0) -> int:
	var it := item(id)
	if it.is_empty(): return fallback
	return int(it.attributes.get(str(key), fallback))

func has_attr(id: int, key: int) -> bool:
	var it := item(id)
	return not it.is_empty() and it.attributes.has(str(key))

func item_name(id: int) -> String:
	return library.text(STRING_ITEM_NAMES + attr(id, A_ID, id))

func category(id: int) -> int: return attr(id, A_CATEGORY)
func type(id: int) -> int: return attr(id, A_TYPE)
func tech(id: int) -> int: return attr(id, A_TECH)
func price_min(id: int) -> int: return attr(id, A_PRICE_MIN)
func price_max(id: int) -> int: return attr(id, A_PRICE_MAX)
## The original's default price: halfway between the extremes.
func price_mid(id: int) -> int: return price_min(id) + (price_max(id) - price_min(id)) / 2
func is_blueprint_product(id: int) -> bool: return not item(id).get("ingredients", []).is_empty()
func stackable(id: int) -> bool:
	var t := type(id)
	return t >= 0 and t < STACKABLE.size() and STACKABLE[t]
func type_name(t: int) -> String: return library.text(STRING_ITEM_TYPES + t)

## Icon cell in items.png: one 16-pixel column per item id... the sheet is
## 5456 pixels wide, 31 pixels per item on the original sheet.
func item_icon_rect(id: int) -> Rect2i:
	return Rect2i(id * 31, 0, 31, 15)

# ------------------------------------------------------------------ ships

func ship_count() -> int:
	return data.ships.size()

func ship(index: int) -> Dictionary:
	return data.ships[index] if index >= 0 and index < data.ships.size() else {}

func ship_name(index: int) -> String:
	return library.text(STRING_SHIP_NAMES + index)

func ship_slots(index: int) -> Array:
	var s := ship(index)
	return [int(s.get("primary", 0)), int(s.get("secondary", 0)), int(s.get("turret", 0)), int(s.get("equipment", 0))]

# ------------------------------------------------------------------ world

func station(id: int) -> Dictionary:
	for s in data.stations:
		if int(s.id) == id: return s
	return {}

func station_name(id: int) -> String:
	return str(station(id).get("name", "?"))

func system(index: int) -> Dictionary:
	return data.systems[index] if index >= 0 and index < data.systems.size() else {}

func system_count() -> int:
	return data.systems.size()

func system_name(index: int) -> String:
	return str(system(index).get("name", "?"))

func system_of_station(station_id: int) -> int:
	return int(station(station_id).get("system", -1))

func faction_name(race: int) -> String:
	return library.text(STRING_RACES + race)

## Map distance between two systems in map units (x/y plane), as the
## economy measures it.
func system_distance(a: int, b: int) -> int:
	var sa := system(a); var sb := system(b)
	if sa.is_empty() or sb.is_empty(): return 0
	var dx := int(sb.x) - int(sa.x); var dy := int(sb.y) - int(sa.y)
	return int(sqrt(dx * dx + dy * dy))

## The original's "closeness": 100 minus the map distance.
func system_closeness(a: int, b: int) -> int:
	return 100 - system_distance(a, b)

## Distance for travel and freelance rewards: 3D, z scaled down tenfold, in
## the original's display kilometres (map units × 18.85).
func travel_distance(a: int, b: int) -> float:
	if a == b: return 0.0
	var sa := system(a); var sb := system(b)
	var d := Vector3(int(sa.x) - int(sb.x), int(sa.y) - int(sb.y), int(sa.z) / 10 - int(sb.z) / 10)
	return int(d.length()) * 18.85

func agent(index: int) -> Dictionary:
	return data.agents[index] if index >= 0 and index < data.agents.size() else {}

## What a named lounge agent sells: {"system": secret system or -1,
## "blueprint": blueprint item or -1}. Content caches converted before the
## field names were corrected store the same two values as "blueprint"
## (secret system) and "item" (blueprint item), in agents.bin order.
static func agent_offer(a: Dictionary) -> Dictionary:
	if a.has("secret_system"):
		return {"system": int(a.secret_system), "blueprint": int(a.get("blueprint_item", -1))}
	return {"system": int(a.get("blueprint", -1)), "blueprint": int(a.get("item", -1))}
