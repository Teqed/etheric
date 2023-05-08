# combat_daemon.gd
# You are the combat daemon.
# You are responsible for the combat system, including
# the combat log, the displayed monsters, the displayed
# health and energy on their statpanel, and receiving one
# of four move selections from the player for any given friendly.
# You're not responsible for the combat loop itself, which is
# handled by the combat system in the ECS.  Instead,
# it will send you messages when it needs you to do something,
# in the form of events. When the player selects a move, you'll
# send a message back to the combat system.

class Monster:
	var tooltip: Dictionary = {"name":"","description":""}
	var statpanel: Dictionary = {"health":0,"energy":0}
	var appearance: Dictionary = {"position":Vector2(0,0),"spriteatlas":Vector2(0,0)}
	var move: Dictionary = {"name":"","description":""}
	var moves: Dictionary = {"move0":move,"move1":move,"move2":move,"move3":move}

	func _init(name: String, description: String, health: int, energy: int, position: Vector2, spriteatlas: Vector2, available_moves: Dictionary):
		tooltip["name"] = name
		tooltip["description"] = description
		statpanel["health"] = health
		statpanel["energy"] = energy
		appearance["position"] = position
		appearance["spriteatlas"] = spriteatlas
		moves["move0"] = available_moves["move0"]
		moves["move1"] = available_moves["move1"]
		moves["move2"] = available_moves["move2"]
		moves["move3"] = available_moves["move3"]

	func update_dictionary(key: String, value):
		if key == "name":
			tooltip["name"] = value
		elif key == "description":
			tooltip["description"] = value
		elif key == "health":
			statpanel["health"] = value
		elif key == "energy":
			statpanel["energy"] = value
		elif key == "position":
			appearance["position"] = value
		elif key == "spriteatlas":
			appearance["spriteatlas"] = value
		elif key == "move0":
			moves["move0"] = value
		elif key == "move1":
			moves["move1"] = value
		elif key == "move2":
			moves["move2"] = value
		elif key == "move3":
			moves["move3"] = value

class CombatSlot extends Node2D:
	var occupied: bool = false
	var monster: Monster = null
	var ordinal: int # Between 0 and 7, inclusive.
	var other_objects: Array = []

	func _init(set_ordinal: int):
		self.ordinal = set_ordinal
		if ordinal == 0:
			self.position = Vector2(0,0)
		elif ordinal == 1:
			self.position = Vector2(1,0)
		elif ordinal == 2:
			self.position = Vector2(2,0)
		elif ordinal == 3:
			self.position = Vector2(3,0)
		elif ordinal == 4:
			self.position = Vector2(0,1)
		elif ordinal == 5:
			self.position = Vector2(1,1)
		elif ordinal == 6:
			self.position = Vector2(2,1)
		elif ordinal == 7:
			self.position = Vector2(3,1)
	func populate(incoming_monster: Monster):
		self.monster = incoming_monster
		self.occupied = true
	func depopulate():
		self.monster = null
		self.occupied = false
	func update_monster(key: String, value):
		self.monster.update_dictionary(key, value)
	func get_monster():
		if occupied:
			return monster
		else:
			return null
	func get_ordinal():
		return ordinal
	func swap_monsters(other_slot: CombatSlot):
		var temp_monster: Monster = other_slot.get_monster()
		if occupied:
			other_slot.populate(monster)
		else:
			other_slot.depopulate()
		if temp_monster != null:
			populate(temp_monster)
		else:
			depopulate()


# Some examples of possible actions are...

# Action:CombatPreparationsStart
## The SceneManager has brought you into focus,
## and the CombatSystem wants you to prepare for combat.
## You'll make sure the combat scene is reset by
## clearing the combat log, clearing the monster positions,
## resetting statpanels, and so on.
## After receiving this message, we expect to receive
## a series of PopulateMonster events.

# Action:PopulateMonster
## The CombatSystem wants you to display a monster.
## It will tell you which monster to display, and where.
## You'll display the monster in the appropriate position.
## It will also have some information about the monster's stats,
## such as their health, energy, and available moves.
## The available moves are important for friendly monsters,
## since we'll use this information on the movepanel.

# Action:CombatPreparationsFinish
## The CombatSystem sends this message after it has
## finished populating the monsters. Now that we now we have populated
## all the monsters, we can unhide the movepanel and combatlog,
## and send a message back to the CombatSystem to start the combat loop.

# Action:StatpanelUpdate
## The CombatSystem sends this message when it wants us to update
## the health and energy of a monster on the statpanel.
## This happens frequently, since each monster's energy updates
## every tick, and their health updates whenever they take damage.
## We'll update the health and energy of the monster on the statpanel.

# Action:MonsterChanges
## The CombatSystem sends this message when a monster changes.
## This happens when something fundamental about the monster changes,
## such as their position or permanent appearance.