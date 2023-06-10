## CombatSlotSystem
# This system is responsible for populating the combat slots with monsters.
# It listens for the OrdinalPosition component and populates the slot with a monster.
# It triggers whenever the OrdinalPosition component changes.
extends System
# var slime: Gamepiece = preload(
# 	"res://scenes/adventure/characters/bestiary/slime.tscn").instantiate();
var previous_ordinal_position_component: PackedInt32Array = PackedInt32Array()
func _init(_world: World):
	name = &"CombatSlotSystem"
	world = _world
func update():
	if enabled:
		var ordinal_position_component = world.get_component(&"Slot")
		if previous_ordinal_position_component != ordinal_position_component:
			previous_ordinal_position_component = ordinal_position_component
			var entities_with_component_ordinal_position = world.get_ids_with_component(&"Slot")
			var party_component = world.get_component(&"Party")
			for id in entities_with_component_ordinal_position:
				# var position = ordinal_position_component[id]
				if party_component[id] == 1:
					pass
					# Events.populate_slot.emit(position, slime)
				else: if party_component[id] == 0:
					pass
					# Events.populate_slot.emit(position, slime)
