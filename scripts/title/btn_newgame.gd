extends Button

func _ready():
	if SaveMan.get_saveslot_count() > 2:
		self.disabled = true

func _pressed():
	SaveMan.new_saveslot()
	Events.scene_change.emit(Global.adventure_scene)
