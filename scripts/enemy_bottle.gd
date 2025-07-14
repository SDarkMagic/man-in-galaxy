class_name Bottle extends Enemy

@export var projectile_speed = 150.0
@export var fire_interval : float = 2.5
@export var raycast_segments : int = 100
@export var beam_lifetime : float = 1.5
@export var beam_scene : PackedScene
var look_dir : Vector2 = Vector2.LEFT
var can_shoot : bool = true
var active_beams : Array = []

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
	for beam in active_beams:
		for raycast in beam.get_children():
			if raycast.is_colliding():
				EventController.emit_signal("damage_player", 1)
				break

func kill():
	is_dead = true
	$Sprite2D/AnimationPlayer.play("dead")

func clear_beams() -> void:
	for beam in active_beams:
		if beam != null:
			active_beams.pop_at(active_beams.find(beam))
			beam.queue_free()

func _ready() -> void:
	$FireCooldown.wait_time = fire_interval
	EventController.connect("clear_projectiles", clear_beams)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_dead:
		return
	if not can_shoot:
		return
	$FireCooldown.start()
	can_shoot = false
	await _calc_attack_path()
	

func _calc_attack_path() -> void:
	var start_pos : Vector2 = $FluidOutlet.global_position
	var target_pos : Vector2 = $"../Player".global_position
	var distance_x : float = target_pos.x - start_pos.x
	var current_pos_x : float = 0.0
	var current_pos_y : float = 0.0
	var current_segment : int = 1
	var visual_line : Line2D = _create_beam(start_pos)
	while current_segment <= raycast_segments:
		var current_target_x : float = (distance_x / raycast_segments) * current_segment
		var current_target_y : float = (2 / (abs(0.0) + abs(distance_x))) * (current_target_x - 0.0) * (current_target_x - distance_x)
		var current_target : Vector2 = Vector2(current_target_x, current_target_y)
		visual_line.add_point(current_target)
		var current_raycast : RayCast2D = _create_raycast_for_beam(Vector2(current_pos_x, current_pos_y), current_target, visual_line)
		current_raycast.force_raycast_update()
		if current_raycast.is_colliding():
			EventController.emit_signal("damage_player", 1)
		current_pos_x = current_target_x
		current_pos_y = current_target_y
		current_segment += 1
	active_beams.append(visual_line)
	await GameManager.wait(beam_lifetime)
	active_beams.pop_at(active_beams.find(visual_line))
	if visual_line != null:
		visual_line.queue_free()
		#await get_tree().process_frame

func _create_raycast_for_beam(start_pos : Vector2, target_pos : Vector2, line : Line2D) -> RayCast2D:
	var raycast : RayCast2D = RayCast2D.new()
	raycast.set_collision_mask_value(1, true)
	line.add_child(raycast)
	raycast.position = start_pos
	raycast.target_position = target_pos - start_pos # Convert target to position to be relative to the start position
	return raycast

func _create_beam(start_pos: Vector2) -> Line2D:
	var line = beam_scene.instantiate()
	line.global_position = start_pos
	get_tree().root.add_child(line)
	return line

func _on_fire_cooldown_timeout() -> void:
	can_shoot = true
