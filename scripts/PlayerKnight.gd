extends CharacterBody2D

const SPEED = 200.0

var sprite: Sprite2D

# const JUMP_VELOCITY = -400.0

# # Get the gravity from the project settings to be synced with RigidBody nodes.
# var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	sprite = self.get_node("%Sprite2D")

func _physics_process(_delta):
	# Add the gravity.
	# if not is_on_floor():
	# 	velocity.y += gravity * delta

	# Handle Jump.
	# if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	# 	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# var direction = Input.get_axis("ui_left", "ui_right")
	# if direction:
	# 	velocity.x = direction * SPEED
	# else:
	# 	velocity.x = move_toward(velocity.x, 0, SPEED)

	# move_and_slide()

	var input_direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

	# Flip the sprite by changing the frame to 1 or 0.
	if input_direction.x > 0:
		sprite.set_frame(0)
	else: if input_direction.x < 0:
		sprite.set_frame(1)

	velocity = input_direction * SPEED

	move_and_slide()

	if Input.is_action_just_pressed("debug_00"):
		print("M key pressed")
		var tilemap = get_node("/root/TileMapRoot/TileMap")
		var new_layer = 3
		var new_coords = Vector2i(10, 10)
		var new_source_id = 2
		var new_atlas_coords = Vector2i(0, 0)
		var new_alternative_tile = 1
		tilemap.set_cell(new_layer, new_coords, new_source_id, new_atlas_coords, new_alternative_tile)
		# _read_cellmap()

	if Input.is_action_just_pressed("debug_01"):
		print("N key pressed")
		# _change_cell(Vector2i(randi() % 10, randi() % 10))
		var tilemap = get_node("/root/TileMapRoot/TileMap")
		var new_layer = 3
		var new_coords = Vector2i(10, 10)
		var new_source_id = 2
		var new_atlas_coords = Vector2i(0, 0)
		var new_alternative_tile = 2
		tilemap.set_cell(new_layer, new_coords, new_source_id, new_atlas_coords, new_alternative_tile)

	# Log the current tile position
	# var tilemap = get_node("/root/TileMapRoot/TileMap")
	# var tile_position = tilemap.local_to_map(position)
	# print("Tile position: " + str(tile_position))


func _read_cellmap():
	var tilemap = get_node("/root/TileMapRoot/TileMap")
	var map_size = tilemap.get_used_rect().size
	var map_layers = tilemap.get_layers_count()
	for y in range(map_size.y):
		for x in range(map_size.x):
			for z in range(map_layers):
				var tile_id = tilemap.get_cell_source_id(z, Vector2i(x, y))
				if tile_id == -1:
					print("No tile found at " + str(x) + ", " + str(y) + ", " + str(z))
				if tile_id != -1:
					var cell_atlas = tilemap.get_cell_atlas_coords(z, Vector2i(x, y))
					var celldata = {
						"tile_id": tile_id,
						"tile_position": Vector2i(x, y),
						"layer": z,
						"cellAtlas": cell_atlas,
					}
					print(celldata)

func _change_cell(new_atlas_coords):
	var tilemap = get_node("/root/TileMapRoot/TileMap")
	var new_layer = 0
	var new_coords = Vector2i(1, 1)
	var new_source_id = 0
	tilemap.set_cell(new_layer, new_coords, new_source_id, new_atlas_coords)
