
class_name Monster_Resources_Move extends Resource

@export var move_name: String = "Move"
@export var description: String = "A move that a monster can learn."


func _init(arg_move_name := move_name, arg_description := description):
	self.move_name = arg_move_name
	self.description = arg_description
