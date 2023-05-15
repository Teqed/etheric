extends System
var entities_with_component_party: Array
var entities_with_component_energy: Array
var singleton_combat_state: int
func _init(_world: World):
	name = &"CombatStateSystem"
	world = _world
	singleton_combat_state = world.get_singleton_data("CombatState")
func update():
	if enabled:
		singleton_combat_state = world.get_singleton_data("CombatState")
		match (singleton_combat_state):
			1:
				var occupied_enemy_positions = []
				var occupied_friendly_positions = []
				# Add the energy component to all entities with the party component
				entities_with_component_party = world.get_ids_with_component("Party")
				var party_component = world.get_component("Party")
				for id in entities_with_component_party:
					if party_component[id] == 1:
						var position = occupied_friendly_positions.size()
						var friendly_position = position + 4
						if position <= 3:
							occupied_friendly_positions.append(position)
							world.set_component(id, "OrdinalPosition", friendly_position)
							world.add_component(id, "Energy")
							Events.populate_slot.emit(friendly_position, Monster.new())
					else: if party_component[id] == 0:
						var position = occupied_enemy_positions.size()
						if position <= 3:
							occupied_enemy_positions.append(position)
							world.set_component(id, "OrdinalPosition", position)
							world.add_component(id, "Energy")
							Events.populate_slot.emit(position, Monster.new())
				world.set_singleton("CombatState", 2)
			2:
				entities_with_component_energy = world.get_ids_with_component("Energy")
				var friendly_entities_remaining = false
				var enemy_entities_remaining = false
				var party_component = world.get_component("Party")
				for id in entities_with_component_energy:
					if party_component[id] == 1:
						friendly_entities_remaining = true
					else: if party_component[id] == 0:
						enemy_entities_remaining = true
				if not friendly_entities_remaining:
					print("CombatStateSystem: All friendly entities have been defeated. Ending combat.")
					entities_with_component_energy = world.get_ids_with_component("Energy")
					for id in entities_with_component_energy:
						world.remove_component(id, "Energy")
					world.set_singleton("CombatState", 0)
				else: if not enemy_entities_remaining:
					print("CombatStateSystem: All enemy entities have been defeated. Ending combat.")
					entities_with_component_energy = world.get_ids_with_component("Energy")
					for id in entities_with_component_energy:
						world.remove_component(id, "Energy")
					world.set_singleton("CombatState", 0)
				for i in range(0, 7):
					Events.depopulate_slot.emit(i)