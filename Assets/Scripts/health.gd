extends TextureProgressBar

@export var player: PlayerController

func _ready() -> void:
	if player == null:
		# try to find automatically (adjust path to your scene)
		player = get_tree().get_first_node_in_group("player") as PlayerController	
	player.health_changed.connect(update_health)
	update_health(player.current_health, player.max_health)

func update_health(current: int, max: int) -> void:
	min_value = 0
	max_value = max
	value = current
