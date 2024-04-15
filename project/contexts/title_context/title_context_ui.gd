extends Control
class_name TitleContextUI

signal request_context_change(context_id)

func _on_start_pressed():
	emit_signal("request_context_change", GameContext.CONTEXT_ID)


func _on_start_mouse_entered():
	$StartButton.rect_scale = Vector2(1.2, 1.2)


func _on_start_mouse_exited():
	$StartButton.rect_scale = Vector2(1.0, 1.0)
