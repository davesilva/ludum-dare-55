extends Node2D
#class_name TestDoor

export (NodePath) var other_door_path

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Area2D_body_entered(body):
	if body.is_in_group(Constants.GROUP_PLAYER):
		var other_door = get_node(other_door_path) as Node2D
		
		print(str(other_door.position))
		
		var player = body as PlayerCharacter
		player.door_exit = other_door.position
		player.can_travel = true


func _on_Area2D_body_exited(body):
	if body.is_in_group(Constants.GROUP_PLAYER):
		var player = body as PlayerCharacter
		player.door_exit = Vector2.ZERO
		player.can_travel = false
		
