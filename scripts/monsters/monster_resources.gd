# @tool
class_name Monster_Resources extends Resource

@export var tooltip: Monster_Resources_Tooltip = Monster_Resources_Tooltip.new()
@export var statpanel: Monster_Resources_Statpanel = Monster_Resources_Statpanel.new()
@export var appearance: Monster_Resources_Appearance = Monster_Resources_Appearance.new()
@export var moves: Array[Monster_Resources_Move] = [
	Monster_Resources_Move.new(),
	Monster_Resources_Move.new(),
	Monster_Resources_Move.new(),
	Monster_Resources_Move.new()]
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
	moves[0] = available_moves["move0"]
	moves[1] = available_moves["move1"]
	moves[2] = available_moves["move2"]
	moves[3] = available_moves["move3"]
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
		moves[0] = value
	elif key == "move1":
		moves[1] = value
	elif key == "move2":
		moves[2] = value
	elif key == "move3":
		moves[3] = value
