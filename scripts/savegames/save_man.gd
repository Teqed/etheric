## Savegame manager
extends Node

# Savegame manager is a singleton / autoload.
var saveslots = [] # array of world_data
var currently_loaded_saveslot = 0

# There will be three save slots, each containing:
# - The player's current location (an adventure scene).
# - The contents of the ECS world (entity list, components).
func _init():
	load_slots_from_disk()

func new_saveslot():
	if saveslots.size() >= 3:
		return
	Global.ecs_world = World.new().create_new_world_data()
	var saveslot = Global.ecs_world.serialize()
	saveslots.append(saveslot)
	currently_loaded_saveslot = saveslots.size() - 1
	save_slots_to_disk()

func load_saveslot(index = currently_loaded_saveslot):
	currently_loaded_saveslot = index
	return saveslots[index]

func get_saveslot_count():
	return saveslots.size()

func clear_saveslot(index):
	saveslots.remove(index)

func save_world_to_slot():
	saveslots[currently_loaded_saveslot] = Global.ecs_world.serialize()
	save_slots_to_disk()

func save_slots_to_disk():
	var json_global_state = JSON.stringify(currently_loaded_saveslot)
	var global_state = FileAccess.open("user://global_state.dat", FileAccess.WRITE)
	global_state.store_pascal_string(json_global_state)

	for index in saveslots.size():
		save_saveslot_to_disk(index)

func save_saveslot_to_disk(index):
	var json_saveslot = JSON.stringify(saveslots[index])
	var save_game = FileAccess.open("user://savegame" + str(index) + ".dat", FileAccess.WRITE)
	save_game.store_pascal_string(json_saveslot)

func load_slots_from_disk():
	if FileAccess.file_exists("user://global_state.dat"):
		var global_state = FileAccess.open("user://global_state.dat", FileAccess.READ)
		var json_global_state = global_state.get_pascal_string()
		var json = JSON.new()
		var parse_result = json.parse(json_global_state)
		if parse_result == OK:
			currently_loaded_saveslot = json.get_data()

	for index in range(3):
		load_saveslot_from_disk(index)

func load_saveslot_from_disk(index):
	if FileAccess.file_exists("user://savegame" + str(index) + ".dat"):
		var save_game = FileAccess.open("user://savegame" + str(index) + ".dat", FileAccess.READ)
		var json_saveslot = save_game.get_pascal_string()
		var json = JSON.new()
		var parse_result = json.parse(json_saveslot)
		if parse_result == OK:
			saveslots.resize(index + 1)
			saveslots[index] = json.get_data()
