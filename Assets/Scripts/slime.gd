extends CharacterBody2D

@export var player: Node2D
@export var speed: float = 60.0
@export var patrol_speed: float = 40.0
@export var chase_range: float = 200.0
@export var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction: int = 1

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if player and global_position.distance_to(player.global_position) <= chase_range:
		direction = sign(player.global_position.x - global_position.x)
		velocity.x = direction * speed
	else:
		velocity.x = direction * patrol_speed

		if is_on_wall() or not $RayCast2D.is_colliding():
			direction *= -1
			$RayCast2D.position.x = abs($RayCast2D.position.x) * direction

	move_and_slide()
