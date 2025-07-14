class_name Player extends CharacterBody2D

@export var SPEED = 300.0
@export var mass  = 90.7
@export var max_helmet_health : int = 7
@export var context_action_active : bool = false
@export var jump_time_to_peak : float = 0.1
@export var jump_time_to_descent : float = 0.1
@export var _jump_height : float = 125.0
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

func _ready() -> void:
	EventController.connect("damage_player", on_event_player_damaged)
	$Lard/PlayerAnimation.play("RESET")
	$Helmet/HelmetAnimation.play("RESET")

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
	helmet_anim_name = "damage_" + str(attacks_used)
	if attacks_used >= max_helmet_health:
		helmet_anim_name = "broken"
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
	if (player_current_health <= 0):
		death_source = "enemy"
		if attacks_used >= max_helmet_health:
			death_source = "helmet"
		EventController.emit_signal("game_over", death_source)
		var animation: String = "dead_helmet" if death_source == "helmet" else "dead"
		animator.play(animation)
		pass # Kill player, trigger game over

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.kill()
	
	pass # Replace with function body.

func _on_hitbox_area_entered(area: Area2D) -> void:
	var entity = area.get_parent()
	if entity is Projectile:
		entity.team = "player"
		entity.velocity *= -1
	return
