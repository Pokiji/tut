extends Node2D

@export var Slimehehe : Slime
@export var animation_player : AnimationPlayer
@export var sprite : Sprite2D

func _process(delta):
	# flips the character sprite
	if Slimehehe.direction == 1:
		sprite.flip_h = false
	elif Slimehehe.direction== -1:
		sprite.flip_h = true
	# plays the movement animation
	if abs(Slimehehe.velocity.x) > 0.0:
		animation_player.play("move")
	else:
		animation_player.play("move")
