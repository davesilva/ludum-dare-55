extends HBoxContainer
class_name ComboHBoxContainer

var up_arrow = preload("res://project/Combo/arrow-square-up.svg")
var down_arrow = preload("res://project/Combo/arrow-square-down.svg")
var left_arrow = preload("res://project/Combo/arrow-square-left.svg")
var right_arrow = preload("res://project/Combo/arrow-square-right.svg")
func add_key(key) -> void:
	var 	label = TextureRect.new()
	label.modulate = Color(1,1,1)
	match key:
		KEY_UP: 	label.texture = up_arrow
		KEY_DOWN: label.texture = down_arrow
		KEY_LEFT: label.texture = left_arrow
		KEY_RIGHT: label.texture = right_arrow
		_: 
			label = Label.new()
			label.text = key

	add_child(label)

	
func clear_keys() -> void:
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()
