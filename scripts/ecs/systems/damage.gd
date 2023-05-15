extends System
var entities_with_component_energy: Array
var entities_with_component_incoming_damage: Array
var entities_with_component_incoming_healing: Array
func _init(_world: World):
	name = &"DamageSystem"
	world = _world
func update():
	# Consume all incoming damage components and apply them to their respective health components
	if enabled:
		entities_with_component_incoming_damage = world.get_ids_with_component("IncomingDamage")
		var health_component = world.get_component("Health")
		var incoming_damage_component = world.get_component("IncomingDamage")
		var incoming_healing_component = world.get_component("IncomingHealing")
		for id in entities_with_component_incoming_damage:
			Global.ecs_world.set_component_of(id, "Health",
			health_component[id] - incoming_damage_component[id])
			world.remove_component_from(id, "IncomingDamage")
		entities_with_component_incoming_healing = world.get_ids_with_component("IncomingHealing")
		for id in entities_with_component_incoming_healing:
			world.set_component_of(id, "Health",
			health_component[id] + incoming_healing_component[id])
			world.remove_component_from(id, "IncomingHealing")
		entities_with_component_energy = world.get_ids_with_component("Energy")
		for id in entities_with_component_energy:
			if health_component[id] <= 0:
				world.remove_component_from(id, "Energy")
				print("DamageSystem: Entity " + str(id) + " has been defeated")