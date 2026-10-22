extends SceneTree
## Headless: godot --headless --path game -s res://tests/wiki_check.gd -- CONTENT_ID [--step=N] [--dump=DIR]
## Builds the reference of an imported game in every interface language and
## checks each page: it parses, every wiki:// link and prose token resolves,
## no title is empty, and a save's step limit keeps later steps out. --dump
## writes entries-<code>.txt and pages-<code>.txt for reading.
const Library := preload("res://src/content/library.gd")
const Catalog := preload("res://src/wiki/catalog.gd")
const WikiHtml := preload("res://src/wiki/html.gd")
const WikiProse := preload("res://src/wiki/prose.gd")
const EngineLanguage := preload("res://src/presentation/engine_language.gd")

var failures := 0

func fail(message: String) -> void:
	failures += 1
	if failures <= 40: printerr("FAIL ", message)

func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var id := ""
	var step := -1
	var dump := ""
	for arg in args:
		if arg.begins_with("--step="): step = arg.trim_prefix("--step=").to_int()
		elif arg.begins_with("--dump="): dump = arg.trim_prefix("--dump=")
		else: id = arg
	if id.is_empty() and not Library.installed().is_empty(): id = str(Library.installed()[0])
	var lib := Library.new()
	if not lib.open(id):
		printerr("No imported content ", id); quit(2); return
	var started := Time.get_ticks_msec()
	var languages: Array = ["en"] if not dump.is_empty() else EngineLanguage.codes()
	for code: String in languages:
		check(Catalog.new(lib, step, code), dump)
	# A save early in the story sees no later step, nor anyone met later.
	var early := Catalog.new(lib, 3, "en")
	for key: String in early.ordered:
		if key.begins_with("step/") and int(key.get_slice("/", 1)) > 3: fail("step limit leaks " + key)
		if key == "character/6": fail("step limit leaks a later character")
		if "wiki://step/4" in early.page(key) or "wiki://step/1" + "0" in early.page(key): fail("step limit leaks a link on " + key)
	var full := Catalog.new(lib, -1, "en")
	print("wiki_check: %d pages, %d languages, %d ms, %d failures" % [full.ordered.size(), languages.size(), Time.get_ticks_msec() - started, failures])
	quit(1 if failures > 0 else 0)

func check(catalog: Catalog, dump: String) -> void:
	var listing := PackedStringArray()
	var pages := PackedStringArray()
	for key: String in catalog.ordered:
		var entry: Dictionary = catalog.entries[key]
		if str(entry.title).strip_edges().is_empty(): fail("%s %s has no title" % [catalog.language, key])
		var html := catalog.page(key)
		if html.is_empty(): fail("%s %s is empty" % [catalog.language, key])
		var parser := XMLParser.new()
		if parser.open_buffer(("<div>" + html + "</div>").to_utf8_buffer()) != OK: fail("%s %s does not open" % [catalog.language, key])
		while true:
			var result := parser.read()
			if result == ERR_FILE_EOF: break
			if result != OK: fail("%s %s is not well formed" % [catalog.language, key]); break
		for target in WikiHtml.links(html):
			if not catalog.entries.has(target): fail("%s %s links to missing %s" % [catalog.language, key, target])
		if WikiHtml.to_bbcode(html, Color.WHITE, Color.GRAY).is_empty(): fail("%s %s has no rich text" % [catalog.language, key])
		listing.append("%s\t%s\t%s\t%s" % [key, entry.category, entry.title, entry.subtitle])
		pages.append("=== %s\n%s" % [key, html])
	# Every prose token names a page the full reference has.
	if catalog.complete():
		for key: String in catalog.prose.blocks:
			for block: Array in catalog.prose.blocks[key]:
				for found in WikiProse.pattern().search_all(str(block[2])):
					if not catalog.entries.has(found.get_string(1)): fail("%s prose %s names missing %s" % [catalog.language, key, found.get_string(1)])
	if not dump.is_empty():
		DirAccess.make_dir_recursive_absolute(dump)
		FileAccess.open(dump.path_join("entries-%s.txt" % catalog.language), FileAccess.WRITE).store_string("\n".join(listing) + "\n")
		FileAccess.open(dump.path_join("pages-%s.txt" % catalog.language), FileAccess.WRITE).store_string("\n".join(pages) + "\n")
