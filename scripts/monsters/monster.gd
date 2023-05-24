
class_name Monster extends CharacterBody2D

var resources := Monster_Resources.new()
var statpanel_node = preload("res://scenes/statbar.tscn").instantiate()
var dummymonster_node = preload("res://scenes/DummyMonster.tscn").instantiate()
var deltaAccumulate = 0
func _init():
	add_child(statpanel_node)
	add_child(dummymonster_node)
	dummymonster_node.scale = Vector2(4, 4)
	dummymonster_node.position = Vector2(32, 32)
# func _process(delta):
# 	#  acculmulate delta
# 	deltaAccumulate += delta
# 	if (deltaAccumulate >= 0.1):
# 		deltaAccumulate = 0
# 		#  update energy bar
# 		if (statpanel_node.get_node("%EnergyBar").value >= 100):
# 			statpanel_node.get_node("%EnergyBar").value = 0
# 		statpanel_node.get_node("%EnergyBar").value += 1
func fill_custom_monster(
		monster_name: String,
		description: String,
		health: int,
		energy: int,
		gameboard_position: Vector2,
		spriteatlas: Vector2,
		available_moves: Dictionary):
	resources = Monster_Resources.new().fill_custom_monster(
		monster_name,
		description,
		health,
		energy,
		gameboard_position,
		spriteatlas,
		available_moves)
	return self
func update_dictionary(key: String, value):
	resources.update_dictionary(key, value)
	return self
