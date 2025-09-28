extends Node2D
class_name PlayerAnimator

@export var player_controller: PlayerController
@export var animation_player: AnimationPlayer
@export var sprite: Sprite2D
@onready var sword = $Sprite2D/Sword   # adjust if your sword path is different

func _ready():
	# Connect attack signal from PlayerController
	if player_controller:
		player_controller.attacked.connect(_on_player_attacked)

func _process(delta):
	# Don’t override attack animation while it’s still playing
	if animation_player.current_animation == "attack" and animation_player.is_playing():
		return

	# Flip character sprite
	if player_controller.direction == 1:
		sprite.flip_h = false
	elif player_controller.direction == -1:
		sprite.flip_h = true

	# Play movement / idle animations
	if abs(player_controller.velocity.x) > 0.0:
		animation_player.play("move")
	else:
		animation_player.play("idle")

	# Play jump / fall animations
	if player_controller.velocity.y < 0.0:
		animation_player.play("jump")
	elif player_controller.velocity.y > 0.0:
		animation_player.play("fall")

func _on_player_attacked():
	animation_player.play("attack")
	if sword:
		sword.attack()   # trigger sword slash animation
