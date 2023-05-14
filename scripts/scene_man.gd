extends Control

signal scene_changed

const DEFAULT_DURATION := 0.2
const DEFAULT_DELAY := 0.0

const AdventureScenePreload := preload("res://scenes/adventure/adventure.tscn")
const CollectionScenePreload := preload("res://scenes/test_scene2.tscn")
const CombatScenePreload := preload("res://scenes/combat.tscn")
var adventure_scene_instance := AdventureScenePreload.instantiate()
var collection_scene_instance := CollectionScenePreload.instantiate()
var combat_scene_instance := CombatScenePreload.instantiate()

@onready var _animator := $AnimationPlayer
@onready var _curtain := $CanvasLayer/ColorRect

func _ready():
	Global.adventure_scene = adventure_scene_instance
	Global.collection_scene = collection_scene_instance
	Global.combat_scene = combat_scene_instance
	var main_panel_array = get_tree().get_nodes_in_group("MainPanelGroup")
	Global.main_panel = main_panel_array[0]
	fade_in()

func set_color(color: Color):
	color.a = _curtain.color.a
	_curtain.color = color

func change_scene_to(
	scene: Node, duration: float = DEFAULT_DURATION, delay: float = DEFAULT_DELAY):
	if duration <= 0.0:
		push_error(
			"TRANSIT ERROR: change_scene duration must be > 0. Defaulting to %s" % DEFAULT_DURATION)
		duration = DEFAULT_DURATION

	if delay < 0.0:
		push_error("TRANSIT ERROR: change_scene delay must be >= 0. Defaulting to %s" % DEFAULT_DELAY)
		delay = DEFAULT_DELAY

	fade_out(duration, delay)

	for child in Global.main_panel.get_children():
		Global.main_panel.remove_child(child)
	Global.main_panel.add_child(scene)

	fade_in()

	emit_signal("scene_changed")

func fade_in():
	# re-enable mouse interaction before fading back in
	_curtain.mouse_filter = MOUSE_FILTER_IGNORE

	_animator.play_backwards("fade")
	await _animator.animation_finished

func fade_out(duration: float = DEFAULT_DURATION, delay: float = DEFAULT_DELAY):
	# disable mouse interaction while fading out
	_curtain.mouse_filter = MOUSE_FILTER_STOP

	if delay > 0:
		await get_tree().create_timer(delay).timeout

	_animator.speed_scale = 1.0 / duration
	_animator.play("fade")
	await _animator.animation_finished