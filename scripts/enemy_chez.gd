class_name Chez extends Enemy

@export var projectile_speed = 150.0
@export var fire_interval : float = 2.5
@export var projectile_scene : PackedScene
var look_dir : Vector2 = Vector2.LEFT
var can_shoot : bool = true

func move(vel: Vector2, delta: float) -> Vector2:
	var player_position : Vector2 = $"../Player".global_position
	if self.global_position.x - player_position.x > 0:
		look_dir = Vector2.LEFT
	else:
		look_dir = Vector2.RIGHT
	return vel

func _physics_process(delta: float) -> void:
	# Do necessary AI calcs here for enemy
	var animator = $Sprite2D/AnimationPlayer
	velocity = self.apply_gravity(velocity, delta)
	if is_dead:
		move_and_slide()
		return
	velocity = move(velocity, delta)
	if look_dir == Vector2.LEFT:
		animator.play("left")
	elif look_dir == Vector2.RIGHT:
		animator.play("right")
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

func _ready() -> void:
	$ProjectileCooldown.wait_time = fire_interval

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_dead:
		return
	if not can_shoot:
		return
	$ProjectileCooldown.start()
	var projectile : Projectile = _instantiate_projectile()
	projectile.fire(look_dir)
	can_shoot = false

func _instantiate_projectile() -> Node2D:
	var projectile = projectile_scene.instantiate()
	projectile.max_speed = projectile_speed
	projectile.position = $PizzaSpitter.global_position
	projectile.team = "enemy"
	get_tree().root.add_child(projectile)
	return projectile


func _on_projectile_cooldown_timeout() -> void:
	can_shoot = true
