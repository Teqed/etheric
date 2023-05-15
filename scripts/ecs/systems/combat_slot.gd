extends System
var entities_with_component_ordinal_position: Array
var entities_with_component_party: Array
var ordinal_position_component: PackedInt32Array
var previous_ordinal_position_component: PackedInt32Array
var party_component: PackedInt32Array
func _init(_world: World):
	name = &"CombatSlotSystem"
	world = _world
func update():
	if enabled:
		ordinal_position_component = world.get_component("OrdinalPosition")
		if previous_ordinal_position_component != ordinal_position_component:
			previous_ordinal_position_component = ordinal_position_component
			entities_with_component_ordinal_position = world.get_ids_with_component("OrdinalPosition")
			entities_with_component_party = world.get_ids_with_component("Party")
			party_component = world.get_component("Party")
			for id in entities_with_component_ordinal_position:
				var position = ordinal_position_component[id]
				if party_component[id] == 1:
					Events.populate_slot.emit(position, Monster.new())
				else: if party_component[id] == 0:
					Events.populate_slot.emit(position, Monster.new())