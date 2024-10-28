extends PlayerState
class_name Idle

@onready var fall: Fall = $"../Fall"

func enter() -> void:
	player.animation_player.play(GameConstants.ANIM_IDLE)

func update(_delta: float) -> void:
	if not player.is_on_floor():
		fall.set_slip_buffer()
		Transitioned.emit("fall")
	
	if player.is_on_floor():
		check_for_jump_input()
	
	check_for_primary_action_input()
	#check_for_backdash_input()

func physics_update(_delta: float) -> void:
	if (player.velocity.x != 0):
		Transitioned.emit("move")