extends Node2D


# Declare member variables here. Examples:
export var cleanliness := 0
export var cleanImage: String
export var dirtyImage: String
var cleanImageTexture: StreamTexture
var dirtyImageTexture: StreamTexture
var naughtyLevel := 0
var niceLevel := 0
enum ROOM_STATE {CLEAN, DIRTY, RUINED}

# Converts the int to the state (real return type is ROOM_STATE)
func cleanlinessToState(c: int) -> int:
	if c < 50:
		return ROOM_STATE.CLEAN
	elif c < 100:
		return ROOM_STATE.DIRTY
	else:
		return ROOM_STATE.RUINED

# Called when the node enters the scene tree for the first time.
func _ready():
	cleanImageTexture = load(cleanImage)
	dirtyImageTexture = load(dirtyImage)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# TODO: Remove this
	if Input.is_action_pressed("ui_up") and cleanliness < 100:
		cleanliness += 1
	elif Input.is_action_pressed("ui_down") and cleanliness > 0:
		cleanliness -= 1

	match cleanlinessToState(cleanliness):
		ROOM_STATE.CLEAN:
			$Sprite.texture = cleanImageTexture
		ROOM_STATE.DIRTY:
			$Sprite.texture = dirtyImageTexture
		ROOM_STATE.RUINED:
			$Sprite.texture = dirtyImageTexture
