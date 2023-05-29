extends Interaction

var resource = load("res://dialogue/crab_town/greeter.dialogue")

func _interact():
	return show_dialogue_balloon(resource)
