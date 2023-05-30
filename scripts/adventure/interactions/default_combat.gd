extends InteractionDialogue

func _interact():
	show_dialogue_balloon(resource)
	await DialogueManager.dialogue_ended
	var monster_maker = Global.ecs_world.MonsterMaker.new();
	monster_maker.create_crab(Global.ecs_world)
	Global.ecs_world.set_singleton(&"CombatState", 1)
	return true
