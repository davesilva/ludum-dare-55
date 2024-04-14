extends Reference
class_name SpookyRoomInfo

var global_position = Vector2.ZERO
var dirtiness = 0.0

func _init(global_pos: Vector2):
	self.global_position = global_pos
