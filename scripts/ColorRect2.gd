extends ColorRect

# This is the script for the "Fade" scene.
# It is a ColorRect node with a script that fades it out over time.
# Every frame, reduce the alpha value of the ColorRect by a small amount.
# When the alpha value reaches 0, queue_free() the node.

var fading = true

func _process(delta):
	if fading:
		self.color.a -= delta * 0.5
		if self.color.a <= 0:
			fading = false

