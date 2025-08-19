class_name Player extends CharacterBody2D

@export var SPEED = 300.0
@export var mass  = 90.7
@export var context_action_active : bool = false
@export var jump_time_to_peak : float = 0.1
@export var jump_time_to_descent : float = 0.1
@export var _jump_height : float = 125.0
@export var sound_names : Array[String]
const PLAYER_TOTAL_HEALTH : int = 3
var player_current_health : int = PLAYER_TOTAL_HEALTH
@onready var attacks_used : int = 0
@onready var look_direction = Vector2.RIGHT
@onready var need_uncrouch = false
@onready var _jump_time_to_peak : float = jump_time_to_peak * GameManager.DEFAULT_GRAVITY
@onready var _jump_time_to_descent : float = jump_time_to_descent * GameManager.DEFAULT_GRAVITY
var jump_velocity : float = 0.1
var jump_gravity : float = 0.1
var fall_gravity : float = GameManager.DEFAULT_GRAVITY
@onready var animator = $Lard/PlayerAnimation
var sounds : Dictionary = {}
var is_dead : bool = false


func _ready() -> void:
	is_dead = false
	for action in sound_names:
		var resource_path : String = "res://sound/{0}.wav".format([action])
		if not ResourceLoader.exists(resource_path):
			continue
		sounds[action] = load(resource_path)
		
	EventController.connect("damage_player", on_event_player_damaged)
	EventController.connect("level_start", _level_started_callback)
	$Lard/PlayerAnimation.play("RESET")
	$Helmet/HelmetAnimation.play("RESET")
	$".".hide()

func animate_player():
	if context_action_active == true:
		return
	var player_direction_x : String = "_left" if look_direction == Vector2.LEFT else "_right"
	var movement_type : String = "walk" if is_on_floor() else "jump"
	if is_on_floor() && velocity.x == 0:
		movement_type = "idle"
	var crouching = Input.is_action_pressed("crouch")
	if crouching:
		movement_type = "crouch"
		need_uncrouch = true
	elif need_uncrouch == true:
		$Helmet.position.x = -4.0
		$Helmet.position.y = -109.0
		$Helmet.rotation = 0.0
		$CollisionShape2D.disabled = false
		$CollisionShape2D_crouch.disabled = true
	animator.play(movement_type + player_direction_x)

func use_attack():
	if context_action_active:
		return
	context_action_active = true
	var helmet_anim_name : String
	if look_direction == Vector2.LEFT:
		$Lard/PlayerAnimation.play("attack_left")
	else:
		$Lard/PlayerAnimation.play("attack_right")
	attacks_used += 1
	EventController.emit_signal("attack_used", attacks_used)
	helmet_anim_name = "damage_" + str(attacks_used)
	if attacks_used >= GameManager.MAX_HELMET_HEALTH:
		helmet_anim_name = "broken"
		play_sound_on_helmet("helmet_shatter")
		EventController.emit_signal("damage_player", 3)
	$Helmet/HelmetAnimation.play(helmet_anim_name)
	
		
func jump():
	var jump_height = (_jump_height * GameManager.DEFAULT_GRAVITY) / get_gravity().y
	jump_velocity = ((2.0 * jump_height) / (_jump_time_to_peak / get_gravity().y)) * -1.0
	jump_gravity = ((-2.0 * jump_height) / (((_jump_time_to_peak / get_gravity().y) * (_jump_time_to_peak / get_gravity().y)))) * -1.0
	fall_gravity = ((-2.0 * jump_height) / (((_jump_time_to_descent / get_gravity().y) * (_jump_time_to_descent / get_gravity().y)))) * -1.0
	velocity.y = jump_velocity

func get_grav_y() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func handle_input(delta: float):
	if GameManager.allow_input == false:
		velocity.x = 0
		return
		
	if Input.is_action_just_pressed("attack"):
		use_attack()
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		play_sound_on_player("player_jump")
		jump()

	# Get the input direction and handle the movement/deceleration.
	var direction_x = Input.get_axis("move_left", "move_right")
	if direction_x < 0:
		look_direction = Vector2.LEFT
	elif direction_x > 0:
		look_direction = Vector2.RIGHT
	else:
		pass # Do nothing if direction_x isn't changing
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


func _physics_process(delta: float) -> void:
	# Add the gravity, capping at a terminal velocity
	var gravity : float = get_grav_y()
	if not is_on_floor():
		velocity.y += (gravity) * delta
		var player_width = $CollisionShape2D.shape.size.x
		var terminal_velocity : float = sqrt((2 * mass * gravity) / (1 * 0.0001 * player_width))
		if velocity.y > terminal_velocity:
			velocity.y = terminal_velocity
	handle_input(delta)
	move_and_slide()
	
func _process(delta: float) -> void:
	#handle_input(delta)
	animate_player()
	
func on_event_player_damaged(damage: int):
	var death_source : String
	player_current_health -= damage
	EventController.emit_signal("player_health_updated", player_current_health)
	if (player_current_health <= 0) and is_dead == false:
		is_dead = true
		death_source = "enemy"
		if attacks_used >= GameManager.MAX_HELMET_HEALTH:
			death_source = "helmet"
		EventController.emit_signal("game_over", death_source)
		var animation: String = "dead_helmet" if death_source == "helmet" else "dead"
		play_sound_on_player("player_" + animation)
		animator.play(animation)
		pass # Kill player, trigger game over

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Enemy and body is not Gumbo:
		body.kill()
		play_sound_on_helmet("helmet_hit")
	
func _on_hitbox_area_entered(area: Area2D) -> void:
	var entity = area.get_parent()
	if entity is Projectile:
		entity.team = "player"
		entity.velocity *= -1
		entity.rotation_degrees += 180
		play_sound_on_helmet("helmet_hit")
	return

func _level_started_callback(start_position: Vector2) -> void:
	global_position = start_position
	$".".show()
	return


func _on_step_taken() -> void:
	var collider : CollisionShape2D
	var tile_map : TileMapLayer = $"../TileMapLayer"
	var tile_material : String
	if not $".".is_on_floor():
		return
	var rid = get_rid()
	var player_tile_pos : Vector2i = tile_map.local_to_map(position)
	var ground_tile : TileData = tile_map.get_cell_tile_data(player_tile_pos)
	if ground_tile == null:
		return
	if ground_tile.get_custom_data("is_metal"):
		tile_material = "metal"
	else:
		tile_material = "grass"
	var step_sound : String = "player_step_" + tile_material
	if step_sound not in sounds.keys():
		print("step sound: {0} does not exist in keys".format([step_sound]))
		return
	play_sound_on_player(step_sound)
	pass # Replace with function body.


# Audio stuff
func play_sound_on_player(action: String) -> void:
	var audio_player : AudioStreamPlayer2D = $Lard/AudioStreamPlayer2D
	if action not in sounds.keys():
		push_error("Specified action was not found for the given identifier while trying to play audio: " + action)
		return
	if sounds[action] == null:
		return
	if audio_player.playing:
		audio_player.stop()
	audio_player.stream = sounds[action]
	audio_player.play()
	return
	
func play_sound_on_helmet(sound: String) -> void:
	var audio_player : AudioStreamPlayer2D = $Helmet/AudioStreamPlayer2D
	if sound not in sounds.keys():
		push_error("Specified action was not found for the given identifier while trying to play audio: " + sound)
		return
	if sounds[sound] == null:
		return
	if audio_player.playing:
		audio_player.stop()
	audio_player.stream = sounds[sound]
	audio_player.play()
	return
