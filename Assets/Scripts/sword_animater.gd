extends Node2D
class_name SwordAnimator

@export var sprite: Sprite2D
@export var animation_player: AnimationPlayer

func _ready():
	# Connect to parent swordSignal for flipping
	var parent = get_parent()
	if parent.has_signal("swordSignal"):
		print("heys")
		parent.swordSignal.connect(flip)

	# Match parent sprite flip at start
	flip(parent.sprite.flip_h)

	# Optional: Connect animation finished to reset logic
	if animation_player:
		animation_player.animation_finished.connect(_on_animation_finished)

func flip(flip_h: bool):
	sprite.flip_h = flip_h

func attack():
	if animation_player.has_animation("slash"):
		animation_player.play("slash")

# Reset sword state after attack
func _on_animation_finished(anim_name: String):
	if anim_name == "slash":
		if animation_player.has_animation("return"):
			animation_player.play("return")
	elif anim_name == "return":
		if animation_player.has_animation("reset"):
			animation_player.play("reset")
