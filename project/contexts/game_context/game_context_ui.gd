extends Control
class_name GameContextUI

onready var prompt_label = $BottomContainer/PromptLabel
onready var combo_container = $TopContainer/Control/PanelContainer/VBoxContainer/ComboHBoxContainer
onready var score_label = $ScoreContainer/ScoreLabel
onready var game_over_root = $GameOverRoot

func _ready():
	GlobalSignals.connect("game_start", self, "_on_game_start")
	GlobalSignals.connect("game_end", self, "_on_game_end")
	GlobalSignals.connect("game_restart", self, "_on_game_restart")
	
	GlobalSignals.connect("display_keys", self, "_on_display_keys")
	GlobalSignals.connect("display_prompt", self, "_on_display_prompt")
	GlobalSignals.connect("score_updated", self, "_on_score_update")
	prompt_label.hide()
	hide_game_over()
	
	
func _on_game_start():
	hide_game_over()
	

func _on_game_end():
	show_game_over()
	

func _on_game_restart():
	_on_game_start()
	
func _on_display_keys(keys):
	combo_container.add_keys(keys)
	
	
func _on_display_prompt(text: String):
	if text.empty():
		prompt_label.hide()
	else:
		prompt_label.text = text
		prompt_label.show()


func _on_score_update(score: int):
	score_label.text = "Score: " + str(score)


func show_game_over():
	game_over_root.show()
	
	
func hide_game_over():
	game_over_root.hide()
