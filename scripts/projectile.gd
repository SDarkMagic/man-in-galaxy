class_name Projectile extends Node2D

@export var max_speed = 500
@export var should_accelerate = false
var team : String = "enemy"
var velocity : Vector2

func _fire_static(direction: Vector2):
	velocity = max_speed * direction

func fire(direction: Vector2, force_offset: Vector2 = Vector2(0, 0)):
	if should_accelerate:
		pass
	else:
		self._fire_static(direction)

func move(delta: float) -> void:
	pass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	position += velocity * delta
