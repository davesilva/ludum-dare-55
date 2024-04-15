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
			var any_happy_ghosts = false
			for g in clicked_room.present_ghosts:
				if g.mood >= 0:
					any_happy_ghosts = true
					continue
			if not any_happy_ghosts:
				for ghost in room.present_ghosts:
					ghost = ghost as Ghost
					if ghost.state == Ghost.STATE.IDLE or ghost.state == Ghost.STATE.CLEANING:
						ghost.send_to_location(clicked_room.room_info)
						ghost.mood = 50
			else:
				#This is where you would play a "NO GOOD" sound
				pass
