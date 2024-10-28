extends Node

const INVALID= "Invalid"

enum Terrain {
	GRASS,
	DIRT,
	STONE,
}

enum DestructionTiles {
	LIGHT,
	MEDIUM,
	HEAVY,
}

const terrain_hp = {
	"GRASS": 5,
	"DIRT": 5,
	"STONE": 10,
}

func _get_terrain_type_from_index(index: int) -> String:
	var terrain_type_keys: Array = Terrain.keys()
	
	if index >= 0 and index < terrain_type_keys.size():
		return terrain_type_keys[index]
	
	return INVALID
