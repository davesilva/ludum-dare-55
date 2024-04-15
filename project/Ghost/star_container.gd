extends Control
class_name StarContainer

onready var top_star_row: StarRow = $VBoxContainer/TopStarRow
onready var bottom_star_row: StarRow = $VBoxContainer/BottomStarRow

func _ready():
	top_star_row.clear_container()
	top_star_row.hide()
	bottom_star_row.clear_container()
	bottom_star_row.hide()
	
	
func display_stars(count: int):
	top_star_row.clear_container()
	bottom_star_row.clear_container()
	
	for index in count:
		if index < 4:
			top_star_row.add_star()
		elif index < 8:
			bottom_star_row.add_star()
			
	top_star_row.visible = count > 0
	bottom_star_row.visible = count > 4
