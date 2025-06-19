extends AnimatableBody2D

@export var move_speed : float = 20.0
@export var left_travel_max : float = 0.0
@export var right_travel_max : float = 0.0
@export var top_travel_max : float = 0.0
@export var bottom_travel_max : float = 0.0
var origin : Vector2
var velocity : Vector2 = Vector2(0.0, 0.0)
var vertical_move_dir : Vector2 = Vector2.ZERO
var horizontal_move_dir : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	origin = position
	if left_travel_max > 0.0:
		horizontal_move_dir = Vector2.LEFT
	elif right_travel_max > 0.0:
		horizontal_move_dir = Vector2.RIGHT
	
	if top_travel_max > 0.0:
		vertical_move_dir = Vector2.UP
	elif bottom_travel_max > 0.0:
		vertical_move_dir = Vector2.DOWN
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if vertical_move_dir != Vector2.ZERO:
		# Handle vertical movement
		velocity.y = move_speed
		if vertical_move_dir == Vector2.UP and position.y <= origin.y - top_travel_max:
			vertical_move_dir = Vector2.DOWN
		elif vertical_move_dir == Vector2.DOWN and position.y >= origin.y + bottom_travel_max:
			vertical_move_dir = Vector2.UP
	if horizontal_move_dir != Vector2.ZERO:
		# Handle horizontal movement
		velocity.x = move_speed
		if horizontal_move_dir == Vector2.LEFT and position.x <= origin.x - left_travel_max:
			horizontal_move_dir = Vector2.RIGHT
		elif horizontal_move_dir == Vector2.RIGHT and position.x >= origin.x + right_travel_max:
			horizontal_move_dir = Vector2.LEFT
		pass
	velocity = velocity * (horizontal_move_dir + vertical_move_dir)
	position += velocity * delta
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
