extends RefCounted
## Shared map/flight rules from the supplied Status, Hud and StarMap. The
## drive bypasses gate links, not discovery, active missions or fitted gear.
const Catalogue := preload("res://src/content/catalogue.gd")

static func known(session, cat, system: int) -> bool:
	var record: Dictionary = cat.system(system)
	return not record.is_empty() and (bool(record.get("visible", false))
		or session.visited_systems.has(str(system)) or session.unlocked_systems.has(str(system)))

static func linked(session, cat, system: int) -> bool:
	if session.in_void or cat.system(system).is_empty(): return false
	for link in cat.system(session.system_index).get("links", []):
		if int(link) == system: return true
	return false

## Status selects the mission at this orbit, campaign first. Remote goals
## and station-only types do not prevent using the drive during free flight.
static func current_mission(session) -> Dictionary:
	for campaign in [true, false]:
		var mission: Dictionary = session.story_mission if campaign else session.job
		if mission.is_empty(): continue
		var kind := int(mission.get("kind", -1))
		if (campaign and kind == 25 and not session.in_void
			and session.station_id == int(session.flags.get("wormhole_station", -2))):
			return mission
		if int(mission.get("station", -2)) != session.location_id() or kind in [8, 19, 16, 14, 13]: continue
		# Recovered freelance crates are the source's return transport leg,
		# not a fresh combat objective when reaching the client's orbit.
		return mission if campaign or (kind != 11 and not bool(mission.get("recovered", false))) else {}
	return {}

static func drive_allowed(session) -> bool:
	if not session.has_equipped_type(Catalogue.Type.JUMP_DRIVE): return false
	var mission := current_mission(session)
	return mission.is_empty() or int(mission.get("kind", -1)) in [0, 11, 23]

static func drive_destination(session, cat, station: int) -> Dictionary:
	if session.in_void:
		if station != session.station_id or cat.system_of_station(station) != session.system_index: return {}
		return {"station": station, "system": session.system_index, "void": false}
	if station == -1: return {"station": -1, "system": -1, "void": true}
	if station == session.station_id or cat.station(station).is_empty(): return {}
	var system: int = cat.system_of_station(station)
	if not known(session, cat, system): return {}
	return {"station": station, "system": system, "void": false}

static func gate_destination(session, cat, station: int) -> bool:
	return (not cat.station(station).is_empty() and cat.system_of_station(station) != session.system_index
		and linked(session, cat, cat.system_of_station(station)) and known(session, cat, cat.system_of_station(station)))
