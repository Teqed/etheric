extends Node

var ecs_world: World
var active_scene: Node
var main_panel: PanelContainer
# var hidden_panels: PanelContainer
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
	var entities: Dictionary = {} #Dictionary<int, Entity>
	var singleton: Entity
	var singleton_components: Dictionary = {} # Dictionary<String, int>
	var occupied_uids: int = -1
	var occupied_flags: Array = Array()
	var occupied_singleton_flags: Array = Array()
	var systems: Dictionary = {} # Dictionary<String, System>
	func _init():
		singleton = Entity.new(0)
	func add_entity() -> Entity:
		occupied_uids += 1
		var entity = Entity.new(occupied_uids)
		entities[occupied_uids] = entity
		return entity
	func remove_entity(entity: Entity):
		entities.erase(entity.uid)
		for component in components:
			var inner_component = components[component]
			if entity.component_flags & (1 << inner_component.flag_position):
				remove_component(entity, component)
	func create_singleton(name: String, data: int = 0) -> Component:
		var new_flag_position = occupied_singleton_flags.size()
		occupied_singleton_flags.append(new_flag_position)
		var component = Component.new(new_flag_position)
		singleton_components[name] = component
		singleton.component_flags = singleton.component_flags | (1 << component.flag_position)
		component.data.insert(singleton.uid, data)
		return component
	func set_singleton(name: String, data: int):
		if (singleton.component_flags & (1 << singleton_components[name].flag_position)) == 0:
			create_singleton(name, data)
		else:
			singleton_components[name].data[singleton.uid] = data
	func get_singleton_data(name: String) -> int:
		var component = singleton_components[name]
		var data = component.data[singleton.uid]
		return data
	func create_component(name: String) -> Component:
		var new_flag_position = occupied_flags.size()
		occupied_flags.append(new_flag_position)
		var component = Component.new(new_flag_position)
		components[name] = component
		return component
	func add_component(entity_uid: int, name: String, data: int = 0) -> Component:
		var component = components[name]
		var entity = entities[entity_uid]
		entity.component_flags = entity.component_flags | (1 << component.flag_position)
		component.data.insert(entity.uid, data)
		return component
	func set_component(entity_uid: int, name: String, data: int):
		var entity = entities[entity_uid]
		if (entity.component_flags & (1 << components[name].flag_position)) == 0:
			add_component(entity_uid, name, data)
		else:
			components[name].data[entity.uid] = data
	func remove_component(entity: Entity, name: String):
		var component = components[name]
		entity.component_flags = entity.component_flags & ~(1 << component.flag_position)
		component.data[entity.uid] = 0
	func get_component(name: String) -> Component:
		var component = components[name]
		return component
	# func get_entities_with_component(name: String) -> Array:
	# 	var entities_with_component = []
	# 	var component = components[name]
	# 	for entity_found in entities:
	# 		if entity_found.component_flags & (1 << component.flag_position):
	# 			entities_with_component.append(entity_found)
	# 	return entities_with_component
	func get_uids_with_component(name: String) -> Array:
		var uids_with_component = []
		var component = components[name]
		for entity_found in entities:
			if entities[entity_found].component_flags & (1 << component.flag_position):
				uids_with_component.append(entities[entity_found].uid)
		return uids_with_component
	func get_uids_without_component(name: String) -> Array:
		var uids_without_component = []
		var component = components[name]
		for entity_found in entities:
			if entities[entity_found].component_flags & (1 << component.flag_position) == 0:
				uids_without_component.append(entities[entity_found].uid)
		return uids_without_component
	func add_system(system: System):
		systems[system.name] = system
	func update():
		for system in systems:
			systems[system].update()
	func enable(system_name: String):
		systems[system_name].enable()
	func disable(system_name: String):
		systems[system_name].disable()
	# func attach(_tilemap: TileMap):
		# systems["PositionSystem"].attach(_tilemap)

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
			entities_with_component = world.get_uids_with_component("Energy")
			for uid in entities_with_component:
				energy_component.data[uid] += speed_component.data[uid]
				if energy_component.data[uid] > 1000:
					Events.combat_log_message.emit("Entity " + str(uid) + " is taking an action!")
					energy_component.data[uid] = 0
				var slot_ordinal = world.get_component("OrdinalPosition").data[uid]
				@warning_ignore("integer_division")
				Events.statpanel_updated.emit(slot_ordinal, false, energy_component.data[uid] / 10)

# class PositionSystem extends System:
# 	var entities_with_position: Dictionary = {} # Dictionary<Entity.uid: int, Entity>
# 	var entities_with_component: Dictionary = {} # Dictionary<Entity.uid: int, Entity>
# 	var position_x_component: Component
# 	var position_y_component: Component
# 	var tilemap: TileMap
# 	func _init(_world: World):
# 		name = "PositionSystem"
# 		world = _world
# 		position_x_component = world.get_component("Position_x")
# 		position_y_component = world.get_component("Position_y")
# 	func attach(_tilemap: TileMap):
# 		tilemap = _tilemap
# 	func update():
# 		if tilemap:
# 			if enabled:
# 				# Check if any entities have been added or removed
# 				var got_entities_with_component = world.get_entities_with_component("Position_x")
# 				for entity in got_entities_with_component:
# 					entities_with_component[entity.uid] = entity
# 				if entities_with_position.size() != entities_with_component.size():
# 					# Entities were added or removed. Figure out which ones.
# 					if entities_with_position.size() < entities_with_component.size():
# 						for entity_uid in entities_with_component:
# 							if not entities_with_position.has(entities_with_component[entity_uid]):
# 								# Entity was added
# 								entities_with_position[entity_uid] = entities_with_component[entity_uid]
# 								# Change the corresponding tile
# 								tilemap.set_cell(3, Vector2i(
# 										position_x_component.data[entity_uid],
# 										position_y_component.data[entity_uid]),
# 										0,
# 										Vector2i(2, 9))
# 					if entities_with_position.size() > entities_with_component.size():
# 						for entity_uid in entities_with_position:
# 							if not entities_with_component.has(entities_with_position[entity_uid]):
# 								# Entity was removed
# 								entities_with_position.erase(entities_with_position[entity_uid])
# 								# Erase the corresponding tile
# 								tilemap.set_cell(3, Vector2i(
# 									position_x_component.data[entity_uid],
# 									position_y_component.data[entity_uid]),
# 									0,
# 									Vector2i(0, 0))
# 				# Update positions
# 				# for entity in entities_with_position: // With CHANGED position? new component?
# 					# position_x_component.data[entity.uid] += 1
# 					# position_y_component.data[entity.uid] += 1
# 			else:
# 				# Remove all entities from the tilemap belonging to this system
# 				for entity_uid in entities_with_position:
# 					tilemap.set_cell(3, Vector2i(
# 						position_x_component.data[entity_uid],
# 						position_y_component.data[entity_uid]),
# 						0,
# 						Vector2i(0, 0))
# 				entities_with_position.clear()
# class OrdinalPositionSystem extends System:
# 	var entities_with_component: Array
# 	var ordinal_position_component: Component
# 	var party_position_component: Component
# 	func _init(_world: World):
# 		name = "OrdinalPositionSystem"
# 		world = _world
# 		ordinal_position_component = world.get_component("OrdinalPosition")
# 		party_position_component = world.get_component("Party")
# 	func update():
# 		if enabled:
# 			entities_with_component_party = world.get_uids_with_component("Party")
# 			for uid in entities_with_component_party:
# 				ordinal_position_component.data[uid] += ordinal_position_component.data[uid]
# 				if ordinal_position_component.data[uid] > 1000:
# 					# print(str(entity.uid) + " is taking a turn")
# 					ordinal_position_component.data[uid] = 0
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
					entities_with_component_party = world.get_uids_with_component("Party")
					var party_component = world.get_component("Party")
					for uid in entities_with_component_party:
						if party_component.data[uid] == 1:
							var position = occupied_friendly_positions.size()
							var friendly_position = position + 4
							if position <= 3:
								occupied_friendly_positions.append(position)
								world.set_component(uid, "OrdinalPosition", friendly_position)
								world.add_component(uid, "Energy")
								Events.populate_slot.emit(friendly_position, Monster.new())
						else: if party_component.data[uid] == 0:
							var position = occupied_enemy_positions.size()
							if position <= 3:
								occupied_enemy_positions.append(position)
								world.set_component(uid, "OrdinalPosition", position)
								world.add_component(uid, "Energy")
								Events.populate_slot.emit(position, Monster.new())
					world.set_singleton("CombatState", 2)
				2:
					entities_with_component_energy = world.get_uids_with_component("Energy")
					var friendly_entities_remaining = false
					var enemy_entities_remaining = false
					var party_component = world.get_component("Party")
					for uid in entities_with_component_energy:
						if party_component.data[uid] == 1:
							friendly_entities_remaining = true
						else: if party_component.data[uid] == 0:
							enemy_entities_remaining = true
					if not friendly_entities_remaining:
						print("CombatStateSystem: All friendly entities have been defeated. Ending combat.")
						entities_with_component_energy = world.get_uids_with_component("Energy")
						for uid in entities_with_component_energy:
							world.remove_component(uid, "Energy")
						world.set_singleton("CombatState", 0)
					else: if not enemy_entities_remaining:
						print("CombatStateSystem: All enemy entities have been defeated. Ending combat.")
						entities_with_component_energy = world.get_uids_with_component("Energy")
						for uid in entities_with_component_energy:
							world.remove_component(uid, "Energy")
						world.set_singleton("CombatState", 0)
					for i in range(0, 7):
						Events.depopulate_slot.emit(i)

class CombatSlotSystem extends System:
	var entities_with_component_ordinal_position: Array
	var entities_with_component_party: Array
	var ordinal_position_component: Component
	var previous_ordinal_position_component: Component
	var party_component: Component
	func _init(_world: World):
		name = "CombatSlotSystem"
		world = _world
	func update():
		if enabled:
			ordinal_position_component = world.get_component("OrdinalPosition")
			if previous_ordinal_position_component != ordinal_position_component:
				previous_ordinal_position_component = ordinal_position_component
				entities_with_component_ordinal_position = world.get_uids_with_component("OrdinalPosition")
				entities_with_component_party = world.get_uids_with_component("Party")
				party_component = world.get_component("Party")
				for uid in entities_with_component_ordinal_position:
					var position = ordinal_position_component.data[uid]
					if party_component.data[uid] == 1:
						Events.populate_slot.emit(position, Monster.new())
					else: if party_component.data[uid] == 0:
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
			entities_with_component_incoming_damage = world.get_uids_with_component("IncomingDamage")
			var health_component = world.get_component("Health")
			var incoming_damage_component = world.get_component("IncomingDamage")
			var incoming_healing_component = world.get_component("IncomingHealing")
			for uid in entities_with_component_incoming_damage:
				world.set_component(uid, "Health",
				health_component.data[uid] - incoming_damage_component.data[uid])
				world.remove_component(uid, "IncomingDamage")
			entities_with_component_incoming_healing = world.get_uids_with_component("IncomingHealing")
			for uid in entities_with_component_incoming_healing:
				world.set_component(uid, "Health",
				health_component.data[uid] + incoming_healing_component.data[uid])
				world.remove_component(uid, "IncomingHealing")
			entities_with_component_energy = world.get_uids_with_component("Energy")
			for uid in entities_with_component_energy:
				if health_component.data[uid] <= 0:
					world.remove_component(uid, "Energy")
					print("DamageSystem: Entity " + str(uid) + " has been defeated")


func _ready():
	ecs_world = World.new()
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

func _process(_delta):
	if Input.is_action_just_pressed("debug_00"):
		for child in Global.main_panel.get_children():
			Global.main_panel.remove_child(child)
		Global.main_panel.add_child(Global.combat_scene)
		Global.ecs_world.set_singleton("CombatState", 1)
	if Input.is_action_just_pressed("debug_01"):
		for child in Global.main_panel.get_children():
			Global.main_panel.remove_child(child)
		Global.main_panel.add_child(Global.adventure_scene)