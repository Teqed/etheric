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

@onready var move_button_1: Button = get_node("%MoveButton1")
@onready var move_button_2: Button = get_node("%MoveButton2")
@onready var move_button_3: Button = get_node("%MoveButton3")
@onready var move_button_4: Button = get_node("%MoveButton4")
@onready var combat_log: RichTextLabel = get_node("%CombatLogText")

func _ready():
	# Change the 'Name' and 'Description' label on each button
	move_button_1.get_node("%Name").set_text("Move 1")
	move_button_1.get_node("%Description").set_text("Move 1 Description")
	move_button_2.get_node("%Name").set_text("Move 2")
	move_button_2.get_node("%Description").set_text("Move 2 Description")
	move_button_3.get_node("%Name").set_text("Move 3")
	move_button_3.get_node("%Description").set_text("Move 3 Description")
	move_button_4.get_node("%Name").set_text("Move 4")
	move_button_4.get_node("%Description").set_text("Move 4 Description")

	# Connect the 'pressed' signal of each button to the 'on_move_button_pressed' function
	move_button_1.connect("pressed", on_move_button_1_pressed)
	move_button_2.connect("pressed", on_move_button_2_pressed)
	move_button_3.connect("pressed", on_move_button_3_pressed)
	move_button_4.connect("pressed", on_move_button_4_pressed)

	var slot_0 = get_tree().get_nodes_in_group("slot_0")[0]
	var slot_1 = get_tree().get_nodes_in_group("slot_1")[0]
	var slot_2 = get_tree().get_nodes_in_group("slot_2")[0]
	var slot_3 = get_tree().get_nodes_in_group("slot_3")[0]
	var slot_4 = get_tree().get_nodes_in_group("slot_4")[0]
	var slot_5 = get_tree().get_nodes_in_group("slot_5")[0]
	var slot_6 = get_tree().get_nodes_in_group("slot_6")[0]
	var slot_7 = get_tree().get_nodes_in_group("slot_7")[0]
	slots = [slot_0, slot_1, slot_2, slot_3, slot_4, slot_5, slot_6, slot_7]
	Events.combat_selected_friendly_slot.connect(update_selected_friendly_slot)
	Events.combat_log_message.connect(new_combat_log_message)
	# update_selected_friendly_slot(4)

func new_combat_log_message(message: String):
	combat_log.newline()
	# Append the message to the RichTextLabel
	combat_log.append_text(message)
	# Scroll to the bottom of the RichTextLabel
	combat_log.scroll_to_line(combat_log.get_line_count())

# Called when a move button is pressed
func on_move_button_1_pressed():
	print("Move 1 pressed")

func on_move_button_2_pressed():
	print("Move 2 pressed")

func on_move_button_3_pressed():
	print("Move 3 pressed")

func on_move_button_4_pressed():
	print("Move 4 pressed")

func update_selected_friendly_slot(slot_ordinal: int):
	# Get the monster and moves for the selected friendly slot
	var selected_friendly_slot = slots[slot_ordinal]
	var moves: Monster_Resources_Moveset = selected_friendly_slot.monster.monster_resources.moves

	# Update the UI elements for each move button
	update_move_button(move_button_1, moves.move0)
	update_move_button(move_button_2, moves.move1)
	update_move_button(move_button_3, moves.move2)
	update_move_button(move_button_4, moves.move3)

func update_move_button(button, move):
	# Update the name and description UI elements for a move button
	button.get_node("%Name").set_text(move.move_name)
	button.get_node("%Description").set_text(move.description)
