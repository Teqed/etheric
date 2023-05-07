@tool
extends Node

var ecsWorld: World
var activeScene: Node
var mainPanel: PanelContainer
var hiddenPanels: PanelContainer
var adventureScene: Node
var collectionScene: Node
var combatScene: Node

class Component:
	var flagPosition: int
	var data: PackedInt32Array
	func _init(newFlagPosition):
		flagPosition = newFlagPosition
		data = PackedInt32Array()
		pass

class Entity:
	var componentFlags: int
	var uid: int
	func _init(occupiedUids):
		uid = occupiedUids
		componentFlags = 0
		pass

class World:
	var worldname: String = "DefaultWorld"
	var components: Dictionary = {} # Dictionary<String, Component>
	var entities: Array = Array() # Array<Entity>
	var occupiedUids: int = -1
	var occupiedFlags: Array = Array()
	var systems: Dictionary = {} # Dictionary<String, System>
	func _init():
		pass
	func add_entity() -> Entity:
		occupiedUids += 1
		var entity = Entity.new(occupiedUids)
		entities.append(entity)
		return entity
	func remove_entity(entity: Entity):
		# entities.erase(entity)
		entities.remove_at(entity.uid)
		for component in components:
			var innerComponent = components[component]
			if entity.componentFlags & (1 << innerComponent.flagPosition):
				remove_component(entity, component)
	func create_component(name: String) -> Component:
		var newFlagPosition = occupiedFlags.size()
		occupiedFlags.append(newFlagPosition)
		var component = Component.new(newFlagPosition)
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
		var entitiesWithComponent = []
		var component = components[name]
		for entityFound in entities:
			if entityFound.componentFlags & (1 << component.flagPosition):
				entitiesWithComponent.append(entityFound)
		return entitiesWithComponent
	func add_system(system: System):
		systems[system.name] = system
		pass
	func update():
		for system in systems:
			systems[system].update()
		pass
	func enable(systemName: String):
		systems[systemName].enable()
		pass
	func disable(systemName: String):
		systems[systemName].disable()
		pass
	func attach(_tilemap: TileMap):
		systems["PositionSystem"].attach(_tilemap)
		pass

class System:
	var name: String = "BlankSystem"
	var world: World
	var enabled: bool = false
	func _init(_world: World):
		world = _world
		pass
	func update():
		if enabled:
			pass
		pass
	func enable():
		enabled = true
		pass
	func disable():
		enabled = false
		pass

class EnergySystem extends System:
	var entitiesWithComponent: Array
	var energyComponent: Component
	var speedComponent: Component
	func _init(_world: World):
		name = "EnergySystem"
		world = _world
		energyComponent = world.get_component("Energy")
		speedComponent = world.get_component("Speed")
		pass
	func update():
		if enabled:
			entitiesWithComponent = world.get_entities_with_component("Speed")
			for entity in entitiesWithComponent:
				energyComponent.data[entity.uid] += speedComponent.data[entity.uid]
				if energyComponent.data[entity.uid] > 1000:
					print(str(entity.uid) + " is taking a turn")
					energyComponent.data[entity.uid] = 0
		pass

class PositionSystem extends System:
	var entitiesWithPosition: Dictionary = {} # Dictionary<Entity.uid: int, Entity>
	var entitiesWithComponent: Dictionary = {} # Dictionary<Entity.uid: int, Entity>
	var positionXComponent: Component
	var positionYComponent: Component
	var tilemap: TileMap
	func _init(_world: World):
		name = "PositionSystem"
		world = _world
		positionXComponent = world.get_component("Position_x")
		positionYComponent = world.get_component("Position_y")
		pass
	func attach(_tilemap: TileMap):
		tilemap = _tilemap
		pass
	func update():
		if tilemap:
			if enabled:
				# Check if any entities have been added or removed by comparing entitiesWithPosition to entitiesWithComponent
				var _entitiesWithComponent = world.get_entities_with_component("Position_x")
				for entity in _entitiesWithComponent:
					entitiesWithComponent[entity.uid] = entity
				if entitiesWithPosition.size() != entitiesWithComponent.size():
					# Entities were added or removed. Figure out which ones.
					if entitiesWithPosition.size() < entitiesWithComponent.size():
						for entityUid in entitiesWithComponent:
							if not entitiesWithPosition.has(entitiesWithComponent[entityUid]):
								# Entity was added
								entitiesWithPosition[entityUid] = entitiesWithComponent[entityUid]
								# Change the corresponding tile
								tilemap.set_cell(3, Vector2i(positionXComponent.data[entityUid], positionYComponent.data[entityUid]), 0, Vector2i(2, 9))
					if entitiesWithPosition.size() > entitiesWithComponent.size():
						for entityUid in entitiesWithPosition:
							if not entitiesWithComponent.has(entitiesWithPosition[entityUid]):
								# Entity was removed
								entitiesWithPosition.erase(entitiesWithPosition[entityUid])
								# Erase the corresponding tile
								tilemap.set_cell(3, Vector2i(positionXComponent.data[entityUid], positionYComponent.data[entityUid]), 0, Vector2i(0, 0))
				# Update positions
				# for entity in entitiesWithPosition: // With CHANGED position? new component?
					# positionXComponent.data[entity.uid] += 1
					# positionYComponent.data[entity.uid] += 1
			else:
				# Remove all entities from the tilemap belonging to this system
				for entityUid in entitiesWithPosition:
					tilemap.set_cell(3, Vector2i(positionXComponent.data[entityUid], positionYComponent.data[entityUid]), 0, Vector2i(0, 0))
				entitiesWithPosition.clear()
		pass



func _ready():
	ecsWorld = World.new()
	ecsWorld.create_component("Name");
	ecsWorld.create_component("Position_x"); # Group 0
	ecsWorld.create_component("Position_y"); # Group 0
	ecsWorld.create_component("Energy"); # Group 1
	ecsWorld.create_component("Speed"); # Group 1
	ecsWorld.create_component("Health");
	ecsWorld.create_component("Attack");
	ecsWorld.create_component("IncomingDamage");
	ecsWorld.create_component("IncomingHealing");
	ecsWorld.create_component("InCombat");
	ecsWorld.add_system(EnergySystem.new(ecsWorld))
	ecsWorld.add_system(PositionSystem.new(ecsWorld))
	ecsWorld.enable("EnergySystem")
	ecsWorld.enable("PositionSystem")
	pass
