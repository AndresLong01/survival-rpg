extends Node
class_name MiningToolController

@onready var timer: Timer = $Timer
@export var mining_tool: PackedScene

const MAX_RANGE: float = 60.0

var current_item: ItemResource

func init(item: ItemResource, player: Player) -> void:
	current_item = item
	_use_mining_tool(player)

func _use_mining_tool(player: Player) -> void:
	var tool_instance: Node2D = mining_tool.instantiate()
	player.add_child(tool_instance)
	tool_instance.init(current_item, player)
	
	var cursor_pos: Vector2 = player.get_global_mouse_position()
	var player_pos: Vector2 = player.position
	var direction: Vector2 = cursor_pos - player_pos
	var distance: float = direction.length()
	
	var modified_range: float = MAX_RANGE * current_item.use_range
	if distance <= modified_range:
		_mine_tile_from_map(cursor_pos, player)
	
	if player.sprite.flip_h:
		tool_instance.global_position = player.global_position + Vector2(-10.0, -10.0)
	else:
		tool_instance.global_position = player.global_position + Vector2(10.0, -10.0)
	

func _mine_tile_from_map(cursor_pos: Vector2, player: Player) -> void:
	var tile_map: Terrain = player.get_tree().get_nodes_in_group('Blocks')[0]
	var tile_pos: Vector2 = tile_map.local_to_map(cursor_pos)
	var tile_type_id: int = tile_map.get_cell_source_id(tile_pos)
	
	var tile_type: String = TileIds._get_terrain_type_from_index(tile_type_id)
	if tile_type == TileIds.INVALID:
		return
	
	var tile_hp: int = TileIds.terrain_hp[tile_type]
	var mining_force: float = current_item.strength
	
	tile_map.calculate_tile_damage(tile_pos, tile_hp, mining_force)
