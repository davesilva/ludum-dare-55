extends Area2D
class_name Ghost

enum STATE {RAGING, CLEANING, IDLE, TRAVELING}

export (int) var mood = 100 setget mood_set
export (float) var movement_speed = 1.0
export (float) var chore_speed = 1.0

var selected = true
# PRETEND THIS IS A GHOST_STATE
var state: int = STATE.IDLE

var destination_info: SpookyRoomInfo
var current_location_info: SpookyRoomInfo

var happy_ghost_image
var angry_ghost_images

onready var sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	add_to_group(Constants.GROUP_GHOST)
	var happy_ghost_images = [
		preload("res://project/Ghost/art/ghost_butler.png"),
		preload("res://project/Ghost/art/Ghost_happy.png"),
		preload("res://project/Ghost/art/ghost_maid.png"),
		preload("res://project/Ghost/art/ghost_mop.png")
	]
	self.angry_ghost_images = [
		preload("res://project/Ghost/art/ghost_mad1.png"),
		preload("res://project/Ghost/art/ghost_mad2.png"),
		preload("res://project/Ghost/art/ghost_mad3-EVIL.png")
	]
	self.happy_ghost_image = happy_ghost_images[randi() % 4]
	sprite.texture = happy_ghost_image


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

func mood_set(new_mood):
	if new_mood < 25 and new_mood >= -40:
		sprite.texture = angry_ghost_images[0]
	elif new_mood < -40 and new_mood >= -80:
		sprite.texture = angry_ghost_images[1]
	elif new_mood < -80:
		sprite.texture = angry_ghost_images[2]
	else:
		sprite.texture = happy_ghost_image
	

func _on_selected():
	self.selected = true

func _on_unselected():
	self.selected = false
