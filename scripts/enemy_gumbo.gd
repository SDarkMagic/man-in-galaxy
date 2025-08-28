class_name Gumbo extends Enemy

@export var lateral_move_speed = 150.0
@export var projectile_scene : PackedScene
@export var projectile_speed : float = 150.0
@export var fire_interval : float = 2.3
var move_direction = Vector2.LEFT
var can_shoot : bool = true
var paused : bool = true

func move(vel: Vector2, delta: float) -> Vector2:
	vel.x = 0
	return vel

func animate() -> void:
	var dir : String
	if move_direction == Vector2.RIGHT:
		dir = "right"
	else:
		dir = "left"
	$Sprite2D/AnimationPlayer.play("move_" + dir)

func _physics_process(delta: float) -> void:
	# Do necessary AI calcs here for enemy
	if is_dead:
		return
	velocity = self.apply_gravity(velocity, delta)
	velocity = move(velocity, delta)
	move_and_slide()

func _instantiate_projectile() -> Node2D:
	var projectile = projectile_scene.instantiate()
	projectile.max_speed = projectile_speed
	projectile.position = $FireOutlet.global_position
	projectile.team = "enemy"
	get_tree().root.add_child(projectile)
	return projectile
			
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_audio_player(false)
	$Sprite2D/AnimationPlayer.play("RESET")
	$ProjectileCooldown.wait_time = fire_interval

func kill():
	is_dead = true
	GameManager.disable_input()
	await play_death_sound()
	$Sprite2D/AnimationPlayer.play("dead")
	$Explosion.explode()
	await GameManager.wait($Sprite2D/AnimationPlayer.get_animation("dead").length + 1)
	EventController.emit_signal("gumbo_down")
	GameManager.enable_input()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_dead:
		return
	if not can_shoot or paused:
		return
	$ProjectileCooldown.start()
	var projectile : Projectile = _instantiate_projectile()
	var player_position : Vector2 = $"../Player".global_position
	player_position.y -= 60 # Aim slightly above player position since the position originates at the base of the player
	var fire_pos : Vector2 = $FireOutlet.global_position
	var direction = (player_position - fire_pos).normalized()
	projectile.fire(direction)
	var desired_rotation = fire_pos.angle_to_point(player_position)
	projectile.rotation = desired_rotation
	can_shoot = false


func _on_projectile_cooldown_timeout() -> void:
	can_shoot = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.context_action_active:
			return
		$Area2D.set_deferred("monitoring", false)
		$Area2D.hide()
		kill()
