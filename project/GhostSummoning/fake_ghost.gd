extends KinematicBody2D

var rng = RandomNumberGenerator.new()

var speed = Vector2.ZERO
	
	
func _ready():
	rng.randomize()
	speed = Vector2(rng.randf_range(-100,100), rng.randf_range(-100,100))

	
func _physics_process(_delta):
	var _result = move_and_slide(speed)
