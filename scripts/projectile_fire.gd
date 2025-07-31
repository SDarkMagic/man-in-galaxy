class_name Fire extends Projectile

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventController.connect("clear_projectiles", self.queue_free)
	$Sprite2D/AnimationPlayer.play("burn")

func _fire_static(direction: Vector2):
	velocity = max_speed * direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_lifetime_timeout() -> void:
	self.queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player && team == "enemy":
		EventController.emit_signal("damage_player", 1)
		self.queue_free()
	pass # Replace with function body.
