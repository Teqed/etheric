@tool
extends Node

# Direction: Nodes -> Nodes
signal combat_selected_friendly_slot(slot_ordinal: int)

# Direction: ECS -> Nodes
signal statpanel_updated(slot_ordinal: int, health_or_energy: bool, new_value: int)

signal populate_slot(slot_ordinal: int, incoming_monster: Monster)
signal depopulate_slot(slot_ordinal: int)

# Direction: Nodes -> ECS