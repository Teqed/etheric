class_name InteractionDialogue
extends Interaction

@export var resource: DialogueResource
var BalloonScene := load("res://dialogue/balloons/portraits_balloon/balloon.tscn")

## Show the example balloon
func show_dialogue_balloon(
	arg_resource: DialogueResource, title: String = "0", extra_game_states: Array = []) -> bool:
	var balloon: Node = (BalloonScene).instantiate()
	myself.get_tree().current_scene.add_child(balloon)
	balloon.start(arg_resource, title, extra_game_states)
	return true

func _interact():
	return show_dialogue_balloon(resource)
