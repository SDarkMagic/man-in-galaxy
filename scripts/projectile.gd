class_name Projectile extends RigidBody2D

@export var max_speed = 500
@export var should_accelerate = false

func _fire_static(direction: Vector2, force_offset: Vector2):
	add_constant_force(max_speed * direction, force_offset)

func fire(direction: Vector2, force_offset: Vector2 = Vector2(0, 0)):
	if should_accelerate:
		pass
	else:
		self._fire_static(direction, force_offset)

func move(delta: float) -> void:
	pass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
