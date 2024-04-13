extends Node2D
class_name GhostSummonerComponent

onready var key_combo_controller = $"%KeyComboController"



var combo_dict = {
	[KEY_LEFT, KEY_UP, KEY_DOWN, KEY_RIGHT]: preload("res://project/GhostSummoning/fake_ghost.tscn")
}


func _on_KeyComboController_combo_completed(combo):
	if combo_dict.has(combo):
		var ghost = combo_dict[combo].instance()
		add_child(ghost)
