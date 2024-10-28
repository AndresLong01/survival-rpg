extends Node2D
class_name MiningTool

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func init(item: ItemResource, player: Player) -> void:
	animation_player.speed_scale = item.frequency
	if player.sprite.flip_h:
		animation_player.play(GameConstants.TOOL_SWING_FLIPPED)
	else:
		animation_player.play(GameConstants.TOOL_SWING)
	
	sprite_2d.texture = item.sprite_texture
