## Savegame manager.
## Responsible for loading and saving the game state.
## Also responsible for defining save slots and their contents.
extends Node

var saveslots: Array

## The savegame manager is a singleton / autoload.

## There will be three save slots.
## Each save slot will contain the following:
## - The player's current location (an adventure scene).
## - The contents of the ECS world (entity list, components).

class Saveslot:
	var location: String
	var world_data: Dictionary

	func _init():
		location = "FirstStep"
		world_data = Global.create_new_world_data()

func _init():
	saveslots = [] # Find the savefile and load it. Placeholder.

func add_saveslot(location: String, world_data: Dictionary):
	if saveslots.size() >= 3:
		return
	var saveslot = Saveslot.new()
	saveslot.location = location
	saveslot.world_data = world_data
	saveslots.append(saveslot)

func get_saveslot(index: int) -> Saveslot:
	return saveslots[index]

func get_saveslot_count() -> int:
	return saveslots.size()

func clear_saveslot(index: int):
	saveslots.pop_at(index)
