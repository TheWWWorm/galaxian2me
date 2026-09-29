extends "res://tests/earned_opening_run.gd"
## Continue a COPY of an earned step-six, one-job step-thirteen, two-job
## step-fourteen, Alioth step-sixteen, Suttnar step-nineteen or fitted EMP
## step-twenty-one, rescued step-twenty-three or earned reward step-twenty-four save.
## Never use unit-fixture saves.
## The base supplies capture/report/JSON helpers.
## Only real UI callbacks and player controls may change the game state.
## godot --headless --path game --fixed-fps 60 -s res://tests/earned_travel_run.gd -- <earned-slot.json> <out-dir>

var source := ""
var source_bytes := PackedByteArray()
var started := false
var docks: Array = []
var flight_entries: Array = []
var reached_lounge := false
var combat_target: WeakRef
var completed_contract := false
var chosen_contract := {}
var input_step := -1
var gate_events: Array = []
var travel_events: Array = []
var alioth_fight_completed := false
var emp_target_disabled := false
var emp_radios_finished := false
var void_salvage_completed := false
var void_salvaged_units := 0
var gear_purchases: Array = []

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 2:
		source = args[0]
		out = args[1]
	else:
		out = ""
	_run.call_deferred()

func press(button: Button, label: String) -> bool:
	if button == null or button.disabled or not button.is_visible_in_tree():
		check(false, "usable UI control: " + label)
		return false
	button.pressed.emit()
	return true

## Picks station `sid` on the real Map as a player does: a click on its
## system on the chart (leaving another open system first), then one on its
## planet. Returns the planet card's departure button.
func map_station(map, sid: int) -> Button:
	var system_id: int = app.catalogue.system_of_station(sid)
	if map.system_view != system_id:
		if map.system_view >= 0: map.close_system()
		map_click(map, map._to_screen(map.canvas, app.catalogue.system(system_id)))
		await frames(3)
	for o in map._orbit_layout(system_id):
		if int(o.station) == sid: map_click(map, map._planet_point(map.canvas, o))
	await frames(2)
	return card_button(map.side, sid)

func map_click(map, at: Vector2) -> void:
	for down in [true, false]:
		var e := InputEventMouseButton.new()
		e.button_index = MOUSE_BUTTON_LEFT; e.pressed = down; e.position = at
		map.canvas._gui_input(e)

func card_button(node: Node, sid: int) -> Button:
	for child in node.get_children():
		if child.is_queued_for_deletion(): continue
		if child is Button and int(child.get_meta("station", -1)) == sid: return child
		var found := card_button(child, sid)
		if found != null: return found
	return null

func named_button(node: Node, text: String) -> Button:
	for child in node.get_children():
		if child.is_queued_for_deletion(): continue
		if child is Button and child.text.begins_with(text): return child
		var found := named_button(child, text)
		if found != null: return found
	return null

func item_row(node: Node, text: String) -> Button:
	for child in node.get_children():
		if child.is_queued_for_deletion() or not child is Button: continue
		for row in child.get_children():
			for label in row.get_children():
				# Similar models may share a name prefix; never buy an upgraded
				# variant merely because the randomized shelf lists it first.
				if label is Label and (label.text == text or label.text.begins_with(text + "  ×")): return child
	return null

func clear_dialogue() -> void:
	for i in 100:
		var talk := dialogue(app.screen)
		if talk == null: return
		await shot("dialogue_step%d" % app.game.session.story_step)
		press(talk.next_button, "dialogue Next")
		await frames(1)
	check(false, "dialogue terminates within its bounded line count")

func watch_flight_entry(node: Node) -> void:
	if node is Flight:
		node.ready.connect(check_flight_entry.bind(weakref(node)), CONNECT_ONE_SHOT)

func check_flight_entry(reference: WeakRef) -> void:
	var flight = reference.get_ref()
	if flight == null: return
	# ready is before the first physics tick. Checking several frames later
	# compares a live ship (which may already be hit) to its last stored state.
	check(flight.space.clock == 0 and flight.space.player.hull + flight.space.player.armor == int(flight.game.session.ship.hull),
		"flight initializes exact saved base hull plus armor before simulation")
	flight.space.event.connect(observe_travel_event.bind(reference))
	if input_step == 16 and flight.game.session.story_step == 16:
		var story = flight.space.story
		check(story != null and story.cast.size() == 7 and int(story.objective.get("to", 0)) == 4,
			"Alioth departure creates four Void fighters and three Terran allies")
		if story != null:
			print("ALIOTH CAST ", JSON.stringify(story.cast.map(func(b): return {"faction": b.faction, "hull": b.hull, "position": str(b.pos)})))

func observe_travel_event(kind: String, data: Dictionary, reference: WeakRef) -> void:
	if kind not in ["gate", "jumped"]: return
	var flight = reference.get_ref()
	if flight == null: return
	var space = flight.space
	var record := {"event": kind, "from_station": space.station.station_id,
		"from_system": app.catalogue.system_of_station(space.station.station_id), "data": data.duplicate(true)}
	if kind == "gate":
		record.destination = space.jump_destination.duplicate(true)
		record.distance = space.player.pos.distance_to(space.gate.pos) if space.gate != null else -1.0
		check(space.gate != null and space.target == space.gate and float(record.distance) < space.GATE_ZONE,
			"gate transition begins by physically reaching the targeted gate")
		gate_events.append(record)
	else:
		travel_events.append(record)
	print("TRAVEL EVENT ", JSON.stringify(record))

func _run() -> void:
	if started: return
	started = true
	if source.is_empty() or out.is_empty() or not FileAccess.file_exists(source):
		push_error("Provide an earned JSON slot and a separate output directory.")
		quit(2)
		return
	root.size = Vector2i(1280, 800)
	DirAccess.make_dir_recursive_absolute(out)
	source_bytes = FileAccess.get_file_as_bytes(source)
	app = TestApp.new()
	save_root = out.path_join("test-saves-%d" % Time.get_ticks_usec())
	app.disk_saves = save_root
	node_added.connect(watch_flight_entry)
	node_added.connect(trace_flight_node)
	root.add_child(app)
	await frames(3)
	var header = JSON.parse_string(source_bytes.get_string_from_utf8())
	if not header is Dictionary or not app.activate(str(header.get("content", ""))):
		check(false, "earned checkpoint's supplied content is installed")
		await finish()
		return
	DirAccess.make_dir_recursive_absolute(app.save_path(0).get_base_dir())
	check(DirAccess.copy_absolute(source, app.save_path(0)) == OK, "copy earned save into fresh isolated storage")
	app.show_title()
	await frames(3)
	app.screen._load()
	await frames(2)
	var box = app.screen.panel_holder.get_child(0).get_child(0)
	press(box.get_child(1), "title Load manual slot 1")
	await frames(3)
	input_step = int(header.get("story_step", -1))
	check(app.screen is Station and input_step in [6, 13, 14, 16, 19, 21, 23, 24] and app.game.session.story_step == input_step,
		"load supported retained earned checkpoint via title menu")
	if not app.screen is Station or not input_step in [6, 13, 14, 16, 19, 21, 23, 24] or app.game.session.story_step != input_step:
		await finish()
		return
	check(app.save_attempts.is_empty(), "load neither rewards nor overwrites a docking checkpoint")
	check(not app.game.campaign.journal_lines.is_empty(), "journal table is recovered from JSON numeric constants")
	var counter := {"target_expr": {"expr": [96.0, {"static": "jobs"}, 2.0]}, "jobs_at_start": 4, "target": 0}
	check(app.game.campaign._counter_target(counter) == 6, "JSON job target preserves jobs-at-start plus two")
	for record in app.library.data.campaign.steps:
		if int(record.step) in range(4, 26): print("PROGRESSION ", JSON.stringify(record))
	timeline.append({"step": input_step, "station": app.game.session.station_id, "frame": 0})
	await shot("earned_input_station")
	if input_step == 6:
		await fit_tutorial()
		await clear_dialogue()
		if failures == 0: await opening_travel()
	elif input_step == 13:
		check(app.game.session.stat("jobs") == 1 and app.game.session.job.is_empty()
			and app.game.campaign._counter_target(app.game.session.story_mission) == 2,
			"retained step thirteen has exactly one earned job and still needs a second")
		reached_lounge = failures == 0
		# Loading is not a docking event; only subsequent screen replacements
		# should be checked for a new docking autosave.
		seen_screen = app.screen.get_instance_id()
	elif input_step == 16:
		check(app.game.session.stat("jobs") == 2 and app.game.session.job.is_empty()
			and app.game.session.station_id == int(app.game.session.story_mission.station),
			"retained Alioth checkpoint has two earned jobs and its actual story station")
		seen_screen = app.screen.get_instance_id()
		if failures == 0: await alioth_and_gate_checkpoint()
	elif input_step == 19:
		check(app.game.session.stat("jobs") == 2 and app.game.session.job.is_empty()
			and int(app.game.session.story_mission.get("kind", -1)) == 20,
			"retained Suttnar checkpoint has its earned jobs and supplied arrival objective")
		seen_screen = app.screen.get_instance_id()
		if failures == 0: await emp_equipment_checkpoint()
	elif input_step == 21:
		check(app.game.session.has_equipped_type(app.catalogue.Type.EMP_BOMB),
			"retained earned encounter input has fitted EMP ammunition")
		seen_screen = app.screen.get_instance_id()
		if failures == 0: await emp_flight_checkpoint()
	elif input_step == 23:
		check(app.game.session.stat("jobs") == 2 and app.game.session.job.is_empty()
			and int(app.game.session.story_mission.get("kind", -1)) == 11,
			"retained rescue checkpoint still requires the supplied reward-station docking")
		seen_screen = app.screen.get_instance_id()
		if failures == 0: await fit_available_shield()
		if failures == 0: await rescue_reward_checkpoint()
	elif input_step == 24:
		check(app.game.session.stat("jobs") == 2 and app.game.session.job.is_empty()
			and int(app.game.session.story_mission.get("kind", -1)) == 4
			and app.game.session.flags.get("wormhole_station", -1) == 48
			and app.game.session.flags.get("wormhole_system", -1) == 9,
			"retained earned reward input contains the supplied next mission and wormhole location")
		seen_screen = app.screen.get_instance_id()
		if failures == 0: await void_salvage_checkpoint()
	else:
		check(app.game.session.stat("jobs") == 2 and app.game.session.job.is_empty(),
			"retained step fourteen has two completed jobs and no active job")
		seen_screen = app.screen.get_instance_id()
		if failures == 0: await campaign_after_contract()
	if reached_lounge and failures == 0:
		if app.game.session.cargo_used() > 0: await trade_for_contract()
		await freelance_checkpoint()
		check(completed_contract, "complete a real free-play courier contract")
		if completed_contract: await save_checkpoint()
		if completed_contract and input_step == 13 and failures == 0:
			await campaign_after_contract()
	check(FileAccess.get_file_as_bytes(source) == source_bytes, "retained earned source remains byte-identical")
	await finish()

func fit_tutorial() -> void:
	var station = app.screen
	press(station.menu.get_child(0), "Hangar")
	await frames(3)
	check(station.current_panel is TabContainer, "earned Hangar opens")
	if not station.current_panel is TabContainer: return
	var tabs: TabContainer = station.current_panel
	var shop = tabs.get_child(0)
	var fitting = tabs.get_child(1)
	var weapon := -1
	var armor := -1
	for entry in app.game.shelf():
		var id := int(entry.id)
		# Select the shelf's first primary (the long-range starter laser), not
		# whichever primary happens to occur last in the inventory list.
		if weapon < 0 and app.catalogue.category(id) == 0: weapon = id
		if app.catalogue.type(id) == app.catalogue.Type.ARMOR: armor = id
	check(weapon >= 0 and armor >= 0, "actual starter shelf supplies the combat tutorial equipment")
	if weapon < 0 or armor < 0: return
	var before_credits: int = app.game.session.credits
	var base_hull: int = app.game.session.ship.hull
	for id in [weapon, armor]:
		tabs.current_tab = 0
		await frames(2)
		if not press(item_row(shop.shelf_list, app.catalogue.item_name(id)), "select starter item"): return
		await frames(2)
		var price: int = app.game.price_here(id)
		var count: int = app.game.session.cargo_count(id)
		if not press(named_button(shop.detail, "Buy"), "Buy starter item"): return
		await frames(2)
		check(app.game.session.cargo_count(id) == count + 1 and app.game.session.credits == before_credits - price,
			"shop obtains %s at its actual shelf price" % app.catalogue.item_name(id))
		before_credits = app.game.session.credits
		tabs.current_tab = 1
		await frames(2)
		var category: int = app.catalogue.category(id)
		var slots: Array = app.game.session.equipment[category]
		var target_slot := slots.find(null)
		if target_slot < 0:
			check(false, "an empty compatible fitting slot exists")
			return
		# Slot rows are in category/slot order; labels are original strings.
		var row_index := target_slot
		for previous in category: row_index += app.game.session.equipment[previous].size()
		var rows: Array = fitting.slots_list.get_children().filter(func(n): return n is Button and not n.is_queued_for_deletion())
		if not press(rows[row_index], "select compatible fitting slot"): return
		await frames(2)
		if not press(item_row(fitting.detail, app.catalogue.item_name(id)), "Mount starter item"): return
		await frames(3)
		check(app.game.session.equipment[category][target_slot] != null and int(app.game.session.equipment[category][target_slot].id) == id,
			"fitting mounts %s from the hold" % app.catalogue.item_name(id))
		if id == weapon: check(app.game.session.story_step == 6, "weapon alone cannot skip the armor requirement")
	await shot("tutorial_equipment_fitted")
	var plate: int = app.game.session.ship_stats().armor_plate
	check(int(app.game.session.ship.get("armor", -1)) == plate and int(app.game.session.ship.hull) == base_hull + plate,
		"fitting armor initializes its protection without subtracting base hull")
	await frames(90)
	check(app.game.session.story_step == 7, "fitting completes equipment tutorial while still docked")
	check(app.save_attempts.is_empty(), "fitting does not overwrite a docking checkpoint")

## Buy and fit only an actual affordable shield. An unarmed travel controller
## must not assume random hostile traffic will ignore the starting ship.
func fit_available_shield() -> void:
	if app.game.session.has_equipped_type(app.catalogue.Type.SHIELD): return
	var category := int(app.catalogue.Category.EQUIPMENT)
	var target_slot: int = app.game.session.equipment[category].find(null)
	if target_slot < 0: return
	var scanner: Dictionary = app.game.session.equipped_of_type(app.catalogue.Type.SCANNER)
	var budget: int = app.game.session.credits
	if not scanner.is_empty(): budget += app.game.price_here(int(scanner.id)) * int(scanner.count)
	var id := -1
	var protection := 0
	for entry in app.game.shelf():
		var candidate := int(entry.id)
		if int(entry.count) <= 0 or int(entry.price) > budget: continue
		if app.catalogue.type(candidate) != app.catalogue.Type.SHIELD: continue
		var value := int(app.catalogue.attr(candidate, app.catalogue.A_SHIELD))
		print("AFFORDABLE SHIELD ", JSON.stringify({"id": candidate, "price": entry.price, "shield": value}))
		if value > protection: id = candidate; protection = value
	if id < 0: return
	# Trade the nonessential scanner only when it funds a real shield offer.
	# All inventory/credit changes still come from the ordinary fitting UI.
	if app.game.price_here(id) > app.game.session.credits:
		if not press(app.screen.menu.get_child(0), "Hangar to fund shield purchase"): return
		await frames(3)
		var funding_tabs = app.screen.current_panel
		funding_tabs.current_tab = 1
		await frames(3)
		var funding = funding_tabs.get_child(1)
		var scanner_id := int(scanner.id)
		if not press(item_row(funding.slots_list, app.catalogue.item_name(scanner_id)), "select mounted scanner trade-in"): return
		await frames(2)
		var proceeds: int = app.game.price_here(scanner_id) * int(scanner.count)
		var before: int = app.game.session.credits
		if not press(named_button(funding.detail, app.library.text(137)), "Sell scanner to fund shield"): return
		await frames(3)
		check(app.game.session.credits == before + proceeds and not app.game.session.has_equipped_type(app.catalogue.Type.SCANNER),
			"actual scanner trade-in funds protection without granting credits")
		gear_purchases.append({"id": scanner_id, "price": -proceeds, "station": app.game.session.station_id, "action": "sell"})
	await buy_and_mount(id, category, target_slot)
	if failures == 0: check(app.game.session.has_equipped_type(app.catalogue.Type.SHIELD), "purchased shield is actually equipped")

func fit_available_primary() -> void:
	var old = app.game.session.equipment[0][0]
	if old == null: return
	var best: float = float(app.catalogue.attr(int(old.id), app.catalogue.A_DAMAGE)) / maxf(1.0, app.catalogue.attr(int(old.id), app.catalogue.A_RELOAD))
	var id := -1
	for entry in app.game.shelf():
		var candidate := int(entry.id)
		if int(entry.count) <= 0 or int(entry.price) > app.game.session.credits: continue
		if app.catalogue.category(candidate) != app.catalogue.Category.PRIMARY: continue
		# Every native primary has its own real range and projectile speed;
		# the pilot below aims and fires using those, rather than requiring the
		# starter laser's unusually long range and skipping affordable guns.
		var score: float = float(app.catalogue.attr(candidate, app.catalogue.A_DAMAGE)) / maxf(1.0, app.catalogue.attr(candidate, app.catalogue.A_RELOAD))
		print("PRIMARY OFFER ", JSON.stringify({"id": candidate, "price": entry.price, "damage_per_ms": score}))
		if score > best: best = score; id = candidate
	if id >= 0: await buy_and_mount(id, 0, 0)

func buy_and_mount(id: int, category: int, target_slot: int) -> void:
	if not press(app.screen.menu.get_child(0), "Hangar for available equipment"): return
	await frames(3)
	var tabs = app.screen.current_panel
	var shop = tabs.get_child(0)
	var fitting = tabs.get_child(1)
	if not press(item_row(shop.shelf_list, app.catalogue.item_name(id)), "select actual equipment offer"): return
	await frames(2)
	var price: int = app.game.price_here(id)
	var before: int = app.game.session.credits
	var before_count: int = app.game.session.cargo_count(id)
	if not press(named_button(shop.detail, "Buy"), "Buy affordable equipment"): return
	await frames(3)
	check(app.game.session.credits == before - price and app.game.session.cargo_count(id) == before_count + 1,
		"equipment purchase spends the actual shelf price from earned credits")
	tabs.current_tab = 1
	await frames(3)
	var row_index := target_slot
	for previous in category: row_index += app.game.session.equipment[previous].size()
	var rows: Array = fitting.slots_list.get_children().filter(func(n): return n is Button and not n.is_queued_for_deletion())
	if not press(rows[row_index], "select compatible equipment slot"): return
	await frames(2)
	if not press(item_row(fitting.detail, app.catalogue.item_name(id)), "Mount purchased equipment"): return
	await frames(3)
	check(app.game.session.equipment[category][target_slot] != null
		and int(app.game.session.equipment[category][target_slot].id) == id and app.game.session.cargo_count(id) == before_count,
		"actual fitting transfers the purchased equipment out of cargo")
	gear_purchases.append({"id": id, "price": price, "station": app.game.session.station_id})
	await shot("earned_equipment_fitted_%d" % id)

## A controller-only pilot. No position, damage, reward or mission mutations.
func pilot(reference: WeakRef) -> Dictionary:
	var flight = reference.get_ref()
	if flight == null: return {}
	var space = flight.space
	if space.story != null and space.story.controls_locked: return {}
	# Arrival objectives require ten real seconds in that station's space.
	# Keep cruising rather than immediately docking before the goal can fire.
	var mission: Dictionary = app.game.session.story_mission
	if app.game.session.story_step == 21 and space.story != null and space.story.cast.size() == 3:
		# The actual mission calls for disabling the named target, not killing
		# neutral ships. Aim and press the ordinary secondary trigger only.
		var lead: Body = space.story.cast[0]
		var distance: float = lead.pos.distance_to(space.player.pos)
		var bomb: Dictionary = {}
		for weapon in space.player.weapons:
			if weapon.kind == "emp" and int(weapon.count) > 0: bomb = weapon; break
		var speed: float = float(bomb.get("speed", 7)) + space.player.speed
		var aim: Vector3 = lead.pos + lead.forward() * lead.speed * distance / maxf(speed, 1.0)
		if lead.disabled or not lead.combat_active: aim = lead.pos
		var steering: Vector2 = space._steer_towards(space.player, aim)
		var in_flight := false
		for projectile in space.projectiles:
			if projectile.owner == space.player and projectile.weapon.kind == "emp": in_flight = true
		var aligned: bool = space.player.forward().dot((aim - space.player.pos).normalized()) > 0.995
		return {"yaw": clampf(steering.x * 2.0, -1.0, 1.0), "pitch": clampf(steering.y * 2.0, -1.0, 1.0),
			"secondary": lead.alive and lead.combat_active and not lead.disabled and not in_flight
				and space.story._done(1) and aligned and not bomb.is_empty()
				and distance < float(bomb.get("life", 0)) * speed * 0.8}
	if int(mission.get("kind", -1)) == 20 and int(mission.get("station", -1)) == space.station.station_id and flight.flight_ms <= 11000:
		return {}
	var story_fight: bool = space.story != null and space.story.active() and not space.story.complete and int(app.game.session.story_mission.get("kind", -1)) == 4
	var fight: bool = story_fight or (space.story != null and not space.story.job.is_empty() and int(space.story.job.kind) not in [0, 11] and not space.story.complete)
	if input_step in [23, 24]:
		for hostile in space.hostiles():
			if hostile.visible and not hostile.friendly and hostile.pos.distance_to(space.player.pos) < 45000.0:
				fight = true
				break
	if app.game.session.story_step == 24 and story_fight and space.hostiles().is_empty():
		# Only normal stick input: keeping the crate under the crosshair lets
		# the fitted tractor charge and pull it. Never set the objective,
		# counter or ship position.
		var salvage: Body
		for body in space.bodies:
			if not body.alive or body.kind != Body.Kind.LOOT: continue
			if salvage == null or body.pos.distance_to(space.player.pos) < salvage.pos.distance_to(space.player.pos): salvage = body
		if salvage != null:
			var stick: Vector2 = space._steer_towards(space.player, salvage.pos)
			return {"yaw": clampf(stick.x * 2.0, -1.0, 1.0), "pitch": clampf(stick.y * 2.0, -1.0, 1.0)}
		return {}
	if fight:
		var enemy: Body = combat_target.get_ref() if combat_target != null else null
		var nearest: Body
		for b in space.hostiles():
			if not b.visible or b.friendly or b.ai.get("mode", "") == "hold": continue
			if nearest == null or b.pos.distance_to(space.player.pos) < nearest.pos.distance_to(space.player.pos): nearest = b
		if enemy != null and nearest != null and enemy.pos.distance_to(space.player.pos) > 12000.0 and nearest.pos.distance_to(space.player.pos) < enemy.pos.distance_to(space.player.pos) * 0.6:
			enemy = nearest
			combat_target = weakref(enemy)
		if enemy == null or not enemy.alive or not enemy.visible or enemy.friendly:
			enemy = null
			for b in space.hostiles():
				if not b.visible or b.friendly or b.ai.get("mode", "") == "hold": continue
				if enemy == null or b.pos.distance_to(space.player.pos) < enemy.pos.distance_to(space.player.pos): enemy = b
			combat_target = weakref(enemy) if enemy != null else null
		if enemy == null: return {}
		var distance: float = enemy.pos.distance_to(space.player.pos)
		var speed := 16.0
		var reach := 30000.0
		if not space.player.weapons.is_empty():
			speed = float(space.player.weapons[0].speed) + space.player.speed
			reach = float(space.player.weapons[0].life) * speed
		var aim: Vector3 = enemy.pos + enemy.forward() * enemy.speed * distance / maxf(1.0, speed)
		var steering: Vector2 = space._steer_towards(space.player, aim)
		# The trigger is not a target-specific damage command. Real projectiles
		# hit an intervening ally, including during a turn. Hold fire until the
		# nose is on the enemy and the friendly formation has cleared the shot.
		var clear := true
		var forward: Vector3 = space.player.forward()
		for body in space.bodies:
			if not body.alive or not body.visible or not body.friendly or body == space.player: continue
			var relative: Vector3 = body.pos - space.player.pos
			var along: float = relative.dot(forward)
			if along < -body.radius or along > distance: continue
			var future: Vector3 = relative + body.forward() * body.speed * maxf(0.0, along) / maxf(1.0, speed)
			# Conservative AABB-sized corridor around current and predicted
			# positions. This only decides whether the player holds the trigger.
			var margin: float = body.radius + 400.0
			var now: Vector3 = (relative - forward * along).abs()
			var later: Vector3 = (future - forward * future.dot(forward)).abs()
			if (now.x < margin and now.y < margin and now.z < margin) or (later.x < margin and later.y < margin and later.z < margin):
				clear = false
		if not clear and distance > 10000.0:
			steering = space._steer_towards(space.player, aim + Vector3(0, 18000, 0))
		# Read-only sight query uses the same boxes as the native projectile
		# sweep. A close ship fills a wider angle than an arbitrary aim cone;
		# this decides the trigger only and never applies damage or moves bodies.
		var sight = space._sweep({"owner": space.player, "pos": space.player.pos + forward * 400.0}, forward * minf(reach, distance + enemy.radius))
		var aligned: bool = sight != null and sight.is_ship() and sight.hostile and not sight.friendly
		return {"yaw": clampf(steering.x * 2.0, -1.0, 1.0), "pitch": clampf(steering.y * 2.0, -1.0, 1.0),
			"fire": distance < reach and aligned and clear, "autopilot": space.autopilot}
	return navigation_input(space)

## Normal stick/target controls for a route, independent of combat policy.
func navigation_input(space) -> Dictionary:
	var goal: Body = space.station
	var sid := int(app.game.destination.get("station", -1))
	if sid >= 0 and sid != space.station.station_id:
		if app.catalogue.system_of_station(sid) != app.game.session.system_index:
			goal = space.gate
		else:
			for b in space.bodies:
				if b.kind == Body.Kind.STAR and b.station_id == sid: goal = b; break
	if goal == null: return {}
	var at: Vector3 = space.player.pos + space._star_direction(goal) * 100000.0 if goal.kind == Body.Kind.STAR else goal.pos
	# Steer the test pilot around actual large rocks rather than expect an
	# autopilot course to remove collision hazards. Only normal stick input
	# and the existing autopilot toggle are returned; the world is unchanged.
	var direction: Vector3 = (at - space.player.pos).normalized()
	var hazard: Body
	var ahead_best := 20000.0
	var clearance := 0.0
	for b in space.bodies:
		if not b.alive or b.kind != Body.Kind.ASTEROID or b.size <= 30: continue
		var relative: Vector3 = b.pos - space.player.pos
		var ahead: float = relative.dot(direction)
		var radius: float = 1500.0 * b.scale.length() / 1.7 + space.PLAYER_RADIUS + 2500.0
		if ahead > -radius and ahead < ahead_best and (relative - direction * ahead).length() < radius:
			hazard = b
			ahead_best = ahead
			clearance = radius
	if hazard != null:
		var bypass: Vector3 = hazard.pos + Vector3.UP * clearance * 2.0
		var avoid: Vector2 = space._steer_towards(space.player, bypass)
		return {"yaw": avoid.x, "pitch": avoid.y, "autopilot": space.autopilot}
	var steering: Vector2 = space._steer_towards(space.player, at)
	return {"yaw": steering.x, "pitch": steering.y,
		"fire_pressed": space.target == goal and space.locked and not space.autopilot and space.travelling < 0}

func observe() -> void:
	var screen = app.screen
	var step: int = app.game.session.story_step
	if step != seen_step:
		seen_step = step
		timeline.append({"step": step, "station": app.game.session.station_id, "frame": frame, "jobs": app.game.session.stat("jobs")})
		print("EARNED ", JSON.stringify(timeline.back()))
	if screen.get_instance_id() != seen_screen:
		seen_screen = screen.get_instance_id()
		if screen is Flight:
			combat_target = null
			screen.controls.scripted = pilot.bind(weakref(screen))
			last_shots = 0
			flight_entries.append({"step": step, "station": app.game.session.station_id})
			if step == 7:
				print("FITTED WEAPONS ", JSON.stringify(screen.space.player.weapons))
				check(screen.space.story != null and screen.space.story.cast.size() == 4, "earned departure creates the actual pirate tutorial and Gunant")
				check(screen.conversation != null, "combat tutorial shows its imported briefing")
				check(screen.space.player.armor == screen.space.player.armor_max and screen.space.player.hull + screen.space.player.armor == int(app.game.session.ship.hull),
					"flight restores the fitted armor and base hull without double subtraction")
		elif screen is Station:
			docks.append({"step": step, "station": app.game.session.station_id})
			print("DOCK ", JSON.stringify(docks.back()))
			check(int(app.game.session.ship.hull) == int(app.game.session.ship_stats().max_hull) and int(app.game.session.ship.armor) == int(app.game.session.ship_stats().armor_plate),
				"real docking services the equipped hull and armor before saving")
			check(int(app.save_summary(app.AUTOSAVE_SLOT).get("story_step", -1)) == step, "docking snapshot contains settled step %d" % step)
	if screen is Flight:
		if input_step in [23, 24] and step == 25 and not void_salvage_completed:
			var encounter = screen.space.story
			void_salvaged_units = int(screen.space.stats.get("collected", 0))
			void_salvage_completed = encounter != null and encounter.complete and encounter.finished.size() == 2 and encounter.finished.all(func(done): return done)
			check(void_salvage_completed and void_salvaged_units >= 3 and app.game.session.cargo_count(131) >= 3,
				"real salvage and both acknowledged radio lines earn step twenty-five")
			check(not app.game.can_sell_cargo(131), "actual mission transition protects the earned alien remains")
			await shot("earned_void_salvage_result")
		if input_step in [19, 21] and step in [21, 22] and screen.space.story != null and screen.space.story.cast.size() == 3:
			var encounter = screen.space.story
			var lead = encounter.cast[0]
			if lead.disabled and lead.alive and not emp_target_disabled:
				emp_target_disabled = true
				check(lead.hull == lead.hull_max, "native secondary EMP disables the named target without hull damage")
				await shot("earned_emp_target_disabled")
			if encounter.finished.size() == 3 and encounter.finished.all(func(done): return done):
				emp_radios_finished = true
			if not encounter.message().is_empty(): await shot("emp_radio_%d" % encounter.current)
		if input_step == 16 and step == 17 and not alioth_fight_completed:
			var story = screen.space.story
			alioth_fight_completed = story != null and story.complete and story.cast.size() == 7
			if alioth_fight_completed:
				for i in 4: alioth_fight_completed = alioth_fight_completed and not story.cast[i].alive
			check(alioth_fight_completed, "all four actual Alioth Void fighters are destroyed before return")
			if story != null and story.cast.size() == 7:
				var allies_loyal := true
				for i in range(4, 7):
					allies_loyal = allies_loyal and story.cast[i].friendly and not story.cast[i].hostile and story.cast[i].ai.get("target") != screen.space.player
				check(allies_loyal, "scripted Alioth escorts retain their allegiance after actual combat")
		if screen.menu_paused and screen.hud.pause_panel != null:
			press(screen.hud.pause_panel.get_child(0).get_child(0), "Resume focus pause")
			focus_resumes += 1
		shots += maxi(0, screen.space.shots_fired - last_shots)
		last_shots = screen.space.shots_fired
		if step in [14, 15] and screen.space.shots_fired > 5: await shot("convoy_combat_step%d" % step)
		if step == 16 and screen.space.shots_fired > 5: await shot("alioth_void_combat")
		var salvage_scene: bool = step == 24 and screen.space.story != null and screen.space.story.active()
		if salvage_scene and screen.space.shots_fired > 5: await shot("void_salvage_combat")
		if salvage_scene and int(screen.space.stats.get("collected", 0)) > 0 and app.game.session.cargo_count(131) > 0: await shot("void_remains_collected")
		if salvage_scene and not screen.space.story.message().is_empty():
			await shot("void_salvage_radio_%d" % screen.space.story.current)
		if screen.space.jumping >= 0: await shot("gate_flight_from_%d" % screen.space.station.station_id)
		if screen.space.story != null and not screen.space.story.message().is_empty():
			await shot("radio_step%d" % step)
			screen._next_radio()
		if frame % 1800 == 0:
			print("FLIGHT frame=", frame, " step=", step, " station=", app.game.session.station_id,
				" hull=", screen.space.player.hull, " shots=", shots, " pos=", screen.space.player.pos,
				" hostiles=", screen.space.hostiles().size(), " target=", screen.space.target.name if screen.space.target != null else "none")
			if combat_target != null and combat_target.get_ref() != null:
				var enemy = combat_target.get_ref()
				print("AIM distance=", enemy.pos.distance_to(screen.space.player.pos), " hull=", enemy.hull,
					" dot=", screen.space.player.forward().dot((enemy.pos - screen.space.player.pos).normalized()))

func choose_destination(sid: int) -> bool:
	var station = app.screen
	if not press(station.menu.get_child(2), "Map"): return false
	await frames(3)
	var map = station.current_panel
	if map == null:
		check(false, "Map is unlocked after the combat tutorial")
		return false
	check(map._known(app.catalogue.system_of_station(sid)), "campaign destination system is visible on the real Map")
	if not map._known(app.catalogue.system_of_station(sid)): return false
	var card: Button = await map_station(map, sid)
	if not press(card, "choose destination on Map"): return false
	await frames(2)
	await shot("map_to_%d" % sid)
	if not press(named_button(map.side, app.library.text(38)), "confirm departure"): return false
	await frames(3)
	check(app.screen is Flight and int(app.game.destination.get("station", -1)) == sid, "Map confirms real flight towards %s" % app.catalogue.station_name(sid))
	return app.screen is Flight

func opening_travel() -> void:
	press(app.screen.launch_button, "Depart for pirate tutorial")
	await frames(3)
	for tick in 60000:
		frame = tick
		await observe()
		await clear_dialogue()
		var screen = app.screen
		var step: int = app.game.session.story_step
		if screen is Flight:
			if screen.defeated:
				check(false, "earned continuation survives its native flight")
				break
			if step == 7 and tick > 120: await shot("pirate_tutorial_combat")
			if step in [10, 11, 12]: await shot("travel_step%d_station%d" % [step, app.game.session.station_id])
		elif screen is Station:
			if step == 10:
				check(shots > 0 and app.game.session.stat("kills") > 5, "native player projectiles complete the pirate fight")
				check(not app.game.session.has_equipped_type(app.catalogue.Type.MINING_LASER), "Gunant receives his equipped prototype back when travel unlocks")
				check(app.game.session.cargo_count(90) == 0, "returned prototype is not duplicated into the hold")
				await shot("travel_unlocked_station")
			if step in [10, 11, 12]:
				if not await choose_destination(int(app.game.session.story_mission.station)): break
			elif step == 13:
				reached_lounge = true
				check(app.game.session.stat("jobs") == 0 and app.game.campaign._counter_target(app.game.session.story_mission) == 2,
					"earned lounge unlock still requires two real contracts")
				check(app.game.session.visited_stations.has("79") and app.game.session.visited_stations.has("76"), "real star travel and docking visit Kernstal and Yrdal Gedal")
				press(screen.menu.get_child(1), "Space Lounge")
				await frames(3)
				check(screen.current_panel != null and screen.current_panel.get_script() == preload("res://src/screens/station/lounge_panel.gd"), "earned Space Lounge opens through the menu")
				await shot("earned_lounge")
				break
			else:
				check(false, "unexpected docked continuation step %d" % step)
				break
		await frames(1)
	check(reached_lounge, "earned combat and travel tutorials reach the free-play lounge")
	if not reached_lounge: await shot("continuation_failure")

func trade_for_contract() -> void:
	var station = app.screen
	var auto_before := saved_state(app.AUTOSAVE_SLOT)
	press(station.menu.get_child(0), "Hangar for earned ore sale")
	await frames(3)
	var shop = station.current_panel.get_child(0)
	var ids := app.game.session.cargo.keys().duplicate()
	var sold := 0
	for key in ids:
		var id := int(key)
		var count: int = app.game.session.cargo_count(id)
		var credits: int = app.game.session.credits
		var price: int = app.game.price_here(id)
		if not press(item_row(shop.hold_list, app.catalogue.item_name(id)), "select earned cargo for sale"): return
		await frames(2)
		if not press(named_button(shop.detail, "Max"), "sell maximum earned cargo"): return
		await frames(2)
		if not press(named_button(shop.detail, app.library.text(137)), "confirm cargo sale"): return
		await frames(2)
		check(app.game.session.cargo_count(id) == 0 and app.game.session.credits == credits + count * price,
			"sale of %s uses its real station price and quantity" % app.catalogue.item_name(id))
		sold += count
	check(sold > 0 and app.game.session.cargo_used() == 0, "earned mining and salvage cargo funds trade and frees courier space")
	check(saved_state(app.AUTOSAVE_SLOT) == auto_before, "bulk trading does not overwrite the docking snapshot")
	check(app.game.session.story_step == 13 and app.game.session.stat("jobs") == 0, "trading cannot satisfy the two-contract requirement")
	await shot("earned_bulk_trade")

func fly_to_dock() -> bool:
	for tick in 16000:
		frame += 1
		await observe()
		await clear_dialogue()
		if app.screen is Station:
			# A result callback can replace the flight during clear_dialogue.
			await observe()
			return true
		if app.screen is Flight and app.screen.defeated:
			await shot("earned_flight_defeat")
			check(false, "survive the earned free-play trip")
			return false
		if app.screen is Flight and app.screen.space.story != null and app.screen.space.story.failed:
			await shot("earned_mission_failure")
			check(false, "earned flight preserves its required mission target")
			return false
		await frames(1)
	check(false, "free-play trip docks before its bounded deadline")
	return false

func freelance_checkpoint() -> void:
	# Search actual generated lounges by travelling. No generated offers,
	# RNG state, credits, damage or campaign counters are replaced by fixtures.
	for visit in 10:
		var station = app.screen
		press(station.menu.get_child(1), "Space Lounge for contract")
		await frames(3)
		var lounge = station.current_panel
		var people: Array = app.game.lounge()
		var choice := -1
		for index in people.size():
			var job: Dictionary = people[index].get("job", {})
			if int(job.get("kind", -1)) != 0 or int(job.get("count", 0)) > app.game.session.cargo_free(): continue
			if app.catalogue.system_of_station(int(job.station)) != app.game.session.system_index: continue
			choice = index
			chosen_contract = job.duplicate(true)
			break
		print("LOUNGE at ", app.game.session.station_id, " ", JSON.stringify(people))
		if choice >= 0:
			var before_credits: int = app.game.session.credits
			var before_jobs: int = app.game.session.stat("jobs")
			if not press(item_row(lounge.list, str(people[choice].name)), "choose courier client"): return
			await frames(2)
			await shot("courier_offer")
			if not press(named_button(lounge.detail, app.library.text(38)), "accept courier contract"): return
			await frames(3)
			check(not app.game.session.job.is_empty() and app.game.session.cargo_count(116) == int(chosen_contract.count), "accepted real courier offer loads its secure freight")
			check(app.game.session.credits == before_credits and app.game.session.stat("jobs") == before_jobs, "accepting a contract does not pay or count completion")
			if app.game.session.job.is_empty(): return
			if not await choose_destination(int(chosen_contract.station)): return
			if not await fly_to_dock(): return
			check(app.game.session.station_id == int(chosen_contract.station) and app.game.session.job.is_empty() and app.game.session.cargo_count(116) == 0,
				"actual courier arrival delivers secure freight and clears the active contract")
			check(app.game.session.credits == before_credits + int(chosen_contract.reward) and app.game.session.stat("jobs") == before_jobs + 1,
				"courier pays the offered reward and counts exactly one completed job")
			var expected_step := 14 if before_jobs == 1 else 13
			check(app.game.session.story_step == expected_step,
				"second earned contract advances to fourteen; the first alone does not")
			check(saved_state(app.AUTOSAVE_SLOT) == snapshot(), "docking autosave contains the earned courier reward, cargo and campaign state")
			completed_contract = true
			await shot("courier_completed_station")
			return
		# Visit more stations than the three-station market cache. Alternating
		# two cached lounges can never reveal another offer after both run out.
		var stations: Array = app.catalogue.system(app.game.session.system_index).get("stations", [])
		var current_index := -1
		for index in stations.size():
			if int(stations[index]) == app.game.session.station_id: current_index = index
		var sid := int(stations[(current_index + 1) % stations.size()])
		if not await choose_destination(sid): return
		if not await fly_to_dock(): return
	check(false, "find an eligible courier by visiting actual station lounges")

func campaign_after_contract() -> void:
	# Preserve the earned second-job slot even if later native combat fails.
	var second_job_path := app.save_path(0)
	var retained := out.path_join("earned-second-job.json")
	check(DirAccess.copy_absolute(second_job_path, retained) == OK,
		"retain earned second-job input before attempting the next campaign flight")
	for trip in 5:
		var step: int = app.game.session.story_step
		if step >= 16:
			check(step == 16 and app.screen is Station and app.game.session.station_id == 98,
				"earned convoy debrief and original scripted transport reach the next story station")
			await shot("earned_next_story_station")
			await save_checkpoint()
			return
		if not step in [14, 15]:
			check(false, "supported next campaign step after the second contract")
			return
		var sid := int(app.game.session.story_mission.station)
		if sid == app.game.session.station_id:
			if not press(app.screen.launch_button, "Depart for earned campaign mission"): return
			await frames(3)
		elif not await choose_destination(sid): return
		await shot("campaign_departure_step%d" % step)
		if not await fly_to_dock(): return
		await shot("campaign_dock_step%d" % app.game.session.story_step)
	check(false, "next campaign checkpoint reached within bounded real trips")

## Plan the pilot's next Map selection from the unmodified imported graph.
## Reaching a system's gate station is an actual in-system flight and dock,
## not a state edit or an assumption that every station has a gate.
func next_route_station(destination: int) -> int:
	var here: int = app.game.session.system_index
	var goal: int = app.catalogue.system_of_station(destination)
	if here == goal: return destination
	var queue: Array = [[here]]
	var visited := {here: true}
	var route: Array = []
	while not queue.is_empty():
		var path: Array = queue.pop_front()
		var current := int(path.back())
		if current == goal:
			route = path
			break
		for link in app.catalogue.system(current).get("links", []):
			var next := int(link)
			var system: Dictionary = app.catalogue.system(next)
			var known: bool = bool(system.get("visible", false)) or app.game.session.visited_systems.has(str(next)) or app.game.session.unlocked_systems.has(str(next))
			if not visited.has(next) and known:
				visited[next] = true
				queue.append(path + [next])
	check(route.size() >= 2, "supplied known gate graph has a route to the campaign destination")
	if route.size() < 2: return -1
	var gate_station := int(app.catalogue.system(here).get("jumpgate_station", -1))
	print("GATE ROUTE ", route, " source gate station=", gate_station, " goal station=", destination)
	if gate_station != app.game.session.station_id: return gate_station
	var next := int(route[1])
	return destination if next == goal else int(app.catalogue.system(next).get("jumpgate_station", -1))

func alioth_and_gate_checkpoint() -> void:
	var before_jumps: int = app.game.session.stat("jumpgates")
	var before_kills: int = app.game.session.stat("kills")
	if not press(app.screen.launch_button, "Depart for Alioth Void mission"): return
	await frames(3)
	if not await fly_to_dock(): return
	check(app.game.session.story_step == 18 and app.game.session.station_id == 98,
		"native Alioth combat, result and return docking earn campaign step eighteen")
	# The supplied objective counts destroyed scene actors, including allied
	# kills. Requiring a player last-hit would invent a different mission.
	check(shots > 0 and alioth_fight_completed,
		"player flies and fires native projectiles while the actual Alioth objective is completed")
	print("ALIOTH PLAYER KILLS ", app.game.session.stat("kills") - before_kills)
	check(app.game.session.stat("jumpgates") == before_jumps, "Alioth combat and local return are not counted as gate travel")
	check(app.game.session.ship.faction == 0, "earned post-Alioth docking retains the supplied Terran livery change")
	if failures > 0: return
	await shot("earned_alioth_return")
	await save_checkpoint()
	check(DirAccess.copy_absolute(app.save_path(0), out.path_join("earned-alioth-return.json")) == OK,
		"retain earned post-Alioth checkpoint before attempting gate travel")
	seen_screen = app.screen.get_instance_id()
	var destination := int(app.game.session.story_mission.get("station", -1))
	check(destination >= 0 and int(app.game.session.story_mission.get("kind", -1)) == 20,
		"next campaign leg uses the supplied arrival mission")
	for trip in 12:
		if failures > 0: return
		if app.game.session.station_id == destination and (app.game.session.story_step > 18 or bool(app.game.session.flags.get("story_halted", false))):
			check(gate_events.size() > 0 and app.game.session.stat("jumpgates") == before_jumps + gate_events.size(),
				"actual gate flights are counted exactly once, separately from local star travel")
			check(saved_state(app.AUTOSAVE_SLOT) == snapshot(), "gate destination docking autosaves the settled earned campaign state")
			await shot("earned_gate_destination")
			await save_checkpoint()
			return
		var next := next_route_station(destination)
		if next < 0: return
		if next == app.game.session.station_id:
			if not press(app.screen.launch_button, "Depart for arrival objective"): return
			await frames(3)
		elif not await choose_destination(next): return
		if not await fly_to_dock(): return
		await shot("gate_route_dock_%d" % app.game.session.station_id)
	check(false, "earned Alioth continuation reaches its gate destination within bounded trips")

## Reach the supplied arrival and equipment stations through real navigation,
## then obtain and mount the mission's free EMP stack through the Hangar UI.
func emp_equipment_checkpoint() -> void:
	var credits: int = app.game.session.credits
	var before_jumps: int = app.game.session.stat("jumpgates")
	for trip in 12:
		if app.game.session.story_step == 20 and app.game.session.station_id == int(app.game.session.story_mission.station): break
		var destination := int(app.game.session.story_mission.get("station", -1))
		var next := next_route_station(destination)
		if next < 0: return
		if next == app.game.session.station_id:
			if not press(app.screen.launch_button, "Depart for supplied arrival objective"): return
			await frames(3)
		elif not await choose_destination(next): return
		if not await fly_to_dock(): return
	check(app.game.session.story_step == 20 and app.screen is Station
		and app.game.session.station_id == int(app.game.session.story_mission.station),
		"real arrival flight and docking reach the supplied EMP equipment station")
	if failures > 0: return
	check(app.game.session.stat("jumpgates") == before_jumps + gate_events.size(),
		"local arrival flights do not invent gate uses")
	check(saved_state(app.AUTOSAVE_SLOT) == snapshot(), "arrival autosave preserves the earned equipment objective and stock")
	await shot("earned_emp_station")
	await save_checkpoint()
	check(DirAccess.copy_absolute(app.save_path(0), out.path_join("earned-emp-arrival.json")) == OK,
		"retain earned step-twenty arrival before fitting")
	seen_screen = app.screen.get_instance_id()
	var station = app.screen
	var waiting := snapshot()
	if not press(station.launch_button, "attempt departure before fitting mission EMP"): return
	await frames(3)
	check(app.screen == station and snapshot() == waiting and station.toast.text == app.library.text(260),
		"actual departure control blocks an unequipped mission without mutating the earned checkpoint")
	if not press(station.menu.get_child(0), "Hangar for mission equipment"): return
	await frames(3)
	var tabs: TabContainer = station.current_panel
	var shop = tabs.get_child(0)
	var fitting = tabs.get_child(1)
	var target := int(app.game.session.story_mission.target)
	var item := -1
	var available := 0
	for entry in app.game.shelf():
		if app.catalogue.type(int(entry.id)) == target and int(entry.price) == 0 and int(entry.count) > 0:
			item = int(entry.id)
			available = int(entry.count)
			break
	check(item >= 0 and available == 10, "supplied story station offers ten free bombs of the required equipment type")
	if item < 0: return
	print("EMP ITEM ", JSON.stringify(app.catalogue.item(item)))
	var auto_before := saved_state(app.AUTOSAVE_SLOT)
	var cargo_before: int = app.game.session.cargo_count(item)
	if not press(item_row(shop.shelf_list, app.catalogue.item_name(item)), "select free mission EMP bombs"): return
	await frames(2)
	check(shop.selected == item, "shop selection targets the exact free mission item, not a name-prefix variant")
	if shop.selected != item: return
	if not press(named_button(shop.detail, "Max"), "choose mission EMP stack"): return
	await frames(2)
	if not press(named_button(shop.detail, "Buy"), "buy free mission EMP stack"): return
	await frames(3)
	check(app.game.session.cargo_count(item) == cargo_before + available and app.game.session.credits == credits,
		"actual shop transfers ten mission EMP bombs without charging credits")
	check(app.game.session.story_step == 20, "bombs in cargo alone do not satisfy the fitted-equipment objective")
	await shot("mission_emp_in_hold")
	tabs.current_tab = 1
	await frames(2)
	var category: int = app.catalogue.category(item)
	var slot: int = app.game.session.equipment[category].find(null)
	check(slot >= 0, "earned ship has an empty compatible mission-equipment slot")
	if slot < 0: return
	var row_index := slot
	for previous in category: row_index += app.game.session.equipment[previous].size()
	var rows: Array = fitting.slots_list.get_children().filter(func(n): return n is Button and not n.is_queued_for_deletion())
	if not press(rows[row_index], "select secondary slot for EMP bombs"): return
	await frames(2)
	if not press(item_row(fitting.detail, app.catalogue.item_name(item)), "mount free mission EMP stack"): return
	await frames(3)
	await clear_dialogue()
	check(app.game.session.story_step == 21 and app.game.session.has_equipped_type(target)
		and app.game.session.cargo_count(item) == 0 and int(app.game.session.equipment[category][slot].count) == available,
		"actual fitting consumes the hold stack and earns campaign step twenty-one")
	check(app.game.session.credits == credits and saved_state(app.AUTOSAVE_SLOT) == auto_before,
		"mission fitting neither invents income nor overwrites the docking snapshot")
	await shot("earned_emp_equipped")
	if failures > 0: return
	await save_checkpoint()
	check(DirAccess.copy_absolute(app.save_path(0), out.path_join("earned-emp-equipped.json")) == OK,
		"retain earned fitted step-twenty-one input for the actual EMP flight")
	if failures == 0: await emp_flight_checkpoint()

func emp_ammo() -> int:
	var count := 0
	for item in app.game.session.equipped_items():
		if app.catalogue.type(int(item.id)) == app.catalogue.Type.EMP_BOMB: count += int(item.count)
	return count

func emp_flight_checkpoint() -> void:
	var credits: int = app.game.session.credits
	var kills: int = app.game.session.stat("kills")
	var jobs: int = app.game.session.stat("jobs")
	var ammo := emp_ammo()
	var before_shots := shots
	var before_jumps: int = app.game.session.stat("jumpgates")
	seen_screen = app.screen.get_instance_id()
	if not press(app.screen.launch_button, "Depart for earned EMP encounter"): return
	await frames(3)
	check(app.screen is Flight and app.screen.space.story != null and app.screen.space.story.cast.size() == 3,
		"fitted equipment allows the actual three-ship encounter to launch")
	if not app.screen is Flight: return
	await shot("earned_emp_encounter_departure")
	if not await fly_to_dock(): return
	check(app.game.session.story_step == 23 and app.game.session.station_id == 55,
		"actual EMP encounter and original result-driven station return earn step twenty-three")
	check(app.game.session.stat("jumpgates") == before_jumps,
		"scripted EMP return does not invent a gate trip")
	check(emp_target_disabled and emp_radios_finished, "earned encounter observes target disabling and all three supplied radio lines")
	check(shots > before_shots and emp_ammo() == ammo - (shots - before_shots),
		"real secondary projectiles consume exactly the ammunition persisted at docking")
	check(app.game.session.stat("kills") == kills and app.game.session.stat("jobs") == jobs
		and app.game.session.credits == credits,
		"nonlethal story objective invents no kill, freelance job or early reward")
	check(saved_state(app.AUTOSAVE_SLOT) == snapshot(), "return docking autosaves earned EMP result and remaining ammunition")
	await shot("earned_emp_return")
	var reveal_key: String = app.game.campaign._system_unlock_field()
	var reveals: Array = app.game.campaign.step_record(23).get("statics", {}).get(reveal_key, [])
	check(not reveals.is_empty(), "supplied rescue return includes its system-reveal data")
	if not press(app.screen.menu.get_child(2), "Map after earned rescue"): return
	await frames(3)
	var map = app.screen.current_panel
	for i in reveals.size():
		if bool(reveals[i]):
			check(app.game.session.unlocked_systems.get(str(i), false) and map._known(i),
				"earned rescue reveals supplied system %d through the actual Map" % i)
	await shot("earned_emp_revealed_map")
	if failures == 0: await save_checkpoint()

## Travel an earned rescued pilot to the supplied reward station. Every leg
## uses the ordinary Map and flight controls; no arrival/campaign assignments.
func rescue_reward_checkpoint() -> void:
	var credits: int = app.game.session.credits
	var reward := int(app.game.session.story_mission.get("reward", 0))
	var destination := int(app.game.session.story_mission.get("station", -1))
	var jumps: int = app.game.session.stat("jumpgates")
	check(destination == 10 and reward == 20000, "supplied rescue delivery pays 20000 at station ten")
	for trip in 16:
		if failures > 0: return
		if app.game.session.story_step == 24:
			check(app.screen is Station and app.game.session.station_id == destination,
				"actual reward-station docking earns step twenty-four")
			check(app.game.session.flags.get("wormhole_station", -1) == 48 and app.game.session.flags.get("wormhole_system", -1) == 9,
				"earned reward transition persists the supplied wormhole location")
			check(app.game.session.credits == credits + reward,
				"rescue reward is paid exactly once on its actual destination docking")
			check(app.game.session.stat("jumpgates") == jumps + gate_events.size(),
				"reward trip counts only physically traversed gates")
			check(saved_state(app.AUTOSAVE_SLOT) == snapshot(), "reward autosave contains the settled earned payout")
			await shot("earned_rescue_reward_station")
			await save_checkpoint()
			if failures > 0: return
			check(DirAccess.copy_absolute(app.save_path(0), out.path_join("earned-rescue-reward.json")) == OK,
				"retain genuine reward checkpoint before the next scene")
			# Re-enter the same station through real departure/flight/docking;
			# loading alone cannot prove that a docking reward is not repeated.
			seen_screen = app.screen.get_instance_id()
			if not press(app.screen.launch_button, "Depart for reward redocking check"): return
			await frames(3)
			if not await fly_to_dock(): return
			check(app.game.session.story_step == 24 and app.game.session.credits == credits + reward,
				"real redocking and title reload do not pay the rescue reward twice")
			await save_checkpoint()
			if failures == 0: await void_salvage_checkpoint()
			return
		check(app.game.session.story_step == 23 and app.game.session.credits == credits,
			"intermediate travel cannot pay or skip the rescue delivery")
		var next := next_route_station(destination)
		if next < 0 or not await choose_destination(next): return
		if not await fly_to_dock(): return
		await shot("rescue_route_dock_%d" % app.game.session.station_id)
	check(false, "earned rescue delivery finishes within bounded real trips")

func void_salvage_checkpoint() -> void:
	seen_screen = app.screen.get_instance_id()
	await fit_available_shield()
	if failures == 0: await fit_available_primary()
	if failures > 0: return
	var destination := int(app.game.session.story_mission.get("station", -1))
	var credits: int = app.game.session.credits
	var jobs: int = app.game.session.stat("jobs")
	var ammo := emp_ammo()
	check(destination == 48 and app.game.session.story_step == 24, "next earned battle uses supplied station forty-eight")
	for trip in 20:
		if failures > 0: return
		if app.game.session.story_step == 25:
			check(void_salvage_completed and app.screen is Station and app.game.session.station_id == destination,
				"salvage result is followed by actual local docking, not a scripted teleport")
			check(app.game.session.credits == credits and app.game.session.stat("jobs") == jobs and emp_ammo() == ammo,
				"Void salvage invents no money, freelance completion or EMP ammunition")
			check(saved_state(app.AUTOSAVE_SLOT) == snapshot(), "docking autosaves the earned remains and protected-cargo flag")
			if not press(app.screen.menu.get_child(0), "Hangar to inspect earned mission cargo"): return
			await frames(3)
			var shop = app.screen.current_panel.get_child(0)
			if not press(item_row(shop.hold_list, app.catalogue.item_name(131)), "inspect actual alien remains"): return
			await frames(3)
			var sell := named_button(shop.detail, app.library.text(137))
			check(sell != null and sell.disabled, "actual Hangar disables selling the earned mission remains")
			await shot("earned_void_protected_cargo")
			await save_checkpoint()
			return
		var next := next_route_station(destination)
		if next < 0: return
		if next == app.game.session.station_id:
			if not press(app.screen.launch_button, "Depart for earned Void salvage mission"): return
			await frames(3)
		elif not await choose_destination(next): return
		if not await fly_to_dock(): return
		await shot("void_route_dock_%d" % app.game.session.station_id)
	check(false, "earned Void salvage finishes within bounded actual trips")

func save_checkpoint() -> void:
	var earned := snapshot()
	var auto_before := saved_state(app.AUTOSAVE_SLOT)
	var station = app.screen
	press(station.menu.get_child(5), "Game Options")
	await frames(2)
	var panel = station.current_panel
	press(named_button(panel.box, app.library.text(2)), "open manual Save menu")
	await frames(2)
	press(panel.box.get_child(0), "manual Save slot 1")
	await frames(2)
	check(saved_state(0) == earned, "manual save persists the earned travel/trade/contract checkpoint")
	check(saved_state(app.AUTOSAVE_SLOT) == auto_before, "manual checkpoint does not overwrite docking autosave")
	var attempts := app.save_attempts.size()
	app.show_title()
	await frames(3)
	app.screen._load()
	await frames(2)
	var box = app.screen.panel_holder.get_child(0).get_child(0)
	press(box.get_child(1), "title reload earned manual slot")
	await frames(4)
	check(app.screen is Station and snapshot() == earned, "title reload restores all earned free-play state")
	check(app.save_attempts.size() == attempts, "reload never repeats a courier reward or writes another checkpoint")
	check(FileAccess.file_exists(app.save_path(0)) and FileAccess.file_exists(app.save_path(app.AUTOSAVE_SLOT)), "earned manual and autosave JSON exist in isolated storage")
	await shot("earned_free_play_reload")

func finish() -> void:
	var result := {"content": app.library.id if app.library != null else "", "checks": checks,
		"failures": failures, "timeline": timeline, "docks": docks, "flight_entries": flight_entries,
		"frames": frame, "player_shots": shots, "focus_resumes": focus_resumes,
		"source": source, "source_sha256": FileAccess.get_sha256(source), "save_root": save_root}
	result.contract = chosen_contract
	result.input_step = input_step
	result.completed_contract = completed_contract
	result.player_hits = player_hits
	result.gate_events = gate_events
	result.travel_events = travel_events
	result.emp_target_disabled = emp_target_disabled
	result.emp_radios_finished = emp_radios_finished
	result.void_salvage_completed = void_salvage_completed
	result.void_salvaged_units = void_salvaged_units
	result.gear_purchases = gear_purchases
	if app.game != null: result.final_session = snapshot()
	# A queued node can otherwise receive one final physics callback while
	# the retained host reference is already null. Stop its inherited flight
	# processing before releasing it; this does not advance the simulation.
	app.process_mode = Node.PROCESS_MODE_DISABLED
	app.queue_free()
	app = null
	await frames(3)
	print("EARNED TRAVEL: %d checks, %d failures" % [checks.size(), failures])
	var file := FileAccess.open(out.path_join("report.json"), FileAccess.WRITE)
	if file != null: file.store_string(JSON.stringify(result, "\t"))
	quit(1 if failures else 0)
