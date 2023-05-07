@tool
extends Node

func _ready():
	var mainPanelArray = get_tree().get_nodes_in_group("MainPanelGroup")
	Global.mainPanel = mainPanelArray[0]
	var hiddenPanelsArray = get_tree().get_nodes_in_group("HiddenPanelsGroup")
	Global.hiddenPanels = hiddenPanelsArray[0]
	$Timer.connect("timeout", _on_Timer_timeout)
	for i in range(0, 10):
		var entity = Global.ecsWorld.add_entity()
		Global.ecsWorld.add_component(entity, "Name", randi())
		Global.ecsWorld.add_component(entity, "Position_x", (randi() % 30))
		Global.ecsWorld.add_component(entity, "Position_y", (randi() % 17))
		Global.ecsWorld.add_component(entity, "Energy", 0)
		Global.ecsWorld.add_component(entity, "Speed", (randi() % 20) + 10)
	pass

func _on_Timer_timeout():
	Global.ecsWorld.update()
	pass

