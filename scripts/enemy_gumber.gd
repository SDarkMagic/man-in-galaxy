class_name Gumber extends Enemy

@export var lateral_move_speed = 150.0

func move(vel: Vector2, delta: float) -> Vector2:
	vel.x = 0
	if is_dead == true:
		vel.y = -1 # Barely move up to cause collision with anything on the top to register on this entity
		return vel
	var player_position : Vector2 = $"../Player".global_position
	vel.x = lateral_move_speed
	if self.global_position.x - player_position.x > 0:
		vel.x *= -1
	return vel

func _physics_process(delta: float) -> void:
	# Do necessary AI calcs here for enemy
	velocity = self.apply_gravity(velocity, delta)
	velocity = move(velocity, delta)
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider().name
		if collider == "Player":
			EventController.emit_signal("damage_player", 1)
			
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D/AnimationPlayer.play("RESET")

func kill():
	is_dead = true
	$Sprite2D/AnimationPlayer.play("dead")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
