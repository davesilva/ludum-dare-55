extends Node2D
class_name SpookyRoom

# TODO: A COUPLE ROOMS NEED WALLS BUT MOST DON'T

# TODO: make a resource(?) 
export var cleanImage: Texture
export var dirtyImage: Texture
export var roomWidth: int
export var roomHeight: int
export var processSpeedInSeconds: int = 5

# These ones are generic
export var dirtiness := 0.0
var naughtyLevel := 0
var niceLevel := 0
enum ROOM_STATE {CLEAN, DIRTY, RUINED}
onready var sprite = $Sprite
onready var room_collision_shape_2d = $RoomArea2D/RoomCollisionShape2D
onready var floor_collision_shape_2d = $Floor/RigidBody2D/FloorCollisionShape2D


# Converts the int to the state (real return type is ROOM_STATE)
func dirtinessToState(c: int) -> int:
	if c < processSpeedInSeconds/2.0:
		return ROOM_STATE.CLEAN
	elif c < processSpeedInSeconds:
		return ROOM_STATE.DIRTY
	else:
		return ROOM_STATE.RUINED

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = cleanImage
	sprite.scale.x = float(roomWidth)/sprite.texture.get_width()
	sprite.scale.y = float(roomHeight)/sprite.texture.get_height()
	# room_collision_shape_2d.shape.set_extents(Vector2(roomWidth, roomHeight))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# TODO: Remove this
	if Input.is_action_pressed("ui_up") and dirtiness > 0:
		niceLevel = 1
		naughtyLevel = 0
	elif Input.is_action_pressed("ui_down") and dirtiness < processSpeedInSeconds:
		niceLevel = 0
		naughtyLevel = -1

	var progress = (delta*((-1)*(niceLevel+naughtyLevel)))
	dirtiness += progress

	if dirtiness > processSpeedInSeconds:
		dirtiness = processSpeedInSeconds
	elif dirtiness < 0:
		dirtiness = 0

	match dirtinessToState(dirtiness):
		ROOM_STATE.CLEAN:
			sprite.texture = cleanImage
		ROOM_STATE.DIRTY:
			sprite.texture = dirtyImage
		ROOM_STATE.RUINED:
			sprite.texture = dirtyImage

func _on_RoomArea2D_body_entered(body):
	if body.is_in_group(Constants.GROUP_PLAYER):
		var player = body as PlayerCharacter
		player.current_room = self
	elif body.is_in_group(Constants.GROUP_GHOST):
		var ghost = body as Ghost
		ghost.current_location = self
