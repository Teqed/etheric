extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.combat_log_message.connect(new_combat_log_message)

func new_combat_log_message(message: String):
	self.newline()
	# Append the message to the RichTextLabel
	self.append_text(message)
	# Scroll to the bottom of the RichTextLabel
	self.scroll_to_line(self.get_line_count())
