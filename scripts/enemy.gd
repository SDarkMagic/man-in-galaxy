class_name Enemy extends CharacterBody2D

@export var mass : float = 50.0
@export var width : float = 20.0

func apply_gravity(vel: Vector2, delta: float) -> Vector2:
	# Add the gravity, capping at a terminal velocity
	if not is_on_floor():
		vel.y += (mass * get_gravity().y) * delta
		var terminal_velocity : float = sqrt((2 * mass * get_gravity().y) / (1 * 0.0001 * width))
		if vel.y > terminal_velocity:
			vel.y = terminal_velocity
	return vel	
			
func _physics_process(delta: float) -> void:
	# Add the gravity, capping at a terminal velocity
	if not is_on_floor():
		velocity.y += (mass * get_gravity().y) * delta
		var player_width = 20
		var terminal_velocity : float = sqrt((2 * mass * get_gravity().y) / (1 * 0.0001 * player_width))
		if velocity.y > terminal_velocity:
			velocity.y = terminal_velocity
	# Do necessary AI calcs here for enemy
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
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
