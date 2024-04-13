extends HBoxContainer
class_name ComboHBoxContainer

func add_key(key) -> void:
	var print_key = ""

	match key:
		KEY_UP: print_key = "UP"
		KEY_DOWN: print_key = "DOWN"
		KEY_LEFT: print_key = "LEFT"
		KEY_RIGHT: print_key = "RIGHT"
	
	var name_label = Label.new()
	name_label.text = print_key
	add_child(name_label)

	
func clear_keys() -> void:
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()
