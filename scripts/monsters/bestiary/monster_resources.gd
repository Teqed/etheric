
class_name Monster_Resources extends Resource

@export var tooltip: Monster_Resources_Tooltip = preload("res://scripts/monsters/tooltips/default.tres")
@export var statpanel: Monster_Resources_Statpanel = preload("res://scripts/monsters/statpanels/default.tres")
@export var appearance: Monster_Resources_Appearance = preload("res://scripts/monsters/appearances/default.tres")
@export var moves: Monster_Resources_Moveset = preload("res://scripts/monsters/movesets/default.tres")
func fill_custom_monster(
		monster_name: String,
		description: String,
		health: int,
		energy: int,
		grid_position: Vector2,
		spriteatlas: Vector2,
		available_moves: Dictionary):
	tooltip["monster_name"] = monster_name
	tooltip["description"] = description
	statpanel["health"] = health
	statpanel["energy"] = energy
	appearance["grid_position"] = grid_position
	appearance["spriteatlas"] = spriteatlas
	moves.move0 = available_moves["move0"]
	moves.move1 = available_moves["move1"]
	moves.move2 = available_moves["move2"]
	moves.move3 = available_moves["move3"]
func update_dictionary(key: String, value):
	if key == "monster_name":
		tooltip["monster_name"] = value
	elif key == "description":
		tooltip["description"] = value
	elif key == "health":
		statpanel["health"] = value
	elif key == "energy":
		statpanel["energy"] = value
	elif key == "grid_position":
		appearance["grid_position"] = value
	elif key == "spriteatlas":
		appearance["spriteatlas"] = value
	elif key == "move0":
		moves.move0 = value
	elif key == "move1":
		moves.move1 = value
	elif key == "move2":
		moves.move2 = value
	elif key == "move3":
		moves.move3 = value