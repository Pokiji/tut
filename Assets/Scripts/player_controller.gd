extends CharacterBody2D
class_name PlayerController

signal health_changed(current: int, max: int)
signal player_died

@export var speed: float = 10.0
@export var jump_power: float = 10.0
@export var damage_multiplier: float = 1.0
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

	if current_health <= 0:
		die()

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
	# Handle sacrifice
	if event.is_action_pressed("sacrifice"):
		sacrifice()

func sacrifice() -> void:
	var health_cost = 20          # how much health to lose
	var damage_increase = 0.2     # increase 20% damage per press
	if current_health > health_cost:
		take_damage(health_cost)  # reduce your health
		damage_multiplier += damage_increase
		print("Damage increased! Current multiplier: ", damage_multiplier)
	else:
		print("Not enough health to sacrifice!")

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

func die() -> void:
	print("Player is dead")
	emit_signal("player_died")
	queue_free()
	get_tree().change_scene_to_file("res://Assets/Scenes/Menu Scenes/Died.tscn") # remove player from scene
