extends Node

## NPC ID
@export_range(0, 10) var npc_id = 0
var resource_0 = load("res://dialogue/crab_town/greeter.dialogue")
var resource_1 = load("res://dialogue/crab_town/knight.dialogue")
var resource_2 = load("res://dialogue/crab_town/crab.dialogue")
var BalloonScene := load("res://dialogue/balloons/portraits_balloon/balloon.tscn")

func interact(actor: Gamepiece) -> bool:
	match npc_id:
		0:
			return _interact()
		1:
			return _interact_1()
		2:
			return _interact_2(actor)
		3:
			return _interact_3()
		_:
			return false

## Show the example balloon
func show_dialogue_balloon(
	resource: DialogueResource, title: String = "0", extra_game_states: Array = []) -> bool:
	var balloon: Node = (BalloonScene).instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(resource, title, extra_game_states)
	return true

func _interact():
	# Acts like a wall -- no responsiveness.
	return true

func _interact_1():
	# Acts like a stuck, pushable object.
	return false

func _interact_2(actor: Gamepiece):
	# Can be pushed around.
	# Get current position.
	# Get the direction the player is facing.
	# Get the tile in that direction.
	# If the tile is empty, move the NPC there.
	# If the tile is not empty, do nothing.
	var current_position: Vector2i = get_parent().get_parent().cell
	var actor_position: Vector2i = actor.cell
	var new_position = current_position
	if actor_position.x > current_position.x:
		new_position.x -= 1
	elif actor_position.x < current_position.x:
		new_position.x += 1
	elif actor_position.y > current_position.y:
		new_position.y -= 1
	elif actor_position.y < current_position.y:
		new_position.y += 1
	get_parent().get_parent().move_speed = get_parent().get_parent().move_speed / 3
	get_parent().get_node("%Brain").go_to_cell(new_position)
	# When finished moving, reset the move speed.
	when_arrived()
	return false

func when_arrived():
	await get_parent().get_parent().arrived
	get_parent().get_parent().move_speed = get_parent().get_parent().move_speed * 3


func _interact_3():
	return show_dialogue_balloon(resource_0)

func _interact_4():
	return show_dialogue_balloon(resource_1)

func _interact_5():
	show_dialogue_balloon(resource_2)
	await DialogueManager.dialogue_ended
	var monster_maker = Global.ecs_world.MonsterMaker.new();
	monster_maker.create_crab(Global.ecs_world)
	Global.ecs_world.set_singleton(&"CombatState", 1)
	return true
