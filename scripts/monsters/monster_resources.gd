
class_name Monster_Resources extends Resource

@export var tooltip: Monster_Resources_Tooltip = preload("res://resources/gamepieces/monster_resources/tooltips/default.tres")
@export var stats: Monster_Resources_Stats = preload("res://resources/gamepieces/monster_resources/stats/default.tres")
@export var moves: Monster_Resources_Moveset = preload("res://resources/gamepieces/monster_resources/movesets/default.tres")
# func fill_custom_monster(
# 		monster_name: String,
# 		description: String,
# 		health: int,
# 		energy: int,
# 		available_moves: Dictionary):
# 	tooltip["monster_name"] = monster_name
# 	tooltip["description"] = description
# 	stats["health"] = health
# 	stats["energy"] = energy
# 	moves.move0 = available_moves["move0"]
# 	moves.move1 = available_moves["move1"]
# 	moves.move2 = available_moves["move2"]
# 	moves.move3 = available_moves["move3"]
# func update_dictionary(key: String, value):
# 	if key == "monster_name":
# 		tooltip["monster_name"] = value
# 	elif key == "description":
# 		tooltip["description"] = value
# 	elif key == "health":
# 		stats["health"] = value
# 	elif key == "energy":
# 		stats["energy"] = value
# 	elif key == "move0":
# 		moves.move0 = value
# 	elif key == "move1":
# 		moves.move1 = value
# 	elif key == "move2":
# 		moves.move2 = value
# 	elif key == "move3":
# 		moves.move3 = value