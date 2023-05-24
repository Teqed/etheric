
class_name Monster_Resources_Appearance extends Resource

@export var gameboard_position := Vector2(0, 0) # The position of the sprite in the sprite atlas
@export var spriteatlas := Vector2(0, 0) # The sprite atlas to use


func _init(arg_gameboard_position := gameboard_position, arg_spriteatlas := spriteatlas):
	gameboard_position = arg_gameboard_position
	spriteatlas = arg_spriteatlas