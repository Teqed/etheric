
extends Node

# Direction: Nodes -> Nodes
signal combat_selected_friendly_slot(slot_ordinal: int)
signal fade_to_black_silence()
signal fade_to_black_completed()
signal fade_to_silence_completed()

# Direction: ECS -> Nodes
signal statpanel_updated(slot_ordinal: int, health_or_energy: bool, new_value: int)

signal populate_slot(slot_ordinal: int, incoming_monster: Monster)
signal depopulate_slot(slot_ordinal: int)

signal combat_log_message(message: String)

# Direction: Nodes -> ECS