extends PanelContainer

var adventure_scene_preload = preload("res://./scenes/adventure.tscn")
var adventure_scene_instance = adventure_scene_preload.instantiate()
var collection_scene_preload = preload("res://./scenes/test_scene2.tscn")
var collection_scene_instance = collection_scene_preload.instantiate()
var combat_scene_preload = preload("res://./scenes/basic_combat.tscn")
var combat_scene_instance = combat_scene_preload.instantiate()

func _ready():
	Global.adventure_scene = adventure_scene_instance
	Global.ecs_world.attach(Global.adventure_scene.get_node("%TileMap"))
	Global.collection_scene = collection_scene_instance
	Global.combat_scene = combat_scene_instance
