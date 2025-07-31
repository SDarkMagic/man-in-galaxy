extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_to_lvl_3_2_body_entered(body: Node2D) -> void:
	if body is not Player:
		return
	var scene = preload("res://scenes/lvl_3-2.tscn")
	GameManager.load_scene(scene)
	pass # Replace with function body.
