extends Control
class_name StarRow

onready var star_container = $StarContainer

func clear_container():
	for star in star_container.get_children():
		if star is Control:
			star.visible = false
			

func add_star():
	for star in star_container.get_children():
		if star is Control:
			if star.visible:
				continue
			else:
				star.visible = true
				return
				
				
func remove_start():
	for star in star_container.get_children().invert():
		if star is Control:
			if not star.visible:
				continue
			else:
				star.visible = false
				return
