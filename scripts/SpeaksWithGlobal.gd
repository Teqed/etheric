@tool
extends Node

func _ready():
	var main_panel_array = get_tree().get_nodes_in_group("MainPanelGroup")
	Global.main_panel = main_panel_array[0]
	var hidden_panels_array = get_tree().get_nodes_in_group("HiddenPanelsGroup")
	Global.hiddenPanels = hidden_panels_array[0]
	$Timer.connect("timeout", _on_Timer_timeout)
	for i in range(0, 10):
		var entity = Global.ecs_world.add_entity()
		Global.ecs_world.add_component(entity, "Name", randi())
		Global.ecs_world.add_component(entity, "Position_x", (randi() % 30))
		Global.ecs_world.add_component(entity, "Position_y", (randi() % 17))
		Global.ecs_world.add_component(entity, "Energy", 0)
		Global.ecs_world.add_component(entity, "Speed", (randi() % 20) + 10)

func _on_Timer_timeout():
	Global.ecs_world.update()
