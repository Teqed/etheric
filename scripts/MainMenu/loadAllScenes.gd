extends PanelContainer

var adventureScenePreload = preload("res://./scenes/adventure.tscn")
var adventureSceneInstance = adventureScenePreload.instantiate()
var collectionScenePreload = preload("res://./scenes/test_scene2.tscn")
var collectionSceneInstance = collectionScenePreload.instantiate()
var combatScenePreload = preload("res://./scenes/basic_combat.tscn")
var combatSceneInstance = combatScenePreload.instantiate()

func _ready():
	Global.adventureScene = adventureSceneInstance
	Global.ecsWorld.attach(Global.adventureScene.get_node("%TileMap"))
	Global.collectionScene = collectionSceneInstance
	Global.combatScene = combatSceneInstance
	pass
