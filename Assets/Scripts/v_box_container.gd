extends Control

@onready var hp_bar: ProgressBar = $ProgressBar
@onready var hp_label: Label = $Label
@onready var player = get_node("../..../Player") # adjust path to your PlayerController

func _ready():
	if player:
		player.health_changed.connect(_on_health_changed)
		_on_health_changed(player.current_health, player.max_health)

func _on_health_changed(current: int, max: int) -> void:
	hp_bar.value = int(current * 100 / max)
	hp_label.text = "%d / %d" % [current, max]
