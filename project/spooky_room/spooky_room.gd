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

var room_info: SpookyRoomInfo
var contains_player: bool = false
# NOTE: Change this if we commit for sure to just one ghost
var present_ghosts: Array = []

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# TODO: Remove this
	if Input.is_action_just_pressed("ui_up") and dirtiness > 0:
		dirtiness -= processSpeedInSeconds/10.0
	elif Input.is_action_just_pressed("ui_down") and dirtiness < processSpeedInSeconds:
		dirtiness += processSpeedInSeconds/10.0
		
	if roomHasTask:
		# NOTE: This can be simplified a lot if we only have one ghost
		var helpful_ghosts = []
		var naughty_ghosts = []
		for ghost in present_ghosts:
			if ghost.is_happy() and ghost.state != Ghost.STATE.TRAVELING:
				helpful_ghosts.append(ghost)
			elif ghost.is_angry() and ghost.state != Ghost.STATE.TRAVELING:
				naughty_ghosts.append(ghost)
		var progress = 0
		for ghost in helpful_ghosts:
			progress += ghost.chore_speed
		for ghost in naughty_ghosts:
			progress -= ghost.chore_speed
		progress = progress * delta
		dirtiness -= progress

		if dirtiness > processSpeedInSeconds:
			dirtiness = processSpeedInSeconds
		elif dirtiness < 0:
			dirtiness = 0

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
		player.current_room_info = room_info
		contains_player = true

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
