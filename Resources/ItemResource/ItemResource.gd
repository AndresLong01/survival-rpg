extends Resource
class_name ItemResource

enum ItemType {
	Mining,
	Block,
	Weapon,
	Food,
	Potion,
	Empty
}

enum Animations {
	Swing,
	Stab,
	Cast,
}

@export var item_type: ItemType
@export var sprite_texture: Texture
@export var animation_type: Animations
@export var frequency: float = 1.0 # How fast the animation should play, multiplier
@export var use_range: float = 1.0 # How far the tool can go
@export var strength: float # Strength of tool or weapon

#region Tool Controllers
const MiningToolController: PackedScene = preload("res://Scenes/Components/Mining/Controller/MiningToolController.tscn")
#endregion

func setup(data: Dictionary) -> ItemResource:
	if "item_type" in data:
		item_type = data.item_type
	if "sprite_texture" in data:
		sprite_texture = data.sprite_texture
	if "animation_type" in data:
		animation_type = data.animation_type
	if "frequency" in data:
		frequency = data.frequency
	if "use_range" in data:
		use_range = data.use_range
	if "strength" in data:
		strength = data.strength
	return self

func setup_empty() -> ItemResource:
	item_type = ItemType.Empty
	return self

func on_active(player : Player) -> void:
	if item_type == ItemType.Mining:
		var controller: MiningToolController = MiningToolController.instantiate()
		controller.init(self, player)
