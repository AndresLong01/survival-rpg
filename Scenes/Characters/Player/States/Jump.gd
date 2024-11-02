extends PlayerState
class_name Jump

func enter() -> void:
	player.animation_player.play(GameConstants.ANIM_JUMP)
	apply_jump()

func update(_delta: float) -> void:
	check_for_primary_action_input()
	check_for_jump_input()
	#check_for_dash_input()

func physics_update(delta: float) -> void:
	player.velocity.y += player.GRAVITY * delta
	
	apply_counter_force()
	
	if player.velocity.y > 0:
		Transitioned.emit("fall")

func apply_jump() -> void:
	player.velocity.y = player.JUMP_VELOCITY

func apply_counter_force() -> void:
	if Input.is_action_just_released(GameConstants.INPUT_JUMP):
		if player.velocity.y < 0:
			player.velocity.y += player.VERTICAL_COUNTER_FORCE
	
	player.velocity.y = clampf(player.velocity.y, player.MAX_VERTICAL_SPEED, player.MAX_FALL_SPEED)
