extends Node2D

@onready var tile_map : Terrain = $BaseTerrain

const WIDTH: float = 1024  # World width in tiles
const HEIGHT: float = 512  # World height in tiles
const SURFACE_LEVEL: float = 32  # Where ground starts
const DEEP_CAVE: float = (HEIGHT - SURFACE_LEVEL) / 4 # 120 in this case 
const CORE: float = HEIGHT - SURFACE_LEVEL
const DIRT_DEPTH: float = 7  # How deep the dirt layer goes
const TERRAIN_AMPLITUDE: float = 25.0
const CAVE_VARIANCE: float = 0.025

const START_X : float = -WIDTH / 2
const END_X : float = WIDTH / 2

var noise: FastNoiseLite
var cave_noise: FastNoiseLite

func _ready() -> void:
	# Initialize noise generator for terrain
	noise = FastNoiseLite.new()
	noise.seed = randi()  # Random seed each time
	noise.frequency = 1.0 / 128
	noise.fractal_octaves = 4
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	
	generate_terrain()

func generate_terrain() -> void:
	# Generate the basic terrain shape
	# Like a CRT TV
	for x in range(START_X, END_X):
		var noise_x: float = x + WIDTH/2
		# Generate surface height using noise
		var surface_height: float = SURFACE_LEVEL + int(noise.get_noise_1d(noise_x) * TERRAIN_AMPLITUDE)
		var dirt_depth_variance: int = randi_range(DIRT_DEPTH - 1, DIRT_DEPTH)
		
		for y in range(HEIGHT):
			if y < surface_height:
				# Above ground is air
				continue
			elif y == surface_height:
				# Surface level is grass
				place_tile(Vector2i(x, y), TileIds.Terrain.GRASS)
			elif y < surface_height + dirt_depth_variance:
				# Dirt layer
				place_tile(Vector2i(x, y), TileIds.Terrain.DIRT)
			else:
				# Stone layer
				place_tile(Vector2i(x, y), TileIds.Terrain.STONE)
	
	generate_caves()

func generate_caves() -> void:
	# Initialize new noise for cave generation
	cave_noise = FastNoiseLite.new()
	cave_noise.seed = randi()
	cave_noise.frequency = 1.0 / 128
	noise.fractal_octaves = 4
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	
	for x in range(START_X, END_X):
		var noise_x: float = x + WIDTH/2
		var dirt_depth_variance: int = randi_range(DIRT_DEPTH - 1, DIRT_DEPTH)
		
		for y in range(SURFACE_LEVEL + dirt_depth_variance, HEIGHT):
			# Only generate caves below dirt layer
			var noise_val: float = cave_noise.get_noise_2d(noise_x, y)
			if y < DEEP_CAVE:
				# Between Dirt and deeper cave
				if abs(noise_val) < CAVE_VARIANCE:
					tile_map.set_cell(Vector2i(x, y), -1)
			elif y < CORE:
				# Deep Cave Region
				if abs(noise_val) < CAVE_VARIANCE * 4:
					tile_map.set_cell(Vector2i(x, y), -1)
			elif y < CORE + 16:
				tile_map.set_cell(Vector2i(x, y), -1)

func place_tile(pos: Vector2i, tile_type: int) -> void:
	# Place tile at position with specified type
	tile_map.set_cell(pos, tile_type, Vector2i(0, 0))
