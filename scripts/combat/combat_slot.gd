class_name CombatSlot
extends Node2D

const SLOT_VECTOR_INITIAL: Dictionary = {
	0: Vector2(160, 992),
	1: Vector2(288, 1120),
	2: Vector2(160, 1120),
	3: Vector2(288, 992),
	4: Vector2(2848, 1056),
	5: Vector2(2848, 928),
	6: Vector2(2976, 1056),
	7: Vector2(2976, 928),
}

## Slot number, 0-7.
@export_range(0,7) var ordinal: int
## Assigned gamepiece, if any.
@export var monster: Gamepiece
var other_objects: Array = []
var occupied: bool = false
@onready var statpanel: Control = get_node("Statbar")
@onready var healthbar: TextureProgressBar = statpanel.get_node("%HealthBar")
@onready var energybar: TextureProgressBar = statpanel.get_node("%EnergyBar")
@onready var gamepiece_container: Node2D = get_node("%Gamepieces")
func _ready():
	add_to_group("slots")
	add_to_group("slot_" + str(ordinal))
	Events.populate_slot.connect(incoming_populate)
	Events.statpanel_updated.connect(update_statpanel)
	if monster:
		occupied = true
		var slot_position = monster.gameboard.pixel_to_cell(self.global_position)
		monster.get_node("%PassiveAiController").go_to_cell(slot_position)
	if not occupied:
		statpanel.visible = false
func incoming_populate(slot_ordinal: int, incoming_monster: Gamepiece):
	if slot_ordinal == ordinal:
		populate(incoming_monster)
func populate(incoming_monster: Gamepiece):
	if occupied:
		depopulate()
	self.monster = incoming_monster
	self.occupied = true
	statpanel.visible = true
	gamepiece_container.add_child(monster)
	monster.position = SLOT_VECTOR_INITIAL[ordinal]
	monster.get_node("%PassiveAiController").go_to_cell(
		monster.gameboard.pixel_to_cell(self.global_position))
func depopulate():
	monster.queue_free() # TODO: Send it to a nice farm.
	self.monster = null
	self.occupied = false
	statpanel.visible = false
func update_monster(key: String, value):
	self.monster.monster_resources.update_dictionary(key, value)
func get_monster():
	if occupied:
		return monster
	return null
func get_ordinal():
	return ordinal
func swap_monsters(other_slot):
	var temp_monster: Gamepiece = other_slot.get_monster()
	if occupied:
		other_slot.populate(monster)
	else:
		other_slot.depopulate()
	if temp_monster != null:
		populate(temp_monster)
	else:
		depopulate()

func child_pressed():
	if (occupied):
		if (ordinal > 3):
			Events.combat_selected_friendly_slot.emit(ordinal)
			print("Slot " + str(ordinal) + " selected.")

func update_statpanel(slot_ordinal: int, health_or_energy: bool, new_value: int):
	if slot_ordinal != ordinal:
		return
	if health_or_energy:
		healthbar.value = new_value
	else:
		energybar.value = new_value
