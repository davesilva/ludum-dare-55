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
				if not self == room and room.roomHasTask and not dirtinessToState(room.dirtiness) == ROOM_STATE.RUINED:
					ghost.send_to_location(room.room_info, true)
					return
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

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group(Constants.GROUP_ROOM)
	sprite.texture = cleanImage
	
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

		# TODO: Remove this
		#if Input.is_action_just_pressed("ui_up") and dirtiness > 0:
		#	dirtiness -= processSpeedInSeconds/10.0
		#elif Input.is_action_just_pressed("ui_down") and dirtiness < processSpeedInSeconds:
		#	dirtiness += processSpeedInSeconds/10.0

		var helpful_ghosts = []
		var naughty_ghosts = []
		for ghost in present_ghosts:
			if ghost.is_happy() and ghost.state != Ghost.STATE.TRAVELING:
				helpful_ghosts.append(ghost)
			elif ghost.is_angry() and ghost.state != Ghost.STATE.TRAVELING:
				naughty_ghosts.append(ghost)
		for ghost in helpful_ghosts:
			dirtiness -= ghost.chore_speed * delta
		for ghost in naughty_ghosts:
			dirtiness += ghost.chore_speed * delta

		if dirtiness > processSpeedInSeconds:
			dirtiness = processSpeedInSeconds
		elif dirtiness < 0:
			dirtiness = 0
			
		if dirtiness < 0.5 and naughty_ghosts.empty():
			dirtiness = 0
			update_progress()

		# If dirtiness changes, update graphics and progress
		if dirtiness != prev_dirtiness:
			update_progress()

			match dirtinessToState(dirtiness):
				ROOM_STATE.CLEAN:
					#$RoomClean.play()
					sprite.texture = cleanImage
				ROOM_STATE.DIRTY:
					sprite.texture = dirtyImage
				ROOM_STATE.DIRTIER:
					sprite.texture = dirtierImage
				ROOM_STATE.RUINED:
					sprite.texture = ruinedImage

		if dirtinessToState(dirtiness) == ROOM_STATE.RUINED:
			ward_off_angry_ghosts()

	_update_debug_labels()
	_sync_room_info()


func update_progress():
	var progress = (dirtiness/processSpeedInSeconds)*100
	ruination_meter.value = progress
	if ruination_meter.value == 0:
		ruination_meter.visible = false
	else:
		ruination_meter.visible = true
	
	
func _sync_room_info():
	room_info.dirtiness = dirtiness


func _on_RoomArea2D_body_entered(body):
	if body.is_in_group(Constants.GROUP_PLAYER):
		var player = body as PlayerCharacter
		player.current_room_info = room_info
		contains_player = true
		ward_off_angry_ghosts()


func _on_RoomArea2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		GlobalSignals.emit_signal("room_clicked", self)


func _on_RoomArea2D_body_exited(body):
	if body.is_in_group(Constants.GROUP_PLAYER):
		var player = body as PlayerCharacter
		player.current_room_info = room_info
		contains_player = false


func _on_GhostActiveArea2D_area_entered(area):
	if area.is_in_group(Constants.GROUP_GHOST):
		var ghost = area as Ghost
		ghost.current_location_info = room_info
		present_ghosts.append(ghost)
		


func _on_GhostActiveArea2D_area_exited(area):
	if area.is_in_group(Constants.GROUP_GHOST):
		var ghost = area as Ghost
		present_ghosts.erase(ghost)

###############
#### DEBUG ####
###############
onready var dirty_debug_label = $Debug/ColorRect/DirtyDebugLabel

func _update_debug_labels():
	var rounded_dirty = stepify(room_info.dirtiness, 0.1)
	dirty_debug_label.text = "DIRTY: " + str(rounded_dirty)
