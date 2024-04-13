extends Control
class_name TitleContextUI

signal request_context_change(context_id)

func _on_start_pressed():
	emit_signal("request_context_change", GameContext.CONTEXT_ID)
