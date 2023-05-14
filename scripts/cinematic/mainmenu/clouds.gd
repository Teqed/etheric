
extends Node2D

var panning_left = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Pan to the left slowly, and when at x position, pan back to the right. Repeat
	if panning_left:
		position.x -= delta * 10
		if position.x < -200:
			panning_left = false
	else:
		position.x += delta * 10
		if position.x > 0:
			panning_left = true