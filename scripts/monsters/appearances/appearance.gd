
class_name Monster_Resources_Appearance extends Resource

@export var grid_position := Vector2(0, 0) # The position of the sprite in the sprite atlas
@export var spriteatlas := Vector2(0, 0) # The sprite atlas to use


func _init(arg_grid_position := grid_position, arg_spriteatlas := spriteatlas):
	grid_position = arg_grid_position
	spriteatlas = arg_spriteatlas