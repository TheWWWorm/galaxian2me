extends RefCounted
## The reference's own writing: overviews, guides, story synopses and
## descriptions, kept per language in src/wiki/prose/<code>.gd. Imported
## names never appear in it; a [[key]] token stands for the page's title in the
## player's game, and [[key|words]] links the given words instead.
##
## Every block names the story step a player must have reached to read it, so
## a synopsis or biography grows with the save and never runs ahead of it.
## A language without its own text for a page falls back to English.

## Pages of their own: key -> {title, subtitle, category, from}. A story
## step's entry gives only its title.
var pages := {}
## Key -> blocks; a block is [from, heading, text, list item].
var blocks := {}

static func path(code: String) -> String: return "res://src/wiki/prose/%s.gd" % code

static func source(code: String):
	return load(path(code)) if ResourceLoader.exists(path(code)) else null

func _init(code := "en") -> void:
	var english = source("en")
	if english != null:
		pages = english.PAGES.duplicate(true); blocks = english.BLOCKS.duplicate(true)
	if code == "en": return
	var local = source(code)
	if local == null: return
	for key: String in local.PAGES:
		if pages.has(key):
			for field in ["title", "subtitle"]:
				if not str(local.PAGES[key].get(field, "")).is_empty(): pages[key][field] = local.PAGES[key][field]
	for key: String in local.BLOCKS: blocks[key] = local.BLOCKS[key]

## The blocks of a page a save at the given step may read.
func visible(key: String, limit: int) -> Array:
	return blocks.get(key, []).filter(func(block: Array): return int(block[0]) <= limit)

static var _pattern: RegEx
## [[key]] or [[key|words]]: group 1 the key, group 2 the words.
static func pattern() -> RegEx:
	if _pattern == null: _pattern = RegEx.create_from_string("\\[\\[([a-z]+(?:/[a-z0-9]+)?)(?:\\|([^\\]]*))?\\]\\]")
	return _pattern
