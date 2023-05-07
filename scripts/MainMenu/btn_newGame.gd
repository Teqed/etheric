extends Button

var fading = false

func _process(delta):
	if fading:
		var fade_node = get_node("%Fade")
		fade_node.color.a += delta * 0.5
		if fade_node.color.a >= 1:
			fading = false
			for child in Global.main_panel.get_children():
				Global.main_panel.remove_child(child)
			Global.main_panel.add_child(Global.adventure_scene)
			Global.main_panel.get_node("%Topbar").visible = true

func _pressed():
	fading = true
