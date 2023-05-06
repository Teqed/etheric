extends Button

var mainPanelContainer: Node

func _ready():
	mainPanelContainer = get_node("../../../PanelContainer")
	pass

func _pressed():
	mainPanelContainer.remove_child(mainPanelContainer.get_child(0))
	var test_scene = load("res://test_scene2.tscn")
	var node = test_scene.instantiate()
	mainPanelContainer.add_child(node)
	Global.activeScene = node
	Global.ecsWorld.disable("EnergySystem")
	pass
