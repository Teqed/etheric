extends Control

const DEFAULT_DURATION := 1.5
const DEFAULT_DELAY := 0.0

const AdventureScenePreload := preload("res://scenes/adventure/places/crab_town.tscn")
# const CollectionScenePreload := preload("res://scenes/test_scene2.tscn")
const CombatScenePreload := preload("res://scenes/adventure/places/combat_board.tscn")
@onready var main_panel_array = get_tree().get_nodes_in_group("MainPanelGroup")
@onready var adventure_scene_instance: Node = AdventureScenePreload.instantiate()
# @onready var collection_scene_instance: Node = CollectionScenePreload.instantiate()
@onready var combat_scene_instance: Node = CombatScenePreload.instantiate()
@onready var _animator: AnimationPlayer = %SceneManAnimation
@onready var _curtain: ColorRect = %FadeRect

func _ready():
	Global.adventure_scene = adventure_scene_instance
	Global.collection_scene = adventure_scene_instance # collection_scene_instance
	Global.combat_scene = combat_scene_instance
	Global.main_panel = main_panel_array[0]
	fade_in()
	Events.scene_change.connect(change_scene_to)


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

	await fade_out(duration, delay)

	for child in Global.main_panel.get_children():
		Global.main_panel.remove_child(child)
	Global.main_panel.add_child(scene)

	await fade_in(duration / 2, delay)
	Events.scene_changed.emit()


func fade_in(duration: float = DEFAULT_DURATION, delay: float = DEFAULT_DELAY):
	# re-enable mouse interaction before fading back in
	_curtain.mouse_filter = MOUSE_FILTER_IGNORE

	if delay > 0:
		await get_tree().create_timer(delay).timeout

	var custom_speed = -1.0 / duration
	_animator.play("fade", -1, custom_speed, true)
	# _animator.play_backwards("fade")
	tween_bgm("in", duration)
	await _animator.animation_finished


func fade_out(duration: float = DEFAULT_DURATION, delay: float = DEFAULT_DELAY):
	# disable mouse interaction while fading out
	_curtain.mouse_filter = MOUSE_FILTER_STOP

	if delay > 0:
		await get_tree().create_timer(delay).timeout

	var custom_speed =  1.0 / duration
	tween_bgm("out", duration)
	_animator.play("fade", -1, custom_speed, false)
	await _animator.animation_finished

func tween_bgm(direction: String = "in", duration: float = DEFAULT_DURATION):
	# await get_tree().create_timer(0.5).timeout
	var bgm = Global.main_panel.get_children()[0].get_node("%BGM")
	if bgm == null:
		push_error("SCENEMAN ERROR: no bgm found in current scene")
	match direction:
		"in":
			bgm.play()
			var bgm_tween = get_tree().create_tween().tween_property(bgm, "volume_db", 0, duration)
			return bgm_tween
		"out":
			var bgm_tween = get_tree().create_tween().tween_property(bgm, "volume_db", -20, duration)
			return bgm_tween
		_:
			push_error("SCENEMAN ERROR: tween_bgm direction must be 'in' or 'out'")
