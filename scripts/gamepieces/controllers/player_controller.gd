## A player controller that may be applied to any gamepiece.
##
## The controller responds to player input.
class_name PlayerController
extends PassiveAiController

const GROUP_NAME: = "_PLAYER_CONTROLLER_GROUP"

var is_pushing = false
var is_slowed = false

func _ready() -> void:
	# gdlint:ignore = private-method-call
	super._ready()
	add_to_group(GROUP_NAME)
	FieldEvents.cell_selected.connect(_on_cell_selected)
	FieldEvents.disable_player_input.emit()
	FieldEvents.enable_player_input.emit()

func _physics_process(_delta: float) -> void:
	if not _focus.is_moving():
			# The player is not moving, so check for input.
			var move_dir: = _get_move_direction()
			if move_dir:
				# The player is pressing a movement key or button.
				var target_cell: = Vector2i.ZERO
				# Unless using 8-direction movement, one movement axis must be preferred.
				#	Default to the x-axis.
				if not is_zero_approx(move_dir.x):
					move_dir = Vector2(move_dir.x, 0)
				else:
					move_dir = Vector2(0, move_dir.y)
				_focus.direction = move_dir
				target_cell = _focus.cell + Vector2i(move_dir)
				# If there is a gamepiece at the target cell, do not move on top of it.
				_update_changed_cells()
				if not is_cell_blocked(target_cell) and \
						not FieldEvents.did_gp_move_to_cell_this_frame(target_cell):
					var move_path: = pathfinder.get_path_cells(_focus.cell, target_cell)
					# Path is invalid. Bump animation?
					if move_path.size() <= 1:
						pass
					else:
						_focus.travel_to_cell(target_cell)
						if is_pushing:
							var parent: Gamepiece = get_parent()
							is_slowed = true
							parent.move_speed = parent.move_speed / 3

				else:
					if not is_pushing:
						# Get the gamepiece at the target cell.
						_target = get_gamepieces_at_cell(target_cell)[0]
						if interaction():
							pass
						else:
							# The player is is_pushing against a wall or another gamepiece.
							# Let's play the push animation by signalling the animation.
							is_pushing = true
							_focus.push_begun.emit()
						_target = null
			else:
				if is_pushing:
					_focus.push_ended.emit()
					is_pushing = false


func _get_move_direction() -> Vector2:
	return Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)


func _on_focus_arriving(excess_distance: float) -> void:
	var parent: Gamepiece = get_parent()
	if is_pushing and is_slowed:
		parent.move_speed = parent.move_speed * 3
		_focus.push_ended.emit()
		is_pushing = false
		is_slowed = false
	# gdlint:ignore = private-method-call
	super._on_focus_arriving(excess_distance)
	var move_direction: = _get_move_direction()
	if _waypoints.is_empty():
		if move_direction:
			# There is no path to follow, so defer to movement keys or buttons that are currently held down.
				_target = null

				var next_cell: Vector2i
				if not is_zero_approx(move_direction.x):
					next_cell = _focus.cell + Vector2i(int(move_direction.x), 0)
				else:
					next_cell = _focus.cell + Vector2i(0, int(move_direction.y))

				if pathfinder.has_cell(next_cell) and not is_cell_blocked(next_cell) and \
						not FieldEvents.did_gp_move_to_cell_this_frame(next_cell):
					_focus.travel_to_cell(next_cell)

func interaction() -> bool:
	var parent: Gamepiece = get_parent()
	print("Arrived at target: " + str(_target))
	# _target.get_children()[2].go_to_cell(Vector2i(_target.cell.x + 1, _target.cell.y))
	if _target.has_method("interact"):
		FieldEvents.disable_player_input.emit()
		return _target.interact(parent)
	return false
