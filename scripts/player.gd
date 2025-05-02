class_name Player extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_HEIGHT_MULTIPLIER : float = 1.0 
@export var mass  = 90.7
const PLAYER_TOTAL_HEALTH : int = 3
var player_current_health : int = PLAYER_TOTAL_HEALTH

func animate_player():
	var animator = $Sprite2D/PlayerAnimation
	var player_direction_x : String = "_left" if velocity.x < 0 else "_right"
	var movement_type : String = "walk" if is_on_floor() else "jump"
	if is_on_floor() && velocity.x == 0:
		movement_type = ""
		player_direction_x = "idle"
	animator.play(movement_type + player_direction_x)

func handle_input(delta: float):
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		var weight : float = mass * get_gravity().y
		var desired_height : float = ($CollisionShape2D.shape.size.y * JUMP_HEIGHT_MULTIPLIER) # Calculate desired jump height based off of the player collider's height
		print(desired_height) 
		print(delta)
		print(weight)
		velocity.y += -1 * (desired_height * weight) * delta

	# Get the input direction and handle the movement/deceleration.
	var direction_x = Input.get_axis("move_left", "move_right")
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _ready() -> void:
	EventController.connect("damage_player", on_event_player_damaged)
	$Sprite2D/PlayerAnimation.play("idle")

func _physics_process(delta: float) -> void:
	# Add the gravity, capping at a terminal velocity
	if not is_on_floor():
		velocity.y += (mass * get_gravity().y) * delta
		var player_width = $CollisionShape2D.shape.size.x
		var terminal_velocity : float = sqrt((2 * mass * get_gravity().y) / (1 * 0.0001 * player_width))
		if velocity.y > terminal_velocity:
			velocity.y = terminal_velocity
	#print(velocity.y)
	#print(position.y)
	#handle_input(delta)
	move_and_slide()
	
func _process(delta: float) -> void:
	handle_input(delta)
	animate_player()
	
func on_event_player_damaged(damage: int):
	player_current_health -= damage
	EventController.emit_signal("player_health_updated", player_current_health)
	if (player_current_health <= 0):
		get_tree().reload_current_scene()
		pass # Kill player, trigger game over
