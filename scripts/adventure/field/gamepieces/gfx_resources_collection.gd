@tool
class_name GFXResourcesCollection
extends Node

@export var gfx_resources = {}

func _ready():
	# for res in preload("res://resources/gamepieces/textures/").get_resource_list():
	# 	gfx_resources[res.get_id()] = res
	# Load all GFXResources and store them in the dictionary
	# First, get a list of all files in the directory res://resources/gamepieces/textures/
	var dir = DirAccess.open("res://resources/gamepieces/gfx/")
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		# For each file, load it as a resource and store it in the dictionary
		var res: GFXResources = load("res://resources/gamepieces/gfx/" + file)
		print("Loaded " + file)
		gfx_resources[res.get_gfx_id()] = res
		file = dir.get_next()

func get_gfx_resource(monster_id: int) -> GFXResources:
	# Return the appropriate GFXResource based on the given monster ID
	return gfx_resources[monster_id]