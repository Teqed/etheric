@tool
class_name Monster_Resources_Moveset extends Resource

@export var move0: Monster_Resources_Move
@export var move1: Monster_Resources_Move
@export var move2: Monster_Resources_Move
@export var move3: Monster_Resources_Move

func _init(arg_move0 := move0, arg_move1 := move1, arg_move2 := move2, arg_move3 := move3):
	move0 = arg_move0
	move1 = arg_move1
	move2 = arg_move2
	move3 = arg_move3