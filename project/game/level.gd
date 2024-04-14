extends Node2D
class_name Level

func set_up():
	var level_hooks = _get_all_level_hooks()
	for hook in level_hooks:
		if hook is LevelHook:
			hook.on_level_set_up(self)
	

func start():
	var level_hooks = _get_all_level_hooks()
	for hook in level_hooks:
		if hook is LevelHook:
			hook.on_level_start(self)
	

func play():
	var level_hooks = _get_all_level_hooks()
	for hook in level_hooks:
		if hook is LevelHook:
			hook.on_level_play(self)
	

func end():
	var level_hooks = _get_all_level_hooks()
	for hook in level_hooks:
		if hook is LevelHook:
			hook.on_level_end(self)
	

func clean_up():
	var level_hooks = _get_all_level_hooks()
	for hook in level_hooks:
		if hook is LevelHook:
			hook.on_level_clean_up(self)


func _get_all_level_hooks() -> Array:
	var level_hook_nodes: Array = []
	var all_children: Array = TreeTools.get_all_children(self)
	
	for node in all_children:
		if node is LevelHook:
			level_hook_nodes.append(node)
	
	return level_hook_nodes
