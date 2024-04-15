extends Control
class_name OnGhostUI

onready var top_zone = $TopZone
onready var bottom_zone = $BottomZone

onready var star_container: StarContainer = $BottomZone/StarContainer

func _ready():
	top_zone.hide()
	bottom_zone.hide()
	
	
func set_stars_display(count: int):
	bottom_zone.visible = count > 0
	star_container.display_stars(count)
