extends SceneTree
func _init() -> void:
	for p in OS.get_cmdline_user_args():
		var s = load(p)
		print(p, " -> ", "OK" if s != null and s.can_instantiate() else "FAIL")
	quit()
