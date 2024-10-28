extends Resource
class_name ItemResource

enum ItemType {
	Mining,
	Weapon,
	Food,
	Potion
}

enum Animations {
	Swing,
	Stab,
	Cast,
}

@export var stat_type: ItemType
@export var sprite_texture: Texture
@export var animation_type: Animations
@export var frequency: float = 1.0 # How fast the animation should play, multiplier
@export var use_range: float = 1.0 # How far the tool can go
@export var strength: float # Strength of tool or weapon

#region Tool Controllers
const MiningToolController: PackedScene = preload("res://Scenes/Components/Mining/Controller/MiningToolController.tscn")
#endregion

func on_active(player : Player) -> void:
	if stat_type == ItemType.Mining:
		var controller: MiningToolController = MiningToolController.instantiate()
		controller.init(self, player)
