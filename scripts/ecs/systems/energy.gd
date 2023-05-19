## EnergySystem
# This system is responsible for updating the energy of all entities with an energy component.
# When an entity's energy reaches 1000, it is that entity's turn to take an action.
# Their energy is then reset to 0.
extends System
func _init(_world: World):
	name = &"EnergySystem"
	world = _world
func update():
	if enabled:
		var entities_with_component := world.get_ids_with_component(&"Energy")
		var energy_component := world.get_component(&"Energy")
		var speed_component := world.get_component(&"Speed")
		var name_component := world.get_component(&"Name")
		for id in entities_with_component:
			var name_int = name_component[id]
			var entity_name: String = world.NAMES_DICTIONARY[name_int]
			energy_component[id] += speed_component[id]
			if energy_component[id] > 1000:
				Events.combat_log_message.emit(entity_name + " is taking an action!")
				var enemy_opponent = world.get_component(&"Party")
				var id_pos = 0
				for enemy in enemy_opponent:
					if enemy != enemy_opponent[id]:
						var enemy_name_int = name_component[id_pos]
						var enemy_entity_name: String = world.NAMES_DICTIONARY[enemy_name_int]
						## Deal 10 damage by applying an incomingdamage component
						Events.combat_log_message.emit(entity_name + " is attacking " + enemy_entity_name)
						world.add_component_to(id_pos, &"IncomingDamage", 10)
					id_pos += 1
				energy_component[id] = 0
			var slot_ordinal = world.get_component(&"Slot")[id]
			@warning_ignore("integer_division")
			Events.statpanel_updated.emit(slot_ordinal, false, energy_component[id] / 10)
