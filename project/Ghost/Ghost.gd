extends Node2D
class_name Ghost

export (int) var mood = 100
export (float) var movement_speed = 1.0
export (float) var chore_speed = 1.0

var selected = false

var destination
var current_location

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group(Constants.GROUP_GHOST)

func _on_send_to_location(send_destination):
	if !self.selected:
		return

	self.destination = send_destination
	var distance = self.position.distance_to(send_destination.position)
	var duration = distance / (self.movement_speed * 100)
	print(distance)
	var tween = create_tween()
	tween.tween_property(self, "position", send_destination, duration)

func _on_selected():
	self.selected = true

func _on_unselected():
	self.selected = false
