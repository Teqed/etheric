## Savegame manager.
## Responsible for loading and saving the game state.
## Also responsible for defining save slots and their contents.
extends Node

var saveslots: Array # of world_data
var currently_loaded_saveslot: int

## The savegame manager is a singleton / autoload.

## There will be three save slots.
## Each save slot will contain the following:
## - The player's current location (an adventure scene).
## - The contents of the ECS world (entity list, components).


func _init():
	load_slots_from_disk()

func new_saveslot():
	if saveslots.size() >= 3:
		return
	Global.ecs_world = World.new().create_new_world_data()
	var saveslot := Global.ecs_world.serialize()
	saveslots.append(saveslot)
	currently_loaded_saveslot = saveslots.size() - 1
	save_slots_to_disk()

func load_saveslot(index: int = currently_loaded_saveslot) -> Dictionary:
	currently_loaded_saveslot = index
	return saveslots[index]

func get_saveslot_count() -> int:
	return saveslots.size()

func clear_saveslot(index: int):
	saveslots.pop_at(index)

func save_world_to_slot():
	var world_data = Global.ecs_world.serialize()
	saveslots[currently_loaded_saveslot] = world_data

func save_slots_to_disk():
	var json_global_state := JSON.stringify(currently_loaded_saveslot)
	var global_state = FileAccess.open("user://global_state.dat", FileAccess.WRITE)
	global_state.store_pascal_string(json_global_state)

	for slots in saveslots.size():
		save_saveslot_to_disk(slots)

func save_saveslot_to_disk(index: int):
	var slot = saveslots[index]
	var prestring: Dictionary = slot
	var json_saveslot = JSON.stringify(prestring)
	var save_game = FileAccess.open("user://savegame" + str(index) + ".dat", FileAccess.WRITE)
	save_game.store_pascal_string(json_saveslot)

func load_slots_from_disk():
	if FileAccess.file_exists("user://global_state.dat"):
		var global_state = FileAccess.open("user://global_state.dat", FileAccess.READ)
		var json_global_state = global_state.get_pascal_string()
		var json := JSON.new()
		var parse_result = json.parse(json_global_state)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ",
				json_global_state, " at line ", json.get_error_line())
			return # Error! We don't have a save to load.
		currently_loaded_saveslot = json.get_data()

	load_saveslot_from_disk(0)
	load_saveslot_from_disk(1)
	load_saveslot_from_disk(2)

func load_saveslot_from_disk(index: int):
	if FileAccess.file_exists("user://savegame" + str(index) + ".dat"):
		var save_game = FileAccess.open("user://savegame" + str(index) + ".dat", FileAccess.READ)
		var json_saveslot = save_game.get_pascal_string()
		var json = JSON.new()
		var parse_result = json.parse(json_saveslot)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ",
				json_saveslot, " at line ", json.get_error_line())
			return # Error! We don't have a save to load.
		if saveslots.size() <= index:
			saveslots.resize(index + 1)
		saveslots[index] = json.get_data()
