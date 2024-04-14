extends Node
class_name LevelHook

signal level_set_up(level)
signal level_start(level)
signal level_play(level)
signal level_end(level)
signal level_clean_up(level)


func on_level_set_up(level):
	emit_signal("level_set_up", level)
	

func on_level_start(level):
	emit_signal("level_start", level)
	

func on_level_play(level):
	emit_signal("level_play", level)
	

func on_level_end(level):
	emit_signal("level_end", level)
	

func on_level_clean_up(level):
	emit_signal("level_clean_up", level)
