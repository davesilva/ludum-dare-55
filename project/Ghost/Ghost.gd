extends Area2D
class_name Ghost

enum STATE {RAGING, CLEANING, IDLE, TRAVELING}

export (int) var mood = 100
export (float) var movement_speed = 1.0
export (float) var chore_speed = 1.0
export (float) var mood_change_per_second = 0.3 #is positive or negative depending on state
export (int) var forced_moves_remaining = 3

onready var run_away_feedback: FeedbackRunner = $RunAwayFeedback
onready var scared_feedback: FeedbackRunner = $ScaredFeedback

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
	
	set_up_floating()
	

func _process(delta):
	_evaluate_states(delta)
	_process_state(delta)
	_update_debug_labels()
	
	
func _evaluate_states(_delta):
	if state != STATE.RAGING and is_angry():
		#set_mood(-10)
		state = STATE.RAGING
		return
	
	if state != STATE.TRAVELING and destination_info != null:
		state = STATE.TRAVELING
		return
		
	match state:
		STATE.IDLE:
			_evaluate_idle()
		STATE.TRAVELING:
			_evaluate_traveling()
		STATE.CLEANING:
			_evaluate_cleaning()
		STATE.RAGING:
			_evaluate_raging()
		

func _evaluate_idle():
	if current_location_info and current_location_info.dirtiness > 0:
		state = STATE.CLEANING
		return
	

func _evaluate_traveling():
	if destination_info == null:
		state = STATE.IDLE
	
		
func _evaluate_cleaning():
	if current_location_info and current_location_info.dirtiness <= 0:
		state = STATE.IDLE
	

func _evaluate_raging():
	if current_location_info and current_location_info.dirtiness > 0:
		state = STATE.RAGING
		return
	
	if is_happy():
		set_mood(10)
		state = STATE.IDLE
		return
		

func _process_state(delta):
	match state:
		STATE.IDLE:
			update_mood(-mood_change_per_second * delta)
		STATE.TRAVELING:
			pass
		STATE.CLEANING:
			update_mood(mood_change_per_second * delta)
		STATE.RAGING:
			update_mood(-mood_change_per_second * delta * 1.2)


func send_to_location(send_destination_info: SpookyRoomInfo, force_send = false):
	if not self.selected or (state == STATE.RAGING and not force_send) or self.destination_info:
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
		
	if force_send:
		forced_moves_remaining -= 1
		scared_feedback.execute_feedbacks()
		yield(scared_feedback, "all_feedbacks_finished")
		
	if not forced_moves_remaining:
		run_away_feedback.execute_feedbacks()
		yield(run_away_feedback, "all_feedbacks_finished")
		var unit_vector = Random.random_unit_vector()
		var new_position = position + (unit_vector * 10000)
		look_at(new_position)
		var tween = create_tween()
		tween.tween_property(self, "position", new_position, 5)
		yield(tween,"finished")
		queue_free()
	else:
		var tween = create_tween()
		tween.tween_property(self, "position", destination_info.global_position, duration)
		yield(tween,"finished")
		self.destination_info = null
		

func is_happy():
	return self.mood >= 0
	
func is_angry():
	return self.mood < 0
	
	
func update_mood(added_value):
	set_mood(mood + added_value)
	
	
func set_mood(mood_value):
	mood = clamp(mood_value, -1000, 100)
	update_sprites_from_mood()
	

func update_sprites_from_mood():
	if mood < 25 and mood >= -40:
		sprite.texture = angry_ghost_images[0]
	elif mood < -40 and mood >= -80:
		sprite.texture = angry_ghost_images[1]
	elif mood < -80:
		sprite.texture = angry_ghost_images[2]
	else:
		sprite.texture = happy_ghost_image
	

func _on_selected():
	self.selected = true

func _on_unselected():
	self.selected = false
	

func set_up_floating():
	$FloatingWaveSequencer.amplitude += Random.randi_range(-1, 4)
	$FloatingWaveSequencer.period += Random.randf_range(0,2)

	
func _on_floating_wave_sequencer_new_value(value):
	sprite.offset.y = value
	
	
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
