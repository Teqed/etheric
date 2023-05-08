# @tool
extends Node2D

@export_range(0,7) var ordinal: int # Between 0 and 7, inclusive.
var other_objects: Array = []
var occupied: bool = false
var monster: Monster = null
func _ready():
	if ordinal == 0:
		self.position = Vector2(128,384)
	elif ordinal == 1:
		self.position = Vector2(320,384)
	elif ordinal == 2:
		self.position = Vector2(512,384)
	elif ordinal == 3:
		self.position = Vector2(704,384)
	elif ordinal == 4:
		self.position = Vector2(1152,384)
	elif ordinal == 5:
		self.position = Vector2(1344,384)
	elif ordinal == 6:
		self.position = Vector2(1536,384)
	elif ordinal == 7:
		self.position = Vector2(1728,384)
func populate(incoming_monster: Monster):
	self.monster = incoming_monster
	self.occupied = true
func depopulate():
	self.monster = null
	self.occupied = false
func update_monster(key: String, value):
	self.monster.update_dictionary(key, value)
func get_monster():
	if occupied:
		return monster
	return null
func get_ordinal():
	return ordinal
func swap_monsters(other_slot):
	var temp_monster: Monster = other_slot.get_monster()
	if occupied:
		other_slot.populate(monster)
	else:
		other_slot.depopulate()
	if temp_monster != null:
		populate(temp_monster)
	else:
		depopulate()

class Monster:
	var tooltip: Dictionary = {"name":"","description":""}
	var statpanel: Dictionary = {"health":0,"energy":0}
	var appearance: Dictionary = {"position":Vector2(0,0),"spriteatlas":Vector2(0,0)}
	var move: Dictionary = {"name":"","description":""}
	var moves: Dictionary = {"move0":move,"move1":move,"move2":move,"move3":move}

	func _init(
			name: String,
			description: String,
			health: int,
			energy: int,
			position: Vector2,
			spriteatlas: Vector2,
			available_moves: Dictionary):
		tooltip["name"] = name
		tooltip["description"] = description
		statpanel["health"] = health
		statpanel["energy"] = energy
		appearance["position"] = position
		appearance["spriteatlas"] = spriteatlas
		moves["move0"] = available_moves["move0"]
		moves["move1"] = available_moves["move1"]
		moves["move2"] = available_moves["move2"]
		moves["move3"] = available_moves["move3"]

	func update_dictionary(key: String, value):
		if key == "name":
			tooltip["name"] = value
		elif key == "description":
			tooltip["description"] = value
		elif key == "health":
			statpanel["health"] = value
		elif key == "energy":
			statpanel["energy"] = value
		elif key == "position":
			appearance["position"] = value
		elif key == "spriteatlas":
			appearance["spriteatlas"] = value
		elif key == "move0":
			moves["move0"] = value
		elif key == "move1":
			moves["move1"] = value
		elif key == "move2":
			moves["move2"] = value
		elif key == "move3":
			moves["move3"] = value
