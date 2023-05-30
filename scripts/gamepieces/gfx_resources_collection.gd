@tool
class_name GFXResourcesCollection
extends Resource

@export var gfx_resources = {}

func _init():
	# for res in preload("res://resources/gamepieces/textures/").get_resource_list():
	# 	gfx_resources[res.get_id()] = res
	# Load all GFXResources and store them in the dictionary
	# First, get a list of all files in the directory res://resources/gamepieces/textures/
	var dir = DirAccess.open("res://resources/gamepieces/bestiary/")
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		# For each file, load it as a resource and store it in the dictionary
		var res: Monster = load("res://resources/gamepieces/bestiary/" + file)
		print("Loaded " + file)
		gfx_resources[res.monster_id] = res
		file = dir.get_next()

func get_gfx_resource(monster_id: int) -> CanvasTexture:
	# Return the appropriate GFXResource based on the given monster ID
	return gfx_resources[monster_id].canvas_texture