extends Control

var healthbar: TextureProgressBar
var energybar: TextureProgressBar
var ordinal: int

func _ready():
	healthbar = get_node("%HealthBar")
	energybar = get_node("%EnergyBar")
	ordinal = get_parent().get_parent().ordinal
	Events.statpanel_updated.connect(update_statpanel)

func update_statpanel(slot_ordinal: int, health_or_energy: bool, new_value: int):
	if slot_ordinal != ordinal:
		return
	if health_or_energy:
		healthbar.value = new_value
	else:
		energybar.value = new_value
