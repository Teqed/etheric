## Interaction
## When a player interacts with an NPC, it checks for an interaction
## and if found, it will run the respective interaction script.
class_name Interaction
extends Resource

var myself: Gamepiece
var actor: Gamepiece

func interact(arg_actor: Gamepiece, arg_myself: Gamepiece):
	self.actor = arg_actor
	self.myself = arg_myself
	return _interact()

func _interact():
	# Acts like a wall -- no responsiveness.
	return true
