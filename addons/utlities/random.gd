class_name Random
# This does nothing to preserve a seed across 
# the game - for that use GameRandom
	
static func randf():
	var rand = _get_fresh_random_generator()
	return rand.randf()
	
	
static func randf_range(low, high):
	var rand = _get_fresh_random_generator()
	return rand.randf_range(low, high)
	
	
static func randi():
	var rand = _get_fresh_random_generator()
	return rand.randi()
	
	
static func randi_range(low, high):
	var rand = _get_fresh_random_generator()
	return rand.randi_range(low, high)
	
	
static func _get_fresh_random_generator() -> RandomNumberGenerator:
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	return rand
	

static func random_unit_vector() -> Vector2:
	var random_x = randf_range(-1, 1)
	var random_y = randf_range(-1, 1)
	return Vector2(random_x, random_y)
