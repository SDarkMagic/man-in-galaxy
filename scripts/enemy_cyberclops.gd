class_name CyberClops extends Enemy

@export var lateral_move_speed = -500.0

func move(vel: Vector2, delta: float) -> Vector2:
	vel.x = lateral_move_speed
	return vel

func _physics_process(delta: float) -> void:
	velocity = self.apply_gravity(velocity, delta)
	# Do necessary AI calcs here for enemy
	if is_dead:
		return
	velocity = move(velocity, delta)
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_normal().x >= 0.8:
			self.kill()
			return
		var collider = collision.get_collider().name
		if collider == "Player":
			EventController.emit_signal("damage_player", 1)
			

func kill():
	# Explode
	is_dead = true
	$Sprite2D/AnimationPlayer2.play("dead")
	play_sound_for_action("explode")
	await GameManager.wait(audio_files["explode"].get_length())
	queue_free()

func _ready() -> void:
	_init_audio_player()
	add_audio_action("explode")
	add_audio_action("drive")
	$DriveSoundTimer.wait_time = audio_files["drive"].get_length()
	play_sound_for_action("drive")
	$DriveSoundTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_explosion_body_entered(body: Node2D) -> void:
	if body is Player:
		EventController.emit_signal("damage_player", 2)


func _on_drive_sound_timer_timeout() -> void:
	if is_dead:
		return
	play_sound_for_action("drive")
