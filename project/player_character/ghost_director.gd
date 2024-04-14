extends Node2D

var enabled = true


func _ready() -> void:
	GlobalSignals.connect("room_clicked", self, "_on_room_clicked")
	
func _on_room_clicked(clicked_room: SpookyRoom) -> void:
	for room in get_tree().get_nodes_in_group(Constants.GROUP_ROOM):
		room = room as SpookyRoom
		if room.contains_player:
			for ghost in room.inhabiting_ghosts:
				ghost = ghost as Ghost
				if ghost.state == Ghost.STATE.IDLE:
					ghost.send_to_location(clicked_room.room_info)
