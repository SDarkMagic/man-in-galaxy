class_name Budge extends Enemy

@export var lateral_move_speed = 150.0

func move(vel: Vector2, delta: float) -> Vector2:
	var player_position : Vector2 = $"../Player".global_position
	vel.x = lateral_move_speed
	if self.global_position.x - player_position.x > 0:
		vel.x *= -1
	return vel

func _physics_process(delta: float) -> void:
	# Do necessary AI calcs here for enemy
	velocity = self.apply_gravity(velocity, delta)
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

func kill():
	is_dead = true
	$Sprite2D/AnimationPlayer.play("dead")
	#self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
