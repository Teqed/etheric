extends CharacterBody2D


const SPEED = 400.0
# const JUMP_VELOCITY = -400.0

# # Get the gravity from the project settings to be synced with RigidBody nodes.
# var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


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

	velocity = input_direction * SPEED

	move_and_slide()

	if Input.is_action_just_pressed("debug_00"):
		print("M key pressed")
		_read_cellmap()

	if Input.is_action_just_pressed("debug_01"):
		print("N key pressed")
		_change_cell(Vector2i(randi() % 10, randi() % 10))


func _read_cellmap():
	var tilemap = get_node("/root/Node2D/MarginContainer/PanelContainer/Node2D/TileMap_Abandoned")
	var map_size = tilemap.get_used_rect().size
	var map_layers = tilemap.get_layers_count()
	for y in range(map_size.y):
		for x in range(map_size.x):
			for z in range(map_layers):
				var tile_id = tilemap.get_cell_source_id(z, Vector2i(x, y))
				if tile_id == -1:
					print("No tile found at " + str(x) + ", " + str(y) + ", " + str(z))
				if tile_id != -1:
					var cellAtlas = tilemap.get_cell_atlas_coords(z, Vector2i(x, y))
					var celldata = {
						"tile_id": tile_id,
						"tile_position": Vector2i(x, y),
						"layer": z,
						"cellAtlas": cellAtlas,
					}
					print(celldata)

func _change_cell(newAtlasCoords):
	var tilemap = get_node("/root/Node2D/MarginContainer/PanelContainer/Node2D/TileMap_Abandoned")
	var newLayer = 0
	var newCoords = Vector2i(1, 1)
	var newSourceId = 0
	tilemap.set_cell(newLayer, newCoords, newSourceId, newAtlasCoords)
