extends SpookyRoom
class_name SummoningRoom

func _ready():
	GlobalSignals.connect("summoning_completed", self, "_on_summoning_completed")
	._ready()

# NOTE: this could take a quality or something
func _on_RoomArea2D_body_entered(body):
	if body.is_in_group(Constants.GROUP_PLAYER):
		var player = body as PlayerCharacter
		player.available_action = PlayerCharacter.PlayerActions.SUMMON
	._on_RoomArea2D_body_entered(body)


func _on_RoomArea2D_body_exited(body):
	if body.is_in_group(Constants.GROUP_PLAYER):
		var player = body as PlayerCharacter
		player.available_action = PlayerCharacter.PlayerActions.NONE
	._on_RoomArea2D_body_exited(body)


func _on_summoning_completed(ghost_to_summon):
	$Poof.play()
	var ghost = ghost_to_summon.instance()
	get_tree().current_scene.add_child(ghost)
	ghost.global_position = self.global_position
