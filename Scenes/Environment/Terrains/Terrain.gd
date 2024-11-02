extends TileMapLayer
class_name Terrain

@export var destruction_tile_map: TileMapLayer

var tile_damage_tracker: Dictionary = {}

func calculate_tile_damage(tile_pos: Vector2, tile_hp: float, mining_force: float) -> void:
	if tile_damage_tracker.get(tile_pos):
		var calculated_hp: float = tile_damage_tracker.get(tile_pos) - mining_force
		_manage_hp_tracker(tile_pos, tile_hp, calculated_hp)
	else:
		var calculated_hp: float = tile_hp - mining_force
		_manage_hp_tracker(tile_pos, tile_hp, calculated_hp)

func _manage_hp_tracker(tile_pos: Vector2, tile_hp: float, calculated_hp: float) -> void:
	if calculated_hp <= 0:
		erase_cell(tile_pos)
		tile_damage_tracker.erase(tile_pos)
		destruction_tile_map.erase_cell(tile_pos)
	else:
		tile_damage_tracker[tile_pos] = calculated_hp
		var percent_damage: float = 100.0 - ((calculated_hp/tile_hp) * 100.0)
		
		destruction_tile_map.erase_cell(tile_pos)
		if percent_damage < 30.0:
			destruction_tile_map.set_cell(tile_pos, TileIds.DestructionTiles.LIGHT, Vector2i(0,0))
		elif percent_damage < 60.0:
			destruction_tile_map.set_cell(tile_pos, TileIds.DestructionTiles.MEDIUM, Vector2i(0,0))
		elif percent_damage < 100.0:
			destruction_tile_map.set_cell(tile_pos, TileIds.DestructionTiles.HEAVY, Vector2i(0,0))
