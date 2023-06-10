@tool
# class_name Bestiary
extends Node

@export var bestiary = {}

func _init():
	print("Bestiary initialized")
	# Populate the bestiary dictionary
	_populate_bestiary()

func _populate_bestiary():
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
	if Engine.is_editor_hint():
		validate_monster_ids()

func get_gfx_resource(monster_id: int) -> CanvasTexture:
	# Return the appropriate GFXResource based on the given monster ID
	if Engine.is_editor_hint():
		_populate_bestiary()
	return bestiary[monster_id].canvas_texture

func get_bestiary_entry_resource(monster_id: int) -> BestiaryEntry:
	# Return the appropriate Monster based on the given monster ID
	if Engine.is_editor_hint():
		_populate_bestiary()
	return bestiary[monster_id]

func validate_monster_ids():
	# Check that all monster IDs are unique
	var monster_ids = []
	for bestiary_entry in bestiary.values():
		if bestiary_entry.monster_id in monster_ids:
			print("ERROR: Monster ID " + str(bestiary_entry.monster_id) + " is not unique!")
		else:
			monster_ids.append(bestiary_entry.monster_id)
	# Check that all monster IDs match their dictionary keys.
	for key in bestiary.keys():
		if key != bestiary[key].monster_id:
			print("ERROR: Monster ID " + str(bestiary[key].monster_id) + \
			" does not match its dictionary key " + str(key) + "!")
