extends Button

func _ready():
	if SaveMan.get_saveslot_count() > 0:
		self.disabled = false

func _pressed():
	pass
