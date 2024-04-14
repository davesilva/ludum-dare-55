extends Area2D
class_name Ghost

enum STATE {RAGING, CLEANING, IDLE, TRAVELING}

export (int) var mood = 100 setget _mood_set
export (float) var movement_speed = 1.0
export (float) var chore_speed = 1.0
export (float) var mood_change_per_second = 0.3 #is positive or negative depending on state

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
	

func _process(delta):
	_evaluate_states(delta)
	_process_state(delta)
	_update_debug_labels()
	
	
func _evaluate_states(_delta):
	if state == STATE.RAGING and is_happy():
		mood = 10 #give it some padding
		state = STATE.IDLE
		return
		
	if state != STATE.RAGING and is_angry():
		mood = -10 # give it some padding
		state = STATE.RAGING
		return
		
	if state != STATE.TRAVELING and self.destination_info != null:
		state = STATE.TRAVELING
		return
		
	if state == STATE.TRAVELING and self.destination_info == null:
		state = STATE.IDLE
		return
		
	if current_location_info and current_location_info.dirtiness > 0:
		state = STATE.CLEANING
		return
		
	if current_location_info and current_location_info.dirtiness <= 0:
		state = STATE.IDLE
		return
		

func _process_state(delta):
	match state:
		STATE.IDLE:
			mood -= mood_change_per_second * delta
		STATE.TRAVELING:
			pass
		STATE.CLEANING:
			mood += mood_change_per_second * delta
			mood = clamp(mood, 0, 100)
		STATE.RAGING:
			mood -= mood_change_per_second * delta * 1.2


func send_to_location(send_destination_info: SpookyRoomInfo):
	if not self.selected:
		return

	self.destination_info = send_destination_info
	var distance = self.position.distance_to(destination_info.global_position)
	var duration = distance / (self.movement_speed * 100)
	
	var scale_tween = create_tween()

	if send_destination_info.global_position.x > self.global_position.x:
		#sprite.scale.x = -1
		scale_tween.tween_property(self, "scale", Vector2(-1,1), .2)
	else:
		#sprite.scale.x = 1
		scale_tween.tween_property(self, "scale", Vector2(1,1), .2)

	var tween = create_tween()
	tween.tween_property(self, "position", destination_info.global_position, duration)
	yield(tween,"finished")
	self.destination_info = null


func is_happy():
	return self.mood >= 0
	
func is_angry():
	return self.mood < 0

func _mood_set(new_mood):
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
	
	
###############
#### DEBUG ####
###############
onready var state_debug_label = $Debug/ColorRect/StateDebugLabel
onready var mood_debug_label = $Debug/ColorRect2/MoodDebugLabel

func _update_debug_labels():
	state_debug_label.text = _string_for_state(state)
	var rounded_mood = stepify(mood, 0.1)
	mood_debug_label.text = str(rounded_mood)
	

func _string_for_state(given_state: int) -> String:
	match given_state:
		STATE.IDLE:
			return "IDLE"
		STATE.TRAVELING:
			return "TRAVEL"
		STATE.CLEANING:
			return "CLEAN"
		STATE.RAGING:
			return "ANGRY"
			
	return "UNKNOWN"
