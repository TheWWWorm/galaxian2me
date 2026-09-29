extends HBoxContainer
## The Space Lounge: the people in this station's bar with their portraits;
## talking to one shows what they say and offer, and the offer can be taken.

const UI := preload("res://src/presentation/ui.gd")
const Common := preload("res://src/screens/station/common.gd")
const Portrait := preload("res://src/presentation/portrait.gd")
const Lounge := preload("res://src/simulation/lounge.gd")

var station
var app
var game
var list: VBoxContainer
var detail: VBoxContainer
var selected := -1

func _ready() -> void:
	app = station.app
	game = station.game
	add_theme_constant_override("separation", 10)
	var left := UI.Frame.new(app.library.text(218))
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(left)
	var l := Common.scroll_list()
	left.add_child(l[0])
	list = l[1]
	var info := UI.Frame.new(app.library.text(212))
	info.custom_minimum_size.x = 420
	add_child(info)
	var s := Common.scroll_list()
	info.add_child(s[0])
	detail = s[1]
	app.play_music("gof2_bar")
	_fill()

func _exit_tree() -> void:
	app.play_music("gof2_hangar")

func _fill() -> void:
	var keep_list := Common.focus_index(list)
	for c in list.get_children(): c.queue_free()
	Common.refocus(list, keep_list)
	var people: Array = game.lounge()
	for i in people.size():
		var p: Dictionary = people[i]
		var face := Portrait.make(app.library, -1, p.get("face", []), 0.75)
		var row := Common.row(face, "%s — %s" % [p.name, app.catalogue.faction_name(int(p.race))], game.bar.offer_label(p), _talk.bind(i))
		row.focus_entered.connect(_preview.bind(i))
		list.add_child(row)
	if selected >= 0: _talk(selected)
	elif detail.get_child_count() == 0:
		detail.add_child(UI.paragraph("Choose someone to talk to." if not people.is_empty() else "Nobody is here right now.", 14, UI.TEXT_DIM))

## Moving the keyboard or pad focus over someone, before talking to anyone,
## shows who they are; it is not a conversation.
func _preview(i: int) -> void:
	if selected >= 0: return
	var people: Array = game.lounge()
	if i >= people.size(): return
	var p: Dictionary = people[i]
	var keep_detail := Common.focus_index(detail)
	for c in detail.get_children(): c.queue_free()
	Common.refocus(detail, keep_detail)
	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 12)
	head.add_child(Portrait.make(app.library, -1, p.get("face", []), 2.0))
	var names := VBoxContainer.new()
	names.add_child(UI.label(str(p.name), 18))
	names.add_child(UI.label(app.catalogue.faction_name(int(p.race)), 14, UI.TEXT_DIM))
	var offer: String = game.bar.offer_label(p)
	if not offer.is_empty(): names.add_child(UI.label(offer, 14, UI.TEXT_GOOD))
	head.add_child(names)
	detail.add_child(head)
	detail.add_child(UI.paragraph("Choose someone to talk to.", 14, UI.TEXT_DIM))

func _talk(i: int) -> void:
	selected = i
	var keep_detail := Common.focus_index(detail)
	for c in detail.get_children(): c.queue_free()
	Common.refocus(detail, keep_detail)
	var people: Array = game.lounge()
	if i >= people.size(): return
	var p: Dictionary = people[i]
	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 12)
	head.add_child(Portrait.make(app.library, -1, p.get("face", []), 2.0))
	var names := VBoxContainer.new()
	names.add_child(UI.label(str(p.name), 18))
	names.add_child(UI.label(app.catalogue.faction_name(int(p.race)), 14, UI.TEXT_DIM))
	head.add_child(names)
	detail.add_child(head)
	var text := UI.paragraph(str(p.get("speech", "")), 15)
	text.custom_minimum_size.x = 380
	detail.add_child(text)
	var kind := int(p.kind)
	var has_offer: bool = kind != Lounge.Kind.TALK and (kind != Lounge.Kind.JOB or p.has("job")) and (kind != Lounge.Kind.BUYER or p.has("job"))
	if not bool(p.get("talked", false)):
		p["talked"] = true
		if has_offer: game.session.add_stat("bar_talks")
	if not has_offer: return
	var lib = app.library
	var answers := VBoxContainer.new()
	answers.add_theme_constant_override("separation", 4)
	detail.add_child(answers)
	var reply := UI.paragraph("", 15, UI.TEXT_GOOD)
	reply.custom_minimum_size.x = 380
	# The original's answers: OK, No thanks, How was that again?, then
	# questions about a job elsewhere or a look at the goods on offer.
	answers.add_child(UI.button(lib.text(495), func():
		var err: String = game.accept_job(i)
		if not err.is_empty(): station.notify(err)
		station._refresh()
		_fill()))
	answers.add_child(UI.button(lib.text(496), func():
		game.session.add_stat("rejected")
		for c in detail.get_children(): c.queue_free()
		detail.add_child(UI.paragraph(lib.text(479 + randi() % 4), 15))
		# The answers are gone: the highlight returns to the guest.
		Common.refocus(list, i)))
	answers.add_child(UI.button(lib.text(497), func():
		game.session.add_stat("asked_repeat")
		reply.text = str(p.get("speech", ""))))
	var job: Dictionary = p.get("job", {})
	if kind == Lounge.Kind.JOB and not job.is_empty() and int(job.get("station", -1)) != game.session.station_id:
		answers.add_child(UI.button(lib.text(440), func():
			p["asked_location"] = true
			var target := int(job.station)
			reply.text = "%s — %s" % [app.catalogue.station_name(target), app.catalogue.system_name(app.catalogue.system_of_station(target))]))
		answers.add_child(UI.button(lib.text(442), func():
			p["asked_difficulty"] = true
			reply.text = lib.text(443 + clampi(int(float(job.get("difficulty", 0)) / 10.0 * 5.0), 0, 4))))
	elif kind == Lounge.Kind.JOB and not job.is_empty():
		answers.add_child(UI.button(lib.text(440), func(): reply.text = lib.text(441)))
	if kind in [Lounge.Kind.SELLER, Lounge.Kind.ITEM_AGENT, Lounge.Kind.BLUEPRINT_AGENT]:
		var shown := int(p.get("blueprint", p.get("item", -1)))
		if shown >= 0:
			answers.add_child(UI.button(lib.text(415), func():
				var cat = app.catalogue
				var lines: Array = ["%s · %s %d" % [cat.item_name(shown), lib.text(37), cat.tech(shown)]]
				for f in Common.item_facts(lib, cat, shown): lines.append("%s: %s" % [f[0], f[1]])
				reply.text = "\n".join(lines)))
	detail.add_child(reply)
