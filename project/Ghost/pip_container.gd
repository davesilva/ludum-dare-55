extends Control
class_name PipContainer

onready var pip_container = $HBoxContainer

func display_pips(amount: int):
	var pips = pip_container.get_children()
	for index in 3:
		if amount > index:
			pips[index].visible = true
		else:
			pips[index].visible = false
