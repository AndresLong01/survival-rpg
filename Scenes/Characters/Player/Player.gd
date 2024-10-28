extends Character

class_name Player
@export var equipped_item: ItemResource

#region Ground State
const MAX_SPEED: float = 300.0
const ACCELERATION: float = 12.5

var can_apply_movement: bool = true
var ignore_sprite_flip: bool = false
#endregion

#region Jump State
const GRAVITY: float = 1500.0
const JUMP_VELOCITY: float = -630.0
const VERTICAL_COUNTER_FORCE: float = 180.0
const MAX_VERTICAL_SPEED: float = -1200.0
const MAX_FALL_SPEED: float = 600.0
#endregion

func _ready() -> void:
	super()
	pass

func _physics_process(_delta: float) -> void:
	if can_apply_movement:
		apply_horizontal_momentum()
	
	if not ignore_sprite_flip:
		flip_sprite()
	
	move_and_slide()

func apply_horizontal_momentum() -> void:
	var direction: int = 0
	
	if Input.is_action_pressed(GameConstants.INPUT_LEFT):
		direction = -1
	elif Input.is_action_pressed(GameConstants.INPUT_RIGHT):
		direction = 1
	else:
		velocity.x = 0
		return
	
	if ignore_sprite_flip:
		velocity.x = direction * MAX_SPEED/2
	else:
		velocity.x = direction * MAX_SPEED

func toggle_horizontal_input(state: bool) -> void:
	can_apply_movement = state
	
	if not can_apply_movement:
		velocity.x = 0

func toggle_ignore_sprite_flip(state: bool) -> void:
	ignore_sprite_flip = state
