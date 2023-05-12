extends Node2D
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

var slots: Array

func _ready():
	var slot_0 = get_tree().get_nodes_in_group("slot_0")[0]
	var slot_1 = get_tree().get_nodes_in_group("slot_1")[0]
	var slot_2 = get_tree().get_nodes_in_group("slot_2")[0]
	var slot_3 = get_tree().get_nodes_in_group("slot_3")[0]
	var slot_4 = get_tree().get_nodes_in_group("slot_4")[0]
	var slot_5 = get_tree().get_nodes_in_group("slot_5")[0]
	var slot_6 = get_tree().get_nodes_in_group("slot_6")[0]
	var slot_7 = get_tree().get_nodes_in_group("slot_7")[0]
	slots = [slot_0, slot_1, slot_2, slot_3, slot_4, slot_5, slot_6, slot_7]
	# update_selected_friendly_slot(4)
	Events.combat_selected_friendly_slot.connect(update_selected_friendly_slot)

func update_selected_friendly_slot(slot_ordinal: int):
	var selected_friendly_slot = slots[slot_ordinal]
	var move_button_1 = get_node("%MoveButton1")
	var selected_friendly_slot_move0_name = (
		selected_friendly_slot.monster.resources.moves.move0.move_name)
	var selected_friendly_slot_move0_description = (
		selected_friendly_slot.monster.resources.moves.move0.description)
	move_button_1.get_child(0).get_child(0).set_text(
		selected_friendly_slot_move0_name + "  @ " + str(slot_ordinal))
	move_button_1.get_child(0).get_child(1).set_text(selected_friendly_slot_move0_description)
	var move_button_2 = get_node("%MoveButton2")
	var selected_friendly_slot_move1_name = (
		selected_friendly_slot.monster.resources.moves.move1.move_name)
	var selected_friendly_slot_move1_description = (
		selected_friendly_slot.monster.resources.moves.move1.description)
	move_button_2.get_child(0).get_child(0).set_text(selected_friendly_slot_move1_name)
	move_button_2.get_child(0).get_child(1).set_text(selected_friendly_slot_move1_description)
	var move_button_3 = get_node("%MoveButton3")
	var selected_friendly_slot_move2_name = (
		selected_friendly_slot.monster.resources.moves.move2.move_name)
	var selected_friendly_slot_move2_description = (
		selected_friendly_slot.monster.resources.moves.move2.description)
	move_button_3.get_child(0).get_child(0).set_text(selected_friendly_slot_move2_name)
	move_button_3.get_child(0).get_child(1).set_text(selected_friendly_slot_move2_description)
	var move_button_4 = get_node("%MoveButton4")
	var selected_friendly_slot_move3_name = (
		selected_friendly_slot.monster.resources.moves.move3.move_name)
	var selected_friendly_slot_move3_description = (
		selected_friendly_slot.monster.resources.moves.move3.description)
	move_button_4.get_child(0).get_child(0).set_text(selected_friendly_slot_move3_name)
	move_button_4.get_child(0).get_child(1).set_text(selected_friendly_slot_move3_description)
