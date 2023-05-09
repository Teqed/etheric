class_name Monster_Resources_Move extends Resource

var this_move_name: String = "Move"
var this_description: String = "A move that a monster can learn."

@export var move_name := this_move_name
@export var description := this_description


func _init(arg_move_name := this_move_name, arg_description := this_description):
	self.move_name = arg_move_name
	self.description = arg_description
