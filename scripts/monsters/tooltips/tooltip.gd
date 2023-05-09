@tool
class_name Monster_Resources_Tooltip extends Resource

@export var monster_name: String = "Monster Name"
@export var description: String = "Description"

func _init(arg_monster_name := monster_name, arg_description := description):
	monster_name = arg_monster_name
	description = arg_description