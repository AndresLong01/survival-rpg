extends PlayerState
class_name Fall

const JUMP_BUFFER_FRAMES: int = 12
const SLIP_BUFFER_FRAMES: int = 6

var jump_buffer_counter: int = 0
var slip_buffer_counter: int = 0

func enter() -> void:
	player.animation_player.play(GameConstants.ANIM_FALL)

func update(_delta: float) -> void:
	check_for_primary_action_input()
	check_for_jump_input()
	#check_for_dash_input()

func physics_update(delta: float) -> void:
	calculate_buffer()
	player.velocity.y += player.GRAVITY * delta
	
	if slip_buffer_counter > 0:
		slip_buffer_counter -= 1
	
	if player.is_on_floor():
		player.velocity.y = 0
		if jump_buffer_counter == 0:
			Transitioned.emit("idle")
		elif jump_buffer_counter > 0:
			Transitioned.emit("jump")

func calculate_buffer() -> void:
	if Input.is_action_just_pressed(GameConstants.INPUT_JUMP):
		if slip_buffer_counter > 0 or player.is_on_floor():
			Transitioned.emit("jump")
		else:
			jump_buffer_counter = JUMP_BUFFER_FRAMES
	
	if jump_buffer_counter > 0:
		jump_buffer_counter -= 1

func set_slip_buffer() -> void:
	slip_buffer_counter = SLIP_BUFFER_FRAMES
