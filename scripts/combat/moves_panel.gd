extends Control

var move_button_1
var move_button_2
var move_button_3
var move_button_4

# Called when the node enters the scene tree for the first time.
func _ready():
	move_button_1 = get_node("MoveButton1")
	move_button_2 = get_node("MoveButton2")
	move_button_3 = get_node("MoveButton3")
	move_button_4 = get_node("MoveButton4")

	# Change the 'Name' and 'Description' label on each button
	move_button_1.get_node("VBoxContainer/Name").set_text("Move 1")
	move_button_1.get_node("VBoxContainer/Description").set_text("Move 1 Description")
	move_button_2.get_node("VBoxContainer/Name").set_text("Move 2")
	move_button_2.get_node("VBoxContainer/Description").set_text("Move 2 Description")
	move_button_3.get_node("VBoxContainer/Name").set_text("Move 3")
	move_button_3.get_node("VBoxContainer/Description").set_text("Move 3 Description")
	move_button_4.get_node("VBoxContainer/Name").set_text("Move 4")
	move_button_4.get_node("VBoxContainer/Description").set_text("Move 4 Description")

	# Connect the 'pressed' signal of each button to the 'on_move_button_pressed' function
	move_button_1.connect("pressed", on_move_button_1_pressed)
	move_button_2.connect("pressed", on_move_button_2_pressed)
	move_button_3.connect("pressed", on_move_button_3_pressed)
	move_button_4.connect("pressed", on_move_button_4_pressed)

# Called when a move button is pressed
func on_move_button_1_pressed():
	print("Move 1 pressed")

func on_move_button_2_pressed():
	print("Move 2 pressed")

func on_move_button_3_pressed():
	print("Move 3 pressed")

func on_move_button_4_pressed():
	print("Move 4 pressed")
