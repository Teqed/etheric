## Interaction
## When a player interacts with an NPC, it checks for an interaction
## and if found, it will run the respective interaction script.
class_name Interaction
extends Resource

var myself: Gamepiece
var actor: Gamepiece

var BalloonScene := load("res://dialogue/balloons/portraits_balloon/balloon.tscn")

## Show the example balloon
func show_dialogue_balloon(
	resource: DialogueResource, title: String = "0", extra_game_states: Array = []) -> bool:
	var balloon: Node = (BalloonScene).instantiate()
	myself.get_tree().current_scene.add_child(balloon)
	balloon.start(resource, title, extra_game_states)
	return true

func interact(arg_actor: Gamepiece, arg_myself: Gamepiece):
	self.actor = arg_actor
	self.myself = arg_myself
	return _interact()

func _interact():
	# Acts like a wall -- no responsiveness.
	return true
