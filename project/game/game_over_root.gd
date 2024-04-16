extends Control
class_name GameOverRoot


func _on_button_pressed():
	PresentationServices.context_service().handle_transition_request(TitleContext.CONTEXT_ID)
	
