extends Node

## NPC ID
@export_range(0, 10) var npc_id = 0
var resource_0 = load("res://dialogue/crab_town/greeter.dialogue")
var resource_1 = load("res://dialogue/crab_town/knight.dialogue")
var resource_2 = load("res://dialogue/crab_town/crab.dialogue")

func interact():
	match npc_id:
		0:
			_interact()
		1:
			_interact_1()
		2:
			_interact_2()
		3:
			_interact()
		4:
			_interact()
		5:
			_interact()
		6:
			_interact()
		7:
			_interact()
		8:
			_interact()
		9:
			_interact()
		10:
			_interact()
		_:
			pass

func _interact():
	DialogueManager.show_example_dialogue_balloon(resource_0)


func _interact_1():
	DialogueManager.show_example_dialogue_balloon(resource_1)


func _interact_2():
	DialogueManager.show_example_dialogue_balloon(resource_2)