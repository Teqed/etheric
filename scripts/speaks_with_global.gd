extends Node

func _ready():
	$Timer.connect("timeout", _on_Timer_timeout)

func _on_Timer_timeout():
	if Global.ecs_world:
		Global.ecs_world.update()
