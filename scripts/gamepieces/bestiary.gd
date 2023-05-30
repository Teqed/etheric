@tool
class_name Bestiary
extends Resource

@export var bestiary = {}

func _init():
	# Load all Monsters and store them in the dictionary
	# First, get a list of all files in the directory res://resources/gamepieces/textures/
	var dir = DirAccess.open("res://resources/gamepieces/bestiary/")
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		# For each file, load it as a resource and store it in the dictionary
		var res: BestiaryEntry = load("res://resources/gamepieces/bestiary/" + file)
		print("Loaded " + file)
		bestiary[res.monster_id] = res
		file = dir.get_next()

func get_gfx_resource(monster_id: int) -> CanvasTexture:
	# Return the appropriate GFXResource based on the given monster ID
	return bestiary[monster_id].canvas_texture

func get_bestiary_entry_resource(monster_id: int) -> BestiaryEntry:
	# Return the appropriate Monster based on the given monster ID
	return bestiary[monster_id]