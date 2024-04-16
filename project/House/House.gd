extends Node2D

onready var ghost_spawn_timer = $GhostSpawnTimer
var ghost_scene: PackedScene

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$BG.play()
	ghost_spawn_timer.connect("timeout", self, "_on_spawn_ghost")
	ghost_scene = preload("res://project/Ghost/Ghost.tscn")

func _on_spawn_ghost():
	print("spawn ghost")
	var rooms: Array = get_tree().get_nodes_in_group(Constants.GROUP_ROOM)
	rooms.shuffle()
	for room in rooms:
		if room.roomHasTask and not room.dirtinessToState(room.dirtiness) == SpookyRoom.ROOM_STATE.RUINED and room.present_ghosts.empty():
			var ghost: Ghost = ghost_scene.instance()
			ghost.mood = -100
			ghost.position = Vector2(-100, 540)
			add_child(ghost)
			ghost.send_to_location(room.room_info, false)
			ghost_spawn_timer.wait_time = ghost_spawn_timer.wait_time - 5
			if ghost_spawn_timer.wait_time < 1:
				ghost_spawn_timer.wait_time = 1
			return
	# If we don't have a valid place for it, don't spawn the ghost
