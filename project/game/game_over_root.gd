extends Control
class_name GameOverRoot

onready var score_label = $CenterArea/ScoreLabel


func _on_button_pressed():
	PresentationServices.context_service().handle_transition_request(TitleContext.CONTEXT_ID)
	

func set_score(score: int):
	score_label.text = str(score)
