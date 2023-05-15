extends System
var entities_with_component: Array
var energy_component: PackedInt32Array
var speed_component: PackedInt32Array
func _init(_world: World):
	name = &"EnergySystem"
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