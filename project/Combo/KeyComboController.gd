extends Node2D
class_name KeyComboController

onready var timer = $Timer
onready var combo_h_box_container = $Control/PanelContainer/VBoxContainer/ComboHBoxContainer
onready var panel_container = $Control/PanelContainer

export(float) var timer_length = 2.0
export(Array) var key_pool = [KEY_W, KEY_A, KEY_S, KEY_D]


var comboing_enabled = false setget _on_comboing_enabled_set
var combo_running = false
var sequence_to_match = []
var current_combo = []
var sequence_length = 3
var current_idx = 0


func _on_comboing_enabled_set(value: bool) -> void:
	comboing_enabled = value
	if comboing_enabled:
		sequence_to_match = generate_combo_sequence()
		combo_h_box_container.clear_keys()
		combo_h_box_container.add_keys(sequence_to_match)
		GlobalSignals.emit_signal("display_keys", sequence_to_match)
		panel_container.show()
		

func end_combo(force_end=false) -> void:
	current_idx = 0
	timer.stop()
	combo_running = false
	combo_h_box_container.reset_key_colors()

	if current_combo.hash() == sequence_to_match.hash():
		sequence_length = sequence_length + 1
		combo_h_box_container.clear_keys()
		sequence_to_match = generate_combo_sequence()
		combo_h_box_container.add_keys(sequence_to_match)
		GlobalSignals.emit_signal("display_keys", sequence_to_match)
		GlobalSignals.emit_signal("combo_completed", current_combo)
	if force_end:
		panel_container.hide	()
	current_combo = []

func generate_combo_sequence() -> Array:
	var arr = []
	for _i in range(1, sequence_length+1):
		arr.append(key_pool[randi() % key_pool.size()])
		
	return arr

func _input(event):
	if not comboing_enabled: return
	if not combo_running: 
		combo_running = true
	if event is InputEventKey and event.pressed and key_pool.has(event.scancode):
		if event.scancode == sequence_to_match[current_idx]:
			current_combo.append(event.scancode)
			if sequence_to_match.hash() == current_combo.hash():
				print("matched")
				$ComboSuccessA.play()
				end_combo(true)
				return
			combo_h_box_container.set_key_color(current_idx, Color(0,1,0))
			current_idx = current_idx + 1
			timer.start(timer_length)


		else:
			$ComboFail.play()
			end_combo()

func _on_Timer_timeout():
	end_combo()
