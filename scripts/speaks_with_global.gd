@tool
extends Node

var adventure_scene_preload = preload("res://scenes/adventure/adventure.tscn")
var adventure_scene_instance = adventure_scene_preload.instantiate()
var collection_scene_preload = preload("res://scenes/test_scene2.tscn")
var collection_scene_instance = collection_scene_preload.instantiate()
var combat_scene_preload = preload("res://scenes/combat.tscn")
var combat_scene_instance = combat_scene_preload.instantiate()

func _ready():
	Global.adventure_scene = adventure_scene_instance
	# Global.ecs_world.attach(Global.adventure_scene.get_node("%TileMap"))
	Global.collection_scene = collection_scene_instance
	Global.combat_scene = combat_scene_instance
	var main_panel_array = get_tree().get_nodes_in_group("MainPanelGroup")
	Global.main_panel = main_panel_array[0]
	# var hidden_panels_array = get_tree().get_nodes_in_group("HiddenPanelsGroup")
	# Global.hidden_panels = hidden_panels_array[0]
	$Timer.connect("timeout", _on_Timer_timeout)
	for i in range(0, 3):
		var entity = Global.ecs_world.add_entity()
		Global.ecs_world.add_component(entity.uid, "Name", randi())
		Global.ecs_world.add_component(entity.uid, "Speed", (randi() % 20) + 10)
		Global.ecs_world.add_component(entity.uid, "Health", (randi() % 100) + 10)
		Global.ecs_world.add_component(entity.uid, "Collection", 1)
		Global.ecs_world.add_component(entity.uid, "Party", 1)
	for i in range(0, 3):
		var entity = Global.ecs_world.add_entity()
		Global.ecs_world.add_component(entity.uid, "Name", randi())
		Global.ecs_world.add_component(entity.uid, "Speed", (randi() % 20) + 10)
		Global.ecs_world.add_component(entity.uid, "Health", (randi() % 100) + 10)
		Global.ecs_world.add_component(entity.uid, "Collection", 0)
		Global.ecs_world.add_component(entity.uid, "Party", 0)

func _on_Timer_timeout():
	Global.ecs_world.update()
