extends Node

var ecs_world: World
var main_panel: PanelContainer
var adventure_scene: Node
var collection_scene: Node
var combat_scene: Node

func _process(_delta):
	if Input.is_action_just_pressed("debug_00"):
		Global.ecs_world.set_singleton("CombatState", 1)
	if Input.is_action_just_pressed("debug_01"):
		Events.scene_change.emit(Global.adventure_scene, 0.4)
		# Global.ecs_world.disable(&"EnergySystem")
		# Global.ecs_world.disable(&"CombatStateSystem")
		# Global.ecs_world.disable(&"DamageSystem")
		# Global.ecs_world.disable(&"CombatSlotSystem")
		Global.ecs_world.set_singleton("CombatState", 0)
	if Input.is_action_just_pressed("debug_02"):
		for i in range(0, 3):
			var entity = Global.ecs_world.add_entity()
			Global.ecs_world.add_component_to(entity, &"Name", randi())
			Global.ecs_world.add_component_to(entity, &"Speed", (randi() % 20) + 10)
			Global.ecs_world.add_component_to(entity, &"Health", (randi() % 100) + 10)
			Global.ecs_world.add_component_to(entity, &"Collection", 1)
			Global.ecs_world.add_component_to(entity, &"Party", 1)
		for i in range(0, 3):
			var entity = Global.ecs_world.add_entity()
			Global.ecs_world.add_component_to(entity, &"Name", randi())
			Global.ecs_world.add_component_to(entity, &"Speed", (randi() % 20) + 10)
			Global.ecs_world.add_component_to(entity, &"Health", (randi() % 100) + 10)
			Global.ecs_world.add_component_to(entity, &"Collection", 0)
			Global.ecs_world.add_component_to(entity, &"Party", 0)
	if Input.is_action_just_pressed("debug_03"):
		print(str(Global.ecs_world.serialize()))
	if Input.is_action_just_pressed("debug_04"):
		pass
