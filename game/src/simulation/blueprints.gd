extends RefCounted
## Native recipe production. Quantities come only from the supplied catalogue.
## Contributions consume cargo, not credits a second time. Remote shipping is
## ten credits per tonne. Finished products are local cargo or wait at origin.

const EngineLanguage := preload("res://src/presentation/engine_language.gd")
const Catalogue := preload("res://src/content/catalogue.gd")
const SHIPPING_PER_TONNE := 10
var session
var cat: Catalogue

func _init(saved_session, catalogue: Catalogue) -> void:
	session = saved_session
	cat = catalogue

static func whole(value, minimum := 0, maximum := 9007199254740991) -> bool:
	return (value is int or value is float) and is_finite(float(value)) \
		and value >= minimum and value <= maximum and float(value) == floor(float(value))

static func numeric_key(key) -> bool:
	return key is String and key.is_valid_int() and str(int(key)) == key and int(key) >= 0

static func recipe(catalogue: Catalogue, product: int) -> Dictionary:
	var record: Dictionary = catalogue.item(product)
	var ids = record.get("ingredients", [])
	var amounts = record.get("amounts", [])
	if not ids is Array or not amounts is Array or ids.is_empty() or ids.size() != amounts.size(): return {}
	var result := {}
	for index in ids.size():
		if not whole(ids[index]) or not whole(amounts[index], 1): return {}
		var key := str(int(ids[index]))
		if catalogue.item(int(ids[index])).is_empty() or result.has(key): return {}
		result[key] = int(amounts[index])
	return result

## Optional fields preserve the old ownership/progress-only save representation.
## Validate before Session changes anything; malformed recipes cannot grant goods.
static func valid_saved(entries: Dictionary, catalogue: Catalogue) -> bool:
	for key in entries:
		if not numeric_key(key) or not entries[key] is Dictionary: return false
		var required := recipe(catalogue, int(key))
		if required.is_empty(): return false
		var state: Dictionary = entries[key]
		var progress = state.get("progress", {})
		if not progress is Dictionary: return false
		for ingredient in progress:
			if not required.has(ingredient) or not whole(progress[ingredient], 0, int(required[ingredient])): return false
		for field in ["cost", "produced"]:
			if state.has(field) and not whole(state[field]): return false
		if state.has("station"):
			if not whole(state.station, -1): return false
			if int(state.station) >= 0 and catalogue.station(int(state.station)).is_empty(): return false
		if int(state.get("cost", 0)) > 0 and int(state.get("station", -1)) < 0: return false
		var pending = state.get("pending", {})
		if not pending is Dictionary: return false
		for origin in pending:
			if not numeric_key(origin) or catalogue.station(int(origin)).is_empty() or not whole(pending[origin], 1): return false
	return true

func details(product: int) -> Dictionary:
	if not session.blueprints.has(str(product)): return {}
	var required := recipe(cat, product)
	if required.is_empty(): return {}
	var state: Dictionary = session.blueprints[str(product)]
	var progress: Dictionary = state.get("progress", {})
	var rows: Array = []
	var fraction := 0.0
	for key in required:
		var total := int(required[key])
		var contributed := int(progress.get(key, 0))
		rows.append({"item": int(key), "required": total, "contributed": contributed,
			"remaining": total - contributed, "cargo": session.cargo_count(int(key))})
		fraction += float(contributed) / float(total) / float(required.size())
	return {"product": product, "ingredients": rows, "fraction": fraction,
		"station": int(state.get("station", -1)), "cost": int(state.get("cost", 0)),
		"produced": int(state.get("produced", 0)), "batch": batch_size(product),
		"pending": state.get("pending", {}).duplicate(true)}

func batch_size(product: int) -> int:
	return 10 if cat.category(product) == Catalogue.Category.SECONDARY else 1

## Quotes are observations. Game re-resolves the real price and entire order
## before committing, so stale controls/confirmations cannot repeat a deposit.
func offer(product: int, ingredient: int, count: int, unit_value: int, protected: bool) -> Dictionary:
	var invalid := {"error": EngineLanguage.translate("This production order is no longer available.")}
	if session.in_void or cat.station(session.station_id).is_empty() or count <= 0 or unit_value < 0: return invalid
	if not session.blueprints.has(str(product)): return invalid
	var required := recipe(cat, product)
	var key := str(ingredient)
	if not required.has(key) or protected: return invalid
	var state: Dictionary = session.blueprints[str(product)]
	var progress: Dictionary = state.get("progress", {})
	var remaining := int(required[key]) - int(progress.get(key, 0))
	var carried: int = session.cargo_count(ingredient)
	if count > remaining or count > carried: return invalid
	var origin := int(state.get("station", -1))
	var first := int(state.get("cost", 0)) == 0
	var remote: bool = not first and origin >= 0 and origin != session.station_id
	var fee := SHIPPING_PER_TONNE * count if remote else 0
	if session.credits < fee: return {"error": EngineLanguage.translate("Not enough credits for the shipment.")}
	return {"error": "", "product": product, "ingredient": ingredient, "count": count,
		"unit_value": unit_value, "fee": fee, "first": first, "remote": remote,
		"station": session.station_id, "origin": origin, "carried": carried,
		"credits": session.credits, "state": state.duplicate(true)}

## Only Game calls this with a freshly revalidated quote. No engine RNG,
## travel, mission advancement or fitted equipment is changed by production.
func contribute(order: Dictionary) -> void:
	var product := int(order.product)
	var ingredient := int(order.ingredient)
	var count := int(order.count)
	var state: Dictionary = session.blueprints[str(product)].duplicate(true)
	var progress: Dictionary = state.get("progress", {})
	if int(state.get("station", -1)) < 0: state.station = session.station_id
	progress[str(ingredient)] = int(progress.get(str(ingredient), 0)) + count
	state.progress = progress
	state.cost = int(state.get("cost", 0)) + int(order.unit_value) * count
	session.add_cargo(ingredient, -count)
	session.credits -= int(order.fee)
	var complete := true
	var required := recipe(cat, product)
	for key in required:
		if int(progress.get(key, 0)) < int(required[key]): complete = false
	if complete:
		var quantity := batch_size(product)
		var origin := int(state.station)
		if origin == session.station_id:
			# The original grants the entire batch even if the hold overfills.
			# The ordinary departure guard then requires trading/fitting first.
			session.add_cargo(product, quantity)
		else:
			var pending: Dictionary = state.get("pending", {})
			pending[str(origin)] = int(pending.get(str(origin), 0)) + quantity
			state.pending = pending
		state.produced = int(state.get("produced", 0)) + 1
		session.add_stat("goods_produced")
		state.progress = {}
		state.cost = 0
		state.station = -1
	session.blueprints[str(product)] = state

## Physical docking collects completed goods at their original station.
## Settle before autosave, not on title Load or every panel refresh.
func collect_at(station_id: int) -> Array:
	var received: Array = []
	var key := str(station_id)
	for product in session.blueprints:
		var state: Dictionary = session.blueprints[product]
		var pending: Dictionary = state.get("pending", {})
		if not pending.has(key): continue
		var count := int(pending[key])
		session.add_cargo(int(product), count)
		pending.erase(key)
		if pending.is_empty(): state.erase("pending")
		received.append({"product": int(product), "count": count})
	return received
