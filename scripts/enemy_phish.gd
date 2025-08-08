class_name Phish extends Enemy

@export var lateral_move_speed = 150.0
@export var left_travel_max : float = -100.0
@export var right_travel_max : float = 100.0
@onready var start_pos : Vector2 = $".".global_position
@onready var global_left_bound : float = start_pos.x + left_travel_max
@onready var global_right_bound : float = start_pos.x + right_travel_max
@onready var animator = $"Sprite2D/AnimationPlayer"
var jump_velocity : float = 0.1
var jump_gravity : float = GameManager.DEFAULT_GRAVITY
var fall_gravity : float = GameManager.DEFAULT_GRAVITY
var current_direction = Vector2.LEFT

func _ready() -> void:
	register_enemy_seen()

func get_grav_y() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func move(vel: Vector2, delta: float) -> Vector2:
	var current_pos : Vector2 = $".".global_position
	vel.x = lateral_move_speed
	#print("Left: ", global_left_bound, " Current: ", current_pos.x, " Right: ", global_right_bound)
	if current_pos.x <= global_left_bound && current_direction == Vector2.LEFT:
		current_direction = Vector2.RIGHT
		animator.play("right")
	if current_pos.x >= global_right_bound && current_direction == Vector2.RIGHT:
		current_direction = Vector2.LEFT
		animator.play("left")
	vel *= current_direction
	return vel

func apply_gravity(vel: Vector2, delta: float) -> Vector2:
	# Add the gravity, capping at a terminal velocity
	vel.y += get_grav_y() * delta
	var terminal_velocity : float = sqrt((2 * mass * get_grav_y()) / (1 * 0.0001 * width))
	if vel.y > terminal_velocity:
		vel.y = terminal_velocity
	return vel

func _physics_process(delta: float) -> void:
	# Do necessary AI calcs here for enemy
	#velocity = apply_gravity(velocity, delta)
	if is_dead:
		velocity = Vector2(0, 0)
		velocity.y = get_grav_y()
		move_and_slide()
		return
	velocity = move(velocity, delta)
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider().name
		if collider == "Player":
			EventController.emit_signal("damage_player", 1)

func kill():
	is_dead = true
	$Sprite2D/AnimationPlayer.play("dead")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
