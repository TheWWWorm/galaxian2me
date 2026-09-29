extends RefCounted
## Margins that keep the interface clear of a phone's notch, camera cutout
## and rounded corners. The 3D view still fills the screen; only panels,
## menus and touch controls move in. A phone held in landscape can be turned
## either way round, so both sides take the larger inset and stay centred.

## Wider than any tablet (4:3 to 16:10) and than a 16:9 screen.
const PHONE_ASPECT := 1.85
## Share of the width kept clear on a wide phone even when the platform
## reports no cutout (browsers without a safe-area inset do not).
const PHONE_SIDE := 0.045

## Set by checks to stand in for a device's cutout: fractions of the window
## {"left", "right", "top", "bottom"}.
static var forced := {}

## The platform's cutout, as fractions of the window.
static func insets() -> Dictionary:
	if not forced.is_empty(): return forced
	var none := {"left": 0.0, "right": 0.0, "top": 0.0, "bottom": 0.0}
	if not OS.has_feature("mobile"): return none
	var area := DisplayServer.get_display_safe_area()
	var screen := DisplayServer.screen_get_size()
	if area.size.x <= 0 or area.size.y <= 0 or screen.x <= 0 or screen.y <= 0: return none
	return {"left": maxf(0.0, area.position.x) / screen.x, "right": maxf(0.0, screen.x - area.end.x) / screen.x,
		"top": maxf(0.0, area.position.y) / screen.y, "bottom": maxf(0.0, screen.y - area.end.y) / screen.y}

## Margins in interface units for an interface of `ui_size`: "side" (both
## left and right), "top" and "bottom". `touch` adds the wide-phone side
## margin where nothing is reported.
static func margins(ui_size: Vector2, touch: bool) -> Dictionary:
	var i := insets()
	var side: float = maxf(float(i.left), float(i.right))
	if touch and ui_size.y > 0.0 and ui_size.x / ui_size.y >= PHONE_ASPECT: side = maxf(side, PHONE_SIDE)
	return {"side": roundf(clampf(side, 0.0, 0.15) * ui_size.x),
		"top": roundf(clampf(float(i.top), 0.0, 0.12) * ui_size.y),
		"bottom": roundf(clampf(float(i.bottom), 0.0, 0.08) * ui_size.y)}
