class_name Katrina extends Enemy

@export var lateral_move_speed = 150.0
@export var jump_time_to_peak : float = 0.1
@export var jump_time_to_descent : float = 0.1
@export var jump_height : float = 450.0
@onready var _jump_time_to_peak : float = jump_time_to_peak * GameManager.DEFAULT_GRAVITY
@onready var _jump_time_to_descent : float = jump_time_to_descent * GameManager.DEFAULT_GRAVITY
var jump_velocity : float = 0.1
var jump_gravity : float = GameManager.DEFAULT_GRAVITY
var fall_gravity : float = GameManager.DEFAULT_GRAVITY

func get_grav_y() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func move(vel: Vector2, delta: float) -> Vector2:
	var player_position : Vector2 = $"../Player".global_position
	if is_on_floor():
		jump_velocity = ((2.0 * jump_height) / (_jump_time_to_peak / get_gravity().y)) * -1.0
		jump_gravity = ((-2.0 * jump_height) / (((_jump_time_to_peak / get_gravity().y) * (_jump_time_to_peak / get_gravity().y)))) * -1.0
		fall_gravity = ((-2.0 * jump_height) / (((_jump_time_to_descent / get_gravity().y) * (_jump_time_to_descent / get_gravity().y)))) * -1.0
		vel.y = jump_velocity
		vel.x = lateral_move_speed
		if self.global_position.x - player_position.x > 0:
			vel.x *= -1
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
	velocity = apply_gravity(velocity, delta)
	if is_dead:
		move_and_slide()
		return
	velocity = move(velocity, delta)
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider().name
		if collider == "Player":
			EventController.emit_signal("damage_player", 1)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func kill():
	is_dead = true
	$Sprite2D/AnimationPlayer.play("dead")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
