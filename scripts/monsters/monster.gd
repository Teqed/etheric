# @tool
class_name Monster extends Node3D

var resources: Monster_Resources
func _init(
		monster_name: String,
		description: String,
		health: int,
		energy: int,
		grid_position: Vector2,
		spriteatlas: Vector2,
		available_moves: Dictionary):
	resources = Monster_Resources.new(
		monster_name,
		description,
		health,
		energy,
		grid_position,
		spriteatlas,
		available_moves)
func update_dictionary(key: String, value):
	if key == "monster_name":
		resources.tooltip["monster_name"] = value
	elif key == "description":
		resources.tooltip["description"] = value
	elif key == "health":
		resources.statpanel["health"] = value
	elif key == "energy":
		resources.statpanel["energy"] = value
	elif key == "grid_position":
		resources.appearance["grid_position"] = value
	elif key == "spriteatlas":
		resources.appearance["spriteatlas"] = value
	elif key == "move0":
		resources.moves["move0"] = value
	elif key == "move1":
		resources.moves["move1"] = value
	elif key == "move2":
		resources.moves["move2"] = value
	elif key == "move3":
		resources.moves["move3"] = value
