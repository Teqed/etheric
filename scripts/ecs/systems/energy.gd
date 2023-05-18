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
		for id in entities_with_component:
			energy_component[id] += speed_component[id]
			print("Updating energy for entity " + str(id) + " to " + str(energy_component[id]))
			if energy_component[id] > 1000:
				Events.combat_log_message.emit("Entity " + str(id) + " is taking an action!")
				var enemy_opponent = world.get_component(&"Party")
				var id_pos = 0
				for enemy in enemy_opponent:
					if enemy != enemy_opponent[id]:
						## Deal 10 damage by applying an incomingdamage component
						Events.combat_log_message.emit("Entity " + str(id) + " is attacking entity " + str(id_pos))
						world.add_component_to(id_pos, &"IncomingDamage", 10)
					id_pos += 1
				energy_component[id] = 0
			var slot_ordinal = world.get_component(&"OrdinalPosition")[id]
			@warning_ignore("integer_division")
			Events.statpanel_updated.emit(slot_ordinal, false, energy_component[id] / 10)
