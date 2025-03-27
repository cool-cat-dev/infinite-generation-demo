extends TileMap

var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()


const CHUNK_SIZE = 256  # Number of tiles per chunk (width & height)
const TILE_SIZE = 16  # Each tile’s size in pixels
const CHUNK_LOAD_THRESHOLD = 1000  # Distance from edge before a new chunk spawns

const GRASS_TILES = [Vector2(0, 0), Vector2(1, 0)]
const ROCK_TILE = Vector2(1, 1)
const WATER_TILE = Vector2(0, 1)

@export var player: CharacterBody2D
@onready var position_label = $CanvasLayer/PositionLabel

var generated_chunks = {}  # Keeps track of generated chunks
var chunk_queue = []  # Chunks waiting to be generated

func _ready():
	_initialize_noise()
	generate_chunk(Vector2i(0, 0))  # Generate the first chunk

func _physics_process(delta):
	check_chunk_loading()  # Check if we need a new chunk
	process_chunk_queue()  # Process chunks gradually
	update_position_label()  # Show debug info


func _initialize_noise():
	moisture.seed = randi()
	temperature.seed = randi()
	altitude.seed = randi()

func generate_chunk(chunk_pos: Vector2i):
	if chunk_pos in generated_chunks:
		return  # Skip if chunk already exists
	generated_chunks[chunk_pos] = true
	chunk_queue.append(chunk_pos)  # Add to queue for processing

func process_chunk_queue():
	if chunk_queue.is_empty():
		return

	var chunk_pos = chunk_queue.pop_front()
	var chunk_offset = chunk_pos * CHUNK_SIZE  # Convert to world coordinates
	
	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			var world_x = chunk_offset.x + x
			var world_y = chunk_offset.y + y

			# Generate terrain based on noise
			var alt = altitude.get_noise_2d(world_x, world_y) * 10
			var moist = moisture.get_noise_2d(world_x, world_y) * 10

			var atlas_coords = WATER_TILE if alt < 2 else ROCK_TILE if alt >= 2 and moist > 4 else GRASS_TILES[randi() % GRASS_TILES.size()]

			set_cell(0, Vector2i(world_x, world_y), 0, atlas_coords)

func check_chunk_loading():
	if not is_instance_valid(player):
		return

	var player_chunk = Vector2i(
		floor(player.global_position.x / (CHUNK_SIZE * TILE_SIZE)),
		floor(player.global_position.y / (CHUNK_SIZE * TILE_SIZE))
	)
	
	var local_x = posmod(player.global_position.x, CHUNK_SIZE * TILE_SIZE)
	var local_y = posmod(player.global_position.y, CHUNK_SIZE * TILE_SIZE)

	if local_x < CHUNK_LOAD_THRESHOLD:
		generate_chunk(player_chunk + Vector2i(-1, 0))  # Left
	elif local_x > (CHUNK_SIZE * TILE_SIZE - CHUNK_LOAD_THRESHOLD):
		generate_chunk(player_chunk + Vector2i(1, 0))  # Right

	if local_y < CHUNK_LOAD_THRESHOLD:
		generate_chunk(player_chunk + Vector2i(0, -1))  # Top
	elif local_y > (CHUNK_SIZE * TILE_SIZE - CHUNK_LOAD_THRESHOLD):
		generate_chunk(player_chunk + Vector2i(0, 1))  # Bottom


func update_position_label():
	if is_instance_valid(player):
		var chunk_x = floor(player.global_position.x / (CHUNK_SIZE * TILE_SIZE))
		var chunk_y = floor(player.global_position.y / (CHUNK_SIZE * TILE_SIZE))
		position_label.text = "Player Pos: (%d, %d)\nCurrent Chunk: (%d, %d)" % [player.global_position.x, player.global_position.y, chunk_x, chunk_y]


