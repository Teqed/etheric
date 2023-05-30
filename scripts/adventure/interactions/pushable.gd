## Allows gamepiece to be pushed.
extends Interaction

func _interact():
	# Can be pushed around.
	# Get current position.
	# Get the direction the player is facing.
	# Get the tile in that direction.
	# If the tile is empty, move the NPC there.
	# If the tile is not empty, do nothing.
	var current_position: Vector2i = myself.cell
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
	myself.move_speed = myself.move_speed / 3
	myself.get_node("%PassiveAiController").go_to_cell(new_position)
	FieldEvents.enable_player_input.emit()
	# When finished moving, reset the move speed.
	when_arrived()
	return false

func when_arrived():
	await myself.arrived
	myself.move_speed = myself.move_speed * 3