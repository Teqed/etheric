@tool
extends Node2D

@export_range(0,7) var ordinal: int # Between 0 and 7, inclusive.
var other_objects: Array = []
var occupied: bool = false
var monster: Monster = null
func _ready():
	add_to_group("slots")
	if ordinal == 0:
		self.position = Vector2(128,384)
		add_to_group("slot_0")
	elif ordinal == 1:
		self.position = Vector2(320,384)
		add_to_group("slot_1")
	elif ordinal == 2:
		self.position = Vector2(512,384)
		add_to_group("slot_2")
	elif ordinal == 3:
		self.position = Vector2(704,384)
		add_to_group("slot_3")
	elif ordinal == 4:
		self.position = Vector2(1152,384)
		add_to_group("slot_4")
	elif ordinal == 5:
		self.position = Vector2(1344,384)
		add_to_group("slot_5")
	elif ordinal == 6:
		self.position = Vector2(1536,384)
		add_to_group("slot_6")
	elif ordinal == 7:
		self.position = Vector2(1728,384)
		add_to_group("slot_7")
	if (true):
		# Populate some temporary monsters for testing purposes.
		var temp_monster: Monster = Monster.new()
		populate(temp_monster)
func populate(incoming_monster: Monster):
	self.monster = incoming_monster
	self.occupied = true
	add_child(monster)
func depopulate():
	monster.queue_free()
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
