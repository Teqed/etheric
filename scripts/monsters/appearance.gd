class_name Monster_Resources_Appearance extends Resource

var this_grid_position := Vector2(0, 0) # The position of the sprite in the sprite atlas
var this_spriteatlas := Vector2(0, 0) # The sprite atlas to use

@export var grid_position := this_grid_position
@export var spriteatlas := this_spriteatlas


func _init(arg_grid_position := this_grid_position, arg_spriteatlas := this_spriteatlas):
	grid_position = arg_grid_position
	spriteatlas = arg_spriteatlas