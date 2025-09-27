extends CanvasLayer
class_name HUD

@export var player: PlayerController
@onready var health_bar: ProgressBar 

func _ready() -> void:
	if player:
		# Connect player’s health signal to HUD
		player.health_changed.connect(health_bar.update_health)
		# Initialize display
		health_bar.update_health(player.current_health, player.max_health)
