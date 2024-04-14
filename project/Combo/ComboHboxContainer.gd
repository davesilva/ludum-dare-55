extends HBoxContainer
class_name ComboHBoxContainer

var up_arrow = preload("res://project/Combo/arrow-square-up.svg")
var down_arrow = preload("res://project/Combo/arrow-square-down.svg")
var left_arrow = preload("res://project/Combo/arrow-square-left.svg")
var right_arrow = preload("res://project/Combo/arrow-square-right.svg")
var labels = []

func add_keys(keys) -> void:
	for key in keys:
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
		labels.append(label)

func set_key_color(index: int, color: Color) -> void:
	labels[index].modulate = color

func reset_key_colors() -> void:
	for label in labels:
		label.modulate = Color(1,1,1)

func clear_keys() -> void:
	labels.clear()
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()
