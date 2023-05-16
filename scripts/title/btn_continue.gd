extends Button

func _ready():
	if SaveMan.get_saveslot_count() > 0:
		self.disabled = false

func _pressed():
	Global.ecs_world = World.new().deserialize(SaveMan.load_saveslot())
	Events.scene_change.emit(Global.adventure_scene)
