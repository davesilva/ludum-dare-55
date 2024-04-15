class_name SpookyRoomInfo

signal can_command_ghost(state)

enum ROOM_TYPE {SPOOKY, SUMMONING, STAIRS}

var global_position = Vector2.ZERO
var dirtiness = 0.0
var contains_player = false setget _set_contains_player
var helpful_ghost_count = 0 setget _set_helpful_ghost_count
var naughty_ghost_count = 0 setget _set_naught_ghost_count
var room_type = ROOM_TYPE.SPOOKY

var _last_command_ghost_state = false

func _init(global_pos: Vector2):
	self.global_position = global_pos

func _set_contains_player(new_value: bool):
	contains_player = new_value
	_run_commandable_ghost_check()
	
	
func _set_helpful_ghost_count(new_value: int):
	helpful_ghost_count = new_value
	_run_commandable_ghost_check()
	
	
func _set_naught_ghost_count(new_value: int):
	naughty_ghost_count = new_value
	_run_commandable_ghost_check()


func _run_commandable_ghost_check():
	var can_command = contains_player && helpful_ghost_count > 0
	if _last_command_ghost_state != can_command:
		emit_signal("can_command_ghost", can_command)
		_last_command_ghost_state = can_command

func can_be_ruined() -> bool:
	match room_type:
		ROOM_TYPE.SPOOKY:
			return true
			
	return false
