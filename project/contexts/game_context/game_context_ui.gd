extends Control
class_name GameContextUI

onready var prompt_label = $BottomContainer/PromptLabel
onready var combo_container = $TopContainer/Control/PanelContainer/VBoxContainer/ComboHBoxContainer

func _ready():
	GlobalSignals.connect("display_keys", self, "_on_display_keys")
	GlobalSignals.connect("display_prompt", self, "_on_display_prompt")
	prompt_label.hide()
	

func _on_display_keys(keys):
	combo_container.add_keys(keys)
	
	
func _on_display_prompt(text: String):
	if text.empty():
		prompt_label.hide()
	else:
		prompt_label.text = text
		prompt_label.show()
