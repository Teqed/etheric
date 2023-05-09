@tool
class_name Monster_Resources_Statpanel extends Resource

@export_range(0,100) var health: int = 100
@export_range(0,100) var energy: int = 0

func _init(arg_health := health, arg_energy := energy):
	self.health = arg_health
	self.energy = arg_energy