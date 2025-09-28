extends Node2D

@export var Slimehehe : Slime
@export var animation_player : AnimationPlayer
@export var sprite : Sprite2D

func _process(delta):
	if Slimehehe.direction == -1:
		sprite.flip_h = false
	elif Slimehehe.direction == 1:
		sprite.flip_h = true

	if animation_player.current_animation != "move":
		animation_player.play("move")
