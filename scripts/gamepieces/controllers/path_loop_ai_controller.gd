@tool
## The path looping controller that follows a Line2D according to a timer.
class_name PathLoopAiController
extends PassiveAiController

## The points in the move_path will be used to generate the waypoints that the AI will follow.
@export var move_path: Line2D:
	set(value):
		move_path = value
		update_configuration_warnings()

var _current_waypoint_index: = 0

@onready var _timer: Timer = $WaitTimer


func _ready() -> void:
	# gdlint:ignore = private-method-call
	super._ready()

	set_process(true)
	# set_process_input(true)
	# set_process_unhandled_input(true)


	if not Engine.is_editor_hint():
		move_path.hide()

		_timer.one_shot = true
		_timer.timeout.connect(_on_timer_timeout)
		_timer.start()


# Ensure that the waypoints are updated whenever the pathfinder is re-created.
# The controller's path will NOT take blocking gamepieces into account, so temporarily unblock all
# cells in the pathfinder.
func _rebuild_pathfinder() -> void:
	# gdlint:ignore = private-method-call
	super._rebuild_pathfinder()

	var blocked_cells: = pathfinder.get_blocked_cells()
	pathfinder.set_blocked_cells([])

	_find_waypoints_from_line2D()

	pathfinder.set_blocked_cells(blocked_cells)


# Note that the following must be called after the pathfinder has been built.
# gdlint:ignore = function-name
func _find_waypoints_from_line2D() -> void:
	# A path needs at least two points.
	if move_path.get_point_count() <= 1:
		return

	# Add the first cell to the path, since subsequent additions will have the first cell removed.
	_waypoints.append(_gameboard.pixel_to_cell(move_path.get_point_position(0) + _focus.position))

	# Create a looping path from the points specified by move_path. Will fail if a path cannot be
	# found between some of the move_path's points.
	for i in range(1, move_path.get_point_count()):
		var source: = _gameboard.pixel_to_cell(move_path.get_point_position(i-1) + _focus.position)
		var target: = _gameboard.pixel_to_cell(move_path.get_point_position(i) + _focus.position)

		var path_subset: = pathfinder.get_path_cells(source, target)
		if path_subset.is_empty():
			print("'%s' PathLoopAiController::_find_waypoints_from_line2D() error - " % name +
				"Failed to find a path between cells %s and %s." % [source, target])
			return

		# Trim the first cell in the path found to prevent duplicates.
		_waypoints.append_array(path_subset.slice(1))

	# Finally, connect the ending and starting cells to complete the loop.
	var last_pos: = move_path.get_point_position(move_path.get_point_count()-1) + _focus.position
	var last_cell: = _gameboard.pixel_to_cell(last_pos)
	var first_cell: = _gameboard.pixel_to_cell(move_path.get_point_position(0) + _focus.position)

	# If we've made it this far there must be a path between the first and last cell.
	_waypoints.append_array(pathfinder.get_path_cells(last_cell, first_cell).slice(1))

func _on_focus_arrived() -> void:
	# gdlint:ignore = private-method-call
	super._on_focus_arrived()
	_timer.start()

func _on_timer_timeout() -> void:
	if _current_waypoint_index < 0 or _current_waypoint_index >= _waypoints.size():
		_current_waypoint_index = 0

	var waypoint: = _waypoints[_current_waypoint_index]
	if waypoint == _focus.cell:
		_current_waypoint_index += 1
		if _current_waypoint_index >= _waypoints.size():
			_current_waypoint_index = 0
		waypoint = _waypoints[_current_waypoint_index]

	if waypoint != _focus.cell and is_cell_blocked(waypoint):
		_timer.start()

	else:
		_focus.travel_to_cell(waypoint)
