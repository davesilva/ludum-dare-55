extends KinematicBody2D
class_name PlayerCharacter

onready var movement := $Movement as MovementComponent2D
onready var door_exit = Vector2.ZERO
onready var can_travel = false


func _ready():
	movement.target = self
	
func _process(delta):
	if Input.is_action_just_pressed("door_travel") and can_travel:
		position = door_exit
		can_travel = false
