extends AudioStreamPlayer

var fading_state = 0

func _ready():
	Events.fade_to_black_silence.connect(fade_to_black_silence)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if fading_state == 0:
		self.volume_db += 0.1
		if self.volume_db >= 0:
			self.volume_db = 0
			fading_state = 1
	if fading_state == 2:
		self.volume_db -= 0.05
		if self.volume_db <= -20:
			self.volume_db = -20
			fading_state = 3
			Events.fade_to_silence_completed.emit()

func fade_to_black_silence():
	fading_state = 2