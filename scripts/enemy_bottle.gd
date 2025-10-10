class_name Bottle extends Enemy

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
	await play_death_sound()
	clear_beams()
	queue_free()

func clear_beams() -> void:
	for beam in active_beams:
		if beam != null:
			active_beams.pop_at(active_beams.find(beam))
			beam.queue_free()

func _ready() -> void:
	_init_audio_player()
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
	var segment_delta : Vector2 = target_pos - start_pos
	var segment_slope : float = segment_delta.y / segment_delta.x
	var vertex_scalar : float = 1.0 + segment_delta.normalized().dot(Vector2.UP)
	var distance_x : float = segment_delta.x
	
	var visual_line : Line2D = _create_beam(start_pos)
	
	# Initialize loop variables
	var current_pos_x : float = 0.0
	var current_pos_y : float = 0.0
	var current_segment : int = 1
	var current_target_x : float
	var current_target_y : float
	var current_target : Vector2
	var current_raycast : RayCast2D
	var ray_distance_y : float
	var ray_distance_x : float
	var current_ray_distance : float
	active_beams.append(visual_line)
	while current_segment <= raycast_segments:
		current_target_x = (distance_x / raycast_segments) * current_segment
		current_target_y = (2 * vertex_scalar / (abs(0.0) + abs(distance_x))) * (current_target_x - 0.0) * (current_target_x - distance_x) + (current_target_x * segment_slope)
		current_target = Vector2(current_target_x, current_target_y)
		visual_line.add_point(current_target)
		current_raycast = _create_raycast_for_beam(Vector2(current_pos_x, current_pos_y), current_target, visual_line)
		ray_distance_y = current_target_y - current_pos_y
		ray_distance_x = current_target_x - current_pos_x
		current_ray_distance = sqrt(abs((ray_distance_y * ray_distance_y) + (ray_distance_x * ray_distance_x)))
		current_raycast.force_raycast_update()
		if current_raycast.is_colliding():
			EventController.emit_signal("damage_player", 1)
		current_pos_x = current_target_x
		current_pos_y = current_target_y
		current_segment += 1
		await GameManager.wait(0.0003 * current_ray_distance)
	await GameManager.wait(beam_lifetime)
	# Ensure the beam wasn't deleted by something else during it's lifetime before deleting it
	var beam_index = active_beams.find(visual_line)
	if beam_index != -1:
		active_beams.pop_at(beam_index)
	if visual_line != null:
		visual_line.queue_free()

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
	line.add_point(Vector2(0,0))
	get_tree().root.add_child(line)
	return line

func _on_fire_cooldown_timeout() -> void:
	can_shoot = true
