extends Node2D
class_name GhostDirector

var enabled = true


func _ready() -> void:
	GlobalSignals.connect("room_clicked", self, "_on_room_clicked")
	
func _on_room_clicked(clicked_room: SpookyRoom) -> void:
	for room in get_tree().get_nodes_in_group(Constants.GROUP_ROOM):
		room = room as SpookyRoom
		if room.contains_player:
			if not clicked_room.roomHasTask:
				return
			if clicked_room.present_ghosts.empty():
				for ghost in room.present_ghosts:
					ghost = ghost as Ghost
					if ghost.is_angry():
						continue
					if ghost.state == Ghost.STATE.IDLE or ghost.state == Ghost.STATE.CLEANING or ghost.state == Ghost.STATE.PACIFIED:
						ghost.set_mood(50)
						ghost.send_to_location(clicked_room.room_info)
			else:
				#This is where you would play a "NO GOOD" sound
				pass
