class_name Maam extends Enemy

@export var move_speed : float = 150.0
@export var bounding_width : float = 2000.0
@export var bounding_height : float = 1500.0
@onready var start_pos : Vector2 = $".".global_position
@onready var bounding_bottom_right_corner : Vector2 = start_pos + Vector2(bounding_width, bounding_height)
@onready var dir_x : Vector2 = Vector2.RIGHT
@onready var dir_y : Vector2 = Vector2.DOWN

func move(vel: Vector2, delta: float) -> Vector2:
	var current_pos : Vector2 = $".".global_position
	
	if current_pos.x <= start_pos.x:
		dir_x = Vector2.RIGHT
	elif current_pos.x + $CollisionShape2D.shape.size.x >= bounding_bottom_right_corner.x:
		dir_x = Vector2.LEFT
		
	if current_pos.y <= start_pos.y:
		dir_y = Vector2.DOWN
	elif current_pos.y + $CollisionShape2D.shape.size.y >= bounding_bottom_right_corner.y:
		dir_y = Vector2.UP
		
	vel = (move_speed * dir_x) + (move_speed * dir_y)
	return vel

func _physics_process(delta: float) -> void:
	# Do necessary AI calcs here for enemy
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
