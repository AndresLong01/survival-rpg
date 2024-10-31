extends Node2D
class_name ItemDrop

@export var item: ItemResource

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	#sprite_2d.texture = item.sprite_texture
	_spawn_jump()

func _spawn_jump() -> void:
	print('I am here')
