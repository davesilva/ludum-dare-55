extends SpookyRoom
class_name StairsRoom

export onready var spawn_point: Vector2 =  Vector2(self.global_position.x, self.global_position.y+34)
export (NodePath) var target_room_path

func _ready():
	._ready()
	GlobalSignals.connect("player_takes_stairs", self, "_on_player_takes_stairs")

func _on_RoomArea2D_body_entered(body):
	._on_RoomArea2D_body_entered(body)
	var other_room = get_node(target_room_path) as Node2D
	if body.is_in_group(Constants.GROUP_PLAYER):
		var player = body as PlayerCharacter
		player.available_action = PlayerCharacter.PlayerActions.CLIMB_STAIRS
		player.stairs_target = other_room
		
func _on_player_takes_stairs(target_room, player):
	if self != target_room:
		return
	player.position = spawn_point
	# NOTE: this is where a fade in animation would go if we did that
		
