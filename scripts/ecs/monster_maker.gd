
class_name MonsterMaker
enum Names {
	BRAVE_ETHERIC,
	CRAB
}
const NAMES_DICTIONARY = {
	Names.BRAVE_ETHERIC: "Brave Etheric",
	Names.CRAB: "Crab"
}
## Create a new monster with the bare minimum components
func create_hero(world: World):
	var new_id = world.add_entity()
	print("Names.BRAVE_ETHERIC: ", Names.BRAVE_ETHERIC)
	world.add_component_to(new_id, &"Name", Names.BRAVE_ETHERIC)
	world.add_component_to(new_id, &"CurrentHealth", 100)
	world.add_component_to(new_id, &"Attack", 2)
	world.add_component_to(new_id, &"Speed", 10)
	world.add_component_to(new_id, &"Party", 1)
	world.add_component_to(new_id, &"Collection", 1)
	return new_id
## Create a crab
func create_crab(world: World):
	var new_id = world.add_entity()
	world.add_component_to(new_id, &"Name", Names.CRAB)
	world.add_component_to(new_id, &"CurrentHealth", 10)
	world.add_component_to(new_id, &"Attack", 1)
	world.add_component_to(new_id, &"Speed", 5)
	world.add_component_to(new_id, &"Party", 0)
	world.add_component_to(new_id, &"Collection", 0)
	return new_id