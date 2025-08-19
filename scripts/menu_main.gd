extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func slide_in() -> void:
	$AnimationPlayer.play("slide_in")

func slide_out() -> void:
	$AnimationPlayer.play_backwards("slide_in")
