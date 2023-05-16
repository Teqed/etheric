extends Node

var ecs_world: World
var main_panel: PanelContainer
var adventure_scene: Node
var collection_scene: Node
var combat_scene: Node

func _process(_delta):
	if Input.is_action_just_pressed("debug_00"):
		Events.scene_change.emit(Global.combat_scene, 0.4)
		Global.ecs_world.set_singleton("CombatState", 1)
	if Input.is_action_just_pressed("debug_01"):
		Events.scene_change.emit(Global.adventure_scene, 0.4)
