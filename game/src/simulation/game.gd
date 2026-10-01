extends RefCounted
## The running game: the session plus the rules that change it while docked
## (trading, fitting, travel bookkeeping). Flight has its own simulation and
## reports outcomes back here.

const Catalogue := preload("res://src/content/catalogue.gd")
const Session := preload("res://src/simulation/session.gd")
const Market := preload("res://src/simulation/market.gd")
const Campaign := preload("res://src/simulation/campaign.gd")
const Lounge := preload("res://src/simulation/lounge.gd")
const Blueprints := preload("res://src/simulation/blueprints.gd")
const Medals := preload("res://src/simulation/medals.gd")

## New-game constants of the original: first station, the hull Keith flies
## and what is mounted on it.
const START_STATION := 78
const START_SHIP := 10
const START_FACTION := 0
const START_PRIMARY := [3, 3]
const START_EQUIPMENT := [54, 59, 82]

signal changed
## Emitted only after arrival, story rewards and freelance settlement finish.
## Persistence belongs to the app, so simulations and tests never write saves.
signal docked(station_id: int)

## Lines to show when the station screen opens (debriefings, arrivals).
var pending_dialogue: Array = []
## Medals awarded at the last docking, waiting to be announced: [index, tier].
var new_medals: Array = []
## Where the next flight is headed: {"station": id} or {}.
var destination := {}
## The secondary weapon (item id) chosen in flight, -1 for none. Like the
## original's, it lasts for the session and is not saved.
var secondary_choice := -1

var library
var cat: Catalogue
var session: Session
var market: Market
var campaign: Campaign
var bar: Lounge
var workshop: Blueprints

func _init(lib, catalogue: Catalogue) -> void:
	library = lib
	cat = catalogue
	session = Session.new(cat)
	session.content_id = lib.id
	market = Market.new(cat)
	campaign = Campaign.new(self)
	bar = Lounge.new(self)
	workshop = Blueprints.new(session, cat)

func new_game() -> void:
	var s := session
	s.credits = 0
	s.story_step = 0
	# The first medal is the pilot's service record, held from the start.
	s.medals = {"0": 1}
	s.stats["rank"] = 1
	s.stats["last_xp"] = 15
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
	if session.in_void:
		# Loading an in-flight checkpoint is not another physical crossing.
		arrival_mode = "void_resume"
		return
	arrive(session.station_id, false)

# ------------------------------------------------------------------ docking

func station() -> Dictionary:
	return cat.station(session.station_id)

func system() -> Dictionary:
	return cat.system(session.system_index)

## Docks at a station: marks it visited and restocks its shelf unless it is
## one of the last three stations visited, whose shelves persist.
func arrive(station_id: int, fresh := true) -> void:
	if station_id < 0 or cat.station(station_id).is_empty(): return
	session.in_void = false
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
	if id >= Medals.DRINK_FIRST and id <= Medals.DRINK_LAST: session.add_stat("booze_bought", count)
	changed.emit()
	return ""

func can_sell_cargo(id: int) -> bool:
	# Original mission freight and cargo explicitly marked unsaleable by the
	# campaign are not trade goods. Keep the UI and transaction guard shared.
	if id == Lounge.COURIER_FREIGHT and int(session.job.get("kind", -1)) == 0: return false
	if bool(session.job.get("recovered", false)) and id == session.recovery_cargo_item(): return false
	var protected = session.flags.get("unsaleable_cargo", {})
	return not (protected is Dictionary and bool(protected.get(str(id), false)))

func sell(id: int, count := 1) -> String:
	count = mini(count, session.cargo_count(id))
	if count <= 0: return library.text(160)
	if not can_sell_cargo(id): return library.text(160)
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

# ------------------------------------------------------------------ production

func blueprint_offer(product: int, ingredient: int, count: int) -> Dictionary:
	if cat.item(ingredient).is_empty(): return {"error": library.text(257)}
	return workshop.offer(product, ingredient, count, price_here(ingredient), not can_sell_cargo(ingredient))

func contribute_blueprint(order: Dictionary) -> String:
	for key in ["product", "ingredient", "count"]:
		if not session._whole(order.get(key), 1 if key == "count" else 0): return library.text(257)
	var current := blueprint_offer(int(order.product), int(order.ingredient), int(order.count))
	if not str(current.error).is_empty(): return str(current.error)
	if current != order: return tr("The production order changed. Review it before confirming.")
	workshop.contribute(current)
	changed.emit()
	return ""

func _collect_products(station_id: int) -> void:
	var received := workshop.collect_at(station_id)
	if received.is_empty(): return
	var text: String = library.text(92)
	for item in received: text += "\n%dx %s" % [int(item.count), cat.item_name(int(item.product))]
	pending_dialogue.append({"speaker": -1, "text": text})

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
	if _occupied_cabin(current): return library.text(160)
	var previous_stats := session.ship_stats()
	var amount := 1
	if cat.stackable(id) and c == Catalogue.Category.SECONDARY: amount = session.cargo_count(id)
	# Only secondary ammunition shares one slot as a quantity. The original
	# permits multiple compressors/cabins, but each occupies its own slot;
	# replacing one returns the old unit to cargo rather than hiding a stack.
	if current != null and int(current.id) == id and c == Catalogue.Category.SECONDARY and cat.stackable(id):
		current.count = int(current.count) + amount
	else:
		if current != null: session.add_cargo(int(current.id), int(current.count))
		slots[slot] = {"id": id, "count": amount}
	session.add_cargo(id, -amount)
	_refit_defenses(previous_stats)
	changed.emit()
	return ""

func demount(category: int, slot: int) -> String:
	var slots: Array = session.equipment[category]
	if slot < 0 or slot >= slots.size() or slots[slot] == null: return ""
	var e: Dictionary = slots[slot]
	if _occupied_cabin(e): return library.text(160)
	if session.cargo_free() < int(e.count): return library.text(84)
	var previous_stats := session.ship_stats()
	session.add_cargo(int(e.id), int(e.count))
	slots[slot] = null
	_refit_defenses(previous_stats)
	changed.emit()
	return ""

func sell_mounted(category: int, slot: int) -> String:
	var slots: Array = session.equipment[category]
	if slot < 0 or slot >= slots.size() or slots[slot] == null: return ""
	var e: Dictionary = slots[slot]
	if _occupied_cabin(e): return library.text(160)
	var previous_stats := session.ship_stats()
	session.credits += price_here(int(e.id)) * int(e.count)
	slots[slot] = null
	_refit_defenses(previous_stats)
	changed.emit()
	return ""

## The supplied HangarList protects every fitted cabin while passengers are
## aboard, even with spare capacity. Check before any fitting/credit mutation;
## replacing a slot must not provide an alternative route around that rule.
func _occupied_cabin(entry) -> bool:
	return entry != null and cat.type(int(entry.id)) == Catalogue.Type.CABIN \
		and int(session.flags.get("passengers", 0)) > 0

func _clamp_hull() -> void:
	session.ship.hull = mini(int(session.ship.hull), int(session.ship_stats().max_hull))

## The saved hull figure includes remaining armor, not its maximum capacity.
## Changing armor must preserve base-hull damage and initialize the new plate;
## fitting an unrelated weapon must not refill either damaged layer.
func _refit_defenses(previous: Dictionary) -> void:
	var next := session.ship_stats()
	if int(previous.armor_plate) != int(next.armor_plate):
		var remaining := clampi(int(session.ship.get("armor", previous.armor_plate)), 0, int(previous.armor_plate))
		var base_hull := clampi(int(session.ship.hull) - remaining, 1, int(next.armor))
		session.ship.armor = int(next.armor_plate)
		session.ship.hull = base_hull + int(next.armor_plate)
	_clamp_hull()

func repair_cost() -> int:
	return 0

## The supplied game's station departure creates fresh hull, armor and
## shields from the equipped catalogue values. Settle that free servicing
## at docking, before autosave; loading a save alone is not a repair action.
func _service_docked_ship() -> void:
	var stats := session.ship_stats()
	session.ship.hull = int(stats.max_hull)
	session.ship.armor = int(stats.armor_plate)
	session.ship.shield = int(stats.shield)

# ------------------------------------------------------------------ ships

func buy_ship(offer: Dictionary) -> String:
	# A stale dealer control must not buy an absent hull or reuse an old price.
	# The transaction always resolves an offer from this station's real shelf.
	var live: Dictionary = {}
	for candidate in dealer():
		if candidate == offer:
			live = candidate
			break
	if live.is_empty() or cat.ship(int(live.get("index", -1))).is_empty(): return library.text(257)
	if int(session.flags.get("passengers", 0)) > 0: return library.text(161)
	offer = live
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
	return market.ship_trade_in(int(session.ship.index), bool(session.flags.get("all_medals", false)))

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
	if bool(session.job.get("recovered", false)):
		# Only the one entrusted container belongs to this recovery.
		session.add_cargo(session.recovery_cargo_item(), -1)
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
		3, 5:
			var payload := session.recovery_cargo_item()
			if bool(job.get("recovered", false)) and int(job.get("return_station", -1)) == station_id and session.cargo_count(payload) >= 1:
				session.add_cargo(payload, -1)
				paid = true
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

## Main/p.java requires fitting the supplied EMP bombs before leaving the
## equipment station, including after the objective advances to the flight.
func departure_error() -> String:
	# Swapping hulls or removing compression may temporarily overfill a docked
	# hold. Keep every item, but require fitting/trading before any departure.
	if session.cargo_free() < 0: return library.text(84)
	if int(session.job.get("kind", -1)) in [3, 5] and cat.station(int(session.job.get("return_station", -1))).is_empty():
		return tr("This older recovery contract has no recorded return station. Abandon it and accept a new offer.")
	# ModStation.leaveStation: at step 6 (fit the gear) and at step 7 while
	# the ship still has no gun and no extra armour, a hint replaces leaving;
	# which one depends on whether a primary weapon waits in the hold.
	if session.story_step == 6 or (session.story_step == 7 and _unarmed()):
		for id in session.cargo:
			if cat.category(int(id)) == 0: return library.text(259)
		return library.text(258)
	if session.station_id != int(session.story_mission.get("station", -1)): return ""
	if session.story_step == 20: return library.text(260)
	if session.story_step == 21:
		for item in session.equipped_items():
			if int(item.id) == 41 and int(item.get("count", 0)) > 0: return ""
		return library.text(260)
	return ""

## Ship.getFirePower() == 0 and getCombinedHP() == getBaseHP(): no gun, no
## shield and no armour plate fitted.
func _unarmed() -> bool:
	var stats := session.ship_stats()
	for e in session.equipment[0]:
		if e != null: return false
	return int(stats.shield) == 0 and int(stats.armor_plate) == 0

func depart(target: Dictionary) -> void:
	destination = target
	arrival_mode = ""
	changed.emit()

## Docked after flight: the station's shelves and story checks run here.
func dock(station_id: int) -> void:
	if session.in_void or station_id < 0 or cat.station(station_id).is_empty(): return
	if int(destination.get("station", -1)) == station_id: destination = {}
	# Main/o checks the record on the approach, before the dock's repair.
	var hull_max: int = maxi(1, int(session.ship_stats().armor))
	var hull_now: int = int(session.ship.hull) - int(session.ship.get("armor", 0))
	var found := Medals.check(session, cat, library, clampi(hull_now * 100 / hull_max, 0, 100))
	arrive(station_id)
	settle_job(station_id)
	_collect_products(station_id)
	# A delivery may satisfy the current story's jobs-so-far requirement.
	# Both reward and campaign advancement belong to the same docking save.
	campaign.on_dock(station_id)
	# The original checks for a new level while the station is open.
	session.check_level_up()
	new_medals = Medals.award(session, library, found)
	_service_docked_ship()
	docked.emit(station_id)

## Arrived at another station's space by gate or in-system travel.
func jump_arrive(system_index: int, station_id: int) -> void:
	if session.in_void or station_id < 0: return
	session.station_id = station_id
	session.system_index = system_index
	session.visited_systems[str(system_index)] = true
	_remember_trip(system_index)
	arrival_mode = "jump"

## The chart's trail of recent trips: the last six systems reached.
const RECENT_TRIPS := 6
func _remember_trip(system_index: int) -> void:
	var trail: Array = session.flags.get("recent_systems", [])
	if not trail.is_empty() and int(trail.back()) == system_index: return
	trail.append(system_index)
	while trail.size() > RECENT_TRIPS: trail.pop_front()
	session.flags["recent_systems"] = trail

## Main/o: a drive stream-out is not a gate use or station visit. In Void
## space the saved normal address remains the only permitted return orbit.
func drive_arrive(destination: Dictionary) -> bool:
	var navigation = preload("res://src/simulation/navigation.gd")
	var address: Dictionary = navigation.drive_destination(session, cat, int(destination.get("station", -2)))
	if address.is_empty() or address != destination: return false
	if bool(address.void):
		session.in_void = true
	else:
		session.in_void = false
		session.station_id = int(address.station)
		session.system_index = int(address.system)
		session.visited_systems[str(session.system_index)] = true
		_remember_trip(session.system_index)
	self.destination = {}
	arrival_mode = "drive"
	return true

## Called only by a physical portal crossing. The retained address is not a
## docking event: no shelf roll, repair, freelance reward or gate statistic.
func cross_wormhole() -> void:
	session.in_void = not session.in_void
	destination = {}
	arrival_mode = "wormhole"

## Standing: wronging a race (disabling or robbing one of its ships costs
## 2, a kill 5) costs standing with it and gains standing with its rival on
## the same axis.
func standing_delict(race: int, amount: int) -> void:
	var rep: Array = session.reputation
	match race:
		0: rep[0] = clampi(int(rep[0]) - amount, -100, 100)
		1: rep[0] = clampi(int(rep[0]) + amount, -100, 100)
		2: rep[1] = clampi(int(rep[1]) - amount, -100, 100)
		3: rep[1] = clampi(int(rep[1]) + amount, -100, 100)

## A kill costs 5 with the victim's race. A pirate kill instead earns a
## little distrust from the rival of the system's race (1): whoever runs the
## system is glad, their neighbours across the axis are not.
func standing_kill(race: int, local_race: int) -> void:
	if race == 8:
		match local_race:
			0: standing_delict(1, 1)
			1: standing_delict(0, 1)
			2: standing_delict(3, 1)
			3: standing_delict(2, 1)
		return
	standing_delict(race, 5)
