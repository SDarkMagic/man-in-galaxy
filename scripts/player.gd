class_name Player extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_FORCE : float = 3.0 
@export var mass  = 1.0
const PLAYER_TOTAL_HEALTH : int = 3
var player_current_health : int = PLAYER_TOTAL_HEALTH

func _ready() -> void:
	EventController.connect("damage_player", on_event_player_damaged)

func _physics_process(delta: float) -> void:
	# Add the gravity, capping at a terminal velocity
	if not is_on_floor():
		velocity.y += (mass * get_gravity().y) * delta
		var player_width = get_node("CollisionShape2D").shape.size.x
		var terminal_velocity : float = sqrt((2 * mass * get_gravity().y) / (1 * 0.0001 * player_width))
		if velocity.y > terminal_velocity:
			velocity.y = terminal_velocity
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += -1 * (JUMP_FORCE * mass * get_gravity().y) * delta

	# Get the input direction and handle the movement/deceleration.
	var direction_x = Input.get_axis("move_left", "move_right")
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func on_event_player_damaged(damage: int):
	player_current_health -= damage
	EventController.emit_signal("player_health_updated", player_current_health)
	if (player_current_health <= 0):
		#get_tree().reload_current_scene()
		pass # Kill player, trigger game over
