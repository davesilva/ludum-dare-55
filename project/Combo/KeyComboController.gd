extends Node2D
class_name KeyComboController

onready var timer = $Timer
onready var combo_h_box_container = $Control/ComboHBoxContainer


export(float) var timer_length = 2.0
export(Array) var key_pool = [KEY_LEFT, KEY_UP, KEY_DOWN, KEY_RIGHT]


var comboing_enabled = false 
var combo_running = false
var current_combo = []

signal combo_completed(combo)

func end_combo(force_end=false) -> void:
	timer.stop()
	combo_running = false
	combo_h_box_container.clear_keys()
	if not force_end:
		emit_signal("combo_completed", current_combo)
	current_combo = []

func generate_combo_sequence() -> Array:
	var arr = []
	for _i in range(1, 5):
		arr.append(key_pool[randi() % key_pool.size()])
		
	return arr

func _input(event):
	if not comboing_enabled: return
	if not combo_running: 
		combo_running = true
	if event is InputEventKey and event.pressed and key_pool.has(event.scancode):
		timer.start(timer_length)
		current_combo.append(event.scancode)
		combo_h_box_container.add_key(event.scancode)

func _on_Timer_timeout():
	end_combo()
