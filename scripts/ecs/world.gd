
## World for ECS. Contains all entities, components, and systems.
class_name World
const EnergySystem := preload("res://scripts/ecs/systems/energy.gd")
const CombatStateSystem := preload("res://scripts/ecs/systems/combat_state.gd")
const DamageSystem := preload("res://scripts/ecs/systems/damage.gd")
const CombatSlotSystem := preload("res://scripts/ecs/systems/combat_slot.gd")
var entities: PackedInt32Array
var singleton: int
var component_dictionary: Dictionary ## Dictionary<String, int>
var component_data: Array ## Array<PackedInt32Array>
var singleton_component_dictionary: Dictionary = {} ## Dictionary<String, int>
var singleton_component_data: PackedInt32Array
var systems: Dictionary = {} ## Dictionary<String, System>
func _init():
	add_system(EnergySystem.new(self))
	add_system(CombatStateSystem.new(self))
	add_system(DamageSystem.new(self))
	add_system(CombatSlotSystem.new(self))
	enable(&"EnergySystem")
	enable(&"CombatStateSystem")
	enable(&"DamageSystem")
	enable(&"CombatSlotSystem")

################################
### 	Serialization		###
################################

func create_new_world_data() -> World:
	create_component(&"Name");
	create_component(&"OrdinalPosition")
	create_component(&"Energy");
	create_component(&"Speed");
	create_component(&"Health");
	create_component(&"IncomingDamage");
	create_component(&"IncomingHealing");
	create_component(&"Collection");
	create_component(&"Party");
	create_singleton(&"CombatState");
	return self

func serialize() -> Dictionary:
	var world_data = {}
	world_data["entities"] = entities
	world_data["singleton"] = singleton
	world_data["component_dictionary"] = component_dictionary
	world_data["component_data"] = component_data
	world_data["singleton_component_dictionary"] = singleton_component_dictionary
	world_data["singleton_component_data"] = singleton_component_data
	return world_data

func deserialize(world_data) -> World:
	entities.clear()
	for entity in world_data["entities"]:
		entities.append(entity)
	# singleton = world_data["singleton"]
	singleton = 0
	# component_dictionary = world_data["component_dictionary"]
	component_dictionary.clear()
	for component in world_data["component_dictionary"]:
		component_dictionary[component] = world_data["component_dictionary"][component]
	component_data.clear()
	for component in world_data["component_data"]:
		component_data.append(PackedInt32Array())
		component_data[component_data.size() - 1].append_array(component)
	# singleton_component_dictionary = world_data["singleton_component_dictionary"]
	singleton_component_dictionary.clear()
	for singleton_component in world_data["singleton_component_dictionary"]:
		singleton_component_dictionary[singleton_component] = (
			world_data["singleton_component_dictionary"][singleton_component])
	singleton_component_data.clear()
	for singleton_component in world_data["singleton_component_data"]:
		singleton_component_data.append(singleton_component)
	return self

################################
### 	Entities 			###
################################

### Adds an entity to the world
## Automatically generates an id for the entity
## Returns the id of the entity
func add_entity() -> int:
	var new_id := entities.size()
	entities.append(0)
	for component in component_data:
		component.append(0)
	return new_id
### Removes an entity from the world
## Removes all components from the entity
## This will invalidate all entity ids. Do not use entity ids after removing an entity.
## For example, do not iterate over entities and remove them at the same time.
## Instead, flag entities for removal by the removal system.
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
	var singleton_flag: int = singleton_component_dictionary.get(name)
	if (singleton & (1 << singleton_flag)) == 0:
		create_singleton(name, data)
	else:
		singleton_component_data[singleton_flag] = data
### Gets the data of a singleton component
## Returns the data of the singleton component
func get_singleton_data(name: StringName) -> int:
	var component_key = singleton_component_dictionary.get(name)
	if !component_key:
		return 0
	var singleton_data = singleton_component_data[component_key]
	if !singleton_data:
		return 0
	return singleton_data

################################
### 	Components 			###
################################

### Creates a component
## Automatically generates an id for the component
## Returns the id of the new component
func create_component(name: StringName) -> int:
	var new_id := component_data.size()
	component_data.append(PackedInt32Array())
	component_dictionary[name] = new_id
	return new_id
### Gets the id of a component
## Returns the id of the component
# func get_component_id(name: String) -> int:
# 	var component_id = component_dictionary[name]
# 	return component_id
### Gets the data of a component
## Using entity ids, you can navigate the component data
## Returns the data of the component as PackedInt32Array
func get_component(name: StringName) -> PackedInt32Array:
	var component_id = component_dictionary.get(name)
	if !component_id:
		return PackedInt32Array()
	return component_data[component_id]
### Gets all entity ids that match a component
## Returns an array of entity ids
func get_ids_with_component(name: StringName) -> Array:
	var ids_with_component := []
	var component_id: int = component_dictionary.get(name)
	if !component_id:
		return []
	var array_position := 0
	for entity in entities:
		if entity & (1 << component_id) != 0:
			ids_with_component.append(array_position)
		array_position += 1
	return ids_with_component
### Gets all entity ids that do NOT match a component
## Returns an array of entity ids
func get_ids_without_component(name: StringName) -> Array:
	var ids_without_component := []
	var component_id: int = component_dictionary.get(name)
	for entity_id in entities:
		if ((entities[entity_id] & (1 << component_id)) == 0):
			ids_without_component.append(entity_id)
	return ids_without_component
### Adds a component to an entity
## Optionally sets the data of the component
func add_component_to(entity_id: int, name: StringName, data: int = 0):
	var component_id: int = component_dictionary.get(name)
	var entity_flags := entities[entity_id]
	entities.set(entity_id, (entity_flags | (1 << component_id)))
	var component: PackedInt32Array = component_data[component_id]
	component[entity_id] = data
	return
### Sets the data of a component
func set_component_of(entity_id: int, name: StringName, data: int):
	var component_id: int = component_dictionary.get(name)
	var entity_flags := entities[entity_id]
	if ((entity_flags & (1 << component_id)) == 0):
		add_component_to(entity_id, name, data)
	else:
		component_data[component_id].set(entity_id, data)
### Removes a component from an entity
## Sets the data to 0 and removes the component flag from the entity
func remove_component_from(entity_id: int, name: StringName):
	var component_id: int = component_dictionary.get(name)
	var entity_flags := entities[entity_id]
	entity_flags = (entity_flags & ~(1 << component_id))
	component_data[component_id].set(entity_id, 0)

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
