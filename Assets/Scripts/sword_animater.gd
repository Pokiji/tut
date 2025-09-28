extends Node2D
class_name SwordAnimator

@export var sprite: Sprite2D
@export var animation_player: AnimationPlayer
#@export var sword_player: .x

func _ready():
	print("heys")

	# Connect to parent swordSignal for flipping
	var parent = get_parent()

	# Match parent sprite fl"player_controller"ip at start

	# Optional: Connect animation finished to reset logic
	if animation_player:
		animation_player.animation_finished.connect(_on_animation_finished)



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
