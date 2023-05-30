@tool
## A Gamepiece is a scene that moves about and is snapped to the gameboard.
##
## Gamepieces, like other scenes in Godot, are expected to be composed from other nodes (i.e. an AI
## [GamepieceController], a collision shape, or a [Sprite2D], for example). Gamepieces themselves
## are 'dumb' objects that do nothing but occupy and move about the gameboard.
##
## [br][br][b]Note:[/b] The [code]gameboard[/code] is considered to be the playable area on which a
## Gamepiece may be placed. The gameboard is made up of cells, each of which may be occupied by one
##  or more gamepieces.
class_name Gamepiece
extends CharacterBody2D

## Emitted when the gamepiece begins to travel towards a destination cell.
signal travel_begun
## Emitted when a gamepiece is about to finish travlling to its destination cell. The remaining
## distance that the gamepiece could travel is based on how far the gamepiece has travelled this
## frame. [br][br]
## The signal is emitted prior to wrapping up the path and traveller, allowing other objects to
## extend the move path, if necessary.
signal arriving(remaining_distance: float)
## Emitted when the gamepiece has finished travelling to its destination cell.
signal arrived
## Emitted when [member blocks_movement] changes.
signal blocks_movement_changed
## Emitted when the gamepiece moves to a new [member cell] on the gameboard.[br][br]
## When travelling, [member cell] is updated [b]before[/b] travelling. In this case,
## prefer to wait for [signal arrived] instead.
signal cell_changed(old_cell: Vector2i)
## Emitted when the gamepiece's [member direction] changes, usually as it travels about the board.
signal direction_changed(new_direction: Vector2)
## Emitted when the gamepiece begins pushing another gamepiece.
signal push_begun
## Emitted when the gamepiece stops pushing another gamepiece.
signal push_ended

const GROUP_NAME: = "_GAMEPIECES"

## The [Gameboard] object used to tie the gamepiece to the gameboard. A gamepiece without a valid
## gameboard reference will produce errors, stopping the program.
@export var gameboard: Gameboard:
	set(value):
		gameboard = value
		update_configuration_warnings()

## A gamepiece may block movement into the cell it currently occupies. To do so, the gamepiece also
## requires a descendant [CollisionObject2D] with a valid collision shape.
@export var blocks_movement: = true:
	set(value):
		if value != blocks_movement:
			blocks_movement = value
			blocks_movement_changed.emit()
		update_configuration_warnings()

## The gamepiece will traverse a movement path at [code]move_speed[/code] pixels per second.
@export var move_speed: = 160.0

## The assigned monster ID for the gamepiece, if any. This is used to look up the monster's
## resources, such as its stats and behavior and appearance.
## When set, the gamepiece will consult the bestiary to look up the monster's resources.
## These will be applied to the gamepiece's descendants, such as its [Sprite2D] and
## [member monster_id].
@export_enum("Slime", "Adult Red Dragon", "Sorcerer") var monster_id: int:
	set(value):
		monster_id = value
		update_monster()
		update_configuration_warnings()

## Some gamepieces are monsters that can participate in combat. The [BestiaryEntry] object
## provides the monster's stats and abilities.
@export var bestiary_entry: BestiaryEntry

## The gamepiece will belong to one of two teams,
## [code]Team.PLAYER[/code], [code]Team.ENEMY[/code]
## The team is used to determine which gamepieces are friendly or hostile to one another.
@export_enum("Player", "Enemy") var team: int:
	set(value):
		team = value
		update_configuration_warnings()

## If the monster is friendly, it either exists in the player's collection or is a party member.
## If the monster is an enemy, it belongs to the 'wild' collection, and the 'crashers' party.
## They both use this flag to determine which state the monster is in.
@export_enum("Collection", "Party") var party: int:
	set(value):
		party = value
		update_configuration_warnings()

## The interaction object that handles interactions with this gamepiece.
## Accepts [code]null[/code] to disable interaction.
## Uses the derivatives of [Interaction] to handle interactions.
@export var interaction: Interaction

## The gamepiece's position is snapped to whichever cell it currently occupies.
## [br][br]The gamepiece will move by steps, being placed at whichever cell it currently occupies.
## This is useful for snapping its collision shape to the gameboard grid, so that there is never
## ambiguity to which space/cell is occupied according to the physics engine. [br][br]
## It is not desirable, however, for the graphical representation of the gamepiece (or the camera!)
## to jump around the gameboard with the gamepiece. Rather, a follower will travel a movement path
## to give the appearance of smooth movement. Other objects (such as sprites and animation) will
## derive their position from this follower and, consequently, appear to move smoothly.
## See [member camera_anchor] and [member gfx_anchor].
var cell: = Vector2i.ZERO:
	set = set_cell

## The [code]direction[/code] is a vector that points where the gamepiece is facing.
## In the event that the gamepiece is moving along a path, direction is updated automatically as
## long as the gamepiece continues to move.
var direction: = Vector2.ZERO:
	set(value):
		value = value.normalized()
		if not direction.is_equal_approx(value):
			direction = value
			direction_changed.emit(direction)

## A camera may smoothly follow a travelling gamepiece by receiving the camera_anchor's transform.
@onready var camera_anchor: = $Decoupler/Path2D/PathFollow2D/CameraAnchor as RemoteTransform2D

## The graphical representation of the gamepiece may smoothly follow a travelling gamepiece by
## receiving the gfx_anchor's transform.
@onready var gfx_anchor: = $Decoupler/Path2D/PathFollow2D/GFXAnchor as RemoteTransform2D

# The following objects allow the gamepiece to appear to move smoothly around the gameboard.
# Please note that the path is decoupled from the gamepiece's position (scale is set to match
# the gamepiece in _ready(), however) in order to simplify path management. All path coordinates may
# be provided in game-world coordinates and will remain relative to the origin even as the
# gamepiece's position changes.
@onready var _path: = $Decoupler/Path2D as Path2D
@onready var _follower: = $Decoupler/Path2D/PathFollow2D as PathFollow2D

## When this gamepiece is interacted with, it attempts to use the [code]interact()[/code]
## method to handle the interaction.
func interact(actor: Gamepiece) -> bool:
	if interaction:
		return interaction.interact(actor, self)
	return false

## The gamepiece may have a graphical representation. This method updates the gamepiece's
## appearance to match its current state.
## This method is called automatically when the gamepiece's [member monster_id] is set.
func update_gfx():
	if bestiary_entry != null:
		# Set the monster's appearance.
		var appearance: CanvasTexture = bestiary_entry.canvas_texture
		if appearance:
			$GFX/Sprite2D.texture = appearance

## This method is called automatically when the gamepiece's [member monster_id] is set.
## It looks up the monster's resources in the bestiary and applies them to the gamepiece.
func update_monster():
	if monster_id != null:
		var bestiary = Bestiary.new()
		bestiary_entry = bestiary.get_bestiary_entry_resource(monster_id)
		update_gfx()
		# Set your name to the monster's name.
		name = bestiary_entry.resource_name + "_0"

func _ready() -> void:
	set_physics_process(false)
	update_configuration_warnings()

	update_monster()

	if not Engine.is_editor_hint():
		assert(gameboard, "Gamepiece '%s' must have a gameboard reference to function!" % name)

		add_to_group(GROUP_NAME)

		# Ensure that the gamepiece and its path are at the same scale. This will enable providing
		# movement coordinates in local scale, simplifying path creation.
		_path.global_scale = global_scale

		# We want to automatically forward the cell_changed signal to the corresponding FieldEvent
		# (please see FieldEvents.gamepiece_cell_changed).
		# To do so we'll connect the cell_changed signal to a lambda that will automatically call
		# the FieldEvent for us, ensuring that the two signals are always paired.
		cell_changed.connect(
			func(old_cell: Vector2): FieldEvents.gamepiece_cell_changed.emit(self, old_cell)
		)

		# Snap the gamepiece to it's initial gameboard position.
		# Note that the path's coordinates are decoupled from the gamepiece's in order to simplify
		# path creation (origin is the point of reference), so the follower needs to be initialized
		# to the gamepiece's position.
		cell = gameboard.pixel_to_cell(position)
		_follower.position = position


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not gameboard:
		warnings.append("Gamepiece requires a Gameboard object to function!")
	if not gameboard:
		warnings.append("Gamepiece requires a Gameboard object to function!")

	# If this gamepiece is supposed to block movement ensure that it has a valid physics object.
	if blocks_movement:
		var collision_shapes: = find_children("*", "CollisionShape2D")
		if collision_shapes.is_empty():
			warnings.append("Gamepiece is set to block other gamepieces but has no collision "
				+ "object. Please add a CollisionShape2D to enable blocking.")

	return warnings


func _physics_process(delta: float) -> void:
	var move_distance: = move_speed * delta

	# We need to let others know that the gamepiece will arrive at the end of its path THIS frame.
	# A controller may want to extend the path (for example, if a move key is held down or if
	# another waypoint should be added to the move path).
	# If we do NOT do so and the path is extended post arrival, there will be a single frame where
	# the gamepiece's velocity is discontinuous (drops, then increases again), causing jittery
	# movement.
	# The excess travel distance allows us to know how much to extend the path by. A VERY fast
	# gamepiece may jump a few cells at a time.
	var excess_travel_distance: =  _follower.progress + move_distance \
		- _path.curve.get_baked_length()
	if excess_travel_distance >= 0:
		arriving.emit(excess_travel_distance)

	# Movement may have been extended, so check if we need to cap movement to the waypoint.
	var has_arrived: = _follower.progress + move_distance >= _path.curve.get_baked_length()
	if has_arrived:
		move_distance = _path.curve.get_baked_length() - _follower.progress

	var old_follower_position: = _follower.position
	_follower.progress += move_distance

	# This breaks down at very high speeds. At that point the cell path determines direction.
	direction = (_follower.position - old_follower_position).normalized()

	# If we've reached the end of the path, either travel to the next waypoint or wrap up movement.
	if has_arrived:
		_on_travel_finished()


## Begin travelling towards the specified cell.
## [br][br]The gamepiece's position will update instantly to the target cell, whereas the path
## follower will begin moving smoothly towards the destination at [member move_speed]. The
## [signal arriving] and [signal arrived] signals will be emitted accordingly as the path follower
## reaches the destination cell.
## [br][br]To move the gamepiece instantly to a new cell, call [method set_cell] instead.
## [br][br][b]Note:[/b] Calling travel_to_cell on a moving gamepiece will update it's position to
## that indicated by the cell coordinates and add the cell to the movement path.
func travel_to_cell(destination_cell: Vector2i) -> void:
	# Note that updating the gamepiece's cell will snap it to its new gameboard position. This will
	# be accounted for below when calculating the waypoint's pixel coordinates.
	var old_position: = position
	cell = destination_cell

	# If the gamepiece is not yet moving, we'll setup a new path.
	if not _path.curve:
		_path.curve = Curve2D.new()

		# The path needs at least two points for the follower to work correctly, so a new path
		# will travel from the gamepiece's old position.
		_path.curve.add_point(old_position)
		_follower.progress = 0

		set_physics_process(true)

	# The gamepiece serves as the waypoint's frame of reference.
	_path.curve.add_point(gameboard.cell_to_pixel(destination_cell))

	travel_begun.emit()

## Returns [code]true[/code] if the gamepiece is currently traversing a path.
func is_moving() -> bool:
	return is_physics_processing()


func set_cell(value: Vector2i) -> void:
	if Engine.is_editor_hint():
		return

	var old_cell: = cell
	cell = value

	if not is_inside_tree():
		await ready

	var old_position: = position
	position = gameboard.cell_to_pixel(cell)
	_follower.position = old_position

	cell_changed.emit(old_cell)


func _on_travel_finished() -> void:
	_path.curve = null
	_follower.progress = 0

	set_physics_process(false)
	arrived.emit()
