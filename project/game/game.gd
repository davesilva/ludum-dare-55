extends Node
class_name Game

var world_root: Node2D = null
var is_game_active = false

func _process(_delta):
	if not is_game_active:
		return
	
	if player_has_lost():
		run_player_lost_sequence()
		return
		
	round_tick()
	
	
func start_game():
	is_game_active = true
	

func player_has_won() -> bool:
	return false


func player_has_lost() -> bool:
	return remaining_salvagable_rooms() <= 1
	
	
func round_tick():
	# here is where we tell things to update in the world
	# like potentially spawning things
	# or entering a new phase of play
	pass
	
	
func run_player_lost_sequence():
	is_game_active = false
	GlobalSignals.emit_signal("display_prompt", "YOU LOSE")
	GlobalSignals.emit_signal("game_end")
	

func remaining_salvagable_rooms() -> int:
	var counter = 0
	var rooms = get_tree().get_nodes_in_group(Constants.GROUP_ROOM)
	for room in rooms:
		if room is SpookyRoom:
			if room.room_info.can_be_ruined() and not room.is_room_ruined():
				counter += 1
	return counter
