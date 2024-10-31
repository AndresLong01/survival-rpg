extends Control
class_name HotbarSlot

@onready var selected_border: TextureRect = $Selected
@onready var item_sprite_icon: TextureRect = $ItemSprite

func set_item_sprite_icon(item: ItemResource) -> void:
	item_sprite_icon.texture = item.sprite_texture

func select_as_current() -> void:
	selected_border.visible = true

func remove_as_selected() -> void:
	selected_border.visible = false
