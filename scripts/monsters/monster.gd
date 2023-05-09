# @tool
class_name Monster extends Node3D

var resources := Monster_Resources.new()
# var statpanel_node = load("res://scenes/statbar.tscn")
func fill_custom_monster(
		monster_name: String,
		description: String,
		health: int,
		energy: int,
		grid_position: Vector2,
		spriteatlas: Vector2,
		available_moves: Dictionary):
	resources = Monster_Resources.new().fill_custom_monster(
		monster_name,
		description,
		health,
		energy,
		grid_position,
		spriteatlas,
		available_moves)
func update_dictionary(key: String, value):
	resources.update_dictionary(key, value)
