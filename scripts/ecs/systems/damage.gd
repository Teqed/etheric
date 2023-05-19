## DamageSystem
# This system is responsible for applying damage to entities with incoming damage components
# It is also responsible for applying healing to entities with incoming healing components
# It also removes the energy component from entities that have been defeated
extends System
func _init(_world: World):
	name = &"DamageSystem"
	world = _world
func update():
	# Consume all incoming damage components and apply them to their respective health components
	if enabled:
		var orindal_component = world.get_component(&"Slot")
		var health_component = world.get_component(&"Health")
		var name_component = world.get_component(&"Name")
		var entities_with_component_incoming_damage = world.get_ids_with_component(&"IncomingDamage")
		var incoming_damage_component = world.get_component(&"IncomingDamage")
		for id in entities_with_component_incoming_damage:
			var name_int = name_component[id]
			var entity_name: String = world.NAMES_DICTIONARY[name_int]
			var health = health_component[id]
			var incoming_damage = incoming_damage_component[id]
			Global.ecs_world.set_component_of(id, &"Health",
			(health - incoming_damage))
			Events.combat_log_message.emit(entity_name + " took " + str(incoming_damage) + " damage!")
			world.remove_component_from(id, &"IncomingDamage")
			Events.statpanel_updated.emit(orindal_component[id], true, health_component[id])
		var entities_with_component_incoming_healing = world.get_ids_with_component(&"IncomingHealing")
		var incoming_healing_component = world.get_component(&"IncomingHealing")
		for id in entities_with_component_incoming_healing:
			var health = health_component[id]
			var incoming_healing = incoming_healing_component[id]
			world.set_component_of(id, &"Health",
			health + incoming_healing)
			world.remove_component_from(id, "&IncomingHealing")
		var entities_with_component_energy = world.get_ids_with_component(&"Energy")
		for id in entities_with_component_energy:
			if health_component[id] <= 0:
				world.remove_component_from(id, &"Energy")
				var name_int = name_component[id]
				var entity_name: String = world.NAMES_DICTIONARY[name_int]
				Events.combat_log_message.emit(entity_name + " has been defeated")
