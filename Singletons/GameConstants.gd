extends Node

const ANIM_IDLE: String = "Idle"
const ANIM_START_MOVE: String = "StartMove"
const ANIM_MOVE: String = "Move"
const ANIM_STOP_MOVE: String = "StopMove"
const ANIM_PATROL: String = "Patrol"
const ANIM_START_JUMP: String = "StartJump"
const ANIM_JUMP: String = "Jump"
const ANIM_START_FALL: String = "StartFall"
const ANIM_FALL: String = "Fall"
const ANIM_DASH: String = "Dash"
const ANIM_BACKDASH: String = "Backdash"
const ANIM_ATTACK: String = "Attack"
const ANIM_AIR_ATTACK: String = "AirAttack"
const ANIM_START_REST: String = "StartRest"
const ANIM_REST: String = "Rest"
const ANIM_START_SLEEP: String = "StartSleep"
const ANIM_SLEEP: String = "Sleep"
const ANIM_DEATH: String = "Death"

#region
const TOOL_SWING: String = "Swing"
const TOOL_SWING_FLIPPED: String = "SwingFlipped"
#endregion

const INPUT_LEFT: String = "Left"
const INPUT_RIGHT: String = "Right"
const INPUT_JUMP: String = "Jump"
const INPUT_DASH: String = "Dash"
const INPUT_PRIMARY: String = "Primary"
const INPUT_HOTBAR: String = "Hotbar"
const INPUT_SCROLL_UP: String = "ScrollUp"
const INPUT_SCROLL_DOWN: String = "ScrollDown"

#region Custom Resources
var copper_pickaxe: ItemResource = ItemResource.new().setup({
	"item_type": ItemResource.ItemType.Mining,
	"sprite_texture": preload("res://Assets/Items/Mining/PickaxeSprites/CopperPickaxe.png"),
	"animation_type": ItemResource.Animations.Swing,
	"frequency": 2.0,
	"use_range": 1.0,
	"strength": 4,
})

var stone_pickaxe: ItemResource = ItemResource.new().setup({
	"item_type": ItemResource.ItemType.Mining,
	"sprite_texture": preload("res://Assets/Items/Mining/PickaxeSprites/StonePickaxe.png"),
	"animation_type": ItemResource.Animations.Swing,
	"frequency": 1.0,
	"use_range": 1.0,
	"strength": 2,
})

var diamond_pickaxe: ItemResource = ItemResource.new().setup({
	"item_type": ItemResource.ItemType.Mining,
	"sprite_texture": preload("res://Assets/Items/Mining/PickaxeSprites/DiamondPickaxe.png"),
	"animation_type": ItemResource.Animations.Swing,
	"frequency": 4.0,
	"use_range": 1.0,
	"strength": 9,
})

var test_hotbar_inventory: Array[ItemResource] = [
	stone_pickaxe,
	ItemResource.new().setup_empty(),
	ItemResource.new().setup_empty(),
	copper_pickaxe,
	ItemResource.new().setup_empty(),
	ItemResource.new().setup_empty(),
	ItemResource.new().setup_empty(),
	diamond_pickaxe,
	ItemResource.new().setup_empty(),
]
#endregion
