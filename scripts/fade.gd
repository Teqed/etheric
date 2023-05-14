extends ColorRect

var fading_state = 0

func _ready():
	Events.fade_to_black_silence.connect(fade_to_black_silence)

func _process(delta):
	if fading_state == 0:
		self.color.a -= delta * 0.5
		if self.color.a <= 0:
			fading_state = 1
	if fading_state == 2:
		self.color.a += delta * 0.5
		if self.color.a >= 1:
			fading_state = 3
			Events.fade_to_black_completed.emit()

func fade_to_black_silence():
	fading_state = 2