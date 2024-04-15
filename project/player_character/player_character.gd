extends KinematicBody2D
class_name PlayerCharacter

enum PlayerActions {
	NONE,
	SUMMON,
	STUDY, 
	COMMAND,
	CLIMB_STAIRS
}

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var sprite: Sprite = $Sprite
onready var movement := $Movement as MovementComponent2D
onready var summoning_power := $SummoningPower as GhostSummonerComponent
onready var available_action = PlayerActions.NONE setget action_setter
onready var current_room_info = SpookyRoomInfo
onready var ghost_director = $GhostDirector
onready var stairs_target = null setget _on_stairs_target_set
onready var character_tooltip = $CharacterTooltip as CharacterTooltip

func action_setter(new_value: int):
	available_action = new_value
	if available_action == PlayerActions.SUMMON:
		character_tooltip.display_text("'W' to begin summoning")
	else:
		character_tooltip.clear_text()


func _ready():
	movement.target = self
	animation_player.play("idle")
	GlobalSignals.connect("summoning_completed", self, "_on_summoning_completed")
	GlobalSignals.connect("player_enable_summoning", self, "enable_summoning")
	GlobalSignals.connect("player_disable_summoning", self, "disable_summoning")
	add_to_group(Constants.GROUP_PLAYER)

	
func _process(_delta):
	if Input.is_action_just_pressed("primary_action"):
		match available_action:
			PlayerActions.CLIMB_STAIRS:
				GlobalSignals.emit_signal("player_takes_stairs", self.stairs_target, self)
			PlayerActions.SUMMON:
				if summoning_power.is_enabled == false:
					start_summoning()
				else:
					stop_summoning()
			PlayerActions.STUDY:
				print("study")
			PlayerActions.COMMAND:
				print("command")
			

func _on_velocity_changed(velocity):
	if abs(velocity.x) < 1.0:
		animation_player.play("idle")
		return
	if velocity.x > 1.0: 
		sprite.flip_h = false
		animation_player.play("run")
	elif velocity.x < 1.0:
		sprite.flip_h = true
		animation_player.play("run")

func _on_summoning_completed(_base_ghost):
	stop_summoning()

func stop_summoning():
	character_tooltip.display_text("'W' to begin summoning")
	summoning_power.is_enabled = false
	movement.is_enabled = true
	animation_player.play("idle")
	sprite.offset.y = 0

func disable_summoning():
	# This shouldn't be necessary
	stop_summoning()
	character_tooltip.clear_text()
	available_action = PlayerActions.NONE

func enable_summoning():
	character_tooltip.display_text("'W' to begin summoning")
	available_action = PlayerActions.SUMMON

func start_summoning():
	character_tooltip.clear_text()
	animation_player.play("summon")
	sprite.offset.y = -12
	summoning_power.is_enabled = true
	movement.is_enabled = false

func _on_stairs_target_set(value):
	stairs_target = value
	if value:
		character_tooltip.display_text("'W' to take stairs")
	else:
		character_tooltip.clear_text()
