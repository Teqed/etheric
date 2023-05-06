extends Button

var mainPanelContainer: Node

func _ready():
	mainPanelContainer = get_node("../../../PanelContainer")
	pass

func _pressed():
	for child in mainPanelContainer.get_children():
		child.queue_free()
	var test_scene = load("res://./scenes/basic_combat.tscn")
	var node = test_scene.instantiate()
	mainPanelContainer.add_child(node)
	# Global.activeScene = node
	# Global.ecsWorld.enable("EnergySystem")
	# Global.ecsWorld.enable("PositionSystem")
	pass
