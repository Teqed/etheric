extends Button

func _pressed():
	if (get_parent().occupied):
		if (get_parent().ordinal > 3):
			Events.combat_selected_friendly_slot.emit(get_parent().ordinal)