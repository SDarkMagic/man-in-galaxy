extends "res://scripts/level_manager.gd"


func _on_to_lvl_3_2_body_entered(body: Node2D) -> void:
	if body is not Player:
		return
	var scene = preload("res://scenes/lvl_3-2.tscn")
	GameManager.load_scene(scene)
