extends Area2D
class_name Ghost

enum STATE {RAGING, CLEANING, IDLE, TRAVELING}

export (int) var mood = 100
export (float) var movement_speed = 1.0
export (float) var chore_speed = 1.0

var selected = true
# PRETEND THIS IS A GHOST_STATE
var state: int = STATE.IDLE

var destination_info: SpookyRoomInfo
var current_location_info: SpookyRoomInfo

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group(Constants.GROUP_GHOST)


func send_to_location(send_destination_info: SpookyRoomInfo):
	if not self.selected:
		return

	self.destination_info = send_destination_info
	var distance = self.position.distance_to(destination_info.global_position)
	var duration = distance / (self.movement_speed * 100)
	state = STATE.TRAVELING
	var tween = create_tween()
	tween.tween_property(self, "position", destination_info.global_position, duration)
	yield(tween,"finished")
	state = STATE.IDLE


func is_happy():
	return self.mood >= 0
	
func is_angry():
	return self.mood < 0

func _on_selected():
	self.selected = true

func _on_unselected():
	self.selected = false
