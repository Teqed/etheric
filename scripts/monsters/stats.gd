
class_name Monster_Resources_Stats extends Resource

@export_range(-100000,100000) var current_health: int = 100 # Maps to an int between -1,000,000,000 and 1,000,000,000
@export_range(-100000,100000) var max_health: int = 100 # Maps to an int between -1,000,000,000 and 1,000,000,000
@export_range(0,1000) var attack: int = 10
@export_range(0,1000) var speed: int = 10

func _init(arg_current_health := current_health,
	arg_max_health := max_health,
	arg_attack := attack,
	arg_speed := speed):
	self.current_health = arg_current_health
	self.max_health = arg_max_health
	self.attack = arg_attack
	self.speed = arg_speed