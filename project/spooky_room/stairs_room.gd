extends SpookyRoom
class_name StairsRoom

signal stairs_glow
signal stairs_unglow

export onready var spawn_point: Vector2 =  Vector2(self.global_position.x, self.global_position.y+34)
export (NodePath) var target_room_path

onready var white_flash = $WhiteFlash

func _ready():
	._ready()
	GlobalSignals.connect("player_takes_stairs", self, "_on_player_takes_stairs")
	var other_room = get_node(target_room_path) as StairsRoom
	other_room.connect("stairs_glow", self, "_on_stairs_glow")
	other_room.connect("stairs_unglow", self, "_on_stairs_unglow")

func _on_RoomArea2D_body_entered(body):
	._on_RoomArea2D_body_entered(body)
	var other_room = get_node(target_room_path) as Node2D
	if body.is_in_group(Constants.GROUP_PLAYER):
		var player = body as PlayerCharacter
		player.available_action = PlayerCharacter.PlayerActions.CLIMB_STAIRS
		player.stairs_target = other_room
		emit_signal("stairs_glow")

func _on_RoomArea2D_body_exited(body):
	._on_RoomArea2D_body_exited(body)
	var other_room = get_node(target_room_path) as Node2D
	if body.is_in_group(Constants.GROUP_PLAYER):
		emit_signal("stairs_unglow")

func _on_player_takes_stairs(target_room, player):
	if self != target_room:
		return
	player.position = spawn_point
	# NOTE: this is where a fade in animation would go if we did that
		

func _on_stairs_glow():
	create_tween().tween_property(white_flash, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.25)

func _on_stairs_unglow():
	create_tween().tween_property(white_flash, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.25)
