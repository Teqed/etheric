extends Node

@export var interaction: Interaction


func interact(actor: Gamepiece) -> bool:
	return interaction.interact(actor, get_parent().get_parent())
