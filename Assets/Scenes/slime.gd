extends CharacterBody2D

@export var speed: float = 100.0
@export var chase_range: float = 200.0   # Distance at which enemy starts chasing

var player: Node2D = null

func _ready():
	# Get reference to player (make sure the Player node is named "Player" in the scene tree)
	player = get_tree().root.get_node("World/Player")  # adjust path to your player

func _physics_process(delta):
	if player:
		var distance_to_player = position.distance_to(player.position)
		
		if distance_to_player <= chase_range:
			# Move towards player
			var direction = (player.position - position).normalized()
			velocity = direction * speed
		else:
			# Stop moving when out of range
			velocity = Vector2.ZERO

		move_and_slide()
