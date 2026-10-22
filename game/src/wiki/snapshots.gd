extends Control
## Photographs the reference's ships and stations for the web page export:
## each is set up in the showroom the reader uses, off screen, and its
## picture is saved once it has been drawn. Needs a renderer; without one (a
## headless run) nothing is photographed and the export keeps the imported
## pixel art instead.
signal progressed(done: int, total: int)

const ShipPreview := preload("res://src/presentation/ship_preview.gd")
const PICTURE := Vector2i(640, 440)
## Frames a showroom is given to build, frame and draw before its picture is taken.
const SETTLE := 6

static func available() -> bool: return DisplayServer.get_name() != "headless"

## Pages with a ship or a station, and what to set up for each.
static func subjects(catalog) -> Dictionary:
	var found := {}
	for key: String in catalog.ordered:
		var shown: Dictionary = catalog.media(key)
		if shown.has("ship") or shown.has("station"): found[key] = shown
	return found

## Saves directory/images/render-<key>.png for every subject and returns
## {key: path inside the site}.
func render(catalog, directory: String) -> Dictionary:
	var written := {}
	if not available(): return written
	DirAccess.make_dir_recursive_absolute(directory.path_join("images"))
	# Off screen but in the tree, so the showrooms run and draw.
	position = Vector2(-PICTURE.x - 100, 0); size = PICTURE
	var subjects_ := subjects(catalog)
	var done := 0
	for key: String in subjects_:
		var shown: Dictionary = subjects_[key]
		var stage := ShipPreview.new()
		stage.library = catalog.library
		stage.stretch = false
		stage.custom_minimum_size = Vector2(PICTURE); stage.size = Vector2(PICTURE)
		add_child(stage)
		stage.viewport.size = PICTURE
		stage.viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		if shown.has("ship"): stage.show_ship(int(shown.ship), int(shown.get("faction", 0)))
		else: stage.show_station(int(shown.station), int(catalog.cat.system(catalog.cat.system_of_station(int(shown.station))).faction))
		for frame in SETTLE: await get_tree().process_frame
		await RenderingServer.frame_post_draw
		var picture: Image = stage.viewport.get_texture().get_image()
		var path := "images/render-%s.png" % key.replace("/", "-")
		if picture != null and picture.save_png(directory.path_join(path)) == OK: written[key] = path
		remove_child(stage); stage.queue_free()
		done += 1; progressed.emit(done, subjects_.size())
	return written
