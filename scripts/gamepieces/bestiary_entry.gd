# @tool
## The BestiaryEntry class provides a way to provide a gamepiece
## an appearance and behavior. It will be loaded by a gamepiece and apply the
## textures within to its Sprite2D.
class_name BestiaryEntry
extends Resource

@export var monster_id : int
@export var canvas_texture : CanvasTexture
@export_multiline var greeting : String = "Hello, I am a monster!"
@export_range(0, 1_000) var experience_reward : int = 0
@export var health: int = 100
@export var attack: int = 10
@export var defense: int = 10
@export var speed: int = 10
@export var energy: int = 10