extends KinematicBody2D
class_name PlayerCharacter

enum PlayerActions {
	NONE,
	SUMMON,
	STUDY, 
	COMMAND
}

onready var movement := $Movement as MovementComponent2D
onready var door_exit = Vector2.ZERO
onready var can_travel = false
onready var available_action = PlayerActions.NONE


func _ready():
	movement.target = self
	
	
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
