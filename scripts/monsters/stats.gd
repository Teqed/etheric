
class_name Monster_Resources_Stats extends Resource

@export_range(0,100) var health: int = 100
@export_range(0,100) var speed: int = 10

func _init(arg_health := health, arg_speed := speed):
	self.health = arg_health
	self.speed = arg_speed