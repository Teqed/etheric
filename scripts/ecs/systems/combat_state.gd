## CombatStateSystem
# This system is responsible for managing the state of combat.
# It is responsible for:
# - Adding the energy component to all entities with the party component
# - Removing the energy component from all entities when combat ends
# - Ending combat when all entities of a party have been defeated
extends System
func _init(_world: World):
	name = &"CombatStateSystem"
	world = _world
func update():
	if enabled:
		var singleton_combat_state = world.get_singleton_data("CombatState")
		match (singleton_combat_state):
			0:
				pass
			1:
				Events.scene_change.emit(Global.combat_scene, 0.4)
				var occupied_enemy_positions = []
				var occupied_friendly_positions = []
				# Add the energy component to all entities with the party component
				var entities_with_component_party = world.get_ids_with_component(&"Party")
				var party_component = world.get_component(&"Party")
				await (Events.scene_changed)
				for id in entities_with_component_party:
					if party_component[id] == 1:
						var position = occupied_friendly_positions.size()
						var friendly_position = position + 4
						if position <= 3:
							occupied_friendly_positions.append(position)
							world.set_component_of(id, &"Slot", friendly_position)
							world.add_component_to(id, &"Energy")
							Events.populate_slot.emit(friendly_position, Monster.new())
					else: if party_component[id] == 0:
						var position = occupied_enemy_positions.size()
						if position <= 3:
							occupied_enemy_positions.append(position)
							world.set_component_of(id, &"Slot", position)
							world.add_component_to(id, &"Energy")
							Events.populate_slot.emit(position, Monster.new())
				world.set_singleton(&"CombatState", 2)
			2:
				var entities_with_component_energy = world.get_ids_with_component(&"Energy")
				var friendly_entities_remaining = false
				var enemy_entities_remaining = false
				var party_component = world.get_component(&"Party")
				for id in entities_with_component_energy:
					if party_component[id] == 1:
						friendly_entities_remaining = true
					else: if party_component[id] == 0:
						enemy_entities_remaining = true
				if not friendly_entities_remaining:
					print("CombatStateSystem: All friendly entities have been defeated. Ending combat.")
					world.set_singleton(&"CombatState", 3)
				else: if not enemy_entities_remaining:
					print("CombatStateSystem: All enemy entities have been defeated. Ending combat.")
					world.set_singleton(&"CombatState", 3)
			3:
				var entities_with_component_energy = world.get_ids_with_component(&"Energy")
				entities_with_component_energy = world.get_ids_with_component(&"Energy")
				for id in entities_with_component_energy:
					world.remove_component_from(id, &"Energy")
					print("CombatStateSystem: Removing energy component from entity " + str(id) + ".")
				for i in range(0, 7):
					Events.depopulate_slot.emit(i)
				# TODO: Show the end of combat screen
				# TODO: Show loot, exp gain, etc.
				# TODO: Play a victory fanfare
				world.set_singleton(&"CombatState", 0)
				Events.scene_change.emit(Global.adventure_scene, 0.4)
