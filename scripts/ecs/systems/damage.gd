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
		var health_component = world.get_component("Health")
		var entities_with_component_incoming_damage = world.get_ids_with_component("IncomingDamage")
		var incoming_damage_component = world.get_component("IncomingDamage")
		for id in entities_with_component_incoming_damage:
			Global.ecs_world.set_component_of(id, "Health",
			health_component[id] - incoming_damage_component[id])
			world.remove_component_from(id, "IncomingDamage")
		var entities_with_component_incoming_healing = world.get_ids_with_component("IncomingHealing")
		var incoming_healing_component = world.get_component("IncomingHealing")
		for id in entities_with_component_incoming_healing:
			world.set_component_of(id, "Health",
			health_component[id] + incoming_healing_component[id])
			world.remove_component_from(id, "IncomingHealing")
		var entities_with_component_energy = world.get_ids_with_component("Energy")
		for id in entities_with_component_energy:
			if health_component[id] <= 0:
				world.remove_component_from(id, "Energy")
				print("DamageSystem: Entity " + str(id) + " has been defeated")
