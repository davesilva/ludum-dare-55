extends Node2D
class_name GhostSummonerComponent

export (bool) var is_enabled = false setget _update_enabled

onready var key_combo_controller = $"%KeyComboController"


var combo_dict = {
	[KEY_LEFT, KEY_UP, KEY_DOWN, KEY_RIGHT]: preload("res://project/Ghost/Ghost.tscn")
}

func _update_enabled(new_value: bool):
	is_enabled = new_value
	key_combo_controller.comboing_enabled = new_value
	if not new_value:
		key_combo_controller.end_combo(true)


func _on_KeyComboController_combo_completed(combo):

	if not is_enabled:
		return
		print("hello")
	if combo_dict.has(combo):
		var ghost = combo_dict[combo].instance()
		get_tree().current_scene.add_child(ghost)
		ghost.global_position = self.global_position
