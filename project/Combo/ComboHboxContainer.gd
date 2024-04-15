extends HBoxContainer
class_name ComboHBoxContainer

export (bool) var use_custom_rect_size = false
export (Vector2) var custom_rect_size = Vector2.ZERO

var up_arrow = preload("res://project/Combo/arrow-square-up.svg")
var down_arrow = preload("res://project/Combo/arrow-square-down.svg")
var left_arrow = preload("res://project/Combo/arrow-square-left.svg")
var right_arrow = preload("res://project/Combo/arrow-square-right.svg")
var labels = []

func add_keys(keys) -> void:
	clear_keys()
	for key in keys:
		var 	label = TextureRect.new()
		label.modulate = Color(1,1,1)
		match key:
			KEY_W: label.texture = up_arrow
			KEY_S: label.texture = down_arrow
			KEY_A: label.texture = left_arrow
			KEY_D: label.texture = right_arrow
			_: 
				label = Label.new()
				label.text = key
				
		if use_custom_rect_size:
			label.rect_size = custom_rect_size

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
