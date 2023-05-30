@tool
## The Monster class provides a way to provide a gamepiece
## an appearance and behavior. It will be loaded by a gamepiece and apply the
## textures within to its Sprite2D.
class_name Monster
extends Resource

@export var canvas_texture : CanvasTexture
@export var monster_id : int
