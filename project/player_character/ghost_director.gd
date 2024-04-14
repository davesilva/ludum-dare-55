extends Node2D

var enabled = true
var ghost: Ghost


func _ready() -> void:
	GlobalSignals.connect("room_clicked", self, "_on_room_clicked")
	
func _on_room_clicked(room: SpookyRoom) -> void:
	if enabled and ghost:
		ghost.send_to_location(room.room_info)
