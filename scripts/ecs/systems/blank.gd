class_name System
var name: StringName = &"BlankSystem"
var world: World
var enabled: bool = false
func _init(_world: World):
	world = _world
func update():
	if enabled:
		pass
func enable():
	enabled = true
func disable():
	enabled = false
