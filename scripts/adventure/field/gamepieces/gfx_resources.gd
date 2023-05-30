@tool
## The GFX_Resources class provides a way to provide a gamepiece
## an appearance. It will be loaded by a gamepiece and apply the
## textures within to its Sprite2D.
class_name GFXResources
extends Resource

@export var canvas_texture : CanvasTexture
@export var monster_id : int

func setup(gamepiece: Gamepiece):
	var sprite = gamepiece.get_node("GFX/Sprite2D")
	sprite.texture = canvas_texture

func get_gfx_id():
	return monster_id