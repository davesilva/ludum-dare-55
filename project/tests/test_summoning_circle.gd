extends Node2D
class_name SummoningCircle


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		var player = body as PlayerCharacter
		player.available_action = PlayerCharacter.PlayerActions.SUMMON
		player.can_travel = false


func _on_Area2D_body_exited(body):	
	if body.is_in_group("Player"):
		var player = body as PlayerCharacter
		player.available_action = PlayerCharacter.PlayerActions.NONE
