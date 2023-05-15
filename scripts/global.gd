extends Node

var ecs_world: World
var main_panel: PanelContainer
var adventure_scene: Node
var collection_scene: Node
var combat_scene: Node

## World for ECS. Contains all entities, components, and systems.
class World:
	var entities: PackedInt32Array
	var occupied_ids: int = -1
	var singleton: int
	var component_dictionary: Dictionary ## Dictionary<String, int>
	var component_data: Array ## Array<PackedInt32Array>
	var singleton_component_dictionary: Dictionary = {} ## Dictionary<String, int>
	var singleton_component_data: PackedInt32Array
	var systems: Dictionary = {} ## Dictionary<String, System>
	func add_entity() -> int:
		occupied_ids += 1
		entities[occupied_ids] = 0
		return occupied_ids
	func remove_entity(entity: int):
		for component in component_data:
			component.remove_at(entity)
		entities.remove_at(entity)
	func create_singleton(name: StringName, data: int = 0) -> int:
		var new_id := singleton_component_data.size()
		singleton_component_data.append(0)
		singleton_component_dictionary[name] = new_id
		singleton = singleton | (1 << new_id)
		singleton_component_data[new_id] = data
		return new_id
	func set_singleton(name: StringName, data: int):
		if (singleton & (1 << singleton_component_dictionary[name])) == 0:
			create_singleton(name, data)
		else:
			singleton_component_data[singleton_component_dictionary[name]] = data
	func get_singleton_data(name: StringName) -> int:
		return singleton_component_data[singleton_component_dictionary[name]]
	func create_component(name: StringName) -> int:
		var new_id := component_data.size()
		component_data.append(0)
		component_dictionary[name] = new_id
		return new_id
	func add_component(entity_id: int, name: StringName, data: int = 0):
		var component_id = component_dictionary[name]
		entities[entity_id] = entities[entity_id] | (1 << component_id)
		component_data[component_id][entity_id] = data
		return
	func set_component(entity_id: int, name: StringName, data: int):
		var component_id = component_dictionary[name]
		var entity_flags = entities[entity_id]
		if (entity_flags & (1 << component_id)) == 0:
			add_component(entity_id, name, data)
		else:
			component_data[component_id][entity_id] = data
	func remove_component(entity_id: int, name: StringName):
		var component_id = component_dictionary[name]
		var entity_flags = entities[entity_id]
		entity_flags = entity_flags & ~(1 << component_id)
		component_data[component_id][entity_id] = 0
	func get_component_id(name: String) -> int:
		var component_id = component_dictionary[name]
		return component_id
	func get_component_data(name: String) -> PackedInt32Array:
		var component_id = component_dictionary[name]
		return component_data[component_id]
	func get_ids_with_component(name: String) -> Array:
		var ids_with_component = []
		var component_id = component_dictionary[name]
		for entity_id in entities:
			if entities[entity_id] & (1 << component_id):
				ids_with_component.append(entity_id)
		return ids_with_component
	func get_ids_without_component(name: String) -> Array:
		var ids_without_component = []
		var component_id = component_dictionary[name]
		for entity_id in entities:
			if entities[entity_id] & (1 << component_id) == 0:
				ids_without_component.append(entity_id)
		return ids_without_component
	func add_system(system: System):
		systems[system.name] = system
	func update():
		for system in systems:
			systems[system].update()
	func enable(system_name: String):
		systems[system_name].enable()
	func disable(system_name: String):
		systems[system_name].disable()

class System:
	var name: String = "BlankSystem"
	var world: World
	var enabled: bool = false
	func _init(_world: World):
		world = _world
	func update():
		if enabled:
			pass
	func enable():
		enabled = true
	func disable():
		enabled = false

class EnergySystem extends System:
	var entities_with_component: Array
	var energy_component: PackedInt32Array
	var speed_component: PackedInt32Array
	func _init(_world: World):
		name = "EnergySystem"
		world = _world
		energy_component = world.get_component_data("Energy")
		speed_component = world.get_component_data("Speed")
	func update():
		if enabled:
			entities_with_component = world.get_ids_with_component("Energy")
			for id in entities_with_component:
				energy_component[id] += speed_component[id]
				if energy_component[id] > 1000:
					Events.combat_log_message.emit("Entity " + str(id) + " is taking an action!")
					energy_component[id] = 0
				var slot_ordinal = world.get_component("OrdinalPosition")[id]
				@warning_ignore("integer_division")
				Events.statpanel_updated.emit(slot_ordinal, false, energy_component[id] / 10)

class CombatStateSystem extends System:
	var entities_with_component_party: Array
	var entities_with_component_energy: Array
	var singleton_combat_state: int
	func _init(_world: World):
		name = "CombatStateSystem"
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

class CombatSlotSystem extends System:
	var entities_with_component_ordinal_position: Array
	var entities_with_component_party: Array
	var ordinal_position_component: PackedInt32Array
	var previous_ordinal_position_component: PackedInt32Array
	var party_component: PackedInt32Array
	func _init(_world: World):
		name = "CombatSlotSystem"
		world = _world
	func update():
		if enabled:
			ordinal_position_component = world.get_component("OrdinalPosition")
			if previous_ordinal_position_component != ordinal_position_component:
				previous_ordinal_position_component = ordinal_position_component
				entities_with_component_ordinal_position = world.get_ids_with_component("OrdinalPosition")
				entities_with_component_party = world.get_ids_with_component("Party")
				party_component = world.get_component("Party")
				for id in entities_with_component_ordinal_position:
					var position = ordinal_position_component[id]
					if party_component[id] == 1:
						Events.populate_slot.emit(position, Monster.new())
					else: if party_component[id] == 0:
						Events.populate_slot.emit(position, Monster.new())

class DamageSystem extends System:
	var entities_with_component_energy: Array
	var entities_with_component_incoming_damage: Array
	var entities_with_component_incoming_healing: Array
	func _init(_world: World):
		name = "DamageSystem"
		world = _world
	func update():
		# Consume all incoming damage components and apply them to their respective health components
		if enabled:
			entities_with_component_incoming_damage = world.get_ids_with_component("IncomingDamage")
			var health_component = world.get_component("Health")
			var incoming_damage_component = world.get_component("IncomingDamage")
			var incoming_healing_component = world.get_component("IncomingHealing")
			for id in entities_with_component_incoming_damage:
				world.set_component(id, "Health",
				health_component[id] - incoming_damage_component[id])
				world.remove_component(id, "IncomingDamage")
			entities_with_component_incoming_healing = world.get_ids_with_component("IncomingHealing")
			for id in entities_with_component_incoming_healing:
				world.set_component(id, "Health",
				health_component[id] + incoming_healing_component[id])
				world.remove_component(id, "IncomingHealing")
			entities_with_component_energy = world.get_ids_with_component("Energy")
			for id in entities_with_component_energy:
				if health_component[id] <= 0:
					world.remove_component(id, "Energy")
					print("DamageSystem: Entity " + str(id) + " has been defeated")

func _ready():
	ecs_world = World.new()

func create_new_world_data() -> Dictionary:
	ecs_world.create_component("Name");
	# ecs_world.create_component("Position_x"); # Group 0
	# ecs_world.create_component("Position_y"); # Group 0
	ecs_world.create_component("OrdinalPosition")
	ecs_world.create_component("Energy"); # Group 1
	ecs_world.create_component("Speed"); # Group 1
	ecs_world.create_component("Health");
	# ecs_world.create_component("Attack");
	ecs_world.create_component("IncomingDamage");
	ecs_world.create_component("IncomingHealing");
	# ecs_world.create_component("InCombat");
	ecs_world.create_component("Collection");
	ecs_world.create_component("Party");
	ecs_world.create_singleton("CombatState");
	ecs_world.add_system(EnergySystem.new(ecs_world))
	ecs_world.add_system(CombatStateSystem.new(ecs_world))
	ecs_world.add_system(DamageSystem.new(ecs_world))
	ecs_world.add_system(CombatSlotSystem.new(ecs_world))
	# ecs_world.add_system(PositionSystem.new(ecs_world))
	ecs_world.enable("EnergySystem")
	ecs_world.enable("CombatStateSystem")
	ecs_world.enable("DamageSystem")
	ecs_world.enable("CombatSlotSystem")
	return ecs_world.serialize()

func _process(_delta):
	if Input.is_action_just_pressed("debug_00"):
		Events.scene_change.emit(Global.combat_scene, 0.4)
		Global.ecs_world.set_singleton("CombatState", 1)
	if Input.is_action_just_pressed("debug_01"):
		Events.scene_change.emit(Global.adventure_scene, 0.4)
