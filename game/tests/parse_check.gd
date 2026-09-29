extends SceneTree
func _init() -> void:
	var failed := false
	for p in OS.get_cmdline_user_args():
		var s = load(p)
		var valid: bool = s is Script and s.can_instantiate()
		print(p, " -> ", "OK" if valid else "FAIL")
		failed = failed or not valid
	quit(1 if failed else 0)
