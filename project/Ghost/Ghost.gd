extends Node2D
class_name Ghost

export (int) var mood = 100
export (float) var movement_speed = 1
export (float) var chore_speed = 1

var selected = false

var destination: SpookyRoom

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_send_to_location(destination: SpookyRoom):
	if !self.selected:
		return

	self.destination = destination
	var distance = self.position.distance_to(destination.position)
	var duration = distance / (self.movement_speed * 100)

	var tween = create_tween()
	tween.tween_property(self, "position", destination, duration)

func _on_selected():
	self.selected = true

func _on_unselected():
	self.selected = false
