extends Node2D

@export var target_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not Player:
		return
	GameManager.disable_input()
	body.hide()
	$Node2D/Sprite2D/AnimationPlayer.play("launch")
	await GameManager.wait($Node2D/Sprite2D/AnimationPlayer.get_animation("launch").get_length() + 0.5)
	GameManager.load_scene(target_scene)
	GameManager.enable_input()
	pass # Replace with function body.
