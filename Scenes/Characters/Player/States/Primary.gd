extends PlayerState
class_name Primary

const BUFFER_FRAMES: int = 12

var buffer_counter: int = 0

func enter() -> void:
	player.toggle_ignore_sprite_flip(true)
	animate_primary_action()
	player.animation_player.connect("animation_finished", _on_animation_finished)

func update(_delta: float) -> void:
	if player.is_on_floor():
		check_for_jump_input()

func physics_update(delta : float) -> void:
	calculate_buffer()
	player.velocity.y += player.GRAVITY * delta

func exit() -> void:
	player.toggle_ignore_sprite_flip(false)
	player.animation_player.disconnect("animation_finished", _on_animation_finished)

func animate_primary_action() -> void:
	if player.equipped_item:
		var animation_name: String = player.equipped_item.Animations.find_key(player.equipped_item.animation_type)
		player.equipped_item.on_active(player)
		player.animation_player.speed_scale = player.equipped_item.frequency
		player.animation_player.play(animation_name)
	else:
		player.animation_player.play(GameConstants.ANIM_ATTACK)

func calculate_buffer() -> void:
	if Input.is_action_just_pressed(GameConstants.INPUT_PRIMARY):
		buffer_counter = BUFFER_FRAMES
	
	if buffer_counter > 0:
		buffer_counter -= 1

func _on_animation_finished(_animation_name: String) -> void:
	player.animation_player.speed_scale = 1.0
	if buffer_counter > 0:
		animate_primary_action()
	else:
		Transitioned.emit("idle")
