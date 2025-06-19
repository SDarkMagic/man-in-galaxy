class_name Bugger extends Enemy

@export var lateral_move_speed = 150.0
var move_direction = Vector2.LEFT

func move(vel: Vector2, delta: float) -> Vector2:
	vel.x = 0
	if is_dead == true:
		vel.y = -0.01 # Barely move up to cause collision with anything on the top to register on this entity
		return vel
	var player_position : Vector2 = $"../Player".global_position
	vel.x = lateral_move_speed
	if self.global_position.x - player_position.x > 0:
		move_direction = Vector2.LEFT
	else:
		move_direction = Vector2.RIGHT
				
	vel.x *= move_direction.x
	return vel

func animate() -> void:
	var dir : String
	if move_direction == Vector2.RIGHT:
		dir = "right"
	else:
		dir = "left"
	$Sprite2D/AnimationPlayer.play(dir)

func _physics_process(delta: float) -> void:
	# Do necessary AI calcs here for enemy
	if $RayCast2D.is_colliding():
		velocity = self.apply_gravity(velocity, delta)
	else:
		velocity.y = 0
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
	if not is_dead:
		animate()
