extends Node2D
class_name SpookyRoom

# TODO: A COUPLE ROOMS NEED WALLS BUT MOST DON'T

# TODO: make a resource(?) 
export var cleanImage: Texture
export var dirtyImage: Texture
export var dirtierImage: Texture
export var ruinedImage: Texture
export var roomWidth: int
export var roomHeight: int
export var processSpeedInSeconds: int = 5
export var roomHasTask: bool = true

# These ones are generic
export var dirtiness := 0.0
enum ROOM_STATE {CLEAN, DIRTY, DIRTIER, RUINED}
onready var sprite = $Sprite
onready var room_collision_shape_2d = $RoomArea2D/RoomCollisionShape2D
onready var canvas_layer = $Container/CanvasLayer
onready var ruination_meter = $Container/CanvasLayer/RuinationMeter

var room_info: SpookyRoomInfo
var contains_player: bool = false
# NOTE: Change this if we commit for sure to just one ghost
var present_ghosts: Array = []


func ward_off_angry_ghosts() -> void:
	# if the player enters the same room as a rager, it should move to a new room to wreck
	#  if there are none available destroy him
	for ghost in present_ghosts:
		if ghost.state == Ghost.STATE.RAGING:
			var rooms: Array = get_tree().get_nodes_in_group(Constants.GROUP_ROOM)
			rooms.shuffle()
			for room in rooms:
				if not self == room and room.roomHasTask and not dirtinessToState(room.dirtiness) == ROOM_STATE.RUINED and room.present_ghosts.empty():
					ghost.send_to_location(room.room_info, true)
					return
			# TODO: This should probably hurt the ghost somehow
			ghost.queue_free()

# Converts the int to the state (real return type is ROOM_STATE)
func dirtinessToState(c: float) -> int:
	if c < processSpeedInSeconds/3.0:
		return ROOM_STATE.CLEAN
	elif c < (processSpeedInSeconds) * 2/3.0:
		return ROOM_STATE.DIRTY
	elif c < processSpeedInSeconds:
		return ROOM_STATE.DIRTIER
	else:
		return ROOM_STATE.RUINED
		
		
func get_room_state() -> int:
	return dirtinessToState(dirtiness)
	
	
func is_room_ruined() -> bool:
	var state = get_room_state()
	match state:
		ROOM_STATE.RUINED:
			return true
	
	return false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group(Constants.GROUP_ROOM)
	_set_room_image()
	update_progress()
	
	if not roomWidth:
		roomWidth = sprite.texture.get_width()
	if not roomHeight:
		roomHeight = sprite.texture.get_height()
	room_info = SpookyRoomInfo.new(self.global_position)
	room_collision_shape_2d.shape.set_extents(Vector2(roomWidth/2.0, roomHeight/2.0))
	canvas_layer.offset.x = self.global_position[0]
	canvas_layer.offset.y = self.global_position[1]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if roomHasTask:
		# NOTE: This can be simplified a lot if we only have one ghost
		var prev_dirtiness = dirtiness

		var helpful_ghosts = _get_helpful_ghosts()
		var naughty_ghosts = _get_angry_ghosts()
		for ghost in helpful_ghosts:
			if dirtiness > 0:
				dirtiness -= ghost.chore_speed * delta
		for ghost in naughty_ghosts:
			dirtiness += ghost.chore_speed * delta

		if dirtiness > processSpeedInSeconds:
			dirtiness = processSpeedInSeconds
		elif dirtiness < 0:
			dirtiness = 0
			
		if dirtiness < processSpeedInSeconds/100.0 and naughty_ghosts.empty():
			dirtiness = 0
			update_progress()

		# If dirtiness changes, update graphics and progress
		if dirtiness != prev_dirtiness:				
			update_progress()
			_set_room_image()
			
			if dirtiness == 0:
				for ghost in helpful_ghosts:
					ghost.current_room_has_been_cleaned()

			if dirtinessToState(dirtiness) == ROOM_STATE.RUINED:
				disable_room()
				ward_off_angry_ghosts()

	_update_debug_labels()
	_sync_room_info()

func disable_room():
	roomHasTask = false
	ruination_meter.visible = false
	sprite.material.set_shader_param("enabled", true)
	$DeadRoom.play()


func update_progress():
	var progress = (dirtiness/processSpeedInSeconds)*100
	ruination_meter.value = progress
	if ruination_meter.value == 0:
		ruination_meter.visible = false
	else:
		ruination_meter.visible = true
	
	
func _sync_room_info():
	room_info.dirtiness = dirtiness
	room_info.contains_player = contains_player
	room_info.helpful_ghost_count = _get_helpful_ghosts().size()
	room_info.naughty_ghost_count = _get_angry_ghosts().size()

func _set_room_image():
	match dirtinessToState(dirtiness):
		ROOM_STATE.CLEAN:
			sprite.texture = cleanImage
		ROOM_STATE.DIRTY:
			sprite.texture = dirtyImage
		ROOM_STATE.DIRTIER:
			sprite.texture = dirtierImage
		ROOM_STATE.RUINED:
			sprite.texture = ruinedImage

func _on_RoomArea2D_body_entered(body):
	if body.is_in_group(Constants.GROUP_PLAYER):
		var player = body as PlayerCharacter
		player.available_action = PlayerCharacter.PlayerActions.NONE
		player.current_room_info = room_info
		player.stairs_target = null
		contains_player = true
		ward_off_angry_ghosts()


func _on_RoomArea2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		GlobalSignals.emit_signal("room_clicked", self)


func _on_RoomArea2D_body_exited(body):
	if body.is_in_group(Constants.GROUP_PLAYER):
		contains_player = false


func _on_GhostActiveArea2D_area_entered(area):
	if area.is_in_group(Constants.GROUP_GHOST):
		var ghost = area as Ghost
		if ghost.state == Ghost.STATE.TRAVELING and ghost.destination_info.global_position != self.global_position:
			return
		ghost.current_location_info = room_info
		present_ghosts.append(ghost)
		if ghost.is_angry() and contains_player:
			ward_off_angry_ghosts()


func _on_GhostActiveArea2D_area_exited(area):
	if area.is_in_group(Constants.GROUP_GHOST):
		var ghost = area as Ghost
		present_ghosts.erase(ghost)
		
		
func _get_helpful_ghosts() -> Array:
	var helpful_ghosts: Array = []
	for ghost in present_ghosts:
		if ghost.is_happy() and ghost.state != Ghost.STATE.TRAVELING:
			helpful_ghosts.append(ghost)
			
	return helpful_ghosts
	
	
func _get_angry_ghosts() -> Array:
	var naughty_ghosts: Array = []
	for ghost in present_ghosts:
		if ghost.is_angry() and ghost.state != Ghost.STATE.TRAVELING:
			naughty_ghosts.append(ghost)
			
	return naughty_ghosts

###############
#### DEBUG ####
###############
onready var dirty_debug_label = $Debug/ColorRect/DirtyDebugLabel

func _update_debug_labels():
	var rounded_dirty = stepify(room_info.dirtiness, 0.1)
	dirty_debug_label.text = "DIRTY: " + str(rounded_dirty)
