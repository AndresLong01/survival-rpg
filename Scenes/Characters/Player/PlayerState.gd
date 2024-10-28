extends State
class_name PlayerState

@export var player: Player

func _ready() -> void:
	if player:
		player.get_stat_resource(StatResource.Stat.Health).on_zero = Callable(self, "_handle_zero_health")

func check_for_jump_input() -> void:
	if Input.is_action_just_pressed(GameConstants.INPUT_JUMP):
		Transitioned.emit("jump")

func check_for_primary_action_input() -> void:
	if Input.is_action_just_pressed(GameConstants.INPUT_PRIMARY):
		Transitioned.emit("primary")

#func check_for_dash_input() -> void:
	#if Input.is_action_just_pressed(GameConstants.INPUT_DASH):
		#Transitioned.emit("dash")

#func check_for_backdash_input() -> void:
	#if Input.is_action_just_pressed(GameConstants.INPUT_DASH):
		#Transitioned.emit("backdash")

func _handle_zero_health() -> void:
	Transitioned.emit("death")
