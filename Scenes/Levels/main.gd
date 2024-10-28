extends Node2D

@onready var tile_map : Terrain = $BaseTerrain

const WIDTH : float = 500  # World width in tiles
const HEIGHT : float = 400  # World height in tiles
const SURFACE_LEVEL : float = 20  # Where ground starts
const DIRT_DEPTH : float = 12  # How deep the dirt layer goes
const CAVE_CHANCE : float = 0.45  # Probability of cave generation

const START_X : float = -WIDTH / 2
const END_X : float = WIDTH / 2

var noise: FastNoiseLite

func _ready() -> void:
	# Initialize noise generator for terrain
	noise = FastNoiseLite.new()
	noise.seed = randi()  # Random seed each time
	noise.frequency = 0.05
	
	generate_terrain()

func generate_terrain() -> void:
	# Generate the basic terrain shape
	for x in range(START_X, END_X):
		var noise_x: float = x + WIDTH/2
		# Generate surface height using noise
		var surface_height: float = SURFACE_LEVEL + int(noise.get_noise_1d(noise_x) * 10)
		
		for y in range(HEIGHT):
			if y < surface_height:
				# Above ground is air
				continue
			elif y == surface_height:
				# Surface level is grass
				place_tile(Vector2i(x, y), TileIds.Terrain.GRASS)
			elif y < surface_height + DIRT_DEPTH:
				# Dirt layer
				place_tile(Vector2i(x, y), TileIds.Terrain.DIRT)
			else:
				# Stone layer
				place_tile(Vector2i(x, y), TileIds.Terrain.STONE)
	
	generate_caves()

func generate_caves() -> void:
	# Initialize new noise for cave generation
	var cave_noise: FastNoiseLite = FastNoiseLite.new()
	cave_noise.seed = randi()
	cave_noise.frequency = 0.1
	
	for x in range(START_X, END_X):
		var noise_x: float = x + WIDTH/2
		
		for y in range(SURFACE_LEVEL + DIRT_DEPTH, HEIGHT):
			# Only generate caves below dirt layer
			var noise_val: float = cave_noise.get_noise_2d(noise_x, y)
			if noise_val > CAVE_CHANCE:
				# Create cave by removing tile
				tile_map.set_cell(Vector2i(x, y), -1)

func place_tile(pos: Vector2i, tile_type: int) -> void:
	# Place tile at position with specified type
	tile_map.set_cell(pos, tile_type, Vector2i(0, 0))
