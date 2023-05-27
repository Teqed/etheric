extends PointLight2D

var pos_1 = -400
var pos_2 = 2200
var direction = 1
var speed = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Slide X to the right until you reach position 1
	# Then, slide left until you reach position 2
	# Repeat
	var current_pos = self.position.x
	if current_pos < pos_1:
		direction = 1
	elif current_pos > pos_2:
		direction = -1
	self.position.x += speed * direction