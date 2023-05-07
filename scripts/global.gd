@tool
extends Node

var ecs_world: World
var active_scene: Node
var main_panel: PanelContainer
var hidden_panels: PanelContainer
var adventure_scene: Node
var collection_scene: Node
var combat_scene: Node

class Component:
	var flag_position: int
	var data: PackedInt32Array
	func _init(new_flag_position):
		flag_position = new_flag_position
		data = PackedInt32Array()

class Entity:
	var component_flags: int
	var uid: int
	func _init(occupied_uids):
		uid = occupied_uids
		component_flags = 0

class World:
	var worldname: String = "DefaultWorld"
	var components: Dictionary = {} # Dictionary<String, Component>
	var entities: Array = Array() # Array<Entity>
	var occupied_uids: int = -1
	var occupied_flags: Array = Array()
	var systems: Dictionary = {} # Dictionary<String, System>
	func _init():
		pass
	func add_entity() -> Entity:
		occupied_uids += 1
		var entity = Entity.new(occupied_uids)
		entities.append(entity)
		return entity
	func remove_entity(entity: Entity):
		# entities.erase(entity)
		entities.remove_at(entity.uid)
		for component in components:
			var inner_component = components[component]
			if entity.componentFlags & (1 << inner_component.flagPosition):
				remove_component(entity, component)
	func create_component(name: String) -> Component:
		var new_flag_position = occupied_flags.size()
		occupied_flags.append(new_flag_position)
		var component = Component.new(new_flag_position)
		components[name] = component
		return component
	func add_component(entity: Entity, name: String, data: int) -> Component:
		var component = components[name]
		entity.componentFlags = entity.componentFlags | (1 << component.flagPosition)
		component.data.insert(entity.uid, data)
		return component
	func remove_component(entity: Entity, name: String):
		var component = components[name]
		entity.componentFlags = entity.componentFlags & ~(1 << component.flagPosition)
		component.data[entity.uid] = 0
	func get_component(name: String) -> Component:
		var component = components[name]
		return component
	func get_entities_with_component(name: String) -> Array:
		var entities_with_component = []
		var component = components[name]
		for entity_found in entities:
			if entity_found.componentFlags & (1 << component.flagPosition):
				entities_with_component.append(entity_found)
		return entities_with_component
	func add_system(system: System):
		systems[system.name] = system
	func update():
		for system in systems:
			systems[system].update()
	func enable(system_name: String):
		systems[system_name].enable()
	func disable(system_name: String):
		systems[system_name].disable()
	func attach(_tilemap: TileMap):
		systems["PositionSystem"].attach(_tilemap)

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
	var energy_component: Component
	var speed_component: Component
	func _init(_world: World):
		name = "EnergySystem"
		world = _world
		energy_component = world.get_component("Energy")
		speed_component = world.get_component("Speed")
	func update():
		if enabled:
			entities_with_component = world.get_entities_with_component("Speed")
			for entity in entities_with_component:
				energy_component.data[entity.uid] += speed_component.data[entity.uid]
				if energy_component.data[entity.uid] > 1000:
					print(str(entity.uid) + " is taking a turn")
					energy_component.data[entity.uid] = 0

class PositionSystem extends System:
	var entities_with_position: Dictionary = {} # Dictionary<Entity.uid: int, Entity>
	var entities_with_component: Dictionary = {} # Dictionary<Entity.uid: int, Entity>
	var position_x_component: Component
	var position_y_component: Component
	var tilemap: TileMap
	func _init(_world: World):
		name = "PositionSystem"
		world = _world
		position_x_component = world.get_component("Position_x")
		position_y_component = world.get_component("Position_y")
	func attach(_tilemap: TileMap):
		tilemap = _tilemap
	func update():
		if tilemap:
			if enabled:
				# Check if any entities have been added or removed
				var got_entities_with_component = world.get_entities_with_component("Position_x")
				for entity in got_entities_with_component:
					entities_with_component[entity.uid] = entity
				if entities_with_position.size() != entities_with_component.size():
					# Entities were added or removed. Figure out which ones.
					if entities_with_position.size() < entities_with_component.size():
						for entity_uid in entities_with_component:
							if not entities_with_position.has(entities_with_component[entity_uid]):
								# Entity was added
								entities_with_position[entity_uid] = entities_with_component[entity_uid]
								# Change the corresponding tile
								tilemap.set_cell(3, Vector2i(
										position_x_component.data[entity_uid],
										position_y_component.data[entity_uid]),
										0,
										Vector2i(2, 9))
					if entities_with_position.size() > entities_with_component.size():
						for entity_uid in entities_with_position:
							if not entities_with_component.has(entities_with_position[entity_uid]):
								# Entity was removed
								entities_with_position.erase(entities_with_position[entity_uid])
								# Erase the corresponding tile
								tilemap.set_cell(3, Vector2i(
									position_x_component.data[entity_uid],
									position_y_component.data[entity_uid]),
									0,
									Vector2i(0, 0))
				# Update positions
				# for entity in entities_with_position: // With CHANGED position? new component?
					# position_x_component.data[entity.uid] += 1
					# position_y_component.data[entity.uid] += 1
			else:
				# Remove all entities from the tilemap belonging to this system
				for entity_uid in entities_with_position:
					tilemap.set_cell(3, Vector2i(
						position_x_component.data[entity_uid],
						position_y_component.data[entity_uid]),
						0,
						Vector2i(0, 0))
				entities_with_position.clear()


func _ready():
	ecs_world = World.new()
	ecs_world.create_component("Name");
	ecs_world.create_component("Position_x"); # Group 0
	ecs_world.create_component("Position_y"); # Group 0
	ecs_world.create_component("Energy"); # Group 1
	ecs_world.create_component("Speed"); # Group 1
	ecs_world.create_component("Health");
	ecs_world.create_component("Attack");
	ecs_world.create_component("IncomingDamage");
	ecs_world.create_component("IncomingHealing");
	ecs_world.create_component("InCombat");
	ecs_world.add_system(EnergySystem.new(ecs_world))
	ecs_world.add_system(PositionSystem.new(ecs_world))
	ecs_world.enable("EnergySystem")
	ecs_world.enable("PositionSystem")
