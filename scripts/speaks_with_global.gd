extends Node

func _ready():
	$Timer.connect("timeout", _on_Timer_timeout)
	# for i in range(0, 3):
	# 	var entity = Global.ecs_world.add_entity()
	# 	Global.ecs_world.add_component(entity.uid, "Name", randi())
	# 	Global.ecs_world.add_component(entity.uid, "Speed", (randi() % 20) + 10)
	# 	Global.ecs_world.add_component(entity.uid, "Health", (randi() % 100) + 10)
	# 	Global.ecs_world.add_component(entity.uid, "Collection", 1)
	# 	Global.ecs_world.add_component(entity.uid, "Party", 1)
	# for i in range(0, 3):
	# 	var entity = Global.ecs_world.add_entity()
	# 	Global.ecs_world.add_component(entity.uid, "Name", randi())
	# 	Global.ecs_world.add_component(entity.uid, "Speed", (randi() % 20) + 10)
	# 	Global.ecs_world.add_component(entity.uid, "Health", (randi() % 100) + 10)
	# 	Global.ecs_world.add_component(entity.uid, "Collection", 0)
	# 	Global.ecs_world.add_component(entity.uid, "Party", 0)

func _on_Timer_timeout():
	if Global.ecs_world:
		Global.ecs_world.update()
