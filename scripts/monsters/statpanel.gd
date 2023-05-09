class_name Monster_Resources_Statpanel extends Resource

var this_health: int = 100
var this_energy: int = 0

@export_range(0,100) var health := this_health
@export_range(0,100) var energy := this_energy

func _init(arg_health := this_health, arg_energy := this_energy):
	self.health = arg_health
	self.energy = arg_energy