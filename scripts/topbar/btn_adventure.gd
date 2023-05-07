extends Button

func _pressed():
	for child in Global.main_panel.get_children():
		Global.main_panel.remove_child(child)
	Global.main_panel.add_child(Global.adventure_scene)
