class_name CyberClops extends Enemy

@export var lateral_move_speed = -500.0

func move(vel: Vector2, delta: float) -> Vector2:
	vel.x = lateral_move_speed
	return vel

func _physics_process(delta: float) -> void:
	velocity = self.apply_gravity(velocity, delta)
	# Do necessary AI calcs here for enemy
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
	# Explode
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
