extends Node2D
class_name CharacterTooltip


onready var combo_h_box_container = $Control/PanelContainer/VBoxContainer/ComboHBoxContainer as ComboHBoxContainer
onready var panel_container = $Control/PanelContainer

func display_text(text: String) -> void:
	combo_h_box_container.add_keys(text.split(""))
#	panel_container.show()
	
	GlobalSignals.emit_signal("display_prompt", text)
	
func clear_text() -> void:
	combo_h_box_container.clear_keys()
	panel_container.hide()
	GlobalSignals.emit_signal("display_prompt", "")
