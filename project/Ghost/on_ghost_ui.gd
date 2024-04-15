extends Control
class_name OnGhostUI

onready var top_zone = $TopZone
onready var bottom_zone = $BottomZone

onready var star_container: StarContainer = $BottomZone/StarContainer
onready var pip_container: PipContainer = $BottomZone/PipContainer

func _ready():
	top_zone.hide()
	bottom_zone.hide()
	
	
func set_stars_display(count: int):
	star_container.show()
	pip_container.hide()
	bottom_zone.visible = count > 0
	star_container.display_stars(count)
	
	
func set_pips(count: int):
	star_container.hide()
	pip_container.show()
	bottom_zone.visible = count > 0
	pip_container.display_pips(count)
