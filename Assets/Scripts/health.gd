extends ProgressBar
class_name HealthBar

@export var player: PlayerController

func _ready() -> void:
	# connect if a player is assigned
	if player:
		player.health_changed.connect(_on_health_changed)
		# initialize bar with player’s current health
		_on_health_changed(player.current_health, player.max_health)

func update_health(current: int, max: int) -> void:
	max_value = max
	value = current
	
func _on_health_changed(current: int, max: int) -> void:
	max_value = max
	value = current
