extends KinematicBody2D
class_name PlayerCharacter

enum PlayerActions {
	NONE,
	SUMMON,
	STUDY, 
	COMMAND,
	CLIMB_STAIRS
}

#We don't currently care about movement or not, stairs or not, etc
enum PlayerState {
	NORMAL,
	SUMMONING
}

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var sprite: Sprite = $Sprite
onready var movement := $Movement as MovementComponent2D
onready var summoning_power := $SummoningPower as GhostSummonerComponent
onready var available_action = PlayerActions.NONE setget action_setter
onready var current_room_info = SpookyRoomInfo setget _set_room_info
onready var ghost_director = $GhostDirector
onready var stairs_target = null setget _on_stairs_target_set
onready var character_tooltip = $CharacterTooltip as CharacterTooltip
onready var collision_shape_2d = $CollisionShape2D
onready var state = PlayerState.NORMAL

func action_setter(new_value: int):
	available_action = new_value
	if available_action == PlayerActions.SUMMON:
		character_tooltip.display_text(Constants.SUMMON_TOOLTIP)
	else:
		character_tooltip.clear_text()


func _set_room_info(room_info: SpookyRoomInfo):
	if not room_info.is_connected("can_command_ghost", self, "_on_command_status_changed"):
		room_info.connect("can_command_ghost", self, "_on_command_status_changed")


func _ready():
	movement.target = self
	animation_player.play("idle")
	GlobalSignals.connect("player_enable_summoning", self, "enable_summoning")
	GlobalSignals.connect("player_disable_summoning", self, "disable_summoning")
	add_to_group(Constants.GROUP_PLAYER)

	
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		match available_action:
			PlayerActions.CLIMB_STAIRS:
				GlobalSignals.emit_signal("player_takes_stairs", self.stairs_target, self)
			PlayerActions.SUMMON:
				if self.state != PlayerState.SUMMONING:
					start_summoning()
				else:
					cancel_summoning()
			PlayerActions.STUDY:
				print("study")
			PlayerActions.COMMAND:
				print("command")
	elif Input.is_action_just_pressed("primary_action"):
			match available_action:
				PlayerActions.CLIMB_STAIRS:
					GlobalSignals.emit_signal("player_takes_stairs", self.stairs_target, self)
	elif Input.is_action_just_released("standard_move_left") or Input.is_action_just_released("standard_move_right"):
		if state == PlayerState.NORMAL:
			movement.is_enabled = true


func _on_velocity_changed(velocity):
	if abs(velocity.x) < 1.0:
		animation_player.play("idle")
		return
	if velocity.x > 1.0: 
		sprite.flip_h = false
		collision_shape_2d.position.x = 20
		animation_player.play("run")
	elif velocity.x < 1.0:
		sprite.flip_h = true
		collision_shape_2d.position.x = -40
		animation_player.play("run")

func cancel_summoning():
	character_tooltip.display_text(Constants.SUMMON_TOOLTIP)
	animation_player.play("idle")
	sprite.offset.y = 0
	summoning_power.is_enabled = false
	state = PlayerState.NORMAL
	if not (Input.is_action_pressed("standard_move_left") or Input.is_action_pressed("standard_move_right")):
		movement.is_enabled = true
	GlobalSignals.emit_signal("summoning_completed", false, null)

func disable_summoning():
	# This shouldn't be necessary
	cancel_summoning()
	character_tooltip.clear_text()
	available_action = PlayerActions.NONE

func enable_summoning():
	character_tooltip.display_text(Constants.SUMMON_TOOLTIP)
	available_action = PlayerActions.SUMMON

func start_summoning():
	character_tooltip.clear_text()
	animation_player.play("summon")
	sprite.offset.y = -12
	self.state = PlayerState.SUMMONING
	summoning_power.is_enabled = true
	movement.is_enabled = false
	GlobalSignals.emit_signal("summoning_started")
	
	
func _on_command_status_changed(can_command: bool):
	if can_command:
		character_tooltip.display_text(Constants.COMMAND_TOOLTIP)
	else:
		character_tooltip.clear_text()
	

func _on_stairs_target_set(value):
	stairs_target = value
	if value:
		character_tooltip.display_text(Constants.STAIRS_TOOLTIP)
	else:
		character_tooltip.clear_text()
		
func play_footsteps_in_the_dark():
	var footstep = [
		$FootstepA,
		$FootstepB,
		$FootstepC,
		$FootstepD
	][randi() % 4].play()
