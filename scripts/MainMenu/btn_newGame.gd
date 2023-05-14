extends Button

var fade_node
var fade_bgm_node
var already_pressed = false
var faded_to_black = false
var faded_to_silence = false

func _ready():
	fade_node = get_node("%Fade")
	fade_bgm_node = get_node("%BGM")
	Events.fade_to_black_completed.connect(_on_fade_to_black_completed)
	Events.fade_to_silence_completed.connect(_on_fade_to_silence_completed)

func _process(_delta):
	if already_pressed && faded_to_black && faded_to_silence:
		for child in Global.main_panel.get_children():
			Global.main_panel.remove_child(child)
		Global.main_panel.add_child(Global.adventure_scene)

func _pressed():
	already_pressed = true
	Events.fade_to_black_silence.emit()

func _on_fade_to_silence_completed():
	faded_to_silence = true

func _on_fade_to_black_completed():
	faded_to_black = true
