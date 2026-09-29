extends RefCounted
## Read-only snapshot for policy tests. Object references are identities;
## every live body is recorded separately, so mutual AI targets cannot
## recurse through one another while serializing the observation.

static func value(item):
	if item is Object: return item.get_instance_id() if is_instance_valid(item) else 0
	if item is Dictionary:
		var result := {}
		for key in item: result[key] = value(item[key])
		return result
	if item is Array: return item.map(func(entry): return value(entry))
	return item

static func fields(object: Object) -> Dictionary:
	var result := {}
	for property in object.get_property_list():
		if int(property.usage) & PROPERTY_USAGE_SCRIPT_VARIABLE:
			result[property.name] = value(object.get(property.name))
	return result

static func capture(space) -> String:
	return var_to_str([fields(space), space.bodies.map(func(body): return fields(body)),
		fields(space.tractor),
		fields(space.story) if space.story != null else {},
		space.game.session.to_dict(), space.rng.state])
