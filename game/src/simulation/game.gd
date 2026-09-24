extends RefCounted
## The running game: the session plus the rules that change it while docked
## (trading, fitting, travel bookkeeping). Flight has its own simulation and
## reports outcomes back here.

const Catalogue := preload("res://src/content/catalogue.gd")
const Session := preload("res://src/simulation/session.gd")
const Market := preload("res://src/simulation/market.gd")
const Campaign := preload("res://src/simulation/campaign.gd")
const Lounge := preload("res://src/simulation/lounge.gd")

## New-game constants of the original: first station, the hull Keith flies
## and what is mounted on it.
const START_STATION := 78
const START_SHIP := 10
const START_FACTION := 0
const START_PRIMARY := [3, 3]
const START_EQUIPMENT := [54, 59, 82]

signal changed

## Lines to show when the station screen opens (debriefings, arrivals).
var pending_dialogue: Array = []
## Where the next flight is headed: {"station": id} or {}.
var destination := {}

var library
var cat: Catalogue
var session: Session
var market: Market
var campaign: Campaign
var bar: Lounge

func _init(lib, catalogue: Catalogue) -> void:
	library = lib
	cat = catalogue
	session = Session.new(cat)
	session.content_id = lib.id
	market = Market.new(cat)
	campaign = Campaign.new(self)
	bar = Lounge.new(self)

func new_game() -> void:
	var s := session
	s.credits = 0
	s.story_step = 0
	s.ship = {"index": START_SHIP, "faction": START_FACTION, "hull": 0}
	s.equipment = [[], [], [], []]
	s.fit_slots()
	for i in START_PRIMARY.size():
		if i < s.equipment[0].size(): s.equipment[0][i] = {"id": START_PRIMARY[i], "count": 1}
	# The original mounts all three equipment pieces into the same first
	# equipment slot, one after the other; only the last one stays.
	for id in START_EQUIPMENT:
		if s.equipment[3].size() > 0: s.equipment[3][0] = {"id": id, "count": 1}
	s.cargo = {}
	s.ship.hull = int(s.ship_stats().max_hull)
	s.station_id = START_STATION
	s.system_index = cat.system_of_station(START_STATION)
	campaign.begin()
	arrive(START_STATION)

## Brings a loaded session into a consistent docked state.
func resume() -> void:
	arrive(session.station_id, false)

# ------------------------------------------------------------------ docking

func station() -> Dictionary:
	return cat.station(session.station_id)

func system() -> Dictionary:
	return cat.system(session.system_index)

## Docks at a station: marks it visited and restocks its shelf unless it is
## one of the last three stations visited, whose shelves persist.
func arrive(station_id: int, fresh := true) -> void:
	session.station_id = station_id
	session.system_index = cat.system_of_station(station_id)
	session.visited_stations[str(station_id)] = true
	session.visited_systems[str(session.system_index)] = true
	var m := session.market_for(station_id)
	if m.is_empty() or (fresh and m.get("stale", false)):
		m = {"station": station_id,
			"items": market.generate_stock(station_id, session.story_step),
			"ships": market.generate_ships(station_id, session.story_step, bool(session.flags.get("all_gold", false)))}
	# The lounge changes with every visit.
	if fresh or not m.has("lounge"):
		m.lounge = bar.generate(station_id)
	session.remember_market(m)
	changed.emit()

func shelf() -> Array:
	return session.market_for(session.station_id).get("items", [])

func dealer() -> Array:
	return session.market_for(session.station_id).get("ships", [])

func price_here(id: int) -> int:
	for e in shelf():
		if int(e.id) == id: return int(e.price)
	return market.price(id, session.station_id)

# ------------------------------------------------------------------ trade

## Buys `count` of an item from the shelf into the hold. Returns a message
## key: "" on success or a reason string.
func buy(id: int, count := 1) -> String:
	var entry := _shelf_entry(id)
	if entry.is_empty() or int(entry.count) <= 0: return library.text(257)
	count = mini(count, int(entry.count))
	var p := int(entry.price)
	if session.credits < p * count:
		return library.format(83, {"#C": _money(p * count - session.credits)})
	if session.cargo_free() < count: return library.text(159)
	session.credits -= p * count
	entry.count = int(entry.count) - count
	session.add_cargo(id, count)
	changed.emit()
	return ""

func sell(id: int, count := 1) -> String:
	count = mini(count, session.cargo_count(id))
	if count <= 0: return library.text(160)
	# Freight carried for a client is not the player's to sell.
	if id == Lounge.COURIER_FREIGHT and int(session.job.get("kind", -1)) == 0: return library.text(160)
	var p := price_here(id)
	session.credits += p * count
	session.add_cargo(id, -count)
	var entry := _shelf_entry(id)
	if entry.is_empty():
		shelf().append({"id": id, "count": count, "price": p})
		shelf().sort_custom(func(a, b): return int(a.id) < int(b.id))
	else:
		entry.count = int(entry.count) + count
	changed.emit()
	return ""

func _shelf_entry(id: int) -> Dictionary:
	for e in shelf():
		if int(e.id) == id: return e
	return {}

static func _money(v: int) -> String:
	return preload("res://src/presentation/ui.gd").money(v)

# ------------------------------------------------------------------ fitting

## Mounts one unit of an item from the hold into a slot of its category.
func mount(id: int, slot: int) -> String:
	var c := cat.category(id)
	if c == Catalogue.Category.COMMODITY: return library.text(257)
	var slots: Array = session.equipment[c]
	if slot < 0 or slot >= slots.size(): return library.text(257)
	if session.cargo_count(id) <= 0: return library.text(257)
	var t := cat.type(id)
	# Equipment other than stacked kinds may be fitted only once.
	if c == Catalogue.Category.EQUIPMENT and not cat.stackable(id):
		for i in slots.size():
			if i != slot and slots[i] != null and cat.type(int(slots[i].id)) == t:
				return library.text(164)
	var current = slots[slot]
	var amount := 1
	if cat.stackable(id) and c == Catalogue.Category.SECONDARY: amount = session.cargo_count(id)
	if current != null and int(current.id) == id and cat.stackable(id):
		current.count = int(current.count) + amount
	else:
		if current != null: session.add_cargo(int(current.id), int(current.count))
		slots[slot] = {"id": id, "count": amount}
	session.add_cargo(id, -amount)
	_clamp_hull()
	changed.emit()
	return ""

func demount(category: int, slot: int) -> String:
	var slots: Array = session.equipment[category]
	if slot < 0 or slot >= slots.size() or slots[slot] == null: return ""
	var e: Dictionary = slots[slot]
	if session.cargo_free() < int(e.count): return library.text(84)
	session.add_cargo(int(e.id), int(e.count))
	slots[slot] = null
	_clamp_hull()
	changed.emit()
	return ""

func sell_mounted(category: int, slot: int) -> String:
	var slots: Array = session.equipment[category]
	if slot < 0 or slot >= slots.size() or slots[slot] == null: return ""
	var e: Dictionary = slots[slot]
	session.credits += price_here(int(e.id)) * int(e.count)
	slots[slot] = null
	_clamp_hull()
	changed.emit()
	return ""

func _clamp_hull() -> void:
	session.ship.hull = mini(int(session.ship.hull), int(session.ship_stats().max_hull))

func repair_cost() -> int:
	return 0

# ------------------------------------------------------------------ ships

func buy_ship(offer: Dictionary) -> String:
	var value := ship_value()
	if session.credits + value < int(offer.price):
		return library.format(83, {"#C": _money(int(offer.price) - session.credits - value)})
	session.credits += value - int(offer.price)
	# Weapons and equipment move to the hold, as the original announces.
	for c in 4:
		for e in session.equipment[c]:
			if e != null: session.add_cargo(int(e.id), int(e.count))
	var old := {"index": session.ship.index, "faction": session.ship.faction}
	session.ship = {"index": int(offer.index), "faction": int(offer.faction), "hull": 0}
	session.equipment = [[], [], [], []]
	session.fit_slots()
	session.ship.hull = int(session.ship_stats().max_hull)
	var offers := dealer()
	offers.erase(offer)
	offers.append({"index": old.index, "faction": old.faction, "price": market.ship_price(int(old.index), session.station_id)})
	changed.emit()
	return ""

## What the dealer credits for the current hull.
func ship_value() -> int:
	return market.ship_trade_in(int(session.ship.index))

# ------------------------------------------------------------------ lounge & jobs

## People in this station's lounge; generated by the lounge rules.
func lounge() -> Array:
	return session.market_for(session.station_id).get("lounge", [])

func accept_job(index: int) -> String:
	var people := lounge()
	if index < 0 or index >= people.size(): return ""
	var error: String = bar.accept(people[index])
	changed.emit()
	return error

func cancel_job() -> void:
	# Abandoning a job returns nothing and takes back its freight.
	if int(session.job.get("kind", -1)) == 0:
		session.add_cargo(Lounge.COURIER_FREIGHT, -int(session.job.get("count", 0)))
	session.flags.erase("passengers")
	session.job = {}
	changed.emit()

## A freelance job whose destination is this station: freight and passengers
## are delivered, bought goods handed over, and the reward paid.
func settle_job(station_id: int) -> void:
	var job: Dictionary = session.job
	if job.is_empty() or int(job.station) != station_id: return
	var kind := int(job.kind)
	var paid := false
	match kind:
		0:
			session.add_cargo(Lounge.COURIER_FREIGHT, -int(job.count))
			session.add_stat("goods_conveyed", int(job.count))
			paid = true
		11:
			session.add_stat("passengers", int(job.count))
			session.flags.erase("passengers")
			paid = true
		8:
			if session.cargo_count(int(job.item)) >= int(job.count):
				session.add_cargo(int(job.item), -int(job.count))
				paid = true
		_:
			paid = bool(job.get("done", false))
	if not paid: return
	session.credits += int(job.reward)
	session.add_stat("jobs")
	pending_dialogue.append({"speaker": -1, "name": str(job.client), "face": job.get("face", []),
		"text": library.text(195 + randi() % 5) + "\n\n" + library.text(97)})
	session.job = {}

# ------------------------------------------------------------------ travel

## How the next flight scene begins: "" launching from the station, "jump"
## after a gate, "travel" after crossing the system.
var arrival_mode := ""

func depart(target: Dictionary) -> void:
	destination = target
	arrival_mode = ""
	changed.emit()

## Docked after flight: the station's shelves and story checks run here.
func dock(station_id: int) -> void:
	if int(destination.get("station", -1)) == station_id: destination = {}
	arrive(station_id)
	campaign.on_dock(station_id)
	settle_job(station_id)
	autosave()

## Arrived at another station's space by gate or in-system travel.
func jump_arrive(system_index: int, station_id: int) -> void:
	session.station_id = station_id
	session.system_index = system_index
	session.visited_systems[str(system_index)] = true
	arrival_mode = "jump"

## Standing: harming a faction's ships costs standing with it and gains
## standing with its rival on the same axis.
func reputation_hit(faction: int, killed: bool) -> void:
	var amount := 5 if killed else 1
	var rep: Array = session.reputation
	match faction:
		0: rep[0] = clampi(int(rep[0]) - amount, -100, 100)
		1: rep[0] = clampi(int(rep[0]) + amount, -100, 100)
		2: rep[1] = clampi(int(rep[1]) + amount, -100, 100)
		3: rep[1] = clampi(int(rep[1]) - amount, -100, 100)

## Destroyed in flight: the last autosave is restored when there is one.
func defeat() -> void:
	var path := autosave_path()
	if FileAccess.file_exists(path):
		var d = JSON.parse_string(FileAccess.get_file_as_string(path))
		if d is Dictionary and session.from_dict(d).is_empty():
			arrive(session.station_id, false)
			return
	new_game()

func autosave_path() -> String:
	return "user://saves/%s/autosave.json" % library.id

func autosave() -> void:
	DirAccess.make_dir_recursive_absolute("user://saves/" + library.id)
	var f := FileAccess.open(autosave_path(), FileAccess.WRITE)
	if f == null: return
	var d := session.to_dict()
	d.saved_at = Time.get_datetime_string_from_system()
	f.store_string(JSON.stringify(d))
