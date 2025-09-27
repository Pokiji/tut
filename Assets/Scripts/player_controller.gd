extends CharacterBody2D
class_name PlayerController

signal health_changed(current: int, max: int)

@export var speed: float = 10.0
@export var jump_power: float = 10.0

@export var max_health: int = 100
var current_health: int = max_health

var speed_multiplier: float = 30.0
var jump_multiplier: float = -30.0
var direction: float = 0.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	current_health = max_health
	emit_signal("health_changed", current_health, max_health) # initialize health bar

func take_damage(amount: int) -> void:
	current_health = max(current_health - amount, 0)
	emit_signal("health_changed", current_health, max_health)

func heal(amount: int) -> void:
	current_health = min(current_health + amount, max_health)
	emit_signal("health_changed", current_health, max_health)

func _input(event: InputEvent) -> void:
	# Handle jump
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_power * jump_multiplier
	# Handle jump down
	if event.is_action_pressed("move_down"):
		set_collision_mask_value(10, false)
	else:
		set_collision_mask_value(10, true)

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Movement
	direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * speed * speed_multiplier
	else:           
		velocity.x = move_toward(velocity.x, 0, speed * speed_multiplier)

	move_and_slide()
