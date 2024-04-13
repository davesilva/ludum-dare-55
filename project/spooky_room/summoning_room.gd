extends SpookyRoom
class_name SummoningRoom

func _on_RoomArea2D_body_entered(body):
	if body.is_in_group("Player"):
		var player = body as PlayerCharacter
		player.available_action = PlayerCharacter.PlayerActions.SUMMON


func _on_RoomArea2D_body_exited(body):
	if body.is_in_group("Player"):
		var player = body as PlayerCharacter
		player.available_action = PlayerCharacter.PlayerActions.NONE
