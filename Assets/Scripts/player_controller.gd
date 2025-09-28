extends CharacterBody2D
class_name PlayerController

signal health_changed(current: int, max: int)
signal player_died
signal attacked 

@export var speed: float = 10.0
@export var jump_power: float = 10.0
@export var damage_multiplier: float = 1.0
@export var max_health: int = 100
@export var attack_range: float = 32.0   # how far the attack reaches
@export var attack_damage: int = 10      # base attack damage
@export var attack_cooldown: float = 0.5 # seconds between attacks

var current_health: int = max_health
var speed_multiplier: float = 30.0
var jump_multiplier: float = -30.0
var direction: float = 0.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_attack: bool = true

func _ready() -> void:
	current_health = max_health
	emit_signal("health_changed", current_health, max_health)

	# Ensure Timer exists
	if not has_node("Timer"):
		var t = Timer.new()
		t.name = "Timer"
		t.wait_time = attack_cooldown
		t.one_shot = true
		t.connect("timeout", Callable(self, "_on_Timer_timeout"))
		add_child(t)

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

	# Handle attack
	if event.is_action_pressed("click"):
		print("attack")
		attack()

	# Handle jump down
	if event.is_action_pressed("move_down"):
		set_collision_mask_value(10, false)
	else:
		set_collision_mask_value(10, true)

	# Handle sacrifice
	if event.is_action_pressed("sacrifice"):
		sacrifice()

func attack() -> void:
	if not can_attack:
		return

	can_attack = false
	$Timer.start()

	# Emit attacked signal so Animator knows
	emit_signal("attacked")

	# Area query for enemies
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	var shape = CircleShape2D.new()
	shape.radius = attack_range
	query.shape = shape
	query.transform = Transform2D(0, global_position)
	query.collision_mask = 1 << 2  # only hits enemies if they are on layer 2

	var results = space_state.intersect_shape(query)

	for result in results:
		var enemy = result.collider
		if enemy and enemy.has_method("take_damage"):
			var total_damage = int(attack_damage * damage_multiplier)
			enemy.take_damage(total_damage)


func _on_Timer_timeout() -> void:
	can_attack = true

func sacrifice() -> void:
	var health_cost = 20
	var damage_increase = 0.2
	if current_health > health_cost:
		take_damage(health_cost)
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
	get_tree().change_scene_to_file("res://Assets/Scenes/Menu Scenes/Died.tscn")
