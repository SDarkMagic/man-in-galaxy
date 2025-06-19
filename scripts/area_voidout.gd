extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		EventController.emit_signal("game_over", "voidout")
		# Kill player, trigger gameover
		pass
