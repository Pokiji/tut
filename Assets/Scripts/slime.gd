extends CharacterBody2D
class_name Slime

@export var speed: float = 60.0
@export var patrol_speed: float = 40.0
@export var chase_range: float = 200.0
@export var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var player: Node2D
@export var attack_range: float = 40.0
@export var attack_cooldown: float = 1.0

var direction: float = 1
var attack_timer: float = 0.0
@export var sprite_path: NodePath
var sprite: Sprite2D

func _ready():
	if sprite_path:
		sprite = get_node(sprite_path) as Sprite2D

func _physics_process(delta):
	# Update attack timer
	if attack_timer > 0:
		attack_timer -= delta

	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	# Determine distance to player safely
	var distance_to_player = 9999
	if player:
		distance_to_player = player.global_position.distance_to(global_position)

	# Behavior
	if player and distance_to_player <= attack_range and attack_timer <= 0:
		# Stop and attack
		velocity.x = 0
		attack()
	elif player and distance_to_player <= chase_range:
		# Chase player
		direction = sign(player.global_position.x - global_position.x)
		velocity.x = direction * speed
	else:
		# Patrol
		velocity.x = direction * patrol_speed

		# Flip if hitting wall
		if is_on_wall():
			direction *= -1
			velocity.x = direction * patrol_speed  # push away slightly

		# Flip if reaching ledge
		elif has_node("LedgeRay") and not $LedgeRay.is_colliding():
			direction *= -1
			$LedgeRay.position.x = abs($LedgeRay.position.x) * direction

	# Move slime
	move_and_slide()

	# Flip sprite
	if sprite:
		sprite.flip_h = direction == -1

func attack():
	attack_timer = attack_cooldown
	if player and global_position.distance_to(player.global_position) <= attack_range:
		if "take_damage" in player:
			player.take_damage(1)  # assumes player has a take_damage() function
