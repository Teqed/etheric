extends Button

func _pressed():
	for child in Global.mainPanel.get_children():
		Global.mainPanel.remove_child(child)
	Global.mainPanel.add_child(Global.combatScene)
	pass
