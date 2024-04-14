extends Node2D
class_name GhostSummonerComponent

export (bool) var is_enabled = false setget _update_enabled

onready var key_combo_controller = $"%KeyComboController"

var base_ghost = preload("res://project/Ghost/Ghost.tscn")

var combo_dict = {
	[KEY_LEFT, KEY_UP, KEY_DOWN, KEY_RIGHT]: base_ghost
}

func _update_enabled(new_value: bool):
	is_enabled = new_value
	key_combo_controller.comboing_enabled = new_value
	if not new_value:
		key_combo_controller.end_combo(true)


func _on_KeyComboController_combo_completed(combo):
	if not is_enabled:
		return
	GlobalSignals.emit_signal("summoning_completed", base_ghost)
