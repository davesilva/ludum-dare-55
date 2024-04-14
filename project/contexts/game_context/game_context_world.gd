extends Node2D
class_name GameContextWorld

export (PackedScene) var initial_level

onready var level_root = $LevelRoot

func _ready():
	var initial_level_instance = initial_level.instance()
	level_root.add_child(initial_level_instance)
