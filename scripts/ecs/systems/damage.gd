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
		var orindal_component = world.get_component(&"OrdinalPosition")
		var health_component = world.get_component(&"Health")
		var entities_with_component_incoming_damage = world.get_ids_with_component(&"IncomingDamage")
		var incoming_damage_component = world.get_component(&"IncomingDamage")
		for id in entities_with_component_incoming_damage:
			print(health_component)
			print("DamageSystem: Applying " + str(incoming_damage_component[id]) + " damage to entity " + str(id))
			var health = health_component[id]
			print("DamageSystem: Entity " + str(id) + " has " + str(health) + " health")
			var incoming_damage = incoming_damage_component[id]
			Global.ecs_world.set_component_of(id, &"Health",
			(health - incoming_damage))
			print("DamageSystem: Entity " + str(id) + " now has " + str(health_component[id]) + " health")
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
				print("DamageSystem: Entity " + str(id) + " has been defeated")
