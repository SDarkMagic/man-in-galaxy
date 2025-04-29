class_name Octo extends CharacterBody2D

func _physics_process(delta: float) -> void:
	# Add the gravity, capping at a terminal velocity
	#if not is_on_floor():
		#velocity.y += (mass * get_gravity().y) * delta
		#var player_width = get_node("CollisionShape2D").shape.size.x
		#var terminal_velocity : float = sqrt((2 * mass * get_gravity().y) / (1 * 0.0001 * player_width))
		#if velocity.y > terminal_velocity:
			#velocity.y = terminal_velocity
	# Do necessary AI calcs here for enemy
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider().name
		print(collider)
		if collider == "Player":
			EventController.emit_signal("damage_player", 1)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
