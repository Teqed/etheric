class_name Monster_Resources_Tooltip extends Resource

var this_monster_name: String = "Monster Name"
var this_description: String = "Description"

@export var monster_name := this_monster_name
@export var description := this_description

func init(arg_monster_name := this_monster_name, arg_description := this_description):
	monster_name = arg_monster_name
	description = arg_description