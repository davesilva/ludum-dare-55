extends Node2D
class_name Ghost

export (int) var mood = 100
export (float) var movement_speed = 1
export (float) var chore_speed = 1

var destination: Chamber

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _setup_signals():
	# Connect send_to_location signal
	pass

func _on_send_to_location(destination: SpookyRoom):
	self.destination = destination
	var tween = create_tween()
	tween.tween_property(self, "position", destination, 1)
	tween.connect("finished", self, "_on_arrived_at_location")

func _on_arrived_at_location():
	pass
