extends KinematicBody2D
class_name PlayerCharacter

enum PlayerActions {
	NONE,
	SUMMON,
	STUDY, 
	COMMAND
}

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var sprite: Sprite = $Sprite
onready var movement := $Movement as MovementComponent2D
onready var summoning_power := $SummoningPower as GhostSummonerComponent
onready var door_exit = Vector2.ZERO
onready var can_travel = false
onready var available_action = PlayerActions.NONE setget action_setter
onready var current_room


func action_setter(new_value: int):
	available_action = new_value
	
	summoning_power.is_enabled = available_action == PlayerActions.SUMMON
			
	

func _ready():
	movement.target = self
	animation_player.play("idle")
	add_to_group(Constants.GROUP_PLAYER)
	
	
func _process(_delta):
	if Input.is_action_just_pressed("primary_action"):
		if can_travel:
			position = door_exit
			can_travel = false
		elif available_action != PlayerActions.NONE:
			_execute_action()
			

func _execute_action():
	match available_action:
		PlayerActions.SUMMON:
			print("summon")
		PlayerActions.STUDY:
			print("study")
		PlayerActions.COMMAND:
			print("command")


func _on_velocity_changed(velocity):
	if abs(velocity.x) < 1.0:
		animation_player.play("idle")
		return
	if velocity.x > 1.0: 
		sprite.flip_h = false
		animation_player.play("run")
	elif velocity.x < 1.0:
		sprite.flip_h = true
		animation_player.play("run")
