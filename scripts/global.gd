extends Node

var ecs_world: World
var main_panel: PanelContainer
var adventure_scene: Node
var collection_scene: Node
var combat_scene: Node

func _ready():
	ecs_world = World.new()

func create_new_world_data() -> Dictionary:
	ecs_world.create_component(&"Name");
	ecs_world.create_component(&"OrdinalPosition")
	ecs_world.create_component(&"Energy");
	ecs_world.create_component(&"Speed");
	ecs_world.create_component(&"Health");
	ecs_world.create_component(&"IncomingDamage");
	ecs_world.create_component(&"IncomingHealing");
	ecs_world.create_component(&"Collection");
	ecs_world.create_component(&"Party");
	ecs_world.create_singleton(&"CombatState");
	return ecs_world.serialize()

func _process(_delta):
	if Input.is_action_just_pressed("debug_00"):
		Events.scene_change.emit(Global.combat_scene, 0.4)
		Global.ecs_world.set_singleton("CombatState", 1)
	if Input.is_action_just_pressed("debug_01"):
		Events.scene_change.emit(Global.adventure_scene, 0.4)
