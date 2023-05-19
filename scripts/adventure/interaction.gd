extends Node

## NPC ID
@export_range(0, 10) var npc_id = 0
var resource_0 = load("res://dialogue/crab_town/greeter.dialogue")
var resource_1 = load("res://dialogue/crab_town/knight.dialogue")
var resource_2 = load("res://dialogue/crab_town/crab.dialogue")
var BalloonScene := load("res://dialogue/balloons/portraits_balloon/balloon.tscn")

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

## Show the example balloon
func show_dialogue_balloon(
	resource: DialogueResource, title: String = "0", extra_game_states: Array = []) -> void:
	var balloon: Node = (BalloonScene).instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(resource, title, extra_game_states)

func _interact():
	show_dialogue_balloon(resource_0)


func _interact_1():
	show_dialogue_balloon(resource_1)


func _interact_2():
	show_dialogue_balloon(resource_2)
	await DialogueManager.dialogue_ended
	var monster_maker = Global.ecs_world.MonsterMaker.new();
	monster_maker.create_crab(Global.ecs_world)
	Global.ecs_world.set_singleton(&"CombatState", 1)
