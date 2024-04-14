extends Node2D
class_name Ghost

export (int) var mood = 100
export (float) var movement_speed = 1
export (float) var chore_speed = 1

var selected = false

var destination
var current_location

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group(Constants.GROUP_GHOST)

func send_to_location(sent_destination):
	var room_destination = sent_destination as Node2D
	if not room_destination:
		return

	if not self.selected:
		return

	self.destination = room_destination
	var distance = self.position.distance_to(room_destination.position)
	var duration = distance / (self.movement_speed * 100)
	print(distance)
	var tween = create_tween()
	tween.tween_property(self, "position", room_destination.position, duration)

func _on_selected():
	self.selected = true

func _on_unselected():
	self.selected = false
