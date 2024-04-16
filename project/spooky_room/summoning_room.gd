extends SpookyRoom
class_name SummoningRoom

export var idle_image: Texture
export var active_image: Texture

func _ready():
	._ready()
	GlobalSignals.connect("summoning_completed", self, "_on_summoning_completed")
	GlobalSignals.connect("summoning_started", self, "_on_summoning_started")
	self.room_info.room_type = SpookyRoomInfo.ROOM_TYPE.SUMMONING

# NOTE: this could take a quality or something
func _on_RoomArea2D_body_entered(body):
	._on_RoomArea2D_body_entered(body)
	if body.is_in_group(Constants.GROUP_PLAYER) and self.present_ghosts.empty():
		var player = body as PlayerCharacter
		if present_ghosts.empty():
			player.enable_summoning()

func _on_GhostActiveArea2D_area_entered(area):
	if area.is_in_group(Constants.GROUP_GHOST):
		if contains_player:
			GlobalSignals.emit_signal("player_disable_summoning")
		var ghost = area as Ghost
		ghost.on_enter_summoning_room()
	._on_GhostActiveArea2D_area_entered(area)

func _on_GhostActiveArea2D_area_exited(area):
	if area.is_in_group(Constants.GROUP_GHOST):
		if contains_player:
			GlobalSignals.emit_signal("player_enable_summoning")
	._on_GhostActiveArea2D_area_exited(area)


func _on_summoning_completed(success: bool, ghost_to_summon):
	if not success:
		return
		
	var ghost = ghost_to_summon.instance()
	get_tree().current_scene.add_child(ghost)
	ghost.global_position = self.global_position
	self.sprite.texture = idle_image

func _on_summoning_started():
	self.sprite.texture = active_image
