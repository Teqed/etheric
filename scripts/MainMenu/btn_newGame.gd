extends Button

var fading = false

func _process(delta):
	if fading:
		var fadeNode = get_node("%Fade")
		fadeNode.color.a += delta * 0.5
		if fadeNode.color.a >= 1:
			fading = false
			for child in Global.mainPanel.get_children():
				Global.mainPanel.remove_child(child)
			Global.mainPanel.add_child(Global.adventureScene)
			Global.mainPanel.get_node("%Topbar").visible = true

func _pressed():
	fading = true
	pass
