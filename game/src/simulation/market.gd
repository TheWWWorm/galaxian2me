extends RefCounted
## Station markets: what a station stocks, what it charges and which hulls
## its dealer offers. The selection rules follow the original's; tables,
## prices and probabilities all come from the imported catalogue.

const Catalogue := preload("res://src/content/catalogue.gd")
const JavaRandom := preload("res://src/simulation/java_random.gd")

## Items that never appear on an ordinary shelf.
const SHELF_EXCLUDED := [164, 175]
## Local spirits: one per system, stocked only at home.
const SPIRITS_FIRST := 132
const SPIRITS_END := 154
## The first station's starter shelf, before the story opens the market.
const STARTER_STATION := 78
const STARTER_STEP_LIMIT := 7
const STARTER_ITEMS := [0, 22, 55]
const TRACTOR_BEAM := 68

var cat
var rng := RandomNumberGenerator.new()

func _init(catalogue) -> void:
	cat = catalogue
	rng.randomize()

## A new shelf for a station: [{id, count, price}], sorted by item id.
func generate_stock(station_id: int, story_step: int) -> Array:
	var st: Dictionary = cat.station(station_id)
	var system_index: int = st.system
	var sys: Dictionary = cat.system(system_index)
	var out: Array = []
	if station_id == STARTER_STATION and story_step < STARTER_STEP_LIMIT:
		for id in STARTER_ITEMS: out.append({"id": id, "count": 1, "price": 0})
		return out
	var station_tech: int = st.tech
	var min_tech := 1 if station_tech < 4 else station_tech / 2
	if story_step > 16 and story_step < 25 and rng.randi_range(0, 99) < 40:
		out.append({"id": TRACTOR_BEAM, "count": 1})
	for id in cat.item_count():
		var forced: bool = station_id == cat.attr(id, Catalogue.A_HOME_STATION, -1)
		var t: int = cat.tech(id)
		var spirit: bool = id >= SPIRITS_FIRST and id < SPIRITS_END
		if not forced:
			if cat.is_blueprint_product(id) or id in SHELF_EXCLUDED or t > station_tech: continue
			if cat.attr(id, Catalogue.A_OCCURRENCE) == 0 or cat.price_mid(id) == 0: continue
			if cat.attr(id, Catalogue.A_VOSSK_ONLY) == 1 and int(sys.faction) != 1: continue
			if spirit and id != SPIRITS_FIRST + system_index: continue
			if not spirit and (t > station_tech or t < min_tech): continue
			if rng.randi_range(0, 99) >= cat.attr(id, Catalogue.A_OCCURRENCE): continue
		var closeness: int = cat.system_closeness(system_index, cat.attr(id, Catalogue.A_ORIGIN))
		var count := 5 + rng.randi_range(0, 14)
		var c: int = cat.category(id)
		if c != Catalogue.Category.COMMODITY and c != Catalogue.Category.SECONDARY:
			count = maxi(1, count / 5)
		elif c == Catalogue.Category.COMMODITY and closeness > 50:
			count *= maxi(1, int(float(closeness - 50) / 50.0 * 20.0))
		out.append({"id": id, "count": count})
	for entry in out:
		if not entry.has("price"): entry.price = price(entry.id, station_id)
	return out

## What this station pays and charges for an item. Prices climb from the
## minimum at the item's origin towards the maximum with distance, then vary
## by a few percent in a way fixed for each station.
func price(id: int, station_id: int) -> int:
	var lo: int = cat.price_min(id)
	var hi: int = cat.price_max(id)
	if cat.price_mid(id) <= 0: return 0
	var origin: int = cat.attr(id, Catalogue.A_ORIGIN)
	var reference: int = cat.attr(id, Catalogue.A_REFERENCE)
	var here: int = cat.system_of_station(station_id)
	var span: int = cat.system_distance(origin, reference)
	var along: int = cat.system_distance(origin, here)
	var factor := 0.0
	if span == 0: factor = 1.0 if along > 0 else 0.0
	else: factor = minf(1.0, float(along) / float(span))
	var value := lo + int(factor * float(hi - lo))
	var r := JavaRandom.new(station_id)
	var spread := maxi(1, int(value * 0.05))
	return value - spread + r.next_int(spread * 2 + 1)

## Hulls on offer at a station's dealer: [{index, faction, price}].
func generate_ships(station_id: int, story_step: int, gold_medals := false) -> Array:
	var st: Dictionary = cat.station(station_id)
	var sys: Dictionary = cat.system(int(st.system))
	if int(st.system) == 15 and story_step < 16: return []
	var faction: int = sys.faction
	var prototype := station_id == 10 and gold_medals
	var count := 1 if faction == 1 or prototype else rng.randi_range(0, 5)
	var out: Array = []
	var chosen := {}
	for _i in count:
		var index := 0
		for _attempt in 64:
			index = 8 if prototype else _dealer_hull(faction)
			if not chosen.has(index): break
		if chosen.has(index): continue
		chosen[index] = true
		out.append({"index": index, "faction": faction, "price": ship_price(index, station_id)})
	return out

func _dealer_hull(faction: int) -> int:
	if faction == 9: return 8
	if faction == 1: return 9
	var n: int = cat.ship_count()
	var index := 0
	while true:
		index = rng.randi_range(0, n - 1)
		if not index in [0, 8, 9, 10, 13, 14, 15]: break
	return index

## A dealer's asking price falls with the station's tech level.
func ship_price(index: int, station_id: int) -> int:
	var base: int = int(cat.ship(index).get("price", 0))
	var t: int = int(cat.station(station_id).get("tech", 0))
	return base - int(float(t) / 100.0 * base)

## What a dealer allows for the player's own hull.
func ship_trade_in(index: int) -> int:
	return int(float(cat.ship(index).get("price", 0)) / 1.25)
