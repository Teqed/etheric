@tool
class_name Monster extends Node2D

var resources := Monster_Resources.new()
var statpanel_node = preload("res://scenes/statbar.tscn").instantiate()
func _init():
	add_child(statpanel_node)
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
