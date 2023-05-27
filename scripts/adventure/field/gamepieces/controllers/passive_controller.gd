## The passive controller does not move on its own, but has methods that can be called by others.
@tool
class_name PassiveAiController
extends GamepieceController

var is_active: = false:
	set(value):
		is_active = value

		set_process(is_active)
		set_physics_process(is_active)
		set_process_input(is_active)
		set_process_unhandled_input(is_active)

# Keep track of the target of a path. Used to face/interact with the object at a path's end.
# It is reset on cancelling the move path or continuing movement via arrows/gamepad directions.
var _target: Gamepiece = null
# Keep track of a move path. The controller will check that the path is clear each time the
# gamepiece needs to continue on to the next cell.
var _waypoints: Array[Vector2i] = []
var _current_waypoint: Vector2i


func _ready() -> void:
	# gdlint:ignore = private-method-call
	super._ready()

	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_unhandled_input(false)

	if not Engine.is_editor_hint():

		_focus.arriving.connect(_on_focus_arriving)
		_focus.arrived.connect(_on_focus_arrived)

	is_active = true


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []

	# Node exports are currently broken.
#	if not move_path:
#		warnings.append("The path loop controller needs a valid Line2D to follow!")

	return warnings

## The controller's focus will finish travelling this frame unless it is extended.
## There are a few cases where the controller will want to extend the path:
##	a) The gamepiece is following a series of waypoints, and needs to know which cell is next. Note
##		that the controller is responsible for the waypoints (instead of the gamepiece, for
##		instance) so that the path can be checked for any changes *as the gamepiece travels*.
##	b) A movement key/button is held down and the gamepiece should smoothly flow into the next cell.
func _on_focus_arriving(excess_distance: float) -> void:

	# If the gamepiece is currently following a path, continue moving along the path if it is still
	# a valid movement path since obstacles may shift while in transit.
	if not _waypoints.is_empty():
		while not _waypoints.is_empty() and excess_distance > 0:
			if is_cell_blocked(_waypoints[0]) or FieldEvents.did_gp_move_to_cell_this_frame(_waypoints[0]):
				return

			_current_waypoint = _waypoints.pop_front()
			var distance_to_waypoint: = \
				_focus.position.distance_to(_gameboard.cell_to_pixel(_current_waypoint))

			_focus.travel_to_cell(_current_waypoint)
			excess_distance -= distance_to_waypoint


func _on_focus_arrived() -> void:
	_waypoints.clear()
	if _target:
		var distance_to_target: = _target.position - _focus.position
		_focus.direction = distance_to_target
		interaction()
		_target = null

func interaction() -> void:
	pass

func go_to_cell(cell: Vector2i) -> void:
	return _on_cell_selected(cell)

## Triggered by something requesting us to move.
## For players, triggered by the player clicking on a cell.
func _on_cell_selected(cell: Vector2i) -> void:
	if not _focus.is_moving():
		if cell == _focus.cell:
			# The player clicked on the cell that the gamepiece carrying the camera focus is on.
			# Don't move to the cell the focus is standing on. May want to open inventory.
			return

		# We'll want different behaviour depending on what's underneath the cursor.
		# If there is an interactable, blocking object beneath the cursor, we'll walk *next* to
		# the cell.
		if is_cell_blocked(cell):
			# The cell is blocked, so try to find a path to a cell next to the blocked cell.
			# Set the target to the gamepiece at the cell.
			_target = get_gamepieces_at_cell(cell)[0]
			var adjacent_cells = _gameboard.get_adjacent_cells(cell)
			for adjacent_cell in adjacent_cells:
				if not is_cell_blocked(adjacent_cell):
					cell = adjacent_cell
					break

		# If the cell beneath the cursor is empty the focus can follow a path to the cell.
		_update_changed_cells()
		_waypoints = pathfinder.get_path_cells(_focus.cell, cell)

		# Only follow a valid path with a length greater than 0 (more than one waypoint).
		if _waypoints.size() > 1:
			FieldEvents.player_path_set.emit(_focus, _waypoints.back())

			# The first waypoint is the focus' current cell and may be discarded.
			_waypoints.remove_at(0)
			_current_waypoint = _waypoints.pop_front()

			_focus.travel_to_cell(_current_waypoint)
