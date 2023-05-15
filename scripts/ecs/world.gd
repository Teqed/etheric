
## World for ECS. Contains all entities, components, and systems.
class_name World
const EnergySystem := preload("res://scripts/ecs/systems/energy.gd")
const CombatStateSystem := preload("res://scripts/ecs/systems/combat_state.gd")
const DamageSystem := preload("res://scripts/ecs/systems/damage.gd")
const CombatSlotSystem := preload("res://scripts/ecs/systems/combat_slot.gd")
var entities: PackedInt32Array
var occupied_ids: int = -1
var singleton: int
var component_dictionary: Dictionary ## Dictionary<String, int>
var component_data: Array ## Array<PackedInt32Array>
var singleton_component_dictionary: Dictionary = {} ## Dictionary<String, int>
var singleton_component_data: PackedInt32Array
var systems: Dictionary = {} ## Dictionary<String, System>
func _init():
	add_system(EnergySystem.new(self))
	enable(&"EnergySystem")
	add_system(CombatStateSystem.new(self))
	enable(&"CombatStateSystem")
	add_system(DamageSystem.new(self))
	enable(&"DamageSystem")
	add_system(CombatSlotSystem.new(self))
	enable(&"CombatSlotSystem")

################################
### 	Entities 			###
################################

### Adds an entity to the world
## Automatically generates an id for the entity
## Returns the id of the entity
func add_entity() -> int:
	occupied_ids += 1
	entities[occupied_ids] = 0
	return occupied_ids
### Removes an entity from the world
## Removes all components from the entity
func remove_entity(entity: int):
	for component in component_data:
		component.remove_at(entity)
	entities.remove_at(entity)

################################
### 	Singletons 			###
################################

### Creates a singleton component
## Singleton components are components that only have one instance
## Singleton components are not attached to entities
## Automatically generates an id for the singleton component
## Returns the id of the new singleton component
func create_singleton(name: StringName, data: int = 0) -> int:
	var new_id := singleton_component_data.size()
	singleton_component_data.append(0)
	singleton_component_dictionary[name] = new_id
	singleton = singleton | (1 << new_id)
	singleton_component_data[new_id] = data
	return new_id
### Sets the data of a singleton component
func set_singleton(name: StringName, data: int):
	if (singleton & (1 << singleton_component_dictionary[name])) == 0:
		create_singleton(name, data)
	else:
		singleton_component_data[singleton_component_dictionary[name]] = data
### Gets the data of a singleton component
## Returns the data of the singleton component
func get_singleton_data(name: StringName) -> int:
	return singleton_component_data[singleton_component_dictionary[name]]

################################
### 	Components 			###
################################

### Creates a component
## Automatically generates an id for the component
## Returns the id of the new component
func create_component(name: StringName) -> int:
	var new_id := component_data.size()
	component_data.append(0)
	component_dictionary[name] = new_id
	return new_id
### Adds a component to an entity
## Optionally sets the data of the component
func add_component(entity_id: int, name: StringName, data: int = 0):
	var component_id = component_dictionary[name]
	entities[entity_id] = entities[entity_id] | (1 << component_id)
	component_data[component_id][entity_id] = data
	return
### Sets the data of a component
func set_component(entity_id: int, name: StringName, data: int):
	var component_id = component_dictionary[name]
	var entity_flags = entities[entity_id]
	if (entity_flags & (1 << component_id)) == 0:
		add_component(entity_id, name, data)
	else:
		component_data[component_id][entity_id] = data
### Removes a component from an entity
## Sets the data to 0 and removes the component flag from the entity
func remove_component(entity_id: int, name: StringName):
	var component_id = component_dictionary[name]
	var entity_flags = entities[entity_id]
	entity_flags = entity_flags & ~(1 << component_id)
	component_data[component_id][entity_id] = 0
### Gets the id of a component
## Returns the id of the component
func get_component_id(name: String) -> int:
	var component_id = component_dictionary[name]
	return component_id
### Gets the data of a component
## Using entity ids, you can navigate the component data
## Returns the data of the component as PackedInt32Array
func get_component_data(name: String) -> PackedInt32Array:
	var component_id = component_dictionary[name]
	return component_data[component_id]
### Gets all entity ids that match a component
## Returns an array of entity ids
func get_ids_with_component(name: String) -> Array:
	var ids_with_component = []
	var component_id = component_dictionary[name]
	for entity_id in entities:
		if entities[entity_id] & (1 << component_id):
			ids_with_component.append(entity_id)
	return ids_with_component
### Gets all entity ids that do NOT match a component
## Returns an array of entity ids
func get_ids_without_component(name: String) -> Array:
	var ids_without_component = []
	var component_id = component_dictionary[name]
	for entity_id in entities:
		if entities[entity_id] & (1 << component_id) == 0:
			ids_without_component.append(entity_id)
	return ids_without_component

################################
### 	Systems 			###
################################

### Adds a system to the world
## This will allow it to be updated
func add_system(system: System):
	systems[system.name] = system
### Updates all systems
## Iterates through all systems in the world and updates them
func update():
	for system in systems:
		systems[system].update()
### Enables a system
func enable(system_name: String):
	systems[system_name].enable()
### Disables a system
func disable(system_name: String):
	systems[system_name].disable()
